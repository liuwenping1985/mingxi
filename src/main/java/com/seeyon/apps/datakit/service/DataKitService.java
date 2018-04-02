
package com.seeyon.apps.datakit.service;

import com.seeyon.apps.datakit.dao.DataKitDao;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
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

    public DataKitService() {
        ScheduleTread scheduleTread = new ScheduleTread();
        scheduleTread.setDataKitService(this);
        scheduleTread.start();
    }

    public List<OriginalDataObject> getSourceList() {
        return this.dataKitDao.getOriginalDataList();
    }

    public CtpEnum getRootEnum() throws BusinessException {
        return this.newEnumDAO.selectById(this.rootEnumId);
    }

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
                        System.out.println(String.valueOf(pid_));
                        item.setParentId(pid_);
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
                CtpEnumItem item = this.trans(data);
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

    public CtpEnumItem trans(OriginalDataObject data) {
        CtpEnumItem item = new CtpEnumItem();
        item.setName(String.valueOf(this.metaId));
        item.setDescription("AUTO-IMPORT");
        item.setEnumvalue(data.getNo());
        if (!"1".equals(data.getEnable()) && !"Y".equals(data.getEnable())) {
            item.setIfuse("N");
        } else {
            item.setIfuse("Y");
        }

        if (!StringUtils.isEmpty(data.getLevel())) {
            try {
                item.setLevelNum(Integer.parseInt(data.getLevel()));
            } finally {
                item.setLevelNum(1);
            }
        } else {
            item.setLevelNum(1);
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
        if (data.getId() != null) {
            try {
                item.setSortnumber(Long.parseLong(data.getId()) + 10086L);
            } finally {
                item.setSortnumber(10086L);
            }
        } else {
            item.setSortnumber(10086L);
        }

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
