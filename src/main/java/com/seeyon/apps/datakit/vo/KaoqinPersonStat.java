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
    private Float days=0f;
    private Integer freq=0;

    private Map<String,Integer> dataFreq = new HashMap<String, Integer>();
    private Map<String,Float> dataDays = new HashMap<String, Float>();

    public void initData(Map<Long,String> enumValues){

        for(String key:enumValues.values()){
            dataFreq.put(key,0);
            dataDays.put(key,0f);
        }


    }
    public void addKaoqinRawData(Long typeId,String typeName,Float num){

        Float days = dataDays.get(typeName);
        if(days==null){
            days = 0f;
        }
        this.days+=num;
        this.freq+=1;
        dataDays.put(typeName,days+num);
        Integer freq = dataFreq.get(typeName);
        dataFreq.put(typeName,freq+1);

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

    public Map<String, Integer> getDataFreq() {
        return dataFreq;
    }

    public void setDataFreq(Map<String, Integer> dataFreq) {
        this.dataFreq = dataFreq;
    }

    public Map<String, Float> getDataDays() {
        return dataDays;
    }

    public void setDataDays(Map<String, Float> dataDays) {
        this.dataDays = dataDays;
    }

    public Float getDays() {
        return days;
    }

    public void setDays(Float days) {
        this.days = days;
    }

    public Integer getFreq() {
        return freq;
    }

    public void setFreq(Integer freq) {
        this.freq = freq;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }
}
