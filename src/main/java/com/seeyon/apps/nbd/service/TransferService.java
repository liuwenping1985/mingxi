package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.form.entity.FormField;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.table.entity.NormalTableDefinition;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.po.*;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.encrypt.CoderFactory;
import com.seeyon.ctp.common.filemanager.Constants;
import com.seeyon.ctp.common.filemanager.event.FileUploadEvent;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.NbdFileUtils;
import com.seeyon.ctp.common.filemanager.manager.SignFileItem;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.UUIDLong;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class TransferService {

    private OrgManager orgManager;
    private EnumManager enumManager;
    private AttachmentManager attachmentManager;
    private Map<String, Class> clsHolder = new HashMap<String, Class>();

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    public EnumManager getEnumManager() {
        if (enumManager == null) {
            enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
        }
        return enumManager;
    }

    public AttachmentManager getAttachmentManager() {
        if (attachmentManager == null) {
            attachmentManager = (AttachmentManager) AppContext.getBean("attachmentManager");
        }
        return attachmentManager;
    }

    private TransferService() {
        clsHolder.put(NbdConstant.DATA_LINK, DataLink.class);
        clsHolder.put(NbdConstant.A8_TO_OTHER, A8ToOtherConfigEntity.class);
        clsHolder.put(NbdConstant.OTHER_TO_A8, OtherToA8ConfigEntity.class);
        clsHolder.put(NbdConstant.LOG, LogEntry.class);
        clsHolder.put(NbdConstant.FTD, Ftd.class);
        clsHolder.put(NbdConstant.A8_TO_OTHER_OUTPUT, A8ToOther.class);
        DataLink link = ConfigService.getA8DefaultDataLink();
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(A8ToOther.class.getSimpleName()), link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(DataLink.class.getSimpleName()), link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(A8ToOtherConfigEntity.class.getSimpleName()), link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(OtherToA8ConfigEntity.class.getSimpleName()), link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(LogEntry.class.getSimpleName()), link);
        DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(Ftd.class.getSimpleName()), link);
        if ("0".equals(link.getDbType())) {
            DataBaseHelper.createTableIfNotExist(CommonUtils.camelToUnderline(ZrzxUserSchedule.class.getSimpleName()), link);
        }

    }

    private TransferService ins = null;

    public static TransferService getInstance() {

        return Holder.ins;
    }

    public void filledOtherToA8(OtherToA8ConfigEntity entity) {
        FormTableDefinition fftd = null;
        NormalTableDefinition nftd = null;
        String storeType = entity.getExtString2();
        DataLink a8Link = ConfigService.getA8DefaultDataLink();
        if ("form".equals(storeType)) {
            fftd = entity.getFtd();
            if (fftd == null) {
                Long ftdId = entity.getFtdId();
                if (ftdId != null && !ftdId.equals(-1)) {
                    Ftd ftd = DataBaseHelper.getDataByTypeAndId(a8Link, Ftd.class, ftdId);
                    if (ftd != null) {
                        fftd = Ftd.getFormTableDefinition(ftd);
                        entity.setFormTableDefinition(fftd);
                    }
                }
            }
        } else {
            nftd = entity.getTableFtd();
            if (nftd == null) {
                Long ftdId = entity.getFtdId();
                if (ftdId != null && !ftdId.equals(-1)) {
                    Ftd ftd = DataBaseHelper.getDataByTypeAndId(a8Link, Ftd.class, ftdId);
                    if (ftd != null) {
                        nftd = Ftd.getNormalTableDefinition(ftd);
                        entity.setNormalTableDefinition(nftd);
                    }
                }
            }
        }
    }

    public Class getTransferClass(String dataType) {
        if (CommonUtils.isEmpty(dataType)) {
            return null;
        }
        return clsHolder.get(dataType);
    }

    public <T> T transData(String dataType, CommonParameter p) {

        if (p == null) {
            return null;
        }
        Class s = getTransferClass(dataType);
        if (s == null) {
            return null;
        }

        String jsonString = JSON.toJSONString(p);
        T t = (T) JSON.parseObject(jsonString, s);

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
     * 'normal': "默认不转换",
     * 'id_2_org_code': "单位转编码",
     * 'id_2_org_name': "单位转名称",
     * 'id_2_dept_code': "部门转编码",
     * 'id_2_dept_name': "部门转名称", getDepartmentsByName
     * 'id_2_person_code': "人员转编码",
     * 'id_2_person_name': "人员转名称",
     * 'enum_2_name': "枚举转名称",
     * 'enum_2_value': "枚举转枚举值",
     * 'file_2_downlaod': "附件转http下载"
     */
    public Object transForm2Other(FormField formField, Object val) {
        final String st = formField.getClassname();
        return transFormCommon(st, val);
    }

    public Object transFormCommon(String st, Object val) {

        try {
            if (CommonUtils.isEmpty(st) || st.equals("normal")) {
                return val;
            }
            // System.out.println("------+"+st+"+-----");
            OrgManager orgManager = this.getOrgManager();
            Long id = CommonUtils.getLong(val);//得到id

            if ("id_2_org_name".equals(st) || "id_2_org_code".equals(st)) {
                V3xOrgAccount account = orgManager.getAccountById(id);
                if (account != null) {
                    if ("id_2_org_name".equals(st)) {
                        return account.getName();
                    } else {
                        return account.getCode();
                    }
                }
            }
            if ("id_2_dept_name".equals(st) || "id_2_org_code".equals(st)) {
                V3xOrgDepartment department = orgManager.getDepartmentById(id);
                if (department != null) {
                    if ("id_2_dept_name".equals(st)) {
                        return department.getName();
                    } else {
                        return department.getCode();
                    }
                }
            }
            if ("id_2_person_name".equals(st) || "id_2_person_code".equals(st)) {
                V3xOrgMember member = orgManager.getMemberById(id);
                if (member != null) {
                    if ("id_2_person_name".equals(st)) {
                        return member.getName();
                    } else {
                        return member.getCode();
                    }
                }
            }
            EnumManager enumManager = this.getEnumManager();
            if ("enum_2_name".equals(st) || "enum_2_value".equals(st)) {
                //System.out.println("id:"+id);
                //enumManager.getCacheEnumItem()
                CtpEnumItem enumItem = enumManager.getCacheEnumItem(id);
                //System.out.println("is null:"+enumItem==null);
                if (enumItem != null) {
                    if ("enum_2_name".equals(st)) {
                        return enumItem.getShowvalue();
                    } else {
                        return enumItem.getEnumvalue();
                    }
                }
            }

            if ("file_2_downlaod".equals(st)) {
                //this.getAttachmentManager().getBySubReference(val);
                List<Attachment> attachemntList = this.getAttachmentManager().getByReference(id);
                if (CommonUtils.isNotEmpty(attachemntList)) {
                    return "/seeyon/nbd.do?method=download&file_id=" + attachemntList.get(0).getFileUrl();
                }
                List<Long> filesIdList = this.getAttachmentManager().getBySubReference(id);
                if (CommonUtils.isNotEmpty(filesIdList)) {

                    return "/seeyon/nbd.do?method=download&file_id=" + filesIdList.get(0);

                }
                return "/seeyon/nbd.do?method=download&file_id=" + val;
            }
            if ("file_sign".equals(st)) {
              //  String downloadUrl = String.valueOf(val);
               // String suffix = UIUtils.getFileSuffix(downloadUrl);
                SignFileItem file = UIUtils.fileDownloadByUrl(String.valueOf(val));
                //File lastFile = null;
                if (file != null) {
                    String signLoginUser = ConfigService.getPropertyByName("sign_login_user", "oa");
                    V3xOrgMember orgMember = this.getOrgManager().getMemberByLoginName(signLoginUser);
                    if (orgMember != null) {
                        //去签章
                        V3XFile v3XFile = uploadFile(orgMember, file);
                        Constants.ATTACHMENT_TYPE type = Constants.ATTACHMENT_TYPE.FILE;
                        ApplicationCategoryEnum category = ApplicationCategoryEnum.form;

                        Attachment att = new Attachment(v3XFile, category, type);
                        //att.setReference();
                        att.setSubReference(UUIDLong.longUUID());
                        att.setCategory(2);
                        att.setType(0);
                        NbdService.attList.add(att);
                        return att.getSubReference();
                        //  PdfSignService.sign(file.getFileItem().getAbsolutePath(),null);
                    }

                }
//                if(lastFile!=null){
//                    String signLoginUser = ConfigService.getPropertyByName("sign_login_user","oa");
//                    V3xOrgMember orgMember = this.getOrgManager().getMemberByLoginName(signLoginUser);
//                    if(orgMember != null){
//                        //去签章
//                        SignFileItem lastSignFile = new SignFileItem(lastFile.getName(),lastFile.length(),lastFile);
//                        uploadFile(orgMember,lastSignFile);
//                    }
//
//                }
                return null;

            }


        } catch (Exception e) {
            return val;
        }

//        EnumManager enumManager = (EnumManager) AppContext.getBean("enumManagerNew");
        return val;
    }

    private static V3XFile uploadFile(V3xOrgMember member, SignFileItem fi) {

        FileUploadEvent event = new FileUploadEvent(fi, fi);
        try {
            EventDispatcher.fireEventWithException(event);
        } catch (Exception var31) {

        } catch (Throwable throwable) {

        }

        long fileId = UUIDLong.longUUID();
        File destFile = null;
        try {
            String dir = NbdFileUtils.getFolder(new Date(), true);
            destFile = new File(dir + File.separator + fileId);
            String encryptVersion = null;
            String isEncrypt = "";
            encryptVersion = CoderFactory.getInstance().getEncryptVersion();
            if (encryptVersion != null && !"no".equals(encryptVersion) && !"false".equals(isEncrypt)) {
                BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(destFile));
                CoderFactory.getInstance().upload(fi.getInputStream(), bos, encryptVersion);
            } else {
                fi.saveAs(destFile);
            }
        } catch (Exception var32) {
            return null;
        }
        Date createDate = new Date();
        V3XFile file = new V3XFile(Long.valueOf(fileId));
        file.setCreateDate(createDate);
        file.setFilename(fi.getName());
        file.setSize(Long.valueOf(fi.getSize()));
        file.setMimeType(fi.getContentType());
        file.setType(Integer.valueOf(Constants.ATTACHMENT_TYPE.FILE.ordinal()));
        file.setCreateMember(member.getId());
        file.setAccountId(member.getOrgAccountId());
        return file;
    }

    static class Holder {
        private static TransferService ins = new TransferService();

    }

    public static void main(String[] args) {
        CommonParameter p = new CommonParameter();
        p.$("user", "1234");
        p.$("password", "12345");
        p.$("host", "12345");
        String url = "http://hzvendor.dnd8.com/SupplierUploads/702bf492-de68-48c2-80bb-be07ef60986b.pdf";

        String vo = UIUtils.getFileSuffix(url);
        // File f = new File();
        System.out.println(vo);
    }
}
