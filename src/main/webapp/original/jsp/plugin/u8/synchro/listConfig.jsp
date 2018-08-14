<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page import="com.seeyon.apps.nc.constants.NCConstants"%>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title></title>
		<%@include file="header.jsp"%>
<c:set value="<%=NCConstants.FILDER_NOT_ENABLED%>" var="fildernotenable" />
<fmt:message key="u8.user.filder.notuse" var="notuse" />
<fmt:message key="u8.user.filder.stop" var="filderstop" />
<fmt:message key='u8.user.filder.set' var="filderset" />
<fmt:message key="u8.org.hand.account" var="accountName"/>
<fmt:message key="u8.org.hand.dept" var="deptName"/>
<script type="text/javascript">		
		function showDetail(orgId,type,ncId,tframe,isSeal){
			if(isSeal!=null && isSeal =='Y')
				{
                          alert("<fmt:message key='u8.orgcorp.isseal'/>");
                          return;
				}
		    tframe.location.href = "${urlNCSynchron}?method=editConfig&orgId="+orgId+"&type="+type+"&ncId="+ncId+"&edit=1";
	    }
	    function modify(){
	    	try{
		    	if(parent.parent.menuFrame){
		    		parent.parent.menuFrame.modify();
		    	}else{
		    		return;
		    	}
	    	}catch(e){
	    		return;
	    	}
	    }
	    function  openset(ncOrgCorpId,ncOrgCorpName,isenableOpen,isSeal)
	    {
	      if(isSeal!=null && isSeal =='Y')
        {
                  alert("<fmt:message key='u8.orgcorp.isseal'/>");
                  return;
        }
	    	try{
		 if(isenableOpen==true||isenableOpen=='true')
	    {
	      return;
	    }
	    	}catch(e){
	    		return;
	    	}
	  
		var sendResult = v3x.openWindow({
	        url : genericURL+"plugin/u8/synchro/filderFrame"+"&ncOrgCorp="+encodeURIComponent(ncOrgCorpId)+"&ncOrgCorpName="+encodeURIComponent(ncOrgCorpName),
	        width : screen.width-155,
	 	    height : screen.height-210,
		    top : 130,
		    left : 140,
            dialogType:"open",
		    resizable: "yes"
	});
	    }
	    	//定义回调函数
	this.invoke = function(ds) {
		try {
			if(ds != null && (typeof ds == 'string'))
			{
			window.location.href = window.location;
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
		    function oparationFilder(isfilder,ncorgCorp,isSeal)
		    {
		      if(isSeal!=null && isSeal =='Y')
				{
                          alert("<fmt:message key='u8.orgcorp.isseal'/>");
                          return;
				}
		if(isfilder=="${fildernotenable}")
		{
		  if(window.confirm("<fmt:message key='u8.user.filder.enable'/>"))
                  {
                    try
                  {
          	    var requestCaller = new XMLHttpRequestCaller(this, "ajaxU8OrgManager", "addFilderAccount",true);
		    requestCaller.addParameter(1, "String", ncorgCorp);
		    var ds1=requestCaller.serviceRequest();
                  }catch(ex1)
                  {
                   alert("Exception : " + ex1);
                   }
                  } 
		}
		else
		{
		  if(window.confirm("<fmt:message key='u8.user.filder.notenable'/>"))
          {
             try
          {
          	var requestCaller = new XMLHttpRequestCaller(this, "ajaxU8OrgManager", "addFilderAccount",true);
		    requestCaller.addParameter(1, "String", ncorgCorp);
		    var ds1=requestCaller.serviceRequest();
          }catch(ex1)
          {
          alert("Exception : " + ex1);
          }
          }  
		}
		}
		
	</script>
	</head>
<body>

<form id="accountform" name="accountform" target="exportIFrame"
	method="post">
	<v3x:table width="100%" htmlId="accountlist" data="ncMaps"
		var="mapperBean" showHeader="true" className="sort ellipsis">
		<c:choose>
			<c:when test="${mapperBean.type == accountOrg}">
				<c:set var="click"
				value="showDetail('${mapperBean.v3xOrgAccount.id}','${mapperBean.type}','${mapperBean.ncOrgCorp.pkCorp}',parent.detailFrame,'${mapperBean.ncOrgCorp.isseal}')" />
				<c:set var="dbclick" value="modify();" />
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id"
						value="${mapperBean.v3xOrgAccount.id}+${mapperBean.type}+${mapperBean.ncOrgCorp.pkCorp}">
				</v3x:column>
				<v3x:column width="25%" align="left" label="u8.org.list.name${v3x:getSysFlagByName('NCSuffix')}"
					type="String" value="${mapperBean.v3xOrgAccount.name}"
					className="cursor-hand sort" maxLength="50" symbol="..."
					alt="${mapperBean.v3xOrgAccount.name}" onClick="${click}"
					onDblClick="${dbclick }" />
				<v3x:column width="10%" align="left" label="u8.org.list.type"
					type="String" alt="${accountName}" value="${accountName}"
					className="cursor-hand sort" onClick="${click}"
					onDblClick="${dbclick }" />
			</c:when>
			<c:otherwise>
				<c:set var="click"
					value="showDetail('${mapperBean.v3xOrgDept.id}','${mapperBean.type}','${mapperBean.ncOrgCorp.pkCorp}',parent.detailFrame,'${mapperBean.ncOrgCorp.isseal}')" />
				<c:set var="dbclick"
					value="modify('${mapperBean.v3xOrgDept.id}','${mapperBean.type}','${mapperBean.ncOrgCorp.pkCorp}');" />
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id"
						value="${mapperBean.v3xOrgDept.id}+${mapperBean.type}+${mapperBean.ncOrgCorp.pkCorp}">
				</v3x:column>
				<v3x:column width="25%" align="left" label="u8.org.list.name${v3x:getSysFlagByName('NCSuffix')}"
					type="String" value="${mapperBean.v3xOrgDept.name}(${mapperBean.v3xOrgAccount.name})"
					className="cursor-hand sort" maxLength="50" symbol="..."
					alt="${mapperBean.v3xOrgDept.name}(${mapperBean.v3xOrgAccount.name})" onClick="${click}"
					onDblClick="${dbclick }" />
				<v3x:column width="10%" align="left" label="u8.org.list.type"
					type="String" alt="${deptName}" value="${deptName}"
					className="cursor-hand sort" onClick="${click}"
					onDblClick="${dbclick }" />
			</c:otherwise>
		</c:choose>
		<c:set var="altcontent"
		value="${mapperBean.ncOrgCorp==null?'':mapperBean.filderEnable==fildernotenable?notuse:filderstop}" />
		<c:set var="clickfilder"
			value="oparationFilder('${mapperBean.filderEnable}','${mapperBean.ncOrgCorp.pkCorp}','${mapperBean.ncOrgCorp.isseal}')" />
		<v3x:column width="35%" align="left" label="u8.org.list.nc.org"
			type="String" alt="${mapperBean.ncOrgCorp.unitname}"
			maxLength="50" symbol="..."
			value="${mapperBean.ncOrgCorp.unitname}"
			className="cursor-hand sort" onClick="${click}"
			onDblClick="${dbclick }" />
		<v3x:column width="15%" align="left"
			label="u8.user.filder.corp.enable" type="String" alt="${altcontent}"
			className="cursor-hand sort" onClick="${clickfilder}"
			onDblClick="${clickfilder}">
				<c:if test="${mapperBean.ncOrgCorp!=null}">
				<a>
				<fmt:message
					key="u8.user.filder.${mapperBean.filderEnable==fildernotenable?'notuse':'use'}" />
					</a>
					</c:if>
		</v3x:column>
		
		<v3x:column width="10%" align="left" label="u8.user.filder.set"
			type="String" className="cursor-hand sort" 
			alt="${mapperBean.filderEnable==fildernotenable?'':filderset}"
			onClick="openset('${mapperBean.ncOrgCorp.pkCorp}','${mapperBean.ncOrgCorp.unitname}','${mapperBean.filderEnable==fildernotenable}','${mapperBean.ncOrgCorp.isseal}')"
			onDblClick="openset('${mapperBean.ncOrgCorp.pkCorp}','${mapperBean.ncOrgCorp.unitname}','${mapperBean.filderEnable==fildernotenable}','${mapperBean.ncOrgCorp.isseal}')">
			<a>	${mapperBean.filderEnable==fildernotenable?'':filderset}</a>
		</v3x:column>
	</v3x:table>
</form>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>

</body>
</html>