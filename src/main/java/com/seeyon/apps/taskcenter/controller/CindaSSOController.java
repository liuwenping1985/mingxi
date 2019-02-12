package com.seeyon.apps.taskcenter.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.seeyon.apps.cinda.sso.SSOLoginHandShakeCinda;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
///cn.com.hkgt.idp.client.filter.IDPFilter
@NeedlessCheckLogin
public class CindaSSOController extends BaseController{
	private static final Log log = LogFactory.getLog(CindaSSOController.class);
	
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response)throws Exception{
		String uid = String.valueOf(request.getSession().getAttribute("cn.com.hkgt.idp.client.filter.user"));
		String url = "/seeyon/main.do";
		log.info("得到单点信息是uid=="+uid);
		if(Strings.isNotBlank(uid)){
			V3xOrgMember member = OrgHelper.getOrgManager().getMemberByLoginName(uid);
			if(member!=null && member.getEnabled()){
				String ticket = SSOLoginHandShakeCinda.makeTicket(uid);
				url="/seeyon/login/sso?from=cindasso&ticket="+ticket;
				log.info("跳转到OASSO地址"+url);
				response.sendRedirect(url);
			}else{
				log.info("OA中没有匹配到有效的用户名"+uid+"，系统将跳转至OA登录页！");
				super.rendJavaScript(response, "alert('用户"+uid+"不是OA用户！');window.location.href = '"+url+"';");
			}
		}
//		log.info("跳转到OASSO地址"+url);
//		super.rendJavaScript(response, "window.location.href = '"+url+"'");
		return null;
		
		
	}


}
