/**
 * $Author翟锋$
 * $Rev$
 * $Date::2012-11-13$:
 *
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 *
 * This software is the proprietary information of Seeyon, Inc.
 * Use is subject to license terms.
 */
package com.seeyon.ctp.portal.section;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.collaboration.enums.CollaborationEnum;
import com.seeyon.apps.collaboration.util.ColUtil;
import com.seeyon.apps.edoc.api.EdocApi;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.affair.AffairCondition;
import com.seeyon.ctp.common.content.affair.AffairCondition.SearchCondition;
import com.seeyon.ctp.common.content.affair.AffairExtPropEnums;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.AffairUtil;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.mainbody.MainbodyType;
import com.seeyon.ctp.common.flag.SysFlag;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.template.CtpTemplate;
import com.seeyon.ctp.common.po.template.CtpTemplateCategory;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.template.manager.TemplateManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.section.templete.BaseSectionTemplete;
import com.seeyon.ctp.portal.section.templete.MultiRowVariableColumnTemplete;
import com.seeyon.ctp.portal.section.templete.mobile.MListTemplete;
import com.seeyon.ctp.portal.section.util.SectionUtils;
import com.seeyon.ctp.portal.util.PortletPropertyContants.PropertyName;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.common.manager.ConfigGrantManager;

/**
 * 已发事项栏目
 * @author zhaifeng
 *
 */
public class SentSection extends BaseSectionImpl {
    private static final Log         log = LogFactory.getLog(SentSection.class);
    private AffairManager            affairManager;
    private EdocApi                  edocApi;
    private ConfigGrantManager       configGrantManager;

    private CommonAffairSectionUtils commonAffairSectionUtils;
    
    private TemplateManager templateManager;

   	public void setTemplateManager(TemplateManager templateManager) {
   		this.templateManager = templateManager;
   	}

    public CommonAffairSectionUtils getCommonAffairSectionUtils() {
        return commonAffairSectionUtils;
    }

    public void setCommonAffairSectionUtils(CommonAffairSectionUtils commonAffairSectionUtils) {
        this.commonAffairSectionUtils = commonAffairSectionUtils;
    }

    public ConfigGrantManager getConfigGrantManager() {
        return configGrantManager;
    }

    public void setConfigGrantManager(ConfigGrantManager configGrantManager) {
        this.configGrantManager = configGrantManager;
    }

    public EdocApi getEdocApi() {
        return edocApi;
    }

