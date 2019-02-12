package com.seeyon.ctp.common.content.comment;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.apps.agent.bo.MemberAgentBean;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.GlobalNames;
import com.seeyon.ctp.common.ModuleType;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.constants.ApplicationCategoryEnum;
import com.seeyon.ctp.common.content.ContentConfig;
import com.seeyon.ctp.common.content.ContentInterface;
import com.seeyon.ctp.common.content.affair.AffairManager;
import com.seeyon.ctp.common.content.affair.constants.StateEnum;
import com.seeyon.ctp.common.content.affair.constants.SubStateEnum;
import com.seeyon.ctp.common.content.comment.Comment.CommentType;
import com.seeyon.ctp.common.content.comment.dao.CommentDao;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.filemanager.manager.AttachmentManager;
import com.seeyon.ctp.common.po.affair.CtpAffair;
import com.seeyon.ctp.common.po.comment.CtpCommentAll;
import com.seeyon.ctp.common.po.filemanager.Attachment;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.common.usermessage.UserMessageManager;
import com.seeyon.ctp.organization.bo.V3xOrgEntity;
import com.seeyon.ctp.organization.dao.OrgHelper;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.organization.po.OrgMember;
import com.seeyon.ctp.organization.po.OrgPost;
import com.seeyon.ctp.organization.po.OrgUnit;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.DateUtil;
import com.seeyon.ctp.util.FlipInfo;
import com.seeyon.ctp.util.ParamUtil;
import com.seeyon.ctp.util.Strings;
import com.seeyon.ctp.util.json.JSONUtil;

/**
 * <p>Title: T1开发框架</p>
 * <p>Description: 评论回复组件接口实现</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: seeyon.com</p>
 * @since CTP2.0
 */
public class CommentManagerImpl implements CommentManager {

    private final static Log  log = LogFactory.getLog(CommentManagerImpl.class);

    private AttachmentManager attachmentManager;

    private AffairManager     affairManager;

    private OrgManager       orgManager;
    
    private UserMessageManager     userMessageManager;
   
    private CommentDao commentDao;
    
    
    
   
	public CommentDao getCommentDao() {
		return commentDao;
	}

	public void setCommentDao(CommentDao commentDao) {
		this.commentDao = commentDao;
	}

	public UserMessageManager getUserMessageManager() {
      return userMessageManager;
    }

    public void setUserMessageManager(UserMessageManager userMessageManager) {
      this.userMessageManager = userMessageManager;
    }

    public OrgManager getOrgManager() {
      return orgManager;
    }

    public void setOrgManager(OrgManager orgManager) {
      this.orgManager = orgManager;
    }

    public void setAttachmentManager(AttachmentManager attachmentManager) {
        this.attachmentManager = attachmentManager;
    }

    public void setAffairManager(AffairManager affairManager) {
        this.affairManager = affairManager;
    }

    @Override
    public Comment insertComment(Comment comment, CtpAffair affair) throws BusinessException {
        //代理人
        Long affairId = comment.getAffairId();
        User user = AppContext.getCurrentUser();
        if (affairId != null) {
            if (affair != null && !affair.getMemberId().equals(user.getId())) {
                comment.setExtAtt2(user.getName());
            } else {
                comment.setExtAtt2(null);
            }
            if (affair != null){
                comment.setCreateId(affair.getMemberId());
            }
        } else {
            comment.setCreateId(AppContext.currentUserId());
        }

        comment.setCreateDate(DateUtil.currentDate());
        //设置当前用户访问来源设备
        comment.setPath(AppContext.getCurrentUser().getUserAgentFrom());
        String showToId = comment.getShowToId();
        
        //评论回复隐藏判断和信息生成
        if (comment.isHidden() != null && comment.isHidden()) {
            if (comment.getExtAtt2() != null && !showToId.contains(String.valueOf(user.getId()))){
            	if(Strings.isBlank(showToId)){
            		showToId = "Member|"+AppContext.getCurrentUser().getId();
            	}else{
            		showToId += ",Member|"+AppContext.getCurrentUser().getId();
            	}
            }
            if(Strings.isNotBlank(showToId)){
            	comment.setShowToId(getSelectPeopleElements(showToId));
            }
        } else {
            comment.setHidden(false);
            comment.setShowToId(null);
        }
        //默认转发次数为0
        if (comment.getForwardCount() == null)
            comment.setForwardCount(0);
        //默认类型为1 - 回复
        if (comment.getCtype() == null)
            comment.setCtype(1);

        CtpCommentAll commentAll = comment.toCommentAll();
        commentAll.setIdIfNew();

        //生成关联信息，支持两种关联信息传入方式，一种是直接传入List，一种是JSON字符串
        List attachList = comment.getAttachList();
        String relateInfo = comment.getRelateInfo();
        if (Strings.isNotBlank(relateInfo) && !relateInfo.startsWith("[")) {
            //不是数组的情况转换为数组
            relateInfo = "[" + relateInfo + "]";
        }
        if (Strings.isNotBlank(relateInfo)) {
            attachList = JSONUtil.parseJSONString(relateInfo, List.class);
        }
        if (attachList != null && attachList.size() > 0) {
            try {
                //关联信息创建
                List<Attachment> attList = attachmentManager.getAttachmentsFromAttachList(
                        ApplicationCategoryEnum.valueOf(comment.getModuleType()), commentAll.getModuleId(),
                        commentAll.getId(), attachList);
                attachmentManager.create(attList);
                commentAll.setRelateInfo(JSONUtil.toJSONString(attList));
            } catch (Exception e) {
                log.error("附件操作出错："+e.getLocalizedMessage(),e);
            }
        }

        DBAgent.save(commentAll);
        Comment newcomment = new Comment(commentAll);
        //评论回复消息推送
        if (comment.isPushMessage() != null && comment.isPushMessage()) {
            ContentConfig cc = ContentConfig.getConfig(ModuleType.getEnumByKey(comment.getModuleType()));

            ContentInterface ci = cc.getContentInterface();
            //包含了发起人附言和回复的消息
            if (ci != null) {
                comment.setId(newcomment.getId());
                ci.doCommentPushMessage(comment);
            }
        }
        return newcomment;
    }

