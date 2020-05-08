package com.seeyon.apps.duban.controller;

import com.alibaba.fastjson.JSON;
import org.apache.commons.lang.StringUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/4/16.
 */
public class ToSQL {

    public static void main(String[] args) throws FileNotFoundException {


        /**
         * insert into pro_city (ID, CITY, CITYENAME, CITYNAME, JIANPIN, COUNTRY, COUNTRYENAME, COUNTRYNAME, PROVINCE, PROVINCEENAME, PROVINCENAME) values ('-1.0108965723e+018', '21141', 'Weishan', '巍山', '', '1', 'China', '中国', '25', 'Yunnan', '云南');

         */
        String filePath_import = ImportProcessor.class.getResource("result.txt").getPath();
        File filePath_import_file = new File(filePath_import);
        FileReader filePath_import_reader = new FileReader(filePath_import_file);
        BufferedReader filePath_import_bufferreader = new BufferedReader(filePath_import_reader);
        LineProcessor importProcessor = new LineProcessor() {
            public void process(BufferedReader bufferedReader, boolean isCloseBuffer) {
                String linecw = null;
                //编码,名称,类型,上级编码,上级名称
                try {
                    final Map<String, City> cityMap = new HashMap<String, City>();
                    while (!StringUtils.isEmpty(linecw = bufferedReader.readLine())) {
                        City city = JSON.parseObject(linecw, City.class);
                        cityMap.put(city.getCityname(), city);

                    }
                    List<City> list = new ArrayList<City>();
                    list.addAll(cityMap.values());
                    this.setCityMap(cityMap);
                    this.setList(list);
                } catch (IOException e) {
                    e.printStackTrace();
                }


            }
        };
        importProcessor.process(filePath_import_bufferreader, true);
        List<City> cityList = importProcessor.getCityList();
        for(City city:cityList){
            StringBuilder dtb = new StringBuilder("insert into pro_city (ID, CITY, CITYENAME, CITYNAME, JIANPIN, COUNTRY, COUNTRYENAME, COUNTRYNAME, PROVINCE, PROVINCEENAME, PROVINCENAME) values (");
            dtb.append("'").append(city.getId()).append("',");
            //'-1.0108965723e+018', '21141', 'Weishan', '巍山', '', '1', 'China', '中国', '25', 'Yunnan', '云南'
            dtb.append("'").append(city.getCity()).append("',");
            dtb.append("'").append(city.getCityenname()).append("',");
            dtb.append("'").append(city.getCityname()).append("',");
            dtb.append("'").append(city.getJianpin()).append("',");
            dtb.append("'").append(city.getCountry()).append("',");
            dtb.append("'").append(city.getCountryenname()).append("',");
            dtb.append("'").append(city.getCountryname()).append("',");
            dtb.append("'").append(city.getProvince()).append("',");
            dtb.append("'").append(city.getProvinceenname()).append("',");
            dtb.append("'").append(city.getProvincename()).append("'");
            dtb.append(");");
            System.out.println(dtb.toString());

        }

    }
}
