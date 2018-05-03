package com.seeyon.apps.datakit.controller;

import com.seeyon.apps.datakit.dao.DataKitNanjingDao;
import com.seeyon.apps.datakit.po.*;
import com.seeyon.apps.datakit.util.DataKitSupporter;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;
import org.springframework.util.CollectionUtils;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DataKitNanjingController extends BaseController {

    private DataKitNanjingDao dataKitNanjingDao;

    public DataKitNanjingDao getDataKitNanjingDao() {
        return dataKitNanjingDao;
    }

    public void setDataKitNanjingDao(DataKitNanjingDao dataKitNanjingDao) {
        this.dataKitNanjingDao = dataKitNanjingDao;
    }
    @NeedlessCheckLogin
    public ModelAndView syncJQJX(HttpServletRequest request, HttpServletResponse response){
        List<JQJX> dataList = dataKitNanjingDao.getListByTableName("JQJX");
        if(CollectionUtils.isEmpty(dataList)){
            DataKitSupporter.responseJSON("nothing to insert",response);
            return null;
        }
        List<Formmain0246> saveList = new ArrayList<Formmain0246>();
        for(JQJX jqjx:dataList){
            Formmain0246 data = new Formmain0246();
            data.setField0001(jqjx.getJQJX01());
            data.setField0002(jqjx.getJQJX02());
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("");
            data.setStartDate(new java.util.Date());
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("");
            saveList.add(data);
        }
        try {
            System.out.println("size:"+saveList.size());
            DBAgent.saveAll(saveList);
        }catch(Exception e){
            e.printStackTrace();
        }
        DataKitSupporter.responseJSON(dataList.size(),response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView syncSPFL(HttpServletRequest request, HttpServletResponse response){
        List<SPFL> dataList = dataKitNanjingDao.getListByTableName("SPFL");
        if(CollectionUtils.isEmpty(dataList)){
            DataKitSupporter.responseJSON("nothing to insert",response);
            return null;
        }
        List<Formmain0248> saveList = new ArrayList<Formmain0248>();
        for(SPFL spfl:dataList){
            Formmain0248 data = new Formmain0248();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("");
            data.setStartDate(new java.util.Date());
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("");
            data.setField0001(String.valueOf(spfl.getSPFL03()));
            data.setField0002(spfl.getSPFL01());
            data.setField0003(spfl.getSPF_SPFL01());
            data.setField0004(spfl.getSPFL02());
            data.setField0005(String.valueOf(spfl.getSPFL04()));
            saveList.add(data);
        }
        DBAgent.saveAll(saveList);
        DataKitSupporter.responseJSON(dataList.size(),response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView syncPPB(HttpServletRequest request, HttpServletResponse response){
        List<PPB> dataList = dataKitNanjingDao.getListByTableName("PPB");
        if(CollectionUtils.isEmpty(dataList)){
            DataKitSupporter.responseJSON("nothing to insert",response);
            return null;
        }
        List<Formmain0247> saveList = new ArrayList<Formmain0247>();
        for(PPB ppb:dataList){
            Formmain0247 data = new Formmain0247();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("");
            data.setStartDate(new java.util.Date());
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("");
            data.setField0001(ppb.getPPB01());
            data.setField0002(ppb.getPPB02());
            saveList.add(data);
        }
        DBAgent.saveAll(saveList);
        DataKitSupporter.responseJSON(dataList.size(),response);
        return null;
    }
    @NeedlessCheckLogin
    public ModelAndView syncDQXX(HttpServletRequest request, HttpServletResponse response){
        List<DQXX> dataList = dataKitNanjingDao.getListByTableName("DQXX");
        if(CollectionUtils.isEmpty(dataList)){
            DataKitSupporter.responseJSON("nothing to insert",response);
            return null;
        }
        List<Formmain0250> saveList = new ArrayList<Formmain0250>();
        for(DQXX dqxx:dataList){
            Formmain0250 data = new Formmain0250();
            data.setId(UUIDLong.longUUID());
            data.setStartMemberId("");
            data.setStartDate(new java.util.Date());
            data.setApproveMemberId("0");
            data.setApproveDate(new java.util.Date());
            data.setState(1);
            data.setFinishedFlag(0);
            data.setRatifyMemberId("0");
            data.setRatifyFlag(0);
            data.setModifyDate(new Date());
            data.setModifyMemberId("");
            data.setField0001(dqxx.getDQXX02());
            data.setField0002(dqxx.getDQXX01());
            data.setField0003(dqxx.getDQX_DQXX01());
            data.setField0004(String.valueOf(dqxx.getDQXX03()));
            data.setField0005(String.valueOf(dqxx.getDQXX04()));
            saveList.add(data);
        }
        DBAgent.saveAll(saveList);
        DataKitSupporter.responseJSON(dataList.size(),response);
        return null;
    }
    /**
     * try {
     *     Class.forName("oracle.jdbc.driver.OracleDriver");
     *     String url = "jdbc:oracle:thin:@xxx.xx.xxx.xxx:1521:xxx";
     *     conn = DriverManager.getConnection(url, username, password);
     * } catch (ClassNotFoundException e) {
     *     e.printStackTrace();
     * } catch (SQLException e) {
     *     e.printStackTrace();
     * }
     */
    @NeedlessCheckLogin
    public ModelAndView ck(HttpServletRequest request, HttpServletResponse response){
        Connection conn = null;
        Statement st = null;
        try {
          Class.forName("oracle.jdbc.OracleDriver");
          String url = "jdbc:oracle:thin:@//192.168.20.12:1521/scmorcl";
          conn = DriverManager.getConnection(url, "hyscm", "begin1");
         st =  conn.createStatement();
        ResultSet set =  st.executeQuery("select count(*) from DQXX");
        System.out.println("count:"+set.getInt(1));
        set.close();
    } catch (ClassNotFoundException e) {
          e.printStackTrace();
     } catch (SQLException e) {
          e.printStackTrace();
      }finally {
            if(st!=null){
                try {
                    st.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if(conn!=null){
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        DataKitSupporter.responseJSON("CHECK",response);
        return null;
    }
}
