package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.Formmain0635;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.apps.nbd.vo.CheckResult;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
 */

public class NbdController extends BaseController {


    @NeedlessCheckLogin
    public ModelAndView selectTable(HttpServletRequest request, HttpServletResponse response) {


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView selectQueryTable(HttpServletRequest request, HttpServletResponse response) {


        return null;

    }


    @NeedlessCheckLogin
    public ModelAndView selectCommdityMall(HttpServletRequest request, HttpServletResponse response) {
        //com.seeyon.ctp.portal.sso.login.SSOTicketLoginAuthentication ghl;

        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);
        CheckResult cr = validParameter(parameter);
        if (!cr.isResult()) {

            UIUtils.responseJSON(cr, response);

            return null;
        }
        Map retMap = new HashMap();
        /**
         * "name":"朗斯卫浴项目",
         "number":"123456",
         "region":"143223",
         "people":"245634562",//存的id
         "department":"987534",//存的部门id
         " startdate ":"2018-08-22",
         " enddate ":"2018-09-22",
         " state ":"0",
         " remark ":"待商务待商务待商务待商务待商务待商务待商务",
         " createdate ":"2018-08-22 19:07:40",
         " updatedate ":"2018-08-22 19:07:40"
         */
        Formmain0635 formmain0635 = new Formmain0635();

        try {
            String name = parameter.$("name");
            formmain0635.setField0001(name);
            String number = parameter.$("number");
            formmain0635.setField0002(number);
            String region = parameter.$("region");
            formmain0635.setField0003(region);
            String people = parameter.$("people");
            Long memberId = getMemberIdByCode(people);
            if(memberId==null){
                cr.setResult(false);
                cr.setMsg("通过人员编码找不到对应人员");
                cr.setData(parameter);
                UIUtils.responseJSON(cr, response);
                return null;
            }
            formmain0635.setField0004(String.valueOf(memberId));
            formmain0635.setStartMemberId(formmain0635.getField0004());
            formmain0635.setModifyMemberId("0");
            formmain0635.setStartDate(new Date());
            formmain0635.setApproveDate(new Date());
            formmain0635.setState(0);
            formmain0635.setFinishedFlag(0);
            formmain0635.setApproveMemberId("0");
            formmain0635.setRatifyFlag(0);
            formmain0635.setRatifyMemberId("0");
            String department = parameter.$("department");
            Long unitId = getDepartmentIdByCode(department);
            formmain0635.setField0005(String.valueOf(unitId));
            String startdate = parameter.$("startdate");
            formmain0635.setField0006(UIUtils.parseDateYearMonthDay(startdate));
            String enddate = parameter.$("enddate");
            formmain0635.setField0007(UIUtils.parseDateYearMonthDay(enddate));
            String state = parameter.$("state");
            String stateId = getEnumIdByState(state);
            formmain0635.setField0008(stateId);
            String remark = parameter.$("remark");
            formmain0635.setField0009(remark);
            String createdate = parameter.$("createdate");
            formmain0635.setField0010(UIUtils.parseDate(createdate));
            String updatedate = parameter.$("updatedate");
            formmain0635.setField0011(UIUtils.parseDate(updatedate));
            formmain0635.setIdIfNew();
            DBAgent.save(formmain0635);
        } catch (Exception e) {
            e.printStackTrace();
        }

        retMap.put("result", true);
        retMap.put("msg", "");
        retMap.put("data", JSON.toJSONString(parameter));

        //agent.execute("insert into formmain_0395");


        UIUtils.responseJSON(parameter, response);
        return null;

    }

    private OrgManager orgManager;

    private OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;

    }


    private CheckResult validParameter(CommonParameter parameter) {

        String name = parameter.$("name");
        CheckResult ret = new CheckResult();
        ret.setResult(true);
        if (StringUtils.isEmpty(name)) {

            ret.setResult(false);
            ret.setMsg("项目名称不能为空");
            ret.setData(parameter);
            return ret;

        }
        String number = parameter.$("number");
        if (StringUtils.isEmpty(number)) {
            ret.setResult(false);
            ret.setMsg("项目编码不能为空");
            ret.setData(parameter);
            return ret;
        }
        String startdate = parameter.$("startdate");

        if (StringUtils.isEmpty(startdate)) {

            ret.setResult(false);
            ret.setMsg("开始时间不能为空");
            ret.setData(parameter);
            return ret;
        }

        Date ddt = UIUtils.parseDateYearMonthDay(startdate);

        if (ddt == null) {
            ret.setResult(false);
            ret.setMsg("开始时间格式不能为空");
            ret.setData(parameter);
            return ret;
        }

        return ret;


    }
    private Map<String,Long> cacheEnumMap = new HashMap<String, Long>();
    private String getEnumIdByState(String state){
       String enumId =  ConfigService.getPropertyByName("state_enum_id","");
      //  System.out.println("enumId:"+enumId);
       if(!StringUtils.isEmpty(enumId)){

           Long ret = cacheEnumMap.get(state);
           if(ret!=null){
               return String.valueOf(ret);
           }
            String sql = "select * from ctp_enum_item where ref_enumid="+enumId;
           System.out.println(sql);
            JDBCAgent jdbcAgent = new JDBCAgent();
            try {
                jdbcAgent.execute(sql);
                List<Map> dataList = jdbcAgent.resultSetToList();
                System.out.println(dataList);
                if(!CollectionUtils.isEmpty(dataList)){

                    for(Map data:dataList){
                        Long id = Long.parseLong(String.valueOf(data.get("id")));
                        cacheEnumMap.put(String.valueOf(data.get("showvalue")),id);
                    }
                    //System.out.println(cacheEnumMap);
                    //System.out.println(state);

                    ret = cacheEnumMap.get(state);
                    System.out.println(ret);
                    if(ret!=null){
                        return String.valueOf(ret);
                    }
                }

            }catch(Exception e){
                e.printStackTrace();
            }finally {
                jdbcAgent.close();
            }
       }

       return state;
    }
    private Long getMemberIdByCode(String code){


       return getIdByCodeAndType(code,"org_member");
    }
    private Long getDepartmentIdByCode(String code){

        return getIdByCodeAndType(code,"org_unit");
    }

    private Long getIdByCodeAndType(String code,String tableName){
        JDBCAgent jdbcAgent = new JDBCAgent();
        try {
            String sql ="select * from "+tableName+" where is_enable=1 and is_deleted=0 and code='"+code+"'";
            System.out.println(sql);
            jdbcAgent.execute(sql);

            List<Map> ret = jdbcAgent.resultSetToList();

            if(CollectionUtils.isEmpty(ret)){
                return null;
            }
            Object id =   ret.get(0).get("id");
            if(id instanceof  Long){
                return (Long)id;
            }
            if(id instanceof BigDecimal){
                return ((BigDecimal)id).longValue();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            jdbcAgent.close();
        }
        return null;

    }


}
