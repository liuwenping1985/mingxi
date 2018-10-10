<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>培训统计</title>
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
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/stat.css${v3x:resSuffix()}" />">

    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-1.11.3.min.js" />"></script>

</head>
<body class="tab-body">

　<center><h2>培训统计表（开始时间-结束时间）</h2></center>
<div>统计条件： 开始时间:<input type="text"> 结束时间:<input type="text"> </div>
<table border="1" bordercolor="#a0c6e5" style="border-collapse:collapse;">

    <tr><td rowspan="2">序号</td>
        <td rowspan="2">姓名</td>
        <td rowspan="2">部门</td>
        <td rowspan="2">培训次数</td>
        <td rowspan="2">培训天数</td>
        <td colspan="7">培训层次（次数）</td>
        <td colspan="5">培训类型（次数）</td>
        <td colspan="7">培训层次（天数）</td>
        <td colspan="5">培训类型（天数）</td>
        <td rowspan="2">备注</td>
    </tr>
    <tr>
        <td>国家级培训</td>
        <td>自治区级培训</td>
        <td>市级培训</td>
        <td>县级培训</td>
        <td>援藏培训</td>
        <td>自主举办培训</td>
        <td>网络培训</td>
        <td>政治思想教育类培训</td>
        <td>党建党务类培训</td>
        <td>纪检监察业务类培训</td>
        <td>其他业务类培训</td>
        <td>其他</td>
        <td>国家级培训</td>
        <td>自治区级培训</td>
        <td>市级培训</td>
        <td>县级培训</td>
        <td>援藏培训</td>
        <td>自主举办培训</td>
        <td>网络培训</td>
        <td>政治思想教育类培训</td>
        <td>党建党务类培训</td>
        <td>纪检监察业务类培训</td>
        <td>其他业务类培训</td>
        <td>其他</td>
    </tr>
    <tbody id="body_data">

    </tbody>



</table>
<script>



    $(document).ready(function(){
        /**
         * {-3203190910465980700=自主举办培训, -3646567579836003063=其他培训, 4795598093938
344974=援藏培训, 3239652260461037825=国家级培训, -4546390016768391868=县级培训,
-4083841512309701729=网络培训, 8912639529675082349=市级培训, -323598044155083109
0=自治区级培训}

         {-3118376600552650498=纪检监察业务类培训, -9147574216199942221=党建党务类培训, -
5699958918363724500=其他业务类培训, 9098400304458910004=其他类培训, -24836338312
05057296=政治思想教育类培训}
         * @type {[*]}
         */
        var seq_level = ["国家级培训","自治区级培训","市级培训","县级培训", "援藏培训","自主举办培训","网络培训"];
        var seq_types = ["政治思想教育类培训","党建党务类培训","纪检监察业务类培训", "其他业务类培训","其他类培训"];
        function getTypeData(typeName,type,item){
            var data={};
            if(type=="freq"){
                data = item['typeFreqStat'];
            }else{
                data= item['typeDayStat'];
            }
           var num = data[typeName];
            if(num==null){
                return "0";
            }
            return num;

        }
        function getLevelData(typeName,type,item){
            var data={};
            if(type=="freq"){
                data = item['levelFreqStat'];
            }else{
                data= item['levelDayStat'];
            }
            var num = data[typeName];
            if(num==null){
                return "0";
            }
            return num;
        }
        function getStat(data){
            var htmls = [];
            var cp = data.cleanPerson;
            htmls.push("未参加培训");
            htmls.push("("+cp.length+")人:");
            htmls.push(cp.join(","));
            return htmls.join("");
        }
        $.get("/seeyon/rikaze.do?method=getPeixunStatData",function(datas){

            var  items = datas.items;
            if(items&&items.length>0){
                console.log(datas);
                var htmls =[];

                $(items).each(function(index,item){
                    htmls.push("<tr>");
                    htmls.push("<td>"+(index+1)+"</td>");
                    htmls.push("<td>"+item.userName+"</td>");
                    htmls.push("<td>"+item.deptName+"</td>");
                    htmls.push("<td>"+item.freq+"</td>");
                    htmls.push("<td>"+item.days+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[0],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[1],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[2],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[3],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[4],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[5],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[6],"freq",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[0],"freq",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[1],"freq",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[2],"freq",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[3],"freq",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[4],"freq",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[0],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[1],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[2],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[3],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[4],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[5],"day",item)+"</td>");
                    htmls.push("<td>"+getLevelData(seq_level[6],"day",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[0],"day",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[1],"day",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[2],"day",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[3],"day",item)+"</td>");
                    htmls.push("<td>"+getTypeData(seq_types[4],"day",item)+"</td>");
                    if(index ==0){
                        htmls.push("<td id='memo' rowspan='999'></td>");
                    }
                    htmls.push("</tr>");
                });
                //heji
                htmls.push("<tr>");
                htmls.push("<td colspan='3'>合计</td>");
                htmls.push("<td>"+datas.freq+"</td>");
                htmls.push("<td>"+datas.days+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[0],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[1],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[2],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[3],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[4],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[5],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[6],"freq",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[0],"freq",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[1],"freq",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[2],"freq",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[3],"freq",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[4],"freq",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[0],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[1],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[2],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[3],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[4],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[5],"day",datas)+"</td>");
                htmls.push("<td>"+getLevelData(seq_level[6],"day",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[0],"day",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[1],"day",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[2],"day",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[3],"day",datas)+"</td>");
                htmls.push("<td>"+getTypeData(seq_types[4],"day",datas)+"</td>");
                htmls.push("</tr>");
                $("#body_data").html(htmls.join(""));
                $("#memo").html(getStat(datas));

            }

        });


    });
</script>
</body>
</html>