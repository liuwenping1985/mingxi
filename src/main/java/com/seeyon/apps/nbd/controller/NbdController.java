package com.seeyon.apps.nbd.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.log.LogBuilder;
import com.seeyon.apps.nbd.core.service.PluginServiceManager;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.service.impl.PluginServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.plugin.PluginDefinition;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.util.StringUtils;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/8/17.
 */

public class NbdController extends BaseController {

    private PluginServiceManager nbdPluginServiceManager;

    private LogBuilder log = new LogBuilder("Export_LOG");

    private FileManager fileManager = (FileManager) AppContext.getBean("fileManager");
    private static PluginServiceManager npsm;

    public static PluginServiceManager getPSM(){
            return npsm;
    }
    public static void setPSM(PluginServiceManager psm){
         npsm = psm;
    }

    private PluginServiceManager getNbdPluginServiceManager() {

        if (nbdPluginServiceManager == null) {
            try {
                if(npsm!=null){
                    nbdPluginServiceManager = npsm;
                    return npsm;
                }
                nbdPluginServiceManager = new PluginServiceManagerImpl();
                npsm = nbdPluginServiceManager;
            } catch (Exception e) {
                e.printStackTrace();
            } catch (Error error) {
                error.printStackTrace();
            }
        }
        return nbdPluginServiceManager;
    }

