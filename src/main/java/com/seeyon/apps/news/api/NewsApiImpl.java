package com.seeyon.apps.news.api;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.seeyon.apps.news.bo.NewsDataBO;
import com.seeyon.apps.news.bo.NewsTypeBO;
import com.seeyon.apps.news.event.NewsAddEvent;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.usermessage.MessageContent;
import com.seeyon.ctp.common.usermessage.MessageReceiver;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.event.EventDispatcher;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.portal.util.Constants.SpaceType;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.SQLWildcardUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.news.domain.NewsData;
import com.seeyon.v3x.news.domain.NewsType;
import com.seeyon.v3x.news.manager.NewsDataManager;
import com.seeyon.v3x.news.manager.NewsTypeManager;
import com.seeyon.v3x.news.util.NewsUtils;

public class NewsApiImpl extends AbstractNewsApi implements NewsApi {

    private NewsTypeManager    newsTypeManager;
    private NewsDataManager    newsDataManager;
    private NewsUtils          newsUtils;
    private OrgManager         orgManager;
    private AttachmentManager  attachmentManager;
    private UserMessageManager userMessageManager;

    public void setNewsTypeManager(NewsTypeManager newsTypeManager) {
        this.newsTypeManager = newsTypeManager;
    }

    public void setNewsDataManager(NewsDataManager newsDataManager) {
        this.newsDataManager = newsDataManager;
    }

    public void setNewsUtils(NewsUtils newsUtils) {
        this.newsUtils = newsUtils;
    }

    public void setOrgManager(OrgManager orgManager) {
        this.orgManager = orgManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
        this.userMessageManager = userMessageManager;
    }

    @Override
    public NewsTypeBO getNewsType(Long id) throws BusinessException {
        NewsType newsType = newsTypeManager.getById(id);
        return NewsUtils.newsTypePOToBO(newsType);
    }

    @Override
    public List<NewsTypeBO> findAllNewsTypes() throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        Collection<NewsType> newsTypes = newsTypeManager.getAllNewsTypes();
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findAllCustomNewsTypes() throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.getAllCustomTypes();
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findGroupNewsTypes() throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.groupFindAll();
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findAccountNewsTypes(Long accountId) throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.findAccountNewsTypes(accountId);
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findAllNewsTypesCanIssue(Long memberId) throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.getTypesCanNew(memberId, null, null);
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findGroupNewsTypesCanIssue(Long memberId) throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.getTypesCanNew(memberId, SpaceType.group, null);
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public List<NewsTypeBO> findAccountNewsTypesCanIssue(Long memberId, Long accountId) throws BusinessException {
        List<NewsTypeBO> newsTypeBO = new ArrayList<NewsTypeBO>();
        List<NewsType> newsTypes = newsTypeManager.getTypesCanNew(memberId, null, accountId);
        for (NewsType newsType : newsTypes) {
            newsTypeBO.add(NewsUtils.newsTypePOToBO(newsType));
        }
        return newsTypeBO;
    }

