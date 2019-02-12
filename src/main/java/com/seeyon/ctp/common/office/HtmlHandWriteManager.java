package com.seeyon.ctp.common.office;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import DBstep.iMsgServer2000;

import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.i18n.ResourceBundleUtil;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Datetimes;
import com.seeyon.ctp.util.Strings;
import com.seeyon.v3x.system.signet.dao.HtmlSignatureHistoryDao;
import com.seeyon.v3x.system.signet.domain.V3xHtmDocumentSignature;
import com.seeyon.v3x.system.signet.domain.V3xHtmlSignatureHistory;
import com.seeyon.v3x.system.signet.enums.V3xHtmSignatureEnum;
import com.seeyon.v3x.system.signet.manager.V3xHtmDocumentSignatManager;

public class HtmlHandWriteManager {

    private static String                             rc            = "com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources";

    //private static Map<String,UserUpdateObject> useObjectList=new Hashtable<String,UserUpdateObject>();
    private final static CacheAccessable              cacheFactory  = CacheFactory
                                                                            .getInstance(HtmlHandWriteManager.class); 
    private static CacheMap<String, UserUpdateObject> useObjectList = cacheFactory.createMap("_HtmlHandWriteManager_useObjectList");

    private V3xHtmDocumentSignatManager                        htmSignetManager;
    private HtmlSignatureHistoryDao                           signHistoryDao;

    private static Log   log           = LogFactory.getLog(HtmlHandWriteManager.class);

    private  OnlineManager                      onlineManager;

    private  OrgManager                         orgManager;

    private synchronized void init() {

        /*		if(onLineManager == null){
        			orgManager = (OrgManager) ApplicationContextHolder.getBean("OrgManager");
        			onLineManager = (OnLineManager)ApplicationContextHolder.getBean("onLineManager");
        		}*/

    }

    public HtmlHandWriteManager() {
        init();
    }

    public void setOnlineManager(OnlineManager onLineManager) {
		this.onlineManager = onLineManager;
	}
    
    public void setHtmSignetManager(V3xHtmDocumentSignatManager htmSignetManager) {
        this.htmSignetManager = htmSignetManager;
    }
    
