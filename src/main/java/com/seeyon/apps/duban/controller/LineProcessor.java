package com.seeyon.apps.duban.controller;

import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/4/13.
 */
public abstract class LineProcessor {

    private List<City> list;

    private Map<String,City> cityMap;

    public Map<String, City> getCityMap() {
        return cityMap;
    }

    public void setCityMap(Map<String, City> cityMap) {
        this.cityMap = cityMap;
    }

    public void setList(List<City> list) {
        this.list = list;
    }

    List<City> getCityList(){

        return list==null?new ArrayList<City>():list;
     }

     abstract void  process(BufferedReader bufferedReader,boolean isCloseBuffer);



}