    @Override
    public Comment insertComment(Comment comment) throws BusinessException {
        //代理人
        Long affairId = comment.getAffairId();
        CtpAffair affair = null;
        if (affairId != null) {
            affair = affairManager.get(affairId);
        }
        User user = AppContext.getCurrentUser();
        if(user !=null ){
            if(comment.getCreateId()==null){
                if(affair != null){
                    List<Long> ownerIds = MemberAgentBean.getInstance().getAgentToMemberId(ModuleType.collaboration.getKey(),user.getId());
                    boolean isProxy = false;
                    if(Strings.isNotEmpty(ownerIds) && ownerIds.contains(affair.getMemberId())) {
                        isProxy = true;
                    }
                    if (affair != null &&  !affair.getMemberId().equals(AppContext.getCurrentUser().getId()) && isProxy) {
                        comment.setExtAtt2(user.getName());
                    } else {
                        comment.setExtAtt2(null);
                    }
                    comment.setCreateId(affair.getMemberId());
                }else {
                    comment.setCreateId(AppContext.currentUserId());
                }
            }
            //设置当前用户访问来源设备
            comment.setPath(user.getUserAgentFrom());
        }else if(affair != null){
            if(comment.getCreateId()==null){
               comment.setCreateId(affair.getMemberId());
            }
        }
        comment.setCreateDate(DateUtil.currentDate());
        
        String showToId = comment.getShowToId();
        
        //评论回复隐藏判断和信息生成
        if (comment.isHidden() != null && comment.isHidden()) {
            if (comment.getExtAtt2() != null && !showToId.contains(String.valueOf(user.getId()))  ){
            	if(Strings.isBlank(showToId)){
            		showToId = "Member|"+user.getId();
            	}else{
            		showToId += ",Member|"+user.getId();
            	}
            }
            if(Strings.isNotBlank(showToId)){
            	comment.setShowToId(getSelectPeopleElements(showToId));
            }
        } else {
            comment.setHidden(false);
            comment.setShowToId(null);
        }
        //默认转发次数为0
        if (comment.getForwardCount() == null)
            comment.setForwardCount(0);
        //默认类型为1 - 回复
        if (comment.getCtype() == null)
            comment.setCtype(1);
        if(affair != null){
            AppContext.putThreadContext(Comment.THREAD_CTX_DOCUMENT_AFFAIR_MEMBER_ID,affair.getMemberId());
        }
        CtpCommentAll commentAll = comment.toCommentAll();
        commentAll.setIdIfNew();

        //生成关联信息，支持两种关联信息传入方式，一种是直接传入List，一种是JSON字符串
        List attachList = comment.getAttachList();
        String relateInfo = comment.getRelateInfo();
        if (Strings.isNotBlank(relateInfo) && !relateInfo.startsWith("[")) {
            //不是数组的情况转换为数组
            relateInfo = "[" + relateInfo + "]";
        }
        if (Strings.isNotBlank(relateInfo)) {
            attachList = JSONUtil.parseJSONString(relateInfo, List.class);
        }
        if (attachList != null && attachList.size() > 0) {
            try {
                //关联信息创建
                List<Attachment> attList = attachmentManager.getAttachmentsFromAttachList(
                        ApplicationCategoryEnum.valueOf(comment.getModuleType()), commentAll.getModuleId(),
                        commentAll.getId(), attachList);
                attachmentManager.create(attList);
                commentAll.setRelateInfo(JSONUtil.toJSONString(attList));
            } catch (Exception e) {
                log.error("附件操作出错："+e.getLocalizedMessage(),e);
            }
        }

        DBAgent.save(commentAll);
        
        comment.setId(commentAll.getId());
        comment.setRelateInfo(commentAll.getRelateInfo());
        return comment;
    }

    @Override
    public void deleteComment(ModuleType moduleType, Long commentId) throws BusinessException {
        String hql = "delete from CtpCommentAll where moduleType=:moduleType and id=:id";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("moduleType", moduleType.getKey());
        map.put("id", commentId);
        DBAgent.bulkUpdate(hql, map);
    }

    public void deleteCommentAllByModuleId(ModuleType moduleType, Long moduleId) throws BusinessException {
        String hql = "delete from CtpCommentAll where moduleType=:moduleType and moduleId=:moduleId";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("moduleType", moduleType.getKey());
        map.put("moduleId", moduleId);
        DBAgent.bulkUpdate(hql, map);
    }
    public  void deleteCommentAllByModuleIdAndCtypes(ModuleType moduleType, Long moduleId,List<Comment.CommentType> types ) throws BusinessException {
        
        String hql = "delete from CtpCommentAll where moduleType=:moduleType and moduleId=:moduleId and cType in (:cType)";
        Map<String, Object> mapX = new HashMap<String, Object>();
        mapX.put("moduleType", moduleType.getKey());
        mapX.put("moduleId", moduleId);
        List<Integer> ti = new ArrayList<Integer>();
        if(Strings.isEmpty(types)){
            return;
        }else{
            for(Comment.CommentType type : types){
                ti.add(type.getKey());
            }
        }
        mapX.put("cType",ti);
        DBAgent.bulkUpdate(hql, mapX);
    }
    public void deleteCommentAllByModuleIdAndParentId(ModuleType moduleType, Long moduleId,Long pid) throws BusinessException {
        String hql = "delete from CtpCommentAll where moduleType=:moduleType and moduleId=:moduleId and pid = :pid ";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("moduleType", moduleType.getKey());
        map.put("moduleId", moduleId);
        map.put("pid", pid);
        DBAgent.bulkUpdate(hql, map);
    }
    
    public void updateCommentCtype(Long id, Comment.CommentType type) throws BusinessException {
        String hql = "update CtpCommentAll as c set c.ctype=:ctype where c.id=:id";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("ctype", type.getKey());
        map.put("id", id);
        DBAgent.bulkUpdate(hql, map);
    }

