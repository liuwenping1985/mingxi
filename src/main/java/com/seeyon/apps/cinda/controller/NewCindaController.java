package com.seeyon.apps.cinda.controller;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.content.comment.Comment;
import com.seeyon.ctp.common.content.comment.CommentManager;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;

/**
 * 协同表单格式调整
 * @author 常建虎
 * @date 2017年3月4日
 *
 */
public class NewCindaController extends BaseController {
  private final static Log log = LogFactory.getLog(NewCindaController.class);
  private OrgManager orgManager;
  private CommentManager ctpCommentManager;

  public OrgManager getOrgManager() {
    return orgManager;
  }


  public void setOrgManager(OrgManager orgManager) {
    this.orgManager = orgManager;
  }

  public CommentManager getCtpCommentManager() {
	return ctpCommentManager;
  }


  public void setCtpCommentManager(CommentManager ctpCommentManager) {
	this.ctpCommentManager = ctpCommentManager;
  }


  public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
    //ModelAndView mv = new ModelAndView("plugin/cinda/index");
    response.setContentType("text/plain;charset=UTF-8");
    PrintWriter out = response.getWriter();
    String name = request.getParameter("name");
    String moduleId = request.getParameter("moduleId");
    String paramModuleType = request.getParameter("moduleType");

    List<Comment> comments = ctpCommentManager.getCommentAllByModuleId(ModuleType.getEnumByKey(Integer.parseInt(paramModuleType)), Long.valueOf(moduleId));
    V3xOrgMember member = null;
    for (Comment comment :comments)
    {
    	V3xOrgMember m = orgManager.getMemberById(comment.getCreateId());
    	if (name.equals(m.getName()))
    	{
    		member = m;
    		break;
    	}
    }

    if (member != null)
    {
        long depId = member.getOrgDepartmentId();
        String fieldValue="";
        try
        {
      	  if (orgManager.getParentDepartment(depId) != null)
      	  {
      		  fieldValue = orgManager.getParentDepartment(depId).getName();
      	  }
      	  else
      	  {
      		  if (orgManager.getDepartmentById(depId) != null)
  	    	  {
  	    		  fieldValue = orgManager.getDepartmentById(depId).getName();
  	    	  }
      	  }
        } catch (Exception e)
        {
        	e.printStackTrace();
        }
//        System.out.println("fieldValue:"+fieldValue);
        log.info("fieldValue:"+fieldValue);
        out.print(fieldValue);
    }
    return null;
  }


}
