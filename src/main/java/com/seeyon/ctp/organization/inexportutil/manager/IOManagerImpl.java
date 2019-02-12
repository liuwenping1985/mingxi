package com.seeyon.ctp.organization.inexportutil.manager;

import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.DataRow;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
//import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.metadata.manager.MetadataManager;
import com.seeyon.ctp.common.po.filemanager.V3XFile;
import com.seeyon.ctp.organization.OrgConstants.Role_NAME;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.dao.OrgCache;
import com.seeyon.ctp.organization.inexportutil.DataManager;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.inexportutil.inf.IImexPort;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.services.OrganizationServices;
import com.seeyon.ctp.organization.webmodel.WebV3xOrgDepartment;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.annotation.CheckRoleAccess;

public class IOManagerImpl implements IOManager {
	private static final Log log = LogFactory
	                         .getLog(IOManagerImpl.class);
	
	OrganizationServices  organizationServices;
	
	FileToExcelManager fileToExcelManager;
	
	private FileManager fileManager;
	
	private DataManager dataManagerImpl;
	
	private MetadataManager metadataManager;
	
	private OrgCache organization;
	
	
	protected OrgManager orgManager;
	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	User opUser=null;
	
	V3xOrgAccount vaccount=null;

	public OrgCache getOrganization() {
		return organization;
	}
	public void setOrganization(OrgCache organization) {
		this.organization = organization;
	}
	
	public MetadataManager getMetadataManager() {
		return metadataManager;
	}
	public void setMetadataManager(MetadataManager metadataManager) {
		this.metadataManager = metadataManager;
	}
	
	public DataManager getDataManagerImpl() {
		return dataManagerImpl;
	}
	public void setDataManagerImpl(DataManager dataManagerImpl) {
		this.dataManagerImpl = dataManagerImpl;
	}
	
	public FileManager getFileManager() {
		return fileManager;
	}
	public void setFileManager(FileManager fileManager) {
		this.fileManager = fileManager;
	}

	public OrganizationServices getOrganizationServices() {
		return organizationServices;
	}
	public void setOrganizationServices(OrganizationServices organizationServices) {
		this.organizationServices = organizationServices;
	}

