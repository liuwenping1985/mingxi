//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.seeyon.ctp.portal.section;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.SystemEnvironment;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.customize.manager.CustomizeManager;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.CollaborationTemplateManager;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.bo.V3xOrgAccount;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.ChessboardTemplete;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete.OPEN_TYPE;
import com.seeyon.ctp.portal.section.templete.ChessboardTemplete.Item;
import com.seeyon.ctp.portal.section.templete.mobile.MListTemplete;
import com.seeyon.ctp.portal.section.templete.mobile.MListTemplete.Row;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.StringUtil;
import com.seeyon.ctp.util.Strings;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import org.apache.log4j.Logger;

public class MyTempleteSection extends BaseSectionImpl {
    private static final Logger LOG = Logger.getLogger(MyTempleteSection.class);
    private CollaborationTemplateManager collaborationTemplateManager;
    private TemplateManager templateManager;
    private OrgManager orgManager;
    private CustomizeManager customizeManager;
    private Map<Integer, Integer> newLine2Column = new ConcurrentHashMap();

    public MyTempleteSection() {
    }

    public void setNewLine2Column(Map<String, String> newLine2Column) {
        Set<Entry<String, String>> en = newLine2Column.entrySet();
        Iterator var3 = en.iterator();

        while(var3.hasNext()) {
            Entry<String, String> entry = (Entry)var3.next();
            this.newLine2Column.put(Integer.valueOf(Integer.parseInt((String)entry.getKey())), Integer.valueOf(Integer.parseInt((String)entry.getValue())));
        }

    }

    public String getIcon() {
        return "templete";
    }

    public String getId() {
        return "templeteSection";
    }

    public String getBaseName() {
        return ResourceUtil.getString("common.my.template");
    }

    public String getName(Map<String, String> preference) {
        String name = (String)preference.get("columnsName");
        return Strings.isBlank(name)?ResourceUtil.getString("common.my.template"):name;
    }

    public Integer getTotal(Map<String, String> arg0) {
        return null;
    }

