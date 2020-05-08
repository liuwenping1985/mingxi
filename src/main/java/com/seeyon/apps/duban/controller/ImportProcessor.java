package com.seeyon.apps.duban.controller;

import com.alibaba.fastjson.JSON;
import com.seeyon.ctp.util.UUIDLong;
import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import org.apache.commons.lang.StringUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by liuwenping on 2020/4/8.
 */
public class ImportProcessor {


    public static void main(String[] args) throws Exception {

        String filePath_import = ImportProcessor.class.getResource("import.txt").getPath();
        File filePath_import_file = new File(filePath_import);
        FileReader filePath_import_reader = new FileReader(filePath_import_file);
        BufferedReader filePath_import_bufferreader = new BufferedReader(filePath_import_reader);

        String filePath_cw = "/Users/liuwenping/Downloads/cwbx_city_no_BOM.txt";
        File filePath_cw_file = new File(filePath_cw);
        FileReader filePath_cw_reader = new FileReader(filePath_cw_file);
        BufferedReader filePath_cw_bufferreader = new BufferedReader(filePath_cw_reader);


        String filePath_oa = "/Users/liuwenping/Downloads/oa_city_all.txt";
        File filePath_oa_file = new File(filePath_oa);
        FileReader oa_reader = new FileReader(filePath_oa_file);
        BufferedReader oa_bufferreader = new BufferedReader(oa_reader);


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

        CWLineProcessor cwLineProcessor = new CWLineProcessor();

        cwLineProcessor.process(filePath_cw_bufferreader, true);

        OALineProcessor oaLineProcessor = new OALineProcessor();

        oaLineProcessor.process(oa_bufferreader, true);

        //先把imt中的数据的省份洗了
        Map<String, City> importMap = importProcessor.getCityMap();

        Map<String, City> cwMap = cwLineProcessor.getCityMap();

        Map<String, City> oaMap = oaLineProcessor.getCityMap();
        //从财务那里找到一级省份
        for (Map.Entry<String, City> entry : importMap.entrySet()) {

            City city = entry.getValue();
            while (city != null) {

                City curCity = cwMap.get(city.getProvincename());

                if (curCity != null && ("全部省份".equals(curCity.getCityname()) || curCity.getCityname().equals(curCity.getProvincename()))) {
                    if("全部省份".equals(city.getProvincename())){
                        entry.getValue().setProvincename(city.getCityname());
                    }else{
                        entry.getValue().setProvincename(city.getProvincename());
                    }

                    entry.getValue().setProvinceenname(city.getProvinceenname());
                    break;
                } else {

                    city = curCity;
                }
            }
        }
        Map<String,City> oaMapExtend = new HashMap<String, City>();
        for(Map.Entry<String, City> entry : oaMap.entrySet()){
            City city = entry.getValue();
            oaMapExtend.put(city.getProvinceenname(),city);

        }

        System.out.println(oaMapExtend.size());
        for (Map.Entry<String, City> entry : importMap.entrySet()) {

            City city = entry.getValue();
            String key = city.getProvincename();
            City oacity =oaMapExtend.get(key);
            if(oacity==null){
                oacity = oaMapExtend.get(key.substring(0,key.length()-1));
            }
            if(oacity==null){
                if("内蒙古自治区".equals(key)){
                    oacity = oaMapExtend.get("内蒙古");
                }
                if("广西壮族自治区".equals(key)){
                    oacity = oaMapExtend.get("广西");
                }
                if("新疆维吾尔自治区".equals(key)){
                    oacity = oaMapExtend.get("新疆");
                }
                if("宁夏回族自治区".equals(key)){
                    oacity = oaMapExtend.get("宁夏");
                }
                if("西藏自治区".equals(key)){
                    oacity = oaMapExtend.get("西藏");
                }

            }
            if(oacity==null){
                System.out.println(key);
            }else{
                city.setCountry(oacity.getCountry());
                city.setCountryname(oacity.getCountryname());
                city.setCountryenname(oacity.getCountryenname());
                city.setProvince(oacity.getProvince());
                city.setProvincename(oacity.getProvinceenname());
                city.setProvinceenname(oacity.getProvincename());
                city.setId(UUIDLong.longUUID());
                city.setJianpin(convertHanzi2Pinyin(city.getCityname(),false));
                String pinyin = convertHanzi2Pinyin(city.getCityname(),true);

                city.setCityenname(pinyin.substring(0,1).toUpperCase()+pinyin.substring(1));
            }



        }

        for (Map.Entry<String, City> entry : importMap.entrySet()){

            System.out.println(JSON.toJSONString(entry.getValue()));

        }


    }

    public static String convertHanzi2Pinyin(String hanzi, boolean full) {
        /***
         * ^[\u2E80-\u9FFF]+$ 匹配所有东亚区的语言 ^[\u4E00-\u9FFF]+$ 匹配简体和繁体
         * ^[\u4E00-\u9FA5]+$ 匹配简体
         */
        String regExp = "^[\u4E00-\u9FFF]+$";
        StringBuffer sb = new StringBuffer();
        if (hanzi == null || "".equals(hanzi.trim())) {
            return "";
        }
        if(hanzi.length()>2){
            hanzi = hanzi.replaceAll("区","");
            hanzi = hanzi.replaceAll("市","");
            if(!hanzi.contains("自治县")){
                hanzi = hanzi.replaceAll("县","");
            }

           // hanzi = hanzi.replaceAll("自治县","");
        }
        String pinyin = "";
        for (int i = 0; i < hanzi.length(); i++) {
            char unit = hanzi.charAt(i);
            if (match(String.valueOf(unit), regExp))// 是汉字，则转拼音
            {
                pinyin = convertSingleHanzi2Pinyin(unit);
                if (full) {
                    sb.append(pinyin);
                } else {
                    sb.append(pinyin.charAt(0));
                }
            } else {
                sb.append(unit);
            }
        }
        return sb.toString();
    }
    private static String convertSingleHanzi2Pinyin(char hanzi) {
        HanyuPinyinOutputFormat outputFormat = new HanyuPinyinOutputFormat();
        outputFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
        String[] res;
        StringBuffer sb = new StringBuffer();
        try {
            res = PinyinHelper.toHanyuPinyinStringArray(hanzi, outputFormat);
            sb.append(res[0]);// 对于多音字，只用第一个拼音
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        return sb.toString();
    }
    public static boolean match(String str, String regex) {
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(str);
        return matcher.find();
    }

}
