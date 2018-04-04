
package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.dao.DataKitDao;
import com.seeyon.apps.datakit.po.BusGetAmountData;
import com.seeyon.apps.datakit.po.DepartmentDataObject;
import com.seeyon.apps.datakit.po.Formmain0230Data;
import com.seeyon.apps.datakit.po.OriginalDataObject;
import com.seeyon.apps.datakit.vo.ScheduleTread;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.ctpenumnew.dao.EnumDAO;
import com.seeyon.ctp.common.ctpenumnew.dao.EnumItemDAO;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManager;
import com.seeyon.ctp.common.ctpenumnew.manager.EnumManagerImpl;
import com.seeyon.ctp.common.exceptions.BusinessException;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnum;
import com.seeyon.ctp.common.po.ctpenumnew.CtpEnumItem;
import com.seeyon.ctp.util.DBAgent;

import java.util.*;

import org.apache.commons.lang.StringUtils;
import org.springframework.util.CollectionUtils;

public class DataKitService {

    private DataKitDao dataKitDao;
    private EnumDAO newEnumDAO;
    private EnumItemDAO newEnumItemDAO;
    private EnumManager enumManagerNew;
    private Long rootEnumId = -4002724650540972121L;
    private Long orgAccountId = -5511286172445225726L;
    private Long metaId = -4002724650540972121L;

    private boolean isStop = false;

    public boolean isStop() {
        return isStop;
    }

    public void setStop(boolean stop) {
        isStop = stop;
    }

    public DataKitService() {
        ScheduleTread scheduleTread = new ScheduleTread();
        scheduleTread.setDataKitService(this);
        scheduleTread.schedule();
    }

    public boolean refresh(){
        try {
            Object enumManagerNew = AppContext.getBean("enumManagerNew");
            if (enumManagerNew instanceof EnumManagerImpl) {
                ((EnumManagerImpl)enumManagerNew).init();
                ((EnumManagerImpl)enumManagerNew).init();
                return true;
            }
        } catch (Exception var8) {
            var8.printStackTrace();
        }
        return false;
    }

    public List<OriginalDataObject> getSourceList() {
        return this.dataKitDao.getOriginalDataList();
    }
    public List<OriginalDataObject> getAllSourceList() {
        return this.dataKitDao.getAllOriginalDataList();
    }

    public CtpEnum getRootEnum() throws BusinessException {
        return this.newEnumDAO.selectById(this.rootEnumId);
    }

    public List<CtpEnumItem> getAllCtpEnumItemList(){
        try {
            List<CtpEnumItem> allItems =  newEnumItemDAO.findAll();
            return allItems;
        } catch (BusinessException e) {
            e.printStackTrace();
        }
        return new ArrayList<CtpEnumItem>();
    }
    public void autoSync(){
        if(isStop){
            return;
        }
        this.syncFromOutside();
        this.syncFromOutsideBudge();
    }

