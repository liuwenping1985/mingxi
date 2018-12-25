package com.seeyon.apps.menhu.controller;

import com.seeyon.apps.collaboration.manager.PendingManager;
import com.seeyon.apps.doc.manager.DocAclNewManager;
import com.seeyon.apps.doc.manager.DocHierarchyManager;
import com.seeyon.apps.doc.manager.DocLibManager;
import com.seeyon.apps.doc.po.DocLibPO;
import com.seeyon.apps.doc.util.Constants;
import com.seeyon.apps.menhu.util.Helper;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.operationlog.manager.OperationlogManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.principal.PrincipalManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;


public class MenhuController extends BaseController {
    private static Logger LOG = LoggerFactory.getLogger(MenhuController.class);

    private PrincipalManager principalManager = null;
    private AttachmentManager attachmentManager;
    private OrgManager orgManager;
    private DocLibManager docLibManager = null;

    private FileManager fileManager;

    private DocHierarchyManager docHierarchyManager;

    private DocAclNewManager docAclNewManager;

    private OperationlogManager operationlogManager;

    public FileManager getFileManager() {
        if (fileManager == null) {
            fileManager = (FileManager) AppContext.getBean("fileManager");
        }
        return fileManager;
    }
    public DocHierarchyManager getDocHierarchyManager() {
        if (docHierarchyManager == null) {
            docHierarchyManager = (DocHierarchyManager) AppContext.getBean("docHierarchyManager");
        }
        return docHierarchyManager;
    }
    public OperationlogManager getOperationlogManager() {
        if (operationlogManager == null) {
            operationlogManager = (OperationlogManager) AppContext.getBean("operationlogManager");
        }
        return operationlogManager;
    }

    public DocAclNewManager getDocAclNewManager(){
        if (docAclNewManager == null) {
            docAclNewManager = (DocAclNewManager) AppContext.getBean("docAclNewManager");
        }
        return docAclNewManager;
    }

    private Integer parseEntranceType(DocLibPO docLib) {
        Integer entranceType = 6;
        if (docLib.getType() == Constants.PERSONAL_LIB_TYPE) {
            entranceType = 1;
        } else if (docLib.getType() == Constants.EDOC_LIB_TYPE) {
            entranceType = 9;
        }
        return entranceType;
    }

    public PrincipalManager getPrincipalManager() {
        if (principalManager == null) {
            principalManager = (PrincipalManager) AppContext.getBean("principalManager");
        }
        return principalManager;
    }

    public DocLibManager getDocLibManager() {
        if (docLibManager == null) {
            docLibManager = (DocLibManager) AppContext.getBean("docLibManager");
        }
        return docLibManager;
    }

    public OrgManager getOrgManager() {
        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;
    }

    private void preResponse(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Methods", "GET, HEAD, POST, PUT, DELETE, TRACE, OPTIONS, PATCH");
        response.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type,Token,Accept, Connection, User-Agent, Cookie");
        response.setHeader("Access-Control-Max-Age", "3628800");
    }


    @NeedlessCheckLogin
    public ModelAndView pendingCount(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        //查用户信息
        preResponse(response);
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("result", false);
        data.put("msg", "error");
        data.put("data", "0");
        String loginName = request.getParameter("loginName");
        if(StringUtils.isEmpty(loginName)){
            data.put("msg", "登录名不能为空");
            data.put("data", "-1");
        }else{
            V3xOrgMember member = this.getOrgManager().getMemberByLoginName(loginName);
            if(member == null){
                data.put("msg", "根据登录名找不到用户");
                data.put("data", "-1");
            }else{
                try {
                   // CtpAffair affair;

                    Integer count = DBAgent.count("select count(1) from CtpAffair where memberId=" + member.getId() + " and state=3 and is_delete=0");
                    data.put("data", count);
                    data.put("msg", "success");
                    data.put("result", true);
                }catch(Exception e){
                    e.printStackTrace();
                    data.put("msg", e.getMessage());
                }
            }

        }

        Helper.responseJSON(data,response);
        return null;

    }



    public static void main(String[] args) {
        System.out.println("a");

    }


}
