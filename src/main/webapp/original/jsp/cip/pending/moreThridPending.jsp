<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/plugin/nc/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>    
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
var sectionName="${param.sectionName}";
getA8Top().showMoreSectionLocation(sectionName);
function openPending(providerId,url){
	try{
		this.onfocus = function(){
			this.location.href = this.location.href;
		};
		v3x.openWindow({url:url,workSpace:true,scrollbars:false,resizable:'false',dialogType:'open'})
	}
	catch(e){
		alert(e.message)
	}
}

initIe10AutoScroll("scrollListDiv",40);
</script>
<title></title>
</head>
<body srcoll="no" style="overflow: hidden">
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" id="listForm" method="post">  
			<v3x:table htmlId="ncPendingTable" showPager="true" data="Pendings" var="p" className="sort ellipsis">
				<v3x:column width="50%" type="String" label="common.subject.label" value="${p.title}" alt="${p.title}"
					onClick="openPending('${providerId }','${p.url}')" className="cursor-hand sort"/>
				<v3x:column width="15%" type="String" label="common.category.label" value="${p.classify}" />
				<v3x:column width="20%" type="Date" label="common.date.sendtime.label">
					<fmt:formatDate value="${p.creationDate}" pattern="${datetimePattern}"/>
				</v3x:column>
				<v3x:column width="15%" type="String" label="common.sender.label" value="${p.senderName}" />

			</v3x:table>
		</form>
    </div>
</body>
</html>
