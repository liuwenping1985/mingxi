/**
 * 
 */
package com.seeyon.v3x.common.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.commons.logging.Log;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.log.CtpLogFactory;
import com.seeyon.ctp.util.Strings;


/**
 * 通用的Controller，以实现将JSP快速实现MVC；<br>
 * <b>此框架从2016年5月16日起废弃，但老的兼容</b>
 * 
 * @author <a href="mailto:tanmf@seeyon.com">Tanmf</a>
 * @version 1.0 2006-10-16
 * @deprecated
 */
public class GenericController extends BaseController {
	protected static final Log LOG = CtpLogFactory.getLog(GenericController.class);

	public static final String Parameter_Name_ViewPage = "ViewPage";
	
	private static final String WhiteListString = 
	        "ctp/common/fileUpload/officeEdit," + 
            "ctp/form/design/eventTip," + 
            "personalAffair/person/setHead," + 
            "apps/autoinstall/downLoadIESet," + 
			"apps/collaboration/fileUpload/attEdit," + 
			"apps/collaboration/fileUpload/attEdit1," +   //客开
			"apps/collaboration/fileUpload/attEdit2," + //kekai zhaohui
			"apps/collaboration/fileUpload/attEditDes," +
			"apps/doc/docPanel," +
			"apps/doc/history/editVersionComment," + 
			"apps/uc/downLoadIESet," +
			"edoc/selectDeptSender," +
			"edoc/templete/saveAsTemplate," +
			"news/audit/lookImage," +
			"inquiry/add," + 
			"project/nodeDescription," +
			"hr/viewSalary/calendarFrame," + 
			"plugin/formtalk/templateIndex," + 
			"plugin/formtalk/templateList," + 
			"plugin/formtalk/unFlowTemplateList," + 
			"plugin/nc/filderFrame," + 
			"plugin/nc/ssologin," + 
			"plugin/nc/A8," +
			"plugin/nc/ncAppletIframe," + 
			"plugin/u8/synchro/filderFrame," + 
			"plugin/didicar/comQuery," + 
			"";
	
	private static final Set<String> WhiteList = new HashSet<String>();
	static{
		String[] tem = WhiteListString.split(",");
		for (String s : tem) {
		    if(Strings.isNotBlank(s)){
		        WhiteList.add(s);
		    }
		}
	}

	/**
	 * 将ViewPage通过参数传入，构造ModelAndView，本方法不负责任何业务逻辑
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ModelAndView index(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String ViewPage = request.getParameter(Parameter_Name_ViewPage);
		String from = request.getParameter("from");
		LOG.debug("ViewPage : " + ViewPage);
		if (ViewPage == null || "".equals(ViewPage)) {
			throw new java.lang.IllegalArgumentException("Parameter 'ViewPage' is not available.");
		}
		
//		File file = new File(SystemEnvironment.getApplicationFolder() + "/WEB-INF/jsp/" + ViewPage + ".jsp");
//		if(!file.exists()){
//		    response.sendError(404);
//		    return null;
//		}

		if(!WhiteList.contains(ViewPage)) {
		    OutputStream out2 = new FileOutputStream(SystemEnvironment.getBaseFolder() + File.separator + "GenericController.log", true);
		    IOUtils.write(ViewPage + ",\r\n", out2);
		    IOUtils.closeQuietly(out2);
		    
            response.sendError(404);
            return null;
		}

		ModelAndView modelAndView = new ModelAndView(ViewPage);
		modelAndView.addObject("from", from);
		return modelAndView;
	}

}
