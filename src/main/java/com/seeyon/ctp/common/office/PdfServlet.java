package com.seeyon.ctp.common.office;

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

/**
 * TODO
 *
import com.seeyon.ctp.common.web.login.CurrentUserToSeeyonApp;
*/

public class PdfServlet extends HttpServlet {
    private static Log log = LogFactory.getLog(PdfServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        /**
         * TODO
         *
         CurrentUserToSeeyonApp.set(request.getSession());
        */
//        ApplicationContext ctx = (ApplicationContext) getServletContext().getAttribute(
//                WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
        AppContext.initSystemEnvironmentContext(request, response);
        HandWriteManager handWriteManager = (HandWriteManager) AppContext.getBeanWithoutCache("handWriteManager");
        DBstep.iMsgServer2000 msgObj = new DBstep.iMsgServer2000();
        try {
            handWriteManager.readVariant(request, msgObj);

            String option = msgObj.GetMsgByName("OPTION");
            if(AppContext.currentUserId()==-1L){
				User user = handWriteManager.getCurrentUser(msgObj);
				AppContext.putThreadContext(GlobalNames.SESSION_CONTEXT_USERINFO_KEY, user);
			}
            if ("LOADFILE".equalsIgnoreCase(option)) {
                handWriteManager.LoadFile(msgObj);
            }
            if ("SAVEFILE".equalsIgnoreCase(option)) {
                handWriteManager.saveFile(msgObj);
            }
            if("SENDMESSAGE".equalsIgnoreCase(option)){
            	handWriteManager.deleteFile(msgObj);
            }
            handWriteManager.sendPackage(response, msgObj);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doGet(req, resp);
    }

}
