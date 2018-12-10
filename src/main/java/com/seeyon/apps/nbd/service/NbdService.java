package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.constant.NbdConstant;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHandler;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.nbd.core.db.link.ConnectionBuilder;
import com.seeyon.apps.nbd.core.form.entity.FormTable;
import com.seeyon.apps.nbd.core.form.entity.FormTableDefinition;
import com.seeyon.apps.nbd.core.service.MappingServiceManager;
import com.seeyon.apps.nbd.core.service.impl.MappingServiceManagerImpl;
import com.seeyon.apps.nbd.core.util.CommonUtils;
import com.seeyon.apps.nbd.core.util.XmlUtils;
import com.seeyon.apps.nbd.core.vo.CommonParameter;
import com.seeyon.apps.nbd.core.vo.NbdResponseEntity;
import com.seeyon.apps.nbd.po.*;
import com.seeyon.apps.nbd.util.UIUtils;
import com.seeyon.apps.nbd.vo.*;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.common.constants.LoginResult;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.flag.BrowserEnum;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.LocaleContext;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.supervise.controller.SuperviseController;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.login.LoginControlImpl;
import com.seeyon.ctp.login.online.OnlineRecorder;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.UUIDLong;
import org.apache.http.protocol.RequestUserAgent;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * Created by liuwenping on 2018/10/29.
 */
public class NbdService {

    // private DataBaseHandler handler = DataBaseHandler.getInstance();
    private MappingServiceManager mappingServiceManager = new MappingServiceManagerImpl();
    private TransferService transferService = TransferService.getInstance();
    private CollaborationTemplateManager collaborationTemplateManager;

    private CollaborationTemplateManager getCollaborationTemplateManager(){
        if(collaborationTemplateManager == null){
            collaborationTemplateManager = (CollaborationTemplateManager)AppContext.getBean("collaborationTemplateManager");
        }
        return collaborationTemplateManager;
    }
    private LoginControlImpl loginControl;

    private HttpServletRequest request;
    private HttpServletResponse response;

    private OrgManager orgManager;
    private OrgManager getOrgManager(){
        if(orgManager == null){
            orgManager = (OrgManager)AppContext.getBean("orgManager");
        }
        return orgManager;
    }
    public void setRequest(HttpServletRequest request) {
        this.request = request;
    }

    public void setResponse(HttpServletResponse response) {
        this.response = response;
    }

    private LoginControlImpl getLoginControl(){
        if(loginControl == null){
            loginControl = (LoginControlImpl)AppContext.getBean("loginControl");
            if(loginControl == null){
                loginControl = (LoginControlImpl)AppContext.getBean("loginControlImpl");
            }
        }
        return loginControl;
    }

    public NbdResponseEntity postAdd(CommonParameter p) {
        System.out.println(p);
        NbdResponseEntity entity = preProcess(p);
        if (!entity.isResult()) {
            return entity;
        }
        String type = p.$("data_type");
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        //handler.createNewDataBaseByNameIfNotExist(type);
        CommonPo cVo = transferService.transData(type, p);
        if (cVo == null) {
            entity.setResult(false);
            entity.setMsg(" data transfer error");
        } else {
            cVo.setDefaultValueIfNull();
            p.$("id", cVo.getId());
            if (NbdConstant.A8_TO_OTHER.equals(type)) {
                Ftd ftd = mappingServiceManager.saveFormTableDefinition(p);
                A8ToOtherConfigEntity a82Otherentity = (A8ToOtherConfigEntity) cVo;
                a82Otherentity.setFtdId(ftd.getId());
            }
            if (NbdConstant.OTHER_TO_A8.equals(type)) {
                Ftd ftd = mappingServiceManager.saveFormTableDefinition(p);
                OtherToA8ConfigEntity otherToA8 = (OtherToA8ConfigEntity) cVo;
                otherToA8.setFtdId(ftd.getId());
            }
            cVo.saveOrUpdate(dataLink);
            entity.setData(cVo);
        }

        return entity;
    }