    @Override
    public void updateComment(Comment comment) throws BusinessException {
        if (comment.getId() == null || comment.getId() == -1)
            return;
        //评论回复隐藏判断和信息生成
        if (comment.isHidden() != null && comment.isHidden()) {
            comment.setShowToId(getSelectPeopleElements(comment.getShowToId()));
        }
        CtpCommentAll commentAll = DBAgent.get(CtpCommentAll.class, comment.getId());
       
        comment.mergeCommentAll(commentAll);
        
        commentAll.setContent(comment.getContent());
        commentAll.setRichContent(comment.getRichContent());
        
        CtpAffair affair = null;
        Long affairId = comment.getAffairId();
        if (affairId != null) {
            affair = affairManager.get(affairId);
            
            User user = AppContext.getCurrentUser();
            List<Long> ownerIds = MemberAgentBean.getInstance().getAgentToMemberId(ModuleType.collaboration.getKey(),user.getId());
            boolean isProxy = false;
            if(Strings.isNotEmpty(ownerIds) && ownerIds.contains(affair.getMemberId())) {
                isProxy = true;
            }
           
            if (affair != null && !affair.getMemberId().equals(AppContext.getCurrentUser().getId()) && isProxy) {
                commentAll.setExtAtt2(AppContext.getCurrentUser().getName());
            } else {
                commentAll.setExtAtt2(null);
            }
        }
        if (affair != null) {
            commentAll.setCreateId(affair.getMemberId());
        } else {
            commentAll.setCreateId(AppContext.currentUserId());
        }
        //修改的时候先删除附件，然后再把所有的附件添加
        attachmentManager.deleteByReference(commentAll.getModuleId(), commentAll.getId());
        //生成关联信息，支持两种关联信息传入方式，一种是直接传入List，一种是JSON字符串
        List attachList = comment.getAttachList();
        String relateInfo = comment.getRelateInfo();
        if (Strings.isNotBlank(relateInfo)) {
            attachList = JSONUtil.parseJSONString(relateInfo, List.class);
        }
        if (attachList != null && attachList.size() > 0) {
            try {
                //关联信息创建
                List<Attachment> attList = attachmentManager.getAttachmentsFromAttachList(
                        ApplicationCategoryEnum.valueOf(comment.getModuleType()), commentAll.getModuleId(),
                        commentAll.getId(), attachList);
                attachmentManager.create(attList);
                commentAll.setRelateInfo(JSONUtil.toJSONString(attList));
            } catch (Exception e) {
                throw new BusinessException(e);
            }
        }
        DBAgent.update(commentAll);
    }

    @Override
    public List<Comment> getCommentList(ModuleType moduleType, Long moduleId) throws BusinessException {
        List<Comment> commentList = new ArrayList<Comment>();
        Comment comment = null;

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", moduleType.getKey());
        params.put("moduleId", moduleId);
        List<CtpCommentAll> commentAllList = DBAgent.findByNamedQuery("ctp_common_comment_findCommentByModule", params);
        List<Comment> treeList = new ArrayList<Comment>();
        for (CtpCommentAll commentAll : commentAllList) {
            comment = new Comment(commentAll);
            if (comment.getCtype() != null && comment.getCtype() < 0)
                commentList.add(comment);
            else
                treeList.add(comment);
        }

        commentList.addAll(getTreeList(treeList));

        return commentList;
    }
    
    public List<Comment> getCommentAllByModuleId(ModuleType moduleType, Long moduleId) throws BusinessException {
    	return getCommentAllByModuleId(moduleType,moduleId,false);      
    }
    @Override
    public List<Comment> getCommentAllByModuleId(ModuleType moduleType, Long moduleId,boolean isHistoryFlag) throws BusinessException {
    	List<Comment> commentList = new ArrayList<Comment>();
		if(isHistoryFlag){
			CommentDao commentDaoFK = (CommentDao)AppContext.getBean("commentDaoFK");
    		if(commentDaoFK != null){
    			commentList = commentDaoFK.getCommentAllByModuleId(moduleType, moduleId);
    		}
    	}else{
    		commentList = commentDao.getCommentAllByModuleId(moduleType, moduleId);
    	}
		
		return commentList;
    }
    
    @Deprecated
    public Map<Integer, Map<Integer, List<Comment>>> getCommentsWithForward(ModuleType moduleType, Long moduleId) throws BusinessException{
    	return getCommentsWithForward(moduleType, moduleId, false);
    }
    