    public V3xHtmDocumentSignatManager getHtmSignetManager() {
        return htmSignetManager;
    }

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}

    public HtmlSignatureHistoryDao getSignHistoryDao() {
        return this.signHistoryDao;
    }

    public void setSignHistoryDao(HtmlSignatureHistoryDao signHistoryDao) {
        this.signHistoryDao = signHistoryDao;
    }

    public boolean loadDocumentSinature(iMsgServer2000 msgObj) throws BusinessException {
        List<V3xHtmDocumentSignature> dsList = null;
        V3xHtmDocumentSignature ds = new V3xHtmDocumentSignature();
        ds.setSummaryId(Long.parseLong(msgObj.GetMsgByName("RECORDID")));//取得文档编号
        ds.setFieldName(msgObj.GetMsgByName("FIELDNAME"));//取得签章字段名称
        ds.setUserName(msgObj.GetMsgByName("USERNAME"));//取得用户名称
        String _isNewImg=(String)msgObj.GetMsgByName("isNewImg");
        boolean isNewImg=false;
        if(Strings.isNotBlank(_isNewImg)){
        	isNewImg=Boolean.valueOf(_isNewImg);
        }
        if(isNewImg){//文单签批
        	String affairIdStr=msgObj.GetMsgByName("AFFAIRID");
        	Long affairId=null;
        	if(Strings.isNotBlank(affairIdStr)&&!"null".equals(affairIdStr)){
        		affairId=Long.valueOf(affairIdStr);//设置affairId
        	}
        	
        	String affairMemberId=msgObj.GetMsgByName("affairMemberId");
        	String affairMemberName=msgObj.GetMsgByName("affairMemberName");
        	msgObj.MsgTextClear(); //清除SetMsgByName设置的值     
			msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
			msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空
			
        	dsList = htmSignetManager.findBySummaryIdPolicyAndType(ds.getSummaryId(), ds.getFieldName(), 
        	        V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
        	if (dsList != null && dsList.size() > 0) {
    			if(dsList.size()==1&&dsList.get(0).getAffairId()==null){//老数据没有affairId数据直接载入
    				msgObj.SetMsgByName("FIELDVALUE", dsList.get(0).getFieldValue()); //设置签章数据
    				msgObj.SetMsgByName("STATUS", "调入成功!"); //设置状态信息
    				msgObj.MsgError(""); //清除错误信息
    			}else{
    				for(V3xHtmDocumentSignature s:dsList){
    					if(s.getAffairId()!=null&&s.getAffairId().equals(affairId)){ 
    						msgObj.SetMsgByName("FIELDVALUE", s.getFieldValue()); //设置签章数据
    						msgObj.SetMsgByName("STATUS", "调入成功!"); //设置状态信息
    						msgObj.MsgError(""); //清除错误信息
    					}
    				}
    			}
    		} else {
    			msgObj.MsgError("load err!"); //设置错误信息
    		}
        }else{//表单签批
        	
        	String affairMemberId=msgObj.GetMsgByName("affairMemberId");
        	String affairMemberName=msgObj.GetMsgByName("affairMemberName");
        	msgObj.MsgTextClear(); //清除SetMsgByName设置的值     
			msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
			msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空
			
        	dsList = htmSignetManager.findBySummaryIdPolicyAndType(ds.getSummaryId(),ds.getFieldName(), 
                        V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
            if(dsList!=null && dsList.size()>0){
            	ds=dsList.get(0);
            	msgObj.SetMsgByName("FIELDVALUE",ds.getFieldValue());  	//设置签章数据
            	msgObj.SetMsgByName("STATUS","调入成功!");  	//设置状态信息
            	msgObj.MsgError("");				//清除错误信息
            }else{
            	msgObj.MsgError("load err!");		        //设置错误信息
            }
        }
        return true;
    }

    public boolean saveSignatureHistory(iMsgServer2000 msgObj) throws BusinessException {
        V3xHtmlSignatureHistory sh = new V3xHtmlSignatureHistory();
        sh.setIdIfNew();
        sh.setSummaryId(Long.valueOf(msgObj.GetMsgByName("RECORDID")));//取得文档编号
        sh.setFieldName(msgObj.GetMsgByName("FIELDNAME"));//取得签章字段名称
        sh.setUserName(msgObj.GetMsgByName("USERNAME")); //取得用户名称
        sh.setDateTime(new Timestamp(System.currentTimeMillis())); //取得签章日期时间
        sh.setHostName(msgObj.GetMsgByName("CLIENTIP")); //取得客户端IP
        sh.setMarkGuid(msgObj.GetMsgByName("MARKGUID")); //取得序列号
        
        String affairMemberId=msgObj.GetMsgByName("affairMemberId");
        boolean isProxy=isProxy(msgObj,affairMemberId);//是不是代理人 
        String markName=msgObj.GetMsgByName("MARKNAME");
        //如果是代理人签批的，在保存历史记录的时候，把增加签章名称的代理人信息去掉
        if(Strings.isNotBlank(markName)&&isProxy&&markName.lastIndexOf("[")!=-1){
        	markName=markName.substring(0,markName.lastIndexOf("["));
        }
        sh.setMarkName(markName);//取得签章名称
    	String affairMemberName=msgObj.GetMsgByName("affairMemberName");
    	msgObj.MsgTextClear(); //清除SetMsgByName设置的值     
		msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
		msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空

        try {
            signHistoryDao.save(sh); //保存印章历史信息
        } catch (Exception e) {
            msgObj.MsgError("saveerr!"); //设置错误信息
            return false;
        }
        msgObj.SetMsgByName("MARKNAME", sh.getMarkName()); //将签章名称列表打包
        msgObj.SetMsgByName("USERNAME", sh.getUserName()); //将用户名列表打包
        msgObj.SetMsgByName("DATETIME", Datetimes.formatDatetime(sh.getDateTime())); //将签章日期列表打包
        msgObj.SetMsgByName("HOSTNAME", sh.getHostName()); //将客户端IP列表打包
        msgObj.SetMsgByName("MARKGUID", sh.getMarkGuid()); //将序列号列表打包
        msgObj.SetMsgByName("STATUS", "save ok!"); //设置状态信息
        msgObj.MsgError(""); //清除错误信息

        return true;
    }

    public boolean getSignatureHistory(iMsgServer2000 msgObj) throws BusinessException {
        V3xHtmlSignatureHistory dh = new V3xHtmlSignatureHistory();

        dh.setSummaryId(Long.valueOf(msgObj.GetMsgByName("RECORDID"))); //取得文档编号
        dh.setFieldName(msgObj.GetMsgByName("FIELDNAME")); //取得签章字段名称
        dh.setUserName(msgObj.GetMsgByName("USERNAME")); //取得用户名
        String affairMemberId=msgObj.GetMsgByName("affairMemberId");
    	String affairMemberName=msgObj.GetMsgByName("affairMemberName");
    	msgObj.MsgTextClear(); //清除SetMsgByName设置的值     
		msgObj.SetMsgByName("affairMemberId",affairMemberId);//当前待办所属人员信息不能被清空
		msgObj.SetMsgByName("affairMemberName",affairMemberName);//当前待办所属人员信息不能被清空

        dh = combStr(signHistoryDao.findByIdAndPolicy(dh.getSummaryId(), dh.getFieldName()));

        if (dh != null) //调入印章历史信息
        {
            msgObj.SetMsgByName("MARKNAME", dh.getMarkName()); //将签章名称列表打包
            msgObj.SetMsgByName("USERNAME", dh.getUserName()); //将用户名列表打包
            msgObj.SetMsgByName("DATETIME", dh.getDateTimeStr()); //将签章日期列表打包
            msgObj.SetMsgByName("HOSTNAME", dh.getHostName()); //将客户端IP列表打包
            msgObj.SetMsgByName("MARKGUID", dh.getMarkGuid()); //将序列号列表打包
            msgObj.SetMsgByName("STATUS", "load ok"); //设置状态信息
            msgObj.MsgError(""); //清除错误信息
        } else {
            msgObj.SetMsgByName("STATUS", "load false"); //设置状态信息
            msgObj.MsgError("load fale"); //设置错误信息
        }
        return true;
    }

    /**
     * 查询到的签章记录转变成控件要求格式
     * @param ls
     * @return
     */

    private V3xHtmlSignatureHistory combStr(List<V3xHtmlSignatureHistory> ls) {
        V3xHtmlSignatureHistory temp, dh = new V3xHtmlSignatureHistory();
        dh.setMarkName(ResourceBundleUtil.getString(rc, "ocx.signname.label") + "\r\n");
        dh.setUserName(ResourceBundleUtil.getString(rc, "ocx.signuser.label") + "\r\n");
        dh.setHostName(ResourceBundleUtil.getString(rc, "ocx.clientip.label") + "\r\n");
        dh.setDateTimeStr(ResourceBundleUtil.getString(rc, "ocx.signtime.label") + "\r\n");
        dh.setMarkGuid(ResourceBundleUtil.getString(rc, "ocx.serialnumber.label") + "\r\n");
        int i, len = ls.size();

        for (i = 0; i < len; i++) {
            temp = ls.get(i);
            dh.setMarkName(dh.getMarkName() + temp.getMarkName() + "\r\n");
            dh.setUserName(dh.getUserName() + temp.getUserName() + "\r\n");
            dh.setHostName(dh.getHostName() + temp.getHostName() + "\r\n");
            dh.setDateTimeStr(dh.getDateTimeStr() + Datetimes.formatDatetime(temp.getDateTime()) + "\r\n");
            dh.setMarkGuid(dh.getMarkGuid() + temp.getMarkGuid() + "\r\n");
        }
        return dh;
    }

    public boolean saveSignature(iMsgServer2000 msgObj) throws BusinessException {
        V3xHtmDocumentSignature hd = new V3xHtmDocumentSignature();
        String clientVer = msgObj.GetMsgByName("Version");
        clientVer = clientVer.replace('.', ',');
        if (msgObj.Version().equals(clientVer)) {
            msgObj.MsgError("ver err");
            msgObj.MsgTextClear();
            msgObj.MsgFileClear();
            return false;
        }
        boolean isUpdate = false;
        Long summaryId = Long.valueOf(msgObj.GetMsgByName("RECORDID"));
        String policy = msgObj.GetMsgByName("FIELDNAME");
        String _isNewImg=(String)msgObj.GetMsgByName("isNewImg");
        boolean isNewImg=false;
        if(Strings.isNotBlank(_isNewImg)){
        	isNewImg=Boolean.valueOf(_isNewImg);
        }
        if(isNewImg){
        	String affairIdStr=msgObj.GetMsgByName("AFFAIRID");
        	Long affairId=null;
        	if(affairIdStr!=null&&!"".equals(affairIdStr) && !"null".equals(affairIdStr)){
        		affairId=Long.valueOf(affairIdStr);//设置affairId
        	}
        	List<V3xHtmDocumentSignature> hsList = htmSignetManager.findBySummaryIdPolicyAndType(summaryId, policy, 
        	        V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
        	//如果列表中已经有该节点的签章数据，则说明改节点是更新操作
        	for(V3xHtmDocumentSignature s:hsList){
        		if((s.getAffairId() != null && s.getAffairId().equals(affairId))
        				||(s.getAffairId()== null && s.getFieldName().equals(policy))){
        			hd=s;
        			isUpdate=true;
        			break;
        		}
        	}
        	hd.setIdIfNew();
        	hd.setAffairId(affairId);//设置affairId
        }else{
            List<V3xHtmDocumentSignature> hsList = htmSignetManager.findBySummaryIdPolicyAndType(summaryId, policy, 
                    V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
             if(hsList!=null && hsList.size()>0)
             {
             	hd=hsList.get(0);
             	isUpdate=true;
             }
             hd.setIdIfNew();
        }
        
        hd.setSummaryId(summaryId);//取得文档编号
        hd.setFieldName(policy);//取得签章字段名称
        hd.setFieldValue(msgObj.GetMsgByName("FIELDVALUE"));//取得签章数据内容
        
        String affairMemberId=msgObj.GetMsgByName("affairMemberId");
        String userName=msgObj.GetMsgByName("USERNAME");//取得用户名称
        boolean isProxy=isProxy(msgObj,affairMemberId);//是不是代理人 
        if(isProxy){//如果是代理保存为：代理人（代理XX）
        	userName=userName+"(代理"+msgObj.GetMsgByName("affairMemberName")+")";
        }
        hd.setUserName(userName);
        
        hd.setDateTime(new Timestamp(System.currentTimeMillis()));//取得签章日期时间
        hd.setHostName(msgObj.GetMsgByName("CLIENTIP"));//取得客户端IP
        
        try {
            if (isUpdate) {
                htmSignetManager.update(hd);
            } else {
                htmSignetManager.save(hd);
            }
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
        return isUpdate;
    }
    
    private boolean isProxy(iMsgServer2000 msgObj,String affairMemberId){
    	boolean isProxy=false;
    	//代理的时候，当前登录人的id和affairMemberId不相等
		if(Strings.isNotBlank(affairMemberId)&&!affairMemberId.equals(AppContext.currentUserId()+"")){
			isProxy=true;
		}
    	return isProxy;
    }

    //读取文单签章，转换成js
    public String getHandWritesJs(Long summaryId, String userName, List<String> opinionNames) {
        StringBuilder sb = new StringBuilder("<Script language='JavaScript'>");
        int i, len;
        List<V3xHtmDocumentSignature> ls = htmSignetManager.findBySummaryIdAndType(summaryId, V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
        V3xHtmDocumentSignature ds = null;
        len = ls.size();

        sb.append("hwObjs=new Array();\r\n");
        for (i = 0; i < len; i++) {
            ds = ls.get(i);
            sb.append("hwObjs[").append(i).append("]=new hwObj('").append(summaryId).append("','").append(
                    ds.getFieldName()).append("','").append(userName).append("','").append(ds.getDateTime().getTime())
                    .append("','").append(ds.getAffairId()== null ? "":ds.getAffairId())
                    .append("');\r\n");
        }
        sb.append("</Script>\r\n");
        if (opinionNames.contains("otherOpinion") == false) {
            opinionNames.add("otherOpinion");
        }
        for (i = 0; i < opinionNames.size(); i++) {
            sb.append(getHandWriteEventJs("hw" + opinionNames.get(i)));
        }
        return sb.toString();

    }

    /**
     * 根据 summmaryId 得到回复该公文签章
     * @param summaryId
     * @return
     */
    public List<V3xHtmDocumentSignature> getHandWrites(Long summaryId) {
        if (summaryId != null) {
            return htmSignetManager.findBySummaryIdAndType(summaryId, V3xHtmSignatureEnum.HTML_SIGNATURE_DOCUMENT.getKey());
        } else {
            return null;
        }
    }
    // 研发 START
    public List<V3xHtmDocumentSignature> getHandWrites(Long summaryId,int type) {
        if (summaryId != null) {
            return htmSignetManager.findBySummaryIdAndType(summaryId, type);
        } else {
            return null;
        }
    }
    // END
    private String getHandWriteEventJs(String hwName) {
        StringBuilder hjen = new StringBuilder();
        hjen.append("<SCRIPT language=javascript for='").append(hwName).append(
                "' event=OnMenuClick(vIndex,vCaption)>\r\n");
        hjen.append("OnMenuHdClick(this,vIndex,vCaption);\r\n");
        hjen.append("</SCRIPT>\r\n");
        return hjen.toString();
    }

    //修改对象,放入对象修改列表
    public synchronized UserUpdateObject editObjectState(String objId) {
        if (objId == null || "".equals(objId)) {
            return null;
        }
        User user = AppContext.getCurrentUser();
        UserUpdateObject os = null;
        os = useObjectList.get(objId);
        if (os == null) {//无人修改
            os = new UserUpdateObject();
            try {
               /* String[] temp = objId.split("___");
                List<V3xHtmDocumentSignature> dsList = htmlSignDao.findByIdAndPolicy(Long.valueOf(temp[0]), temp[1]);
                if (dsList != null && dsList.size() > 0) {
                    os.setLastUpdateTime(dsList.get(0).getDateTime());
                } else {
                    os.setLastUpdateTime(null);
                    os.setCurEditState(false);
                }*/
            	os.setLastUpdateTime(user.getLoginTimestamp());
                os.setCurEditState(false);
                os.setObjId(objId);
                os.setUserId(user.getId());
                os.setUserName(user.getName());
                addUpdateObj(os);
            } catch (Exception e) {
                log.error("", e);
            }
        } else {
            //			有用户修改时，要判断用户是否在线,如果用户不在线，删除修改状态
            boolean editUserOnline = true;
            V3xOrgMember member = null; //当前office控件编辑用户
            try {
                member = orgManager.getEntityById(V3xOrgMember.class, os.getUserId());
                
                boolean isSameLogin  = onlineManager.isSameLogin(member.getLoginName(), os.getLastUpdateTime()) ;
                
                editUserOnline = onlineManager.isOnline(member.getLoginName()) && isSameLogin;
                
            } catch (Exception e1) {
                log.warn("检查文档是否被编辑，文档编辑用户不存在[" + os.getUserId() + "]", e1);
            }
            if (editUserOnline && !os.getUserId().equals(user.getId()) ) {
                os.setCurEditState(true);
            } else {
                //编辑用户已经离线，修改文档编辑人为当前用户
                os.setUserId(user.getId());
                os.setCurEditState(false);
            	os.setLastUpdateTime(user.getLoginTimestamp());
            }
        }
        return os;
    }

    //检查对象是否被修改
    public synchronized UserUpdateObject checkObjectState(String objId) {
        UserUpdateObject os = null;
        os = useObjectList.get(objId);
        if (os == null) {
            os = new UserUpdateObject();
        }
        return os;
    }

    public synchronized boolean deleteUpdateObj(String objId, Long userId) {

        UserUpdateObject os = null;
        os = useObjectList.get(objId);
        if (os == null || userId == null) {
            return true;
        }
        if (userId.equals(os.getUserId())) {
            useObjectList.remove(objId);
            //发送集群通知
            NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectRomoveHtml, new Object[]{objId,userId});
        }
        return true;
    }

    public synchronized boolean deleteUpdateObj(String objId) {

        User user = AppContext.getCurrentUser();
        if (user == null)
            return true;
        Long userId = user.getId();
        return deleteUpdateObj(objId, userId);

    }

    public synchronized boolean addUpdateObj(UserUpdateObject uo) {
        useObjectList.put(uo.getObjId(), uo);
        //		发送集群通知
        NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectAddHtml, uo);
        return true;
    }

    public static Map<String, UserUpdateObject> getUseObjectList() {
        return useObjectList.toMap();
    }

    public static void setUseObjectList(Map<String, UserUpdateObject> uo) {
        useObjectList.replaceAll(uo);
    }

	public V3xHtmDocumentSignature getByAffairId(Long oldAffairId) {
	    return htmSignetManager.getByAffairId(oldAffairId);
	}

	public void update(V3xHtmDocumentSignature htmSignate) {
	    htmSignetManager.update(htmSignate);
	}
    

}
