package com.seeyon.apps.datakit.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/9.
 */
public class KaoqinPersonStat {


    private String userName;

    private Long userId;

    private Long deptId;

    private String deptName;

    private Long accountId;

    private String accountName;

    private String no;

    private Long sortId;
    //按照事由归类
    private Map<String,List<KaoqinItem>> data;

    public void addKaoqinItem(KaoqinItem item){

        if(data == null){
            data = new HashMap<String, List<KaoqinItem>>();
        }
        String key = item.getTypeName();
        List<KaoqinItem> itemList =  data.get(key);
        if(itemList == null){
            itemList = new ArrayList<KaoqinItem>();
            data.put(key,itemList);
        }
        itemList.add(item);

    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getDeptId() {
        return deptId;
    }

    public void setDeptId(Long deptId) {
        this.deptId = deptId;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }


    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public Map<String, List<KaoqinItem>> getData() {
        return data;
    }

    public void setData(Map<String, List<KaoqinItem>> data) {
        this.data = data;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public Long getSortId() {
        return sortId;
    }

    public void setSortId(Long sortId) {
        this.sortId = sortId;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }
}
