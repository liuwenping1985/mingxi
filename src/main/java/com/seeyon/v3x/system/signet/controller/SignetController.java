package com.seeyon.v3x.system.signet.controller;

import java.io.File;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.system.signet.manager.CtpSignetManager;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.appLog.AppLogAction;
import com.seeyon.ctp.common.appLog.manager.AppLogManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.RoleType;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.TextEncoder;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;
import com.seeyon.ctp.util.annotation.SetContentType;
import com.seeyon.v3x.common.dao.paginate.Pagination;
import com.seeyon.v3x.common.web.login.CurrentUser;
import com.seeyon.v3x.system.signet.domain.V3xSignet;
import com.seeyon.v3x.system.signet.manager.SignetManager;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;

@CheckRoleAccess(roleTypes = { Role_NAME.AccountAdministrator })
public class SignetController extends BaseController {
    private static final int sizeLength = 1024;

    private static final Log LOGGER = LogFactory.getLog(SignetController.class);

    private SignetManager    signetManager;
    private CtpSignetManager ctpSignetManager;
    private OrgManager       orgManager;
    private AppLogManager    appLogManager;
    private FileManager fileManager;

    public void setSignetManager(SignetManager signetManager) {
        this.signetManager = signetManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setAppLogManager(AppLogManager appLogManager) {
        this.appLogManager = appLogManager;
    }
    
    public void setCtpSignetManager(CtpSignetManager ctpSignetManager) {
        this.ctpSignetManager = ctpSignetManager;
    }
    
    public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

    public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
        return null;
    }

    /**
     * 印章管理的进入方法 主界面的首要方法
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView signetFrame(HttpServletRequest request, HttpServletResponse response) {
        return new ModelAndView("signet/signetFrame");
    }

    /**
     * 读取全部数据
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView listSignet(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView result = new ModelAndView("signet/listSignet");
        List<V3xSignet> signetList = null;
        List<V3xSignet> newList = new ArrayList<V3xSignet>();
        try {
            long accountId = CurrentUser.get().getLoginAccount();
            signetList = signetManager.findAll();
            if (signetList != null) {
                for (V3xSignet signet : signetList) {
                    if (signet.getOrgAccountId().longValue() != accountId) {
                        continue;
                    }
                    V3xOrgMember vm = orgManager.getMemberById(Long.valueOf(signet.getOrgAccountId()));
                    if(vm!=null){
                        signet.setUserName(vm.getName());
                    }
                    signet.setMarkName(signet.getMarkName());
                    newList.add(signet);
                }
            }
        } catch (Exception e) {
          LOGGER.error("读取签章列表数据错误：",e);
        }
        List<V3xSignet> _pagenate = pagenate(newList);
        result.addObject("signetList", _pagenate);
        return result;
    }

    /**
     * @param request
     * @param response
     */
    @SetContentType
    public ModelAndView signetPicture(HttpServletRequest request, HttpServletResponse response) {
        Long id = Long.valueOf(request.getParameter("id"));

        V3xSignet signet = signetManager.getSignet(id);
        OutputStream out = null;
        try {
            byte[] b = signet.getMarkBodyByte();

            response.setContentType("application/octet-stream; charset=UTF-8");
            response.setHeader("Content-disposition", "attachment;filename=\"file.gif\"");

            out = response.getOutputStream();
            out.write(b);
        } catch (Exception e) {
            if (!(e.getClass().getSimpleName().equals("ClientAbortException"))) {
              LOGGER.error("", e);
            }
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (Exception e) {
                  LOGGER.info(e.getMessage());
                }
            }
        }