    @Deprecated
    @Override
    public Map<Integer, Map<Integer, List<Comment>>> getCommentsWithForward(ModuleType moduleType, Long moduleId,boolean  isHistoryFlag)
            throws BusinessException {

        Comment comment = null;

      
        List<CtpCommentAll> commentAllList = new ArrayList<CtpCommentAll>();
        ContentConfig contentConfig = ContentConfig.getConfig(moduleType);
        CommentDao commentDaoFK = (CommentDao)AppContext.getBean("commentDaoFK");
        if (contentConfig.isCommentListByCreateDateDesc()){
        	if(isHistoryFlag){
        		if(commentDaoFK != null){
        			commentAllList = commentDaoFK.getCommentsByDesc(moduleType, moduleId);
        		}
        	}else{
        		commentAllList = commentDao.getCommentsByDesc(moduleType, moduleId);
        	}
        	
        }
        else{
        	if(isHistoryFlag){
        		if(commentDaoFK != null){
        			commentAllList = commentDaoFK.getComments(moduleType, moduleId);
        		}
        	}else{
        		commentAllList = commentDao.getComments(moduleType, moduleId);
        	}
        }

        Map<Integer, Map<Integer, List<Comment>>> resultMap = new HashMap<Integer, Map<Integer, List<Comment>>>();

        Integer curForwardCount = -1;
        Map<Integer, List<Comment>> curMap = null;
        //ctpcommentall ctype 字段    draft(-2, "草稿"), sender(-1, "发起人附言"), comment(0, "评论"), reply(1, "回复");
        Integer praiseToSumNum = 0;
        Map<String,Integer> forwardPraise  = new HashMap<String,Integer>();
        for (CtpCommentAll commentAll : commentAllList) {
            if((Integer.valueOf(0).equals(commentAll.getCtype()) && Integer.valueOf(1).equals(commentAll.getPraiseToSummary()))
                && (null == commentAll.getForwardCount()||(null !=commentAll.getForwardCount() && commentAll.getForwardCount().intValue() == 0))){
              praiseToSumNum += 1;
            }
            else{//转发
            	if(commentAll.getForwardCount()>0){//统计转发次数
            		String key = "p"+commentAll.getForwardCount();
            		int count = 0;
            		if(forwardPraise.get(key) == null){
            			forwardPraise.put(key, count);
            		}else{
            			count = forwardPraise.get(key);
            		}
            		if(Integer.valueOf(0).equals(commentAll.getCtype()) && 
            				Integer.valueOf(1).equals(commentAll.getPraiseToSummary())){
            			forwardPraise.put(key, count+1);
            		}
            	}
            }
            //praiseToSumNum += commentAll.getPraiseNumber()==null?0:commentAll.getPraiseNumber();
            comment = new Comment(commentAll);
            if(null != comment.getCreateId()){
            	String avatarImageUrl = OrgHelper.getAvatarImageUrl(comment.getCreateId());
            	comment.setAvatarImageUrl(avatarImageUrl);
            }
            String atts = comment.getRelateInfo();
            if(Strings.isNotBlank(atts) && atts.indexOf(":") != -1){
                try{
                    List list = JSONUtil.parseJSONString(atts,List.class);
                    List<Attachment> l = ParamUtil.mapsToBeans(list, Attachment.class, false);
                    l = attachmentManager.setOfficeTransformEnable(l);
                    comment.setRelateInfo(JSONUtil.toJSONString(l));
                }catch(Exception e){
                    log.error(e);
                }
            }
           
            Integer forwardCount = comment.getForwardCount();
            //默认转发次数为0
            if (forwardCount == null)
                forwardCount = 0;
            if (!forwardCount.equals(curForwardCount)) {
                curMap = new HashMap<Integer, List<Comment>>();
                curForwardCount = forwardCount;
                resultMap.put(forwardCount, curMap);
            }
            Integer ctype = comment.getCtype();
            if (ctype == null || ctype == 1) //回复和评论在一个List中，为创建树结构做准备
                ctype = 0;
            List<Comment> comList = curMap.get(ctype);
            if (comList == null) {
                comList = new ArrayList<Comment>();
                curMap.put(ctype, comList);
            }
            comment.setCreateName(Functions.showMemberName(comment.getCreateId()));
            comList.add(comment);
        }

        //组装评论和回复的树结构
        for (Integer forwardCount : resultMap.keySet()) {
            Map<Integer, List<Comment>> comMap = resultMap.get(forwardCount);
            List<Comment> comList = comMap.get(0);

            comMap.put(0, getTreeList(comList));

        }

        HttpServletRequest request = (HttpServletRequest) AppContext
                .getThreadContext(GlobalNames.THREAD_CONTEXT_REQUEST_KEY);
        //拆分设置界面属性
        List<Comment> commentList = null;
        List<Comment> commentSenderList = null;
        List<Comment> commentDraftList = null;

        for (Integer forwardCount : resultMap.keySet()) {
            if (forwardCount == 0) {
                Map<Integer, List<Comment>> comMap = resultMap.remove(0);
                for (Integer ctype : comMap.keySet()) {
                    if (ctype == 0){
                        commentList = comMap.get(ctype);
                    }else if (ctype == -1){
                        commentSenderList = comMap.get(ctype);
                    }else if (ctype == -2){
                        commentDraftList = comMap.get(ctype);
                    }
                }
                break;
            }
        }
        //客开 协同事项处理人意见区显示部门岗位信息 start
        Map<Long,Map<String,String>> unitAndPosts = new HashMap<Long, Map<String,String>>();
        if(CollectionUtils.isNotEmpty(commentList)){
          for(Comment c:commentList){
            OrgMember m = DBAgent.get(OrgMember.class, c.getCreateId());
            OrgUnit unit = DBAgent.get(OrgUnit.class, m.getOrgDepartmentId());
            String unitName = "";
            if(unit!=null){
//              String parentPath = unit.getPath().substring(0,unit.getPath().length()-4);
              String parentPath = unit.getPath().length()>=16?StringUtils.left(unit.getPath(), 16):unit.getPath();
              List<OrgUnit> parentUnits = DBAgent.find("from OrgUnit where IS_DELETED=0 and path='"+parentPath+"'");
              if(org.apache.commons.collections.CollectionUtils.isNotEmpty(parentUnits)){
//                unitName = parentUnits.get(0).getName()+"/"+unit.getName();
                unitName = parentUnits.get(0).getName();
              }
            }
            OrgPost post = DBAgent.get(OrgPost.class, m.getOrgPostId());
            String postName = "";
            if(post!=null){
              if(StringUtils.equals(post.getName(), ".")){
                postName ="&nbsp;";
              }else{
                postName ="&nbsp;"+post.getName();
              }
            }
            Map<String,String> unitAndPost = new HashMap<String, String>();
            unitAndPost.put("unitName", unitName);
            unitAndPost.put("postName", postName);
            unitAndPosts.put(c.getId(), unitAndPost);
          }
        }
        request.setAttribute("unitAndPosts", unitAndPosts);
        //客开 end
        request.setAttribute("commentList", commentList);
        request.setAttribute("praiseToSumNum", praiseToSumNum);
        request.setAttribute("commentSenderList", commentSenderList);
        request.setAttribute("commentDraftList", commentDraftList);
        request.setAttribute("commentForwardMap", resultMap);
        request.setAttribute("forwardPraise", forwardPraise);
        //计算初始化当前协同评论Path
        /*Integer maxPath = 1;
        if (commentList != null) {
            for (Comment comm : commentList) {
                String cp = comm.getPath();
                Integer cval = Integer.parseInt(cp);
                if (cval >= maxPath)
                    maxPath = cval + 1;
            }
        }
        String maxPathStr = String.valueOf(maxPath);
        if (maxPathStr.length() == 1)
            maxPathStr = "00" + maxPathStr;
        else if (maxPathStr.length() == 2)
            maxPathStr = "0" + maxPathStr;
        request.setAttribute("commentMaxPathStr", maxPathStr);*/

        //设置内容系统配置上下文
        request.setAttribute("contentCfg", ContentConfig.getConfig(moduleType));

        return resultMap;
    }

