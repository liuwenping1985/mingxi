package com.seeyon.apps.duban.controller;

import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.seeyon.apps.duban.controller.CsvReader.processOA;

/**
 * Created by liuwenping on 2020/4/13.
 */
public class OALineProcessor extends LineProcessor {

    public void process(BufferedReader bufferedReader, boolean isCloseBuffer) {

        String line = null;
        //编码,名称,类型,上级编码,上级名称
        Map<String, City> oaCity = new HashMap<String, City>();
        int flag = 0;
        try {
            while (!StringUtils.isEmpty(line = bufferedReader.readLine())) {
                if (flag == 0) {
                    flag++;
                    continue;
                }
                City city = processOA(line);
                if (city != null) {
                    oaCity.put(city.getCityname(), city);
                }
                flag++;
            }
            this.setCityMap(oaCity);
            List<City> list = new ArrayList<City>();
            list.addAll(oaCity.values());
            this.setList(list);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (isCloseBuffer) {
                if (bufferedReader != null) {
                    try {
                        bufferedReader.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }


    }
}
