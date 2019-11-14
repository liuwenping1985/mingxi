package com.seeyon.apps.nbd.service;

import com.alibaba.fastjson.JSON;
import com.seeyon.apps.nbd.core.config.ConfigService;
import com.seeyon.apps.nbd.core.db.DataBaseHelper;
import com.seeyon.apps.duban.util.CommonUtils;
import com.seeyon.apps.nbd.po.A8ToOther;
import com.seeyon.apps.nbd.po.DataLink;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.organization.bo.V3xOrgMember;
import com.seeyon.ctp.organization.manager.OrgManager;
import com.seeyon.ctp.util.UUIDLong;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TimerTask;

import static com.seeyon.apps.nbd.core.config.ConfigService.getPropertyByName;

/**
 * Created by liuwenping on 2019/1/22.
 */
public class CustomRuianTask extends TimerTask {

    private static DataLink dl;

    private static DataLink getLink() {
        if (dl == null) {
            dl = new DataLink();
            String url = getPropertyByName("chailv_db_url", "192.168.1.98");
            String port = getPropertyByName("chailv_db_port", "3306");
            String user = getPropertyByName("chailv_db_user", "root");
            String password = getPropertyByName("chailv_db_password", "admin123!");
            String type = getPropertyByName("chailv_db_type", "0");
            String name = getPropertyByName("chailv_db_name", "v61sp22");
            dl.setUserName(user);
            dl.setPort(port);
            dl.setDataBaseName(name);
            dl.setDbType(type);
            dl.setPassword(password);
            dl.setHost(url);
        }
        return dl;


        // return dl;
    }

    private OrgManager orgManager;

    private OrgManager getOrgManager() {

        if (orgManager == null) {
            orgManager = (OrgManager) AppContext.getBean("orgManager");
        }
        return orgManager;


    }