    @NeedlessCheckLogin
    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) {

        Map data = new HashMap();
        //  DBAgent.saveAll(formTableDefinitions);
        data.put("items", "1234567890");
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        entity.setData(data);
        UIUtils.responseJSON(entity, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView selectA8(HttpServletRequest request, HttpServletResponse response) {

        Map data = new HashMap();
        List<A8OutputVo> list = DBAgent.find("from A8OutputVo");
        data.put("items", list);
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        entity.setData(data);
        UIUtils.responseJSON(entity, response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView syncData(HttpServletRequest request, HttpServletResponse response) {

        String type = request.getParameter("affairType");

        try {
            ServicePlugin sp = this.getNbdPluginServiceManager().getServicePluginsByAffairType(type);

            List<A8OutputVo> formTableDefinitions = sp.exportData(type);
            Map data = new HashMap();
            DBAgent.saveAll(formTableDefinitions);
            data.put("items", formTableDefinitions);
            NbdResponseEntity entity = new NbdResponseEntity();
            entity.setResult(true);
            entity.setData(data);
            UIUtils.responseJSON(entity, response);
            return null;
        } catch (Exception e) {
            e.printStackTrace();
        }
        UIUtils.responseJSON("error", response);
        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView syncDataAll(HttpServletRequest request, HttpServletResponse response) {

        List<ServicePlugin> spList = this.getNbdPluginServiceManager().getServicePlugins();
        Map ret = new HashMap();
        if (!CommonUtils.isEmpty(spList)) {
            for (ServicePlugin sp : spList) {
                Map<String, List<A8OutputVo>> data = sp.exportAllData();
                for (Map.Entry<String, List<A8OutputVo>> entry : data.entrySet()) {
                    ret.put(entry.getKey(), entry.getValue() == null ? 0 : entry.getValue().size());
                }
            }
        }
        UIUtils.responseJSON(ret, response);

        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView receive(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);
        List<ServicePlugin> spList = nbdPluginServiceManager.getServicePlugins();
        String affairType = parameter.$("affairType");
        if (!CommonUtils.isEmpty(spList)) {
            for (ServicePlugin sp : spList) {
                if (sp.containAffairType(affairType)) {
                    CommonDataVo cdv = sp.receiveAffair(parameter);
                    UIUtils.responseJSON(cdv, response);
                    break;
                }
            }
        }


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView find(HttpServletRequest request, HttpServletResponse response) {


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView update(HttpServletRequest request, HttpServletResponse response) {


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView importData(HttpServletRequest request, HttpServletResponse response) {
        List<PluginDefinition> retList = this.getNbdPluginServiceManager().getPluginDefinitions();
        List<String> affairList = new ArrayList<String>();
        for (PluginDefinition pd : retList) {
            affairList.addAll(pd.getSupportAffairTypes());
        }
        DataBaseHandler dbh = DataBaseHandler.getInstance();
        for (String type : affairList) {
            try {
                log.log("eeeee:" + type);
                Map data = dbh.getDataAll(type);
                if (CommonUtils.isEmpty(data)) {
                    continue;
                }

                List<A8OutputVo> retDataList = new ArrayList<A8OutputVo>();
                for (Object key : data.keySet()) {
                    Object dataJson = data.get(key);
                    A8OutputVo vo = JSON.parseObject(JSON.toJSONString(dataJson), A8OutputVo.class);
                    retDataList.add(vo);

                }
                DBAgent.updateAll(retDataList);
            } catch (Exception e) {
                e.printStackTrace();
            }catch(Error e){
                e.printStackTrace();
            }

        }


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView flatAllDataVo(HttpServletRequest request, HttpServletResponse response) {


        CommonParameter parameter = CommonParameter.parseParameter(request);

        List<PluginDefinition> retList = this.getNbdPluginServiceManager().getPluginDefinitions();
        List<String> affairList = new ArrayList<String>();
        for (PluginDefinition pd : retList) {
            affairList.addAll(pd.getSupportAffairTypes());
        }
        DataBaseHandler dbh = DataBaseHandler.getInstance();
        for (String type : affairList) {
            log.log(" export start type=" + type);
            String sql = "from A8OutputVo where type='" + type + "'";
            List<A8OutputVo> aopvList = DBAgent.find(sql);
            log.log(" exist data size=" + aopvList.size());
            dbh.createNewDataBaseByNameIfNotExist(type);
            String upDbName = "UPDATE_" + type;
            String crDbName = "CREATE_" + type;
            dbh.createNewDataBaseByNameIfNotExist(upDbName);
            dbh.createNewDataBaseByNameIfNotExist(crDbName);
            Map<String, String> existDataMap = new HashMap<String, String>();
            Map<Long, Long> existIdDataMap = new HashMap<Long, Long>();
            Map<Long, A8OutputVo> existWholeDataMap = new HashMap<Long, A8OutputVo>();
            for (A8OutputVo aovp : aopvList) {
                existIdDataMap.put(aovp.getSourceId(), aovp.getId());
                existWholeDataMap.put(aovp.getSourceId(), aovp);
                existDataMap.put(String.valueOf(aovp.getSourceId()), aovp.getData());
            }
            //dbh.putAllData(type,existDataMap);
            ServicePlugin sp = this.getNbdPluginServiceManager().getServicePluginsByAffairType(type);
            log.log(" sp is null=" + (sp == null));
            List<A8OutputVo> outList = sp.exportData(type);
            log.log(" output size=" + (outList.size()));
            List<A8OutputVo> addedList = new ArrayList<A8OutputVo>();
            List<A8OutputVo> updatedList = new ArrayList<A8OutputVo>();
            Map<Long, String> updatedMap = new HashMap<Long, String>();
            Map<Long, String> addedMap = new HashMap<Long, String>();
            for (A8OutputVo out : outList) {
                String data = existDataMap.get(String.valueOf(out.getSourceId()));
                if (CommonUtils.isEmpty(data)) {
                    addedList.add(out);
                    addedMap.put(out.getSourceId(), out.getType());
                    log.log("added " + type + " and sourceId:" + out.getSourceId());
                } else {
                    if (!out.getData().equals(data)) {
                        updatedMap.put(out.getSourceId(), out.getType());
                        updatedList.add(out);
                        log.log("updated " + type + " and sourceId:" + out.getSourceId());
                    }
                }
            }
            dbh.putAllData(upDbName, updatedMap);
            dbh.putAllData(crDbName, addedMap);
            log.log("added -size=" + addedList.size());
            log.log("updated -size=" + updatedList.size());
            String save = parameter.$("save");
            if ("1".equals(save)) {

                if (!CommonUtils.isEmpty(addedList)) {
                    DBAgent.saveAll(addedList);
                }
                if (!CommonUtils.isEmpty(updatedList)) {
                    for (A8OutputVo vo : updatedList) {
                        Long id = existIdDataMap.get(vo.getSourceId());
                        vo.setId(id);
                    }
                    DBAgent.updateAll(updatedList);
                }


            }
            try {
                dbh.putAllData(type, existWholeDataMap);
            } catch (Exception e) {

            }
        }


        return null;

    }

    @NeedlessCheckLogin
    public ModelAndView flatData(HttpServletRequest request, HttpServletResponse response) {
        CommonParameter parameter = CommonParameter.parseParameter(request);
        // List<String> affairTyps = getNbdPluginServiceManager().
        String type = parameter.$("affairType");
        if (StringUtils.isEmpty(type)) {
            return null;
        }
        log.log(" export start type=" + type);
        DataBaseHandler dbh = DataBaseHandler.getInstance();
        String sql = "from A8OutputVo where type='" + type + "'";
        List<A8OutputVo> aopvList = DBAgent.find(sql);
        log.log(" exist data size=" + aopvList.size());
        dbh.createNewDataBaseByNameIfNotExist(type);
        String upDbName = "UPDATE_" + type;
        String crDbName = "CREATE_" + type;
        dbh.createNewDataBaseByNameIfNotExist(upDbName);
        dbh.createNewDataBaseByNameIfNotExist(crDbName);
        Map<String, String> existDataMap = new HashMap<String, String>();
        Map<Long, Long> existIdDataMap = new HashMap<Long, Long>();
        Map<Long, A8OutputVo> existWholeDataMap = new HashMap<Long, A8OutputVo>();
        for (A8OutputVo aovp : aopvList) {
            existIdDataMap.put(aovp.getSourceId(), aovp.getId());
            existWholeDataMap.put(aovp.getSourceId(), aovp);
            existDataMap.put(String.valueOf(aovp.getSourceId()), aovp.getData());
        }
        //dbh.putAllData(type,existDataMap);
        ServicePlugin sp = this.getNbdPluginServiceManager().getServicePluginsByAffairType(type);
        log.log(" sp is null=" + (sp == null));
        List<A8OutputVo> outList = sp.exportData(type);
        log.log(" output size=" + (outList.size()));
        List<A8OutputVo> addedList = new ArrayList<A8OutputVo>();
        List<A8OutputVo> updatedList = new ArrayList<A8OutputVo>();
        Map<Long, String> updatedMap = new HashMap<Long, String>();
        Map<Long, String> addedMap = new HashMap<Long, String>();
        for (A8OutputVo out : outList) {
            String data = existDataMap.get(String.valueOf(out.getSourceId()));
            if (CommonUtils.isEmpty(data)) {
                addedList.add(out);
                addedMap.put(out.getSourceId(), out.getType());
                log.log("added " + type + " and sourceId:" + out.getSourceId());
            } else {
                if (!out.getData().equals(data)) {
                    updatedMap.put(out.getSourceId(), out.getType());
                    updatedList.add(out);
                    log.log("updated " + type + " and sourceId:" + out.getSourceId());
                }
            }
        }
        dbh.putAllData(upDbName, updatedMap);
        dbh.putAllData(crDbName, addedMap);
        log.log("added -size=" + addedList.size());
        log.log("updated -size=" + updatedList.size());
        String save = parameter.$("save");
        if ("1".equals(save)) {

            if (!CommonUtils.isEmpty(addedList)) {
                DBAgent.saveAll(addedList);
            }
            if (!CommonUtils.isEmpty(updatedList)) {
                for (A8OutputVo vo : updatedList) {
                    Long id = existIdDataMap.get(vo.getSourceId());
                    vo.setId(id);
                }
                DBAgent.updateAll(updatedList);
            }


        }
        try {
            dbh.putAllData(type, existWholeDataMap);
        } catch (Exception e) {

        }

        UIUtils.responseJSON("OK", response);

        return null;

    }


    private void flatDataAll() {


    }


    @NeedlessCheckLogin
    public ModelAndView download(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String fileId = request.getParameter("file_id");
        if (CommonUtils.isEmpty(fileId)) {

            return null;

        }
//        String path = "D:/Seeyon/A8/base/temporary/";
//        path = path+fileId;
//        String downloadSuffix = "decryption";
//        path+=downloadSuffix;
//        // path是指欲下载的文件的路径。
//        File file = new File(path);
//        if(!file.exists()){
//
//        }
        try {
            V3XFile v3xfile = fileManager.getV3XFile(Long.parseLong(fileId));
            File file = fileManager.getFile(Long.parseLong(fileId), v3xfile.getCreateDate());
            String filename = v3xfile.getFilename();

            // 取得文件名。

            // 取得文件的后缀名。
            //String ext = filename.substring(filename.lastIndexOf(".") + 1).toUpperCase();

            // 以流的形式下载文件。
            InputStream fis = new BufferedInputStream(new FileInputStream(file));
            byte[] buffer = new byte[fis.available()];
            fis.read(buffer);
            fis.close();
            // 清空response
            response.reset();
            // 设置response的Header
            response.addHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes()));
            response.addHeader("Content-Length", "" + file.length());
            OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
            response.setContentType("application/octet-stream");
            toClient.write(buffer);
            toClient.flush();
            toClient.close();

        } catch (Exception e) {
            e.printStackTrace();
        }


        return null;

    }


}
