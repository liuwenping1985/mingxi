package com.seeyon.apps.nbd.plugin.als.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
import com.seeyon.apps.nbd.core.log.LogBuilder;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.als.service.AbstractAlsServicePlugin;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.dao.V3XFileDAO;
import com.seeyon.ctp.common.filemanager.dao.V3XFileDAOImpl;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManagerImpl;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.filemanager.manager.FileManagerImpl;
import com.seeyon.ctp.common.fileupload.FileUploadController;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.oainterface.impl.exportdata.FileDownloadExporter;

import java.io.File;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class AlsServicePluginImpl extends AbstractAlsServicePlugin {
    private LogBuilder log = new LogBuilder("Export_LOG");
    private EnumManager enumManager;

    private OrgManager orgManager;

    private FileManager fileManager = (FileManager) AppContext.getBean("fileManager");


    public EnumManager getEnumManager() {

        if (enumManager == null) {
            enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
        }
        return enumManager;
    }

    public OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }


    public List<String> getSupportAffairTypes() {
        return this.getPluginDefinition().getSupportAffairTypes();
    }

    public Map<String, List<A8OutputVo>> exportAllData() {
        Map<String, List<A8OutputVo>> ret = new HashMap<String, List<A8OutputVo>>();
        List<String> allSupports = this.getPluginDefinition().getSupportAffairTypes();
        for(String arrairType:allSupports){
            try {
                List<A8OutputVo> afList = exportData(arrairType);
                ret.put(arrairType, afList);
                if (!CommonUtils.isEmpty(afList)) {
                    DBAgent.saveAll(afList);
                }
            }catch(Exception e){
                e.printStackTrace();
                ret.put(arrairType, new ArrayList<A8OutputVo>());
            }
        }
        return ret;
    }

    public List<A8OutputVo> exportData(String affairType) {
        List<A8OutputVo> dataList = new ArrayList<A8OutputVo>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            log.log(ftd.getFormTable().getName()+"master table data size:" + list.size());
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables) && !CommonUtils.isEmpty(list)) {
                //create temp master table container

                Map<Long, Map> masterTempMap = new HashMap<Long, Map>();
                for (Map masterMap : list) {
                    Object id = masterMap.get("id");
                    if (id != null) {
                        if (id instanceof Long) {
                            masterTempMap.put((Long) id, masterMap);
                        } else if (id instanceof BigDecimal) {
                            masterTempMap.put(((BigDecimal) id).longValue(), masterMap);
                        } else {
                            try {
                                Long r_id = Long.parseLong(String.valueOf(id));
                                masterTempMap.put(r_id, masterMap);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }

                    }
                }
                //System.out.println("master map:" + masterTempMap.values().size());
                for (FormTable ft : slaveTables) {
                    log.log("[<---->]export slave table:" + ft.getName());
                    String slaveTableSql = FormTableDefinition.genRawAllQuery(ft);
                    //System.out.println("[<---->] slave table sql:" + slaveTableSql);
                    List<Map> slaveDataList = new ArrayList<Map>();
                    try {
                        slaveDataList = DataBaseHelper.executeQueryByNativeSQL(slaveTableSql);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    //onwerfield
                    if (!CommonUtils.isEmpty(slaveDataList)) {
                        log.log("[<---->] slave table" + ft.getName() + " data-size:" + slaveDataList.size());
                        int tag = 0;
                        for (Map slaveTableMap : slaveDataList) {
                            Object fmId = slaveTableMap.get("formmain_id");
                            // System.out.println("fmId:"+fmId);
                            if (fmId != null) {
                                Long key = null;
                                if (fmId instanceof Long) {
                                    key = (Long) fmId;
                                } else if (fmId instanceof BigDecimal) {
                                    key = ((BigDecimal) fmId).longValue();
                                } else {
                                    key = Long.parseLong(String.valueOf(fmId));
                                }
                                Map masterMap = masterTempMap.get(key);
                                if (!CommonUtils.isEmpty(masterMap)) {
                                    //getDisplayText
                                    for (Object skey : slaveTableMap.keySet()) {
                                        slaveTableMap.put(skey, getDisplayTextByValue("" + skey, "", slaveTableMap.get(skey)));

                                    }
                                    List<Map> slaveMaps = (List<Map>)masterMap.get(ft.getDisplay());
                                    if (slaveMaps == null) {
                                        slaveMaps = new ArrayList<Map>();
                                        masterMap.put(ft.getDisplay(),slaveMaps);

                                    }
                                    slaveMaps.add(slaveTableMap);
                                    if(tag==0){
                                        System.out.println(slaveTableMap);
                                        tag++;
                                    }
                                } else {

                                    System.out.println(key + "--master not found--->>>" + "<<<---");
                                }
                            }
                        }
                    }
                }
            }
            List<List<SimpleFormField>> simpleList = ftd.filledValue(list);
            for (List<SimpleFormField> sffList : simpleList) {
                A8OutputVo a8OutputVo = exportA8OutputVo(affairType, sffList);
                if (a8OutputVo != null) {
                    dataList.add(a8OutputVo);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println(" end of export master table");
        return dataList;

    }

    public List<Map> exportOriginalData(String affairType) {
        List<Map> dataList = new ArrayList<Map>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }

        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<Map>();
    }

    private A8OutputVo exportA8OutputVo(String affairType, List<SimpleFormField> sffList) {

        if (CommonUtils.isEmpty(sffList)) {
            return null;
        }
        A8OutputVo vo = new A8OutputVo();
        Map<String, Object> dataMap = new HashMap<String, Object>();
        vo.setStatus(0);
        vo.setCreateDate(new Date());
        vo.setUpdateDate(vo.getCreateDate());
        vo.setType(affairType);
        //处理子表

        //end of 处理
        for (SimpleFormField sff : sffList) {
            if (sff.getName().toLowerCase().equals("id")) {
                vo.setSourceId(CommonUtils.paserLong(sff.getValue()));
            }
            if (sff.getName().toLowerCase().equals("start_date")) {
                Object obj = sff.getValue();
                vo.setYear(String.valueOf(CommonUtils.getYear(String.valueOf(obj))));
                vo.setCreateDate(CommonUtils.parseDate(String.valueOf(obj)));
                vo.setUpdateDate(vo.getCreateDate());
            }
            /**
             * 翻译
             */
            // this.getCtpEnumItemById()
            dataMap.put(sff.getDisplay(), getDisplayText(sff));
        }
        vo.setData(JSON.toJSONString(dataMap));
        vo.setIdIfNew();
        return vo;
    }

    private Object getDisplayText(SimpleFormField sff) {
        Object val = sff.getValue();
        return getDisplayTextByValue(sff.getDisplay(), sff.getClassName(), val);
    }

    private Object getDisplayTextByValue(String displayName, String className, Object val) {
        Long sid = null;
        try {
            if (val instanceof Long) {
                sid = (Long) val;
            } else if (val instanceof BigDecimal) {
                sid = ((BigDecimal) val).longValue();
            } else {
                try {
                    sid = Long.parseLong(String.valueOf(val));
                } catch (Exception e) {
                    return val;
                }
            }
            if (sid.intValue() >= 0 &&sid.intValue() <= 10000) {
                return val;
            }

        } catch (Exception e) {

        }
        try {
            if(DataBaseHandler.getInstance().isEnumExist(sid)){
                return sid;
            }
            CtpEnumItem item = this.getCtpEnumItemById(sid);
            if (item != null) {
                return item.getShowvalue();
            }

            String dept = getMemberOrDepartmentById(sid);
            if (!CommonUtils.isEmpty(dept)) {
                return dept;
            }

        } catch (Exception e) {

        }
        //是否是时间

        if (("" + displayName).contains("日期") || ("" + displayName).contains("时间")) {
            try {

                Date dt = new Date(sid);
                String dtStr = CommonUtils.parseDate(dt);
                if (!CommonUtils.isEmpty(dtStr)) {
                    return dtStr;
                }
            } catch (Exception e) {

            }
        }

        if (!CommonUtils.isEmpty(className)) {
            if ("attachment".equals(className)) {
                //System.out.println("---I am in attchment---:"+sff.getValue());
               // String sql = "select * from ctp_attachment where id=" + sid + " or reference=" + sid + " or sub_reference=" + sid;
                try {
                    List<Map> dataList = getFiles(sid);
                    if (!CommonUtils.isEmpty(dataList)) {
                        List<Map> files = new ArrayList<Map>();
                        for(Map fileMap:dataList){

                            Object fileName = fileMap.get("filename");
                            //   System.out.println("---I find a attchment---:"+fileName);
                            Object mimeType = fileMap.get("mime_type");
                            Object fileSize = fileMap.get("attachment_size");
                            Object fileIdRaw = fileMap.get("file_url");
                            Long file_id = null;
                            if (fileIdRaw instanceof Long) {
                                file_id = (Long) fileIdRaw;
                            }
                            if (fileIdRaw instanceof BigDecimal) {
                                file_id = ((BigDecimal) fileIdRaw).longValue();
                            }
                            // System.out.println("---I find a attchment file_url---:"+file_id);
                            if (file_id != null) {

                                V3XFile v3xFile = fileManager.getV3XFile(file_id);
                                //     System.out.println("---v3xFile---:"+v3xFile);
                                if (v3xFile != null) {
                                    //System.out.println("---I find a v3xFile file_url---:"+v3xFile.getId());
                                    File file = fileManager.getFile(file_id, v3xFile.getCreateDate());
                                    //       System.out.println("file---->>>>"+file);
                                    if (file != null) {
                                        Map ret = new HashMap();
                                        ret.put("file_path", "/seeyon/nbd.do?method=download&file_id=" + fileIdRaw);
                                        ret.put("file_name", fileName);
                                        ret.put("file_id", fileIdRaw);
                                        ret.put("mime_type", mimeType);
                                        ret.put("file_size", fileSize);
                                        // System.out.println(ret);
                                        files.add(ret);
                                    } else {
                                        Map ret = new HashMap();
                                        ret.put("file_name", fileName);
                                        files.add(ret);;
                                    }

                                }
                            }

                        }
                        return JSON.toJSONString(files);

                    }
                } catch (Exception e) {
                    System.out.println("error:" + e.getMessage());
                }
            }

        }
        return val;
    }
    private static final List<Map> fileDataList = new ArrayList<Map>();

    private synchronized List<Map> getDataByCache(){
       if(fileDataList.isEmpty()){
           String sql = "select * from ctp_attachment";
           try {
               List<Map> dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
               if(dataList==null||CommonUtils.isEmpty(dataList)){
                   return fileDataList;
               }
               fileDataList.addAll(dataList);
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
        return fileDataList;
    }
    private List<Map> getFiles(Long id){
        List<Map> dataList = this.getDataByCache();
        List<Map> retList = new ArrayList<Map>();
        for(Map map:dataList){
            Long fid = CommonUtils.getLong("id");
            Long referenceId = CommonUtils.getLong("reference");
            Long subReferenceId = CommonUtils.getLong("sub_reference");
            if(id.equals(fid)||id.equals(referenceId)||id.equals(subReferenceId)){
                retList.add(map);
            }

        }
        return retList;
    }


    private CtpEnumItem getCtpEnumItemById(Long enumId) {

        CtpEnumItem item = null;
        try {
            item = getEnumManager().getCacheEnumItem(enumId);
            return item;
        } catch (BusinessException e) {

        }
        return null;
    }

    private String getMemberOrDepartmentById(Long enumId) {

        try {
            V3xOrgMember member = this.getOrgManager().getMemberById(enumId);
            if (member != null) {
                return member.getName();
            }

        } catch (Exception e) {
        }

        try {
            V3xOrgDepartment department = this.getOrgManager().getDepartmentById(enumId);
            if (department != null) {
                return department.getName();
            }
        } catch (Exception e) {


        }


        return null;
    }

    public List<A8OutputVo> exportData(String affairType, CommonParameter parameter) {
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        return null;
    }
}
