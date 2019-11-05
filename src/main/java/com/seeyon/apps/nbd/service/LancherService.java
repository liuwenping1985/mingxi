package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.entity.*;
import com.seeyon.apps.nbd.core.service.NbdBpmnService;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.platform.oa.SubEntityFieldParser;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairDaoImpl;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairManagerImpl;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;
import com.seeyon.ctp.util.TextEncoder;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.v3x.services.flow.FlowUtil;
import org.apache.commons.lang.StringUtils;
import org.springframework.util.CollectionUtils;


import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class LancherService {

    private ServiceConfigMain configMain;

    private NbdBpmnService nbdBpmnService;


    private ColManager colManager;

    private AffairManager affairManager;

    private OrgManager orgManager;

    private FormManager formManager;

    public FormManager getFormManager(){
        if(this.formManager == null) {
            this.formManager = (FormManager)AppContext.getBean("formManager");
        }

        return this.formManager;

    }

    public LancherService(){
        this.nbdBpmnService =  new NbdBpmnService();

    }

    public ColManager getColManager() {
        if(this.colManager == null) {
            this.colManager = (ColManager)AppContext.getBean("colManager");
        }

        return this.colManager;
    }
    public AffairManager getAffairManager() {
        if(this.affairManager == null) {
            this.affairManager = (AffairManager)AppContext.getBean("affairManager");
        }

        return this.affairManager;
    }
    public OrgManager getOrgManager() {
        if(this.orgManager == null) {
            this.orgManager = (OrgManager)AppContext.getBean("orgManager");
        }

        return this.orgManager;
    }




    public CommonDataVo receiveAffair(CommonParameter parameter) {
        CommonDataVo vo =  new CommonDataVo();
        String affairType = (String)parameter.get("affairType");
        String affairId = parameter.$("affair_id");
        if(null == affairId){
            vo.setResult(false);
            vo.setMsg("affair_id 没有传入！");
            vo.setData(parameter);
            return vo;
            //com.seeyon.ctp.workflow.designer.controller.WorkFlowDesignerController
        }
        ServiceAffairs affairs = getServiceAffairs(affairType);
        ServiceAffair affair = affairs.getAffairHolder().get("receive");
        try {
            Map data = new HashMap();
            String templeteCode = affair.getFormTempleteCode();
            Map param = genCollaborationParam(parameter,affair);

            Long flowId =  nbdBpmnService.sendCollaboration(templeteCode,param);
            data.put("id",flowId);
            List<Attachment> attachments = parameter.getAttachmentList();
            if(!CollectionUtils.isEmpty(attachments)){
                for(Attachment att:attachments){
                    att.setReference(flowId);
                    try {
                        String attName = att.getFilename();
                        System.out.println(attName);
                        //attName.replaceAll("/./.",".")
                        att.setFilename(URLDecoder.decode(att.getFilename(), "UTF-8"));
                    }catch(Exception e){

                    }
                }
                DBAgent.updateAll(attachments);
                /**
                 * 暴力一点吧 没办法了
                 */
                insertOtherAttachment(attachments);
            }
            String key = affairType+"_"+affairId;
            DataBaseHandler.getInstance().putData(key,flowId);
            DataBaseHandler.getInstance().putData("flow"+flowId,key);
            vo.setData(data);
            vo.setResult(true);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if(!StringUtils.isEmpty(msg)){
                vo.setMsg("错误-发起流程失败--错误原因为:"+msg);
            }else{
                vo.setMsg("错误-发起流程失败");
            }

            vo.setResult(false);

        }
        return vo;
    }

    private void insertOtherAttachment(List<Attachment> attachments){


        String table_name = ConfigService.getPropertyByName("filesubForm","formson_0231");
        // System.out.println(table_name);
        StringBuilder querySQL = new StringBuilder("select * from ");
        querySQL.append(table_name);
        StringBuilder inStatement = new StringBuilder();
        inStatement.append("(");
        int tag =0;

        for(Attachment att:attachments){
            if(tag == 0){
                inStatement.append(att.getSubReference());
            }else{
                inStatement.append(",").append(att.getSubReference());
            }
            tag++;


        }
        inStatement.append(")");
        querySQL.append(" where field0024 in ");
        querySQL.append(inStatement);
        //   System.out.println(querySQL);
        JDBCAgent agent = new JDBCAgent();
        try {

            agent.execute(querySQL.toString());
            Map<String,String> existInsertMap = new HashMap<String, String>();
            List retList = agent.resultSetToList(true);
            List<String> insertSQLList = new ArrayList<String>();
            StringBuilder insertSQLPre = new StringBuilder();
            insertSQLPre.append("insert into ").append(table_name);
            insertSQLPre.append("(id,formmain_id,sort,field0024)values");
            Object formmainId=null;
            // System.out.println(retList);
            if(retList != null&&retList.size()>0){
                for(Object obj:retList){
                    Map data = (Map)obj;
                    //  System.out.println(data);
                    formmainId = data.get("formmain_id");
                    existInsertMap.put(String.valueOf(data.get("field0024")),"1");
                }
                //  System.out.println("formmain_id:"+formmainId);
                //   System.out.println("----------------------------");
                if(formmainId!=null) {
                    int sort =1;
                    for (Attachment att : attachments) {
                        String isExist = existInsertMap.get(String.valueOf(att.getSubReference()));
                        if(isExist!=null){
                            continue;
                        }
                        StringBuilder insql = new StringBuilder();
                        insql.append(insertSQLPre.toString());
                        insql.append("(").append(UUIDLong.longUUID()).append(","+formmainId+",");
                        insql.append(sort).append(",").append(att.getSubReference()).append(")");
                        insertSQLList.add(insql.toString());
                        sort++;
                    }
                    if(!CollectionUtils.isEmpty(insertSQLList)){

                        agent.executeBatch(insertSQLList);
                    }
                }
            }


        }catch(Exception e){
            e.printStackTrace();
        }finally {
            agent.close();
        }
    }

    private Map genCollaborationParam(CommonParameter inputParameter,ServiceAffair affair){

        Map param = new HashMap();
        String title = inputParameter.$("title");
        param.put("subject",title);
        param.put("transfertype","json");
        String senderLoginName = inputParameter.$("sender");
        param.put("senderLoginName",senderLoginName);
        List<Attachment> attachmentList = inputParameter.getAttachmentList();
        List<Long> attachments = new ArrayList<Long>();
        if(!CollectionUtils.isEmpty(attachmentList)){

            for(Attachment attachment:attachmentList){
                attachments.add(attachment.getId());
            }
            param.put("attachments",attachments);
            param.put("formContentAtt",attachments);
        }

        String data = genData(inputParameter,affair);
        param.put("data",data);
        param.put("param","0");
        return param;
    }
    private static Object unicodeStr2String(Object unicodeStrInput) {
        if(!(unicodeStrInput instanceof String)){

            return unicodeStrInput;

        }
        String unicodeStr = (String)unicodeStrInput;
        int length = unicodeStr.length();
        int count = 0;
        //正则匹配条件，可匹配“\\u”1到4位，一般是4位可直接使用 String regex = "\\\\u[a-f0-9A-F]{4}";
        String regex = "\\\\u[a-f0-9A-F]{4}";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(unicodeStr);
        StringBuffer sb = new StringBuffer();

        while (matcher.find()) {
            String oldChar = matcher.group();//原本的Unicode字符
            //System.out.println(oldChar);
            String newChar = unicode2String(oldChar);//转换为普通字符
            //System.out.println(newChar);
            // System.out.println(sb.toString().length());
            int index = unicodeStr.indexOf(oldChar);
            //System.out.println("count:"+count+",index:"+index+",sblenght:"+sb.toString().length());
            while(count>index){
                index = index+4+unicodeStr.substring(index+4, unicodeStr.length()).indexOf(oldChar);
            }


            sb.append(unicodeStr.substring(count, index));//添加前面不是unicode的字符
            sb.append(newChar);//添加转换后的字符
            count = index + oldChar.length();//统计下标移动的位置
        }
        sb.append(unicodeStr.substring(count, length));//添加末尾不是Unicode的字符
        return sb.toString();


    }
    private static String unicode2String(String unicode) {
        StringBuffer string = new StringBuffer();
        String[] hex = unicode.split("\\\\u");

        for (int i = 1; i < hex.length; i++) {
            // 转换出每一个代码点
            int data = Integer.parseInt(hex[i], 16);
            // 追加成string
            string.append((char) data);
        }

        return string.toString();
    }


    private String genData(CommonParameter inputParameter,ServiceAffair affair){

        Mapping mapping = affair.getMaping();
        String content = inputParameter.$("content");
        if(StringUtils.isEmpty(content)){
            return "";
        }else{
            try {
                content = URLDecoder.decode(content,"UTF-8");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        Map param = new HashMap();
        Map inputData = JSON.parseObject(content,HashMap.class);
        Entity entity = mapping.getEntity();
        List<FieldMeta> fields = entity.getFields();
        if(!CollectionUtils.isEmpty(fields)){
            for(FieldMeta meta:fields){
                setData(meta,param,inputData);
            }
        }
        // System.out.println("parse--sub-entity");
        List<OriginalField> ofList = entity.getOriginalFields();

        if(!CollectionUtils.isEmpty(ofList)){
            //   System.out.println("parse--sub2-entity");
            for(OriginalField meta:ofList){
                Entity subEntity =  meta.getEntity();

                if(subEntity!=null){
                    //System.out.println("parse--sub3-entity");
                    if(!StringUtils.isEmpty(subEntity.getParse())){
                        //System.out.println("parse--sub4-entity");
                        String parse = subEntity.getParse();
                        //System.out.println("parse--sub5-entity:"+parse);
                        try {
                            Class cls = Class.forName(parse);
                            Object instance = cls.newInstance();
                            if(instance instanceof SubEntityFieldParser){
                                //System.out.println("parse--sub6-entity");
                                SubEntityFieldParser parser = (SubEntityFieldParser)instance;
                                //System.out.println("----coming----");
                                parser.parse(inputParameter,param,inputData,subEntity);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    }else{
                        Map subParam = new HashMap();
                        List<FieldMeta> subFields = subEntity.getFields();
                        for(FieldMeta meta2:subFields){
                            setData(meta2,subParam,inputData);
                        }
                        Object sub = param.get("sub");
                        if(sub == null){
                            sub = new ArrayList<Map>();
                            param.put("sub",sub);
                        }
                        ((List)sub).add(subParam);
                    }

                }
            }

        }

        return JSON.toJSONString(param);
    }

    private void setData(FieldMeta meta,Map dataMap,Map inputData){
        String source = meta.getSource();
        String name = meta.getName();
        if(!StringUtils.isEmpty(source)&&!StringUtils.isEmpty(name)){

            dataMap.put(name,unicodeStr2String(inputData.get(source)));
        }
    }

    public CommonDataVo getAffair(CommonParameter parameter) {
//
//        CommonDataVo vo = new CommonDataVo();
//        String affairId = parameter.$("affair_id");
//        String affairType = parameter.$("affairType");
//        String id = parameter.$("id");
//        String summaryId = "";
//        if(!StringUtils.isEmpty(id)){
//            // FlowFactoryImpl fl;
//            //
//            //  FlowUtil.getFlowState()
//            // DataBaseHandler.getInstance().getDataByKey()
//            summaryId = id;
//        }else{
//
//            if(StringUtils.isEmpty(affairType)){
//                vo.setResult(false);
//                vo.setMsg("affairType不能为空");
//                return vo;
//            }
//            if(StringUtils.isEmpty(affairId)){
//                vo.setResult(false);
//                vo.setMsg("affair_id不能为空");
//                return vo;
//            }
//            String key = affairType+"_"+affairId;
//            Object obj =  DataBaseHandler.getInstance().getDataByKey(key);
//            summaryId = String.valueOf(obj);
//        }
//        if(StringUtils.isEmpty(summaryId)){
//            vo.setResult(false);
//            vo.setMsg("根据传入的参数无法找到数据");
//        }else{
//
//            //FlowFactoryImpl impl;
//            //impl.getFlowState()
//
//            try {
//                ColSummary summary = this.getColManager().getColSummaryById(Long.valueOf(summaryId));
//                AffairManagerImpl impl;
//                AffairDaoImpl dao;
//                List<CtpAffair> affairs = getAffairManager().getAffairs(ApplicationCategoryEnum.collaboration, summary.getId());
//                Map data = new HashMap();
//                List<CtpAffair> currentAffairList = new ArrayList<CtpAffair>();
//                int state=0;
//                int doneCount = 0;
//                //FlowUtil.getFlowState()
//                for(CtpAffair affair:affairs){
//                    if(affair.getState().intValue() == StateEnum.col_done.key()){
//                        // affair.
//                        ++doneCount;
//                        continue;
//                    }else if(affair.getState().intValue() == StateEnum.col_cancel.key() && !affair.isDelete().booleanValue()) {
//                        state = FlowUtil.FlowState.cancle.getKey();
//                    }else if(affair.getState().intValue() ==  StateEnum.col_pending.key() && !affair.isDelete().booleanValue()) {
//                        state = FlowUtil.FlowState.run.getKey();
//                        currentAffairList.add(affair);
//                    }
//
//
//                }
//                if(doneCount == 0) {
//                    state = FlowUtil.FlowState.pendDone.getKey();
//                }
//                data.put("state",state);
//                data.put("title",summary.getSubject());
//
//                if(!CollectionUtils.isEmpty(currentAffairList)){
//
//                    String url="/seeyon/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="+currentAffairList.get(0).getId();
//                    data.put("url",url);
//                    // CtpAffair affair = currentAffairList.get(0);
//                    StringBuilder stb = new StringBuilder("");
//                    StringBuilder stbName = new StringBuilder("");
//                    StringBuilder stbdept = new StringBuilder("");
//                    List<Map> currentUserList = new ArrayList<Map>();
//                    for(CtpAffair ctpAffair:currentAffairList){
//                        V3xOrgMember member =  this.getOrgManager().getMemberById(ctpAffair.getMemberId());
//                        V3xOrgDepartment department = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
//                        Map curUser = new HashMap();
//                        curUser.put("userLoginName",member.getLoginName());
//                        curUser.put("name",member.getName());
//                        curUser.put("department",department.getName());
////                        if("".equals(stb.toString())){
////                            stb.append(member.getLoginName());
////                            stbName.append(member.getName());
////                            stbdept.append(department.getName());
////                            curUser.put("userLoginName",member.getLoginName());
////                            curUser.put("name",member.getName());
////                            curUser.put("department",department.getName());
////                        }else{
////                            stb.append(",").append(member.getLoginName());
////                            stbName.append(",").append(member.getName());
////                            stbdept.append(",").append(department.getName());
////                        }
//                        currentUserList.add(curUser);
//
//                    }
////                    data.put("currentUserName",stbName.toString());
////                    data.put("currentUserDepartmentName",stbdept.toString());
//                    data.put("currentUser",currentUserList);
//                }
//                //com.seeyon.ctp.privilege.manager.PrivilegeMenuManagerImpl impl;
//                vo.setData(data);
//                vo.setResult(true);
//                // PrivilegeCacheImpl impl2;
//                //MenuDaoImpl dap;
//
//            } catch (BusinessException e) {
//                e.printStackTrace();
//            }
//        }


        return null;
    }

    public CommonDataVo deleteAffair(CommonParameter parameter) {
        CommonDataVo vo = new CommonDataVo();

        return vo;
    }

    public CommonDataVo processAffair(CommonParameter parameter) {
        CommonDataVo vo = new CommonDataVo();

        return vo;
    }

    public List<String> getServiceTypes(CommonParameter parameter) {
        return null;
    }

    public ServiceAffairs getServiceAffairs(String affairType){
        if(StringUtils.isEmpty(affairType)){
            return null;
        }
        List<ServiceAffairs> sasList = this.configMain.getAffairsList();
        if(!CollectionUtils.isEmpty(sasList)){
            for(ServiceAffairs affairs:sasList){
                if(affairType.equals(affairs.getName())){
                    return affairs;
                }

            }
        }
        return null;
    }
    public boolean containAffairType(String affairType) {
        if(StringUtils.isEmpty(affairType)){
            return false;
        }
        List<ServiceAffairs> sasList = this.configMain.getAffairsList();
        if(!CollectionUtils.isEmpty(sasList)){
            for(ServiceAffairs affairs:sasList){
                if(affairType.equals(affairs.getName())){
                    return true;
                }

            }
        }
        return false;
    }
    public static void main(String[] args) throws UnsupportedEncodingException {

        String input = "BR-%E8%AE%A1%E8%B4%B9%E5%87%86%E7%A1%AE%E6%80%A7%E8%B0%83%E6%95%B4%E6%96%B9%E6%A1%88%E7%9B%B8%E5%85%B3%E9%9C%80%E6%B1.docx";

        System.out.println(TextEncoder.decode("/1.0/MjM0NTY3ODk="));
        //System.out.println(unicodeStr2String(URLDecoder.decode(input,"UTF-8")));

    }


}