    public BaseSectionTemplete projection(Map<String, String> preference) {
        System.out.println("-------------");
        System.out.println(preference);
        /**
         * -------------
         {spaceId=-9065827178818812426, panelId=0, spaceType=personal, x=1, width=4, y=4, entityId=3500884485715543527, isNarrow=false, ownerId=670869647114347, sections=templeteSection, ordinal=0}
         -------------
         */
        System.out.println("-------------");
        String _subject = "";

        try {
            _subject = URLEncoder.encode(this.getName(preference), "UTF-8");
        } catch (UnsupportedEncodingException var28) {
            LOG.error("", var28);
        }

        ChessboardTemplete c = new ChessboardTemplete();
        c.addBottomButton(ResourceUtil.getString("template.templatePub.configurationTemplates"), "/collTemplate/collTemplate.do?method=showTemplateConfig&fragmentId=" + (String)preference.get(PropertyName.entityId.name()) + "&ordinal=" + (String)preference.get(PropertyName.ordinal.name()), (String)null, "sectionSetIco");
        String _configRecent = (String)preference.get("recent");
        String viewType = this.customizeManager.getCustomizeValue(AppContext.currentUserId(), "template_view_type");
        if("1".equals(viewType)) {
            c.addBottomButton("common_more_label", "/collTemplate/collTemplate.do?method=moreTemplate&fragmentId=" + (String)preference.get(PropertyName.entityId.name()) + "&ordinal=" + (String)preference.get(PropertyName.ordinal.name()), (String)null, "sectionMoreIco");
        } else {
            c.addBottomButton("common_more_label", "/template/template.do?method=moreTreeTemplate&fragmentId=" + (String)preference.get(PropertyName.entityId.name()) + "&ordinal=" + (String)preference.get(PropertyName.ordinal.name()) + "&columnsName=" + _subject + "&recent=" + (String)preference.get("recent"), (String)null, "sectionMoreIco");
        }

        String panel = SectionUtils.getPanel("all", preference);
        String category = "-1,1,2,4,19,20,21,32";
        int configRecentCount;
        if(!"all".equals(panel)) {
            String tempStr = (String)preference.get(panel + "_value");
            StringBuffer sb;
            if(Strings.isBlank(tempStr)) {
                sb = new StringBuffer();
                sb.append("-1");
                if(AppContext.hasPlugin("collaboration")) {
                    sb.append(",1,2");
                }

                if(AppContext.hasPlugin("edoc")) {
                    sb.append(",4,19,20,21");
                }

                category = sb.toString();
            } else {
                category = "";
                sb = new StringBuffer();
                String[] temList = tempStr.split(",");
                String[] var11 = temList;
                configRecentCount = temList.length;

                for(int var13 = 0; var13 < configRecentCount; ++var13) {
                    String s = var11[var13];
                    if("catagory_coll".equals(s)) {
                        sb.append("-1");
                    } else if("catagory_collOrFormTemplete".equals(s)) {
                        if(AppContext.hasPlugin("collaboration")) {
                            if(Strings.isNotBlank(sb.toString())) {
                                sb.append(",");
                            }

                            sb.append("1,2");
                        }
                    } else if("catagory_edoc".equals(s) && AppContext.hasPlugin("edoc")) {
                        if(Strings.isNotBlank(sb.toString())) {
                            sb.append(",");
                        }

                        sb.append("4,19,20,21");
                    }
                }

                category = sb.toString();
            }
        }

        int newLine = 2;
        int width = Integer.parseInt((String)preference.get(PropertyName.width.name()));
        Integer newLineStr = (Integer)this.newLine2Column.get(Integer.valueOf(width));
        if(newLineStr != null) {
            newLine = newLineStr.intValue();
        }

        c.setLayout(8, newLine);
        int total = SectionUtils.getSectionCount(16, preference);
        configRecentCount = 10;
        if(!StringUtil.checkNull(_configRecent)) {
            configRecentCount = Integer.parseInt(_configRecent);
            if(configRecentCount > total) {
                configRecentCount = total;
            }
        }

        List<CtpTemplate> templatesRecent = new ArrayList();
        long currentUserId = AppContext.currentUserId();

        try {
            templatesRecent = this.templateManager.findHistoryTemplates(Long.valueOf(currentUserId), category, 30, true);
            List<CtpTemplate> afterFilterRecent = new ArrayList();
            Set<Long> recentTemplateIds = new HashSet();
            if(Strings.isNotEmpty((Collection)templatesRecent)) {
                Iterator var18 = ((List)templatesRecent).iterator();

                while(var18.hasNext()) {
                    CtpTemplate t = (CtpTemplate)var18.next();
                    if(!recentTemplateIds.contains(t.getId())) {
                        afterFilterRecent.add(t);
                        recentTemplateIds.add(t.getId());
                    }
                }

                templatesRecent = afterFilterRecent;
            }
        } catch (BusinessException var29) {
            LOG.error("", var29);
        }

        int configTempsFetchCount = total * 2;
        List<CtpTemplate> configTemplates = this.findConfigTemplates(category, configTempsFetchCount);
        if(configTemplates.size() < total) {
            try {
                this.templateManager.transMergeCtpTemplateConfig(Long.valueOf(currentUserId));
                configTemplates = this.findConfigTemplates(category, configTempsFetchCount);
            } catch (BusinessException var27) {
                LOG.error("", var27);
            }
        }

        Set<Long> configTemplateIds = new HashSet();
        Iterator var39 = configTemplates.iterator();

        while(var39.hasNext()) {
            CtpTemplate t = (CtpTemplate)var39.next();
            configTemplateIds.add(t.getId());
        }

        try {
            this.checkAcl(category, (List)templatesRecent, configTemplates);
        } catch (BusinessException var26) {
            LOG.error("", var26);
        }

        int _sublistRecentInt = ((List)templatesRecent).size() >= configRecentCount?configRecentCount:((List)templatesRecent).size();
        List<CtpTemplate> showRecentTemplates = ((List)templatesRecent).subList(0, _sublistRecentInt);
        Set<Long> showRecentTemplateIds = new HashSet();
        Iterator it = showRecentTemplates.iterator();

        CtpTemplate t;
        while(it.hasNext()) {
            t = (CtpTemplate)it.next();
            showRecentTemplateIds.add(t.getId());
        }

        it = configTemplates.iterator();

        while(it.hasNext()) {
            t = (CtpTemplate)it.next();
            if(showRecentTemplateIds.contains(t.getId())) {
                it.remove();
            }
        }

        int _sublistOtherInt;
        if(total - showRecentTemplates.size() > 0) {
            if(total - showRecentTemplates.size() > configTemplates.size()) {
                _sublistOtherInt = configTemplates.size();
            } else {
                _sublistOtherInt = total - showRecentTemplates.size();
            }
        } else {
            _sublistOtherInt = 0;
        }

        List<CtpTemplate> showOtherTemplates = configTemplates.subList(0, _sublistOtherInt);
        int cou = 16;
        String countStr = (String)preference.get("count");
        if(Strings.isNotBlank(countStr)) {
            cou = Integer.parseInt(countStr);
        }

        c.setDataNum(cou);
        this.addItems(c, showRecentTemplates, "1", preference);
        this.addItems(c, showOtherTemplates, "2", preference);
        return c;
    }