    public NbdResponseEntity postUpdate(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        System.out.println("post--->>>>" + p.$("id"));
        Long id = Long.parseLong("" + p.$("id"));
        CommonPo cVo = transferService.transData(type, p);
        if (id != null) {
            cVo.setId(id);
        } else {
            entity.setResult(false);
            entity.setMsg("id is not presented!");
        }
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        System.out.println("post--->>>>" + cVo.getId());
        Class cls = transferService.getTransferClass(type);
        CommonPo vo2 = (CommonPo) DataBaseHelper.getDataByTypeAndId(dataLink, cls, id);
        // CommonPo vo2 = (CommonPo) handler.getDataByKeyAndClassType(type, ""+cVo.getId(), cls);
        System.out.println("post2--->>>>" + vo2.getId());
        //handler.removeDataByKey(type,vo2.getId());
        vo2 = CommonUtils.copyProIfNotNullReturnSource(vo2, cVo);

        entity.setData(vo2);
        if (NbdConstant.A8_TO_OTHER.equals(type) || NbdConstant.OTHER_TO_A8.equals(type)) {
            //CommonParameter ftdP = new CommonParameter();
            A8ToOtherConfigEntity a82Otherentity = (A8ToOtherConfigEntity) vo2;
            p.$("id", a82Otherentity.getFtdId());
            mappingServiceManager.updateFormTableDefinition(p);
        }
        vo2.saveOrUpdate(dataLink);
        entity.setResult(true);
        return entity;
    }

    public NbdResponseEntity postDelete(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        String id = p.$("id");
        if (CommonUtils.isEmpty(id)) {
            entity.setResult(false);
            entity.setMsg("id not present!");
            return entity;
        }
        Class cls = transferService.getTransferClass(type);
        DataLink dataLink = ConfigService.getA8DefaultDataLink();

        CommonPo commonPo = (CommonPo) DataBaseHelper.getDataByTypeAndId(dataLink, cls, Long.parseLong(id));

        //Object data = handler.removeDataByKey(type, id);
        if (commonPo != null) {
            entity.setData(commonPo);
            entity.setResult(true);
        } else {
            entity.setResult(false);
            entity.setData(id);
        }
        if (NbdConstant.A8_TO_OTHER.equals(type)) {
            A8ToOtherConfigEntity a8ToOtherConfigEntity = (A8ToOtherConfigEntity) entity.getData();
            CommonParameter ftdP = new CommonParameter();
            ftdP.$("id", a8ToOtherConfigEntity.getFtdId());
            mappingServiceManager.deleteFormTableDefinition(ftdP);
        }
        if (NbdConstant.OTHER_TO_A8.equals(type)) {
           // mappingServiceManager.deleteFormTableDefinition(p);

            OtherToA8ConfigEntity otherToA8 = (OtherToA8ConfigEntity) entity.getData();
            CommonParameter ftdP = new CommonParameter();
            ftdP.$("id", otherToA8.getFtdId());
            mappingServiceManager.deleteFormTableDefinition(ftdP);


        }
        commonPo.delete(dataLink);
        return entity;
    }

    public NbdResponseEntity getDataList(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        DataLink dataLink = ConfigService.getA8DefaultDataLink();
        Class cls = transferService.getTransferClass(type);
        String sql = DataBaseHelper.genSelectAllSQL(cls);

        List dataList = DataBaseHelper.executeObjectQueryBySQLAndLink(dataLink,cls,sql);


        if (dataList == null) {
            entity.setItems(new ArrayList());
        } else {
            for(Object obj:dataList){
                if(obj instanceof CommonPo){
                    CommonPo cp = (CommonPo)obj;
                    cp.setSid(String.valueOf(cp.getId()));
                }
                if(obj instanceof A8ToOtherConfigEntity){
                    A8ToOtherConfigEntity cp = (A8ToOtherConfigEntity)obj;
                    cp.setsLinkId(String.valueOf(cp.getLinkId()));
                }
                if(obj instanceof OtherToA8ConfigEntity){
                    OtherToA8ConfigEntity cp = (OtherToA8ConfigEntity)obj;
                    cp.setsLinkId(String.valueOf(cp.getLinkId()));
                }

            }
            entity.setItems(dataList);
        }
        return entity;
    }

