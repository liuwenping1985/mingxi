package com.seeyon.apps.nbd.constant;

import com.seeyon.apps.nbd.vo.PageResourceVo;
import com.seeyon.ctp.common.authenticate.domain.User;


import java.util.*;

public final class PageResourceConstant {

    private static List<PageResourceVo> RENSHI_RESOURCE= new ArrayList<PageResourceVo>();

    static{                                                                  //人事

        RENSHI_RESOURCE.add(new PageResourceVo("rstj"));
    }
    private static List<PageResourceVo> ZICHAN_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        ZICHAN_RESOURCE.add(new PageResourceVo("zctj"));        //资产
    }
    private static List<PageResourceVo> NIANDU_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        NIANDU_RESOURCE.add(new PageResourceVo("ndgz"));        //年度
    }
    private static List<PageResourceVo> YS_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        YS_RESOURCE.add(new PageResourceVo("yszx"));            //预算
    }

    private static List<PageResourceVo> HT_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        HT_RESOURCE.add(new PageResourceVo("htgl"));        //合同
    }
    private static List<PageResourceVo> HY_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        HY_RESOURCE.add(new PageResourceVo("hyqk"));                //会议
    }
    private static Long M_LEADER_DEPT = -5750530787295213570L;                           //中心领导部门
    private static Long RENSHICHU_DEPT = 5742101819118274289L;                           //人事
    private static Long BANGPNGSHI_DEPT = 7128333900198856380L;                          //办公室
    private static Long CAIWUCHU_DEPT = -4383918711151245312L;                           //财务
    private static Long WYCZ =8728307740078393847L;                                      //物业

    private static Map<Long,Long> DEPT_USERS = new HashMap<Long, Long>();
    static {
        DEPT_USERS.put(1822038565934680648L,1L);
        DEPT_USERS.put(-6097045687008607400L,1822038565934680648L);
        DEPT_USERS.put(-8214240139807995738L,1822038565934680648L);                         //部门用户
        DEPT_USERS.put(-3876300610548250724L,1822038565934680648L);
        DEPT_USERS.put(-2011222988335790230L,1822038565934680648L);
        DEPT_USERS.put(-802149540235885363L,1822038565934680648L);
        DEPT_USERS.put(3788150910215143963L,1822038565934680648L);
        DEPT_USERS.put(-4594154039441208528L,1822038565934680648L);
        DEPT_USERS.put(5906500564404094379L,1822038565934680648L);
        DEPT_USERS.put(2273730859150231023L,1822038565934680648L);
        DEPT_USERS.put(-1426208089212501378L,1822038565934680648L);
        DEPT_USERS.put(2415256442971898934L,1822038565934680648L);
        DEPT_USERS.put(8728307740078393847L,1822038565934680648L);



    }
    private static List<PageResourceVo> ZUORIYAOQING_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        ZUORIYAOQING_RESOURCE.add(new PageResourceVo("zryq"));          //昨日邀请
    }
    private static List<PageResourceVo> HUIYI_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        HUIYI_RESOURCE.add(new PageResourceVo("huiyi"));            //会议资源
    }
    private static List<PageResourceVo> RiCheng_RESOURCE= new ArrayList<PageResourceVo>();
    static{

        HUIYI_RESOURCE.add(new PageResourceVo("richeng"));            //richeng资源
    }
    public static Collection<PageResourceVo> getMainPagePrivileges(User user){
        Set<PageResourceVo> retLst = new HashSet<PageResourceVo>();
        Long deptId = user.getDepartmentId();
        Long userId = user.getId();
        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)){
            retLst.addAll(ZUORIYAOQING_RESOURCE);
        }
        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)||DEPT_USERS.equals(userId)){
            retLst.addAll(HUIYI_RESOURCE);
        }
        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)||DEPT_USERS.equals(userId)){
            retLst.addAll(RiCheng_RESOURCE);
        }
        return retLst;

    }
    public static boolean hasZRYQPrivilege(User user){
        Long deptId = user.getDepartmentId();

        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)){
            return true;
        }
        return false;

    }
    public static boolean hasHuiYiAllPrivilege(User user){
        Long deptId = user.getDepartmentId();
        Long userId = user.getId();

        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)){
            return true;
        }
        return false;

    }
    public static boolean hasRiChenPrivilege(User user){
        Long deptId = user.getDepartmentId();
        Long userId = user.getId();

        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)||DEPT_USERS.equals(userId)){
            return true;
        }
        return false;

    }
    //,,,,,,,
    //5742101819118274289
    public static Collection<PageResourceVo> getUserReportPrivileges(User user){
        Set<PageResourceVo> retLst = new HashSet<PageResourceVo>();
        Long deptId = user.getDepartmentId();
        Long userId = user.getId();
        if(WYCZ.equals(userId)){
            retLst.addAll(ZICHAN_RESOURCE);
        }
        if(DEPT_USERS.containsKey(userId)){
            retLst.addAll(NIANDU_RESOURCE);
            retLst.addAll(YS_RESOURCE);
            retLst.addAll(HY_RESOURCE);
        }
        if(M_LEADER_DEPT.equals(deptId)||BANGPNGSHI_DEPT.equals(deptId)){
            retLst.addAll(RENSHI_RESOURCE);
            retLst.addAll(ZICHAN_RESOURCE);
            retLst.addAll(NIANDU_RESOURCE);
            retLst.addAll(YS_RESOURCE);
            retLst.addAll(HT_RESOURCE);
            retLst.addAll(HY_RESOURCE);
            return retLst;
        }
        if(RENSHICHU_DEPT.equals(deptId)){
            retLst.addAll(RENSHI_RESOURCE);
            return retLst;
        }
        if(CAIWUCHU_DEPT.equals(deptId)){
            retLst.addAll(ZICHAN_RESOURCE);
            retLst.addAll(HT_RESOURCE);
            return retLst;
        }




        return retLst;
    }



}
