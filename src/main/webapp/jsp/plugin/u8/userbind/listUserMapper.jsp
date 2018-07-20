<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header_userMapper.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">

        window.onload = function(){
	     	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	     	//判断是不是查询
	     	var condition = "${condition}";
	     	if(condition != ''){
	     		document.getElementsByName("condition")[0].onchange();
	     	}
        }
        function modify(){			
			var id = getSelectIds(parent.listFrame);
			var ids = id.split(",");
			if(ids.size()==2){
			    parent.detailFrame.location.href="${urlU8UserMapper}?method=editUserMapper&id="+ids[0];
			}else if(ids.size()>2){
				alert("<fmt:message key='u8.bind.modify.one.once'/>");
				return false;				
			}else{
				alert("<fmt:message key='u8.bind.modify.one.select'/>");
				return false;
			}
		}
		function showDetail(id,type,tframe){
			tframe.location.href = "${urlU8UserMapper}?method=editUserMapper&id="+id+"&oper=edit";
		}
		//待修改getA8Top().showLocation(null, "<fmt:message key='menu.organization.info.manage' bundle='${v3xMainI18N}' />", "<fmt:message key='nc.user.mapper' />");
</script>
</head>
<body class="overflow-hidden">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
    	<table class="border-left border-right border-top" height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
    		<tr>
		<td height="22" class="webfx-menu-bar">
			<script type="text/javascript">
				var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; //取得HR外围frame中的菜单样式
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode);
				myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","modify()","<c:url value='/common/images/toolbar/update.gif'/>","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>", null));
				document.write(myBar);
		    	document.close();
	    	</script>
	    </td>
		<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" />
		<td id="grayTd" class="webfx-menu-bar">
			<form name="searchForm" id="searchForm" method="post"  action="${urlU8UserMapper}?method=listUserMapper" onkeypress="doSearchEnter()">
				<div class="div-float-right">
					<div class="div-float">
						<select style="height: 20px;width: 120px" name="condition" class="condition"
							onChange="showNextCondition(this)">
							<option value="" <c:if test="${condition == ''}">selected='true'</c:if> >
								<fmt:message key="member.list.find" />
							</option>
							<option value="name" <c:if test="${condition == 'name'}">selected='true'</c:if>>
								<fmt:message key="member.list.find.name" />
							</option>
							<option value="loginName" <c:if test="${condition == 'loginName'}">selected='true'</c:if>>
								<fmt:message key="member.list.find.login" />
							</option>
						</select>
						
					</div>
					<div id="nameDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" />
					</div>
					<div id="loginNameDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" />
					</div>
					<div onclick="javascript:doSearch()"
						class="condition-search-button">
						&nbsp;
					</div>
				</div>
			</form>
		</td>
	</tr>
    	</table>
    </div>
    <div class="center_div_row2 overflow-hidden" id="scrollListDiv">
    <fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
    	<form id="userMapperForm" method="post" target="exportIFrame">
            <fmt:message key="org.entity.disabled" var="orgDisabled"/>
            <fmt:message key="org.entity.deleted" var="orgDeleted"/>
            <fmt:message key="org.entity.transfered" var="orgTransfered"/>      		
			<v3x:table htmlId="userMapperlist" data="userMapperList" var="member"  showHeader="true" className="sort ellipsis">
			<c:set var="click" value="showDetail('${member.v3xOrgMember.id}','Member',parent.detailFrame)"/>
			<c:set var="dbclick" value="modify();"/>
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type="checkbox" name="id" value="${member.v3xOrgMember.id}" isInternal="${member.v3xOrgMember.isInternal}">
				</v3x:column>
                <c:set var="status" value=""/>
                <c:if test="${member.v3xOrgMember.status == 2}"><c:set var="status" value="(${orgDisabled})"/></c:if>
                <c:if test="${member.v3xOrgMember.status == 3}"><c:set var="status" value="(${orgDeleted})"/></c:if>    
                <c:if test="${member.v3xOrgMember.status == 4}"><c:set var="status" value="(${orgTransfered})"/></c:if>     			
				<v3x:column width="10%" align="left" label="org.member_form.name.label" type="String"
					value="${member.v3xOrgMember.name}${status}" className="cursor-hand sort" 
					 alt="${member.v3xOrgMember.name}${status}" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="10%" align="left" label="org.member_form.loginName.label" type="String"
					value="${member.v3xOrgMember.loginName}" className="cursor-hand sort" 
					alt="${member.v3xOrgMember.loginName}" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="10%" align="left" label="org.member_form.code" type="String"
					value="${member.v3xOrgMember.code}" className="cursor-hand sort" 
					alt="${member.v3xOrgMember.code}" onClick="${click}" onDblClick="${dbclick }"/>
					
				<v3x:column width="10%" align="center" label="common.sort.label" type="Number" maxLength="8"  symbol="..."
					alt="${member.v3xOrgMember.sortId}" value="${member.v3xOrgMember.sortId}" className="cursor-hand sort" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="10%" align="left" label="org.member_form.deptName.label" type="String"
					value="${member.departmentName}" className="cursor-hand sort" 
					alt="${member.departmentName}" onClick="${click}" onDblClick="${dbclick }"/>
				<v3x:column width="10%" align="left" label="org.member_form.primaryPost.label" type="String"
					className="cursor-hand sort" alt="${member.postName}" onClick="${click}" onDblClick="${dbclick }">
					<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
					<c:if test="${member.v3xOrgMember.isInternal}">
					<c:choose>
					<c:when test="${member.v3xOrgMember.orgPostId != -1}">
						${v3x:toHTML(member.postName)}
					</c:when>
					<c:otherwise>
						<fmt:message key="org.member.noPost"/>				
					</c:otherwise>
					</c:choose>
					</c:if>
				</v3x:column>	
				<v3x:column width="10%" align="left" label="org.member_form.levelName.label" type="String"
					className="cursor-hand sort"  alt="${member.levelName}" onClick="${click}" onDblClick="${dbclick }">
					<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources"/>
					<c:if test="${member.v3xOrgMember.isInternal}">
					<c:choose>
					<c:when test="${member.v3xOrgMember.orgLevelId != -1}">
						${v3x:toHTML(member.levelName)}
					</c:when>
					<c:otherwise>
						<font color="red"><fmt:message key="org.member.noPost"/></font>						
					</c:otherwise>
					</c:choose>
					</c:if>
				</v3x:column>
				<%-- <c:if test="${sys_isGroupVer}">
					<v3x:column width="15%" align="left" label="org.member_form.account" type="String"
						className="cursor-hand sort" alt="${member.accountName}" onClick="${click}" onDblClick="${dbclick }">
						${v3x:toHTML(member.accountName)}
					</v3x:column>
				</c:if> --%>
					<v3x:column width="28%" align="left" label="u8.account.label" type="String" 
				    alt="${member.stateName}" value="${member.stateName}"
				    symbol="..." className="cursor-hand sort" onClick="${click}" onDblClick="${dbclick }">
				    <fmt:setBundle basename="com.seeyon.apps.u8.i18n.U8Resources"/>
				  	</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>