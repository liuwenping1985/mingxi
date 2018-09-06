//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.portal.link.controller;

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
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
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

public class LinkSystemController extends BaseController {
    private LinkSystemManager linkSystemManager;
    private FileManager fileManager;
    private FileToExcelManager fileToExcelManager;
    private LinkSectionManager linkSectionManager;
    private LinkOptionManager linkOptionManager;
    private LinkSpaceManager linkSpaceManager;
    private LinkCategoryManager linkCategoryManager;
    private OrgManager orgManager;
    private LinkMenuManager linkMenuManager;

    public LinkSystemController() {
    }

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

    public ModelAndView linkSystemMain(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/portal/link/linkSystemMain");
        Integer productId = SystemProperties.getInstance().getIntegerProperty("system.ProductId");
        boolean isSystemAdmin = AppContext.isSystemAdmin();
        if(ProductEditionEnum.a6p.ordinal() == productId.intValue() || ProductEditionEnum.a6.ordinal() == productId.intValue()) {
            isSystemAdmin = AppContext.isAdministrator();
        }

        List<PortalLinkCategory> linkCategories = new ArrayList();
        if(isSystemAdmin) {
            linkCategories.add(new PortalLinkCategory(0L, ResourceUtil.getString("link.category.manage"), -1L));
            List<PortalLinkCategory> list = this.linkCategoryManager.getCategoriesByAdmin();
            Iterator itr = list.iterator();

            label35:
            while(true) {
                PortalLinkCategory category;
                do {
                    do {
                        if(!itr.hasNext()) {
                            linkCategories.addAll(list);
                            break label35;
                        }

                        category = (PortalLinkCategory)itr.next();
                        category.setCname(ResourceUtil.getString(category.getCname()));
                    } while(4L != category.getId().longValue());
                } while(ProductEditionEnum.a6p.ordinal() != productId.intValue() && ProductEditionEnum.a6.ordinal() != productId.intValue());

                itr.remove();
            }
        } else {
            linkCategories.add(new PortalLinkCategory(0L, ResourceUtil.getString("link.category.knowledge"), -1L));
            linkCategories.add(new PortalLinkCategory(5L, ResourceUtil.getString("link.category.othershare"), 0L));
            linkCategories.add(new PortalLinkCategory(6L, ResourceUtil.getString("link.category.myknowledge"), 0L));
            linkCategories.addAll(this.linkCategoryManager.getCategoriesByUser());
        }

        request.setAttribute("fftree", linkCategories);
        Map params = new HashMap();
        if(!CollectionUtils.isEmpty(linkCategories)) {
            params.put("categoryId", ((PortalLinkCategory)linkCategories.get(1)).getId());
            FlipInfo fi = this.linkSystemManager.selectLinkSystem(new FlipInfo(), params);
            fi.setParams(params);
            request.setAttribute("ffmytable", fi);
        }

        mav.addObject("isSystemAdmin", Boolean.valueOf(isSystemAdmin));
        request.setAttribute("currentUserId", Long.valueOf(AppContext.currentUserId()));
        return mav;
    }

    public ModelAndView linkOptionValueMain(HttpServletRequest request, HttpServletResponse response) throws BusinessException {
        ModelAndView mav = new ModelAndView("ctp/portal/link/linkOptionValueMain");
        String linkSystemId = request.getParameter("linkSystemId");
        if(linkSystemId != null && !"null".equals(linkSystemId)) {
            Map params = new HashMap();
            params.put("linkSystemId", linkSystemId);
            FlipInfo fi = this.linkOptionManager.selectLinkOptionValues(new FlipInfo(), params);
            List<PortalLinkOption> linkOptionList = this.linkOptionManager.selectLinkOptions(Long.valueOf(linkSystemId));
            request.setAttribute("ffoptionValueTable", fi);
            request.setAttribute("linkOptionList", linkOptionList);
            request.setAttribute("linkSystemId", linkSystemId);
            mav.addObject("linkSystemId", linkSystemId);
            int linkOptionListNum = linkOptionList.size();
            int tableHeadExistNum = 2;
            int columnWidthPecent = 100 / (linkOptionListNum + tableHeadExistNum);
            mav.addObject("columnWidthPecent", Integer.valueOf(columnWidthPecent));
            return mav;
        } else {
            return mav;
        }
    }

