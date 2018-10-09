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
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
    <link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-1.11.3.min.js" />"></script>

</head>
<body srcoll="no" style="overflow: hidden;border:0;" class="tab-body">

　<center><h2>考勤统计表（开始时间-结束时间）</h2></center>
<div>统计条件： 开始时间:<input type="text"> 结束时间:<input type="text"> </div>状态：<select>
    <option value="222">已报备</option>
    <option value="333">待报备</option>
    <option value="444">待处理</option>

</select>
<table border="1">

    <tr><td rowspan="2">序号</td>
        <td rowspan="2">姓名</td>
        <td rowspan="2">部门</td>
        <td colspan="7">请假类型（次数）</td>
        <td colspan="7">请假类型（天数）</td>
        <td rowspan="2">备注</td>
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
    <tbody id="body_data">
    <tr>
        <td>

        </td>
    </tr>
    </tbody>


</table>
<script>



    $(document).ready(function(){
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
            var datas = item.data[out_types_[typeId]];
            if(datas==null){
                return "0";
            }
            var num=0;
            for(var p=0;p<datas.length;p++){
                var data = datas[p];
                if(data.typeId==typeId){
                    num=num+data.num;
                }
            }
            if(num == 0){
                return "0";
            }
            return ""+num;

        }
        function getTypeFreqData(typeId,item){
            var datas = item.data[out_types_[typeId]];

            if(datas==null){
                return "0";
            }
            var num=0;
            for(var p=0;p<datas.length;p++){
                var data = datas[p];
                if(data.typeId==typeId){
                    num=num+1;
                }
            }
            if(num == 0){
                return "0";
            }
            return ""+num;
        }
        function getStat(){

            return "";
        }
        $.get("/seeyon/rikaze.do?method=getStatKaoqinData",function(datas){

            var  items = datas.items;
            if(items&&items.length>0){
                console.log(datas);
                stat_msg.user_count=datas.userCount;
                var htmls =[];

                $(items).each(function(index,item){
                    htmls.push("<tr>");
                    htmls.push("<td>"+(index+1)+"</td>");
                    htmls.push("<td>"+item.userName+"</td>");
                    htmls.push("<td>"+item.deptName+"</td>");
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
                        htmls.push("<td id='memo' rowspan='999'></td>");
                    }
                    htmls.push("</tr>");
                });
                $("#body_data").html(htmls.join(""));
                $("#memo").html(getStat());

            }

        });


    });
</script>
</body>
</html>