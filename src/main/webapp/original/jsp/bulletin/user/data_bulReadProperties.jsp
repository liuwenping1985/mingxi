<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<style>
	#scrollList1{background:#fafafa;}
	#scrollList2{background:#fafafa;}
</style>
<script type="text/javascript">
	function modifyNum(){
		var mode = document.getElementById("mode").value;
		var div1 = document.getElementById('scrollList1');
		var div2 = document.getElementById('scrollList2');
		if(mode == "normal"){
			div1.style.display = "block";
			div2.style.display = "none";
			var table1 = document.getElementById('bDivbulreadcountId1');
			table1.style.overflowX = 'hidden';
			table1.style.borderLeft = '1px solid #e1e1e1';
			div1.style.height = "318px";
			div2.style.height = "318px";
//				parent.document.getElementById(array[j]+1).className="tab-tag-left-sel";
//				parent.document.getElementById(array[j]+2).className="tab-tag-middel-sel";
//				parent.document.getElementById(array[j]+3).className="tab-tag-right-sel";
		}else{
			div1.style.display = "none";
			div2.style.display = "block";
			var table2 = document.getElementById('bDivbulreadcountId2');
			table2.style.overflowX = 'hidden';
			table2.style.borderLeft = '1px solid #e1e1e1';
			div1.style.height = "318px";
			div2.style.height = "318px";
//				var theDocument=parent.document.getElementById(array[j]+1);
//				if(theDocument == null){
//					continue;
//				}else {
//					parent.document.getElementById(array[j]+1).className="tab-tag-left";
//					parent.document.getElementById(array[j]+2).className="tab-tag-middel";
//					parent.document.getElementById(array[j]+3).className="tab-tag-right";
//				}
		}
	}
	//子页面
	var i18nRemindSuccess = '<fmt:message key="bul.remind.success"/>',i18nRemindSelect = '<fmt:message key="bul.remind.please.select.member"/>';
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulRemind.js${v3x:resSuffix()}" />"></script>
</head>
<body onload="modifyNum()" style="height: 100%;"scrolling="no">
<form method="post" name="propertyMainForm" id="propertyMainForm" style="height: 100%;">
<input id="mode" type="hidden" value="${mode}">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr id="normalTR"  valign="top">
			<td>
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="scrollList" id="scrollList1">
								<c:if test="${mode=='normal'}">
								<v3x:table data="bulreadcount" var="bulrc" htmlId="bulreadcountId1" isChangeTRColor="false" showHeader="true" className="sort body-detail-table" showPager="true">
									<v3x:column type="String" label="bul.type.spaceType.1" className="sort font-12px" width="50%" value="${v3x:showOrgEntitiesOfIds(bulrc.deptId, 'Department', pageContext)}" alt="${v3x:showDepartmentFullPath(bulrc.deptId)}"/>
									<v3x:column type="String" label="bul.userName" className="sort font-12px" width="30%" value="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}"/>
									<v3x:column  type="Date" label="bul.read.readDate" className="sort font-12px" width="30%">
										<fmt:formatDate value="${bulrc.readDate}" pattern="${datePattern}"/>
									</v3x:column>
								</v3x:table>
								</c:if>
							</div>
							<iframe name="grantIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr id="borrowTR" valign="top">
			<td>
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<div class="scrollList" id="scrollList2">
								<c:if test="${mode=='borrow'}">
								<v3x:table data="bulnotreadcount" var="bulrc" htmlId="bulreadcountId2" isChangeTRColor="false" showHeader="true" className="sort body-detail-table" showPager="true">
									<v3x:column width="8%" align="center" label="<input type='checkbox' onclick='fnSelectAll(this, \"id\")'/>">
										<input type='checkbox' name='id' value="${bulrc.userId}"/>
										<input type="hidden" name='type' value="Member"/>
									</v3x:column>
									<v3x:column type="String" label="bul.type.spaceType.1"  className="sort font-12px" width="43%" value="${v3x:showOrgEntitiesOfIds(param.deptId, 'Department', pageContext)}" alt="${v3x:showDepartmentFullPath(param.deptId)}"/>
									<v3x:column type="String" label="bul.userName"  width="27%" className="sort font-12px" value="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}" alt="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}" />
									<v3x:column  type="Date" label="bul.read.readDate"  width="30%" className="sort font-12px" >
										&nbsp;&nbsp;&nbsp;<fmt:formatDate value="${bulrc.readDate}" pattern="${datePattern}"/>
									</v3x:column>
								</v3x:table>
								</c:if>
							</div>
							<iframe name="grantIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
						</td>
					</tr>
				</table>
			</td>
		</tr>
</table>
</form>
<script type="text/javascript">
bindOnresize('scrollList1',0,0);
bindOnresize('scrollList2',0,0);
</script>
</body>
</html>