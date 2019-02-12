/**
 * $Author: wangchw $
 * $Rev: 49432 $
 * $Date:: 2015-05-18 13:38:04 +#$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.link.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ProductEditionEnum;
import com.seeyon.ctp.common.constants.SystemProperties;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.excel.DataRecord;
import com.seeyon.ctp.common.excel.FileToExcelManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.organization.inexportutil.DataUtil;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.link.manager.LinkCategoryManager;
import com.seeyon.ctp.portal.link.manager.LinkMenuManager;
import com.seeyon.ctp.portal.link.manager.LinkOptionManager;
import com.seeyon.ctp.portal.link.manager.LinkSectionManager;
import com.seeyon.ctp.portal.link.manager.LinkSpaceManager;
import com.seeyon.ctp.portal.link.manager.LinkSystemManager;
import com.seeyon.ctp.portal.link.util.Constants;
import com.seeyon.ctp.portal.link.webmodel.LinkMoreVO;
import com.seeyon.ctp.portal.link.webmodel.LinkShowVO;
import com.seeyon.ctp.portal.link.webmodel.PortalLinkOptionVO;
import com.seeyon.ctp.portal.po.PortalLinkCategory;
import com.seeyon.ctp.portal.po.PortalLinkMenu;
import com.seeyon.ctp.portal.po.PortalLinkOption;
import com.seeyon.ctp.portal.po.PortalLinkOptionValue;
import com.seeyon.ctp.portal.po.PortalLinkSection;
import com.seeyon.ctp.portal.po.PortalLinkSpace;
import com.seeyon.ctp.portal.po.PortalLinkSystem;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;

/**
 * <p>Title: 关联系统控制器类</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class LinkSystemController extends BaseController {
    private LinkSystemManager   linkSystemManager;
    private FileManager         fileManager;
    private FileToExcelManager  fileToExcelManager;
    private LinkSectionManager  linkSectionManager;
    private LinkOptionManager   linkOptionManager;
    private LinkSpaceManager    linkSpaceManager;
    private LinkCategoryManager linkCategoryManager;
    private OrgManager          orgManager;
    private LinkMenuManager     linkMenuManager;

    public void setLinkSystemManager(LinkSystemManager linkSystemManager) {
        this.linkSystemManager = linkSystemManager;
    }

    public void setFileManager(FileManager fileManager) {
        this.fileManager = fileManager;
    }

    public void setFileToExcelManager(FileToExcelManager fileToExcelManager) {
        this.fileToExcelManager = fileToExcelManager;
    }

    public void setLinkSectionManager(LinkSectionManager linkSectionManager) {
        this.linkSectionManager = linkSectionManager;
    }

    public void setLinkOptionManager(LinkOptionManager linkOptionManager) {
        this.linkOptionManager = linkOptionManager;
    }

    public void setLinkSpaceManager(LinkSpaceManager linkSpaceManager) {
        this.linkSpaceManager = linkSpaceManager;
    }

    public void setLinkCategoryManager(LinkCategoryManager linkCategoryManager) {
        this.linkCategoryManager = linkCategoryManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setLinkMenuManager(LinkMenuManager linkMenuManager) {
        this.linkMenuManager = linkMenuManager;
    }

    /**
     * 关联系统管理主页面
     * @return 
     * @throws BusinessException 
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public ModelAndView linkSystemMain(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/portal/link/linkSystemMain");
        Integer productId =  SystemProperties.getInstance().getIntegerProperty("system.ProductId");        
        boolean isSystemAdmin = AppContext.isSystemAdmin();
        if(ProductEditionEnum.a6p.ordinal() == productId || ProductEditionEnum.a6.ordinal() == productId){
        	isSystemAdmin=AppContext.isAdministrator();
        }
        //越权isSystemAdmin = Boolean.valueOf(request.getParameter("isAdmin"));
        List<PortalLinkCategory> linkCategories = new ArrayList<PortalLinkCategory>();
        if (isSystemAdmin) {
            linkCategories.add(new PortalLinkCategory(0, ResourceUtil.getString("link.category.manage"), -1));
            List<PortalLinkCategory> list = linkCategoryManager.getCategoriesByAdmin();
            Iterator<PortalLinkCategory> itr = list.iterator();
            while(itr.hasNext()){
                PortalLinkCategory category = itr.next();
                category.setCname(ResourceUtil.getString(category.getCname()));
                if(Constants.LINK_CATEGORY_KNOWLEDGE_ID == category.getId() && (ProductEditionEnum.a6p.ordinal() == productId || ProductEditionEnum.a6.ordinal() == productId)){
                    itr.remove();
                }
            }
            linkCategories.addAll(list);
        } else {
            linkCategories.add(new PortalLinkCategory(0, ResourceUtil.getString("link.category.knowledge"), -1));
            linkCategories.add(new PortalLinkCategory(5, ResourceUtil.getString("link.category.othershare"), 0));
            linkCategories.add(new PortalLinkCategory(6, ResourceUtil.getString("link.category.myknowledge"), 0));
            linkCategories.addAll(linkCategoryManager.getCategoriesByUser());
        }
        request.setAttribute("fftree", linkCategories);
        Map params = new HashMap();
        if (!CollectionUtils.isEmpty(linkCategories)) {
            params.put("categoryId", linkCategories.get(1).getId());
            FlipInfo fi = linkSystemManager.selectLinkSystem(new FlipInfo(), params);
            fi.setParams(params);
            request.setAttribute("ffmytable", fi);
        }
        mav.addObject("isSystemAdmin", isSystemAdmin);
        request.setAttribute("currentUserId", AppContext.currentUserId());
        return mav;
    }

    /**
     * 关联系统参数管理页面
     * @return 
     * @throws BusinessException 
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
    public ModelAndView linkOptionValueMain(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/portal/link/linkOptionValueMain");
        String linkSystemId = request.getParameter("linkSystemId");
        if(linkSystemId == null || "null".equals(linkSystemId)){
            return mav;
        }
        Map params = new HashMap();
        params.put("linkSystemId", linkSystemId);
        FlipInfo fi = linkOptionManager.selectLinkOptionValues(new FlipInfo(), params);
        List<PortalLinkOption> linkOptionList = linkOptionManager.selectLinkOptions(Long.valueOf(linkSystemId));
        request.setAttribute("ffoptionValueTable", fi);
        request.setAttribute("linkOptionList", linkOptionList);
        request.setAttribute("linkSystemId", linkSystemId);
        mav.addObject("linkSystemId", linkSystemId);
        //关联系统参数个数
        int linkOptionListNum = linkOptionList.size();
        //表头已有的两个列头：userName，loginName
        int tableHeadExistNum = 2;
        //每一列的百分比
        int columnWidthPecent = 100 / (linkOptionListNum + tableHeadExistNum);
        mav.addObject("columnWidthPecent", columnWidthPecent);
        return mav;
    }

    /**
     * 关联系统参数导入
     * @throws IOException 
     */
    public ModelAndView importOptionValue(HttpServletRequest request, HttpServletResponse response)
            throws BusinessException, IOException {
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        User u = AppContext.getCurrentUser();
        if (u == null) {
            return null;
        }
        if (DataUtil.doingImpExp(u.getId())) {
            DataUtil.removeImpExpAction(u.getId());
            return null;
        }

        DataUtil.putImpExpAction(u.getId(), "import");
        String linkSystemId = request.getParameter("linkSystemId");
        String repeat = request.getParameter("repeat");
        Long linkSystemIdLong = 0l;
        try {
            linkSystemIdLong = Long.parseLong(linkSystemId);
        } catch (NumberFormatException nfe) {
            logger.error("error when parse linkSystemId to long, linkSystemId" + linkSystemId, nfe);
            DataUtil.removeImpExpAction(u.getId());
            out.println(ResourceUtil.getString("link.jsp.import.fail.prompt"));
            out.flush();
            return null;
        }
        String results = "";
        try {
            List<PortalLinkOption> linkOptionList = linkOptionManager.selectLinkOptions(linkSystemIdLong);
            if (linkOptionList == null || linkOptionList.size() == 0) {
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.nooption.prompt"));
                out.flush();
                return null;
            }
            File xlsFile = fileManager.getFile(Long.parseLong(request.getParameter("fileid")), new Date());
            //重复解密File xlsFileDecrypted = fileManager.decryptionFile(xlsFile);
            List<List<String>> linkOptionValueList = fileToExcelManager.readExcel(xlsFile);
            List<List<String>> realLinkOptionValueList = new ArrayList<List<String>>();
            //验证模板有效性--start
            if (linkOptionValueList == null || linkOptionValueList.size() <= 2) {
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                out.flush();
                return null;
            }
            if (linkOptionList.size() != linkOptionValueList.get(1).size() - 2) {
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                out.flush();
                return null;
            }
            for (int i = 0; i < linkOptionList.size(); i++) {
                PortalLinkOption loTmp = linkOptionList.get(i);
                if (!loTmp.getParamName().equals(linkOptionValueList.get(1).get(i + 1).trim())) {
                    DataUtil.removeImpExpAction(u.getId());
                    out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                    out.flush();
                    return null;
                }
            }
            //验证模板有效性--end
            realLinkOptionValueList = linkOptionValueList.subList(1, linkOptionValueList.size());
            results = linkOptionManager.importLinkOptinValue(linkSystemIdLong, realLinkOptionValueList, repeat);
        } catch (BusinessException e) {
            DataUtil.removeImpExpAction(u.getId());
            out.println(ResourceUtil.getString("link.jsp.import.fail.prompt") + "<br/>" + e.getMessage());
            out.flush();
            return null;
        } catch (Exception e) {
            DataUtil.removeImpExpAction(u.getId());
            out.println(ResourceUtil.getString("link.jsp.import.fail.prompt") + "<br/>" + e.getMessage());
            out.flush();
            return null;
        }
        DataUtil.removeImpExpAction(u.getId());
        out.println(ResourceUtil.getString("link.jsp.import.success.prompt") + "<br/>" + results);
        out.flush();
        return null;
    }

    /**
     * 下载模板
     */
    public ModelAndView downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("utf-8");
        User u = AppContext.getCurrentUser();
        if (u == null) {
            //DataUtil.outNullUserAlertScript(out);
            return null;
        }
        if (DataUtil.doingImpExp(u.getId())) {
            //DataUtil.outDoingImpExpAlertScript(out);
            return null;
        }
        String linkSystemId = request.getParameter("linkSystemId");
        if(linkSystemId == null || linkSystemId.trim().length() == 0){
            PrintWriter out = response.getWriter();
            out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.nooption.prompt") + "\")</script>");
            out.flush();
            return null;
        }
        Long linkSystemId_long = 0l;
        try {
            linkSystemId_long = Long.parseLong(linkSystemId);
        } catch (NumberFormatException nfe) {
            logger.error("error when parse linkSystemId to long", nfe);
            DataUtil.removeImpExpAction(u.getId());
            PrintWriter out = response.getWriter();
            out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
            out.flush();
            return null;
        }
        List<PortalLinkOption> linkOptionList = linkOptionManager.selectLinkOptions(linkSystemId_long);
        if (linkOptionList == null || linkOptionList.size() == 0) {
            DataUtil.removeImpExpAction(u.getId());
            PrintWriter out = response.getWriter();
            out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.nooption.prompt") + "\")</script>");
            out.flush();
            return null;
        }
        String fName = "LinkOptionValue_" + u.getLoginName();

        DataUtil.putImpExpAction(u.getId(), "export");
        DataRecord dataRecord = null;
        try {
            dataRecord = linkOptionManager.exportLinkOptionTemplate(linkOptionList);
        } catch (Exception e) {
            logger.error("error", e);
            DataUtil.removeImpExpAction(u.getId());
            PrintWriter out = response.getWriter();
            out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
            out.flush();
            return null;
        }
        DataUtil.removeImpExpAction(u.getId());
        try {
            logger.info("expLinkOptionTemplate");
            fileToExcelManager.save(response, fName, dataRecord);
        } catch (Exception e) {
            logger.error("error", e);
            PrintWriter out = response.getWriter();
            out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
            out.flush();
        }
        return null;
    }

    /**
     * 下载SSOProxy模板
     */
    public ModelAndView downloadSSOProxyTemplate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String path = "";
        String filename = "";

        response.setContentType("application/octet-stream; charset=UTF-8");

        path = AppContext.getSystemProperty("ApplicationRoot") + "/ssoproxy/jsp/";
        filename = URLEncoder.encode("ssoproxy.zip", "UTF-8");

        response.setHeader("Content-disposition", "attachment;filename=\"" + filename + "\"");

        OutputStream out = null;
        InputStream in = null;
        try {
            in = new FileInputStream(new File(path + filename));
            out = response.getOutputStream();

            IOUtils.copy(in, out);
        } catch (Exception e) {
            if ("ClientAbortException".equals(e.getClass().getSimpleName())) {
                logger.debug("用户关闭下载窗口: " + e.getMessage());
            } else {
                logger.error("", e);
            }
        } finally {
            IOUtils.closeQuietly(in);
            IOUtils.closeQuietly(out);
        }
        return null;
    }

    //进入个人关联系统主设置页面
    public ModelAndView userLinkMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelView = new ModelAndView("ctp/portal/link/linkSystemSetting");
        boolean isKnowledge = false;
        String str = request.getParameter("isKnowledge");
        if (str != null) {
            isKnowledge = Boolean.valueOf(str);
        }
        modelView.addObject("isKnowledge", isKnowledge);
        return modelView;
    }

    /**
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView userLinkSetting(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelView = new ModelAndView("ctp/portal/link/linkSystemUser");
        Map<String, Object> param = new HashMap<String, Object>();
        boolean isKnowledge = false;
        long categoryId = 0;
        String str = request.getParameter("isKnowledge");
        if (str != null) {
            isKnowledge = Boolean.valueOf(str);
        }
        if (isKnowledge) {
            param.put("categoryId", Constants.LINK_CATEGORY_KNOWLEDGE_ID);
            categoryId = Constants.LINK_CATEGORY_KNOWLEDGE_ID;
        }
        FlipInfo fi = linkSystemManager.selectLinkSystemByUser(new FlipInfo(), param);
        request.setAttribute("ffmytable", fi);
        modelView.addObject("categoryId", categoryId);
        modelView.addObject("isKnowledge", isKnowledge);
        return modelView;
    }

    /**
     * 关联系统链接
     */
    public ModelAndView linkConnect(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");
        try {
            Long linkSpaceId = Long.valueOf(request.getParameter("linkId"));
            PortalLinkSpace lsp = linkSpaceManager.findLinkSpaceById(linkSpaceId);
            PortalLinkSystem ls = null;
            boolean canAccess = false;
            User user = AppContext.getCurrentUser();
            if (lsp == null) {
                ls = linkSystemManager.selectLinkSystemWithOptions(linkSpaceId);                
                canAccess = linkSystemManager.isUseTheSystem(user.getId(), ls.getId(), ls.getLinkCategoryId());
            } else {
                ls = linkSystemManager.selectLinkSystemWithOptions(lsp.getLinkSystemId());
                canAccess = linkSpaceManager.isUseTheLinkSpace(user.getId(), lsp.getId());
            }
            //如果是通过点击空间导航菜单而来，需进行防护：关联系统已被删除、关联系统不允许作为空间导航配置及用户无权使用关联系统
            if ("spaceMenu".equals(request.getParameter("spaceFlag"))
                    && (ls == null || ls.getAllowedAsSpace() == 0 || !canAccess)) {
                Long accountId = user.getLoginAccount();
                super.printV3XJS(response.getWriter());
                super.rendJavaScript(
                        response,
                        "alert('"
                                + ResourceBundleUtil.getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.system")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason1")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason2")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason3")
                                + "\\n"
                                + ResourceBundleUtil.getString(Constants.LINK_RESOURCE_BASENAME,
                                        "cannot.visit.plscontact") + "');" + "if(window.opener) {"
                                + "    window.opener.getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId
                                + "');" + "    window.close();" + "} else {"
                                + "    getCtpTop().contentFrame.topFrame.realignLinkSpaceMenu('" + accountId + "');"
                                + "}");
                return null;
            }

            if (ls == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                ret.addObject("dataExist", false);
                return ret;
            }

            List<PortalLinkOptionVO> optionVos = getLinkOptionVO(ls, AppContext.currentUserId());
            ret.addObject("optionVos", optionVos);
            ret.addObject("link", ls);
            ret.addObject("linkSpaceOrSectionVO", lsp);
            if(lsp != null){
                ret.addObject("contentForCheck", lsp.getContentForCheck());
            }
            ret.addObject("firstLinked", true);
            ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
            ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
        } catch (Exception e) {
            logger.error(e);
            return null;
        }
        return ret;
    }

    /**
     * 如果是扩展栏目
     */
    public ModelAndView linkConnectForSection(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");

        try {
            Long linkSystemId = Long.valueOf(request.getParameter("linkSystemId"));
            PortalLinkSystem ls = linkSystemManager.selectLinkSystemWithOptions(linkSystemId);
            Long sectionDefinitionId = Long.valueOf(request.getParameter("sectionDefinitionId"));
            User user = AppContext.getCurrentUser();
            PortalLinkSection linkSection = this.linkSectionManager.selectLinkSection(sectionDefinitionId);
            Map<String, String> sectionProps = new HashMap<String, String>();
            sectionProps.put("targetPageUrl", linkSection.getTargetUrl());
            //如果是通过点击空间导航菜单而来，需进行防护：关联系统已被删除、关联系统不允许作为空间导航配置及用户无权使用关联系统
            if ("spaceMenu".equals(request.getParameter("spaceFlag"))
                    && (ls == null || ls.getAllowedAsSpace() == 0 || !linkSystemManager.isUseTheSystem(user.getId(),
                            ls.getId(), ls.getLinkCategoryId()))) {
                Long accountId = user.getLoginAccount();
                super.printV3XJS(response.getWriter());
                super.rendJavaScript(
                        response,
                        "alert('"
                                + ResourceBundleUtil.getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.system")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason1")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason2")
                                + "\\n"
                                + ResourceBundleUtil
                                        .getString(Constants.LINK_RESOURCE_BASENAME, "cannot.visit.reason3")
                                + "\\n"
                                + ResourceBundleUtil.getString(Constants.LINK_RESOURCE_BASENAME,
                                        "cannot.visit.plscontact") + "');" + "if(window.opener) {"
                                + "    window.opener.getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId
                                + "');" + "    window.close();" + "} else {"
                                + "    getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId + "');"
                                + "    getCtpTop().contentFrame.topFrame.backToPersonalSpace();" + "}");
                return null;
            }

            if (ls == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                ret.addObject("dataExist", false);
                return ret;
            }

            List<PortalLinkOptionVO> optionVos = getLinkOptionVO(ls, AppContext.currentUserId());
            ret.addObject("optionVos", optionVos);
            ret.addObject("linkSpaceOrSectionVO", sectionProps);
            ret.addObject("link", ls);
            ret.addObject("contentForCheck", linkSection.getContentForCheck());
            ret.addObject("firstLinked", true);
            ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
            ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
        } catch (Exception e) {
            logger.error(e);
            return null;
        }
        return ret;
    }

    private List<PortalLinkOptionVO> getLinkOptionVO(PortalLinkSystem linkSystem, long userId) throws BusinessException {
        List<PortalLinkOption> options = linkSystem.getLinkOptions();
        List<PortalLinkOptionVO> optionVos = new ArrayList<PortalLinkOptionVO>();
        if (CollectionUtils.isNotEmpty(options)) {
            Map<Long, PortalLinkOption> linkOptionMap = new HashMap<Long, PortalLinkOption>();
            List<Long> optionIds = new ArrayList<Long>();
            for (PortalLinkOption lo : options) {
                optionIds.add(lo.getId());
                linkOptionMap.put(lo.getId(), lo);
            }
            List<PortalLinkOptionValue> plovs = linkOptionManager.selectLinkOptionValues(optionIds, userId);
            for (PortalLinkOptionValue plov : plovs) {
                Long optionId = plov.getLinkOptionId();
                PortalLinkOption plo = linkOptionMap.get(optionId);
                PortalLinkOptionVO vo = new PortalLinkOptionVO(plo, plov);
                optionVos.add(vo);
                optionIds.remove(optionId);
            }
            for(Long optionId : optionIds){
                PortalLinkOption plo = linkOptionMap.get(optionId);
                PortalLinkOptionValue plov = new PortalLinkOptionValue();
                plov.setValue(plo.getParamValue());
                PortalLinkOptionVO vo = new PortalLinkOptionVO(plo, plov);
                optionVos.add(vo);
            }
        }
        return optionVos;
    }

    /**
     * SSO菜单集成链接
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView linkConnectForMenu(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");
        try {
            Long linkSystemId = Long.valueOf(request.getParameter("linkSystemId"));
            PortalLinkSystem linkSystem = linkSystemManager.selectLinkSystemWithOptions(linkSystemId);
            Long menuId = Long.valueOf(request.getParameter("menuId"));
            PortalLinkMenu linkMenu = this.linkMenuManager.selectLinkMenu(menuId);
            Map<String, String> sectionProps = new HashMap<String, String>();
            sectionProps.put("targetPageUrl", linkMenu.getTargetUrl());
            if (linkSystem == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                ret.addObject("dataExist", false);
                return ret;
            }
            if (linkMenu != null && linkMenu.getParentId() == 0) {
                linkSystem.setNeedContentCheck(0);
            }
            List<PortalLinkOptionVO> optionVos = getLinkOptionVO(linkSystem, AppContext.currentUserId());
            ret.addObject("optionVos", optionVos);
            ret.addObject("linkSpaceOrSectionVO", sectionProps);
            ret.addObject("link", linkSystem);
            ret.addObject("contentForCheck", linkMenu.getContentForCheck());
            ret.addObject("target", request.getParameter("target"));
            ret.addObject("firstLinked", true);
            ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
            ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
        } catch (Exception e) {
            logger.error(e);
            return null;
        }
        return ret;
    }

    public ModelAndView linkSystemMore(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkSystemMore");
        int doType = Integer.parseInt(request.getParameter("doType"));
        List<List<PortalLinkSystem>> list = linkSystemManager.findAllLinkSystem(doType);
        List<LinkMoreVO> vos = new ArrayList<LinkMoreVO>();
        for (int i = 0; i < list.size(); i++) {
            List<PortalLinkSystem> li = list.get(i);
            LinkMoreVO vo = new LinkMoreVO(this.getLinkShowVOs(li));
            if (li != null && li.size() > 0) {
                PortalLinkCategory lc = linkCategoryManager.selectCategoryById(li.get(0).getLinkCategoryId());
                String name = "";
                if (lc != null) {
                    name = lc.getCname();
                }
                vo.setCategoryName(name);
            }
            if (i == 0) {
                if (doType == Constants.LIST_MORE_TYPE_KNOWLEDGE) {
                    vo.setCategoryName(ResourceUtil.getString("link.category.sysknowledge"));
                } else {
                    vo.setCategoryName(ResourceUtil.getString("link.category.common"));
                }
            } else if (i == 1) {
                if(doType != Constants.LIST_MORE_TYPE_KNOWLEDGE){
                    vo.setCategoryName(ResourceUtil.getString("link.category.in"));
                }else{
                    vo.setCategoryName(ResourceUtil.getString("link.category.othershare"));
                }
            } else if (i == 2 && doType != Constants.LIST_MORE_TYPE_KNOWLEDGE) {
                vo.setCategoryName(ResourceUtil.getString("link.category.out"));
            }
            vos.add(vo);
        }
        //关联系统类别数
        int vosSize = vos.size();
        ret.addObject("vos", vos);
        //每个关联系统类别中所包含的关联系统数
        List<Integer> sizeList = new ArrayList<Integer>();
        for (LinkMoreVO t : vos) {
            if (t.getLinks() == null)
                sizeList.add(0);
            else
                sizeList.add(t.getLinks().size());
        }
        ret.addObject("sizeList", sizeList);
        ret.addObject("vosSize", vosSize);
        ret.addObject("doType", doType);
        return ret;
    }

    private List<LinkShowVO> getLinkShowVOs(List<PortalLinkSystem> lss) throws Exception {
        List<LinkShowVO> vos = new ArrayList<LinkShowVO>();
        if (lss == null || lss.size() == 0)
            return vos;
        for (PortalLinkSystem ls : lss) {
            LinkShowVO vo = new LinkShowVO(ls);
            String url = "/seeyon/portal/linkSystemController.do?method=linkConnect&linkId=" + ls.getId();
            String icon = ls.getImage();
            if (Strings.isBlank(icon) || (icon.indexOf("defaultLinkSystemImage") != -1)) {
                icon = "/decorations/css/images/portal/defaultLinkSystemImage.png";
            } else {
                icon = icon.replaceFirst("/seeyon", "");
            }
            if (ls.getLinkCategoryId() == Constants.LINK_COMMON)
                url = ls.getUrl();
            vo.setIcon(icon);
            vo.setLink(url);
            if (ls.getCreatorType() == Constants.LINK_CREATOR_TYPE_MEMBER
                    && ls.getCreateUserId() != AppContext.currentUserId()) {
                vo.setShowTile(ls.getLname() + " 分享人:[" + orgManager.getMemberById(ls.getCreateUserId()).getName()
                        + "]");
            }

            vos.add(vo);
        }
        return vos;
    }

    /**
     * 关联系统排序
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    public ModelAndView linkSystemOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("/ctp/portal/link/linkSystemOrder");
        List<PortalLinkSystem> linkSystemList = new ArrayList<PortalLinkSystem>();
        int doType = 0;
        long userId = AppContext.currentUserId();
        String typeStr = request.getParameter("doType");
        if (typeStr != null) {
            doType = Integer.parseInt(typeStr);
        }
        if (doType == Constants.LIST_SYSTEM_SHARE_KNOWLEDGE) {
            linkSystemList = linkSystemManager.findSysKnowledgeSystem(AppContext.currentUserId());
        } else if (doType == Constants.LIST_SELFCRETE_KNOWLEDGE) {
            long linkCategoryId = Long.valueOf((String) request.getParameter("categoryId"));
            if (linkCategoryId == 5) {
                linkSystemList = linkSystemManager.findShareLinkSystem(userId);
            }
            if (linkCategoryId == 6) {
                linkSystemList = linkSystemManager.findKnowledgeSystemByCreator(userId);
            }
        } else {
            linkSystemList = linkSystemManager.findSysLinkSystem(userId);
        }
        if (linkSystemList != null && linkSystemList.size() > 0) {
            List<Long> ids = new ArrayList<Long>(linkSystemList.size());
            for (PortalLinkSystem ls : linkSystemList) {
                ids.add(ls.getId());
            }
            mav.addObject("oldLinks", StringUtils.join(ids, ';'));
        }
        mav.addObject("linkSystemList", linkSystemList);
        return mav;
    }
}