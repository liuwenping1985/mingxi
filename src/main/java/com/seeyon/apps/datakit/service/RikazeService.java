package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.po.SignDataFromLogin;
import com.seeyon.ctp.organization.controller.MemberController;
import com.seeyon.ctp.organization.manager.MemberManagerImpl;
import com.seeyon.ctp.portal.customize.manager.CustomizeManager;
import com.seeyon.ctp.portal.customize.manager.CustomizeManagerImpl;
import com.seeyon.ctp.util.DBAgent;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by liuwenping on 2018/5/31.
 */
public class RikazeService {

    private static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    public static void loginRecord(Long userId,String name){
        Date dt = new Date();
        String dtStr = format.format(dt);
        List<SignDataFromLogin> dataList =  DBAgent.find("from SignDataFromLogin where userId="+userId+" and dateToken='"+dtStr+"'");
        if(CollectionUtils.isEmpty(dataList)){
            SignDataFromLogin ret = new SignDataFromLogin();
            ret.setIdIfNew();
            ret.setDataState(0);
            ret.setContent("Sign");
            ret.setDataType(0);
            ret.setDateToken(dtStr);
            ret.setLoginDate(new Date());
            ret.setLastLoginDate(ret.getLoginDate());
            ret.setUserId(userId);
            ret.setName(name);
            DBAgent.save(ret);
        }else{
            SignDataFromLogin data = dataList.get(0);
            data.setLastLoginDate(new Date());
            DBAgent.update(data);
        }
//        CustomizeManagerImpl iml;
//        MemberController con;
//        MemberManagerImpl iml;

    }

    public static List<SignDataFromLogin> getSignDataFromLoginByUserId(Long userId){
        List<SignDataFromLogin> dataList =  DBAgent.find("from SignDataFromLogin where userId="+userId);
        return dataList;
    }
    public static List<SignDataFromLogin> getSignDataFromLoginByDate(Long userId,Date date){
        String dtStr = format.format(date);
        List<SignDataFromLogin> dataList =  DBAgent.find("from SignDataFromLogin where userId="+userId+" and dateToken='"+dtStr+"'");
        return dataList;
    }
    public static List<SignDataFromLogin> getSignDataFromLoginBetweenDate(Long userId,Date stDate,Date edDate){

        DetachedCriteria query = DetachedCriteria.forClass(SignDataFromLogin.class);
        query.add(Restrictions.between("loginDate",stDate,edDate));
        query.add(Restrictions.eq("userId",userId));

        List<SignDataFromLogin>  sdflList = DBAgent.findByCriteria(query);

        return sdflList;
    }

    public static void main(String[] args){
        System.out.println(format.format(new Date()));
    }



}
