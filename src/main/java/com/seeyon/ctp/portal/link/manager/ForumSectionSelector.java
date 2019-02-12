package com.seeyon.ctp.portal.link.manager;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;

import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceUtil;
import com.seeyon.ctp.portal.po.PortalLinkCategory;
import com.seeyon.ctp.portal.po.PortalLinkSection;
import com.seeyon.ctp.portal.section.bo.SectionTreeNode;
import com.seeyon.ctp.portal.section.manager.BaseAbstractSectionSelector;
import com.seeyon.ctp.util.UUIDLong;

public class ForumSectionSelector extends BaseAbstractSectionSelector {
    private LinkCategoryManager   linkCategoryManager;
    private LinkSectionManager linkSectionManager;
    public void setLinkSectionManager(LinkSectionManager linkSectionManager) {
        this.linkSectionManager = linkSectionManager;
    }
    public void setLinkCategoryManager(LinkCategoryManager linkCategoryManager) {
        this.linkCategoryManager = linkCategoryManager;
    }
    @Override
    public List<SectionTreeNode> selectSectionTreeData(String spaceType, String spaceId) throws BusinessException {
        List<String[]> sections = super.selectAllowedSections(spaceType);
        //排序start
        String[] iframeSectionStr = sections.get(2);
        String[] ssoWebcontentSectionStr = sections.get(4);
        sections.set(2, ssoWebcontentSectionStr);
        sections.set(4, iframeSectionStr);
        //排序end
        List<SectionTreeNode> l = new ArrayList<SectionTreeNode>();
        SectionTreeNode rootNode = new SectionTreeNode();
        rootNode.setId("forumSectionTreeRoot");
        rootNode.setSectionName(ResourceUtil.getString("publicManager.select"));
        l.add(rootNode);
        if(CollectionUtils.isNotEmpty(sections)){
            //关联系统节点ID
            String newLinkSystemSectionUUID = String.valueOf(UUIDLong.longUUID());
            //常用链接节点ID
            String iframeSectionUUID = String.valueOf(UUIDLong.longUUID());
            //数据集成型节点ID
            String ssoWebcontentSection = String.valueOf(UUIDLong.longUUID());
            //功能操作型节点ID
            String ssoIframeSectionUUID = String.valueOf(UUIDLong.longUUID());
            
            boolean hasNewLinkSystemSection = false;
            for(String[] str : sections){
               if("newLinkSystemSection".equals(str[0])){
                   hasNewLinkSystemSection = true;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(newLinkSystemSectionUUID);
                   node.setSectionBeanId(str[0]);
                   node.setSectionName(ResourceUtil.getString("space.section.newLinkSystemSection"));
                   node.setSectionCategory(str[2]);
                   node.setParentId(rootNode.getId());
                   l.add(node);
                   continue;
               }
               if("lbsSearchSection".equals(str[0])){
                   hasNewLinkSystemSection = true;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(newLinkSystemSectionUUID);
                   node.setSectionBeanId(str[0]);
                   node.setSectionName(ResourceUtil.getString("attendance.common.list.label"));
                   node.setSectionCategory(str[2]);
                   node.setParentId(rootNode.getId());
                   l.add(node);
                   continue;
               }
               if("lbsMapSection".equals(str[0])){
                   hasNewLinkSystemSection = true;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(newLinkSystemSectionUUID);
                   node.setSectionBeanId(str[0]);
                   node.setSectionName(ResourceUtil.getString("attendance.common.map.label"));
                   node.setSectionCategory(str[2]);
                   node.setParentId(rootNode.getId());
                   l.add(node);
                   continue;
               }
               if("singleBoardLinkSection".equals(str[0])){
                   List<PortalLinkCategory> categories = linkCategoryManager.getAllCategories();
                   if(CollectionUtils.isNotEmpty(categories)){
                       for(PortalLinkCategory category : categories){
                           Long singleBoardId = category.getId();
                           String categoryName = ResourceUtil.getString(category.getCname());
                           SectionTreeNode node = new SectionTreeNode();
                           node.setId(String.valueOf(UUIDLong.longUUID()));
                           node.setSectionBeanId(str[0]);
                           node.setSectionName(categoryName);
                           node.setSectionCategory(str[2]);
                           node.setSingleBoardId(String.valueOf(singleBoardId));
                           if(hasNewLinkSystemSection){
                               node.setParentId(newLinkSystemSectionUUID);
                           }
                           l.add(node);
                       }
                   }
                   continue;
               }
               
               /**
                *  类型，0：数据集成型（SSOWebContentSection）1：功能操作型（SSOIframeSection）2：网页集成型（IframeSection） 
                */
               List<PortalLinkSection> linkSections = new ArrayList<PortalLinkSection>();
               String parentId = "";
               User user = AppContext.getCurrentUser();
               if("iframeSection".equals(str[0])){
                   if (user.isAdmin()) {
                       linkSections = linkSectionManager.selectLinkSectionByType(2);
                   } else {
                       linkSections = linkSectionManager.getSectionsByUserId(user.getId(),2);
                   }
                   parentId = iframeSectionUUID;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(iframeSectionUUID);
                   node.setSectionName(ResourceUtil.getString("space.section.iframe1"));
                   node.setParentId(rootNode.getId());
                   l.add(node);
               }
               if("ssoIframeSection".equals(str[0])){
                   if (user.isAdmin()) {
                       linkSections = linkSectionManager.selectLinkSectionByType(1);
                   } else {
                       linkSections = linkSectionManager.getSectionsByUserId(user.getId(),1);
                   }
                   parentId = ssoIframeSectionUUID;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(ssoIframeSectionUUID);
                   node.setSectionName(ResourceUtil.getString("space.section.ssoIframe1"));
                   node.setParentId(rootNode.getId());
                   l.add(node);
               }
               if("ssoWebcontentSection".equals(str[0])){
                   if (user.isAdmin()) {
                       linkSections = linkSectionManager.selectLinkSectionByType(0);
                   } else {
                       linkSections = linkSectionManager.getSectionsByUserId(user.getId(),0);
                   }
                   parentId = ssoWebcontentSection;
                   SectionTreeNode node = new SectionTreeNode();
                   node.setId(ssoWebcontentSection);
                   node.setSectionName(ResourceUtil.getString("space.section.ssoWebcontent1"));
                   node.setParentId(rootNode.getId());
                   l.add(node);
               }
               if(CollectionUtils.isNotEmpty(linkSections)){
                   for(PortalLinkSection linkSection : linkSections){
                       Long singleBoardId = linkSection.getId();
                       String categoryName = ResourceUtil.getString(linkSection.getSname());
                       SectionTreeNode node = new SectionTreeNode();
                       node.setId(String.valueOf(UUIDLong.longUUID()));
                       node.setSectionBeanId(str[0]);
                       node.setSectionName(categoryName);
                       node.setSectionCategory(str[2]);
                       node.setSingleBoardId(String.valueOf(singleBoardId));
                       node.setParentId(parentId);
                       l.add(node);
                   }
               }
            }
        }
        return l;
    }

}
