package com.seeyon.apps.datakit.vo;

import java.util.*;

/**
 * Created by liuwenping on 2018/10/10.
 */
public class PeixunPersonStat {

    private String userName;
    private Long userId;
    private Long deptId;
    private String deptName;
    private Long sortId;
    private Integer freq=0;
    private Float days=0f;

    private Map<String,Float> levelDayStat = new HashMap<String, Float>();
    private Map<String,Integer> levelFreqStat = new HashMap<String, Integer>();

    private Map<String,Float> typeDayStat = new HashMap<String, Float>();
    private Map<String,Integer> typeFreqStat = new HashMap<String, Integer>();
    public void initBase(Map<Long,String> levels,Map<Long,String> types){
        for(String key:types.values()){
            typeDayStat.put(key,0f);
            typeFreqStat.put(key,0);

        }
        for(String key:levels.values()){
            levelDayStat.put(key,0f);
            levelFreqStat.put(key,0);
        }

    }
    public void addRawData(String levelName,String typeName,Float num){

        Float days = typeDayStat.get(typeName);
        Float levelDays = levelDayStat.get(levelName);
        typeDayStat.put(typeName,days+num);
        levelDayStat.put(levelName,levelDays+num);
        Integer freq = typeFreqStat.get(typeName);
        Integer levelFreq = levelFreqStat.get(levelName);
        typeFreqStat.put(typeName,freq+1);
        levelFreqStat.put(levelName,levelFreq+1);
        this.freq+=1;
        this.days+=num;

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

    public Long getSortId() {
        return sortId;
    }

    public void setSortId(Long sortId) {
        this.sortId = sortId;
    }

    public Integer getFreq() {
        return freq;
    }

    public void setFreq(Integer freq) {
        this.freq = freq;
    }

    public Float getDays() {
        return days;
    }

    public void setDays(Float days) {
        this.days = days;
    }

    public Map<String, Integer> getLevelFreqStat() {
        return levelFreqStat;
    }

    public void setLevelFreqStat(Map<String, Integer> levelFreqStat) {
        this.levelFreqStat = levelFreqStat;
    }

    public Map<String, Float> getLevelDayStat() {
        return levelDayStat;
    }

    public void setLevelDayStat(Map<String, Float> levelDayStat) {
        this.levelDayStat = levelDayStat;
    }

    public Map<String, Float> getTypeDayStat() {
        return typeDayStat;
    }

    public void setTypeDayStat(Map<String, Float> typeDayStat) {
        this.typeDayStat = typeDayStat;
    }

    public Map<String, Integer> getTypeFreqStat() {
        return typeFreqStat;
    }

    public void setTypeFreqStat(Map<String, Integer> typeFreqStat) {
        this.typeFreqStat = typeFreqStat;
    }
}
