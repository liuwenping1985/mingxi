<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="docHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}" />
<script type="text/javascript">
	var deptId = "${param.deptId}";
	function seachDocRel(){
		//var theParent=parent.docIframe;
		//查询条件
		var searchContent = document.getElementById('condition').value;
		var _src="${detailURL}?method=docLearningHistory&isGroupLib=${param.isGroupLib}&docId=${docId}&deptId=" + deptId+"&searchContent="+encodeURI(searchContent); 		
		//alert(_src);
		window.location.href = _src;
	 	//theParent.location =_src;
		//theParent.location.reload(true);
	 
	}
	
	function setDeptId(ele){
		if(!ele)
			return;
		showOriginalElement_per=true;
		deptId = ele[0].id;
		document.getElementById("condition").value = ele[0].name;
	}
	
</script>

	<v3x:selectPeople id="deptSp" panels="Department" selectType="Department"
		departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
		jsFunction="setDeptId(elements)" minSize="1" maxSize="1" />
	<script type="text/javascript">
	//if('${param.isGroupLib}' != 'true')
	//	onlyLoginAccount_deptSp = true;
	</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
</head>
<body onkeydown="listenerKeyESC()">
	<div class="main_div_row2">
	  <div class="right_div_row2">
	    <div class="top_div_row2">
	<table cellpadding="0" cellspacing="0" width="100%" border="0">
		<tr height="20px"><td>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="10%">
		<tr valign="top"><td id="canOpen" width="5%" height="22" class="webfx-menu-bar">
		</td>
		<td height="22" valign="top">		</td>	
			<td class="webfx-menu-bar" valign="top">		
					<form action="" name="searchForm" id="searchForm" method="post"
				onsubmit="return false" style="margin: 0px" target="docFrame">
				<input type="hidden" value="subject" name="flag">
			<div class="div-float-right">
			<div class="div-float"><!--select name="condition" id="condition"
				onChange="setDeptId(this)" class="condition">
				<option value=""><fmt:message
					key="doc.jsp.learn.history.search.label" /></option>
				<c:forEach items="${depts}" var="dept">
					<option value="${dept.id}">${dept.name}</option>
				</c:forEach>
			</select-->
			<input type="text" name="condition" id="condition" onclick="selectPeopleFun_deptSp()" readonly="readonly" value="<fmt:message
					key="doc.jsp.learn.history.search.label" />" />
			</div>			
			
			<div onclick="seachDocRel();" class="condition-search-button div-float"></div>
			</div>
			</form>
			
			</td>
	
		</tr>
		</table>
			</td>
			</tr>
			</table>
			</div>
			<div class="center_div_row2" id="scrollListDiv">
				<form>
					<v3x:table data="${dlhvos}" var="vo" isChangeTRColor="true" showHeader="true" htmlId="relAddTable" width="100%" >
				
						
						<v3x:column width="20%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.learn.history.name')}"
				
							value="${v3x:getLimitLengthString(vo.memberName,20,'...')}"></v3x:column>
							
						<v3x:column width="45%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.learn.history.dept')}"
							value="${vo.deptName}"></v3x:column>
				
						<v3x:column width="35%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.learn.history.time')}">
							<fmt:formatDate value="${vo.lastAccessTime}"
								pattern="${datetimePattern}" />
						</v3x:column>
				
					</v3x:table>
				</form>
			</div>
			</div>
		</div>


<input type="hidden" name="relIdAndRelName" id="relIdAndRelName" value="">

<iframe name="docLinkFrame" id="docLinkFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe> 
<script>
//保留查询条件
var searchCon = '${searchContent}';
if(searchCon!=null && searchCon!=''){
document.getElementById('condition').value=searchCon;
}
</script>
</body>
</html>