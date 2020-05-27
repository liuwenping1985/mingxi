//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.form.modules.trigger;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.content.mainbody.MainbodyService;
import com.seeyon.ctp.common.po.content.CtpContentAll;
import com.seeyon.ctp.common.quartz.QuartzHolder;
import com.seeyon.ctp.common.quartz.QuartzJob;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormFieldBean;
import com.seeyon.ctp.form.bean.FormTriggerBean;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.form.util.FormUtil;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.ParamUtil;

import java.io.PrintStream;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class FormTriggerQuartzJob implements QuartzJob {
    private static final Logger LOGGER = Logger.getLogger(FormTriggerQuartzJob.class);
    private FormManager formManager;

    public FormTriggerQuartzJob() {
    }

    public void execute(Map<String, String> parameters) {
        int moduleType = ParamUtil.getInt(parameters, "MODULETYPE");
        long moduleId = ParamUtil.getLong(parameters, "MODULEID", 0L);
        long triggerBeanId = ParamUtil.getLong(parameters, "TRIGGERID", 0L);
        long formId = ParamUtil.getLong(parameters, "FORMID", 0L);
        long masterId = ParamUtil.getLong(parameters, "MASTERID", 0L);
        String subDataIds = (String)parameters.get("DateSubDataIds");

        System.out.println("moduleId="+moduleId);//这个就是实例
        System.out.println("formId="+formId);//这个代表是那个底表“工作督办单”
//        System.out.println("subDataIds="+subDataIds);

        try {
            FormUtil.removeThreadCalcCache();
            OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
            Long memberId = ParamUtil.getLong(parameters, "USERID", 0L);
            V3xOrgMember member = orgManager.getMemberById(memberId);
            V3xOrgAccount account = orgManager.getAccountById(member.getOrgAccountId());
            User user = new User();
            user.setId(member.getId());
            user.setAccountId(member.getOrgAccountId());
            user.setDepartmentId(member.getOrgDepartmentId());
            user.setLevelId(member.getOrgLevelId());
            user.setLoginAccount(member.getOrgAccountId());
            user.setLoginAccountName(account.getName());
            user.setLoginAccountShortName(account.getShortName());
            user.setPostId(member.getOrgPostId());
            user.setName(member.getName());
            user.setLoginName(member.getLoginName());
            AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
            CtpContentAll contentAll = (CtpContentAll)MainbodyService.getInstance().getContentList(ModuleType.getEnumByKey(moduleType), moduleId).get(0);
            FormBean formBean = this.formManager.getForm(formId);
            FormTriggerBean triggerBean = formBean.getFormTriggerBean(triggerBeanId);
            FormDataMasterBean masterBean = this.formManager.getDataMasterBeanById(masterId, formBean, (String[])null);
            if (masterBean == null) {
                QuartzHolder.deleteQuartzJobByGroupAndJobName(triggerBean.getId().toString(), (String)parameters.get("TRIGGER_PARAM_TRIGGER_JOB_NAME"));
                LOGGER.info("执行时间调度触发异常，需要执行触发的数据被删除！删除此任务调度");
                return;
            }

            Map<String, Object> map = new HashMap();
            map.put("MASTER", masterBean);
            map.put("CONTENTALL", contentAll);
            map.put("USERID", memberId);
            map.put("ISTIMEJOB", true);
            map.put("FORMBEAN", formBean);
            map.put("DateSubDataIds", subDataIds);
            if (triggerBean.isMatchCondition((List)null, masterBean)) {
                if (isDubanForm(formBean))
                {
                    if (isTimeOk(formBean,Long.valueOf(moduleId))) {
                        triggerBean.doit(map);
                    } else {
                        System.out.println("还没到日子");
                    }
                } else
                {
                    triggerBean.doit(map);
                }
            }
        } catch (Exception var22) {
            LOGGER.error("异步线程执行触发时间调度任务异常：", var22);
        }

    }

    public boolean isDubanForm(FormBean formBean)
    {
        String formName  = formBean.getFormName();
        String shotName = formBean.getShortName();
        System.out.println(formBean.getId());
        System.out.println(formName);
        System.out.println(shotName);
        if (formName.equals("工作督办单"))
        {
            return true;
        }
        return false;
    }
    public boolean isTimeOk(FormBean formBean,long formRecordId)
    {
        boolean isContinue = false;
        try {
            FormDataMasterBean data = FormService.findDataById(formRecordId, formBean.getId());
            //System.out.println("filed0008="+formBean.getFieldBeanByName("field0008").getFormatEnumLevel());
            //System.out.println("filed0008="+formBean.getFieldBeanByName("field0008").getDisplay());
            FormFieldBean fieldBean = formBean.getFieldBeanByDisplay("督办周期");
            Calendar calendar = Calendar.getInstance();
            int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1;//星期几
            int numWeekOfMonth = calendar.get(Calendar.DAY_OF_WEEK_IN_MONTH);//一个月第几周
            int dayOfMonth = calendar.get(Calendar.DAY_OF_MONTH);
            int month = calendar.get(Calendar.MONTH) + 1;//第几月

            String strValue = (String)fieldBean.getDisplayValue(data.getAllDataMap().get("field0008"))[1]; //这个能取出来
           // String strValue1 = (String)fieldBean.getDisplayValue(data.getAllDataMap().get("督办周期"))[1]; //这个的出来是“”
            System.out.println(strValue);
            LOGGER.info("strValue="+strValue);
            if (strValue.equals("周"))//周
            {
                if (dayOfWeek == 3)//提前两天，周五发送待办
                {
                    isContinue = true;
                }
            } else if (strValue.equals("双周"))//双周
            {
                if (dayOfWeek == 2 && (numWeekOfMonth == 2 || numWeekOfMonth == 4))//提前两天，周五发送待办
                {
                    isContinue = true;
                }
            } else if (strValue.equals("月"))//月每月1号
            {
                if (dayOfMonth == 25)//每月25号
                {
                    isContinue = true;
                }
            } else if (strValue.equals("季度"))//季度
            {
                if (dayOfMonth == 1 && (month == 4 || month == 7 || month == 10 || month == 1)) {
                    isContinue = true;
                }
            } else if (strValue.equals("半年度"))//半年
            {
                if (dayOfMonth == 1 && (month == 7 || month == 1)) {
                    isContinue = true;
                }
            } else if (strValue.equals("年度"))//年
            {
                if (dayOfMonth == 1 && month == 1) {
                    isContinue = true;
                }
            }
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }

        return isContinue;
    }

    public FormManager getFormManager() {
        return this.formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }
}