    @Override
    public List<Comment> getCommentList(ModuleType moduleType, Long moduleId, Long parentCommentId)
            throws BusinessException {
            String hql = " FROM CtpCommentAll as cl WHERE cl.moduleType=:moduleType AND cl.moduleId=:moduleId AND cl.pid = :pid ";
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("moduleType", moduleType.getKey());
            map.put("moduleId", moduleId);
            map.put("pid", parentCommentId);
            List<CtpCommentAll> po =  DBAgent.find(hql, map);
            List<Comment> list = new ArrayList<Comment>();
            for(CtpCommentAll a:po){
                list.add(new Comment(a));
            }
            return list;
    }
    
    public List<Comment> getCommentAllByCTYPE(ModuleType moduleType, Long moduleId,CommentType CommentType)throws BusinessException {
            String hql = " FROM CtpCommentAll as cl WHERE cl.moduleType=:moduleType AND cl.moduleId=:moduleId AND cl.ctype = :CommentType ";
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("moduleType", moduleType.getKey());
            map.put("moduleId", moduleId);
            map.put("CommentType", CommentType.getKey());
            List<CtpCommentAll> po =  DBAgent.find(hql, map);
            List<Comment> list = new ArrayList<Comment>();
            for(CtpCommentAll a:po){
                list.add(new Comment(a));
            }
            return list;
    }

    public List<Comment> getTreeList(List<Comment> comList) {
        List<Comment> commentList = new ArrayList<Comment>();
        if (comList != null) {
            Map<Long, Comment> allCommentMap = new HashMap<Long, Comment>();
            for (Comment com : comList) {
                allCommentMap.put(com.getId(), com);
                //根节点放入结果集
                if (com.getPid() != null && com.getPid() == 0)
                    commentList.add(com);
            }

            for (Comment pm : comList) {
                Long pid = pm.getPid();
                if (pid != null && pid != 0) {
                    Comment parent = allCommentMap.get(pid);
                    if (parent != null) {
                        parent.addChild(pm);
                        //pm.setParent(parent);
                        
                    }
                }
            }
        }
        return commentList;
    }

    @Override
    public void transForwardComment(ModuleType fromModuleType, Long fromModuleId, ModuleType toModuleType,
            Long toModuleId, boolean forwardOriginalNote, boolean forwardOriginalopinion) throws BusinessException {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", fromModuleType.getKey());
        params.put("moduleId", fromModuleId);
        List<CtpCommentAll> commentAllList = DBAgent.findByNamedQuery("ctp_common_comment_findCommentAllByModule",
                params);

        List<CtpCommentAll> newCommentAllList = new ArrayList<CtpCommentAll>();

        //所有意见的“老-新”ID映射，用于振荡回复意见拷贝
        Map<Long, Long> idMap = new HashMap<Long, Long>();

        //所有意见、回复的“老-新”ID映射，用于附件拷贝
        Map<Long, Long> attMap = new HashMap<Long, Long>();

        int maxForwardCount = 0;
        for (CtpCommentAll commentAll : commentAllList) {
            int forwardCount = Strings.escapeNULL(commentAll.getForwardCount(), new Integer(0));

            if (forwardCount > maxForwardCount) {
                maxForwardCount = forwardCount;
            }
        }

        //先处理发起者附言和处理意见
        for (CtpCommentAll commentAll : commentAllList) {
            if (commentAll.getCtype().intValue() == Comment.CommentType.sender.getKey()
                    || commentAll.getCtype().intValue() == Comment.CommentType.comment.getKey()) {

                //不转发原发起者附言
                if (!forwardOriginalNote && commentAll.getCtype().intValue() == Comment.CommentType.sender.getKey()) {
                    continue;
                }
                //不转发原处理意见
                if (!forwardOriginalopinion && commentAll.getCtype().intValue() == Comment.CommentType.comment.getKey()) {
                    continue;
                }

                Comment comment = new Comment(commentAll);

                CtpCommentAll newCommentAll = comment.toCommentAll();
                newCommentAll.setNewId();
                newCommentAll.setModuleId(toModuleId);
                newCommentAll.setModuleType(toModuleType.getKey());
                newCommentAll.setRelateInfo(null);

                //最近的协同意见
                if (newCommentAll.getForwardCount() == null || newCommentAll.getForwardCount().intValue() == 0) {
                    newCommentAll.setForwardCount(maxForwardCount + 1);
                }

                //如果是隐藏意见，就把内容清空
                if (Strings.isTrue(commentAll.isHidden())) {
                    newCommentAll.setContent("");
                } else { //隐藏的意见，不拷贝附件
                    attMap.put(commentAll.getId(), newCommentAll.getId());
                }

                newCommentAllList.add(newCommentAll);

                idMap.put(commentAll.getId(), newCommentAll.getId());
            }
        }

        //再处理振荡回复意见
        for (CtpCommentAll commentAll : commentAllList) {
            if (commentAll.getCtype().intValue() == Comment.CommentType.reply.getKey()) {
                Comment comment = new Comment(commentAll);

                Long newPid = idMap.get(commentAll.getPid());
                if (newPid == null) {
                    continue;
                }

                CtpCommentAll newCommentAll = comment.toCommentAll();
                newCommentAll.setNewId();
                newCommentAll.setModuleId(toModuleId);
                newCommentAll.setModuleType(toModuleType.getKey());
                newCommentAll.setPid(newPid);
                newCommentAll.setRelateInfo(null);

                //最近的协同意见
                if (newCommentAll.getForwardCount() == null || newCommentAll.getForwardCount().intValue() == 0) {
                    newCommentAll.setForwardCount(maxForwardCount + 1);
                }

                //如果是隐藏意见，就把内容清空
                if (Strings.isTrue(commentAll.isHidden())) {
                    newCommentAll.setContent("");
                } else { //隐藏的意见，不拷贝附件
                    attMap.put(commentAll.getId(), newCommentAll.getId());
                }

                newCommentAllList.add(newCommentAll);
            }
        }

        /******************* 处理附件 ********************/
        
        attMap.put(fromModuleId, toModuleId);

        // 意见Id - 其下面的意见
        Map<Long, List<Attachment>> id2Atts = new HashMap<Long, List<Attachment>>();

        List<Attachment> newAtts = new ArrayList<Attachment>();
        List<Attachment> attachments = this.attachmentManager.getByReference(fromModuleId);
        java.util.Date now = new java.util.Date();

        if (attachments != null) {
            for (Attachment att : attachments) {
                //图片、表单单元格文件不复制
                if (att.getType() == com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.IMAGE.ordinal()
                        || att.getType() == com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FormFILE
                                .ordinal()
                        || att.getType() == com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FormDOCUMENT
                                .ordinal()) {
                    continue;
                }

                Long newSubReference = attMap.get(att.getSubReference());

                if (newSubReference == null) {
                    continue;
                }

                Attachment newAtt = null;
                try {
                    newAtt = (Attachment) att.clone();
                    newAtt.setNewId();

                    if (att.getType() == com.seeyon.ctp.common.filemanager.Constants.ATTACHMENT_TYPE.FILE.ordinal()) {
                        //Long newFileId = UUIDLong.longUUID();
                        //this.fileManager.clone(att.getFileUrl(), att.getCreatedate(), newFileId, now);

                        newAtt.setFileUrl(att.getFileUrl());
                    }
                } catch (Exception e) {
                    log.warn("", e);
                    continue;
                }

                newAtt.setReference(toModuleId);
                newAtt.setSubReference(newSubReference); //新的意见id
                //newAtt.setCreatedate(now);

                newAtts.add(newAtt);

                Strings.addToMap(id2Atts, newSubReference, newAtt);
            }
        }

        for (CtpCommentAll comment : newCommentAllList) {
            List<Attachment> atts = id2Atts.get(comment.getId());
            if (!Strings.isEmpty(atts)) {
                comment.setRelateInfo(JSONUtil.toJSONString(atts));
            }
        }

        DBAgent.saveAll(newCommentAllList);
        this.attachmentManager.create(newAtts);
    }

