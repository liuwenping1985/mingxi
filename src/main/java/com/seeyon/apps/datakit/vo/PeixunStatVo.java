package com.seeyon.apps.datakit.vo;

import java.util.*;


/**
 * Created by liuwenping on 2018/10/10.
 */
public class PeixunStatVo {

    private List<PeixunPersonStat> items = new ArrayList<PeixunPersonStat>();
    private List<String> cleanPerson = new ArrayList<String>();
    private Map<String,Float> levelDayStat = new HashMap<String, Float>();
    private Map<String,Integer> levelFreqStat = new HashMap<String, Integer>();
    private Integer freq=0;
    private Float days=0f;
    private Map<String,Float> typeDayStat = new HashMap<String, Float>();
    private Map<String,Integer> typeFreqStat = new HashMap<String, Integer>();
    public void initBase(Map<Long,String> levels,Map<Long,String> types){

        for(String key:levels.values()){
            levelDayStat.put(key,0f);
            levelFreqStat.put(key,0);

        }
        for(String key:types.values()){
            typeDayStat.put(key,0f);
            typeFreqStat.put(key,0);

        }


    }
    public void addPeixunPersonStatList(Collection<PeixunPersonStat> colls){

        for(PeixunPersonStat stat:colls){
            freq+=stat.getFreq();
            days+=stat.getDays();
            Map<String,Float> levelDays = stat.getLevelDayStat();
            for(Map.Entry<String,Float> entry:levelDays.entrySet()){
                String key = entry.getKey();
                Float val = entry.getValue();
                Float sum = levelDayStat.get(key);
                levelDayStat.put(key,sum+val);
            }
            Map<String,Float> typeDays = stat.getTypeDayStat();
            for(Map.Entry<String,Float> entry:typeDays.entrySet()){
                String key = entry.getKey();
                Float sum = typeDayStat.get(key);
                typeDayStat.put(key,sum+entry.getValue());
            }
            Map<String,Integer> levelFreqs = stat.getLevelFreqStat();
            for(Map.Entry<String,Integer> entry:levelFreqs.entrySet()){
                String key = entry.getKey();
                Integer sum = levelFreqStat.get(key);
                levelFreqStat.put(key,sum+entry.getValue());
            }

            Map<String,Integer> typeFreqs = stat.getTypeFreqStat();
            for(Map.Entry<String,Integer> entry:typeFreqs.entrySet()){
                String key = entry.getKey();
                Integer sum = typeFreqStat.get(key);
                typeFreqStat.put(key,sum+entry.getValue());
            }
            boolean isClean = true;
            for(Integer freq:typeFreqs.values()){
                if(freq>0){
                    isClean = false;
                    break;
                }
            }
            if(isClean){
                cleanPerson.add(stat.getUserName());
            }


            items.add(stat);

        }


    }

    public List<PeixunPersonStat> getItems() {
        return items;
    }

    public void setItems(List<PeixunPersonStat> items) {
        this.items = items;
    }

    public List<String> getCleanPerson() {
        return cleanPerson;
    }

    public void setCleanPerson(List<String> cleanPerson) {
        this.cleanPerson = cleanPerson;
    }

    public Map<String, Float> getLevelDayStat() {
        return levelDayStat;
    }

    public void setLevelDayStat(Map<String, Float> levelDayStat) {
        this.levelDayStat = levelDayStat;
    }

    public Map<String, Integer> getLevelFreqStat() {
        return levelFreqStat;
    }

    public void setLevelFreqStat(Map<String, Integer> levelFreqStat) {
        this.levelFreqStat = levelFreqStat;
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
}
