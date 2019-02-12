package com.seeyon.ctp.common.office;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.util.Strings;
/**
 * TODO
 *
import com.seeyon.ctp.common.web.login.CurrentUserToSeeyonApp;
import com.seeyon.ctp.common.web.util.ThreadLocalUtil;
*/

public class HtmlOfficeServlet extends HttpServlet {
	
	private static Log log = LogFactory.getLog(HtmlOfficeServlet.class);
	

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	    /**
	     * TODO
	     *
		CurrentUserToSeeyonApp.set(request.getSession());
		*/
	    AppContext.initSystemEnvironmentContext(request, response);
		//ApplicationContext ctx = (ApplicationContext) getServletContext().getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
		HandWriteManager handWriteManager = (HandWriteManager) AppContext.getBean("handWriteManager");
		HtmlHandWriteManager htmlHandWriteManager = (HtmlHandWriteManager) AppContext.getBeanWithoutCache("htmlHandWriteManager");

		DBstep.iMsgServer2000 msgObj = new DBstep.iMsgServer2000();
		try {
			handWriteManager.readVariant(request, msgObj);
			if(AppContext.currentUserId()==-1L){
				User user = handWriteManager.getCurrentUser(msgObj);
				AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, user);
			}
			msgObj.SetMsgByName("CLIENTIP", Strings.getRemoteAddr(request));

			String option = msgObj.GetMsgByName("OPTION");
		
			if ("LOADFILE".equalsIgnoreCase(option)) {
				handWriteManager.LoadFile(msgObj);
			}			
			else if("LOADSIGNATURE".equalsIgnoreCase(option))
			{
				htmlHandWriteManager.loadDocumentSinature(msgObj);
			}
			else if("LOADMARKLIST".equalsIgnoreCase(option))
			{
				handWriteManager.LoadSinatureList(msgObj);
			}
			else if("SIGNATRUEIMAGE".equalsIgnoreCase(option))
			{
				handWriteManager.LoadSinature(msgObj);
			}			
			else if("SAVESIGNATURE".equalsIgnoreCase(option))
			{
				htmlHandWriteManager.saveSignature(msgObj);
			}
			else if("SAVEHISTORY".equalsIgnoreCase(option))
			{
				htmlHandWriteManager.saveSignatureHistory(msgObj);
			}
			else if("SIGNATRUELIST".equalsIgnoreCase(option))
			{//调入印章列表
				handWriteManager.LoadSinatureList(msgObj);
			}
			else if("SHOWHISTORY".equalsIgnoreCase(option))
			{
				htmlHandWriteManager.getSignatureHistory(msgObj);
			}else if("SAVEASIMG".equalsIgnoreCase(option)){
				String fileName = msgObj.GetMsgByName("FILENAME");
				String tempFolder = new File(new File("").getAbsolutePath()).getParentFile().getParentFile().getPath();
				String tempPath = tempFolder + "/base/upload/taohongTemp" ;
				File folder = new File(tempPath);
				if(!folder.exists()){
					folder .mkdir(); 
				}
				msgObj.MsgFileSave(tempPath + "/" + fileName);
			}

			handWriteManager.sendPackage(response, msgObj);
		}
		catch (Exception e) {
			log.error("",e);
			msgObj = new DBstep.iMsgServer2000();
			msgObj.MsgError("htmoffice operate err");
			handWriteManager.sendPackage(response, msgObj);
		}
		AppContext.clearThreadContext();
	}

	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		this.doGet(request, response);
	}

}
