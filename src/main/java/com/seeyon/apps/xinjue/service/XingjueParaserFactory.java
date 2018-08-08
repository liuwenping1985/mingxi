package com.seeyon.apps.xinjue.service;

import com.seeyon.apps.xinjue.constant.EnumParameterType;
import com.seeyon.apps.xinjue.po.*;
import com.seeyon.ctp.util.UUIDLong;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class XingjueParaserFactory {


    public static XingjueDataParser getParser(EnumParameterType type){

        switch(type) {
            case WAREHOUSE:
                return WAREHOUSE_PARSER_INSTANCE;
            case ORG:
                return ORG_PARSER_INSTANCE;
            case BILL:
                return BILL_PARSER_INSTANCE;
            case CUSTOM:
                return CUSTOM_PARSER_INSTANCE;
            case COMMODITY:
                return COMMODITY_PARSER_INSTANCE;
            default:
                return null;
        }
    }

    static class WAREHOUSE_PARSER implements XingjueDataParser<Formmain1464>{


        public List<Formmain1464> parseData(Map parseData) {
            List<Map> dataList = (List)parseData.get("resultset");
            if(CollectionUtils.isEmpty(dataList)){
                return null;
            }
            List<Formmain1464> fm1464List = new ArrayList<Formmain1464>();
            for(Map data:dataList){
                Formmain1464 fm1464 = new Formmain1464();
                fm1464.setField0001(String.valueOf(data.get("orgcode")));
                fm1464.setField0002(String.valueOf(data.get("ckcode")));
                fm1464.setField0003(String.valueOf(data.get("ckname")));
                fm1464.setField0004(String.valueOf(data.get("ckaddr")));
                fm1464.setId(UUIDLong.longUUID());
                fm1464List.add(fm1464);

            }
            return fm1464List;
        }
    }
    static class BILL_PARSER implements XingjueDataParser<Formmain1465>{


        public List<Formmain1465> parseData(Map parseData) {
            List<Map> dataList = (List)parseData.get("resultset");
            if(CollectionUtils.isEmpty(dataList)){
                return null;
            }
            /**
             * "ywtype": "1602",
             *                 "ywtypename": "批发退货"
             */
            List<Formmain1465> fm1465List = new ArrayList<Formmain1465>();
            for(Map data:dataList){
                Formmain1465 fm1465 = new Formmain1465();
                fm1465.setField0001(String.valueOf(data.get("ywtype")));
                fm1465.setField0002(String.valueOf(data.get("ywtypename")));
                fm1465.setId(UUIDLong.longUUID());
                fm1465List.add(fm1465);
            }
            return fm1465List;
        }
    }
    static class ORG_PARSER implements XingjueDataParser<Formmain1468>{
        public List<Formmain1468> parseData(Map parseData) {
            List<Map> dataList = (List)parseData.get("resultset");
            if(CollectionUtils.isEmpty(dataList)){
                return null;
            }
            List<Formmain1468> fm1468List = new ArrayList<Formmain1468>();
            for(Map data:dataList){
                Formmain1468 fm1468 = new Formmain1468();
                fm1468.setField0001(String.valueOf(data.get("orgcode")));
                fm1468.setField0002(String.valueOf(data.get("orgname")));
                fm1468.setField0003(String.valueOf(data.get("orgtype")));
                fm1468.setField0004(String.valueOf(data.get("preorgcode")));
                fm1468.setId(UUIDLong.longUUID());
                fm1468List.add(fm1468);

            }
            return fm1468List;
        }
    }
    static class CUSTOM_PARSER implements XingjueDataParser<Formmain1466>{
        public List<Formmain1466> parseData(Map parseData) {
            List<Map> dataList = (List)parseData.get("resultset");
            if(CollectionUtils.isEmpty(dataList)){
                return null;
            }

            List<Formmain1466> fm1466List = new ArrayList<Formmain1466>();
            for(Map data:dataList){
                Formmain1466 fm1466 = new Formmain1466();
                fm1466.setField0001(String.valueOf(data.get("orgcode")));
                fm1466.setField0002(String.valueOf(data.get("etpcode")));
                fm1466.setField0003(String.valueOf(data.get("etpname")));
                fm1466.setField0004(String.valueOf(data.get("address")));
                fm1466.setField0005(String.valueOf(data.get("linkman")));
                fm1466.setField0006(String.valueOf(data.get("lkmtel")));
                fm1466.setId(UUIDLong.longUUID());
                fm1466List.add(fm1466);
            }
            return fm1466List;
        }
    }
    static class COMMODITY_PARSER implements XingjueDataParser<Formmain1467>{
        public List<Formmain1467> parseData(Map parseData) {
            List<Map> dataList = (List)parseData.get("resultset");
            if(CollectionUtils.isEmpty(dataList)){
                return null;
            }
            List<Formmain1467> fm1467List = new ArrayList<Formmain1467>();
            for(Map data:dataList){
                Formmain1467 fm1467 = new Formmain1467();

                fm1467.setField0001(String.valueOf(data.get("pluid")));
                fm1467.setField0002(String.valueOf(data.get("plucode")));
                fm1467.setField0003(String.valueOf(data.get("pluname")));
                fm1467.setField0004(String.valueOf(data.get("barcode")));
                fm1467.setField0005(String.valueOf(data.get("unit")));
                fm1467.setField0006(String.valueOf(data.get("spec")));
                fm1467.setField0007(String.valueOf(data.get("pluweight")));
                fm1467.setField0008(String.valueOf(data.get("pluheight")));
                fm1467.setField0009(String.valueOf(data.get("plulong")));
                fm1467.setField0010(String.valueOf(data.get("pluwidth")));
                fm1467.setField0011(String.valueOf(data.get("cargono")));
                fm1467.setField0012(String.valueOf(data.get("clsid")));
                fm1467.setField0016(String.valueOf(data.get("bzdays")));
                fm1467.setField0014(String.valueOf(data.get("brandcode")));
                fm1467.setField0017(String.valueOf(data.get("isweight")));
                fm1467.setField0018(String.valueOf(data.get("iskc")));
                fm1467.setId(UUIDLong.longUUID());
                fm1467List.add(fm1467);
            }
            return fm1467List;
        }
    }

    private static final WAREHOUSE_PARSER WAREHOUSE_PARSER_INSTANCE = new WAREHOUSE_PARSER();
    private static final BILL_PARSER BILL_PARSER_INSTANCE = new BILL_PARSER();
    private static final ORG_PARSER ORG_PARSER_INSTANCE = new ORG_PARSER();
    private static final CUSTOM_PARSER CUSTOM_PARSER_INSTANCE = new CUSTOM_PARSER();
    private static final COMMODITY_PARSER COMMODITY_PARSER_INSTANCE = new COMMODITY_PARSER();
}
