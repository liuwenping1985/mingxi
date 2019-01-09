package com.seeyon.apps.nbd.plugin.als.service.impl;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.form.entity.SimpleFormField;
import com.seeyon.apps.nbd.core.log.LogBuilder;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.service.impl.MappingServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.plugin.als.po.A8OutputVo;
import com.seeyon.apps.nbd.plugin.als.service.AbstractAlsServicePlugin;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONObject;
import org.json.XML;

import java.io.File;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by liuwenping on 2018/9/7.
 */
public class AlsServicePluginImpl extends AbstractAlsServicePlugin {
    private static final Log log222 = LogFactory.getLog(AlsServicePluginImpl.class);

    private LogBuilder log = new LogBuilder("Export_LOG");
    private EnumManager enumManager;

    private OrgManager orgManager;

    private FileManager fileManager = (FileManager) AppContext.getBean("fileManager");

    private MappingServiceManager manager = new MappingServiceManagerImpl();

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

    private static Map<String, String> mappingTable = new HashMap<String, String>();

    static {
        mappingTable.put("formmain_2571", "FK0002");
        mappingTable.put("formmain_1841", "FK0003");
        mappingTable.put("formmain_1415", "FK0004");
        mappingTable.put("formmain_0111", "FK0005");
        mappingTable.put("formmain_0998", "FK0001");
        mappingTable.put("formmain_0025", "HT0005");
        mappingTable.put("formmain_1455", "HT0006");
        mappingTable.put("formmain_1626", "HT0007");
        mappingTable.put("formmain_2434", "HT0002");
        mappingTable.put("formmain_0845", "HT0004");
        mappingTable.put("formmain_2660", "HT0001");


    }

    class syncThread extends TimerTask {


        public void run() {
            try {

                System.out.println(1);

            } catch (Exception e) {

            } catch (Error e) {


            }


        }
    }

    public AlsServicePluginImpl() {
        //Timer timer = new Timer();
       // timer.schedule(new syncThread(), 5000,  2* 1000);

    }

    public List<String> getSupportAffairTypes() {
        return this.getPluginDefinition().getSupportAffairTypes();
    }

    public Map<String, List<A8OutputVo>> exportAllData() {
        Map<String, List<A8OutputVo>> ret = new HashMap<String, List<A8OutputVo>>();
        List<String> allSupports = this.getPluginDefinition().getSupportAffairTypes();
        for (String arrairType : allSupports) {
            try {
                List<A8OutputVo> afList = exportData(arrairType);
                ret.put(arrairType, afList);
                if (!CommonUtils.isEmpty(afList)) {
                    DBAgent.saveAll(afList);
                }
            } catch (Exception e) {
                e.printStackTrace();
                ret.put(arrairType, new ArrayList<A8OutputVo>());
            }
        }
        return ret;
    }