	public FileToExcelManager getFileToExcelManager() {
		return fileToExcelManager;
	}
	public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
		this.fileToExcelManager = fileToExcelManager;
	}
	
	public ModelAndView exportReport(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		DataRow[] datarow = (DataRow[])session.getAttribute("datarowlist");
        if (datarow == null) {
            List resultlst = (List) session.getAttribute("resultlst");
            datarow = DataUtil.createDataRowsFromResultObjects(resultlst);
        }
		String importType = (String)session.getAttribute("importType");
		//String language = (String)session.getAttribute("language");
		String import_level_report = ResourceUtil.getString("import.level.report");
		String import_post_report = ResourceUtil.getString("import.post.report");
		String import_team_report = ResourceUtil.getString("import.team.report");
		String import_member_report = ResourceUtil.getString("import.member.report");
		String import_dept_report = ResourceUtil.getString("import.dept.report");
		String import_account_report = ResourceUtil.getString("import.account.report");
		String import_report = ResourceUtil.getString("import.report");
		String import_data = ResourceUtil.getString("import.data");
		String import_result = ResourceUtil.getString("import.result");
		String import_description = ResourceUtil.getString("import.description");
		String title = "";
		String sheetName = "";
		if("level".equals(importType)){
			title = import_level_report;
			sheetName = import_level_report;
		}else if("post".equals(importType)){
			title = import_post_report;
			sheetName = import_post_report;
		}else if("team".equals(importType)){
			title = import_team_report;
			sheetName = import_team_report;
		}else if("member".equals(importType)){
			title = import_member_report;
			sheetName = import_member_report;
		}else if("department".equals(importType)){
			title = import_dept_report;
			sheetName = import_dept_report;
		}else if("account".equals(importType)){
			title = import_account_report;
			sheetName = import_account_report;
		}
//		将导入结果添加到excel中
		DataRecord dataRecord = new DataRecord();
		try {
			dataRecord.addDataRow(datarow);
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		String[] columnName = { import_data , import_result , import_description };
		dataRecord.setColumnName(columnName);
		dataRecord.setTitle(title);
		dataRecord.setSheetName(sheetName);

		try {
			fileToExcelManager.save(response, import_report, dataRecord);
		} catch (Exception e) {
			log.error("error", e);
		}
		return null;
	}
	
    public ModelAndView importExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("organization/selectImportExcel");
        String importType = request.getParameter("importType");
        modelAndView.addObject("importType", importType);
        HttpSession session = request.getSession();
        AppContext.putSessionContext("importType", importType);
        List<V3xOrgAccount> accountlst = this.getOrganizationServices().getOrgManager().getAllAccounts();
        modelAndView.addObject("accountlst", accountlst);
        return modelAndView;
    }
	
	/**
	 * 页面跳转
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    public ModelAndView matchField(HttpServletRequest request, HttpServletResponse response) throws Exception {
        File file = uploadFile(request);
        String path = file.getAbsolutePath() + ".xls";
        File realfile = new File(path);
        DataUtil.CopyFile(file, realfile);

        HttpSession session = request.getSession();
        String selectvalue = request.getParameter("selectvalue");

        AppContext.putSessionContext("selectvalue", selectvalue);
        if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
            throw new Exception("请上传文件对应的表！");
        }
        String radiovalue = request.getParameter("radiovalue");

        AppContext.putSessionContext("radiovalue", radiovalue);
        /*
        if(radiovalue == null || "".equals(radiovalue) || "null".equals(radiovalue)){
        	throw new Exception("请选择单、多表！");
        }*/
        String sheetnumber = request.getParameter("sheetnumber");

        AppContext.putSessionContext("sheetnumber", sheetnumber);
        if ("multi".equals(radiovalue)) {
            if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
                throw new Exception("请选择上传表对应的工作簿的位置！");
            }
        }

        String language = request.getParameter("languagevalue");
        AppContext.putSessionContext("language", language);

        List<List<String>> accountList = null;
        accountList = fileToExcelManager.readExcel(realfile);

        // tanglh test
        if (accountList != null && accountList.size() > 2) {
            log.info("读取默认工作簿的数据，其中个行大小如下");
            for (int i = 2; i < accountList.size(); i++) {
                log.info("accountList i=" + i);
                List l = accountList.get(i);
                if (l == null) {
                    log.info("accountList'subList is null");
                    continue;
                }
                log.info("accountList'subList size=" + l.size());
            }

            // tanglh test

        }
        AppContext.putSessionContext("excellst", accountList);

        return null;

        //return super.redirectModelAndView("/organization.do?method=popMatchPage");

    }

	public ModelAndView matchField1(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		File file = uploadFile(request);
		String path = file.getAbsolutePath()+".xls";
		File realfile = new File(path);
		DataUtil.CopyFile(file,realfile);

		HttpSession session = request.getSession();
		String selectvalue = request.getParameter("selectvalue");
		
		AppContext.putSessionContext("selectvalue", selectvalue);
		if(selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)){
			throw new Exception("请上传文件对应的表！");
		}
		String radiovalue = request.getParameter("radiovalue");
		
		AppContext.putSessionContext("radiovalue", radiovalue);
		/*
		if(radiovalue == null || "".equals(radiovalue) || "null".equals(radiovalue)){
			throw new Exception("请选择单、多表！");
		}*/
		String sheetnumber = request.getParameter("sheetnumber");
		
		AppContext.putSessionContext("sheetnumber", sheetnumber);
		if("multi".equals(radiovalue)){
			if(selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)){
				throw new Exception("请选择上传表对应的工作簿的位置！");
			}	
		}
		
		String language = request.getParameter("languagevalue");
		AppContext.putSessionContext("language", language);
		
		//从后台取出数据字段列表
		List datastrulst = getDataManagerImpl().getDataStructure(selectvalue);
		DataUtil du = new DataUtil(selectvalue);
		datastrulst = du.getCHNString(datastrulst, request);
		AppContext.putSessionContext("datastrulst", datastrulst);
		List<List<String>> accountList = null;
		if("multi".equals(radiovalue)){
			accountList = fileToExcelManager.readExcel(realfile);
		}else if("single".equals(radiovalue)){
			//读取默认工作簿的数据
			accountList = fileToExcelManager.readExcel(realfile);
			
			//tanglh test
			if(accountList!=null && accountList.size()>2){
				log.info("读取默认工作簿的数据，其中个行大小如下");
				for(int i=2;i<accountList.size();i++){
					log.info("accountList i="+i);
					List l=accountList.get(i);
					if(l==null){
						log.info("accountList'subList is null");
						continue;
					}
					log.info("accountList'subList size="+l.size());
				}
			}
			
//			tanglh test

		}
		AppContext.putSessionContext("excellst", accountList);
		/*
		//读取表头数据，一般为第二行
		List proList = accountList.get(1);
		
		//得到匹配的list,及不匹配的list 组成的map
		allmap = DataUtil.getMatchList(proList, datastrulst);
		
		AppContext.putSessionContext("allmap", allmap);
*/
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("parent.getA8Top().contentFrame.topFrame.matchfiled();");
		out.println("</script>");		
		return null;
		/*
		out.println("<script>");
		//out.println("parent.window.close();");
		//out.println("parent.top.contentFrame.topFrame.matchfiled();");
		//out.println("parent.window.close();");//tanglh
		out.println("document.location.href= '${organizationURL}?method=popMatchPage';");//tanglh
		out.println("</script>");		
		
		return super.redirectModelAndView("/organization.do?method=popMatchPage");
*/
	}	
	public ModelAndView popMatchPage(HttpServletRequest request,
			HttpServletResponse response) throws Exception {		
		HttpSession session = request.getSession();
		ModelAndView modelAndView = new ModelAndView("organization/matchField");
		Map allmap = (Map)session.getAttribute("allmap");

		//用于页面已匹配下拉列表框
		modelAndView.addObject("matchlst", allmap.get("0"));	
		//用于页面的新增下拉列表框
		modelAndView.addObject("excellst", allmap.get("1"));
        //用于页面的删除下拉列表框
		modelAndView.addObject("strulst", allmap.get("2"));
		
		modelAndView.addObject("language", (String)session.getAttribute("language"));
		modelAndView.addObject("selectvalue", (String)session.getAttribute("selectvalue"));
		modelAndView.addObject("radiovalue",(String) session.getAttribute("radiovalue"));
		modelAndView.addObject("sheetnumber", (String)session.getAttribute("sheetnumber"));
		
		
		session.removeAttribute("allmap");
		return modelAndView;
	}
	
	/**
	 * 导入文件跳转controller
	 */
    public ModelAndView importReport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("apps/organization/common/importReport");
        HttpSession session = request.getSession();

        String selectvalue = request.getParameter("selectvalue");
        if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
            throw new Exception("请上传文件对应的表！");
        }
        String deptOrRole = "";
        if("department".equals(selectvalue)){
            deptOrRole = request.getParameter("depart");
            modelAndView.addObject("deptOrRole", deptOrRole);
            AppContext.putSessionContext("deptOrRole", deptOrRole);
        }

        //跳过为 1  覆盖为 0
        String repeat = request.getParameter("repeat");

        String language = request.getParameter("language");
        if (Strings.isBlank(language))
            language = "zh_CN";//默认中文

        String impURL = request.getParameter("impURL");
        if (!StringUtils.hasText(impURL)) {
            impURL = (String) session.getAttribute("impURL");
        }
        log.info("impURL=" + impURL);

        List resultlst = (List) session.getAttribute("resultlst");
        if (resultlst == null) {
            resultlst = DataUtil.getResult4Imp(selectvalue);
        }
        if (resultlst == null) {
            resultlst = new ArrayList();
        }

        modelAndView.addObject("selectvalue", selectvalue);
        AppContext.putSessionContext("selectvalue", selectvalue);
        AppContext.putSessionContext("importType", selectvalue);
        modelAndView.addObject("repeat", repeat);
        AppContext.putSessionContext("repeat", repeat);
        modelAndView.addObject("language", language);
        AppContext.putSessionContext("language", language);
        modelAndView.addObject("impURL", impURL);
        AppContext.putSessionContext("impURL", impURL);

        //query.setFirstResult(Pagination.getFirstResult());
        //query.setMaxResults(Pagination.getMaxResults());
        //Pagination.setRowCount(resultlst.size());
        List subl = DataUtil.pageForList(resultlst);

        modelAndView.addObject("resultlst", subl);

        return modelAndView;
    }
    
	/**
	 * 導入操作以及页面跳转
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public String doImport4Redirect(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//ModelAndView modelAndView = new ModelAndView("organization/importReport");		
		HttpSession session = request.getSession();

		String selectvalue = request.getParameter("selectvalue");
		if(selectvalue==null){
			selectvalue=(String)request.getAttribute("selectvalue");
		}
		if(selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)){
			throw new Exception("请上传文件对应的表！");
		}
		
		File file = uploadFile(request);
		if(file==null){
			return "";
		}
		String path = file.getAbsolutePath()+file.getName();//+".xlsx";
		//String path = file.getAbsolutePath()+".xls";
		File realfile = new File(path);
		DataUtil.CopyFile(file,realfile);
		
		AppContext.putSessionContext("selectvalue", selectvalue);
		if(selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)){
			throw new Exception("请上传文件对应的表！");
		}
		String radiovalue = request.getParameter("radiovalue");
		AppContext.putSessionContext("radiovalue", radiovalue);
		String sheetnumber = request.getParameter("sheetnumber");
		
		AppContext.putSessionContext("sheetnumber", sheetnumber);
		if("multi".equals(radiovalue)){
			if(selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)){
				throw new Exception("请选择上传表对应的工作簿的位置！");
			}	
		}

		//跳过为 1  覆盖为 0
		String repeat = request.getParameter("repeat");
        boolean ignoreWhenUpdate = "0".equals(repeat) ? false : true;
		
		String language = request.getParameter("language");
		if(Strings.isBlank(language)) language = "zh_CN";
		AppContext.putSessionContext("language", language);
//		Locale locale = null;
//		// 根据选择导入文件语言获取对应locale对象
//		if(language.equals("zh_CN")){
//			locale = Locale.CHINA;
//		}else if(language.equals("en")){
//			locale = Locale.ENGLISH;
//		}else if(language.equals("zh")){
//			locale = Locale.TAIWAN;
//		}
		
		String impURL = request.getParameter("impURL");//???
		AppContext.putSessionContext("impURL", impURL);

        List<List<String>> accountList = null;
        List reall = new ArrayList();
        accountList = fileToExcelManager.readExcel(realfile);
        String deptOrRole = null;
        if("department".equals(selectvalue)){
            deptOrRole = request.getParameter("depart");
            List<String> firstString = new ArrayList<String>();
            firstString.add(deptOrRole);
            firstString.add(deptOrRole);
            
            accountList.set(0, firstString);
        }
        

        //tanglh test
        if (accountList != null && accountList.size() > 2) {
            log.info("读取默认工作簿的数据，其中个行大小如下");
            for (int i = 2; i < accountList.size(); i++) {
                List l = accountList.get(i);
                if (l == null) {
                    log.info("accountList'subList is null");
                    continue;
                }
            }
            reall = accountList.subList("department".equals(selectvalue)?0:2, accountList.size());
        }
        // tanglh test
			
        DataUtil du = new DataUtil(selectvalue);
        Map reportmap = du.getIip().importOrg(organizationServices, metadataManager, reall, this.getVaccount(),
                ignoreWhenUpdate);

        List resultlst = this.createResultObjectList(reportmap);

		AppContext.putSessionContext("resultlst", resultlst);
		DataUtil.putResult4Imp(selectvalue, resultlst);
		
		return DataUtil.getImportReportURL(selectvalue, repeat, language, impURL);
		
	}
	
    public ModelAndView doImport(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelAndView = new ModelAndView("organization/importReport");
        HttpSession session = request.getSession();

        String selectvalue = request.getParameter("selectvalue");
        if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
            throw new Exception("请上传文件对应的表！");
        }

        File file = uploadFile(request);
        String path = file.getAbsolutePath() + ".xls";
        File realfile = new File(path);
        DataUtil.CopyFile(file, realfile);

        AppContext.putSessionContext("selectvalue", selectvalue);
        if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
            throw new Exception("请上传文件对应的表！");
        }
        String radiovalue = request.getParameter("radiovalue");

        AppContext.putSessionContext("radiovalue", radiovalue);
        /*
        if(radiovalue == null || "".equals(radiovalue) || "null".equals(radiovalue)){
        	throw new Exception("请选择单、多表！");
        }*/
        String sheetnumber = request.getParameter("sheetnumber");

        AppContext.putSessionContext("sheetnumber", sheetnumber);
        if ("multi".equals(radiovalue)) {
            if (selectvalue == null || "".equals(selectvalue) || "null".equals(selectvalue)) {
                throw new Exception("请选择上传表对应的工作簿的位置！");
            }
        }

        //AppContext.putSessionContext("excellst", accountList);

        //跳过为 1  覆盖为 0
        String repeat = request.getParameter("repeat");
        boolean ignoreWhenUpdate = "0".equals(repeat) ? false : true;

        String language = request.getParameter("language");
        modelAndView.addObject("language", language);
        AppContext.putSessionContext("language", language);
        Locale locale = null;
        //		根据选择导入文件语言获取对应locale对象
        if ("zh_CN".equals(language)) {
            locale = Locale.CHINA;
        } else if ("en".equals(language)) {
            locale = Locale.ENGLISH;
        } else if ("zh".equals(language)) {
            locale = Locale.TAIWAN;
        }

        String impURL = request.getParameter("impURL");//???
        modelAndView.addObject("impURL", impURL);//???

        List<List<String>> accountList = null;
        accountList = fileToExcelManager.readExcel(realfile);

        //tanglh test
        if (accountList != null && accountList.size() > 2) {
            log.info("读取默认工作簿的数据，其中个行大小如下");
            for (int i = 2; i < accountList.size(); i++) {
                log.info("accountList i=" + i);
                List l = accountList.get(i);
                if (l == null) {
                    log.info("accountList'subList is null");
                    continue;
                }
                log.info("accountList'subList size=" + l.size());
            }
        }

        List reall = new ArrayList();
        if (null != accountList && accountList.size() > 2) {
            reall = accountList.subList(2, accountList.size());
        }

        DataUtil du = new DataUtil(selectvalue);
        //开始导入
        Map reportmap = du.getIip().importOrg(organizationServices, metadataManager, reall, this.getVaccount(),
                ignoreWhenUpdate);

        List resultlst = this.createResultObjectList(reportmap);

        AppContext.putSessionContext("resultlst", resultlst);
        modelAndView.addObject("resultlst", resultlst);
        modelAndView.addObject("repeat", repeat);//repeat

        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("parent.closeOnbeforeunload('?method=);");
        out.println("</script>");

        return null;
    }
	
    private File uploadFile(HttpServletRequest request) throws Exception {
        Map<String, V3XFile> v3xFiles = new HashMap<String, V3XFile>();
        File fil = null;
        try {
            V3XFile v3x = null;
            v3xFiles = fileManager.uploadFiles(request, "xls,xlsx", null);
            String key = "";
            if (v3xFiles != null) {
                Iterator<String> keys = v3xFiles.keySet().iterator();
                while (keys.hasNext()) {
                    key = keys.next();
                    v3x = (V3XFile) v3xFiles.get(key);
                }
            }
            if (null != v3x) {
                fil = fileManager.getFile(v3x.getId(), v3x.getCreateDate());
            }
        } catch (Exception e) {
            log.error("", e);
        }
        return fil;
    }

	public ModelAndView expOrgToExcel(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		User user = catchCurrentUser();
//		----------------------------------accountSheet---------------------
		V3xOrgAccount account = this.getOrganizationServices().getOrgManager().getAccountById(user.getLoginAccount());
		List<V3xOrgDepartment> deptlist = this.getOrganizationServices().getOrgManager().getAllDepartments(user.getLoginAccount());
		for (int i = 0; i < deptlist.size(); i++) {
			V3xOrgDepartment dept = (V3xOrgDepartment) deptlist
					.get(i);
			Long longid = dept.getId();
			V3xOrgDepartment parent = this.getOrganizationServices().getOrgManager().getParentDepartment(longid);
			WebV3xOrgDepartment webdept = new WebV3xOrgDepartment();
			webdept.setV3xOrgDepartment(dept);
			if (null != parent) {
				webdept.setParentId(parent.getId());
				webdept.setParentName(parent.getName());
			} else {
				if (dept.getPath().indexOf(".") > 0
						&& (dept.getPath().indexOf(".") == dept.getPath()
								.lastIndexOf("."))) {
					webdept.setParentId(dept.getOrgAccountId());
					webdept.setParentName(account.getName());
				}
			}
		}
		return null;
	}
	
	public User getOpUser() {
		return opUser;
	}
	public void setOpUser(User opUser) {
		this.opUser = opUser;
	}
	
	public V3xOrgAccount getVaccount() {
		return vaccount;
	}
	public void setVaccount(V3xOrgAccount vaccount) {
		this.vaccount = vaccount;
	}
	public void setVaccountByUser(Long accountId){
	    try{
            V3xOrgAccount vao=orgManager.getAccountById(accountId);
            setVaccount(vao);
        }catch(Exception e){
            log.error("error", e);
        }
	}
	
    public List createResultObjectList(Map resultMap) {
        List l = new ArrayList();

        try {
            List addl = (List) resultMap.get(IImexPort.RESULT_ADD);
            if (addl != null)
                l.addAll(addl);

            List updatel = (List) resultMap.get(IImexPort.RESULT_UPDATE);
            if (updatel != null)
                l.addAll(updatel);

            List ignorel = (List) resultMap.get(IImexPort.RESULT_IGNORE);
            if (ignorel != null)
                l.addAll(ignorel);

            List errorl = (List) resultMap.get(IImexPort.RESULT_ERROR);
            if (errorl != null)
                l.addAll(errorl);
            List nitexistl = (List) resultMap.get(IImexPort.RESULT_NOTEXIST);
            if (nitexistl != null)
                l.addAll(nitexistl);
        } catch (Exception e) {
            log.error("error", e);
        }

        return l;
    }
	
	public void writeExpEndProcScript(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		PrintWriter out = response.getWriter();
		out.println("<script>");
		out.println("parent.closeOnbeforeunload();");
		out.println("</script>");
	}
	
	public static final String EXP_BASE_VIEW="organization/expbase";
	public static final String EXP_REPEATER_VIEW="organization/exprepeater";
	public static final String IMP_BASE_VIEW="organization/impbase"; 
	
	public static final String PARA_TARGET_URL_BASE="paratargeturl"; 
	public static final String PARA_TOMETHOD_BASE="tomethod"; 
	public static final String PARA_METHOD_BASE="method"; 
	
	public ModelAndView toExpRepeater(HttpServletRequest request,
			HttpServletResponse response,String url) throws Exception {
		ModelAndView mv = new ModelAndView(EXP_REPEATER_VIEW);
		mv.addObject(PARA_TARGET_URL_BASE, url);
		
		return mv;
	}
	public ModelAndView toImpBase(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		return toBaseJSP(request,response,IMP_BASE_VIEW);
	}
	
	public ModelAndView toExpBase(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		return toBaseJSP(request,response,EXP_BASE_VIEW);
	}
	protected ModelAndView toBaseJSP(HttpServletRequest request,
			HttpServletResponse response,String viewname) throws Exception {
		ModelAndView mv = new ModelAndView(viewname);
		
		String qStr4BaseJsp=getQueryString4BaseJsp(request,response);
		mv.addObject(PARA_TARGET_URL_BASE, qStr4BaseJsp);
		
		return mv;
	}
	protected String getQueryString4BaseJsp(HttpServletRequest request,
			HttpServletResponse response) throws Exception{
		String org=request.getQueryString();
		log.info("QueryString="+org);
		if(!StringUtils.hasText(org))
			return org;
		int mt=org.indexOf(PARA_TOMETHOD_BASE);
		if(mt<0)
			return org;
		
		return org.substring(mt+2);
	}
	
//	tanglh  判断是否可以执行IO
	//客开 @CheckRoleAccess(roleTypes={Role_NAME.GroupAdmin,Role_NAME.AccountAdministrator,Role_NAME.HrAdmin})
	public String canIO() throws Exception {
		return this.canIO(catchCurrentUser());
	}
//	tanglh  判断是否可以执行IO
	public String canIO(User u) throws Exception {
		if(u==null){
			return "nouser";
		}		
		
		return canIO(u.getId());
	}
	public String canIO(long userid) throws Exception {
		return DataUtil.doingImpExp(userid)?"doing":"ok";
	}
	public String canIO(String userid) throws Exception {
		try{
			return canIO(Long.parseLong(userid));
		}catch(Exception e){
			return canIO();
		}
	}
	
	private User catchCurrentUser(){
		return AppContext.getCurrentUser();
	}
}//end class
