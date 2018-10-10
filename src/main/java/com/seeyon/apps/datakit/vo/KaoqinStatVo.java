package com.seeyon.apps.datakit.vo;


import java.util.*;

/**
 * Created by liuwenping on 2018/10/9.
 */
public class KaoqinStatVo {

    private String memo;

    private Integer userCount;
    private Map<String,Integer> allFreq = new HashMap<String, Integer>();
    private Map<String,Float> allDays = new HashMap<String, Float>();
    private Float days=0f;
    private Integer freq=0;
    private List<KaoqinPersonStat> items;
    //按照事由名字统计
    private Map<String, List<String>> statData = new HashMap<String, List<String>>();
    private List<String> cleanPerson = new ArrayList<String>();
    public void addKaoqinPerson(Collection<KaoqinPersonStat> statList) {

        if (items == null) {
            items = new ArrayList<KaoqinPersonStat>();
        }
        for(KaoqinPersonStat stat:statList){

            Map<String, Integer> freqs = stat.getDataFreq();
            boolean isClean = true;
            for(Integer f:freqs.values()){
                if(isClean){
                    if(f>0){
                        isClean=false;
                        break;
                    }
                }

            }
            freq+=stat.getFreq();
            days+=stat.getDays();
            if(isClean){
                cleanPerson.add(stat.getUserName());
            }
            Map<String, Float>  days =  stat.getDataDays();
            for(Map.Entry<String,Float> entry:days.entrySet()){
                Float day = allDays.get(entry.getKey());
                if(day == null){
                    day = 0f;
                }
                allDays.put(entry.getKey(),day+entry.getValue());

            }
            for(Map.Entry<String,Integer> entry:freqs.entrySet()){
                Integer freq = allFreq.get(entry.getKey());
                if(freq == null){
                    freq = 0;
                }
                Integer val = entry.getValue();
                List<String> list = statData.get(entry.getKey());
                if(list == null){
                    list = new ArrayList<String>();
                    statData.put(entry.getKey(),list);
                }
                if(val>0){
                    list.add(stat.getUserName());
                    allFreq.put(entry.getKey(),freq+entry.getValue());
                }

            }
            items.add(stat);
        }
    }

    public String getMemo() {
        return memo;
    }

    public Integer getUserCount() {
        return userCount;
    }

    public void setUserCount(Integer userCount) {
        this.userCount = userCount;
    }



    public void setMemo(String memo) {
        this.memo = memo;
    }

    public List<KaoqinPersonStat> getItems() {
        return items;
    }

    public void setItems(List<KaoqinPersonStat> items) {
        this.items = items;
    }

    public Map<String, List<String>> getStatData() {
        if (statData == null) {
            statData = new HashMap<String, List<String>>();
        }
        return statData;
    }

    public Map<String, Integer> getAllFreq() {
        return allFreq;
    }

    public void setAllFreq(Map<String, Integer> allFreq) {
        this.allFreq = allFreq;
    }

    public Map<String, Float> getAllDays() {
        return allDays;
    }

    public void setAllDays(Map<String, Float> allDays) {
        this.allDays = allDays;
    }

    public List<String> getCleanPerson() {
        return cleanPerson;
    }

    public void setCleanPerson(List<String> cleanPerson) {
        this.cleanPerson = cleanPerson;
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

    public void setStatData(Map<String, List<String>> statData) {
        this.statData = statData;
    }
}
