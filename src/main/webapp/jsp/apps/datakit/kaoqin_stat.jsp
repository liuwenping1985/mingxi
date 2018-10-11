<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>考勤统计</title>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
    <%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>
    <fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
    <fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
    <fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
    <fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"  var="v3xEdocI18N"/>
    <link type="text/css" href="/seeyon/common/css/common-debug.css?V=V5_80_2017-07-28" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
    <link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/stat.css${v3x:resSuffix()}" />">

    <script type="text/javascript" src="/seeyon/common/js/ui/calendar/calendar-zh_CN.js?V=V5_80_2017-07-28"></script>
    <script>
        var _ctxPath = '/seeyon';
    </script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-1.11.3.min.js" />"></script>
    <link href="/seeyon/apps_res/rikaze/jqui/jquery-ui.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" charset="UTF-8" src="/seeyon/apps_res/rikaze/jqui/jquery-ui.js"></script>
    <script type="text/javascript" charset="UTF-8" src="/seeyon/apps_res/rikaze/jqui/dp_zh_cn.js"></script>


</head>
<body >

　<center><h2>考勤统计表（开始时间-结束时间）</h2></center>
<div>
    统计条件： 开始时间:<input id="startDate" class="datepicker" type="text">  结束时间:<input class="datepicker"  id="endDate" type="text">

</div>

<table class="stat_table">
    <thead class="stat_thead">
    <tr><td rowspan="2">序号</td>
        <td rowspan="2">姓名</td>
        <td rowspan="2">部门</td>
        <td rowspan="2">请假次数</td>
        <td rowspan="2">请假天数</td>
        <td colspan="7">请假类型（次数）</td>
        <td colspan="7">请假类型（天数）</td>
        <td rowspan="2" style="text-align:top;">备注</td>
    </tr>
    <tr>
        <td>休假</td>
        <td>病假</td>
        <td>产假（护理假）</td>
        <td>丧假</td>
        <td>婚假</td>
        <td>事假</td>
        <td>因公外出</td>

        <td>休假</td><td>病假</td><td>产假（护理假）</td><td>丧假</td><td>婚假</td><td>事假</td><td>因公外出</td>
    </tr>
    </thead>
    <tbody class="stat_body" id="body_data">

    </tbody>



</table>
<script>



    $(document).ready(function(){
        $(".datepicker").datepicker({
            language: 'zh-CN',
            autoclose: true,
            todayHighlight: true
        });

        var seq_types = ["-2014878666199710129","2419948774269406145","-5165953433318177465", "1473013248361449610","8173490199372843815","4723733551924793225","4858874681520769516"];
        var out_types_={
            "8173490199372843815":"婚假",
            "4858874681520769516":"因公外出",
            "1473013248361449610":"丧假",
            "-2014878666199710129":"休假",
            "4723733551924793225":"事假",
            "-5165953433318177465":"产假（护理假）",
            "2419948774269406145":"病假"
        };
        var stat_msg = {
            "婚假":[],
            "因公外出":[],
            "丧假":[],
            "休假":[],
            "事假":[],
            "产假（护理假）":[],
            "病假":[],
            "user_count":0
        }
        function getTypeData(typeId,item){
            var datas = item["dataDays"]||item["allDays"];
            datas = datas[out_types_[typeId]];
            if(datas==null){
                return "0";
            }
            return ""+datas;

        }
        function getTypeFreqData(typeId,item){
            var datas = item["dataFreq"]||item["allFreq"];
            datas = datas[out_types_[typeId]];

            if(datas==null){
                return "0";
            }

            return ""+datas;
        }
        function getStat(data){
            var htmls = [];
            var stat = data.statData;
            var cp = data.cleanPerson;
            htmls.push("未休假");
            htmls.push("("+cp.length+")人:");
            htmls.push(cp.join(","));
            for(p in stat){
                htmls.push("<br>"+p);
                htmls.push("("+stat[p].length+")人:");
                htmls.push(stat[p].join(","));
            }
            return htmls.join("");
        }
        $.get("/seeyon/rikaze.do?method=getStatKaoqinData",function(datas){

            var  items = datas.items;
            if(items&&items.length>0){


                var htmls =[];
                var cls = "even";
                $(items).each(function(index,item){
                    if(index%2==0){
                        cls="odd";
                    }else{
                        cls="even";
                    }

                    htmls.push("<tr class='"+cls+"'>");
                    htmls.push("<td>"+(index+1)+"</td>");
                    htmls.push("<td>"+item.userName+"</td>");
                    htmls.push("<td>"+item.deptName+"</td>");
                    htmls.push("<td>"+item.freq+"</td>");
                    htmls.push("<td>"+item.days+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[0],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[1],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[2],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[3],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[4],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[5],item)+"</td>");
                    htmls.push("<td>"+getTypeFreqData(seq_types[6],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[0],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[1],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[2],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[3],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[4],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[5],item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[6],item)+"</td>");
                    if(index ==0){
                        htmls.push("<td  id='memo' rowspan='999'></td>");
                    }
                    htmls.push("</tr>");
                });
                //heji
                htmls.push("<tr class='stat_total'>");
                htmls.push("<td colspan='3'>合计</td>");
                htmls.push("<td>"+datas.freq+"</td>");
                htmls.push("<td>"+datas.days+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[0],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[1],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[2],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[3],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[4],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[5],datas)+"</td>");
                htmls.push("<td>"+getTypeFreqData(seq_types[6],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[0],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[1],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[2],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[3],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[4],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[5],datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[6],datas)+"</td>");

                htmls.push("</tr>");
                $("#body_data").html(htmls.join(""));
                $("#memo").html(getStat(datas));

            }

        });


    });
</script>
</body>
</html>