    public BaseSectionTemplete mProjection(Map<String, String> preference) {
        String category = "1,2";
        Integer count = Integer.valueOf(SectionUtils.getSectionCount(3, preference));
        List<CtpTemplate> templatesRecent = new ArrayList();
        long currentUserId = AppContext.currentUserId();

        try {
            templatesRecent = this.templateManager.findHistoryTemplates(Long.valueOf(currentUserId), category, 30, false);
        } catch (BusinessException var22) {
            LOG.error("移动端栏目获取最近使用的模板异常！", var22);
        }

        List<CtpTemplate> afterFilterRecent = new ArrayList();
        Set<Long> recentTemplateIds = new HashSet();
        if(Strings.isNotEmpty((Collection)templatesRecent)) {
            Iterator var9 = ((List)templatesRecent).iterator();

            while(var9.hasNext()) {
                CtpTemplate t = (CtpTemplate)var9.next();
                if("20".equals(t.getBodyType()) && !recentTemplateIds.contains(t.getId())) {
                    afterFilterRecent.add(t);
                    recentTemplateIds.add(t.getId());
                }
            }

            templatesRecent = afterFilterRecent;
        }

        int configTempsFetchCount = count.intValue() * 2;
        List<CtpTemplate> configTemplates = this.findConfigTemplates(category, configTempsFetchCount);
        if(configTemplates.size() < count.intValue()) {
            try {
                this.templateManager.transMergeCtpTemplateConfig(Long.valueOf(currentUserId));
                configTemplates = this.findConfigTemplates(category, configTempsFetchCount);
            } catch (BusinessException var21) {
                LOG.error("", var21);
            }
        }

        Set<Long> configTemplateIds = new HashSet();
        Iterator var12 = configTemplates.iterator();

        while(var12.hasNext()) {
            CtpTemplate t = (CtpTemplate)var12.next();
            configTemplateIds.add(t.getId());
        }

        try {
            this.checkAcl(category, (List)templatesRecent, configTemplates);
        } catch (BusinessException var20) {
            LOG.error("", var20);
        }

        Object showRecentTemplates;
        if(Strings.isNotEmpty((Collection)templatesRecent) && ((List)templatesRecent).size() > count.intValue()) {
            showRecentTemplates = ((List)templatesRecent).subList(0, count.intValue());
        } else {
            showRecentTemplates = templatesRecent;
        }

        Set<Long> showRecentTemplateIds = new HashSet();
        Iterator it = ((List)showRecentTemplates).iterator();

        CtpTemplate t2;
        while(it.hasNext()) {
            t2 = (CtpTemplate)it.next();
            showRecentTemplateIds.add(t2.getId());
        }

        it = configTemplates.iterator();

        while(true) {
            do {
                if(!it.hasNext()) {
                    int _sublistOtherInt;
                    if(count.intValue() - ((List)showRecentTemplates).size() > 0) {
                        if(count.intValue() - ((List)showRecentTemplates).size() > configTemplates.size()) {
                            _sublistOtherInt = configTemplates.size();
                        } else {
                            _sublistOtherInt = count.intValue() - ((List)showRecentTemplates).size();
                        }
                    } else {
                        _sublistOtherInt = 0;
                    }

                    List<CtpTemplate> showOtherTemplates = configTemplates.subList(0, _sublistOtherInt);
                    MListTemplete t = new MListTemplete();
                    Iterator var17 = ((List)showRecentTemplates).iterator();

                    CtpTemplate showOthershowOther;
                    Row row;
                    while(var17.hasNext()) {
                        showOthershowOther = (CtpTemplate)var17.next();
                        row = t.addRow();
                        row.setSubject(showOthershowOther.getSubject());
                        row.setLink("/seeyon/m3/apps/v5/collaboration/html/newCollaboration.html?VJoinOpen=VJoin&templateId=" + showOthershowOther.getId() + "&r=" + System.currentTimeMillis());
                    }

                    var17 = showOtherTemplates.iterator();

                    while(var17.hasNext()) {
                        showOthershowOther = (CtpTemplate)var17.next();
                        row = t.addRow();
                        row.setSubject(showOthershowOther.getSubject());
                        row.setLink("/seeyon/m3/apps/v5/collaboration/html/newCollaboration.html?VJoinOpen=VJoin&templateId=" + showOthershowOther.getId() + "&r=" + System.currentTimeMillis());
                    }

                    t.setMoreLink("/seeyon/m3/apps/v5/collaboration/html/templateIndex.html?VJoinOpen=VJoin&r=" + System.currentTimeMillis());
                    return t;
                }

                t2 = (CtpTemplate)it.next();
            } while("20".equals(t2.getBodyType()) && !showRecentTemplateIds.contains(t2.getId()));

            it.remove();
        }
    }

