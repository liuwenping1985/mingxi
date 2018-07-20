<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

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


</style>
</head>
<body style="overflow-y:hidden;">
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
	<div  id="statTitle" align="center" class="padding_tb_5" style="font-size:13px;">${conditionVo.statTitle }</div>
</div>
<table class="xl_table_thead" border="0" cellSpacing="0" cellPadding="0">   	
 		<thead>
      		<tr>
           		<td rowspan="2" style="width:260px;">单位</td>
		     	<td rowspan="2" class="xl_thead_num">发文总数</td>
                <c:if test="${conditionVo.statSetVo.sfShowTwo}">  
                	<td colspan="2">2个工作日内签收</td>
                </c:if>
                <c:if test="${conditionVo.statSetVo.sfShowThree}">  
                	<td colspan="2">3至5个工作日内签收</td>
                </c:if>
                <c:if test="${conditionVo.statSetVo.sfShowFive}">  
                	<td colspan="2">5个工作日后签收</td>
                </c:if>
                <c:if test="${conditionVo.statSetVo.sfShowNoRec}">  
                	<td colspan="2">仍未签收</td>
                </c:if>
      		</tr>
            <tr class="xl_thead_title">
               	<c:if test="${conditionVo.statSetVo.sfShowTwo}"> 
               		<td>数量</td>
               		<td>百分比</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.sfShowThree}"> 
               		<td>数量</td>
               		<td>百分比</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.sfShowFive}"> 
               		<td>数量</td>
               		<td>百分比</td>
               	</c:if>
               	<c:if test="${conditionVo.statSetVo.sfShowNoRec}"> 
               		<td>数量</td>
               		<td>百分比</td>
               	</c:if>
           	</tr>
        </thead>
</table>
<div class="xl_auto_height" style="overflow:auto;">
	<table class="xl_table_tbody" border="0" cellSpacing="0" cellPadding="0">       
		<tbody>		 	
			<c:forEach items="${statVoList}" var="statVo" varStatus="status">
				<c:set var="allNum" value="${statVo.allNum }" />
				<tr>
					<%-- 单位 --%>
					<td style="width:260px;" title="${statVo.displayName }">
						${statVo.displayName }
					</td>
					<%-- 发文总数 --%>
					<td class="xl_tbody_num">${statVo.allNum }</td>	
					<c:if test="${conditionVo.statSetVo.sfShowTwo }"> 
						<td>${statVo.twoSign }</td>
						<td>${statVo.twoSignPer}</td>
					</c:if>
					<%-- 2个工作日内接收--%>
					<c:if test="${conditionVo.statSetVo.sfShowThree }"> 
						<td>${statVo.threeSign }</td>
						<td>${statVo.threeSignPer }</td>	
					</c:if>
					<%-- 3至5个工作日内接收--%>
					<c:if test="${conditionVo.statSetVo.sfShowFive }"> 
						<td>${statVo.fiveSign }</td>
						<td>${statVo.fiveSignPer }</td>	
					</c:if>
					<%-- 5个工作日后内接收--%>
					<c:if test="${conditionVo.statSetVo.sfShowNoRec }"> 					
					 	<td>${statVo.noRecSignNum }</td>
					 	<td>${statVo.noRecSignNumPer }</td>
					</c:if>
				</tr>
			</c:forEach>
		</tbody>
	</table> 
</div>
<script>
	$(function(){
		//发文总数的头部和body的宽度保持一致
		var width1=$(".xl_thead_num").css("width");
		$(".xl_tbody_num").css("width",width1);
		//其他表头内容和对应的body数据宽度保持一致
		var thead_td=$(".xl_thead_title td");
		var tbody_tr=$(".xl_table_tbody tr").get(0);
		if(tbody_tr!=undefined){
			var tbody_tds = tbody_tr.children;
			for(var i=0;i<thead_td.length;i++){
				var width=thead_td[i].offsetWidth;
				tbody_tds[i+2].setAttribute("width",width);		
			}
		}
		//获得父页面的iframe的高度，计算出body数据div的高度
		var iframe=(window.parent.document.getElementById("statResultIframe"));
		var height1=iframe.clientHeight-28-48;
		$(".xl_auto_height").css("height",height1+"px");
		//点击上下按钮后重新计算高度
		setInterval(function(){
			var height2=iframe.clientHeight-28-48;
			if(height2!=height1){
				$(".xl_auto_height").css("height",height2+"px");
			}
			var height1=iframe.clientHeight-28-48;	
		},50);
	})
</script>
</body>
</html>