    public ModelAndView importOptionValue(HttpServletRequest request, HttpServletResponse response) throws BusinessException, IOException {
        response.setCharacterEncoding("utf-8");
        PrintWriter out = response.getWriter();
        User u = AppContext.getCurrentUser();
        if(u == null) {
            return null;
        } else if(DataUtil.doingImpExp(u.getId())) {
            DataUtil.removeImpExpAction(u.getId());
            return null;
        } else {
            DataUtil.putImpExpAction(u.getId(), "import");
            String linkSystemId = request.getParameter("linkSystemId");
            String repeat = request.getParameter("repeat");
            Long linkSystemIdLong = Long.valueOf(0L);

            try {
                linkSystemIdLong = Long.valueOf(Long.parseLong(linkSystemId));
            } catch (NumberFormatException var15) {
                this.logger.error("error when parse linkSystemId to long, linkSystemId" + linkSystemId, var15);
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.fail.prompt"));
                out.flush();
                return null;
            }

            String results = "";

            try {
                List<PortalLinkOption> linkOptionList = this.linkOptionManager.selectLinkOptions(linkSystemIdLong);
                if(linkOptionList == null || linkOptionList.size() == 0) {
                    DataUtil.removeImpExpAction(u.getId());
                    out.println(ResourceUtil.getString("link.jsp.import.nooption.prompt"));
                    out.flush();
                    return null;
                }

                File xlsFile = this.fileManager.getFile(Long.valueOf(Long.parseLong(request.getParameter("fileid"))), new Date());
                List<List<String>> linkOptionValueList = this.fileToExcelManager.readExcel(xlsFile);
                new ArrayList();
                if(linkOptionValueList == null || linkOptionValueList.size() <= 2) {
                    DataUtil.removeImpExpAction(u.getId());
                    out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                    out.flush();
                    return null;
                }

                if(linkOptionList.size() != ((List)linkOptionValueList.get(1)).size() - 2) {
                    DataUtil.removeImpExpAction(u.getId());
                    out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                    out.flush();
                    return null;
                }

                int i = 0;

                while(true) {
                    if(i >= linkOptionList.size()) {
                        List<List<String>> realLinkOptionValueList = linkOptionValueList.subList(1, linkOptionValueList.size());
                        results = this.linkOptionManager.importLinkOptinValue(linkSystemIdLong, realLinkOptionValueList, repeat);
                        break;
                    }

                    PortalLinkOption loTmp = (PortalLinkOption)linkOptionList.get(i);
                    if(!loTmp.getParamName().equals(((String)((List)linkOptionValueList.get(1)).get(i + 1)).trim())) {
                        DataUtil.removeImpExpAction(u.getId());
                        out.println(ResourceUtil.getString("link.jsp.import.wrongtmp.prompt"));
                        out.flush();
                        return null;
                    }

                    ++i;
                }
            } catch (BusinessException var16) {
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.fail.prompt") + "<br/>" + var16.getMessage());
                out.flush();
                return null;
            } catch (Exception var17) {
                DataUtil.removeImpExpAction(u.getId());
                out.println(ResourceUtil.getString("link.jsp.import.fail.prompt") + "<br/>" + var17.getMessage());
                out.flush();
                return null;
            }

            DataUtil.removeImpExpAction(u.getId());
            out.println(ResourceUtil.getString("link.jsp.import.success.prompt") + "<br/>" + results);
            out.flush();
            return null;
        }
    }

