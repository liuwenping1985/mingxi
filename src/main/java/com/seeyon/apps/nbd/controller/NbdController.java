package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.Formmain0635;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.apps.nbd.vo.CheckResult;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.login.LoginControlImpl;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
 */

public class NbdController extends BaseController {


    private LoginControlImpl loginControl;


    private LoginControlImpl getLoginControl(){
        if(loginControl == null){
            loginControl = (LoginControlImpl)AppContext.getBean("loginControl");
            if(loginControl == null){
                loginControl = (LoginControlImpl)AppContext.getBean("loginControlImpl");
            }
        }
        return loginControl;
    }
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
    public ModelAndView sso(HttpServletRequest request, HttpServletResponse response) {
//        String user_name = request.getParameter("user_name");
//
//        String password = request.getParameter("password");
//
//        String skey="oa";
//
//        Map ret = null;
//        try {
//            String url= ConfigService.getPropertyByName("lens_url","");
//            url = url+"?loginname="+user_name+"&spassword="+password+"skey="+skey;
//            ret = UIUtils.get(url);
//            String retStatus = String.valueOf(ret.get("result"));
//            if("1".equals(retStatus)){
//
//
//
//
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);
        CheckResult cr = validParameter(parameter,0);
        if (!cr.isResult()) {

            UIUtils.responseJSON(cr, response);

            return null;
        }
        Map retMap = new HashMap();
        Formmain0635 formmain0635 = new Formmain0635();

        try {
            String name = parameter.$("name");
            formmain0635.setField0001(name);
            String number = parameter.$("number");
            formmain0635.setField0002(number);
            String region = parameter.$("region");
            formmain0635.setField0003(region);
            String people = parameter.$("people");
            Long memberId = UIUtils.getMemberIdByCode(people);
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
            Long unitId = UIUtils.getDepartmentIdByCode(department);
            formmain0635.setField0005(String.valueOf(unitId));
            String startdate = parameter.$("startdate");
            formmain0635.setField0006(UIUtils.parseDateYearMonthDay(startdate));
            String enddate = parameter.$("enddate");
            formmain0635.setField0007(UIUtils.parseDateYearMonthDay(enddate));
            String state = parameter.$("state");
            String stateId = UIUtils.getEnumIdByState(state);
            formmain0635.setField0008(stateId);
            String remark = parameter.$("remark");
            formmain0635.setField0009(remark);
            String createdate = parameter.$("createdate");
            formmain0635.setField0010(UIUtils.parseDate(createdate));
            String updatedate = parameter.$("updatedate");
            formmain0635.setField0011(UIUtils.parseDate(updatedate));
            String address = parameter.$("address");
            formmain0635.setField0012(address);
            formmain0635.setIdIfNew();
            DBAgent.save(formmain0635);
        } catch (Exception e) {
            e.printStackTrace();
        }

        retMap.put("result", true);
        retMap.put("msg", "");
        retMap.put("data", JSON.toJSONString(parameter));