    @Override
    public Long issueNewsData(NewsDataParam newsDataParam) throws BusinessException {
        if (newsDataParam.getTitle() == null || newsDataParam.getTypeId() == null || newsDataParam.getContent() == null || newsDataParam.getCategroy() == null || newsDataParam.getMemberId() == null) {
            throw new BusinessException("参数不能为空！");
        }
        V3xOrgMember member = orgManager.getMemberById(newsDataParam.getMemberId());
        NewsType type = newsTypeManager.getById(newsDataParam.getTypeId());
        NewsData bean = new NewsData();
        bean.setIdIfNew();

        bean.setCreateDate(new Date());
        bean.setPublishDate(new Date());
        bean.setCreateUser(newsDataParam.getMemberId());
        bean.setAuditDate(new Timestamp(System.currentTimeMillis()));
        bean.setAuditUserId(newsDataParam.getMemberId());
        bean.setReadCount(0);
        bean.setDataFormat(newsDataParam.getDataFormat());
        bean.setTitle(newsDataParam.getTitle());
        bean.setTypeId(newsDataParam.getTypeId());
        bean.setType(type);
        bean.setTopOrder(Byte.valueOf("0"));
        bean.setPublishUserId(newsDataParam.getMemberId());
        bean.setSpaceType(type.getSpaceType());
        bean.setAccountId(type.getAccountId());
        bean.setDeletedFlag(false);
        //客开 start
        //如果有排版节点，则发布状态置为待排版，否则直接发布
        if(type.isTypesettingFlag() && type.getTypesettingStaff()!= null && type.getTypesettingStaff().intValue()!=0 && type.getTypesettingStaff().intValue()!=0){
          bean.setState(com.seeyon.v3x.news.util.Constants.DATA_STATE_TYPESETTING_CREATE);
        }else{
          bean.setState(com.seeyon.v3x.news.util.Constants.DATA_STATE_ALREADY_PUBLISH);
        }
        //客开 end
        //增加标识，表明此新闻是由信息报送转发
        bean.setExt4(newsDataParam.getCategroy().name());
        bean.setContent(newsDataParam.getContent());
        boolean hasAttFlag = attachmentManager.hasAttachments(newsDataParam.getObjectId(), newsDataParam.getObjectId());
        if (hasAttFlag) {
            attachmentManager.copy(newsDataParam.getObjectId(), newsDataParam.getObjectId(), bean.getId(), bean.getId(), ApplicationCategoryEnum.news.key());//附件
            bean.setAttachmentsFlag(true);
        }
        //设置发布部门
        if (newsDataParam.getDepartmentId() == null) {
            bean.setPublishDepartmentId(member.getOrgDepartmentId());
        } else {
            bean.setPublishDepartmentId(newsDataParam.getDepartmentId());
        }
        //发布新闻
        newsDataManager.saveCollNews(bean);

        //客开 如果是发布状态，触发发布事件 start
        if(bean.getState().intValue() == com.seeyon.v3x.news.util.Constants.DATA_STATE_ALREADY_PUBLISH){
          //触发发布事件
          NewsAddEvent newsAddEvent = new NewsAddEvent(this);
          newsAddEvent.setNewsDataBO(NewsUtils.newsDataPOToBO(bean));
          EventDispatcher.fireEvent(newsAddEvent);

          //直接发送不审合消息
          
          Set<Long> resultIds = new HashSet<Long>();
          List<V3xOrgMember> listMemberId = newsUtils.getScopeMembers(type.getSpaceType(), bean.getAccountId(), type.getOutterPermit());
          for (V3xOrgMember member1 : listMemberId) {
              resultIds.add(member1.getId());
          }

          userMessageManager.sendSystemMessage(MessageContent.get("news.auditing", bean.getTitle(), member.getName()), ApplicationCategoryEnum.news, member.getId(),
                MessageReceiver.getReceivers(new Long(ApplicationCategoryEnum.news.getKey()), resultIds, "message.link.news.assessor.auditing", String.valueOf(bean.getId())), bean.getTypeId());
         }
        //客开 end
        return bean.getId();
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public List<NewsTypeBO> findNewsTypesByAccountId(FlipInfo fi, Long accountId, String condition, String value1, String value2) throws BusinessException {
        if (accountId == null) {
            throw new BusinessException("参数不能为空！");
        }
        StringBuilder hql = new StringBuilder(" from NewsType where usedFlag = :usedFlag and accountId = :accountId ");
        Map parameter = new HashMap();
        parameter.put("usedFlag", true);
        parameter.put("accountId", accountId);
        if (Strings.isNotBlank(condition)) {
            if ("name".equals(condition) && Strings.isNotBlank(value1)) {
                hql.append(" and typeName like :typeName ");
                parameter.put("typeName", "%" + SQLWildcardUtil.escape(value1) + "%");
            }
        }
        List<NewsType> list = DBAgent.find(hql.toString(), parameter, fi);

        List<NewsTypeBO> result = new ArrayList<NewsTypeBO>();
        if (Strings.isNotEmpty(list)) {
            for (NewsType newsType : list) {
                result.add(NewsUtils.newsTypePOToBO(newsType));
            }
        }
        return result;
    }

    @SuppressWarnings({ "rawtypes", "unchecked" })
    public List<NewsDataBO> findNewsDatasByTypeId(FlipInfo fi, Long typeId, String condition, String value1, String value2) throws BusinessException {
        if (typeId == null) {
            throw new BusinessException("参数不能为空！");
        }
        StringBuilder hql = new StringBuilder(" from NewsData where typeId = :typeId and deletedFlag = :deletedFlag and state = :state ");
        Map parameter = new HashMap();
        parameter.put("typeId", typeId);
        parameter.put("deletedFlag", false);
        parameter.put("state", com.seeyon.v3x.news.util.Constants.DATA_STATE_ALREADY_PUBLISH);
        if (Strings.isNotBlank(condition)) {
            if ("title".equals(condition) && Strings.isNotBlank(value1)) {
                hql.append(" and title like :title ");
                parameter.put("title", "%" + SQLWildcardUtil.escape(value1) + "%");
            }
        }
        hql.append(" order by publishDate desc ");
        List<NewsData> list = DBAgent.find(hql.toString(), parameter, fi);

        List<NewsDataBO> result = new ArrayList<NewsDataBO>();
        if (Strings.isNotEmpty(list)) {
            for (NewsData newsData : list) {
                result.add(NewsUtils.newsDataPOToBO(newsData));
            }
        }
        return result;
    }

}