    public Map syncFromOutside(){
        Map retData = new HashMap();
        List<OriginalDataObject> dataList = dataKitDao.getOriginalDataList();
        if(CollectionUtils.isEmpty(dataList)){
            retData.put("信息","没有数据需要更新");
            return retData;
        }
        List<CtpEnumItem> items = getAllCtpEnumItemList();
        Map<String,CtpEnumItem> itemValueMap = new HashMap<String, CtpEnumItem>();
        Map<String,CtpEnumItem> itemOriginalIdMap = new HashMap<String, CtpEnumItem>();
        initDataMap(items,itemValueMap,itemOriginalIdMap);
        List<OriginalDataObject> updateDataList = new ArrayList<OriginalDataObject>();
        List<CtpEnumItem> updateItemList = new ArrayList<CtpEnumItem>();
        List<CtpEnumItem> addItemList = new ArrayList<CtpEnumItem>();
        //transNew
        for(OriginalDataObject data:dataList){
            if("Y".equals(data.getUpdateStatus())){
                updateDataList.add(data);
            }else{
                addItemList.add(transNew(data));
            }
            data.setSyncStatus("Y");
            data.setUpdateStatus("N");
        }
        //先处理新增加的
        if(!CollectionUtils.isEmpty(addItemList)){
            initDataMap(addItemList,itemValueMap,itemOriginalIdMap);
            Iterator<CtpEnumItem> it = addItemList.iterator();
            while(it.hasNext()) {
                CtpEnumItem item = it.next();
                String pid = "" + item.getExtraAttr("original-pid");
                CtpEnumItem pid_ = itemOriginalIdMap.get(pid);
                if (pid_ != null) {
                    item.setParentId(pid_.getId());
                }else{
                    item.setParentId(0L);
                }
            }
            DBAgent.saveAll(addItemList);
        }

        if(!CollectionUtils.isEmpty(updateDataList)){
            for(OriginalDataObject data:updateDataList){
                CtpEnumItem item = itemValueMap.get(data.getNo());
                if(item == null){
                    item =   itemOriginalIdMap.get(data.getId());
                }
                if(item == null){
                    continue;
                }
                String pid = "" + item.getExtraAttr("original-pid");
                CtpEnumItem pid_ = itemOriginalIdMap.get(pid);
                if (pid_ != null) {
                    item.setParentId(pid_.getId());
                }else{
                    item.setParentId(0L);
                }
                updateItemList.add(item);
            }
            DBAgent.updateAll(updateItemList);
        }
        retData.put("新增:",addItemList);
        retData.put("更新:",updateItemList);
        this.saveSourceList(dataList);
        return retData;
    }
    private void initDataMap(List<CtpEnumItem> items,Map<String,CtpEnumItem> itemValueMap,Map<String,CtpEnumItem> itemOriginalIdMap){
        for(CtpEnumItem enumItem:items){
            String value = enumItem.getEnumvalue();
            if(!org.springframework.util.StringUtils.isEmpty(value)&&rootEnumId.equals(enumItem.getRefEnumid())){
                Object id = enumItem.getExtraAttr("original-id");
                if(id!=null){
                    itemOriginalIdMap.put(String.valueOf(id),enumItem);
                }
                itemValueMap.put(enumItem.getEnumvalue(),enumItem);
            }
        }
    }
    public Map syncFromOutsideBudge(){
        Map retData = new HashMap();
        List<BusGetAmountData> busgetList = dataKitDao.getBusGetAmountData();
        if(CollectionUtils.isEmpty(busgetList)){
            return retData;
        }
        List<DepartmentDataObject> departmentDataObjectList = dataKitDao.getDepartmentData();
        List<CtpEnumItem> items = getAllCtpEnumItemList();
        Map<String,CtpEnumItem> itemMap = new HashMap<String, CtpEnumItem>();
        for(CtpEnumItem item:items){
            itemMap.put(item.getEnumvalue(),item);
        }
        Map<String,DepartmentDataObject> deptMap = new HashMap<String, DepartmentDataObject>();
        for(DepartmentDataObject dept:departmentDataObjectList){
            String ysId = dept.getYsId();
            if(org.springframework.util.StringUtils.isEmpty(ysId)){
                continue;
            }
            deptMap.put(dept.getYsId(),dept);
        }
        List<Formmain0230Data>datalistall = new ArrayList<Formmain0230Data>();
        for (BusGetAmountData data:busgetList){
            Formmain0230Data formData = new Formmain0230Data();
            formData.setIdIfNew();
            String accountId = data.getAccountId();
            String deptId = data.getDepartmentId();
            if(StringUtils.isEmpty(accountId)||StringUtils.isEmpty(deptId)){
                continue;
            }
            formData.setStartMemberId("-1578261713210163012");
            formData.setStartDate(new Date());
            formData.setApproveMemberId("0");
            formData.setApproveDate(new Date());
            formData.setState(1);
            formData.setFinishedFlag(0);
            formData.setRatifyMemberId("0");
            formData.setRatifyFlag(0);
            formData.setModifyDate(new Date());
            formData.setModifyMemberId("-1578261713210163012");
            formData.setField0001(Integer.parseInt(data.getYear())+0d);
            formData.setField0002(Integer.parseInt(data.getMonth())+0d);
            CtpEnumItem item = itemMap.get(data.getItemNo());
            if(item == null){
                continue;
            }
            formData.setField0003(String.valueOf(item.getId()));
            formData.setField0008(Double.parseDouble(data.getAmount()));
            DepartmentDataObject account =  deptMap.get(data.getAccountId());
            if(account==null||StringUtils.isEmpty(account.getOaId())){
                continue;
            }
            formData.setField0005(account.getOaId());
            DepartmentDataObject dept =  deptMap.get(data.getDepartmentId());
            if(dept==null||StringUtils.isEmpty(dept.getOaId())){
                continue;
            }
            formData.setField0010(dept.getOaId());
            datalistall.add(formData);
            data.setSyncStatus("Y");
        }
        DBAgent.saveAll(datalistall);
        dataKitDao.saveOriginalDataObjectList2(busgetList);
        return retData;
    }
    public Map getBuget(){
        List<BusGetAmountData> busgetList = dataKitDao.getBusGetAmountData();
        List<DepartmentDataObject> departmentDataObjectList = dataKitDao.getDepartmentData();
        Map data = new HashMap();
        data.put("busget",busgetList);
        data.put("dept",departmentDataObjectList);
        return data;
    }
    private List<CtpEnumItem>  deleteAll(){
        return DBAgent.find("from CtpEnumItem");
    }





//以下都是实验方法 不顶用的
    public List<CtpEnumItem> getExistCtpEnumItem() throws BusinessException {
        return this.mockDo();
    }

