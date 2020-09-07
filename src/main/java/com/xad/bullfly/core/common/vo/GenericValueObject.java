package com.xad.bullfly.core.common.vo;

import com.alibaba.fastjson.JSON;

import com.xad.bullfly.core.common.base.domain.BaseDomain;
import org.springframework.util.CollectionUtils;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

/**
 * 核心通用vo,可包含数据的主键，本身的主键没有任何意义,多处使用，同时充当前端VO
 * KEY,VALUE 泛型用于在严格区分对象类型的场景 平时不需要写
 * 优势点 通用性极强
 * 缺点 语义不明 代码可读性差
 *
 * @Author liuwenping
 */
public class GenericValueObject<KEY extends Serializable, VALUE> extends BaseDomain<KEY> {


    /**
     * 前端相应对象的字段定义
     */
    protected static final String RESPONSE_VO_DATA_FIELDNAME = "data";
    protected static final String RESPONSE_VO_MSG_FIELDNAME = "msg";
    protected static final String RESPONSE_VO_RESULT_FIELDNAME = "result";
    protected static final String RESPONSE_VO_ITEMS_FIELDNAME = "items";

    private volatile Map<KEY, VALUE> dataContainer;

    public GenericValueObject() {
        this.dataContainer = new HashMap<KEY, VALUE>();
    }

    public GenericValueObject(Map data) {
        if (data != null) {
            this.dataContainer = data;
        } else {
            this.dataContainer = new HashMap<KEY, VALUE>();
        }

    }

    public GenericValueObject(GenericValueObject<KEY, VALUE> data) {
        this.dataContainer = new HashMap<KEY, VALUE>();
        if (data != null) {
            this.dataContainer.putAll(data.dataContainer);
        }

    }


    public GenericValueObject set(KEY key, VALUE val) {
        synchronized (this) {
            this.dataContainer.put(key, val);
        }
        return this;

    }

    public void copyFrom(Map<KEY, VALUE> dataMap) {
        if (CollectionUtils.isEmpty(dataMap)) {
            return;

        }
        this.dataContainer.putAll(dataMap);
    }

    public void copyFromIfValueIsNotNull(Map<KEY, VALUE> dataMap) {
        if (CollectionUtils.isEmpty(dataMap)) {
            return;

        }
        for (Map.Entry<KEY, VALUE> entry : dataMap.entrySet()) {
            VALUE val = entry.getValue();
            if (val != null) {

                this.dataContainer.put(entry.getKey(), entry.getValue());
            }

        }


    }
    public boolean isEmpty(){
        return this.dataContainer!=null&&this.dataContainer.isEmpty();
    }

    public void extend(GenericValueObject gvo){
        if(gvo==null&&gvo.isEmpty()){
            return;
        }
        this.copyFrom(gvo.dataContainer);
    }
    public void extendIfValueNotNull(GenericValueObject gvo){
        if(gvo==null){
            return;
        }
        this.copyFromIfValueIsNotNull(gvo.dataContainer);
    }

    public GenericValueObject put(KEY key, VALUE val) {
        return this.set(key, val);
    }

    /**
     * set方法的简写
     *
     * @param key
     * @param val
     * @return
     */
    public GenericValueObject s(KEY key, VALUE val) {
        return this.set(key, val);

    }

    public VALUE get(KEY key) {

        return this.dataContainer.get(key);

    }

    public VALUE $(KEY key) {

        return this.get(key);
    }

    public VALUE $(KEY key, VALUE defaultValue) {

        VALUE val = this.get(key);
        if (val != null) {
            return val;
        }
        return defaultValue;
    }

    public <T> T toPOJO(Class<T> t) {

        String jsonString = JSON.toJSONString(this.dataContainer);
        return JSON.parseObject(jsonString, t);
    }

    /**
     * 转换为JSON 依赖fastjson
     *
     * @return
     */
    public String toJSONString() {

        return JSON.toJSONString(this.dataContainer);

    }

    @Override
    public String toString(){
        return toJSONString();
    }

    public Map toResponseDataMapWhenResultIsSingleObject() {
        Map data = new HashMap();
        data.put(RESPONSE_VO_DATA_FIELDNAME, this.dataContainer.get(RESPONSE_VO_DATA_FIELDNAME));
        data.put(RESPONSE_VO_RESULT_FIELDNAME, this.dataContainer.get(RESPONSE_VO_RESULT_FIELDNAME));
        data.put(RESPONSE_VO_MSG_FIELDNAME, this.dataContainer.get(RESPONSE_VO_MSG_FIELDNAME));

        return data;
    }

    public Map toResponseListMapWhenResultIsList() {
        Map data = toResponseDataMapWhenResultIsSingleObject();
        data.put(RESPONSE_VO_ITEMS_FIELDNAME, this.dataContainer.get(RESPONSE_VO_ITEMS_FIELDNAME));
        return data;
    }



}