    @Override
    public void deleteCommentByAffairId(Long affairId) throws BusinessException {
        String hql = "delete from CtpCommentAll where affairId=:affairId";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("affairId", affairId);
        DBAgent.bulkUpdate(hql, map);
    }
    public CtpCommentAll getDrfatComment(Long affairId)  throws BusinessException{
        String hql = " from CtpCommentAll where affairId = :affairId and ctype = :ctype ";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("affairId", affairId);
        map.put("ctype", Comment.CommentType.draft.getKey());
        List<CtpCommentAll> list = DBAgent.find(hql, map);
        if(Strings.isNotEmpty(list)){
            return list.get(0);
        }
        return null;
    }
    @Override
    public List<Comment> getCommentListByActivityAndMember(ModuleType moduleType, Long moduleId, Long activityId,
            Long memberId) throws BusinessException {
        List<CtpAffair> affairList = affairManager.getAffairsByObjectIdAndNodeId(moduleId, activityId);
        CtpAffair af = null;
        for (CtpAffair affair : affairList) {
            if (affair.getMemberId().equals(memberId)
                    && (affair.getState() == StateEnum.col_done.getKey() || (affair.getState() == StateEnum.col_pending
                            .getKey() && affair.getSubState() == SubStateEnum.col_pending_ZCDB.getKey()))) {
                af = affair;
                break;
            }
        }

        if (af == null)
            throw new BusinessException("未找到待办事项[moduleType:" + moduleType.getKey() + ",moduleId:" + moduleId
                    + ",activityId:" + activityId + ",memberId:" + memberId + "]");

        Long affairId = af.getId();

        Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", moduleType.getKey());
        params.put("moduleId", moduleId);
        params.put("affairId", affairId);
        params.put("createId", memberId);
        List<CtpCommentAll> commentAllList = DBAgent.findByNamedQuery(
                "ctp_common_comment_findCommentByModuleAndAffair", params);
        List<Comment> result = new ArrayList<Comment>();
        for (CtpCommentAll ctpCommentAll : commentAllList) {
            result.add(new Comment(ctpCommentAll));
        }
        return result;
    }

    @Override
    public FlipInfo getCommentListByPaging(ModuleType moduleType, Long moduleId, FlipInfo fpi) throws BusinessException {
        Map<String, Object> params = new HashMap<String, Object>();
        params.put("moduleType", moduleType.getKey());
        params.put("moduleId", moduleId);
        List<CtpCommentAll> commentAllList = DBAgent.findByNamedQuery(
                "ctp_common_comment_findCommentByModuleWithPagging", params);

        List<Comment> comList = new ArrayList<Comment>();
        for (CtpCommentAll commentAll : commentAllList) {
            Comment comment = new Comment(commentAll);
            comList.add(comment);
        }

        //组装评论和回复的树结构
        comList = getTreeList(comList);

        DBAgent.memoryPaging(comList, fpi);

        return fpi;
    }

    @Override
    public Comment getParentComment(Comment comment) throws BusinessException {
        Comment result = null;
        if (comment != null) {
            Long pid = comment.getPid();
            if (pid != null && pid != 0) {
                //根据性能情况看是否需要增加分区字段查询条件ModuleType
                CtpCommentAll ctpCommentAll = DBAgent.get(CtpCommentAll.class, pid);
                if (ctpCommentAll != null) {
                    result = new Comment(ctpCommentAll);
                }
            }
        }
        return result;
    }
    
