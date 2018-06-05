package com.seeyon.apps.bulext.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.bulext.po.BulForceRead;
import com.seeyon.apps.bulext.po.BulReaderRecord;
import com.seeyon.apps.bulext.util.BulUtils;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.authenticate.domain.User;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.login.controller.MainController;
import com.seeyon.ctp.organization.bo.V3xOrgDepartment;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.v3x.bulletin.dao.BulPublishScopeDao;
import com.seeyon.v3x.bulletin.dao.BulPublishScopeDaoImpl;
import com.seeyon.v3x.bulletin.domain.BulData;
import com.seeyon.v3x.bulletin.domain.BulPublishScope;
import com.seeyon.v3x.bulletin.manager.BulDataManager;
import com.seeyon.v3x.bulletin.manager.BulDataManagerImpl;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

public class BulExtendController extends BaseController {
    /**
     *
     *
     */

    public ModelAndView recordReader(HttpServletRequest req, HttpServletResponse response){

        Map<String,Object> data = new HashMap<String,Object>();
        String bulId =  req.getParameter("bulId");
        User user = AppContext.getCurrentUser();
        List<BulReaderRecord> recordList =  DBAgent.find("from BulReaderRecord where bulId="+bulId+" and memberId="+user.getId());
        if(CollectionUtils.isEmpty(recordList)){
            BulReaderRecord record = new BulReaderRecord();
            record.setIdIfNew();
            record.setBulId(Long.parseLong(bulId));
            record.setMemberId(user.getId());
            record.setReadDate(new Date());
            DBAgent.save(record);
        }
        data.put("ok",response);
        BulUtils.responseJSON(data,response);
        return null;
    }
    public ModelAndView isReading(HttpServletRequest req, HttpServletResponse response){

        Map<String,Object> data = new HashMap<String,Object>();
        String bulId =  req.getParameter("bulId");
        BulUtils.responseJSON(data,response);
        MainController c;
        return null;
    }
    public ModelAndView getUserReadBulList(HttpServletRequest req, HttpServletResponse response){

        Map<String,Object> data = new HashMap<String,Object>();
        User user = AppContext.getCurrentUser();
        List<BulForceRead> forceReadList= DBAgent.find("from BulForceRead");
        if(CollectionUtils.isEmpty(forceReadList)){
            data.put("items", JSON.toJSONString(new ArrayList<Long>()));
        }else{
           //
            StringBuilder insql = new StringBuilder();
            int index = 0;
            for(BulForceRead read:forceReadList){
                if(index==0){
                    insql.append("(").append(read.getBulId());
                }else{
                    insql.append(",").append(read.getBulId());
                }
                index++;
            }
            insql.append(")");
            List<BulReaderRecord> recordList =  DBAgent.find("from BulReaderRecord where bulId in"+insql.toString()+" and memberId="+user.getId());
            if(!CollectionUtils.isEmpty(recordList)){
                Map<String,Long> readMap = new HashMap<String, Long>();
                for(BulReaderRecord record:recordList){
                    readMap.put(""+record.getBulId(),record.getBulId());
                }
                Iterator<BulForceRead> it = forceReadList.iterator();
                while(it.hasNext()){
                    BulForceRead br = it.next();
                   Long bulId_ =  readMap.get(br.getBulId()+"");
                   if(bulId_!=null){
                       it.remove();
                   }
                }
            }
            if(CollectionUtils.isEmpty(forceReadList)){
                data.put("items", JSON.toJSONString(new ArrayList<Long>()));
                BulUtils.responseJSON(data,response);
                return null;
            }else{
                insql = new StringBuilder();
                 index = 0;
                for(BulForceRead read:forceReadList){
                    if(index==0){
                        insql.append("(").append(read.getBulId());
                    }else{
                        insql.append(",").append(read.getBulId());
                    }
                    index++;
                }
                insql.append(")");
            }

            List<BulPublishScope> scopes =  DBAgent.find("from BulPublishScope where bulDataId in "+insql.toString());
            List<Long> bulIdList = new ArrayList<Long>();
            if(CollectionUtils.isEmpty(scopes)){
                System.out.println("not --- found");
                bulIdList.add(forceReadList.get(0).getBulId());
                data.put("items", bulIdList);
            }else{
                Map<String,Long> deptMap = new HashMap<String, Long>();
                Long accountId = user.getAccountId();
                Long userId = user.getId();
                Long departmentId = user.getDepartmentId();
                deptMap.put(String.valueOf(departmentId),departmentId);
                OrgManager manager = (OrgManager)AppContext.getBean("orgManager");
                try {
                    V3xOrgDepartment pDept =  manager.getParentDepartment(departmentId);
                    while(pDept!=null){
                        deptMap.put(String.valueOf(pDept.getId()),pDept.getId());
                        pDept =  manager.getParentDepartment(pDept.getId());
                    }
                    System.out.println("parentPath:"+deptMap);
                } catch (BusinessException e) {
                    e.printStackTrace();
                }
                for(BulPublishScope scope:scopes){
                    String userType = scope.getUserType();
                    String scopeUserId = ""+scope.getUserId();
                    Long scopeBulData = scope.getBulDataId();
                    if("Department".equals(userType)){
                        Long deptId  = deptMap.get(scopeUserId);
                        if(deptId!=null){
                            data.put("items", scopeBulData);
                            break;
                        }
                    }
                    if("Member".equals(userType)){
                        if(scopeUserId.equals(String.valueOf(userId))){
                            data.put("items", scopeBulData);
                            break;
                        }

                    }
                    if("Account".equals(userType)){
                        if(scopeUserId.equals(String.valueOf(accountId))){
                            data.put("items", scopeBulData);
                            break;
                        }
                    }
                    if("Team".equals(userType)){

                    }
                }
            }
        }
        BulUtils.responseJSON(data,response);
        return null;
    }

    public ModelAndView getForceReadBulList(HttpServletRequest req, HttpServletResponse response){

        Map<String,Object> data = new HashMap<String,Object>();
        User user = AppContext.getCurrentUser();


        BulUtils.responseJSON(data,response);
        return null;
    }


}
