<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>表单查询</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script>
function tab(id,name){
    var url = "${path}/form/queryResult.do?method=queryStatisticsTab&type=${type}&formMasterId=${formMasterId}&id="+id;
    if (${type ne "query"}){
        url = "${path}/report/queryReport.do?method=getContent&formMasterId=${formMasterId}&reportId="+id;
    }
    $("#tab_iframe").attr("src",url);
     $("#id").val(id);
     $("#name").val(name);
}

$().ready(function(){
		var type = "${type}";
		if(type == "query"){
			var tt = $("#toolbar").toolbar({
	            toolbar: [{
	                id: "export",
	                name: "${ctp:i18n('calendar.event.create.out')}",
	                className: "ico16 export_excel_16",
	               click : exportToExcel
	            }]
	        });       
		}
        
});

function exportToExcel(){
	$("#queryExcel").attr("action","queryResult.do?method=exportToExcel&type=${type}&formMasterId=${formMasterId}&id="+$("#id").val()+"&name="+$("#name").val());
    $("#queryExcel").jsonSubmit();
}
</script>
</head>
<body class="h100b overflow_hidden page_color margin_5 padding_t_5" id="layout1">
	<div id="toolbar"></div>
    <div class="comp" id="tabs" comp="type:'tab',width:800,height:800,parentId:'layout1'">
        <div class="common_tabs clearfix" id="tabs_head">
             <ul class="left">
                 <c:forEach var="data" items="${datas}" varStatus="status">
                   <li <c:if test="${status.first}">class="current"</c:if>>
                     <a hidefocus="true" style="max-width:1000px" href="javascript:void(0)" tgt="tab_iframe" onclick="tab('${data.id}','${data.name }')" title="${data.name}"><span>${data.name}</span></a>
                   </li>
                 </c:forEach>
             </ul>
        </div>
        <div class="common_tabs_body " id="tabs_body">
            <iframe width="100%" id="tab_iframe" src="" border="0" frameborder="no"></iframe>
        </div>
    </div>
    <form id="queryExcel" action="#" method="post">
        <input type="hidden" id="id" name="id" /> 
        <input type="hidden" id="name" name="name" /> 
   </form>
</body>
</html>