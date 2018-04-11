<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.seeyon.apps.nc.constants.NCConstants"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<%@include file="header.jsp"%>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
		<title><fmt:message key="nc.user.filder.title.dept"/></title>
		<c:set value="<%=NCConstants.FILDER_STATE_NOT%>" var="fildernot" />
		<c:set value="<%=NCConstants.FILDER_STATE_PART%>" var="filderpart" />
		<c:set value="<%=NCConstants.FILDER_STATE_ALL%>" var="filderall" />
	</head>
	<script type="text/javascript">
	    var selectIndex = 0;
		function showDetail(ncOrgDeptId,ncOrgDeptState){
		  // parent.detailFrame.location.href = "${urlNCSynchron}?method=viewPersonBydept&ncOrgDeptId="+ncOrgDeptId+"&ncOrgDeptState="+ncOrgDeptState+"&ncOrgCorp="+${param.ncOrgCorp};
	   if("${filderpart}"==ncOrgDeptState){
	   	    var selected = v3x.openWindow({
		    url : "${u8FilderSynchron}?method=viewPersonBydept&ncOrgDeptId="+ncOrgDeptId+"&ncOrgDeptState="+ncOrgDeptState+"&ncOrgCorp=${ncOrgCorpId}",
		    width : "550",
		    height: "400",
		    dialogType:"open"
	   	 	});
	   }
	}
		    	//定义回调函数
	this.invoke = function(ds) {
		try {
			if(ds != null && (typeof ds == 'string'))
			{
			//alert("<fmt:message key='u8.user.filder.department.type'/>");
			window.location.href = window.location;
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
	function changeFilder(ncorgCorp,deptId,filderState)
	{
	       if(window.confirm("<fmt:message key='u8.user.filder.dept.status.change'/>"))
          {
	          try
	          {
	          	var requestCaller = new XMLHttpRequestCaller(this, "ajaxU8OrgManager", "updateFilderDeptState",true);
			    requestCaller.addParameter(1, "String", ncorgCorp);
			    requestCaller.addParameter(2, "String", deptId);
			    requestCaller.addParameter(3, "String", filderState.value);
			    var ds1=requestCaller.serviceRequest();
	          }catch(ex1)
	          {
	          alert("Exception : " + ex1);
	          }
          }else{
        	  filderState.options[selectIndex].selected = true;
          }
	}
	
	</script>
	<body scroll="no">
	<div class="main_div_center">
  		<div class="right_div_center">
    		<div class="center_div_center" id="scrollListDiv">
      				<form name="listForm" id="listForm" method="post">
							<v3x:table htmlId="listTable" data="ncOrgDep" var="list" >
								<c:set var="click"
									value="showDetail('${list.entityId}','${list.state}')"/>
								<v3x:column width="40%" type="String" label="u8.user.filder.ncdept.name"
									className="cursor-hand sort">
									<c:out value="${list.entityName}" />
								</v3x:column>
								<v3x:column width="30%" type="String" label="u8.user.filder.label.type"
									className="cursor-hand sort">
									<select name="filderState" onfocus="selectIndex = this.options.selectedIndex;" onchange="changeFilder('${ncOrgCorpId}','${list.entityId}',this)">
										<option value="${fildernot}" <c:if test="${fildernot==list.state}">selected</c:if>>
											<fmt:message key="u8.user.filder.dept.state${fildernot}"/>
										</option>
										<option value="${filderpart }" <c:if test="${filderpart==list.state}">selected</c:if>>
											<fmt:message key="u8.user.filder.dept.state${filderpart}"/>
										</option>
										<option value="${filderall }" <c:if test="${filderall==list.state}">selected</c:if>>
											<fmt:message key="u8.user.filder.dept.state${filderall}"/>
										</option>
									</select>
								</v3x:column>
								<v3x:column width="30%" type="String" label="u8.user.filder.label.person"
									className="cursor-hand sort" onClick="${click}">
									<c:if test="${filderpart==list.state}"><fmt:message key="u8.user.filder.person.set"/></c:if>
								</v3x:column>
							</v3x:table>
					</form>
    		</div>
  		</div>
	</div>
	</body>
</html>