    public void saveSourceList(List<OriginalDataObject> dataList) {
        this.dataKitDao.saveOriginalDataObjectList(dataList);
    }

    public List<CtpEnumItem> mockDo() {
        List<OriginalDataObject> dataList = this.getSourceList();
        if (!CollectionUtils.isEmpty(dataList)) {
            List<CtpEnumItem> itemList = this.transList(dataList);
            if (!CollectionUtils.isEmpty(itemList)) {
                Map<String, Long> sourceDataIdMap = new HashMap();
                Iterator var4 = dataList.iterator();

                while(var4.hasNext()) {
                    OriginalDataObject data = (OriginalDataObject)var4.next();
                    sourceDataIdMap.put(data.getId(), data.getOaId());
                }

                System.out.println("-----source------");
                System.out.println(sourceDataIdMap);
                System.out.println("-----endOfSource------");
                var4 = itemList.iterator();

                while(var4.hasNext()) {
                    CtpEnumItem item = (CtpEnumItem)var4.next();
                    String pid = "" + item.getExtraAttr("original-pid");
                    Long pid_ = (Long)sourceDataIdMap.get(pid);
                    if (pid != null) {
                       // System.out.println(String.valueOf(pid_));
                        item.setParentId(pid_);
                    }else{
                        item.setParentId(0L);
                    }
                }

                return itemList;
            }
        }

        return new ArrayList();
    }

