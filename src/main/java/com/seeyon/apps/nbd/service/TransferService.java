package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.*;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class TransferService {

    private OrgManager orgManager;
    private EnumManager enumManager;
    private Map<String,Class> clsHolder = new HashMap<String,Class>();
    public OrgManager getOrgManager() {
        if(orgManager==null){
            orgManager = (OrgManager)AppContext.getBean("orgManager");
        }
        return orgManager;
    }
    public EnumManager getEnumManager() {
        if(enumManager==null){
            enumManager = (EnumManager)AppContext.getBean("enumManager");
        }
        return enumManager;
    }
    private TransferService(){
        clsHolder.put(NbdConstant.DATA_LINK,DataLink.class);
        clsHolder.put(NbdConstant.A8_TO_OTHER,A8ToOtherConfigEntity.class);
        clsHolder.put(NbdConstant.OTHER_TO_A8,OtherToA8ConfigEntity.class);
        clsHolder.put(NbdConstant.LOG,LogEntry.class);
        clsHolder.put(NbdConstant.FTD,Ftd.class);
        clsHolder.put(NbdConstant.A8_TO_OTHER_OUTPUT,A8ToOther.class);
        DataLink link = ConfigService.getA8DefaultDataLink();
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(A8ToOther.class.getSimpleName()),link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(DataLink.class.getSimpleName()),link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(A8ToOtherConfigEntity.class.getSimpleName()),link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(OtherToA8ConfigEntity.class.getSimpleName()),link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(LogEntry.class.getSimpleName()),link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(Ftd.class.getSimpleName()),link);
        if("0".equals(link.getDbType())){
            DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(ZrzxUserSchedule.class.getSimpleName()),link);
        }

    }
    private TransferService ins = null;

    public static TransferService getInstance(){

        return Holder.ins;
    }

    public Class getTransferClass(String dataType){
        if(CommonUtils.isEmpty(dataType)){
            return null;
        }
        return clsHolder.get(dataType);
    }

    public <T> T transData(String dataType, CommonParameter p){

        if(p == null){
            return null;
        }
        Class s = getTransferClass(dataType);
        if(s == null){
            return null;
        }

        String jsonString = JSON.toJSONString(p);
        T t =  (T) JSON.parseObject(jsonString,s);

        return t;


    }

    /**
     'normal': "默认不转换",
     'id_2_org_code': "单位转编码",
     'id_2_org_name': "单位转名称",
     'id_2_dept_code': "部门转编码",
     'id_2_dept_name': "部门转名称",
     'id_2_person_code': "人员转编码",
     'id_2_person_name': "人员转名称",
     'enum_2_name': "枚举转名称",
     'enum_2_value': "枚举转枚举值",
     'file_2_downlaod': "附件转http下载"
     */
    /**
     'normal': "默认不转换",
     'id_2_org_code': "单位转编码",
     'id_2_org_name': "单位转名称",
     'id_2_dept_code': "部门转编码",
     'id_2_dept_name': "部门转名称", getDepartmentsByName
     'id_2_person_code': "人员转编码",
     'id_2_person_name': "人员转名称",
     'enum_2_name': "枚举转名称",
     'enum_2_value': "枚举转枚举值",
     'file_2_downlaod': "附件转http下载"
     */
    public Object transForm2Other(FormField formField,Object val){
        final String st = formField.getClassname();
        try {
            if (CommonUtils.isEmpty(st) || st.equals("normal")) {
                return val;
            }
            OrgManager orgManager = this.getOrgManager();
            Long id = CommonUtils.getLong(val);//得到id

            if ("id_2_org_name".equals(st)||"id_2_org_code".equals(st)) {
                V3xOrgAccount account=orgManager.getAccountById(id);
                if(account!=null){
                    if("id_2_org_name".equals(st)){
                        return  account.getName();
                    }else {
                        return  account.getCode();
                    }
                }
            }
            if("id_2_dept_name".equals(st)||"id_2_org_code".equals(st)){
                V3xOrgDepartment department=orgManager.getDepartmentById(id);
                if(department!=null){
                    if("id_2_dept_name".equals(st)){
                        return  department.getName();
                    }else {
                        return  department.getCode();
                    }
                }
            }
            if("id_2_person_name".equals(st)||"id_2_person_code".equals(st)){
                V3xOrgMember member=orgManager.getMemberById(id);
                if(member!=null){
                    if("id_2_person_name".equals(st)){
                        return member.getName();
                    }else {
                        return  member.getCode();
                    }
                }
            }
            EnumManager enumManager=this.getEnumManager();
            if("enum_2_name".equals(st)||"enum_2_value".equals(st)){

                CtpEnumItem enumItem=enumManager.getCacheEnumItem(id);
                if(enumItem!=null){
                    //enumItem.getCode();
                    if("enum_2_name".equals(st)){
                        return enumItem.getShowvalue();
                    }else {
                        return  enumItem.getEnumvalue();
                    }
                }
            }

            if("file_2_downlaod".equals(st)){
                return "/seeyon/nbd.do?method=download&file_id="+val;
            }


        }catch(Exception e){
            return  val;
        }

//        EnumManager enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
        return val;

    }
    public Object transForm2A8(FormField formField,Object val){

        return val;
    }
    static class Holder{
        private static TransferService ins = new TransferService();

    }

    public static void main(String[] args){
        CommonParameter p = new CommonParameter();
        p.$("user","1234");
        p.$("password","12345");
        p.$("host","12345");
        CommonPo vo = getInstance().transData("data_link",p);
        System.out.println(JSON.toJSONString(vo));
    }
}
