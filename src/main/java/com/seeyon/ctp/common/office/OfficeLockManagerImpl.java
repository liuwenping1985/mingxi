package com.seeyon.ctp.common.office;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.seeyon.ctp.cluster.notification.NotificationManager;
import com.seeyon.ctp.cluster.notification.NotificationType;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.cache.CacheAccessable;
import com.seeyon.ctp.common.cache.CacheFactory;
import com.seeyon.ctp.common.cache.CacheMap;
import com.seeyon.ctp.common.constants.Constants;
import com.seeyon.ctp.login.online.OnlineManager;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.Strings;

public class OfficeLockManagerImpl implements OfficeLockManager{
	private static Log  LOGGER    = LogFactory.getLog(OfficeLockManagerImpl.class);
	private final static CacheAccessable cacheFactory  = CacheFactory.getInstance(HtmlHandWriteManager.class);
	private static CacheMap<String, OfficeLockObject> useObjectList = cacheFactory.createMap("officeLock");
	
	private  OnlineManager   onlineManager;
	private  OrgManager      orgManager;

	public void setOnlineManager(OnlineManager onLineManager) {
		this.onlineManager = onLineManager;
	}

	public void setOrgManager(OrgManager orgManager) {
		this.orgManager = orgManager;
	}
	
	//修改对象,放入对象修改列表
	@Override
    public synchronized OfficeLockObject lock(String objId) {
		
		String from = Constants.login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
		
        if (objId == null || "".equals(objId)) {
            return null;
        }
        User user = AppContext.getCurrentUser();
        OfficeLockObject os = null;
        os = useObjectList.get(objId);
        if (os == null) {//无人修改
            os = new OfficeLockObject();
            try {
            	os.setLastUpdateTime(user.getLoginTimestamp());
                os.setCurEditState(false);
                os.setObjId(objId);
                os.setUserId(user.getId());
                os.setUserName(user.getName());
                os.setFrom(from);
                addUpdateObj(os);
            } catch (Exception e) {
                LOGGER.error("", e);
            }
        } else {
        	
            //有用户修改时，要判断用户是否在线,如果用户不在线，删除修改状态
            boolean editUserOnline = true;
            V3xOrgMember member = null; //当前office控件编辑用户
            try {
                member = orgManager.getEntityById(V3xOrgMember.class, os.getUserId());
                
                boolean isSameLogin  = onlineManager.isSameLogin(member.getLoginName(), os.getLastUpdateTime()) ;
                
                editUserOnline = onlineManager.isOnline(member.getLoginName()) && isSameLogin;
                
            } catch (Exception e1) {
            	LOGGER.warn("检查文档是否被编辑，文档编辑用户不存在[" + os.getUserId() + "]", e1);
            }
            boolean isOne = os.getUserId().equals(user.getId());
            boolean  isSameClient =  Strings.equals(from, os.getFrom());
            
            if (editUserOnline && (!os.getUserId().equals(user.getId()) || (isOne && !isSameClient ))) {  
            	//在线，不是一个人或者是一个人但是不同端的时候不能获取锁
                os.setCurEditState(true);
            } else {
                //编辑用户已经离线，修改文档编辑人为当前用户
                os.setUserId(user.getId());
                os.setUserName(user.getName());
                os.setCurEditState(false);
            	os.setLastUpdateTime(user.getLoginTimestamp());
            }
        }
        return os;
    }

    //检查对象是否被修改
    @Override
    public synchronized OfficeLockObject getLock(String objId) {
    	OfficeLockObject os = null;
        os = useObjectList.get(objId);
        if (os == null) {
            os = new OfficeLockObject();
        }
        return os;
    }
    
    @Override
    public synchronized boolean unlock(String objId, Long userId) {

    	OfficeLockObject os = null;
        os = useObjectList.get(objId);
        if (os == null || userId == null) {
            return true;
        }
        String from = Constants.login_sign.stringValueOf(AppContext.getCurrentUser().getLoginSign());
        if (userId.equals(os.getUserId())  && Strings.isNotBlank(from) && from.equals(os.getFrom())) {
            useObjectList.remove(objId);
            //发送集群通知
            NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectRomoveHtml, new Object[]{objId,userId});
        }
        return true;
    }

    public synchronized boolean unlock(String objId) {

        User user = AppContext.getCurrentUser();
        if (user == null)
            return true;
        Long userId = user.getId();
        
        return unlock(objId, userId);
    }
    
    @Override
    public  boolean unlockAll(Long recordId) {

        User user = AppContext.getCurrentUser();
        if (user == null){
            return true;
        }
        if(null==recordId){
        	return true;
        }
        String recordIdString = String.valueOf(recordId);
        List<String> objIds = new ArrayList<String>();
	       for(String objId:useObjectList.keySet()){
	    	   if(objId.startsWith(recordIdString)){
	    		   objIds.add(objId);
	    	   }
	       }
		return useObjectList.removeAll(objIds);
    }

    public synchronized boolean addUpdateObj(OfficeLockObject uo) {
        useObjectList.put(uo.getObjId(), uo);
        
        //发送集群通知
        NotificationManager.getInstance().send(NotificationType.EdocUserOfficeObjectAddHtml, uo);
        return true;
    }

    public static Map<String, OfficeLockObject> getUseObjectList() {
        return useObjectList.toMap();
    }

    public static void setUseObjectList(Map<String, OfficeLockObject> uo) {
        useObjectList.replaceAll(uo);
    }
}
