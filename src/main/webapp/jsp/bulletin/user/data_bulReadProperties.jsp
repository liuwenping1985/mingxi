<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<html style="height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	function modifyNum(){
		var array=new Array("normal","borrow");
		for(var j=0;j<array.length;j++){
			if(array[j] == "normal"){
				parent.document.getElementById(array[j]+1).className="tab-tag-left-sel";
				parent.document.getElementById(array[j]+2).className="tab-tag-middel-sel";
				parent.document.getElementById(array[j]+3).className="tab-tag-right-sel";
			}else{
				var theDocument=parent.document.getElementById(array[j]+1);
				if(theDocument == null){
					continue;
				}else {					
					parent.document.getElementById(array[j]+1).className="tab-tag-left";
					parent.document.getElementById(array[j]+2).className="tab-tag-middel";
					parent.document.getElementById(array[j]+3).className="tab-tag-right";
				}
			}
		}
	}
	//子页面
	var i18nRemindSuccess = '<fmt:message key="bul.remind.success"/>',i18nRemindSelect = '<fmt:message key="bul.remind.please.select.member"/>';
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/bulletin/js/bulRemind.js${v3x:resSuffix()}" />"></script>
</head>
<body onload="modifyNum()" style="height: 100%;"scrolling="no">
<form method="post" name="propertyMainForm" id="propertyMainForm" style="height: 100%;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr id="normalTR"  valign="top">
		<td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div class="scrollList">
						<v3x:table data="bulreadcount" var="bulrc" htmlId="bulreadcountId" isChangeTRColor="false" showHeader="true" showPager="false" dragable="false">
							<v3x:column type="String" label="bul.type.spaceType.1" className="sort font-12px" width="30%" value="${v3x:showOrgEntitiesOfIds(bulrc.deptId, 'Department', pageContext)}" />
							<v3x:column type="String" label="bul.userName" className="sort font-12px" width="30%" value="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}" />
							<v3x:column  type="Date" label="bul.read.readDate" className="sort font-12px" width="38%">
								<fmt:formatDate value="${bulrc.readDate}" pattern="${datePattern}"/>
							</v3x:column>
						</v3x:table>
					</div>
					<iframe name="grantIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr id="borrowTR" valign="top" style="display:none">
		<td>
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<div class="body-detail-su" style="padding:6px 12px 0px 12px;">
						<v3x:table data="bulnotreadcount" var="bulrc" htmlId="bulreadcountId" isChangeTRColor="false" showHeader="true"  className="sort body-detail-table" showPager="false">
							<v3x:column width="7%" align="center" label="<input type='checkbox' onclick='fnSelectAll(this, \"id\")'/>">
								<input type='checkbox' name='id' value="${bulrc.userId}"/>
								<input type="hidden" name='type' value="Member"/>
							</v3x:column>
							<v3x:column type="String" label="bul.type.spaceType.1"  className="sort font-12px" width="27%" value="${v3x:showOrgEntitiesOfIds(param.deptId, 'Department', pageContext)}" />
							<v3x:column type="String" label="bul.userName"  width="28%" className="sort font-12px" value="${v3x:showOrgEntitiesOfIds(bulrc.userId, 'Member', pageContext)}" />
							<v3x:column  type="Date" label="bul.read.readDate"  width="32%" className="sort font-12px" >
								&nbsp;&nbsp;&nbsp;<fmt:formatDate value="${bulrc.readDate}" pattern="${datePattern}"/>
							</v3x:column>
						</v3x:table>
					</div>
					<iframe name="grantIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"> </iframe>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>