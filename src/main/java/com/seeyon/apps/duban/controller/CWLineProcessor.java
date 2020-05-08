package com.seeyon.apps.duban.controller;

import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.seeyon.apps.duban.controller.CsvReader.processCW;

/**
 * Created by liuwenping on 2020/4/13.
 */
public class CWLineProcessor extends LineProcessor {
    public void process(BufferedReader bufferedReader, boolean isCloseBuffer) {
        Map<String,City> cwCity = new HashMap<String,City>();
        int flag=0;
        String linecw="";
        try {
            while (!StringUtils.isEmpty(linecw = bufferedReader.readLine())) {
                if(flag==0){
                    flag++;
                    continue;
                }
                City city = processCW(linecw);
                if(city!=null){
                    cwCity.put(city.getCityname(),city);
                }
                flag++;
            }
            this.setCityMap(cwCity);
            List<City> list = new ArrayList<City>();
            list.addAll(cwCity.values());
            this.setList(list);
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(isCloseBuffer){
                if(bufferedReader!=null){
                    try{
                        bufferedReader.close();
                    }catch (Exception e){

                    }
                }
            }
        }

    }
}
