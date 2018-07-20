<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/docstat/govdoc_stat_result.js${v3x:resSuffix()}" />"></script>
<title></title>
<style type="text/css">
/*xl 6-27*/
div,p,table,tbody{
    padding:0;
    margin:0;
    font-size:12px;
    color:#111;
}
.xl_table_thead{
	width:100%;
	background-color:rgb(181, 219, 235);
	border-collapse:collapse;
}
.xl_table_thead td{
	height:22px;
	line-height:22px;
	text-align:center;
	border:1px solid #fff;
}
.xl_table_tbody{
	width:100%;
}
.xl_table_tbody td{
	height:28px;
	line-height:28px;
	text-align:center;
}
.xl_table_tbody tr:nth-child(even){
	background-color:rgb(247,247,247);
}
.xl_table_tbody tr:hover{
	background-color:#ebfafb;
}
#center>div{
	overflow:auto;
	width:100%;
}
</style>
<script>
	var _ctxPath = '${path}';
	var edocStatUrl = _ctxPath+"/edocStatNew.do";
</script>
</head>
<body overflow-y:hidden; >
<input type="hidden" name="statId" id="statId" value="${conditionVo.statId }">
<input type="hidden" name="statType" id="statType" value="${conditionVo.statType }">
<input type="hidden" name="statRangeId" id="statRangeId" value="${conditionVo.statRangeId }">
<input type="hidden" name="statRangeType" id="statRangeType" value="${conditionVo.statRangeType }">
<input type="hidden" name="docMark" id="docMark" value="${conditionVo.docMarkDefId }">
<input type="hidden" name="docMark_txt" id="docMark_txt" value="${conditionVo.docMark }">
<input type="hidden" name="serialNo" id="serialNo" value="${conditionVo.serialNoDefId }">
<input type="hidden" name="serialNo_txt" id="serialNo_txt" value="${conditionVo.serialNo }">
<input type="hidden" name="startTime" id="startTime" value="${conditionVo.startTime }">
<input type="hidden" name="endTime" id="endTime" value="${conditionVo.endTime }">

<div>
	<div id="statTitle" align="center" class="padding_tb_5" style="font-size:13px;">${conditionVo.statTitle }</div>
</div>

<div id="center" >

<table class="xl_table_thead" border="0" cellSpacing="0" cellPadding="0">   	
 		<thead>
			<tr id="${conditionVo.statRangeName}">
       			<td class="xl_thead_unit" style="width:120px;" rowspan="2">${conditionVo.statRangeName}</td>
	   			<c:if test="${conditionVo.statSetVo.showSend}">
           			<td colspan="${conditionVo.statSetVo.sendTdSize}">发文</td>
            	</c:if>
             	<c:if test="${conditionVo.statSetVo.showRec}">
            		<td colspan="${conditionVo.statSetVo.recTdSize}">收文</td>
            	</c:if>
             	<c:if test="${conditionVo.statSetVo.showTotal}">
            		<td colspan="${conditionVo.statSetVo.totalTdSize}">总计</td>
            	</c:if>
        	</tr>
          	<tr class="xl_thead_title">
            	<c:if test="${conditionVo.statSetVo.showSendCount}"> 
               		<td>发文数</td>
               	</c:if>
                <c:if test="${conditionVo.statSetVo.showFontSize}"> 
               		<td>字数</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.showSendDCount}"> 
               		<td>已办结</td>
               	</c:if> 
               	<c:if test="${conditionVo.statSetVo.showSendPCount}"> 
              		<td>办理中</td>
              	</c:if>
                <c:if test="${conditionVo.statSetVo.showSendDPer}"> 
               		<td>办结率</td>
               	</c:if>
              	<c:if test="${conditionVo.statSetVo.showSendOCount}"> 
               		<td>超期件数</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.showSendOper}"> 
               		<td>超期率</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.showRecCount}"> 
               		<td>收文数</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.showRecDCount}"> 
               		<td>已办结</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.showRecPCount}"> 
               		<td>办理中</td>
               	</c:if>
	            <c:if test="${conditionVo.statSetVo.showRecDper}"> 
	               	<td>办结率</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showRecOCount}"> 
	               	<td>超期件数</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showRecOper}"> 
	               	<td>超期率</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllCount}"> 
	              	<td>总计</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllDCount}"> 
	             	<td>已办结</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllPCount}"> 
	              	<td>办理中</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllDPer}"> 
	             	<td>办结率</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllOCount}"> 
	                <td>超期件数</td>
	            </c:if>
	            <c:if test="${conditionVo.statSetVo.showAllOper}"> 
	                <td>超期率</td>
	            </c:if>
            </tr>
     	</thead>