    public NbdResponseEntity getDataById(CommonParameter p) {
        NbdResponseEntity entity = preProcess(p);
        String type = p.$("data_type");
        String id = String.valueOf(p.$("id"));
        if (CommonUtils.isEmpty(id)) {
            entity.setResult(false);
            entity.setMsg("id not present!");
            return entity;
        }
        Class cls = TransferService.getInstance().getTransferClass(type);
        DataLink dl = ConfigService.getA8DefaultDataLink();
        Object obj = DataBaseHelper.getDataByTypeAndId(dl, cls, Long.parseLong(id));
        if (NbdConstant.A8_TO_OTHER.equals(type)) {
            A8ToOtherConfigEntity a8toOther = (A8ToOtherConfigEntity) obj;
            Long ftdId = a8toOther.getFtdId();
            Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, ftdId);
            FormTableDefinition formDef = Ftd.getFormTableDefinition(ftd);
            a8toOther.setFormTableDefinition(formDef);
            a8toOther.setsLinkId(String.valueOf(a8toOther.getLinkId()));
        }
        if (NbdConstant.OTHER_TO_A8.equals(type)) {

            OtherToA8ConfigEntity otherToA8ConfigEntity = (OtherToA8ConfigEntity) obj;
            Long ftdId = otherToA8ConfigEntity.getFtdId();
            Ftd ftd = DataBaseHelper.getDataByTypeAndId(dl, Ftd.class, ftdId);
            FormTableDefinition formDef = Ftd.getFormTableDefinition(ftd);
            otherToA8ConfigEntity.setFormTableDefinition(formDef);
            otherToA8ConfigEntity.setsLinkId(String.valueOf(otherToA8ConfigEntity.getLinkId()));
        }
        if(obj instanceof CommonPo){
            CommonPo cp = (CommonPo)obj;
            cp.setSid(String.valueOf(cp.getId()));
        }
        entity.setData(obj);
        return entity;
    }

    private NbdResponseEntity preProcess(CommonParameter cp) {
        NbdResponseEntity entity = new NbdResponseEntity();
        entity.setResult(true);
        String type = cp.$("data_type");
        if (CommonUtils.isEmpty(type)) {
            entity.setResult(false);
            entity.setMsg("unknown data_type");
            entity.setData(cp);
        }
        return entity;
    }

    public NbdResponseEntity testConnection(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();
        try {
            DataLink dl = TransferService.getInstance().transData("data_link", p);
            boolean isOk = ConnectionBuilder.testConnection(dl);
            if (isOk) {
                entity.setResult(true);
                entity.setMsg("connection is ok");
            } else {
                entity.setResult(false);
                entity.setData("Error occured ~ when connecting~");
            }

        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
        }

        return entity;
    }

    public NbdResponseEntity getCtpTemplateNumber(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();
        try {
            String linkId = p.$("linkId");
            DataLink dl = null;
            if (!CommonUtils.isEmpty(linkId)) {

                DataLink dfl = ConfigService.getA8DefaultDataLink();
                dl = DataBaseHelper.getDataByTypeAndId(dfl, DataLink.class, Long.parseLong(linkId));
                if (dl == null) {
                    dl = ConfigService.getA8DefaultDataLink();
                }
            } else {
                dl = ConfigService.getA8DefaultDataLink();
            }

            boolean isOk = ConnectionBuilder.testConnection(dl);
            if (isOk) {
                entity.setResult(true);
                String sql = "select * from ctp_template where state=0 and is_delete=0";
                List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
                entity.setItems(items);
                entity.setMsg("connection is ok");
            } else {
                entity.setResult(false);
                entity.setMsg("数据连接失败");
                entity.setData("Error occured ~ when connecting~");
            }

        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
        }

        return entity;
    }

    public NbdResponseEntity getFormByTemplateNumber(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();

        String affairType = p.$("affairType");
        String sql = " select * from form_definition where id = (select  CONTENT_TEMPLATE_ID from ctp_content_all where id =(select BODY from ctp_template where TEMPLETE_NUMBER='" + affairType + "'))";
        DataLink dl = ConfigService.getA8DefaultDataLink();
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
        if (CommonUtils.isEmpty(items)) {
            entity.setResult(false);
            entity.setMsg("根据模板编号无法找到对应的表单");
            return entity;
        }
        String xml = String.valueOf(items.get(0).get("field_info"));
        try {
            String jsonString = XmlUtils.xmlString2jsonString(xml);
            Map data = JSON.parseObject(jsonString, HashMap.class);
            FormTableDefinition ftd = mappingServiceManager.parseFormTableMapping(data);
            entity.setData(ftd);
            entity.setResult(true);
            return entity;
        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
            return entity;
        }

    }

    public NbdResponseEntity dbConsole(CommonParameter p) {
        NbdResponseEntity entity = new NbdResponseEntity();

        String linkId = p.$("linkId");
        String sql = p.$("sql");
        if (CommonUtils.isEmpty(sql)) {
            entity.setResult(false);
            entity.setData("empty sql or link");
            return entity;
        } else {
            if (!sql.toLowerCase().startsWith("select")) {
                entity.setResult(false);
                entity.setData("不支持的sql语句，解锁完整版请联系商务");
                return entity;
            }
        }

        DataLink dl = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), DataLink.class, Long.parseLong(linkId));
        List<Map> items = DataBaseHelper.executeQueryBySQLAndLink(dl, sql);
        if (CommonUtils.isEmpty(items)) {
            entity.setResult(false);
            entity.setMsg("无数据");
            return entity;
        }
        try {
            entity.setItems(items);
            entity.setResult(true);
            return entity;
        } catch (Exception e) {
            e.printStackTrace();
            entity.setResult(false);
            entity.setMsg(e.getMessage());
            return entity;
        }

    }

    public void transA8Output(CtpAffair affair, A8ToOtherConfigEntity a8ToOtherConfigEntity) {

        String expType = a8ToOtherConfigEntity.getExportType();

        if ("mid_table".equals(expType)) {

            Long formRecordId = affair.getFormRecordid();
            Long ftdId = a8ToOtherConfigEntity.getFtdId();
            Ftd ftdHandler = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), Ftd.class, ftdId);
            FormTableDefinition ftd = Ftd.getFormTableDefinition(ftdHandler);
            // FormTableDefinition ftd =
            if (ftd == null) {
                System.out.println("[ERROR]FTD NOT FOUND:" + a8ToOtherConfigEntity.getId());
                return;
            }
            String sql = ftd.genQueryById(formRecordId);
            System.out.println(sql);
            try {
                List<Map> dataMapList = DataBaseHelper.executeQueryByNativeSQL(sql);
                if (CommonUtils.isEmpty(dataMapList)) {
                    System.out.println("[ERROR]DATA NOT FOUND:" + formRecordId);
                    return;
                }

                List<Map> retList = ftd.filled2ValueMap(ftd.getFormTable(), dataMapList);

                //只会有一条
                Map masterRecord = retList.get(0);
                System.out.println("master_record:" + masterRecord);
                //处理子表
                List<FormTable> slaveTables = ftd.getFormTable().getSlaveTableList();
                if (!CommonUtils.isEmpty(slaveTables)) {

                    for (FormTable ft : slaveTables) {

                        String slaveSql = ftd.genSelectSQLByProp(ft, "formmain_id", formRecordId);
                        List<Map> slaveDataMapList = DataBaseHelper.executeQueryByNativeSQL(slaveSql);
                        List<Map> slaveRet = ftd.filled2ValueMap(ft, slaveDataMapList);
                        masterRecord.put(ft.getDisplay(), slaveRet);
                    }
                }
                //List<List<SimpleFormField>> retList = ftd.filledValue(dataMapList);
                A8ToOther a8OutputVo = new A8ToOther();
                a8OutputVo.setCreateTime(new Date());
                a8OutputVo.setData(JSON.toJSONString(masterRecord));
                a8OutputVo.setId(UUIDLong.longUUID());
                a8OutputVo.setSourceId(formRecordId);
                a8OutputVo.setStatus(0);
                a8OutputVo.setUpdateTime(new Date());
                a8OutputVo.setName(a8ToOtherConfigEntity.getAffairType() + "_" + ftd.getFormTable().getName());
                System.out.println("to_be_saved:" + JSON.toJSONString(a8OutputVo));
                Long linkId = a8ToOtherConfigEntity.getLinkId();
                DataLink link = DataBaseHelper.getDataByTypeAndId(ConfigService.getA8DefaultDataLink(), DataLink.class, linkId);
                DataBaseHelper.persistCommonVo(link, a8OutputVo);

            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("[ERROR]EXECUTE ERROR:" + e.getMessage());
                return;
            } catch (Error error) {
                error.printStackTrace();
            }


        } else if("http".equals(expType)){
           // UIUtils.post()


        }

    }
    public List<CtpTemplate> findConfigTemplates(String category,int offset, int limit,Long userId,Long accountId) {
        List<CtpTemplate> templateList = new ArrayList();

        if(limit <= 0) {
            return (List)templateList;
        } else {
            FlipInfo flipInfo = new FlipInfo();
            flipInfo.setPage(1);
            flipInfo.setSize(limit+offset);

            flipInfo.setNeedTotal(false);
            Map<String, Object> params = new HashMap();
            if(userId!=null){

                params.put("userId", userId);
                params.put("accountId", accountId);
            }else{
                User user = AppContext.getCurrentUser();
                params.put("userId", user.getId());
                params.put("accountId", user.getLoginAccount());
            }

            params.put("category", category);

            try {
                templateList = this.getCollaborationTemplateManager().getMyConfigCollTemplate(flipInfo, params);
                if(templateList.size()<offset){
                    return new ArrayList<CtpTemplate>();
                }else{
                    return templateList.subList(offset,offset+limit);
                }
            } catch (BusinessException var8) {

            }

            return (List)templateList;
        }
    }

    public void login(Long userId){

        OrgManager om = this.getOrgManager();
        if(om!=null){
            try {
                V3xOrgMember vm = om.getMemberById(userId);
                login(vm);
            } catch (BusinessException e) {

            }
        }
    }



    private User login(V3xOrgMember handleMember) throws BusinessException {
        User user = new User();
        user.setId(handleMember.getId());
        user.setDepartmentId(handleMember.getOrgDepartmentId());
        user.setLoginAccount(handleMember.getOrgAccountId());
        user.setLoginName(handleMember.getLoginName());
        user.setName(handleMember.getName());
        user.setSecurityKey(UUIDLong.longUUID());
        user.setUserAgentFrom("pc");
        user.setBrowser(BrowserEnum.IE);
        String remoteAddr = Strings.getRemoteAddr(request);
        user.setRemoteAddr(remoteAddr);
        HttpSession session = request.getSession(true);
        String sessionId = session.getId();
        user.setSessionId(sessionId);
        user.setTimeZone(TimeZone.getDefault());
        user.setLoginState(User.login_state_enum.ok);
        Locale locale = LocaleContext.make4Frontpage(request);
        user.setLocale(locale);
        LoginResult result = mergeUserInfo(user, this.getLoginControl());
        if (!result.isOK()) {
            return null;
        }
        user.setLoginState(User.login_state_enum.ok);
        AppContext.putSessionContext(SessionLocaleResolver.LOCALE_SESSION_ATTRIBUTE_NAME, locale);
        session.setAttribute("com.seeyon.current_user", user);
        AppContext.putThreadContext("SESSION_CONTEXT_USERINFO_KEY", user);
        OnlineRecorder.moveToOffline(user.getLoginName(), user.getLoginSign(), Constants.LoginOfflineOperation.loginAnotherone);
        this.getLoginControl().getOnlineManager().updateOnlineState(user);
        this.getLoginControl().createLog(user);
        this.getLoginControl().getTopFrame(user, request);
        this.response.addHeader("LoginOK", "ok");
        this.response.addHeader("VJA", user.isAdmin() ? "1" : "0");
        return user;
    }


    private static LoginResult mergeUserInfo(User currentUser, LoginControlImpl loginControl) {
        if (currentUser == null) {
            return LoginResult.ERROR_UNKNOWN_USER;
        } else {
            try {
                String loginName = currentUser.getLoginName();
                V3xOrgMember member = loginControl.getOrgManager().getMemberByLoginName(loginName);
                if (member != null && member.isValid()) {
                    long userId = member.getId().longValue();
                    V3xOrgAccount account = loginControl.getOrgManager().getAccountById(member.getOrgAccountId());
                    V3xOrgAccount loginAccount;
                    if (currentUser.getLoginAccount() != null) {
                        loginAccount = loginControl.getOrgManager().getAccountById(currentUser.getLoginAccount());
                    } else {
                        loginAccount = account;
                    }

                    if (account != null && loginAccount != null && account.isValid() && loginAccount.isValid()) {
                        currentUser.setId(Long.valueOf(userId));
                        currentUser.setAccountId(account.getId());
                        currentUser.setLoginAccount(loginAccount.getId());
                        currentUser.setLoginAccountName(loginAccount.getName());
                        currentUser.setLoginAccountShortName(loginAccount.getShortName());
                        currentUser.setExternalType(member.getExternalType());
                        String name = null;
                        if (member.getIsAdmin().booleanValue()) {
                            if (loginControl.getOrgManager().isAuditAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setAuditAdmin(true);
                                name = ResourceUtil.getString("org.auditAdminName.value");
                            } else if (loginControl.getOrgManager().isGroupAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setGroupAdmin(true);
                                name = ResourceUtil.getString("org.account_form.groupAdminName.value" + (String) SysFlag.EditionSuffix.getFlag());
                            } else if (loginControl.getOrgManager().isAdministratorById(Long.valueOf(userId), loginAccount).booleanValue()) {
                                currentUser.setAdministrator(true);
                                name = loginAccount.getName() + ResourceUtil.getString("org.account_form.adminName.value");
                            } else if (loginControl.getOrgManager().isSystemAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setSystemAdmin(true);
                                name = ResourceUtil.getString("org.account_form.systemAdminName.value");
                            } else if (loginControl.getOrgManager().isSuperAdmin(loginName, loginAccount).booleanValue()) {
                                currentUser.setSuperAdmin(true);
                                name = ResourceUtil.getString("org.account_form.superAdminName.value");
                            } else if (loginControl.getOrgManager().isPlatformAdminById(Long.valueOf(userId)).booleanValue()) {
                                currentUser.setPlatformAdmin(true);
                                name = ResourceUtil.getString("org.account_form.platformAdminName.value");
                            }
                        } else {
                            name = member.getName();
                        }

                        currentUser.setName(name);
                        currentUser.setDepartmentId(member.getOrgDepartmentId());
                        currentUser.setLevelId(member.getOrgLevelId());
                        currentUser.setPostId(member.getOrgPostId());
                        currentUser.setInternal(member.getIsInternal().booleanValue());
                        return LoginResult.OK;
                    } else {
                        return LoginResult.ERROR_UNKNOWN_USER;
                    }
                } else {
                    return LoginResult.ERROR_UNKNOWN_USER;
                }
            } catch (Throwable var9) {
                loginControl.getLogger().error(var9.getLocalizedMessage(), var9);
                return LoginResult.ERROR_UNKNOWN_USER;
            }
        }
    }
    public static void main(String[] args) {
        NbdService nbds = new NbdService();
        CommonParameter p = new CommonParameter();
        p.$("type", 123);
        p.$("type2", "66we");
        p.$("data_type", "3474646");

        //nbds.handler.createNewDataBaseByNameIfNotExist("test");


//        String json = JSON.toJSONString(p);
        // Test t = JSON.parseObject(json,Test.class);
        //Test t = (Test) nbds.handler.getDataByKeyAndClassType("test", "123", Test.class);
        //System.out.println(t.getType());
    }
}