    public ModelAndView downloadTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setCharacterEncoding("utf-8");
        User u = AppContext.getCurrentUser();
        if(u == null) {
            return null;
        } else if(DataUtil.doingImpExp(u.getId())) {
            return null;
        } else {
            String linkSystemId = request.getParameter("linkSystemId");
            if(linkSystemId != null && linkSystemId.trim().length() != 0) {
                Long linkSystemId_long = Long.valueOf(0L);

                PrintWriter out;
                try {
                    linkSystemId_long = Long.valueOf(Long.parseLong(linkSystemId));
                } catch (NumberFormatException var13) {
                    this.logger.error("error when parse linkSystemId to long", var13);
                    DataUtil.removeImpExpAction(u.getId());
                    out = response.getWriter();
                    out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
                    out.flush();
                    return null;
                }

                List<PortalLinkOption> linkOptionList = this.linkOptionManager.selectLinkOptions(linkSystemId_long);
                if(linkOptionList != null && linkOptionList.size() != 0) {
                    String fName = "LinkOptionValue_" + u.getLoginName();
                    DataUtil.putImpExpAction(u.getId(), "export");
                    DataRecord dataRecord = null;


                    try {
                        dataRecord = this.linkOptionManager.exportLinkOptionTemplate(linkOptionList);
                    } catch (Exception var12) {
                        this.logger.error("error", var12);
                        DataUtil.removeImpExpAction(u.getId());
                        out = response.getWriter();
                        out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
                        out.flush();
                        return null;
                    }

                    DataUtil.removeImpExpAction(u.getId());

                    try {
                        this.logger.info("expLinkOptionTemplate");
                        this.fileToExcelManager.save(response, fName, new DataRecord[]{dataRecord});
                    } catch (Exception var11) {
                        this.logger.error("error", var11);
                        out = response.getWriter();
                        out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.fail.prompt") + "\")</script>");
                        out.flush();
                    }

                    return null;
                } else {
                    DataUtil.removeImpExpAction(u.getId());
                    out = response.getWriter();
                    out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.nooption.prompt") + "\")</script>");
                    out.flush();
                    return null;
                }
            } else {
                PrintWriter out = response.getWriter();
                out.println("<script>parent.$.alert(\"" + ResourceUtil.getString("link.jsp.import.nooption.prompt") + "\")</script>");
                out.flush();
                return null;
            }
        }
    }

    public ModelAndView downloadSSOProxyTemplate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String path = "";
        String filename = "";
        response.setContentType("application/octet-stream; charset=UTF-8");
        path = AppContext.getSystemProperty("ApplicationRoot") + "/ssoproxy/jsp/";
        filename = URLEncoder.encode("ssoproxy.zip", "UTF-8");
        response.setHeader("Content-disposition", "attachment;filename=\"" + filename + "\"");
        OutputStream out = null;
        FileInputStream in = null;

        try {
            in = new FileInputStream(new File(path + filename));
            out = response.getOutputStream();
            IOUtils.copy(in, out);
        } catch (Exception var11) {
            if("ClientAbortException".equals(var11.getClass().getSimpleName())) {
                this.logger.debug("用户关闭下载窗口: " + var11.getMessage());
            } else {
                this.logger.error("", var11);
            }
        } finally {
            IOUtils.closeQuietly(in);
            IOUtils.closeQuietly(out);
        }

        return null;
    }

    public ModelAndView userLinkMain(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelView = new ModelAndView("ctp/portal/link/linkSystemSetting");
        boolean isKnowledge = false;
        String str = request.getParameter("isKnowledge");
        if(str != null) {
            isKnowledge = Boolean.valueOf(str).booleanValue();
        }

        modelView.addObject("isKnowledge", Boolean.valueOf(isKnowledge));
        return modelView;
    }

    public ModelAndView userLinkSetting(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView modelView = new ModelAndView("ctp/portal/link/linkSystemUser");
        Map<String, Object> param = new HashMap();
        boolean isKnowledge = false;
        long categoryId = 0L;
        String str = request.getParameter("isKnowledge");
        if(str != null) {
            isKnowledge = Boolean.valueOf(str).booleanValue();
        }

        if(isKnowledge) {
            param.put("categoryId", Long.valueOf(4L));
            categoryId = 4L;
        }

        FlipInfo fi = this.linkSystemManager.selectLinkSystemByUser(new FlipInfo(), param);
        request.setAttribute("ffmytable", fi);
        modelView.addObject("categoryId", Long.valueOf(categoryId));
        modelView.addObject("isKnowledge", Boolean.valueOf(isKnowledge));
        return modelView;
    }

    public ModelAndView linkConnect(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");

        try {
            Long linkSpaceId = Long.valueOf(request.getParameter("linkId"));
            PortalLinkSpace lsp = this.linkSpaceManager.findLinkSpaceById(linkSpaceId);
            PortalLinkSystem ls = null;
            boolean canAccess = false;
            User user = AppContext.getCurrentUser();
            if(lsp == null) {
                ls = this.linkSystemManager.selectLinkSystemWithOptions(linkSpaceId);
                canAccess = this.linkSystemManager.isUseTheSystem(user.getId(), ls.getId(), ls.getLinkCategoryId());
            } else {
                ls = this.linkSystemManager.selectLinkSystemWithOptions(lsp.getLinkSystemId());
                canAccess = this.linkSpaceManager.isUseTheLinkSpace(user.getId(), lsp.getId());
            }

            if("spaceMenu".equals(request.getParameter("spaceFlag")) && (ls == null || ls.getAllowedAsSpace().intValue() == 0 || !canAccess)) {
                Long accountId = user.getLoginAccount();
                super.printV3XJS(response.getWriter());
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.system", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason1", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason2", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason3", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.plscontact", new Object[0]) + "');" + "if(window.opener) {" + "    window.opener.getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId + "');" + "    window.close();" + "} else {" + "    getCtpTop().contentFrame.topFrame.realignLinkSpaceMenu('" + accountId + "');" + "}");
                return null;
            } else if(ls == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                ret.addObject("dataExist", Boolean.valueOf(false));
                return ret;
            } else {
                List<PortalLinkOptionVO> optionVos = this.getLinkOptionVO(ls, AppContext.currentUserId());
                ret.addObject("optionVos", optionVos);
                ret.addObject("link", ls);


                ret.addObject("linkSpaceOrSectionVO", lsp);
                if(lsp != null) {
                    ret.addObject("contentForCheck", lsp.getContentForCheck());
                }

                ret.addObject("firstLinked", Boolean.valueOf(true));
                ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
                ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
                return ret;
            }
        } catch (Exception var10) {
            this.logger.error(var10);
            return null;
        }
    }

    public ModelAndView linkConnectForSection(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");

        try {
            Long linkSystemId = Long.valueOf(request.getParameter("linkSystemId"));
            PortalLinkSystem ls = this.linkSystemManager.selectLinkSystemWithOptions(linkSystemId);
            Long sectionDefinitionId = Long.valueOf(request.getParameter("sectionDefinitionId"));
            User user = AppContext.getCurrentUser();
            PortalLinkSection linkSection = this.linkSectionManager.selectLinkSection(sectionDefinitionId.longValue());
            Map<String, String> sectionProps = new HashMap();
            sectionProps.put("targetPageUrl", linkSection.getTargetUrl());
            if(!"spaceMenu".equals(request.getParameter("spaceFlag")) || ls != null && ls.getAllowedAsSpace().intValue() != 0 && this.linkSystemManager.isUseTheSystem(user.getId(), ls.getId(), ls.getLinkCategoryId())) {
                if(ls == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                    ret.addObject("dataExist", Boolean.valueOf(false));
                    return ret;
                } else {
                    List<PortalLinkOptionVO> optionVos = this.getLinkOptionVO(ls, AppContext.currentUserId());
                    ret.addObject("optionVos", optionVos);
                    ret.addObject("linkSpaceOrSectionVO", sectionProps);
                    ret.addObject("link", ls);
                    ret.addObject("contentForCheck", linkSection.getContentForCheck());
                    ret.addObject("firstLinked", Boolean.valueOf(true));
                    ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
                    ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
                    return ret;
                }
            } else {
                Long accountId = user.getLoginAccount();
                super.printV3XJS(response.getWriter());
                super.rendJavaScript(response, "alert('" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.system", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason1", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason2", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.reason3", new Object[0]) + "\\n" + ResourceBundleUtil.getString("com.seeyon.v3x.link.i18n.LinkResource", "cannot.visit.plscontact", new Object[0]) + "');" + "if(window.opener) {" + "    window.opener.getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId + "');" + "    window.close();" + "} else {" + "    getCtpTop().contentFrame.topFrame.realignSpaceMenu('" + accountId + "');" + "    getCtpTop().contentFrame.topFrame.backToPersonalSpace();" + "}");
                return null;
            }
        } catch (Exception var11) {
            this.logger.error(var11);
            return null;
        }
    }

    private List<PortalLinkOptionVO> getLinkOptionVO(PortalLinkSystem linkSystem, long userId) throws BusinessException {
        List<PortalLinkOption> options = linkSystem.getLinkOptions();
        List<PortalLinkOptionVO> optionVos = new ArrayList();
        if(CollectionUtils.isNotEmpty(options)) {
            Map<Long, PortalLinkOption> linkOptionMap = new HashMap();
            List<Long> optionIds = new ArrayList();
            Iterator var8 = options.iterator();

            while(var8.hasNext()) {
                PortalLinkOption lo = (PortalLinkOption)var8.next();
                optionIds.add(lo.getId());
                linkOptionMap.put(lo.getId(), lo);
            }

            List<PortalLinkOptionValue> plovs = this.linkOptionManager.selectLinkOptionValues(optionIds, userId);
            Iterator var18 = plovs.iterator();

            PortalLinkOptionVO vo;
            while(var18.hasNext()) {
                PortalLinkOptionValue plov = (PortalLinkOptionValue)var18.next();
                Long optionId = plov.getLinkOptionId();
                PortalLinkOption plo = (PortalLinkOption)linkOptionMap.get(optionId);
                vo = new PortalLinkOptionVO(plo, plov);
                optionVos.add(vo);
                optionIds.remove(optionId);
            }

            var18 = optionIds.iterator();

            while(var18.hasNext()) {
                Long optionId = (Long)var18.next();
                PortalLinkOption plo = (PortalLinkOption)linkOptionMap.get(optionId);
                PortalLinkOptionValue plov = new PortalLinkOptionValue();
                plov.setValue(plo.getParamValue());
                vo = new PortalLinkOptionVO(plo, plov);
                optionVos.add(vo);
            }
        }

        return optionVos;
    }

    public ModelAndView linkConnectForMenu(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkConnecting");

        try {
            Long linkSystemId = Long.valueOf(request.getParameter("linkSystemId"));
            PortalLinkSystem linkSystem = this.linkSystemManager.selectLinkSystemWithOptions(linkSystemId);
            Long menuId = Long.valueOf(request.getParameter("menuId"));
            PortalLinkMenu linkMenu = this.linkMenuManager.selectLinkMenu(menuId.longValue());
            Map<String, String> sectionProps = new HashMap();
            sectionProps.put("targetPageUrl", linkMenu.getTargetUrl());
            if(linkSystem == null && Strings.isBlank(request.getParameter("spaceFlag"))) {
                ret.addObject("dataExist", Boolean.valueOf(false));
                return ret;
            } else {
                if(linkMenu != null && linkMenu.getParentId().longValue() == 0L) {
                    linkSystem.setNeedContentCheck(Integer.valueOf(0));
                }

                List<PortalLinkOptionVO> optionVos = this.getLinkOptionVO(linkSystem, AppContext.currentUserId());
                ret.addObject("optionVos", optionVos);
                ret.addObject("linkSpaceOrSectionVO", sectionProps);
                ret.addObject("link", linkSystem);
                ret.addObject("contentForCheck", linkMenu.getContentForCheck());
                ret.addObject("target", request.getParameter("target"));
                ret.addObject("firstLinked", Boolean.valueOf(true));
                ret.addObject("wrongConfigPrompt", "关联系统配置错误，请联系管理员！");
                ret.addObject("longPrompt", "关联系统当前不可用或者关联系统配置错误，请联系管理员！");
                return ret;
            }
        } catch (Exception var10) {
            this.logger.error(var10);
            return null;
        }
    }

    public ModelAndView linkSystemMore(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView ret = new ModelAndView("/ctp/portal/link/linkSystemMore");
        int doType = Integer.parseInt(request.getParameter("doType"));
        List<List<PortalLinkSystem>> list = this.linkSystemManager.findAllLinkSystem(doType);
        List<LinkMoreVO> vos = new ArrayList();

        int i;
        for(i = 0; i < list.size(); ++i) {
            List<PortalLinkSystem> li = (List)list.get(i);
            LinkMoreVO vo = new LinkMoreVO(this.getLinkShowVOs(li));
            if(li != null && li.size() > 0) {
                PortalLinkCategory lc = this.linkCategoryManager.selectCategoryById(((PortalLinkSystem)li.get(0)).getLinkCategoryId().longValue());
                String name = "";
                if(lc != null) {
                    name = lc.getCname();
                }

                vo.setCategoryName(name);
            }

            if(i == 0) {
                if(doType == 2) {
                    vo.setCategoryName(ResourceUtil.getString("link.category.sysknowledge"));
                } else {
                    vo.setCategoryName(ResourceUtil.getString("link.category.common"));
                }
            } else if(i == 1) {
                if(doType != 2) {
                    vo.setCategoryName(ResourceUtil.getString("link.category.in"));
                } else {
                    vo.setCategoryName(ResourceUtil.getString("link.category.othershare"));
                }
            } else if(i == 2 && doType != 2) {
                vo.setCategoryName(ResourceUtil.getString("link.category.out"));
            }

            vos.add(vo);
        }

        i = vos.size();
        ret.addObject("vos", vos);
        List<Integer> sizeList = new ArrayList();
        Iterator var13 = vos.iterator();

        while(var13.hasNext()) {
            LinkMoreVO t = (LinkMoreVO)var13.next();
            if(t.getLinks() == null) {
                sizeList.add(Integer.valueOf(0));
            } else {
                sizeList.add(Integer.valueOf(t.getLinks().size()));
            }
        }

        ret.addObject("sizeList", sizeList);
        ret.addObject("vosSize", Integer.valueOf(i));
        ret.addObject("doType", Integer.valueOf(doType));
        return ret;
    }

    private List<LinkShowVO> getLinkShowVOs(List<PortalLinkSystem> lss) throws Exception {
        List<LinkShowVO> vos = new ArrayList();
        if(lss != null && lss.size() != 0) {
            LinkShowVO vo;
            for(Iterator var3 = lss.iterator(); var3.hasNext(); vos.add(vo)) {
                PortalLinkSystem ls = (PortalLinkSystem)var3.next();
                vo = new LinkShowVO(ls);
                String url = "/seeyon/portal/linkSystemController.do?method=linkConnect&linkId=" + ls.getId();
                String icon = ls.getImage();
                if(!Strings.isBlank(icon) && icon.indexOf("defaultLinkSystemImage") == -1) {
                    icon = icon.replaceFirst("/seeyon", "");
                } else {
                    icon = "/decorations/css/images/portal/defaultLinkSystemImage.png";
                }

                if(ls.getLinkCategoryId().longValue() == 1L) {
                    url = ls.getUrl();
                }

                vo.setIcon(icon);
                vo.setLink(url);
                if(ls.getCreatorType().intValue() == 1 && ls.getCreateUserId().longValue() != AppContext.currentUserId()) {
                    vo.setShowTile(ls.getLname() + " 分享人:[" + this.orgManager.getMemberById(ls.getCreateUserId()).getName() + "]");
                }
            }

            return vos;
        } else {
            return vos;
        }
    }

    public ModelAndView linkSystemOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
        ModelAndView mav = new ModelAndView("/ctp/portal/link/linkSystemOrder");
        List<PortalLinkSystem> linkSystemList = new ArrayList();
        int doType = 0;
        long userId = AppContext.currentUserId();
        String typeStr = request.getParameter("doType");
        if(typeStr != null) {
            doType = Integer.parseInt(typeStr);
        }

        if(doType == 3) {
            linkSystemList = this.linkSystemManager.findSysKnowledgeSystem(AppContext.currentUserId());
        } else if(doType == 5) {
            long linkCategoryId = Long.valueOf(request.getParameter("categoryId")).longValue();
            if(linkCategoryId == 5L) {
                linkSystemList = this.linkSystemManager.findShareLinkSystem(userId);
            }

            if(linkCategoryId == 6L) {
                linkSystemList = this.linkSystemManager.findKnowledgeSystemByCreator(userId);
            }
        } else {
            linkSystemList = this.linkSystemManager.findSysLinkSystem(userId);
        }

        if(linkSystemList != null && ((List)linkSystemList).size() > 0) {
            List<Long> ids = new ArrayList(((List)linkSystemList).size());
            Iterator var10 = ((List)linkSystemList).iterator();

            while(var10.hasNext()) {
                PortalLinkSystem ls = (PortalLinkSystem)var10.next();
                ids.add(ls.getId());
            }

            mav.addObject("oldLinks", StringUtils.join(ids, ';'));
        }

        mav.addObject("linkSystemList", linkSystemList);
        return mav;
    }
}
