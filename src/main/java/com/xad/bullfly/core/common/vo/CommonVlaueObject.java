package com.xad.bullfly.core.common.vo;

import com.alibaba.fastjson.JSON;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2020/5/7.
 */
public abstract class CommonVlaueObject<T> {

    private Map data_;

    public Map generateMap() {

        String json = JSON.toJSONString(this);
        Map data = JSON.parseObject(json, HashMap.class);
        this.data_ = data;
        return data;

    }

    public Object $(String key) {
        if (this.data_ == null) {
            this.generateMap();
        }
        if (this.data_ == null) {
            return null;
        }
        return data_.get(key);

    }

    public void $(String key, Object val) {
        if (this.data_ == null) {
            this.generateMap();
        }
        if (this.data_ == null) {
            this.data_ = new HashMap();
        }
        data_.put(key, val);

    }


}
