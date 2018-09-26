package com.seeyon.apps.nbd.plugin.als.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
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
import com.seeyon.oainterface.impl.exportdata.FileDownloadExporter;

import java.io.File;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class AlsServicePluginImpl extends AbstractAlsServicePlugin {
    private EnumManager enumManager;

    private OrgManager orgManager;

    private FileManager fileManager = (FileManager)AppContext.getBean("fileManager");


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
        throw new UnsupportedOperationException();
    }

    public List<A8OutputVo> exportData(String affairType) {
        List<A8OutputVo> dataList = new ArrayList<A8OutputVo>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        System.out.println("----starting export data----");
        System.out.println("----export master table---");
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            System.out.println("master table data size:" + list.size());
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables) && !CommonUtils.isEmpty(list)) {
                //create temp master table container

                Map<Long, Map> masterTempMap = new HashMap<Long, Map>();
                for (Map masterMap : list) {
                    Object id = masterMap.get("id");
                    if (id != null) {
                        if (id instanceof Long) {
                            masterTempMap.put((Long) id, masterMap);
                        }
                        if (id instanceof BigDecimal) {
                            masterTempMap.put(((BigDecimal) id).longValue(), masterMap);
                        }
                    }
                }

                for (FormTable ft : slaveTables) {
                    System.out.println("[<---->]export slave table:" + ft.getName());
                    String slaveTableSql = FormTableDefinition.genRawAllQuery(ft);
                    System.out.println("[<---->] slave table sql:" + slaveTableSql);
                    List<Map> slaveDataList = new ArrayList<Map>();
                    try {
                        slaveDataList = DataBaseHelper.executeQueryByNativeSQL(slaveTableSql);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    //onwerfield
                    if (!CommonUtils.isEmpty(slaveDataList)) {
                        System.out.println("[<---->] slave table"+ft.getName()+" data-size:" + slaveDataList.size());
                        for (Map slaveTableMap : slaveDataList) {
                            Object fmId = slaveTableMap.get("formmain_id");
                            if (fmId != null) {
                                Long key = null;
                                if (fmId instanceof Long) {
                                    key = (Long) fmId;
                                }
                                if (fmId instanceof BigDecimal) {
                                    key = ((BigDecimal) fmId).longValue();
                                }
                                Map masterMap = masterTempMap.get(key);
                                if (!CommonUtils.isEmpty(masterMap)) {
                                    masterMap.putAll(slaveTableMap);
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
        Long sid = null;
        try {
            if(val instanceof Long){
                sid = (Long)val;
            }else if(val instanceof BigDecimal){
                sid = ((BigDecimal)val).longValue();
            }else{
                try{
                    sid = Long.parseLong(String.valueOf(val));
                }catch(Exception e){
                    return val;
                }
            }
            if(sid.intValue() ==0||sid.intValue()==1){
                return val;
            }

        } catch (Exception e) {

        }
        try {

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

        if (("" + sff.getDisplay()).contains("日期") || ("" + sff.getDisplay()).contains("时间")) {
            try {

                Date dt = new Date(sid);
                String dtStr = CommonUtils.parseDate(dt);
                if(!CommonUtils.isEmpty(dtStr)){
                    return dtStr;
                }
            } catch (Exception e) {

            }
        }

        if(!CommonUtils.isEmpty(sff.getClassName())){
            if("attachment".equals(sff.getClassName())){
                System.out.println("---I am in attchment---:"+sff.getValue());
                String sql = "select * from ctp_attachment where id="+sid+" or reference="+sid+" or sub_reference="+sid;
                try {
                    List<Map> dataList =  DataBaseHelper.executeQueryByNativeSQL(sql);
                    if(!CommonUtils.isEmpty(dataList)){

                       Map fileMap= dataList.get(0);
                       Object fileName = fileMap.get("filename");
                        System.out.println("---I find a attchment---:"+fileName);
                       Object mimeType = fileMap.get("mime_type");
                       Object fileSize = fileMap.get("attachment_size");
                       Object fileIdRaw = fileMap.get("file_url");
                       Long file_id = null;
                       if(fileIdRaw instanceof Long){
                           file_id = (Long)fileIdRaw;
                       }
                        if(fileIdRaw instanceof BigDecimal){
                            file_id = ((BigDecimal)fileIdRaw).longValue();
                        }
                       // System.out.println("---I find a attchment file_url---:"+file_id);
                        if(file_id!=null){

                            V3XFile v3xFile = fileManager.getV3XFile(file_id);
                            System.out.println("---v3xFile---:"+v3xFile);
                           if(v3xFile!=null){
                               //System.out.println("---I find a v3xFile file_url---:"+v3xFile.getId());
                               File file = fileManager.getFile(file_id, v3xFile.getCreateDate());
                               System.out.println("file---->>>>"+file);
                                if(file!=null){
                                    Map ret = new HashMap();
                                    ret.put("file_path",file.getAbsolutePath());
                                    ret.put("file_name",fileName);
                                    ret.put("file_id",fileIdRaw);
                                    ret.put("mime_type",mimeType);
                                    ret.put("file_size",fileSize);
                                    System.out.println(ret);
                                    return JSON.toJSONString(ret);
                                }else{

                                    return fileName;
                                }

                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("error:"+e.getMessage());
                }
            }

        }
        return val;
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