        return null;
    }

    /**
     * 进入印章管理的修改界面
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView modifySignet(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView result = new ModelAndView("signet/signet");
        String printId = request.getParameter("id");
        Long id = Long.valueOf(printId);
        V3xSignet signet = signetManager.getSignet(id);
        // 取得是否是详细页面标志
        String isDetail = request.getParameter("isDetail");
        boolean readOnly = false;
        if (null != isDetail && isDetail.equals("readOnly")) {
            readOnly = true;
            result.addObject("readOnly", readOnly);
        }
        String password = null;
        if (StringUtils.isNotBlank(signet.getPassword())) {
            password = TextEncoder.decode(signet.getPassword());
        }
        result.addObject("password", password);
        result.addObject("signetUserId", signet.getUserName());
        result.addObject("showImg", 1);
        result.addObject("signet", signet);
        result.addObject("signetManagerMethod", "editSignet");
        return result;
    }

    /**
     * 进入印章管理的添加界面方法
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView addSignet(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView result = new ModelAndView("signet/signet");
        result.addObject("showImg", 0);
        result.addObject("signetManagerMethod", "createSignet");
        return result;
    }
    
    public ModelAndView bathCreateSignet(HttpServletRequest request, HttpServletResponse response){
    	String dirPath = request.getParameter("dirPath");
    	if(Strings.isBlank(dirPath)){
    		dirPath = SystemEnvironment.getBaseFolder() + "/signet";
    	}
    	com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
    	try{
	    	File file = new File(dirPath);		//获取其file对象
	    	File[] fs = file.listFiles();	//遍历path下的文件和目录，放在File数组中
	    	for(File f : fs){					//遍历File[]数组
	
		    	if(f == null || f.isDirectory()){		//若非目录(即文件)，则打印
		    		continue;
		    	}
		    	System.out.println(f.getAbsolutePath() + "    " + f.getName());
		    	/*
		    	V3xSignet signet = new V3xSignet();

		    	byte[] bClear = FileUtils.readFileToByteArray(f);
	            byte[] b = TextEncoder.encodeBytes(bClear);
	            signet.setIdIfNew();
	            signet.setUserName(user.getId().toString());
	            signet.setPassword(TextEncoder.encode("123456"));
	            signet.setMarkBody(b);
	            signet.setMarkBodyByte(bClear);
	            signet.setMarkType(1);
	            signet.setImgType(".png");
	            signet.setMarkDate(new Date());
	            signet.setOrgAccountId(user.getAccountId());
	            signet.setMarkPath(f.getName());
	            
	            ctpSignetManager.save(signet);
	            appLogManager.insertLog(user, AppLogAction.Signet_New, user.getName(), signet.getMarkName());
	            //安全日志
	            appLogManager.insertLog(user, AppLogAction.SignetAuth_New, orgManager.getAccountById(user.getAccountId())
	                    .getName(), signet.getMarkName(), request.getParameter("signetName"));
				*/
	    	}
	    	
	    	PrintWriter out = response.getWriter();
            response.setContentType("text/html; charset=UTF-8");
            out.println("<script type='text/javascript'>");
            out.println("alert(parent.v3x.getMessage('sysMgrLang.system_post_ok'))");
            out.println("parent.parent.location.href=parent.parent.location;");
            out.println("</script>");
            out.close();
            
    	}catch(Exception e){
    		LOGGER.error("bathCreateSignet ", e);
    	}
    	
    	
    	return null;
    }

    /**
     * 完成印章管理的添加功能
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView createSignet(HttpServletRequest request, HttpServletResponse response) {
        V3xSignet signet = new V3xSignet();
        com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
        String imgType = request.getParameter("imgType");
        int type = Integer.parseInt(request.getParameter("signetSelect"));
        String icon = request.getParameter("iconId");
        try {
            // 读入文件
            byte[] bClear = null;
            byte[] b = null;
            if(Strings.isNotBlank(icon)){
            	bClear = this.fileManager.getFileBytes(Long.parseLong(icon));
            	b = TextEncoder.encodeBytes(bClear);
             }
            bind(request, signet);
            signet.setIdIfNew();
            signet.setUserName(request.getParameter("signetauto"));
            signet.setPassword(TextEncoder.encode(request.getParameter("password")));
            signet.setMarkBody(b);
            signet.setMarkBodyByte(bClear);
            signet.setMarkType(type);
            signet.setImgType(imgType);
            signet.setMarkDate(new Date());
            signet.setOrgAccountId(user.getAccountId());
            signet.setMarkPath(request.getParameter("icon"));
            
            ctpSignetManager.save(signet);
            appLogManager.insertLog(user, AppLogAction.Signet_New, user.getName(), signet.getMarkName());
            //安全日志
            appLogManager.insertLog(user, AppLogAction.SignetAuth_New, orgManager.getAccountById(user.getAccountId())
                    .getName(), signet.getMarkName(), request.getParameter("signetName"));
            PrintWriter out = response.getWriter();
            response.setContentType("text/html; charset=UTF-8");
            out.println("<script type='text/javascript'>");
            out.println("alert(parent.v3x.getMessage('sysMgrLang.system_post_ok'))");
            out.println("parent.parent.location.href=parent.parent.location;");
            out.println("</script>");
            out.close();
        }
        catch (Exception e) {
            LOGGER.error("", e);
        }
        return null;
    }

    /**
     * 删除印章管理记录的方法
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView removeSignet(HttpServletRequest request, HttpServletResponse response) {
        try {
            com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
            String[] ids = request.getParameterValues("id");
            StringBuffer bf = new StringBuffer();
            if (ids != null && ids.length > 0) {
                String[] signetNames = request.getParameterValues("signetNames");
                Long l = null;
                for (int i = 0; i < ids.length; i++) {
                    l = Long.valueOf(ids[i].toString());
                    signetManager.deleteSignet(l);
                    if (i > 0) {
                        bf.append(",");
                    }
                    bf.append("《").append(signetNames[i]).append("》");
                }
                appLogManager.insertLog(user, AppLogAction.Signet_Delete, user.getName(), bf.toString());
            }
            return super.refreshWorkspace();
        } catch (Exception e) {
          LOGGER.info(e.getMessage());
            return null;
        }
    }

    /**
     * 对印章管理进行修改
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView editSignet(HttpServletRequest request, HttpServletResponse response) {
        V3xSignet signet = new V3xSignet();
        try {
            signet = signetManager.getSignet(Long.parseLong(request.getParameter("id")));
        } catch (NumberFormatException e1) {
        	LOGGER.error("", e1);
        } catch (Exception e1) {
        	LOGGER.error("", e1);
        }
        String imgType = request.getParameter("imgType");
        int type = Integer.parseInt(request.getParameter("signetSelect"));
        String icon = request.getParameter("iconId");
        try {
            // 读入文件
            byte[] bClear = null;
            byte[] b = null;
            if(Strings.isNotBlank(icon)){
            	bClear = this.fileManager.getFileBytes(Long.parseLong(icon));
            	b = TextEncoder.encodeBytes(bClear);
             }
            String oldUser = signet.getUserName();
            bind(request, signet);
            signet.setIdIfNew();
            signet.setUserName(request.getParameter("signetauto"));
            signet.setPassword(TextEncoder.encode(request.getParameter("password")));
            signet.setImgType(Strings.isBlank(imgType)?".jpg":imgType);
            if (Strings.isNotBlank(icon)) {
                signet.setMarkBody(b);
                signet.setMarkBodyByte(bClear);
                signet.setMarkPath(request.getParameter("icon"));
            }
            signet.setMarkType(type);
            //修改印章不改变印章的排列顺序，修改bug17644
            com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
            signet.setOrgAccountId(user.getAccountId());

            ctpSignetManager.update(signet);
            appLogManager.insertLog(user, AppLogAction.Signet_Update, user.getName(), signet.getMarkName());
           
           if (!oldUser.equals(signet.getUserName())) {
                appLogManager.insertLog(user, AppLogAction.SignetAuthModify,
                        orgManager.getAccountById(user.getAccountId()).getName(), signet.getMarkName(),
                        request.getParameter("signetName"));
            }
        } catch (Exception e) {
          LOGGER.info(e.getMessage());
        }
        return super.refreshWorkspace();
     
    }

    /**
     * 进入修改印章密码
     * 
     * @param request
     * @param response
     * @return
     */

    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView modifyPasswordSignet(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView result = new ModelAndView("signet/modifySignet");
        com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
        List<V3xSignet> signetList = signetManager.findSignetByMemberId(user.getId());
        result.addObject("signetList", signetList);
        result.addObject("signetManagerMethod", "editSignet");
        return result;
    }

    /**
     * 进行印章密码修改
     * 
     * @param request
     * @param response
     * @return
     */
    @CheckRoleAccess(roleTypes = { Role_NAME.NULL })
    public ModelAndView editPassword(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        ModelAndView result = new ModelAndView("signet/modifySignet");
        PrintWriter out = response.getWriter();
        String markids=request.getParameter("markid");
        Long.parseLong(markids);
        Long markid = Long.valueOf(request.getParameter("markid"));
        String oldword = request.getParameter("password");
        String newword = request.getParameter("newSignetword");
        String validword = request.getParameter("validateSignetword");

        V3xSignet signet = signetManager.getSignet(markid);
        if (!TextEncoder.decode(signet.getPassword()).equals(oldword)) {//输入的原密码不等于原来的密码
            out.println("<script type='text/javascript'>");
            out.println("alert(parent.v3x.getMessage('sysMgrLang.system_post_passNo'));");
            out.println("</script>");
            out.close();
            return null;
        } else { // 修改
            if (newword.equals(validword)) {
                com.seeyon.ctp.common.authenticate.domain.User user = CurrentUser.get();
                signet.setPassword(TextEncoder.encode(newword));
                signetManager.update(signet);
                appLogManager
                        .insertLog(user, AppLogAction.Update_Signet_Password, user.getName(), signet.getMarkName());

                List<V3xSignet> signetList = signetManager.findSignetByMemberId(user.getId());

                result.addObject("signetList", signetList);
                out.println("<script type='text/javascript'>");
                out.println("alert(parent.v3x.getMessage('sysMgrLang.system_post_ok'));");
                out.println("</script>");
                out.close();
                return null;
            }
        }
        return result;
    }

    private <T> List<T> pagenate(List<T> list) {
        if (list.isEmpty()){
            return new ArrayList<T>();
        }
        Integer first = Pagination.getFirstResult();
        Integer pageSize = Pagination.getMaxResults();
        Pagination.setRowCount(list.size());
        List<T> subList = null;
        if (first + pageSize > list.size()) {
            subList = list.subList(first, list.size());
        } else {
            subList = list.subList(first, first + pageSize);
        }
        return subList;
    }

    /**
     * 根据条件查询数据
     * 
     * @param request
     * @param response
     * @return
     */
    public ModelAndView listSerachSignet(HttpServletRequest request, HttpServletResponse response) {
        ModelAndView result = new ModelAndView("signet/listSignet");
        List<V3xSignet> signetList = null;
        List<V3xSignet> newList = new ArrayList<V3xSignet>();
        String condition = request.getParameter("condition");
        String keyWord = request.getParameter("textfield");
        try {
            signetList = signetManager.findAllByAccountId(CurrentUser.get().getLoginAccount());
            if (signetList != null) {
                if (keyWord != null && !"".equals(keyWord.trim())) {
                    int intcondition = Integer.parseInt(condition.trim());
                    switch (intcondition) {
                        case 0:
                            for (V3xSignet signet : signetList) {
                                signet.setMarkName(signet.getMarkName());
                                newList.add(signet);
                            }
                            break;
                        case 1:
                            for (V3xSignet signet : signetList) {
                                int nameIndex = signet.getMarkName().indexOf(keyWord.trim());
                                if (nameIndex != -1) {
                                    signet.setMarkName(signet.getMarkName());
                                    newList.add(signet);
                                }
                            }
                            break;
                        case 2:
                            for (V3xSignet signet : signetList) {
                                if (signet.getMarkType() == Integer.parseInt(keyWord.trim())) {
                                    signet.setMarkName(signet.getMarkName());
                                    newList.add(signet);
                                }
                            }
                            break;
                        case 3:
                            for (V3xSignet signet : signetList) {
                            	String userId = signet.getUserName();
                            	if(Strings.isNotBlank(userId)){
                            		  V3xOrgMember vm = orgManager.getMemberById(Long.valueOf(signet.getUserName()));
                            		  if(vm!=null){
                            			  int nameIndex = vm.getName().indexOf(keyWord.trim());
                            			  if (nameIndex != -1) {
                            				  signet.setMarkName(signet.getMarkName());
                            				  newList.add(signet);
                            			  }
                            		  }
                            	}
                            }
                            break;
                        default:
                          throw new IllegalStateException();
                    }
                } else {
                    for (V3xSignet signet : signetList) {
                        signet.setMarkName(signet.getMarkName());
                        newList.add(signet);
                    }
                }
            }
        } catch (Exception e) {
          LOGGER.info(e.getMessage());
        }
        result.addObject("signetList", pagenate(newList));
        return result;
    }
}
