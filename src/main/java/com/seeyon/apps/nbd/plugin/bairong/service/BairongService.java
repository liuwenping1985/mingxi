package com.seeyon.apps.nbd.plugin.bairong.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.collaboration.manager.ColManager;
import com.seeyon.apps.collaboration.po.ColSummary;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.entity.*;
import com.seeyon.apps.nbd.core.service.ServicePlugin;
import com.seeyon.apps.nbd.core.vo.CommonDataVo;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.platform.bpm.NbdBpmnService;
import com.seeyon.apps.nbd.platform.oa.SubEntityFieldParser;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairDao;
import com.seeyon.ctp.common.content.affair.AffairDaoImpl;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairManagerImpl;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.form.bean.FormBean;
import com.seeyon.ctp.form.bean.FormDataMasterBean;
import com.seeyon.ctp.form.bean.FormDataSubBean;
import com.seeyon.ctp.form.bean.FormTableBean;
import com.seeyon.ctp.form.service.FormManager;
import com.seeyon.ctp.form.service.FormService;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.sso.thirdpartyintegration.controller.ThirdpartyController;
import com.seeyon.ctp.privilege.dao.MenuDaoImpl;
import com.seeyon.ctp.privilege.dao.PrivilegeCacheImpl;
import com.seeyon.ctp.privilege.dao.RoleMenuDaoImpl;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.v3x.services.document.DocumentFactory;
import com.seeyon.v3x.services.flow.FlowFactory;
import com.seeyon.v3x.services.flow.FlowService;
import com.seeyon.v3x.services.flow.FlowUtil;
import com.seeyon.v3x.services.flow.impl.FlowFactoryImpl;
import com.seeyon.v3x.services.flow.impl.FlowServiceImpl;
import com.seeyon.v3x.services.form.FormUtils;
import org.apache.cxf.resource.DefaultResourceManager;
import org.hibernate.SessionFactory;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by liuwenping on 2018/8/20.
 */
public class BairongService implements ServicePlugin {

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