    public List<CtpEnumItem> doWorkInOneStep() {
        List<OriginalDataObject> dataList = this.getSourceList();
        if (CollectionUtils.isEmpty(dataList)) {
            return new ArrayList();
        } else {
            List<CtpEnumItem> ret = this.transList(dataList);
            Map<String, Long> sourceDataIdMap = new HashMap();
            Iterator var4 = dataList.iterator();
            while(var4.hasNext()) {
                OriginalDataObject data = (OriginalDataObject)var4.next();
                sourceDataIdMap.put(data.getId(), data.getOaId());
            }
            var4 = ret.iterator();
            while(var4.hasNext()) {
                CtpEnumItem item = (CtpEnumItem)var4.next();
                String pid = "" + item.getExtraAttr("original-pid");
                Long pid_ = (Long)sourceDataIdMap.get(pid);
                if (pid != null) {
                    item.setParentId(pid_);
                }else{
                    item.setParentId(0L);
                }
            }
            DBAgent.saveAll(ret);
            try {
                Object enumManagerNew = AppContext.getBean("enumManagerNew");
                if (enumManagerNew instanceof EnumManagerImpl) {
                    ((EnumManagerImpl)enumManagerNew).init();
                }
            } catch (Exception var8) {
                var8.printStackTrace();
            }

            this.saveSourceList(dataList);
            return ret;
        }
    }

    public List<CtpEnumItem> transList(List<OriginalDataObject> dataList) {
        List<CtpEnumItem> list = new ArrayList();
        if (!CollectionUtils.isEmpty(dataList)) {
            Iterator var3 = dataList.iterator();
            while(var3.hasNext()) {
                OriginalDataObject data = (OriginalDataObject)var3.next();
                CtpEnumItem item = this.transNew(data);
                if (item != null) {
                    list.add(item);
                }
                data.setSyncStatus("Y");
                if ("Y".equals(data.getUpdateStatus())) {
                    data.setUpdateStatus("N");
                }
            }
        }

        return list;
    }

    public CtpEnumItem transNew(OriginalDataObject data) {
        CtpEnumItem item = new CtpEnumItem();
        item.setName(String.valueOf(this.metaId));
        //item.setDescription("AUTO-IMPORT");
        item.setEnumvalue(data.getNo());
        if (!"1".equals(data.getEnable()) && !"Y".equals(data.getEnable())) {
            item.setIfuse("N");
        } else {
            item.setIfuse("Y");
        }

        if (!StringUtils.isEmpty(data.getLevel())) {
            try {
                item.setLevelNum(Integer.parseInt(data.getLevel())-1);
            } catch(Exception e) {
                item.setLevelNum(0);
            }
        } else {
            item.setLevelNum(0);
        }
        item.setMetadataId(this.metaId);
        item.setShowvalue(data.getName());
        item.setIsRef(0);
        item.setLabel(data.getName());
        item.setIdIfNew();
        item.putExtraAttr("original-id", data.getId());
        item.putExtraAttr("original-pid", data.getpId());
        item.setOutputSwitch(1);
        if (!StringUtils.isEmpty(data.getpId())) {
            try {
                item.setParentId(Long.parseLong(data.getpId()));
            } finally {
                item.setParentId(0L);
            }
        } else {
            item.setParentId(0L);
        }

        item.setRefEnumid(this.rootEnumId);
        item.setOrgAccountId(this.orgAccountId);
        item.setRootId(0L);
        item.setState(1);
        item.setSortnumber(9998l);
        data.setOaId(item.getId());
        return item;
    }

    public DataKitDao getDataKitDao() {
        return this.dataKitDao;
    }

    public void setDataKitDao(DataKitDao dataKitDao) {
        this.dataKitDao = dataKitDao;
    }

    public EnumDAO getNewEnumDAO() {
        return this.newEnumDAO;
    }

    public void setNewEnumDAO(EnumDAO newEnumDAO) {
        this.newEnumDAO = newEnumDAO;
    }

    public EnumItemDAO getNewEnumItemDAO() {
        return this.newEnumItemDAO;
    }

    public void setNewEnumItemDAO(EnumItemDAO newEnumItemDAO) {
        this.newEnumItemDAO = newEnumItemDAO;
    }

    public EnumManager getEnumManagerNew() {
        return this.enumManagerNew;
    }

    public void setEnumManagerNew(EnumManager enumManagerNew) {
        this.enumManagerNew = enumManagerNew;
    }
}