    public List<A8OutputVo> exportDataSingle(String affairType, Long formRecrodId) {
        List<A8OutputVo> dataList = new ArrayList<A8OutputVo>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = ftd.genAllQuery();
        sql += " where t.id=" + formRecrodId;
        log.log(sql);
        try {
            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(sql);
            log.log(ftd.getFormTable().getName() + "master table data size:" + list.size());
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables) && !CommonUtils.isEmpty(list)) {
                //create temp master table container

                Map<Long, Map> masterTempMap = new HashMap<Long, Map>();
                for (Map masterMap : list) {
                    Object id = masterMap.get("id");

                    if (id != null) {
                        Long key = getLong(id);
                        masterTempMap.put(key,masterMap);
                    }

                }
                //System.out.println("master map:" + masterTempMap.values().size());
                for (FormTable ft : slaveTables) {
                    log.log("[<---->]export slave table:" + ft.getName());
                    String slaveTableSql = FormTableDefinition.genRawAllQuery(ft)+" where formmain_id="+formRecrodId ;
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
                                Long key = getLong(fmId);
                                Map masterMap = masterTempMap.get(key);
                                if (!CommonUtils.isEmpty(masterMap)) {
                                    //getDisplayText
                                    for (Object skey : slaveTableMap.keySet()) {
                                        slaveTableMap.put(skey, getDisplayTextByValue(null,"" + skey, "", slaveTableMap.get(skey)));

                                    }
                                    List<Map> slaveMaps = (List<Map>) masterMap.get(ft.getDisplay());
                                    if (slaveMaps == null) {
                                        slaveMaps = new ArrayList<Map>();
                                        masterMap.put(ft.getDisplay(), slaveMaps);

                                    }
                                    slaveMaps.add(slaveTableMap);
                                    if (tag == 0) {
                                        //System.out.println(slaveTableMap);
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
            log.log("dataList:"+dataList.size());
            return dataList;
        } catch (Exception e) {
            log222.error(e.getMessage(),e);
            e.printStackTrace();
        }
       // log.log(" end of export master table");
        return dataList;

    }
    private Long getLong(Object fmId){
        Long key = null;
        if (fmId instanceof Long) {
            key = (Long) fmId;
        } else if (fmId instanceof BigDecimal) {
            key = ((BigDecimal) fmId).longValue();
        } else {
            key = Long.parseLong(String.valueOf(fmId));
        }
        return key;
    }
    public List<A8OutputVo> exportData(String affairType) {
        List<A8OutputVo> dataList = new ArrayList<A8OutputVo>();
        if (!this.getSupportAffairTypes().contains(affairType)) {
            throw new UnsupportedOperationException();
        }
        FormTableDefinition ftd = this.getFormTableDefinition(affairType);
        String sql = FormTableDefinition.genRawAllQuery(ftd.getFormTable());

        try {
            //这里增加逻辑
            String s_sql = sql + " where finishedflag=1 and id not in (select source_id from A8FK2YW where type='" + affairType + "')";
            // List<Map> idList = DataBaseHelper.executeQueryByNativeSQL(s_sql);
            //Map<Long,Object> idMap

            List<Map> list = DataBaseHelper.executeQueryByNativeSQL(s_sql);
            log.log(ftd.getFormTable().getName() + "master table data size:" + list.size());
            List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
            if (!CommonUtils.isEmpty(slaveTables) && !CommonUtils.isEmpty(list)) {
                //create temp master table container

                Map<Long, Map> masterTempMap = new HashMap<Long, Map>();
                for (Map masterMap : list) {
                    Object id = masterMap.get("id");
                    if (id != null) {
                        Long key = getLong(id);
                        masterTempMap.put(key,masterMap);
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
                                Long key = getLong(fmId);
//                                if (fmId instanceof Long) {
//                                    key = (Long) fmId;
//                                } else if (fmId instanceof BigDecimal) {
//                                    key = ((BigDecimal) fmId).longValue();
//                                } else {
//                                    key = Long.parseLong(String.valueOf(fmId));
//                                }
                                Map masterMap = masterTempMap.get(key);
                                if (!CommonUtils.isEmpty(masterMap)) {
                                    //getDisplayText
                                    for (Object skey : slaveTableMap.keySet()) {
                                        slaveTableMap.put(skey, getDisplayTextByValue(null,"" + skey, "", slaveTableMap.get(skey)));

                                    }
                                    List<Map> slaveMaps = (List<Map>) masterMap.get(ft.getDisplay());
                                    if (slaveMaps == null) {
                                        slaveMaps = new ArrayList<Map>();
                                        masterMap.put(ft.getDisplay(), slaveMaps);

                                    }
                                    slaveMaps.add(slaveTableMap);
                                    if (tag == 0) {
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

    /**
     * 这个地方你懂得
     *
     * @param affair
     * @return
     */
    public List<A8OutputVo> exportData(CtpAffair affair) {

        Long templateId = affair.getTempleteId();
        log.log("templateId:"+templateId);
        if (templateId != null) {
            String sql = "select * from form_definition where id = (select  CONTENT_TEMPLATE_ID from ctp_content_all where id =(select BODY from ctp_template where id=" + templateId + "))";
            try {
                List<Map> retList = DataBaseHelper.executeQueryByNativeSQL(sql);
                if (CommonUtils.isEmpty(retList)) {
                    return null;
                }
                Map defin = retList.get(0);
                String fieldInfo = (String) defin.get("field_info");
                JSONObject jsonObject = XML.toJSONObject(fieldInfo);
                Map data = JSON.parseObject(jsonObject.toString(), HashMap.class);
                FormTableDefinition ftd = manager.parseFormTableMapping(data);
                //只是为了得个表名
                String tbName = ftd.getFormTable().getName().toLowerCase();
                log.log("tbName:"+tbName);
                String affairType = mappingTable.get(tbName);
                log.log("affairType:"+affairType);
                if (!CommonUtils.isEmpty(affairType)) {

                    Long summaryId = affair.getObjectId();

                    ColManager colManager = (ColManager) AppContext.getBean("colManager");
                    ColSummary summary = colManager.getSummaryById(summaryId);
                    Long formRecordId = summary.getFormRecordid();
                    List<A8OutputVo> dataList = exportDataSingle(affairType, formRecordId);
                    if (!CommonUtils.isEmpty(dataList)) {
                        log.log("SAVED-SAVED-SAVED");
                        A8OutputVo vo = dataList.get(0);
                        JDBCAgent agent = new JDBCAgent();
                        String insert = "insert into A8FK2YW(id,subject,data,source_id,createdate,type,status,updatedate)values(?,?,?,?,?,?,?,?)";
                        //agent.execute()
                        //DBAgent.save(dataList.get(0));
                       // DBAgent.save(dataList.get(0))
                        List params = new ArrayList();
                        params.add(vo.getId());
                        params.add(vo.getSubject());
                        params.add(vo.getData());
                        params.add(vo.getSourceId());
                        params.add(vo.getCreateDate());
                        params.add(vo.getType());
                        params.add(vo.getStatus());
                        params.add(vo.getUpdateDate());
                        try {
                            int state = agent.execute(insert, params);
                            log.log("AFTER-SAVED-SAVED:"+state);
                        }catch(Exception e){
                            log.log("exception-message:"+e.getMessage());
                            log222.error(e.getMessage(),e);
                            e.printStackTrace();
                        }finally {
                            agent.close();
                        }

                    }

                }

            } catch (Exception e) {
                log.log("exception-message:"+e.getMessage());
                log222.error(e.getMessage(),e);
                e.printStackTrace();
            }


        }else{

            //LOG

        }


        return null;
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
        for (SimpleFormField sff : sffList) {
            if (sff.getName().toLowerCase().equals("id")) {
                vo.setSourceId(CommonUtils.paserLong(sff.getValue()));
            }
        }
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
            dataMap.put(sff.getDisplay(), getDisplayText(vo.getSourceId(),sff));
        }
        vo.setData(JSON.toJSONString(dataMap));
        vo.setIdIfNew();
        return vo;
    }

    private Object getDisplayText(Long dataId,SimpleFormField sff) {
        Object val = sff.getValue();
        return getDisplayTextByValue(dataId,sff.getDisplay(), sff.getClassName(), val);
    }

    private Object getDisplayTextByValue(Long formDataId,String displayName, String className, Object val) {
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
            if (sid.intValue() >= 0 && sid.intValue() <= 10000) {
                return val;
            }

        } catch (Exception e) {

        }
        try {
            if (DataBaseHandler.getInstance().isEnumExist(sid)) {
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
                    List<Map> dataList = getFiles(formDataId,sid);
                    if (!CommonUtils.isEmpty(dataList)) {
                        Map<String, Map> checkFilesMap = new HashMap<String, Map>();
                        for (Map dts : dataList) {
                            Object fileIdRaw = dts.get("file_url");
                            String key = String.valueOf(fileIdRaw);
                            Map ckMap = checkFilesMap.get(key);
                            if (ckMap == null) {
                                checkFilesMap.put(key, dts);
                            }
                        }
                        List<Map> files = new ArrayList<Map>();
                        for (Map fileMap : checkFilesMap.values()) {

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
                                        files.add(ret);
                                        ;
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
    private static final Map<String,String> colSummaryIdMap = new HashMap<String,String>();


    private synchronized List<Map> getDataByCache() {
        if (fileDataList.isEmpty()) {
            String sql = "select * from ctp_attachment";
            try {
                List<Map> dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
                if (dataList == null || CommonUtils.isEmpty(dataList)) {
                    return fileDataList;
                }
                fileDataList.addAll(dataList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return fileDataList;
    }
    private synchronized Map getColSummaryDataCache() {
        if (colSummaryIdMap.isEmpty()) {
            String sql = "SELECT id,form_recordid FROM col_summary WHERE form_recordid is not null";
            try {
                List<Map> dataList = DataBaseHelper.executeQueryByNativeSQL(sql);
                if (dataList == null || CommonUtils.isEmpty(dataList)) {
                    return colSummaryIdMap;
                }
                for(Map data:dataList){
                    colSummaryIdMap.put(data.get("form_recordid").toString(),data.get("id").toString());
                }
                //colSummaryDataList.addAll(dataList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return colSummaryIdMap;
    }

    private List<Map> getFiles(Long formDataId,Long id) {

        List<Map> dataList = this.getDataByCache();
        List<Map> retList = new ArrayList<Map>();
        Map<String,String> summaryIdMap = getColSummaryDataCache();
        for (Map map : dataList) {
            Long fid = CommonUtils.getLong(map.get("id"));
            Long referenceId = CommonUtils.getLong(map.get("reference"));
            Long subReferenceId = CommonUtils.getLong(map.get("sub_reference"));
            if (id.equals(fid) || id.equals(referenceId) || id.equals(subReferenceId)) {
                if(formDataId!=null){
                    String val = summaryIdMap.get(String.valueOf(formDataId));
                    if(val!=null){
                        if(val.equals(String.valueOf(referenceId))){
                            retList.add(map);
                        }
                    }else{
                        retList.add(map);
                    }

                }else{
                    retList.add(map);
                }


            }

        }
        if(CommonUtils.isEmpty(retList)){
            String sql = "select * from ctp_attachment where reference="+id+" or sub_reference="+id;
            try {
               List<Map> dataMap =  DataBaseHelper.executeQueryByNativeSQL(sql);
               return dataMap;
            } catch (Exception e) {
                e.printStackTrace();
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

    public static void main(String[] args) {
        //<TableList>    <Table id="-2597545628270901579" name="formmain_0080" display="formmain_0005" tabletype="master" onwertable="" onwerfield="">        <FieldList>            <Field id="2472960954853442624" name="id" display="id" fieldtype="long" fieldlength="20" is_null="true" is_primary="true" classname=""/>            <Field id="4918802969136615163" name="state" display="审核状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>             <Field id="5275691187212012286" name="start_member_id" display="发起人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>            <Field id="4604159390915903979" name="start_date" display="发起时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>            <Field id="-2370519779571646318" name="approve_member_id" display="审核人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>            <Field id="-4126955320246318274" name="approve_date" display="审核时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>            <Field id="-4914733194421911117" name="finishedflag" display="流程状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>            <Field id="2068830263587916098" name="ratifyflag" display="核定状态" fieldtype="int" fieldlength="10" is_null="true" is_primary="false" classname=""/>            <Field id="-5979099454044222143" name="ratify_member_id" display="核定人" fieldtype="long" fieldlength="20" is_null="true" is_primary="false" classname=""/>            <Field id="-2531679393628142183" name="ratify_date" display="核定时间" fieldtype="DATETIME" fieldlength="" is_null="true" is_primary="false" classname=""/>                                    <Field id="586797023731272028" name="field0001" display="填表日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-1980379085442102920" name="field0002" display="部门" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-5753443324817094769" name="field0003" display="申请人姓名" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-7775203168153943677" name="field0004" display="年假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="-116219757259243054" name="field0005" display="倒休假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="1757172507400357123" name="field0006" display="带薪休假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="3713848733577596829" name="field0007" display="婚假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="-8358100921500676742" name="field0008" display="丧假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="2907510175771476870" name="field0009" display="产检假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="1455170563657253849" name="field0010" display="围产假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="8961940481896172731" name="field0011" display="产假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="-2473236689200463842" name="field0012" display="工伤假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="6456245037069257083" name="field0013" display="哺乳假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="-4189219693626045000" name="field0014" display="计划生育假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="3421023139819176358" name="field0015" display="公益日假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="574799651101757438" name="field0016" display="病假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="-7332386369166357271" name="field0017" display="事假" fieldtype="VARCHAR" fieldlength="5,0" is_null="false" is_primary="false" classname=""/>            <Field id="2863864576265504530" name="field0018" display="休假共计" fieldtype="DECIMAL" fieldlength="20,1" is_null="false" is_primary="false" classname=""/>            <Field id="3375014453023296274" name="field0019" display="上级主管意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="-2554144471288100481" name="field0020" display="上级主管签字" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="9077280452612867983" name="field0021" display="上级主管日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-1370326112799997099" name="field0022" display="人力资源意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="3015315429985109715" name="field0023" display="人力签字" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="6864642567839171224" name="field0024" display="人力日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-808851486511707201" name="field0025" display="运营总监意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="5705973824074892790" name="field0026" display="运营总监签字" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="7350831072534020706" name="field0027" display="运营总监日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-2779601386022090838" name="field0028" display="秘书长意见" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="-7531451036732996143" name="field0029" display="秘书长签字" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-2680253744008904249" name="field0030" display="秘书长日期" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="1985208297296908085" name="field0034" display="休假说明" fieldtype="LONGTEXT" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-1272491093482975633" name="field0035" display="休假时间起" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-6169042518582147009" name="field0036" display="休假时间止" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-3665107992161665007" name="field0038" display="总监" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="-8844055543243650120" name="field0039" display="副秘书长" fieldtype="VARCHAR" fieldlength="4000,0" is_null="false" is_primary="false" classname=""/>            <Field id="947564276115457444" name="field0037" display="作废1" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>        </FieldList>        <IndexList>        </IndexList>    </Table>    <Table id="-767767086808284788" name="formson_0081" display="组4" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">        <FieldList>            <Field id="-1410036640100102408" name="field0031" display="休假起" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-1937935550336643364" name="field0032" display="休假止" fieldtype="TIMESTAMP" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="7955580652210441049" name="field0033" display="休假类型说明" fieldtype="VARCHAR" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>        </FieldList>        <IndexList>        </IndexList>    </Table>    <Table id="0" name="formson_2736" display="组6" tabletype="slave" onwertable="formmain_0080" onwerfield="formmain_id">        <FieldList>            <Field id="8813799841310196994" name="field0040" display="休假开始时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-7169593202535412810" name="field0041" display="休假结束时间" fieldtype="DATETIME" fieldlength="255,0" is_null="false" is_primary="false" classname=""/>            <Field id="-886899757936981143" name="field0042" display="天数" fieldtype="DECIMAL" fieldlength="20,1" is_null="false" is_primary="false" classname=""/>        </FieldList>        <IndexList>        </IndexList>    </Table>  </TableList>
        //AlsServicePluginImpl
//        InputStream io = ProcessEventHandler.class.getResourceAsStream("tt.xml");
//        try {
//            String xml = IOUtils.toString(io);
//            //System.out.println(xml);
//            MappingServiceManager manager = new MappingServiceManagerImpl();
//            JSONObject xmlJSONObj = XML.toJSONObject(xml);
//            Map data = JSON.parseObject(xmlJSONObj.toString(),HashMap.class);
//            FormTableDefinition ftd = manager.parseFormTableMapping(data);
//            String sql = ftd.genAllQuery();
//            sql+= " where t.id="+1;
//            System.out.println(sql);
//        } catch (IOException e) {
//            e.printStackTrace();
//        } catch (JSONException e) {
//            e.printStackTrace();
//        }


        //Thread.currentThread().setDaemon(true);

    }
}