        //agent.execute("insert into formmain_0395");
        UIUtils.responseJSON(retMap, response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView update(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);
        CheckResult cr = validParameter(parameter,1);
        if (!cr.isResult()) {

            UIUtils.responseJSON(cr, response);

            return null;
        }
        Map retMap = new HashMap();
        String number = parameter.$("number");

        String sql ="from Formmain0635 where field0002='"+number+"'";
        List<Formmain0635> fmList = DBAgent.find(sql);
        if(CollectionUtils.isEmpty(fmList)){
            cr.setResult(false);
            cr.setData(parameter);
            cr.setMsg("通过项目编码无法找到数据");
            UIUtils.responseJSON(cr, response);

            return null;
        }
        Formmain0635 formmain0635 = fmList.get(0);
        try {
            String name = parameter.$("name");
            if(!StringUtils.isEmpty(name)){
                formmain0635.setField0001(name);
            }
            String region = parameter.$("region");
            if(!StringUtils.isEmpty(region)){
                formmain0635.setField0003(region);
            }
            String people = parameter.$("people");
            if(!StringUtils.isEmpty(people)){
                Long memberId = UIUtils.getMemberIdByCode(people);
                if(memberId==null){
                    cr.setResult(false);
                    cr.setMsg("更新时通过人员编码找不到对应人员");
                    cr.setData(parameter);
                    UIUtils.responseJSON(cr, response);
                    return null;
                }
                formmain0635.setField0004(String.valueOf(memberId));
            }
            String department = parameter.$("department");
            if(!StringUtils.isEmpty(department)){
                Long unitId = UIUtils.getDepartmentIdByCode(department);
                formmain0635.setField0005(String.valueOf(unitId));
            }
            String startdate = parameter.$("startdate");
            if(!StringUtils.isEmpty(startdate)){
                formmain0635.setField0006(UIUtils.parseDateYearMonthDay(startdate));
            }

            String enddate = parameter.$("enddate");
            if(!StringUtils.isEmpty(enddate)){
                formmain0635.setField0007(UIUtils.parseDateYearMonthDay(enddate));
            }

            String state = parameter.$("state");
            if(!StringUtils.isEmpty(state)){
                String stateId = UIUtils.getEnumIdByState(state);
                formmain0635.setField0008(stateId);
            }
            String remark = parameter.$("remark");
            if(!StringUtils.isEmpty(remark)){
                formmain0635.setField0009(remark);
            }


            String createdate = parameter.$("createdate");
            if(!StringUtils.isEmpty(remark)){
                formmain0635.setField0010(UIUtils.parseDate(createdate));
            }

            String updatedate = parameter.$("updatedate");
            if(!StringUtils.isEmpty(remark)){
                formmain0635.setField0011(UIUtils.parseDate(updatedate));
            }
            String address = parameter.$("address");
            if(!StringUtils.isEmpty(address)){
                formmain0635.setField0012(address);
            }
            DBAgent.update(formmain0635);
        } catch (Exception e) {
            e.printStackTrace();
        }

        retMap.put("result", true);
        retMap.put("msg", "");
        retMap.put("data", JSON.toJSONString(parameter));

        //agent.execute("insert into formmain_0395");
        UIUtils.responseJSON(retMap, response);
        return null;

    }
    @NeedlessCheckLogin
    public ModelAndView delete(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);
        CheckResult cr = validParameter(parameter,2);
        if (!cr.isResult()) {

            UIUtils.responseJSON(cr, response);

            return null;
        }
        String number = parameter.$("number");
        Map retMap = new HashMap();
       // Formmain0635 formmain0635 = new Formmain0635();
        String sql ="from Formmain0635 where field0002='"+number+"'";
        List<Formmain0635> fmList = DBAgent.find(sql);
        if(CollectionUtils.isEmpty(fmList)){
            cr.setResult(false);
            cr.setData(parameter);
            cr.setMsg("删除时通过项目编码无法找到数据");
            UIUtils.responseJSON(cr, response);

            return null;
        }
        Formmain0635 formmain0635 =fmList.get(0);
        try {
            DBAgent.delete(formmain0635);
        } catch (Exception e) {
            e.printStackTrace();
        }

        retMap.put("result", true);
        retMap.put("msg", "");
        retMap.put("data", JSON.toJSONString(parameter));

        //agent.execute("insert into formmain_0395");
        UIUtils.responseJSON(retMap, response);
        return null;

    }
    private OrgManager orgManager;

    private OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;

    }


    private CheckResult validParameter(CommonParameter parameter,int mode) {

        String name = parameter.$("name");
        CheckResult ret = new CheckResult();
        ret.setResult(true);
        String number = parameter.$("number");
        if (StringUtils.isEmpty(number)) {
            ret.setResult(false);
            ret.setMsg("项目编码不能为空");
            ret.setData(parameter);
            return ret;
        }
        //删除
        if(mode==2||mode==1){
            return ret;
        }
        if (StringUtils.isEmpty(name)) {

            ret.setResult(false);
            ret.setMsg("项目名称不能为空");
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

    public static void main(String []args){
        System.out.println("test1");
    }

}
