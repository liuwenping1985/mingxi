package com.seeyon.apps.xinjue.service;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.po.Formmain1465;
import com.seeyon.apps.xinjue.po.Formmain1468;
import com.seeyon.apps.xinjue.vo.HaiXingParameter;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.util.DBAgent;
import com.seeyon.ctp.util.JDBCAgent;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

public class SyncThread extends TimerTask {
    private Date startDate;
    private Date endDate;
    private static final String SYNC_DATE = "modify_date";
    private static final String SYNC_SORT = "sort";
    private SimpleDateFormat format = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
    private XingjueService service;
    private EnumParameterType[] enumTyps = {
            EnumParameterType.ORG,
            EnumParameterType.BILL,
            EnumParameterType.COMMODITY,
            EnumParameterType.CUSTOM,
            EnumParameterType.WAREHOUSE
    };

    public XingjueService getService() {
        return service;
    }

    public void setService(XingjueService service) {
        this.service = service;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public void run() {

        for (EnumParameterType type : enumTyps) {

            switch (type) {
                case ORG: {
                    syncORG();
                    break;
                }
                case CUSTOM: {
                    syncCUSTOM();

                    break;
                }
                case BILL: {
                    syncBILL();

                    break;
                }
                case WAREHOUSE: {
                    syncWAREHOUSE();

                    break;
                }
                case COMMODITY: {
                    syncCOMMODITY();
                    break;
                }
            }

        }
    }

    public List syncORG() {
        //全量
        String check_field="field0001";
        try {
            List list = this.service.getData(EnumParameterType.ORG);
            if(list == null||list.size()==0){
                return null;
            }
            String sql = "from Formmain1468";
            List<Formmain1468> listData = DBAgent.find(sql);
            Map<String,Formmain1468> dataMap = new HashMap<String, Formmain1468>();
            List<Formmain1468> createList = new ArrayList<Formmain1468>();
            List<Formmain1468> updateList = new ArrayList<Formmain1468>();
            for(Formmain1468 data:listData){
                dataMap.put(data.getField0001(),data);
            }
            for(Object obj:list){
                Formmain1468 data = (Formmain1468)obj;
                Formmain1468 oldData = dataMap.get(data.getField0001());
                if(oldData == null){
                    createList.add(data);
                }else{
                    String oldkey=""+oldData.getField0002()+"|"+oldData.getField0003()+"|"+oldData.getField0004();
                    String newkey=""+data.getField0002()+"|"+data.getField0003()+"|"+data.getField0004();
                    if(!oldkey.equals(newkey)){
                        updateList.add(data);
                    }
                }

            }
            if(!createList.isEmpty()){
                DBAgent.saveAll(createList);
            }
            if(!updateList.isEmpty()){
                DBAgent.updateAll(updateList);
            }
             createList.addAll(updateList);
            return createList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List syncBILL() {
        //全量
        try {
            List list = this.service.getData(EnumParameterType.BILL);
            if(list == null||list.size()==0){
                return null;
            }
            String sql = "from Formmain1465";
            List<Formmain1465> listData = DBAgent.find(sql);
            Map<String,Formmain1465> dataMap = new HashMap<String, Formmain1465>();
            List<Formmain1465> createList = new ArrayList<Formmain1465>();
            List<Formmain1465> updateList = new ArrayList<Formmain1465>();
            for(Formmain1465 data:listData){
                dataMap.put(data.getField0001(),data);
            }
            for(Object obj:list){
                Formmain1465 data = (Formmain1465)obj;
                Formmain1465 oldData = dataMap.get(data.getField0001());
                if(oldData == null){
                    createList.add(data);
                }else{
                    if(!String.valueOf(oldData.getField0002()).equals(data.getField0002())){
                        oldData.setField0002(data.getField0002());
                        updateList.add(oldData);
                    }
                }

            }
            if(!createList.isEmpty()){
                DBAgent.saveAll(createList);
            }
            if(!updateList.isEmpty()){
                DBAgent.updateAll(updateList);
            }
            createList.addAll(updateList);
            return createList;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    //增量
    public List syncCOMMODITY() {
        return syncIncrementData(EnumParameterType.COMMODITY);
    }

    public List syncCUSTOM() {
        return syncIncrementData(EnumParameterType.CUSTOM);
    }

    public List syncWAREHOUSE() {
        return syncIncrementData(EnumParameterType.WAREHOUSE);
    }

    private List syncIncrementData(EnumParameterType type) {
        String tableName = type.getTableName();
        Integer maxSort = getMaxSortFromTable(tableName);
        HaiXingParameter parameter;
        if (maxSort != null) {
            parameter = this.service.getHaixingParameterByType(type,Long.parseLong(""+maxSort));
        }else{

            parameter = this.service.getHaixingParameterByType(type,0l);
        }
        try {
            List list = this.service.getData(type,parameter);
            if(list!=null&&list.size()!=0){
                DBAgent.saveAll(list);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;


    }
    public static Integer getMaxSortFromTable(String tableName) {
        String sql = "select max(" + SYNC_SORT + ") as max_sort from " + tableName;
        JDBCAgent agent = new JDBCAgent();

        try {
            agent.execute(sql);
            List dataList = agent.resultSetToList(true);
            if (dataList == null || dataList.size() == 0) {
                return null;
            }
            Map data = (Map) dataList.get(0);
            if (data != null) {
                Object oriSort = data.get("max_sort");
                if (oriSort instanceof Integer) {
                    return (Integer)oriSort;
                }
                String val = String.valueOf(oriSort);

                return Integer.parseInt(val);

            }
        } catch (BusinessException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                agent.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return null;
    }
    private Date getMaxDateFromTable(String tableName) {
        String sql = "select max(" + SYNC_DATE + ") as max_date from " + tableName;
        JDBCAgent agent = new JDBCAgent();

        try {
            agent.execute(sql);
            List dataList = agent.resultSetToList(true);
            if (dataList == null || dataList.size() == 0) {
                return null;
            }
            Map data = (Map) dataList.get(0);
            if (data != null) {
                Object oriDate = data.get("max_date");
                if (oriDate instanceof Date) {
                    return (Date) oriDate;
                }
                if (oriDate instanceof String) {
                    try {
                        return format.parse((String) oriDate);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                return null;
            }
        } catch (BusinessException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                agent.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return null;
    }
}
