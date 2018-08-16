package com.seeyon.apps.xinjue.controller;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.service.XingjueService;
import com.seeyon.apps.xinjue.util.UIUtils;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class XingjueController extends BaseController {

    private XingjueService svc;

    public XingjueService getSvc() {
        if(svc == null){
            svc = new XingjueService();
        }
        return svc;
    }
    @NeedlessCheckLogin
    public ModelAndView syncDataSave(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("type");
        Map ret  = new HashMap();
        EnumParameterType p_type = EnumParameterType.ORG;
        if("org".equals(type)){
            p_type = EnumParameterType.ORG;
        }else if("bill".equals(type)){
            p_type = EnumParameterType.BILL;
        } else if("commodity".equals(type)){
            p_type = EnumParameterType.COMMODITY;
        }else if("custom".equals(type)){
            p_type = EnumParameterType.CUSTOM;
        }else if("warehouse".equals(type)){
            p_type = EnumParameterType.WAREHOUSE;
        }
        try {
            List list = this.getSvc().getData(p_type);
            DBAgent.saveAll(list);
            ret.put("data",list);
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("data","error");
        }

        UIUtils.responseJSON(ret,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView getSyncData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("type");
        Map ret  = new HashMap();
        String p_type = "from Formmain1464";
        if("org".equals(type)){
            p_type = "from Formmain1468";
        }else if("bill".equals(type)){
            p_type = "from Formmain1465";
        } else if("commodity".equals(type)){
            p_type = "from Formmain1467";
        }else if("custom".equals(type)){
            p_type = "from Formmain1466";
        }else if("warehouse".equals(type)){
            p_type = "from Formmain1464";
        }
        try {
            List list = DBAgent.find(p_type);
            ret.put("data",list);
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("data","error");
        }

        UIUtils.responseJSON(ret,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView syncData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("type");
        Map ret  = new HashMap();
        EnumParameterType p_type = EnumParameterType.ORG;
        if("org".equals(type)){
             p_type = EnumParameterType.ORG;
        }else if("bill".equals(type)){
            p_type = EnumParameterType.BILL;
        } else if("commodity".equals(type)){
            p_type = EnumParameterType.COMMODITY;
        }else if("custom".equals(type)){
            p_type = EnumParameterType.CUSTOM;
        }else if("warehouse".equals(type)){
            p_type = EnumParameterType.WAREHOUSE;
        }
        try {
            List list = this.getSvc().getData(p_type);
            ret.put("data",list);
        } catch (IOException e) {
            e.printStackTrace();
            ret.put("data","error");
        }

        UIUtils.responseJSON(ret,response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView syncAllData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("user");
        Map ret  = new HashMap();
        if(!"liuwenping".equals(type)){
            ret.put("data-error","deny - access");
            UIUtils.responseJSON(ret,response);
            return null;
        }

        EnumParameterType[] enumTyps = {
                EnumParameterType.ORG,
                EnumParameterType.BILL,
                EnumParameterType.COMMODITY,
                EnumParameterType.CUSTOM,
                EnumParameterType.WAREHOUSE
        };

            for(EnumParameterType pt:enumTyps){
                try {
                    List list = this.getSvc().getData(pt);
                    ret.put("data-" + pt, list);
                    if(!CollectionUtils.isEmpty(list)){
                            DBAgent.saveAll(list);
                    }
                }catch(Exception e){
                    e.printStackTrace();
                    ret.put("data-" + pt, "error");
                }

            }


        UIUtils.responseJSON(ret,response);


        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView deleteAllData(HttpServletRequest request, HttpServletResponse response){

        String type = request.getParameter("user");
        Map ret  = new HashMap();
        if(!"liuwenping".equals(type)){
            ret.put("data-error","deny - access");
            UIUtils.responseJSON(ret,response);
            return null;
        }
       String[] sqls = {
                "from Formmain1464",
               "from Formmain1465",
               "from Formmain1466",
               "from Formmain1467",
               "from Formmain1468"
       };
        for(String sql:sqls){
            try {
                List list = DBAgent.find(sql);
                ret.put("data-" + sql, list);
                if(!CollectionUtils.isEmpty(list)){
                    DBAgent.deleteAll(list);
                }
            }catch(Exception e){
                e.printStackTrace();
                ret.put("data-" + sql, "error");
            }
        }
        UIUtils.responseJSON(ret,response);
        return null;
    }
    public static void main(String[] args) throws IOException {
        XingjueController conm = new XingjueController();
         Date st  = new Date(new Date().getTime()-24*3600*60*1000);
         Date ed = new Date();
         List list =  conm.getSvc().getData(EnumParameterType.WAREHOUSE,st,ed);
         System.out.println(list);
    }
}