    public BairongService(ServiceConfigMain config){
        this.configMain = config;
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


        try {
            FormBean fb = getFormManager().getFormByFormCode("HT0002");
            List<FormTableBean> list = fb.getSubTableBean();
            //this.getFormManager().get
            ColSummary summary = this.getColManager().getSummaryById(7024609399219550905L);
            Long formRecordId = summary.getFormRecordid();
            Long formId = summary.getFormAppid();
            try {
                FormDataMasterBean data = FormService.findDataById(formRecordId.longValue(), formId.longValue());

                System.out.println("----sub-sub-sub----"+data.toJSON());
                Map<String, List<FormDataSubBean>> subData = data.getSubTables();
                for(String key:subData.keySet()){
                    List<FormDataSubBean> listFormDataSubBean = subData.get(key);
                    for(FormDataSubBean bean:listFormDataSubBean){
                        System.out.println("--------");
                        System.out.println(bean.toJSON());
                        System.out.println("----------");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        String affairType = (String)parameter.get("affairType");
        String affairId = parameter.$("affair_id");
        if(null == affairId){
            vo.setResult(false);
            vo.setMsg("affair_id 没有传入！");
            vo.setData(parameter);
            return vo;

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
                    att.setFilename(URLDecoder.decode(att.getFilename(),"UTF-8"));
                }
                DBAgent.updateAll(attachments);
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
        System.out.println("parse--sub-entity");
        List<OriginalField> ofList = entity.getOriginalFields();

        if(!CollectionUtils.isEmpty(ofList)){
            System.out.println("parse--sub2-entity");
            for(OriginalField meta:ofList){
                Entity subEntity =  meta.getEntity();

                if(subEntity!=null){
                    System.out.println("parse--sub3-entity");
                    if(!StringUtils.isEmpty(subEntity.getParse())){
                        System.out.println("parse--sub4-entity");
                        String parse = subEntity.getParse();
                        System.out.println("parse--sub5-entity:"+parse);
                        try {
                            Class cls = Class.forName(parse);
                            Object instance = cls.newInstance();
                            if(instance instanceof SubEntityFieldParser){
                                System.out.println("parse--sub6-entity");
                                SubEntityFieldParser parser = (SubEntityFieldParser)instance;
                                System.out.println("----coming----");
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

        CommonDataVo vo = new CommonDataVo();
        String affairId = parameter.$("affair_id");
        String affairType = parameter.$("affairType");
        String id = parameter.$("id");
        String summaryId = "";
        if(!StringUtils.isEmpty(id)){
           // FlowFactoryImpl fl;
           //
           // DataBaseHandler.getInstance().getDataByKey()
            summaryId = id;
        }else{

            if(StringUtils.isEmpty(affairType)){
                vo.setResult(false);
                vo.setMsg("affairType不能为空");
                return vo;
            }
            if(StringUtils.isEmpty(affairId)){
                vo.setResult(false);
                vo.setMsg("affair_id不能为空");
                return vo;
            }
            String key = affairType+"_"+affairId;
            Object obj =  DataBaseHandler.getInstance().getDataByKey(key);
            summaryId = String.valueOf(obj);
        }
        if(StringUtils.isEmpty(summaryId)){
            vo.setResult(false);
            vo.setMsg("根据传入的参数无法找到数据");
        }else{

            //FlowFactoryImpl impl;
            //impl.getFlowState()

            try {
                ColSummary summary = this.getColManager().getColSummaryById(Long.valueOf(summaryId));
                AffairManagerImpl impl;
                AffairDaoImpl dao;
                List<CtpAffair> affairs = getAffairManager().getAffairs(ApplicationCategoryEnum.collaboration, summary.getId());
                Map data = new HashMap();
                List<CtpAffair> currentAffairList = new ArrayList<CtpAffair>();
                int state=0;
                int doneCount = 0;

                for(CtpAffair affair:affairs){
                    if(affair.getState().intValue() == StateEnum.col_done.key()){
                       // affair.
                        ++doneCount;
                        continue;
                    }else if(affair.getState().intValue() == StateEnum.col_cancel.key() && !affair.isDelete().booleanValue()) {
                        state = FlowUtil.FlowState.cancle.getKey();
                    }else if(affair.getState().intValue() ==  StateEnum.col_pending.key() && !affair.isDelete().booleanValue()) {
                        state = FlowUtil.FlowState.run.getKey();
                        currentAffairList.add(affair);
                    }


                }
                if(doneCount == 0) {
                    state = FlowUtil.FlowState.pendDone.getKey();
                }
                data.put("state",state);
                data.put("title",summary.getSubject());

                if(!CollectionUtils.isEmpty(currentAffairList)){

                    String url="/seeyon/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="+currentAffairList.get(0).getId();
                    data.put("url",url);
                   // CtpAffair affair = currentAffairList.get(0);
                    StringBuilder stb = new StringBuilder("");
                    StringBuilder stbName = new StringBuilder("");
                    StringBuilder stbdept = new StringBuilder("");
                    for(CtpAffair ctpAffair:currentAffairList){
                        V3xOrgMember member =  this.getOrgManager().getMemberById(ctpAffair.getMemberId());
                        V3xOrgDepartment department = this.getOrgManager().getDepartmentById(member.getOrgDepartmentId());
                        if("".equals(stb.toString())){
                            stb.append(member.getLoginName());
                            stbName.append(member.getName());
                            stbdept.append(department.getName());
                        }else{
                            stb.append(",").append(member.getLoginName());
                            stbName.append(",").append(member.getName());
                            stbdept.append(",").append(department.getName());
                        }


                    }
                    data.put("currentUserName",stbName.toString());
                    data.put("currentUserDepartmentName",stbdept.toString());
                    data.put("currentUser",stb.toString());
                }
                //com.seeyon.ctp.privilege.manager.PrivilegeMenuManagerImpl impl;
                vo.setData(data);
                vo.setResult(true);
               // PrivilegeCacheImpl impl2;
                //MenuDaoImpl dap;

            } catch (BusinessException e) {
                e.printStackTrace();
            }
        }


        return vo;
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
        ThirdpartyController con;
        String input = "%7B%22id%22%3A+2536%2C+%22number%22%3A+%22%22%2C+%22customer_name%22%3A+%22test0822%22%2C+%22short_name%22%3A+%22test0822%22%2C+%22applicant_name%22%3A+%22%5Cu5f20%5Cu5b87%22%2C+%22create_time%22%3A+%222018-08-23T14%3A17%3A41%22%2C+%22state_name%22%3A+%22%5Cu5f85%5Cu5546%5Cu52a1%5Cu5ba1%5Cu6838%5Cu5458%5Cu5ba1%5Cu6838%22%2C+%22our%22%3A+%22%5Cu767e%5Cu878d%5Cu91d1%5Cu670d%22%2C+%22A_company%22%3A+%22c0823%22%2C+%22A_address%22%3A+%22c0823%22%2C+%22A_person%22%3A+%22c0823%22%2C+%22A_tel%22%3A+%2213111111111%22%2C+%22products%22%3A+%5B%7B%22id%22%3A+1%2C+%22name%22%3A+%22%5Cu7528%5Cu6237%5Cu8bc4%5Cu4f30%22%2C+%22code%22%3A+%22pgbg%22%2C+%22type%22%3A+%22fk%22%7D%5D%2C+%22type%22%3A+%22%5Cu6b63%5Cu5f0f%5Cu670d%5Cu52a1%5Cu534f%5Cu8bae%28%5Cu516c%5Cu53f8%5Cu6a21%5Cu677f%29%22%2C+%22start_time%22%3A+%222018-08-23T00%3A00%3A00%22%2C+%22end_time%22%3A+%222019-08-29T00%3A00%3A00%22%2C+%22modify%22%3A+%22%5Cu5408%5Cu540c%5Cu6a21%5Cu677f%28%5Cu6709%5Cu4fee%5Cu6539%29%22%2C+%22flag_charge%22%3A+1%2C+%22flag_bulu%22%3A+0%2C+%22discount%22%3A+%22c0823%22%2C+%22note%22%3A+%22c0823%22%2C+%22files%22%3A+%5B%5D%2C+%22username%22%3A+%22yu.zhang%22%2C+%22zone%22%3A+%22%5Cu4e1c%5Cu5317%22%7D";

        System.out.println(URLDecoder.decode(input,"UTF-8"));
        System.out.println(unicodeStr2String(URLDecoder.decode(input,"UTF-8")));

    }


}
