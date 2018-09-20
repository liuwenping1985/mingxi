package com.seeyon.apps.xinjue.controller;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.service.SyncThread;
import com.seeyon.apps.xinjue.service.XingjueService;
import com.seeyon.apps.xinjue.util.UIUtils;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;
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
        if (svc == null) {
            svc = new XingjueService();
        }
        return svc;
    }

    @NeedlessCheckLogin
    public ModelAndView syncDataSave(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("type");
        Map ret = new HashMap();
        SyncThread th = new SyncThread();
        th.setService(this.getSvc());
        try {
        if ("org".equals(type)) {
           // p_type = EnumParameterType.ORG;
            List list = th.syncORG();
            ret.put("data-size", list.size());
        } else if ("bill".equals(type)) {
          //  p_type = EnumParameterType.BILL;
            List list = th.syncBILL();
            //DBAgent.saveAll(list);
            ret.put("data-size", list.size());
        } else if ("commodity".equals(type)) {
            List list = th.syncCOMMODITY();
            //DBAgent.saveAll(list);
            ret.put("data-size", list.size());

        } else if ("custom".equals(type)) {
            List list = th.syncCUSTOM();
            //DBAgent.saveAll(list);
            ret.put("data-size", list.size());
        } else if ("warehouse".equals(type)) {
            List list = th.syncWAREHOUSE();
            //DBAgent.saveAll(list);
            ret.put("data-size", list.size());
        }


        } catch (Exception e) {
            e.printStackTrace();
            ret.put("data", "error");
        }

        UIUtils.responseJSON(ret, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView getSyncData(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("type");
        Map ret = new HashMap();
        String p_type = "from Formmain1464";
        if ("org".equals(type)) {
            p_type = "from Formmain1468";
        } else if ("bill".equals(type)) {
            p_type = "from Formmain1465";
        } else if ("commodity".equals(type)) {
            p_type = "from Formmain1467";
        } else if ("custom".equals(type)) {
            p_type = "from Formmain1466";
        } else if ("warehouse".equals(type)) {
            p_type = "from Formmain1464";
        }
        try {
            List list = DBAgent.find(p_type);
            ret.put("data", list);
        } catch (Exception e) {
            e.printStackTrace();
            ret.put("data", "error");
        }

        UIUtils.responseJSON(ret, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView startSyncData(HttpServletRequest request, HttpServletResponse response) {
        Map data = new HashMap();
        try {
            this.getSvc().syncAllDataByPeriod();
            data.put("isOk", true);
        } catch (Exception e) {
            e.printStackTrace();
            data.put("isOk", false);
            data.put("msg", e.getMessage());
        }
        UIUtils.responseJSON(data, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView stopSyncData(HttpServletRequest request, HttpServletResponse response) {

        Map data = new HashMap();
        try {
            this.getSvc().stopDataSync();
            data.put("isOk", true);
        } catch (Exception e) {
            e.printStackTrace();
            data.put("isOk", false);
            data.put("msg", e.getMessage());
        }
        UIUtils.responseJSON(data, response);
        // UIUtils.responseJSON(ret,response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView syncData(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("type");
        String num = request.getParameter("num");
        Long no = 0l;
        if(num!=null){
            no = Long.parseLong(num);
        }
        Map ret = new HashMap();
        EnumParameterType p_type = EnumParameterType.ORG;
        try {
            List list = null;
            Date start = new Date(0);
            Date end = new Date();
            if ("org".equals(type)) {
                p_type = EnumParameterType.ORG;
                 list = this.getSvc().getData(p_type);
            } else if ("bill".equals(type)) {
                p_type = EnumParameterType.BILL;
                 list = this.getSvc().getData(p_type);
            } else if ("commodity".equals(type)) {
                p_type = EnumParameterType.COMMODITY;
                HaiXingParameter p =  this.getSvc().getHaixingParameterByType(p_type,no);
                 list = this.getSvc().getData(p_type,p);
                ret.put("data", list);
            } else if ("custom".equals(type)) {
                p_type = EnumParameterType.CUSTOM;
                HaiXingParameter p =  this.getSvc().getHaixingParameterByType(p_type,no);
                list = this.getSvc().getData(p_type,p);
            } else if ("warehouse".equals(type)) {
                p_type = EnumParameterType.WAREHOUSE;
                HaiXingParameter p =  this.getSvc().getHaixingParameterByType(p_type,no);
                list = this.getSvc().getData(p_type,p);
            }

            ret.put("data", list);

        } catch (IOException e) {
            e.printStackTrace();
            ret.put("data", "error");
        }

        UIUtils.responseJSON(ret, response);
        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView syncAllData(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("user");
        Map ret = new HashMap();
        if (!"liuwenping".equals(type)) {
            ret.put("data-error", "deny - access");
            UIUtils.responseJSON(ret, response);
            return null;
        }

        EnumParameterType[] enumTyps = {
                EnumParameterType.ORG,
                EnumParameterType.BILL,
                EnumParameterType.COMMODITY,
                EnumParameterType.CUSTOM,
                EnumParameterType.WAREHOUSE
        };
        Date dt = new Date(0);
        Date ed = new Date();
        for (EnumParameterType pt : enumTyps) {
            try {
                List list = null;
                if(pt == EnumParameterType.ORG||pt==EnumParameterType.BILL){
                    list = this.getSvc().getData(pt);

                }else{
                    list = this.getSvc().getData(pt,0L);
                }
                if (!CollectionUtils.isEmpty(list)) {
                    DBAgent.saveAll(list);
                }
                if(list!=null){
                    int size = list.size();
                    Long start = 1000l;
                    while(size==1000){
                        List tempList = this.getSvc().getData(pt,start);
                        if(tempList!=null){
                            size = tempList.size();
                            start = start+size;
                            DBAgent.saveAll(tempList);
                        }else{
                            size = 0;
                        }

                    }
                    ret.put("data-size", start);
                }

                ret.put("data-" + pt, list);


            } catch (Exception e) {
                e.printStackTrace();
                ret.put("data-" + pt, "error");
            }

        }


        UIUtils.responseJSON(ret, response);


        return null;
    }

    @NeedlessCheckLogin
    public ModelAndView deleteAllData(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("user");
        Map ret = new HashMap();
        if (!"liuwenping".equals(type)) {
            ret.put("data-error", "deny - access");
            UIUtils.responseJSON(ret, response);
            return null;
        }
        String[] sqls = {
                "from Formmain1464",
                "from Formmain1465",
                "from Formmain1466",
                "from Formmain1467",
                "from Formmain1468"
        };
        for (String sql : sqls) {
            try {
                List list = DBAgent.find(sql);
                ret.put("data-" + sql, list);
                if (!CollectionUtils.isEmpty(list)) {
                    DBAgent.deleteAll(list);
                }
            } catch (Exception e) {
                e.printStackTrace();
                ret.put("data-" + sql, "error");
            }
        }
        UIUtils.responseJSON(ret, response);
        return null;
    }

    public static void main(String[] args) throws IOException {
        XingjueController conm = new XingjueController();
        Date st = new Date(new Date().getTime() - 24 * 3600 * 60 * 1000);
        Date ed = new Date();
        List list = conm.getSvc().getData(EnumParameterType.WAREHOUSE, st, ed);
        System.out.println(list);
    }
}