    private void checkAcl(String category, List<CtpTemplate> templatesRecent, List<CtpTemplate> configTemplates) throws BusinessException {
        List<CtpTemplate> allTemplates = new ArrayList();
        allTemplates.addAll(configTemplates);
        allTemplates.addAll(templatesRecent);
        Map<Long, Boolean> isEnabled = this.templateManager.isTemplateEnabled(allTemplates, Long.valueOf(AppContext.currentUserId()));
        Iterator it;
        CtpTemplate t;
        if(templatesRecent != null) {
            it = templatesRecent.iterator();

            while(it.hasNext()) {
                t = (CtpTemplate)it.next();
                if(!((Boolean)isEnabled.get(t.getId())).booleanValue()) {
                    it.remove();
                }
            }
        }

        if(configTemplates != null) {
            it = configTemplates.iterator();

            while(it.hasNext()) {
                t = (CtpTemplate)it.next();
                if(!((Boolean)isEnabled.get(t.getId())).booleanValue()) {
                    it.remove();
                }
            }
        }

    }

    private void addItems(ChessboardTemplete c, List<CtpTemplate> templates, String icon, Map<String, String> preference) {
        if(Strings.isNotEmpty(templates)) {
            boolean isPluginEdoc = SystemEnvironment.hasPlugin("edoc");
            boolean isEdoc = Functions.isEnableEdoc();
            Iterator var7 = templates.iterator();

            while(true) {
                CtpTemplate ctpTemplate;
                int type;
                do {
                    if(!var7.hasNext()) {
                        return;
                    }

                    ctpTemplate = (CtpTemplate)var7.next();
                    type = ctpTemplate.getModuleType().intValue();
                } while((!isPluginEdoc || !isEdoc) && (type == ModuleType.edocSend.ordinal() || type == ModuleType.edocRec.ordinal() || type == ModuleType.edocSign.ordinal() || type == ModuleType.edoc.ordinal()));

                Item item = c.addItem();
                long templeteId = ctpTemplate.getId().longValue();
                StringBuilder templeteIconMapping = new StringBuilder();
                String iconStyle = "";
                if("2".equals(icon)) {
                    if(type != ModuleType.edocSend.ordinal() && type != ModuleType.edocRec.ordinal() && type != ModuleType.edocSign.ordinal() && type != ModuleType.edoc.ordinal()) {
                        if(type == ModuleType.info.ordinal()) {
                            iconStyle = "<span class=\"ico16 infoTemplate_16\"></span>";
                        } else if("workflow".equals(ctpTemplate.getType())) {
                            iconStyle = "<span class=\"ico16 flow_template_16 margin_r_5\"></span>";
                        } else if("text".equals(ctpTemplate.getType())) {
                            iconStyle = "<span class=\"ico16 format_template_16 margin_r_5\"></span>";
                        } else if("template".equals(ctpTemplate.getType()) && "20".equals(ctpTemplate.getBodyType())) {
                            iconStyle = "<span class=\"ico16 form_temp_16 margin_r_5\"></span>";
                        } else {
                            iconStyle = "<span class=\"ico16 collaboration_16 margin_r_5\"></span>";
                        }
                    } else {
                        iconStyle = "<span class=\"ico16 red_text_template_16 margin_r_5\"></span>";
                    }
                } else if(type != ModuleType.edocSend.ordinal() && type != ModuleType.edocRec.ordinal() && type != ModuleType.edocSign.ordinal() && type != ModuleType.edoc.ordinal()) {
                    if(type == ModuleType.info.ordinal()) {
                        iconStyle = "<span class=\"ico16 infoTemplate_16\"></span>";
                    } else if("workflow".equals(ctpTemplate.getType())) {
                        iconStyle = "<span class=\"ico16 lately_flow_template_16 margin_r_5\"></span>";
                    } else if("text".equals(ctpTemplate.getType())) {
                        iconStyle = "<span class=\"ico16 lately_format_template_16 margin_r_5\"></span>";
                    } else if("template".equals(ctpTemplate.getType()) && "20".equals(ctpTemplate.getBodyType())) {
                        iconStyle = "<span class=\"ico16 lately_text_type_template_16 margin_r_5\"></span>";
                    } else {
                        iconStyle = "<span class=\"ico16 lately_text_type_template_16 margin_r_5\"></span>";
                    }
                } else {
                    iconStyle = "<span class=\"ico16 lately_red_text_template_16 margin_r_5\"></span>";
                }

                templeteIconMapping.append(iconStyle);
                if(type != -1 && type != ModuleType.collaboration.ordinal() && type != ModuleType.form.ordinal()) {
                    if(type == ModuleType.edoc.ordinal()) {
                        item.setLink("/edocController.do?method=entryManager&entry=newEdoc&templeteId=" + templeteId);
                    } else if(type == ModuleType.edocSend.ordinal()) {
                        item.setLink("/edocController.do?method=entryManager&entry=sendManager&edocType=0&toFrom=newEdoc&templeteId=" + templeteId);
                    } else if(type == ModuleType.edocRec.ordinal()) {
                        item.setLink("/edocController.do?method=entryManager&entry=recManager&edocType=1&toFrom=newEdoc&templeteId=" + templeteId + "&listType=newEdoc");
                    } else if(type == ModuleType.edocSign.ordinal()) {
                        item.setLink("/edocController.do?method=entryManager&entry=signReport&edocType=2&toFrom=newEdoc&templeteId=" + templeteId);
                    } else if(type == ModuleType.info.ordinal()) {
                        item.setLink("/info/infomain.do?method=infoReport&listType=listCreateInfo&templateId=" + templeteId);
                    }
                } else {
                    item.setLink("/collaboration/collaboration.do?method=newColl&from=templateNewColl&templateId=" + templeteId);
                    item.setOpenType(OPEN_TYPE.multiWindow);
                }

                String templeteSubject = Strings.toHTML((String)Strings.escapeNULL(ctpTemplate.getSubject(), ""), false);
                if(!ctpTemplate.getOrgAccountId().equals(AppContext.getCurrentUser().getLoginAccount())) {
                    V3xOrgAccount account = null;

                    try {
                        account = this.orgManager.getAccountById(ctpTemplate.getOrgAccountId());
                    } catch (BusinessException var18) {
                        LOG.error("", var18);
                    }

                    StringBuffer sb = new StringBuffer(templeteSubject);
                    sb.append("(");
                    sb.append(account != null?account.getShortName():"");
                    sb.append(")");
                    templeteSubject = sb.toString();
                }

                item.setName(templeteIconMapping.append(templeteSubject).toString());
                item.setTitle((String)Strings.escapeNULL(ctpTemplate.getSubject(), ""));
            }
        }
    }

