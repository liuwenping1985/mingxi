package com.seeyon.apps.datakit.vo;

import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2018/10/9.
 */
public class KaoqinStatVo {

    private String memo;

    private List<KaoqinPersonStat> items;

    private Map<String,List<KaoqinPersonStat>> stat;

    public String getMemo() {
        return memo;
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

    public Map<String, List<KaoqinPersonStat>> getStat() {
        return stat;
    }

    public void setStat(Map<String, List<KaoqinPersonStat>> stat) {
        this.stat = stat;
    }
}
