<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="Collaborationheader.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
<!-- 
	function exportExcel() {
		parent.exportExcelWorkflowStat();
	}
	
	function popprint() {
		var printContentBody = "";
		var cssList = new ArrayList();
		var pl = new ArrayList();
		var contentBody = "" ;
		var contentBodyFrag = "" ;
		
		//OA-33946 使用clone的方法将表格分页插件隐藏掉
		var clonePrint = $("#print").clone();
		clonePrint.find("tfoot").remove();
		contentBody = clonePrint.html();
		contentBodyFrag = new PrintFragment(printContentBody, contentBody);
		pl.add(contentBodyFrag);
		
		cssList.add("/seeyon/common/skin/default/skin.css");
		
		printList(pl,cssList);
	}
	$(document).ready(function(){//IE7下如果只是scroll=yes,会出无谓的横向滚动条,只能这样了
			if($.browser.msie&&$.browser.version=="7.0"){
			$("body").css({"overflow-x":"hidden","overflow-y":"auto",height:"100%"});
			}else if($.browser.msie&&$.browser.version=="10.0"){
				$("body").prop("scroll","yes");
				initIe10AutoScroll('print',0);
			}else{
				$("body").prop("scroll","yes");
			}
	})

//-->
</script>

<body class="page_color" onkeydown="listenerKeyESC()" >
<c:set var="appType" value="${v3x:getApplicationCategoryName(param.appType==-1?appType:param.appType, pageContext) }"/>
    	<table width="100%" height="50px" border="0" cellspacing="0" cellpadding="0">
			<tr height="26px;">
			<td class="PopupTitle">
				${searchScope }-${template }(${stateStr })
			</td>
				<td>
					<div class="div-float-right" style="margin-right: 70px; display: block;" >
						<table>
							<tr>
								<td>
									<span id="ExcportExcel1Div" title="<fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' />" style="width: 16px; height: 16px; display: block;" class="export_excel_16 ico16 margin_r_5" onclick='javascript:exportExcel()'></span>			
								</td>
								<td>
									<a onclick="exportExcel()"><fmt:message key='common.export.excel' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
								</td>
								<td>
									<span id="printButton1Div" title="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" class="ico16 print_16 margin_r_5" style="display: block;" onclick='popprint()'></span>
								</td>
								<td>
									<a onclick="popprint()"><fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' /></a>
								</td>
							</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
		<div id="print" class="margin_lr_10">
		<form>
		<v3x:table data="results" var="result" width="100%" dragable="false" pageSize="20" >
			<v3x:column width="25%" align="left" type="String" label="common.subject.label" alt="${result[2]}">${result[2] }</v3x:column>
			<v3x:column width="" align="left" type="String" label="common.sender.label" value="${v3x:showMemberName(result[1])}"></v3x:column>
			<c:if test="${state!=-1}">
				<fmt:formatDate value="${result[3]}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm" var="createTime"/>
				<v3x:column width="" align="left" type="String" label="common.date.sendtime.label" alt="${createTime}">
					${createTime }
				</v3x:column>
			</c:if>
			<c:if test="${state!=2 }">
				<v3x:column width="" align="left" type="String" label="common.workflow.handler" alt="${v3x:showMemberName(result[8])}">
					${v3x:showMemberName(result[8])}
				</v3x:column>
			</c:if>
			<c:if test="${state==3 or state==-1 }">
				<fmt:formatDate value="${result[6]}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm" var="receiveTime"/>
				<v3x:column width="" align="left" type="String" label="col.time.receive.label" alt="${receiveTime}">
					${receiveTime }
				</v3x:column>
			</c:if>
			<c:if test="${state==4 or state==-1}">
				<fmt:formatDate value="${result[7]}" type="both" dateStyle="full" pattern="yyyy-MM-dd HH:mm" var="completeTime"/>
				<v3x:column width="" align="left" type="String" label="common.workflow.finish.date" alt="${completeTime}">
					${completeTime }
				</v3x:column>
			</c:if>
			<c:if test="${state==4 }">
				<v3x:column width="" align="left" type="String" label="common.workflow.dealTime.date" alt="${v3x:showDateByWork(result[10])}">
					${v3x:showDateByWork(result[10])}
				</v3x:column>
			</c:if>
			<c:if test="${state==-1 }">			
				<v3x:column width="" type="String" label="${ctp:i18n('collaboration.timeouts.label')}" >
					${v3x:showDateByWork(result[9])}
				</v3x:column>
			</c:if>
			<c:if test="${state!=1 and state!=2}">
				<v3x:column width="" type="String" label="col.metadata_item.process.date" >
					${v3x:showDateByNature(result[5])}
				</v3x:column>
			</c:if>
			<v3x:column width="" align="center" type="String" label="col.isFinshed.label">
				<fmt:message key="common.${result[4]!=null}" bundle="${v3xCommonI18N}" />
			</v3x:column>
		</v3x:table>
		</form>
		</div>
	<br>
<iframe name="temp_iframe" id="temp_iframe" style="display: none;">&nbsp;</iframe>
</body>
</html>