    private List<CtpTemplate> queryMyRencentCollTemplate(String category, int count) {
        try {
            return this.collaborationTemplateManager.getPersonalRencentTemplete(category, count);
        } catch (BusinessException var4) {
            LOG.error("", var4);
            return new ArrayList();
        }
    }

    private List<CtpTemplate> findConfigTemplates(String category, int count) {
        List<CtpTemplate> templateList = new ArrayList();
        User user = AppContext.getCurrentUser();
        if(count <= 0) {
            return (List)templateList;
        } else {
            FlipInfo flipInfo = new FlipInfo();
            flipInfo.setPage(1);
            flipInfo.setSize(count);
            flipInfo.setNeedTotal(false);
            Map<String, Object> params = new HashMap();
            params.put("userId", user.getId());
            params.put("accountId", user.getLoginAccount());
            params.put("category", category);

            try {
                templateList = this.collaborationTemplateManager.getMyConfigCollTemplate(flipInfo, params);
            } catch (BusinessException var8) {
                LOG.error("", var8);
            }

            return (List)templateList;
        }
    }

    public void setCollaborationTemplateManager(CollaborationTemplateManager collaborationTemplateManager) {
        this.collaborationTemplateManager = collaborationTemplateManager;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setTemplateManager(TemplateManager templateManager) {
        this.templateManager = templateManager;
    }

    public void setCustomizeManager(CustomizeManager customizeManager) {
        this.customizeManager = customizeManager;
    }
}
