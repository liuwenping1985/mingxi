<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="header.jsp"%>
    <link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--
function openNCPending(id,a,b){
	try{
		//刷新NC待办事项
		this.onfocus = function(){
			this.location.href = this.location.href;
		};
		getA8Top().openNCPending(id,a,b);
	}
	catch(e){
		//alert(e.message)
	}
}
//-->
</script>
<title>NC待办事项-更多</title>
</head>
<body srcoll="no" style="overflow: hidden">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
		     	<tr class="page2-header-line">
		       			<td width="45" class="page2-header-img"><div class="notepager"></div></td>
						<td id="notepagerTitle1" class="page2-header-bg">&nbsp;<c:choose>
			        <c:when test="${sectionFlag}">ERP<fmt:message key='u8.schedule.collaboration_listDone'/></c:when>
				    <c:otherwise>ERP<fmt:message key='u8.schedule.pending'/></c:otherwise>
				    </c:choose></td>
						<td class="page2-header-line padding-right" align="right" id="back"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
			        </tr>
			 </table>
		</td>
	</tr>
</table>	
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="post">  
			<v3x:table htmlId="ncPendingTable" showPager="true" data="NCPendings" var="p" className="sort ellipsis">
				<v3x:column width="50%" type="String" label="common.subject.label" value="${p.title}" alt="${p.title}"
					onClick="openNCPending('${p.messagePK}', '${p.userCode}', '${p.unitCode}')" className="cursor-hand sort"/>
				<v3x:column width="20%" type="Date" label="common.date.sendtime.label">
					<fmt:formatDate value="${p.sendeDate}" pattern="${datePattern}"/>
				</v3x:column>
				<v3x:column width="15%" type="String" label="common.sender.label" value="${p.senderName}" />

				<v3x:column width="15%" type="String" label="common.type.label" value="${p.type}" />
				
			</v3x:table>
		</form>
    </div>
  </div>
</div>
</body>
</html>
<script>
	//设置数据显示div的px高度
	initIe10AutoScroll("scrollListDiv",40);
</script>