</table>
	<div>
	<table class="xl_table_tbody" border="0" cellSpacing="0" cellPadding="0" style="overflow:auto;">		
		<tbody scroll="auto" id="dataList">	
		<c:forEach items="${statVoList}" var="statVo" varStatus="status">
		    <tr displayId="${statVo.displayId }" sfClickOn ="${statVo.sfClickOn }" displayType="${statVo.displayType }" displayName="${statVo.displayName }">
               	
               	<td class="xl_tbody_unit" style="width:120px;">${statVo.displayName }</td> 
               	<%-- 发文数 --%>
               	<c:if test="${conditionVo.statSetVo.showSendCount}"> 
               		<td><a listType="1" href="javascript:void(0);">${statVo.sendCount }</a></td>
              	</c:if>
              	<%-- 发文字数--%>
               	<c:if test="${conditionVo.statSetVo.showFontSize}"> 
               		<td>${statVo.fontSize }</td>
               	</c:if>
               	<%-- 发文已办结 --%>
               	<c:if test="${conditionVo.statSetVo.showSendDCount}"> 
               		<td><a listType="3" href="javascript:void(0);">${statVo.sendDoneCount }</a></td>
               	</c:if>
               	<%-- 发文办理中 --%>
               	<c:if test="${conditionVo.statSetVo.showSendPCount}"> 
               		<td><a listType="2" href="javascript:void(0);">${statVo.sendPendingCount }</a></td>
               	</c:if>
               	<%-- 发文办结率 --%>
               	<c:if test="${conditionVo.statSetVo.showSendDPer}"> 
               		<td>${statVo.sendDonePer }</td>
               	</c:if>
               	<%-- 发文超期件数 --%>
               	<c:if test="${conditionVo.statSetVo.showSendOCount}"> 
               		<td><a listType="4" href="javascript:void(0);">${statVo.sendOverCount }</a></td>
               	</c:if>
               	<%-- 发文超期率 --%>
               	<c:if test="${conditionVo.statSetVo.showSendOper}"> 
               		<td>${statVo.sendOverPer }</td>
               	</c:if>
               	<%-- 收文数 --%>
               	<c:if test="${conditionVo.statSetVo.showRecCount}"> 
               		<td><a listType="5" href="javascript:void(0);">${statVo.recCount }</a></td>
               	</c:if>
               	<%-- 收文已办结 --%>
               	<c:if test="${conditionVo.statSetVo.showRecDCount}"> 
               		<td><a listType="7" href="javascript:void(0);">${statVo.recDoneCount }</a></td>
               	</c:if>
               	<%-- 收文办理中 --%>
               	<c:if test="${conditionVo.statSetVo.showRecPCount}"> 
               		<td><a listType="6" href="javascript:void(0);">${statVo.recPendingCount }</a></td>
               	</c:if>
               	<%-- 收文办结率 --%>
               	<c:if test="${conditionVo.statSetVo.showRecDper}"> 
               		<td>${statVo.recDonePer }</td>
               	</c:if>
               	<%-- 收文超期件数 --%>
               	<c:if test="${conditionVo.statSetVo.showRecOCount}"> 
               		<td><a listType="8" href="javascript:void(0);">${statVo.recOverCount }</a></td>
               	</c:if>
               	<%-- 收文超期率 --%>
               	<c:if test="${conditionVo.statSetVo.showRecOper}"> 
               		<td>${statVo.recOverPer }</td>
               	</c:if>
               	<%-- 总计 --%>
              	<c:if test="${conditionVo.statSetVo.showAllCount}"> 
               		<td><a listType="9" href="javascript:void(0);">${statVo.allCount }</a></td>
               	</c:if>
               	<%-- 已办结 --%>
               	<c:if test="${conditionVo.statSetVo.showAllDCount}"> 
               		<td><a listType="11" href="javascript:void(0);">${statVo.allDoneCount }</a></td>
               	</c:if>
               	<%-- 办理中 --%>
               	<c:if test="${conditionVo.statSetVo.showAllPCount}"> 
               		<td><a listType="10" href="javascript:void(0);">${statVo.allPendingCount }</a></td>
               	</c:if>
               	<%-- 办结率 --%>
               	<c:if test="${conditionVo.statSetVo.showAllDPer}"> 
               		<td>${statVo.allDonePer }</td>
               	</c:if>
               	<%-- 超期件数 --%>
               	<c:if test="${conditionVo.statSetVo.showAllOCount}"> 
               		<td><a listType="12" href="javascript:void(0);">${statVo.allOverCount }</a></td>
               	</c:if>
               	<%-- 超期率 --%>
               	<c:if test="${conditionVo.statSetVo.showAllOper}"> 
               		<td>${statVo.allOverPer}</td>
               	</c:if>
               </tr>
           </c:forEach>            
		</tbody>
	</table>
	</div>
</div>
<script>
	$(function(){
		//点击上下按钮后重新计算高度
		setInterval(function(){
			var height2=iframe.clientHeight-28-48;
			if(height2!=height1){
				$("#center>div").css("height",height2+"px");
			}
			var height1=iframe.clientHeight-28-48;
			var height3=parseInt($("#center>div").css("height"));
			var height4=parseInt($(".xl_table_tbody").css("height"));
			if(height4>height3){
				$(".xl_table_thead").css("width","99%");
			}else if(height4<=height3){
				$(".xl_table_thead").css("width","100%");
			}
		},50);
			
		
		//其他表头内容和对应的body数据宽度保持一致
		var thead_td=$(".xl_thead_title td");
		var tbody_tr=$(".xl_table_tbody tr").get(0);
		if(tbody_tr!=undefined){
			var tbody_tds = tbody_tr.children;
			for(var i=0;i<thead_td.length;i++){
				var width=thead_td[i].offsetWidth;
				tbody_tds[i+1].setAttribute("width",width);		
			}
		}
		//获得父页面的iframe的高度，计算出body数据div的高度
		var iframe=(window.parent.document.getElementById("statResultIframe"));
		var height1=iframe.clientHeight-28-48;
		$("#center>div").css("height",height1+"px");
				
	})
</script>
</body>
</html>