    public void setEdocApi(EdocApi edocApi) {
        this.edocApi = edocApi;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    @Override
    public String getId() {
        return "sentSection";
    }

    @Override
    public boolean isAllowUsed() {
        User user = AppContext.getCurrentUser();
        if (user.isV5Member()) {
            return true;
        } else {
            return AppContext.isAdmin() || AppContext.hasResourceCode("F01_listSent");
        }
    }

    @Override
    public void init() {
        super.init();
        if (AppContext.hasPlugin("edoc")) {
            return;
        }

        //不展示公文相关配置信息
        List<SectionProperty> properties = this.getProperties();
        for (SectionProperty sp : properties) {
            SectionReference[] references = sp.getReference();
            for (SectionReference ref : references) {
                if ("rowList".equals(ref.getName())) {
                    SectionReferenceValueRange[] valueRanges = ref.getValueRanges();
                    List<SectionReferenceValueRange> result = new ArrayList<SectionReferenceValueRange>();
                    for (SectionReferenceValueRange val : valueRanges) {
                        if (!"edocMark".equals(val.getValue())) {
                            result.add(val);
                        }
                    }
                    ref.setValueRanges(result.toArray(new SectionReferenceValueRange[0]));
                }
            }
        }
    }

    @Override
    public String getBaseName() {
        return ResourceUtil.getString("common.my.sent.title");
    }

    @Override
    public String getName(Map<String, String> preference) {
        //栏目显示的名字，必须实现国际化，在栏目属性的“columnsName”中存储
        String name = preference.get("columnsName");
        if (Strings.isBlank(name)) {
            return ResourceUtil.getString("common.my.sent.title");//已发事项
        } else {
            return name;
        }
    }

    @Override
    public Integer getTotal(Map<String, String> preference) {
        return null;
    }

    @Override
    public String getIcon() {
        return "sent";
    }

    @Override
    public BaseSectionTemplete projection(Map<String, String> preference) {
        String rowStr = preference.get("rowList");
        //发起时间、处理期限是必须显示的，而不是通过配置的，同时为了保证顺序问题，因此要如此处理(将deadline放到category前面)
        if (Strings.isBlank(rowStr)) {
            rowStr = "subject,publishDate,category";
        }

        AffairCondition condition = new AffairCondition();
        FlipInfo fi = new FlipInfo();
        fi.setNeedTotal(false);
        //显示行数
        String count = preference.get("count");
        //默认为8条记录
        int coun = 8;
        if (Strings.isNotBlank(count)) {
            coun = Integer.parseInt(count);
        }
        //单列表
        fi.setSize(coun);
        //OA-27551首页事项中去除已发已办栏目名称后面的数字显示
        fi.setNeedTotal(false);
        List<CtpAffair> affairs = this.querySectionAffair(condition, fi, preference);

        //String s =   Functions.escapeJavascript(Functions.toHTML(Functions.toHTML(this.getName(preference) .replaceAll("#", "%25").replaceAll("&", "%23").replaceAll("=", "%3D"))));
        String s = "";
        try {
            s = URLEncoder.encode(this.getName(preference), "UTF-8");
        } catch (UnsupportedEncodingException e) {
            log.error("", e);
        }
        //单列表
        MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();
        c = this.getTemplete(affairs, preference);
        // 【更多】

        c.addBottomButton(BaseSectionTemplete.BOTTOM_BUTTON_LABEL_MORE,
                "/portalAffair/portalAffairController.do?method=moreSent" + "&fragmentId="
                        + preference.get(PropertyName.entityId.name()) + "&ordinal="
                        + preference.get(PropertyName.ordinal.name()) + "&rowStr=" + rowStr + "&columnsName=" + s);
        c.setDataNum(coun);
        return c;
    }

    @Override
    public BaseSectionTemplete mProjection(Map<String, String> preference) {
        FlipInfo fi = new FlipInfo();
        AffairCondition condition = new AffairCondition();
        Integer count = SectionUtils.getSectionCount(3, preference);
        fi.setSize(count);
        fi.setNeedTotal(false);
        List<CtpAffair> affairs = this.querySectionAffair(condition, fi, preference);
        MListTemplete c = new MListTemplete();
        if (Strings.isNotEmpty(affairs)) {
            for (CtpAffair affair : affairs) {
                MListTemplete.Row row = c.addRow();
                row.setSubject(affair.getSubject());
                row.setLink("/seeyon/m3/apps/v5/collaboration/html/details/summary.html?affairId=" + affair.getId()
                        + "&openFrom=listSent&VJoinOpen=VJoin&summaryId=" + affair.getObjectId() + "&r="
                        + System.currentTimeMillis());
                row.setCreateDate(MListTemplete.showDate(affair.getCreateDate()));
                String memberName = Functions.showMemberName(affair.getSenderId());
                if (memberName == null && (affair.getSenderId() == null || affair.getSenderId() == -1)) {
                    memberName = Strings.escapeNULL(affair.getExtProps(), "");
                }
                row.setCreateMember(memberName);
                row.setReadFlag("true");
                row.setState(affair.getSummaryState() == null ? "0" : affair.getSummaryState().toString());
            }
        }
        String moreLink = "/seeyon/m3/apps/v5/collaboration/html/colAffairs.html?openFrom=listSent&VJoinOpen=VJoin&r="
                + System.currentTimeMillis();
        c.setMoreLink(moreLink);
        return c;
    }

    /**
     * 根据条件查询列表
     * @param affairCondition
     * @param fi
     * @param preference
     * @return
     */
    private List<CtpAffair> querySectionAffair(AffairCondition affairCondition, FlipInfo fi,
            Map<String, String> preference) {
        Long memberId = AppContext.getCurrentUser().getId();
        affairCondition.setMemberId(memberId);
        String panel = SectionUtils.getPanel("all", preference);
        // 流程来源
        if (!"all".equals(panel)) {
            if (Strings.isNotBlank(panel) && "sources".equals(panel)) {
                affairCondition.addSourceSearchCondition(preference, false);
            } else {
                String tempStr = preference.get(panel + "_value");
                if (Strings.isNotBlank(tempStr)) {
                    // 组装查询条件
                    if ("track_catagory".equals(panel)) {//分类
                        affairCondition.addSearch(SearchCondition.catagory, tempStr, null);
                    } else if ("importLevel".equals(panel)) {//重要程度
                        affairCondition.addSearch(SearchCondition.importLevel, tempStr, null);
                    } else if ("templete_pending".equals(panel)) {//模板分类
                        affairCondition.addSearch(SearchCondition.templete, tempStr, null);
                    }
                } else {
                    return new ArrayList<CtpAffair>();
                }
            }

        } else {
            affairCondition.addSearch(SearchCondition.catagory, "sent_catagory_all", null);
        }
        return affairCondition.getSectionAffair(affairManager, StateEnum.col_sent.key(), fi);
    }

    /**
     * 获得列表模版
     * @param affairs
     * @return
     */
    private MultiRowVariableColumnTemplete getTemplete(List<CtpAffair> affairs, Map<String, String> preference) {
        MultiRowVariableColumnTemplete c = new MultiRowVariableColumnTemplete();

        User user = AppContext.getCurrentUser();
        String widthStr = preference.get("width");
        int width = 10;
        if (Strings.isNotBlank(widthStr)) {
            width = Integer.valueOf(widthStr);
        }
        //显示列
        String rowStr = preference.get("rowList");
        if (Strings.isBlank(rowStr)) {
        	//客开 start
            /*if (user.isV5Member()) {
                rowStr = "subject,publishDate,category";
            } else {
                rowStr = "subject,publishDate";
            }*/
        	rowStr = "category,subject,publishDate,currentNodesInfo";
        	//客开 end
        	
        }
        String[] rows = rowStr.split(",");
        List<String> list = Arrays.asList(rows);
        //判断是否选择‘标题’
        boolean isSubject = list.contains("subject");
        //判断是否选择‘发起时间’
        boolean isCreateDatee = list.contains("publishDate");
        //判断是否选择'公文文号'
        boolean isEdocMark = list.contains("edocMark");
        //判断是否选择‘分类’
        boolean isCategory = list.contains("category");
        //判断是否选择‘当前待办人’
        boolean isCurrentNodesInfo = list.contains("currentNodesInfo");

        Boolean isGov = (Boolean) (SysFlag.is_gov_only.getFlag());
        if (isGov == null) {
            isGov = false;
        }
        boolean hasInfoReportGrant = false;
        //默认为8条记录
        int count = 8;
        
        //客开 gxy 20180511 栏目固定显示条数 start
       /* String coun = preference.get("count");
        if (Strings.isNotBlank(coun)) {
            count = Integer.parseInt(coun);
        }
        count = affairs.size();*/
      //客开 gxy 20180511 栏目固定显示条数 end
        Map<Long, String> currentNodeInfos = commonAffairSectionUtils.parseCurrentNodeInfos(affairs);
        
      //客开 start
        MultiRowVariableColumnTemplete.Row rowsub = c.addRow();
		MultiRowVariableColumnTemplete.Cell subrows = rowsub.addCell();
		subrows.setAlt("任务来源");
		subrows.setCellContent("任务来源");
		subrows.setClassName("font_bold");
		subrows.setCellWidth(20);
		
		MultiRowVariableColumnTemplete.Cell subrows1 = rowsub.addCell();
		subrows1.setAlt("标题");
		subrows1.setCellContent("标题");
		subrows1.setClassName("font_bold");
		subrows1.setCellWidth(40);
		
		MultiRowVariableColumnTemplete.Cell subrows2 = rowsub.addCell();
		subrows2.setAlt("发起时间");
		subrows2.setCellContent("发起时间");
		subrows2.setClassName("font_bold");
		subrows2.setCellWidth(20);
		
		MultiRowVariableColumnTemplete.Cell subrows3 = rowsub.addCell();
		subrows3.setAlt("当前待办人");
		subrows3.setCellContent("当前待办人");
		subrows3.setClassName("font_bold");
		subrows3.setCellWidth(20);
		//客开 end
        
        for (int i = 0; i < count-1; i++) {
            MultiRowVariableColumnTemplete.Row row = c.addRow();
            //标题
            MultiRowVariableColumnTemplete.Cell subjectCell = null;
            //发起时间
            MultiRowVariableColumnTemplete.Cell createDateCell = null;
            //公文文号
            MultiRowVariableColumnTemplete.Cell edocMarkCell = null;
            //分类
            MultiRowVariableColumnTemplete.Cell categoryCell = null;
            //当前待办人
            MultiRowVariableColumnTemplete.Cell currentNodesInfoCell = null;

            //客开 start
            if (isCategory) {
                categoryCell = row.addCell();
                categoryCell.setCellWidth(20);
            	categoryCell.setCellContentWidth(20);
            }
            //客开 end 
            if (isSubject) {
                subjectCell = row.addCell();
                //客开 start
                /*subjectCell.setCellWidth(100);
                int cellWidth = 50;
                if(rows.length == 3) {
                	cellWidth = 65;
                }else if(rows.length == 2) {
                	cellWidth = 90;
                }else if(rows.length == 1){
                	cellWidth = 100;
                }
                subjectCell.setCellContentWidth(cellWidth);*/
            	subjectCell.setCellWidth(40);
            	subjectCell.setCellContentWidth(40);
            	//客开 end
            }
            if (isCreateDatee) {
                createDateCell = row.addCell();
                //客开 start
                createDateCell.setCellWidth(20);
                createDateCell.setCellContentWidth(20);
                //客开 end
            }
            if (isEdocMark) {
                edocMarkCell = row.addCell();
            }
            if (isCurrentNodesInfo) {
                currentNodesInfoCell = row.addCell();
                currentNodesInfoCell.setCellWidth(20);
                currentNodesInfoCell.setCellContentWidth(20);
            }
            /*if (isCategory) {
                categoryCell = row.addCell();
            }*/
            if (affairs == null || affairs.size() < 1) {
                continue;
            }
            if (i < affairs.size()) {
                CtpAffair affair = affairs.get(i);
                String url = "";
                String forwardMember = affair.getForwardMember();
                Integer resentTime = affair.getResentTime();
                String subject = ColUtil.showSubjectOfAffair(affair, false, -1).replaceAll("\r\n", "").replaceAll("\n",
                        "");
                if (isSubject) {
                    if (affair.getAutoRun() != null && affair.getAutoRun()) {
                        subject = ResourceUtil.getString("collaboration.newflow.fire.subject", subject);
                    }
                    subjectCell.setAlt(ColUtil.mergeSubjectWithForwardMembers(affair.getSubject(), forwardMember,
                            resentTime, null, -1));
                    //设置重要程度图标
                    if (affair.getImportantLevel() != null && affair.getImportantLevel() > 1
                            && affair.getImportantLevel() < 6) {
                        subjectCell.addExtPreClasses("ico16 important" + affair.getImportantLevel() + "_16");
                    }
                    //设置附件图标
                    if (AffairUtil.isHasAttachments(affair)) {
                        subjectCell.addExtClasses("ico16 affix_16");
                    }
                    //表单授权
                    if (AffairUtil.getIsRelationAuthority(affair)) {
                        subjectCell.addExtClasses("ico16 authorize_16");
                    }
                    //流程状态
                    if (Integer.valueOf(CollaborationEnum.flowState.finish.ordinal())
                            .equals(affair.getSummaryState())) {
                        subjectCell.addExtPreClasses("ico16 flow3_16");
                    } else if (Integer.valueOf(CollaborationEnum.flowState.terminate.ordinal())
                            .equals(affair.getSummaryState())) {
                        subjectCell.addExtPreClasses("ico16 flow1_16");
                    }
                    //设置正文类型图标
                    if (affair.getBodyType() != null && !"10".equals(affair.getBodyType())
                            && !"30".equals(affair.getBodyType()) && !"HTML".equals(affair.getBodyType())) {
                        String bodyType = affair.getBodyType();
                        //迁移的应用会议、公文等保存的是字符串的形式，这里做下适配 --xiangfan
                        if ("OfficeWord".equals(bodyType)) {
                            bodyType = String.valueOf(MainbodyType.OfficeWord.getKey());
                        } else if ("OfficeExcel".equals(bodyType)) {
                            bodyType = String.valueOf(MainbodyType.OfficeExcel.getKey());
                        } else if ("WpsWord".equals(bodyType)) {
                            bodyType = String.valueOf(MainbodyType.WpsWord.getKey());
                        } else if ("WpsExcel".equals(bodyType)) {
                            bodyType = String.valueOf(MainbodyType.WpsExcel.getKey());
                        } else if ("Pdf".equals(bodyType)) {
                            bodyType = String.valueOf(MainbodyType.Pdf.getKey());
                        }
                        subjectCell.addExtClasses("ico16 office" + bodyType + "_16");
                    }
                    subjectCell.setCellContent(subject.replaceAll("\\r\\n", ""));
                }
                int app = affair.getApp();
                
                //客开 2018-03-23 gxy start
                String categoryName="";
                try {
                	CtpTemplateCategory clc = null;
                	CtpTemplate ctpTemplate = null;
    				if(affair.getTempleteId()!=null && !"".equals(affair.getTempleteId()) && !"null".equals(affair.getTempleteId()) ){
    					ctpTemplate = templateManager.getCtpTemplate(Long.valueOf(affair.getTempleteId()));
    					clc = templateManager.getCtpTemplateCategory(ctpTemplate.getCategoryId());
    					if("发文模版".equals(clc.getName())){
    						if("-2066523224662719456".equals(ctpTemplate.getId()+"") ){
        						categoryName = "部门发文";
        					}else{
        						categoryName = "公司发文";
        					}
    					//客开 2018-07-03 赵培珅 任务来源显示错误 start 
    					}else if("收文模版".equals(clc.getName())){
    							categoryName="收文处理";
    					}else{
    						categoryName = clc.getName();
    					}
    					if("2135462982126750833".equals(ctpTemplate.getId()+"") ){
    						categoryName = "签报";
    					}
    					//客开 2018-07-03 赵培珅 任务来源显示错误 end
    				}else{
    					categoryName = ResourceUtil.getString("application."+app+".label");
    				}
				} catch (Exception e) {
					log.error("获取任务来源异常",e);
				}
                //客开 2018-03-23 gxy end
                
                ApplicationCategoryEnum appEnum = ApplicationCategoryEnum.valueOf(app);
                String from = null;
                switch (StateEnum.valueOf(affair.getState())) {
                    case col_sent:
                        from = "listSent";
                        break;
                    case col_pending:
                        from = "listPending";
                        break;
                    case col_done:
                        from = "listDone";
                        break;
                    default:
                        from = "listDone";
                }
                switch (appEnum) {
                    case collaboration:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL(
                                    "/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId="
                                            + affair.getId());
                        }
                        if (categoryCell != null) {
                            //判断是否有资源菜单权限
                            if (ColUtil.checkByReourceCode("F01_listSent")) {
                                url = AppContext.getRawRequest().getContextPath()
                                        + "/collaboration/collaboration.do?method=listSent";
                                categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            }
                            categoryCell.setCellContentHTML(categoryName);
                        }
                        break;
                    case edocSend:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId="
                                    + affair.getId() + "");
                        }
                        if (categoryCell != null) {
                            if (user.hasResourceCode("F07_sendNewEdoc")) {
                                url = AppContext.getRawRequest().getContextPath()
                                        + "/edocController.do?method=entryManager&entry=sendManager&listType=listSent";
                                categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            }

                            categoryCell.setCellContentHTML(categoryName);
                        }
                        getEdocExtField(affair, edocMarkCell, width);
                        break;
                    case edocRec:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId="
                                    + affair.getId() + "");
                        }
                        if (categoryCell != null) {
                            //判断是否有资源菜单权限
                            if (user.hasResourceCode("F07_recSent")) {
                                url = AppContext.getRawRequest().getContextPath()
                                        + "/edocController.do?method=entryManager&entry=recManager&listType=listSent";
                                categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            }

                            categoryCell.setCellContentHTML(categoryName);
                        }
                        getEdocExtField(affair, edocMarkCell, width);
                        break;
                    case edocSign:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId="
                                    + affair.getId() + "");
                        }
                        if (categoryCell != null) {
                            //判断是否有资源菜单权限
                            //                    	    if(user.hasResourceCode("F07_signNewEdoc")){
                            if (user.hasResourceCode("F07_signReport")) {
                                url = AppContext.getRawRequest().getContextPath()
                                        + "/edocController.do?method=entryManager&entry=signReport&listType=listSent";
                                categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            }

                            categoryCell.setCellContentHTML(categoryName);
                        }
                        getEdocExtField(affair, edocMarkCell, width);
                        break;
                    case exSend:
                    case exSign:
                    case edocRegister:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL("/edocController.do?method=detailIFrame&from=" + from + "&affairId="
                                    + affair.getId() + "");
                        }
                        if (categoryCell != null) {
                            //判断是否有资源菜单权限
                            if (ColUtil.checkByReourceCode("F07_recRegister")) {
                                url = AppContext.getRawRequest().getContextPath()
                                        + "/edocController.do?method=entryManager&entry=recManager&listType=listV5Register";
                                categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            }
                            categoryCell.setCellContentHTML(categoryName);
                        }
                        getEdocExtField(affair, edocMarkCell, width);
                        break;
                    case info:
                        if (subjectCell != null) {
                            subjectCell.setLinkURL("/infoDetailController.do?method=detail&summaryId="
                                    + affair.getObjectId() + "&from=" + from + "&affairId=" + affair.getId() + "");
                        }
                        if (categoryCell != null) {
                            if (configGrantManager != null) {
                                hasInfoReportGrant = configGrantManager.hasConfigGrant(user.getLoginAccount(),
                                        user.getId(), "info_config_grant", "info_config_grant_report");
                                if (hasInfoReportGrant) {
                                    url = AppContext.getRawRequest().getContextPath()
                                            + "/infoNavigationController.do?method=indexManager&entry=infoReport&toFrom=listInfoReported&affairId="
                                            + affair.getObjectId();
                                }
                            }
                            categoryName = "<a href=" + url + ">" + categoryName + "</a>";
                            categoryCell.setCellContentHTML(categoryName);
                        }
                        break;
                    default:
                        break;
                }
                if (createDateCell != null) {
                   // String dateTime = ColUtil.getDateTime(affair.getCreateDate(), "yyyy-MM-dd HH:mm");
                    String dateTime = Datetimes.format(affair.getCreateDate(), "yyyy-MM-dd HH:mm");//客开 修改时间显示格式
                    createDateCell.setCellContentHTML(
                            "<span class='color_gray' title='" + dateTime + "'>" + dateTime + "</span>");
                }
                //当前处理人
                List<Integer> edocApps = new ArrayList<Integer>();
                edocApps.add(ApplicationCategoryEnum.edocSend.getKey());//发文 19
                edocApps.add(ApplicationCategoryEnum.edocRec.getKey());//收文 20
                edocApps.add(ApplicationCategoryEnum.edocSign.getKey());//签报21
                edocApps.add(ApplicationCategoryEnum.exSend.getKey());//待发送公文22
                edocApps.add(ApplicationCategoryEnum.exSign.getKey());//待签收公文 23
                edocApps.add(ApplicationCategoryEnum.edocRegister.getKey());//待登记公文 24
                edocApps.add(ApplicationCategoryEnum.edocRecDistribute.getKey());//收文分发34

                
                //客开 gxy 20180622 start
                String currentNodesInfoStr = currentNodeInfos.get(affair.getObjectId());
                if (Strings.isNotBlank(currentNodesInfoStr) && isCurrentNodesInfo) {
                    String currentInfo = Strings.getSafeLimitLengthString(currentNodesInfoStr, 8, "..");
                    currentInfo = "<span title='" + currentNodesInfoStr + "' >" + currentInfo + "</span>";
                    currentNodesInfoCell.setCellContentHTML(currentInfo);
                }
                
                /*try {
                	List<CtpAffair> caList = affairManager.getAffairs(affair.getObjectId(), StateEnum.col_pending);
        			if(caList.size()>0){
        				//客开  赵培珅  2018-06-20 start 代办人显示错误
        				//if(null != caList.get(0).getSummaryState() && caList.get(0).getSummaryState()!=3){
	        				OrgManager orgManager = (OrgManager) AppContext.getBean("orgManager");
							V3xOrgMember member = orgManager.getMemberById(caList.get(0).getMemberId());
							String currentInfo=Strings.getSafeLimitLengthString(member.getName(), 8, "..");
	                    	currentInfo="<span title='"+member.getName()+"' >"+currentInfo+"</span>";
	                    	currentNodesInfoCell.setCellContentHTML(currentInfo);
        			//	}
        				//客开  赵培珅  2018-06-20 end  代办人显示错误
        			}
				} catch (Exception e) {
				}*/
                
                //客开 gxy 20180622 end
                
                
            }
        }
        return c;
    }

    /**
     * 取出公文扩展字段
     * @param affair CtpAffair对象
     * @param edocMarkCell 公文文号
     */
    private void getEdocExtField(CtpAffair affair, MultiRowVariableColumnTemplete.Cell edocMarkCell, int width) {
        Map<String, Object> extParam = AffairUtil.getExtProperty(affair);
        if (null != extParam && null != extParam.get(AffairExtPropEnums.edoc_edocMark.name()) && edocMarkCell != null) {
            Object obj = extParam.get(AffairExtPropEnums.edoc_edocMark.name());
            if (obj != null) {
                String str = obj.toString();
                if (str.length() > 7 && width < 10)
                    str = str.substring(0, 7) + "...";
                edocMarkCell.setCellContentHTML("<span title='" + obj.toString() + "' >" + str + "</span>");
            }
        }
    }
    
}