    public void run() {
        //System的目的是不想去打开日志文件
        System.out.println("CustomRuianChailvTaskStart-IN-TEST");
        DataLink dataLink = this.getLink();
        String sql = "SELECT ID,applyuser, ApplyDate,(select BranchCode from ZDBranch where BranchInnerCode=D12BXSQ.BranchInnerCode) BranchCode,VerifyCostSum,BXLX FROM D12BXSQ WHERE PayCfm='Y' ";
        try {
            List<Map> idMapList = DataBaseHelper.executeQueryByNativeSQL("select source_id,id from a8_to_other where name='D12BXSQ'");
            if(CommonUtils.isNotEmpty(idMapList)){
                List<String> keysMap = new ArrayList<String>();
                for(Map data:idMapList){
                    keysMap.add(""+data.get("source_id"));
                }

                if(keysMap.size()>=1000){
                    List<String> subSql = new ArrayList<String>();
                    int size = 0;
                    while(size<keysMap.size()){
                        List<String> subList;
                        if(size+999<keysMap.size()){
                            subList = keysMap.subList(size,size+999);
                            size = size+999;
                        }else{
                            subList = keysMap.subList(size,keysMap.size());
                            size=keysMap.size()+99;
                        }

                        subSql.add(" ID not in ("+DataBaseHelper.join(subList,",")+") ");
                    }
                    StringBuilder stb = new StringBuilder();
                    stb.append("(");
                    stb.append(DataBaseHelper.join(subSql,"and"));
                    stb.append(")");
                    sql += " and "+stb.toString();
                }else{
                    if(keysMap.size()>0){
                        sql += " and ID not in(" + DataBaseHelper.join(keysMap, ",") + ")";
                    }
                }
            }
            System.out.println("CustomRuianChailvTaskStart-FETCH-DATA-SQL:"+sql);

            List<Map> dataMapList = DataBaseHelper.executeQueryBySQLAndLink(dataLink, sql);
            System.out.println("CustomRuianChailvTaskStart-FETCH-DATA:"+dataMapList.size());
          //  id=37, applyuser=035058, applydate=2017-10-09, branchcode=014800, verifycostsum=130.0, bxlx=CLF
            /**
             * 0002=年份（ApplyDate的年）     0003=月份（ApplyDate的月）   0007=部门编码（通过差旅系统里面的applyuser跟OA系统中的登录名匹配， 然后获取OA系统中的部门ID ）    0009=费用类型（CLF=差旅费  PXF=培训费）   0008=总金额（对应同一年份，同一月份，同一部门ID，同一费用类型的VerifyCostSum合计）
             */
            for(Map data:dataMapList){
                Object id = data.get("id");
                Object applydate = data.get("applydate");
                if(applydate==null||CommonUtils.isEmpty(applydate.toString())){
                    System.out.println("日期为空不处理:"+applydate);
                    continue;
                }
                Object applyuser = data.get("applyuser");
                if(applyuser==null||CommonUtils.isEmpty(applyuser.toString())){
                    System.out.println("用户为空不处理:"+applyuser);
                    continue;
                }
                V3xOrgMember member = this.getOrgManager().getMemberByLoginName(String.valueOf(applyuser));
                if(member == null){
                    System.out.println("用户为空不处理,找不到用户:"+applyuser);
                    continue;
                }

                String[] times = String.valueOf(applydate).split("-");
                if(times.length<2){
                    continue;

                }
                String checkSql="select * from formmain_1032 where field0002='"+times[0]+"' and field0003='"+times[1]+"'";
                //先看有没有
                List<Map> formmainDataList = DataBaseHelper.executeQueryByNativeSQL(checkSql);
                Long formmainId = UUIDLong.longUUID();
                if(CommonUtils.isEmpty(formmainDataList)){
                    //入库
                    String insertFormmain="INSERT INTO formmain_1032(ID,STATE,field0001,field0002,field0003)VALUES(?,?,?,?,?)";
                    List vals = new ArrayList();
                    vals.add(formmainId);
                    vals.add(1);
                    vals.add("CL"+times[0]+times[1]);
                    vals.add(times[0]);
                    vals.add(times[1]);
                    Integer count = DataBaseHelper.executeUpdateByNativeSQLAndLink(ConfigService.getA8DefaultDataLink(),insertFormmain,vals);

                    if(count==1){
                        System.out.println("save formmain success:::"+count);
                    }else{
                        System.out.println("save formmain failed:::"+count);
                        continue;
                    }

                }else{
                    Map masterMap  = formmainDataList.get(0);
                    formmainId = CommonUtils.getLong(masterMap.get("id"));
                }
                /**
                 *    0009=费用类型（CLF=差旅费  PXF=培训费）   0008=
                 */
                Object feeType = data.get("bxlx");
                String fType = "差旅费";
                if("PXF".equals(feeType)){
                    fType = "培训费";
                }
                String formsonSQL = "select * from formson_1033 where 1=1 and formmain_id="+formmainId+" and field0007="+member.getOrgDepartmentId()+" and field0009='"+fType+"'";

                List<Map> formsonData = DataBaseHelper.executeQueryByNativeSQL(formsonSQL);
                if(CommonUtils.isEmpty(formsonData)){
                    String insertFormson = "INSERT INTO formson_1033(id,formmain_id,field0007,field0008,field0009) values(?,?,?,?,?)";
                    List vals = new ArrayList();
                    vals.add(UUIDLong.longUUID());
                    vals.add(formmainId);
                    vals.add(member.getOrgDepartmentId());
                    vals.add(Float.parseFloat(String.valueOf(data.get("verifycostsum"))));
                    vals.add(fType);
                    Integer count = DataBaseHelper.executeUpdateByNativeSQLAndLink(ConfigService.getA8DefaultDataLink(),insertFormson,vals);
                    System.out.println("formson -saved"+count);
                }else{
                    Map sonMap = formsonData.get(0);
                    Long sonId = CommonUtils.getLong(sonMap.get("id"));
                    Object val = sonMap.get("field0008");
                    float orginal = Float.parseFloat(String.valueOf(val));
                    float sumData  = Float.parseFloat(String.valueOf(data.get("verifycostsum")));
                    String updateFormsonSQL="UPDATE formson_1033 SET field0008=? WHERE ID="+sonId;
                    List vals = new ArrayList();
                    vals.add(orginal+sumData);
                    Integer count = DataBaseHelper.executeUpdateByNativeSQLAndLink(ConfigService.getA8DefaultDataLink(),updateFormsonSQL,vals);
                    System.out.println("formson -update:"+count);
                }
            }
            for(Map data:dataMapList){
                A8ToOther a8ToOther = new A8ToOther();
                a8ToOther.setIdIfNew();
                a8ToOther.setName("D12BXSQ");
                Long sourceId = CommonUtils.getLong(data.get("id"));
                a8ToOther.setData(JSON.toJSONString(data));
                a8ToOther.setSourceId(sourceId);
                a8ToOther.saveOrUpdate();
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("GAME_OVER");

    }

    public static void main(String[] args) {
       String sql = "SELECT ID,applyuser, ApplyDate,(select BranchCode from ZDBranch where BranchInnerCode=D12BXSQ.BranchInnerCode) BranchCode,VerifyCostSum,BXLX FROM D12BXSQ WHERE PayCfm='Y'";
//       String sql="select * from D12BXSQ";
        DataLink dtLink = getLink();
        List<Map> dataMapList = DataBaseHelper.executeQueryBySQLAndLink(dtLink, sql);
        System.out.println(dataMapList);



    }
}
