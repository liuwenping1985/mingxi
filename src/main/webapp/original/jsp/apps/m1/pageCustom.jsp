<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="header.jsp"%>
<html>
<head>
<script type="text/javascript">
	$(document).ready(function(){
		var isSys = ${isSys};
		if(isSys){
			showCtpLocation("M1_sysChangeImg");
		}else{
			showCtpLocation('M1_accountChangeImg');
		};
		 changeMenuTab(document.getElementById('changeIpad'));
		$('#changeIpad').click(function(){
				changeMenuTab(this);
		
		});
		$('#changeIphone').click(function(){
		//	changedh(1);
			changeMenuTab(this);
		
		});
		$('#changeAndroid').click(function(){
		//	changedh(2);
			changeMenuTab(this);
		
		});
		$('#changeEben').click(function(){
		//	changedh(3);
			changeMenuTab(this);
		
		});
	
	
	});
	
</script>
<style type="text/css">
	body{border-top: 2px #CDCDCD solid; }
	table{ width:100%; height:100%;}
</style>
</head>

<body  id="pageCustomId"  >
<table>
<tr>
	<td valign="bottom" height="26" class="tab-tag">
		<div id="menuTabDiv" class="div-float">
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" id="changeIpad" name="changeIpad" url="<c:url value='/m1/changeImgController.do'/>?method=toShowImgManage&fromw=ipad&isSys=${isSys}"><fmt:message key="label.mm.orgpage.ipad" bundle="${mobileManageBundle}"/></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" id="changeIphone" url="<c:url value='/m1/changeImgController.do'/>?method=toShowImgManage&fromw=iphone&isSys=${isSys}"><fmt:message key="label.mm.orgpage.iphone" bundle="${mobileManageBundle}"/></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" id="changeAndroid" url="<c:url value='/m1/changeImgController.do'/>?method=toShowImgManage&fromw=android&isSys=${isSys}"><fmt:message key="label.mm.orgpage.android" bundle="${mobileManageBundle}"/></div>
			<div class="tab-tag-right"></div>
			<div class="tab-separator"></div>
			<div class="tab-tag-left"></div>
			<div class="tab-tag-middel" id="changeEben" url="<c:url value='/m1/changeImgController.do'/>?method=toShowImgManage&fromw=eben&isSys=${isSys}"><fmt:message key="label.mm.orgpage.eben" bundle="${mobileManageBundle}"/></div>
			<div class="tab-tag-right"></div>
		</div>
	</td>
</tr>
<tr>
	<td  id = "framestyle ">
		<iframe id="detailIframe" name="detailIframe" frameborder="0" scrolling="yes" style="width:100%; height:100%;"></iframe>			
	</td>
</tr>
</table>
</body>
</html>