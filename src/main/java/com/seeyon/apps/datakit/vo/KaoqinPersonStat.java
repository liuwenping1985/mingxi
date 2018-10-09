package com.seeyon.apps.datakit.vo;

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

    private String accountId;

    private String accountName;

    private Map<Long,KaoqinItem> data;

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

    public String getAccountId() {
        return accountId;
    }

    public void setAccountId(String accountId) {
        this.accountId = accountId;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public Map<Long, KaoqinItem> getData() {
        return data;
    }

    public void setData(Map<Long, KaoqinItem> data) {
        this.data = data;
    }
}
