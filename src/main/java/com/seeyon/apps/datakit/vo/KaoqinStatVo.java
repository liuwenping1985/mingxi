package com.seeyon.apps.datakit.vo;


import java.util.*;

/**
 * Created by liuwenping on 2018/10/9.
 */
public class KaoqinStatVo {

    private String memo;

    private Integer userCount;

    private List<KaoqinPersonStat> items;
    //按照事由名字统计
    private Map<String, List<KaoqinPersonStat>> statData;

    public void addKaoqinPerson(Collection<KaoqinPersonStat> statList) {

        if (items == null) {
            items = new ArrayList<KaoqinPersonStat>();
        }
        items.addAll(statList);

        if (statData == null) {
            statData = new HashMap<String, List<KaoqinPersonStat>>();
        }
        for (KaoqinPersonStat personStat : statList) {
            Map<String, List<KaoqinItem>> data = personStat.getData();
            if (data == null || data.isEmpty()) {
                continue;
            }
            for (Map.Entry<String, List<KaoqinItem>> entry : data.entrySet()) {
                List<KaoqinItem> itemList = entry.getValue();
                if (itemList != null && !itemList.isEmpty()) {
                    continue;
                }
                List<KaoqinPersonStat> pstat =  statData.get(entry.getKey());
                if(pstat==null){
                    pstat = new ArrayList<KaoqinPersonStat>();
                    statData.put(entry.getKey(),pstat);
                }
                pstat.add(personStat);
            }


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

    public void initStatData(Map<Long, String> enumItems) {
        statData = new HashMap<String, List<KaoqinPersonStat>>();
        for (String val : enumItems.values()) {
            if (val == null || "null".equals(val)) {
                continue;
            }
            statData.put(val, new ArrayList<KaoqinPersonStat>());
        }
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

    public Map<String, List<KaoqinPersonStat>> getStatData() {
        if (statData == null) {
            statData = new HashMap<String, List<KaoqinPersonStat>>();
        }
        return statData;
    }

    public void setStatData(Map<String, List<KaoqinPersonStat>> statData) {
        this.statData = statData;
    }
}