    /**
     * 解析选人组件的字符串为数组,返回 member用逗号分割
     * @param selectPeopleStr
     * @return String
     */
    public static String getSelectPeopleElements(String selectPeopleStr) {
        String members = null;
        if (StringUtils.isNotBlank(selectPeopleStr)) {
            String[] entities = selectPeopleStr.split(",");
            for (String entity : entities) {
                String[] items = entity.split("[|]");
                if(Strings.isBlank(members)){
                    members = items[1];
                }else{
                    members += "," + items[1];
                }
            }
        }
        return members;
    }

    @SuppressWarnings("unchecked")
	public synchronized String addPraise(Map<String,String> para){
    	
    	User currentUser = AppContext.getCurrentUser();
      
		String hql =" from CtpCommentAll c where c.id=:moduleId";
		Map mp = new HashMap();
		mp.put("moduleId", Long.valueOf(para.get("moduleId")));
		List find = DBAgent.find(hql,mp);
		Integer count  = 0 ;
		if(Strings.isNotEmpty(find)){
		    CtpCommentAll c = (CtpCommentAll)find.get(0);
		    
		    //已经是点赞状态，直接返回
		    if(Strings.isNotBlank(c.getPraiseMemberIds()) && c.getPraiseMemberIds().indexOf(para.get("praiseMemberId")) != -1){
		    	return c.getPraiseNumber() == null ? String.valueOf(0) : String.valueOf(c.getPraiseNumber());
		    }
		    
		    String names ="";
		    if(null != c.getPraiseNumber()){
		    	count = c.getPraiseNumber() +1;
			}else{
				count += 1;
			}
			if(Strings.isNotBlank(c.getPraiseMemberIds())){
				names = c.getPraiseMemberIds()+","+para.get("praiseMemberId");
			}else{
				names = para.get("praiseMemberId");
			}
			c.setPraiseNumber(count);
			c.setPraiseMemberIds(names);
			DBAgent.update(c);
		
			if(null != currentUser && null != currentUser.getId() && !currentUser.getId().equals(c.getCreateId())){
				  ContentConfig cc = ContentConfig.getConfig(ModuleType.getEnumByKey(c.getModuleType()));
				  ContentInterface ci = cc.getContentInterface();
				  //包含了发起人附言和回复的消息
				  if (ci != null) {
				    try {
				    	ci.doCommentPrise(currentUser, para.get("subject"), c);
				    } catch (BusinessException e) {
				        log.error(e.getLocalizedMessage(),e);
				    }
				}
			}
		}
		return count+"";
    }
    
    @SuppressWarnings("unchecked")
	public synchronized String deletePraise(Map<String,String> para){
    	String hql =" from CtpCommentAll c where c.id=:moduleId";
    	Map mp = new HashMap();
    	mp.put("moduleId", Long.valueOf(para.get("moduleId")));
    	List find = DBAgent.find(hql,mp);
    	Integer count  = 0 ;
    	if(Strings.isNotEmpty(find)){
	        CtpCommentAll c = (CtpCommentAll)find.get(0);
	        
	        //已经是取消赞状态，直接返回
		    if(Strings.isNotBlank(c.getPraiseMemberIds()) && c.getPraiseMemberIds().indexOf(para.get("praiseMemberId")) == -1){
		    	return c.getPraiseNumber() == null ? String.valueOf(0) : String.valueOf(c.getPraiseNumber());
		    }
	        
	        
	        if(null != c.getPraiseNumber() && c.getPraiseNumber().intValue() != 0){
	        	count = c.getPraiseNumber() - 1;
	        }
	        String temStr=c.getPraiseMemberIds();
	        if(Strings.isNotBlank(c.getPraiseMemberIds())){
		         String curStr = para.get("praiseMemberId");
		          
		         if(temStr.startsWith(curStr) && temStr.length() > curStr.length()){
		        	 temStr = temStr.replace(curStr+",","");
		         }else if(temStr.startsWith(curStr) && temStr.length() == curStr.length()){
		            temStr = temStr.replace(curStr,"");
		         }else{
		            temStr = temStr.replace(","+curStr,"");
		         }
	        }
	        c.setPraiseNumber(count);
	        c.setPraiseMemberIds(temStr);
	        DBAgent.update(c);
	      }
      return count+"";
    }
    
    public String getPraiseNames(Map<String,String> para) throws NumberFormatException, BusinessException{
      String hql =" from CtpCommentAll c where c.id=:moduleId";
      Map mp = new HashMap();
      mp.put("moduleId", Long.valueOf(para.get("moduleId")));
      List find = DBAgent.find(hql,mp);
      if(Strings.isNotEmpty(find)){
        CtpCommentAll c = (CtpCommentAll)find.get(0);
        String tempStr = c.getPraiseMemberIds();
        if(Strings.isNotBlank(tempStr)){
            String result = Functions.showOrgEntities(tempStr, V3xOrgEntity.ORGENT_TYPE_MEMBER, ", ");
            if(result==null){
                result = "";
	      }
            return result;
        }else{
          return ""; 
        }
      }
      return "";
    }

	@Override
	public Comment getComment(Long id) throws BusinessException {
		CtpCommentAll c = DBAgent.get(CtpCommentAll.class, id);
		return new Comment(c);
	}

    @Override
    public Map<Long, List<Comment>> findCommentReplay(List<Long> parentIds) throws BusinessException {
        
        Map<Long, List<CtpCommentAll>> subComments = commentDao.findCommentReplay(parentIds);
        if((subComments == null || subComments.size() == 0) && AppContext.hasPlugin("fk")){
        	CommentDao commentDaoFK = (CommentDao) AppContext.getBean("commentDaoFK");
        	if(commentDaoFK != null){
        		subComments = commentDaoFK.findCommentReplay(parentIds);
        	}
        }
        Map<Long, List<Comment>> ret = new HashMap<Long, List<Comment>>();
        
        Set<Entry<Long, List<CtpCommentAll>>> entrys =  subComments.entrySet();
        for(Entry<Long, List<CtpCommentAll>> e : entrys){
            Long parentId = e.getKey();
            List<CtpCommentAll> commentAlls = e.getValue();
            List<Comment> cList = new ArrayList<Comment>();
            for(CtpCommentAll c : commentAlls){
                cList.add(new Comment(c));
            }
            ret.put(parentId, cList);
        }
        
        return ret;
    }
    
