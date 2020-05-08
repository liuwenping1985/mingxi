package com.seeyon.apps.duban.controller;


import com.alibaba.fastjson.JSON;
import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by liuwenping on 2020/4/7.
 */
public class CsvReader {




    public static void main(String[] args) throws Exception {
        /**
         *  /Users/liuwenping/Downloads/city/cwbx_city.csv
         *   /Users/liuwenping/Downloads/city/oa_city.csv
         */

        String filePath_cw = "/Users/liuwenping/Downloads/cwbx_city_no_BOM.txt";

        String filePath_oa = "/Users/liuwenping/Downloads/oa_city_all.txt";

        File file = new File(filePath_oa);
        FileReader reader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(reader);
        Map<String,City> oaCity = new HashMap<String,City>();
        OALineProcessor oaLineProcessor = new OALineProcessor();
        oaLineProcessor.process(bufferedReader,true);
        oaCity = oaLineProcessor.getCityMap();

        File filecw = new File(filePath_cw);
        FileReader readercw = new FileReader(filecw);
        BufferedReader bufferedReadercw = new BufferedReader(readercw);
        Map<String,City> cwCity = new HashMap<String,City>();
        CWLineProcessor cwLineProcessor = new CWLineProcessor();
        cwLineProcessor.process(bufferedReadercw,true);
        cwCity = cwLineProcessor.getCityMap();

        int tag=0;
        for(Map.Entry<String,City> entry:cwCity.entrySet()){
            String cwName = entry.getKey();
            City city = oaCity.get(cwName);
            if(city==null){
                if(cwName.endsWith("省")){
                    continue;
                }
                if(cwName.endsWith("区")||cwName.endsWith("县")||cwName.endsWith("市")){
                    String ncwname = cwName.substring(0,cwName.length()-1);
                    city = oaCity.get(ncwname);
                    if(cwName.endsWith("区")&&!"重庆".equals(entry.getValue().getProvincename())){
                        continue;
                    }
                    if(city==null){
                        tag++;
                        System.out.println(JSON.toJSONString(entry.getValue()));
                    }
                }else{

                        tag++;
                        System.out.println(JSON.toJSONString(entry.getValue()));

                }


            }


        }
        System.out.println(tag);



    }

    public static City processOA(String line) {
        /*
         * ID,CITY,CITYENAME,CITYNAME,JIANPIN,COUNTRY,COUNTRYENAME,COUNTRYNAME,PROVINCE,PROVINCEENAME,PROVINCENAME
         *
         */
        String[] lines = line.split(",");
        if (lines == null) {
            return null;
        }
        City city = new City();

        city.setCity(trim(lines[1]));
        city.setCityenname(trim(lines[2]));
        city.setCityname(trim(lines[3]));
        city.setJianpin(trim(lines[4]));
        city.setCountry(trim(lines[5]));
        city.setCountryenname(lines[6]);
        city.setCountryname(trim(lines[7]));
        city.setProvince(trim(lines[8]));
        city.setProvincename(trim(lines[9]));
        city.setProvinceenname(trim(lines[10]));


        return city;

    }
    private static String trim(String val){
        if(val==null){
            return "";
        }
        return val.trim();

    }

    public static City processCW(String line) {
        /**
         * 编码,名称,类型,上级编码,上级名称
         */
        String[] lines = line.split(",");
        if (lines == null||lines.length<5) {
            return null;
        }
        City city = new City();
        city.setCity(trim(lines[0]));
        city.setCityname(trim(lines[1]));
        city.setProvince(trim(lines[3]));
        city.setProvincename(trim(lines[4]));


        return city;
    }


}
