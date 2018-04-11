<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" />
<html style="height: 100%">
<head>
<script type="text/javascript">
<!--
	function add(){
		if(${label!=null}){
			window.location='${hrStaffURL}?method=initUserDefinedPage&staffId=${staffId}&operation=Save&isShow=Show&isSave=Save&page_id=${page_id}';
		}else{
	     	alert(v3x.getMessage("HRLang.hr_userDefinedPage_lable"));
	     	return;
		}
	}
	
	function modify(){
		if(!checkSelectedId(this)){
			var ids = getSelectId(this);
			window.location='${hrStaffURL}?method=initUserDefinedPage&staffId=${staffId}&operation=Update&isShow=Show&isSave=Save&page_id=${page_id}&ids=' + ids + "&dis=false";
		}else{
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_modify"));
			return;
		}
	}

	function viewUserDefined(ids){
		window.location='${hrStaffURL}?method=initUserDefinedPage&staffId=${staffId}&operation=Update&isShow=Show&page_id=${page_id}&ids=' + ids + "&dis=true";
	}
	
	function delOption(){
		var ids = getSelectIds(this);
		if(ids){
			if (window.confirm('您确定要删除吗？')) {
				window.location = '${hrStaffURL}?method=detoryUserDefined&staffId=${staffId}&page_id=${page_id}&ids=' + ids;
			}else{
				return;
			}
		}else{
			alert(v3x.getMessage("HRLang.hr_staffInfo_choose_delete"));
			return;
		}
	}
	
	function init(){
		document.getElementById("mainDiv").style.width=document.body.clientWidth-50;
		document.getElementById("mainDiv").style.height=document.body.clientHeight-120;
	}
//-->
</script>
<style type="text/css">
	#editusertable .categorySet-body{
	<c:if test="${operation == 'Save'||operation == 'Update'}">
		height: 150px;
	</c:if>
	<c:if test="${operation != 'Save'&& operation != 'Update'}">
		height: 200px;
	</c:if>
	}
</style>
</head>
<body scroll="no" onLoad="init();" onresize="init();" style="height: 100%">
<script>
	var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
	if(${repair == 0}){
		myBar1.add(new WebFXMenuButton("new", "<fmt:message key='hr.toolbar.salaryinfo.new.label' bundle='${v3xHRI18N}' />",  "add()", "<c:url value='/common/images/toolbar/new.gif'/>"));
		myBar1.add(new WebFXMenuButton("modify", "<fmt:message key='hr.staffInfo.modify.label' bundle='${v3xHRI18N}' />", "modify()", "<c:url value='/common/images/toolbar/update.gif'/>", "", null));
		myBar1.add(new WebFXMenuButton("delete", "<fmt:message key='hr.toolbar.salaryinfo.delete.label' bundle='${v3xHRI18N}' />", "delOption()", "<c:url value='/common/images/toolbar/delete.gif'/>"), "",null );
	}
	document.write(myBar1);
	document.close();
</script>
<form id="editForm" method="post" style="height: 100%" action="${hrStaffURL}?method=addUserDefined&operation=${operation}&staffId=${staffId}&page_id=${page_id}&ids=${ids}" onsubmit="return (checkForm(this))">
<c:set value="height: 94%;" var="heightcss"></c:set>
<c:set value="display:none;" var="displays"></c:set>
<c:if test="${show}">
<c:set value="height: 50%;" var="heightcss"></c:set>
<c:set value="" var="displays"></c:set>
</c:if>

<div style="${heightcss}overflow-x:hidden;overflow-y:auto;">
<table border="0" cellpadding="0" cellspacing="0" width="90%" height="100%" align="left" class="categorySet-bg">
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="120" nowrap="nowrap">&nbsp;
						<c:choose>
							<c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN'}">
								<span class="hr-ellipsis">${pageLabelName_zh}</span>
							</c:when>
							<c:otherwise>
								<span class="hr-ellipsis">${pageLabelName_en}</span>
							</c:otherwise>
						</c:choose>
					</td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;
				    </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head" style="vertical-align: top">
			 <div id="mainDiv"  class="categorySet-body border-bottom">
			 <table border="0" cellspacing="0" cellpadding="0" width="100%">
			 <tr>
			 <td>
	             <table align="left" width="60%" border="0" cellspacing="0" cellpadding="0">
	              <tr>
	                <td class="bg-gray" width="12%" nowrap="nowrap"><fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>:</td>
	          		<td class="new-column" width="35%" nowrap="nowrap">${staff.name}</td>
	                <td class="bg-gray" width="12%" nowrap="nowrap"><fmt:message key="hr.staffInfo.memberno.label"  bundle="${v3xHRI18N}"/>:</td>
	          		<td class="new-column" width="35%" nowrap="nowrap">${staff.code}</td>
	              </tr>
	             </table>
             </td>
       		 </tr>
               <tr><td><hr /></td></tr>
               <tr>
               <td>
                   	<table align="center" width="95%" border="1" bordercolor="BDBDBD" cellspacing="0" cellpadding="0" bgcolor="white">
                   	  <tr>
                   	    <td width="3%">&nbsp;</td>
                   	    <c:choose>
                   	    <c:when test="${v3x:getLocale(pageContext.request) == 'zh_CN' || v3x:getLocale(pageContext.request) == 'zh_TW'}">
                   	    	<c:forEach items="${webLabels_zh}" var="webLabel_zh">
                   	    		<td class="new-column" width="16%" nowrap="nowrap">
                   	    			${webLabel_zh.labelName_zh}
                   	    		</td>
                   	    	</c:forEach>
                   	    </c:when>
                   	    <c:otherwise>
                   	    	<c:forEach items="${webLabels_en}" var="webLabel_en">
                   	    		<td class="new-column" width="16%" nowrap="nowrap">
                   	    			${webLabel_en.lavelName_en}
                   	    		</td>
                   	    	</c:forEach>
                   	    </c:otherwise>
                   	    </c:choose>
                   	  </tr>                   	  
                   	  <hr:staffDisplayTag typeList="${propertyTypes}" valueList="${propertyValues}" />      				      				
                 	</table>                                                                            
		       </td>
		       </tr>
		       </table>
			</div>		
		</td>
	</tr>
</table>
</div>
<div style="${displays}height: 235px;width: 100%;overflow-x:hidden;overflow-y:auto;">
      <%@include file="editUserDefined.jsp"%>
</div>
</form>
</body>
</html>