    public Map<Integer,Map<Integer,Integer>> countComments(ModuleType moduleType, Long moduleId,
			Map<String,Object> queryParams, boolean isHistory) throws BusinessException {
    	Map<Integer,Map<Integer,Integer>> countMap = new HashMap<Integer,Map<Integer,Integer>>();
		if (isHistory && AppContext.hasPlugin("fk")) {
			CommentDao commentDaoFK = (CommentDao) AppContext.getBean("commentDaoFK");
			if (commentDaoFK != null) {
				countMap = commentDaoFK.countComments(moduleType, moduleId, queryParams);
			}
		}
		else {
			countMap = commentDao.countComments(moduleType, moduleId, queryParams);
		}
		return countMap;
	}
    
    @Override
    public List<Comment> findCommentByType(ModuleType moduleType, Long moduleId,
            CommentType cType, FlipInfo fpi, boolean isCount, boolean isHistory)
            throws BusinessException {
        
        return findComments(moduleType, moduleId, cType, fpi, null, isCount, isHistory);
    }

    @Override
    public List<Comment> findLikeComment(ModuleType moduleType, Long moduleId, CommentType cType, FlipInfo fpi,
            boolean isCount, boolean isHistory) throws BusinessException {
        Map<String, Object> other = new HashMap<String, Object>();
        other.put("praiseToSummary", 1);
        return findComments(moduleType, moduleId, cType, fpi, other, isCount, isHistory);
    }

    @Override
    public List<Comment> findCommentByAttitude(ModuleType moduleType, Long moduleId, CommentType cType, FlipInfo fpi,
            String attitude, boolean isCount, boolean isHistory) throws BusinessException {
        Map<String, Object> other = new HashMap<String, Object>();
        other.put("extAtt1", attitude);
        return findComments(moduleType, moduleId, cType, fpi, other, isCount, isHistory);
    }
    
    /**
     * 获取评论
     * @Author      : xuqw
     * @Date        : 2015年11月25日下午11:32:54
     * @param moduleType
     * @param moduleId
     * @param cType 类型
     * @param fpi 分页对象呢
     * @param other 其他查询条件
     * @param isCount 是否只查询数量
     * @return
     * @throws BusinessException
     */
    public List<Comment> findComments(ModuleType moduleType, Long moduleId, 
            CommentType cType, FlipInfo fpi, Map<String, Object> other, boolean isCount, boolean isHistory) throws BusinessException{
        
        List<CtpCommentAll> commentAllList = new ArrayList<CtpCommentAll>();

        if(isHistory && AppContext.hasPlugin("fk")){
        	CommentDao commentDaoFK = (CommentDao) AppContext.getBean("commentDaoFK");
        	if(commentDaoFK != null){
        		commentAllList = commentDaoFK.findCommentByType(moduleType, moduleId, cType, fpi, other, isCount);
        	}
        }else{
        	commentAllList = commentDao.findCommentByType(moduleType, moduleId, cType, fpi, other, isCount);
        }
        
        List<Comment> comList = new ArrayList<Comment>();
        for (CtpCommentAll commentAll : commentAllList) {
            Comment comment = new Comment(commentAll);
            comList.add(comment);
        }
        if(fpi != null){
            fpi.setData(comList);
        }
        return comList;
    }
    
    public CtpCommentAll getLastComment(Long affairId)  throws BusinessException{
        String hql = " from CtpCommentAll where affairId = :affairId order by createDate desc";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("affairId", affairId);
        List<CtpCommentAll> list = DBAgent.find(hql, map);
        if(Strings.isNotEmpty(list)){
            return list.get(0);
        }
        return null;
    }
    
    @Override
    public CtpCommentAll getLastDealComment(Long affairId)  throws BusinessException{
        String hql = " from CtpCommentAll where affairId = :affairId and ctype=0 order by createDate desc";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("affairId", affairId);
        List<CtpCommentAll> list = DBAgent.find(hql, map);
        if(Strings.isNotEmpty(list)){
            return list.get(0);
        }
        return null;
    }

	@Override
	public List<Comment> findCommentsList(ModuleType moduleType, CommentType cType, Long moduleId, Long memberId) throws BusinessException {
	 	String hql = " from CtpCommentAll where moduleId = :moduleId and ctype = :ctype and moduleType = :moduleType and createId = :createId order by createDate desc";
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("moduleId", moduleId);
        map.put("ctype", cType.getKey());
        map.put("moduleType", moduleType.getKey());
        map.put("createId", memberId);
        
        @SuppressWarnings("unchecked")
		List<CtpCommentAll> list = ( List<CtpCommentAll>)DBAgent.find(hql, map);
        List<Comment> comList = new ArrayList<Comment>();
        if(Strings.isNotEmpty(list)){
        	 for (CtpCommentAll commentAll : list) {
                 Comment comment = new Comment(commentAll);
                 comList.add(comment);
             }
        }
        return comList;
	}

	public List<Comment> findComments(ModuleType moduleType, Long moduleId, FlipInfo fpi, Map<String, Object> queryParams, boolean isHistory) throws BusinessException {
		List<CtpCommentAll> commentAllList = new ArrayList<CtpCommentAll>();

		if (isHistory && AppContext.hasPlugin("fk")) {
			CommentDao commentDaoFK = (CommentDao) AppContext.getBean("commentDaoFK");
			if (commentDaoFK != null) {
				commentAllList = commentDaoFK.findComments(moduleType, moduleId, fpi, queryParams);
			}
		}
		else {
			commentAllList = commentDao.findComments(moduleType, moduleId, fpi, queryParams);
		}

		List<Comment> comList = new ArrayList<Comment>();
		for (CtpCommentAll commentAll : commentAllList) {
			Comment comment = new Comment(commentAll);
			comList.add(comment);
		}
		if (fpi != null) {
			fpi.setData(comList);
		}
		return comList;
	}
}
