<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/docMenu.css${v3x:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/addressbook/js/addressbook.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript">
	//getA8Top().showLocation(1006,"<fmt:message key='addressbook.menu.public.label'  bundle='${v3xAddressBookI18N}'/>" );
	//getA8Top().endProc('');
	var rightMenu = new RightMenu("${pageContext.request.contextPath}");
	var menuBorder = false;
	<c:if test="${v3x:hasNewMail()}">
		rightMenu.AddItem("sendMail", "<fmt:message key='addressbook.email.label' />", "<c:url value='/common/images/left/icon/fayoujian.gif'/>","rbpm",  "sendSMS", "sendSMS");	
		menuBorder = true;
	</c:if>
	document.writeln(rightMenu.GetMenu());
</script>
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/private.js${v3x:resSuffix()}'/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onresize="resizeRightBody(500,'treeandlist','60%')">
<div class="main_div_row2" id="listMember_div">
  <div class="right_div_row2">
    <div class="top_div_row2"><%@ include file="../toolbar.jsp"%></div>
    <div class="center_div_row2" id="scrollListDiv" style="overflow: hidden;top:25px;">
      <input type="hidden" id="resultCount" value="${resultCount}" />
	  	   <form id="memberform" method="post">
			<v3x:table data="${members}" var="member" leastSize="0"  isChangeTRColor="false"  htmlId="memberlist" className="sort ellipsis"> 
			
			<c:set var="click" value="viewMember('${member.id}')"/>
			<v3x:column  width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type="checkbox" name="id" value="${member.id}" nameStr="${member.name}" mobilePhone="${member.mobilePhone}">
			</v3x:column>
			<c:choose>
				<c:when test="${!empty member.email}">
					<c:set var="onmouseover" value="showEditImage('${member.id }')"/>
				<c:set var="onmouseout" value="removeEditImage('${member.id}')"/>
				</c:when>
				<c:otherwise>
					<c:set var="onmouseover" value=""/>
				<c:set var="onmouseout" value=""/>
				</c:otherwise>
			</c:choose>
			
			<v3x:column  width="20%" align="left" label="addressbook.username.label"  onmouseover="${onmouseover }" onmouseout="${onmouseout}"   className="sort" type="string">
				<a class="defaulttitlecss  div-float cursor-hand" href="javascript:${click}" title="${v3x:toHTML(member.name)}">${v3x:toHTML(member.name)}</a>
				<div class="div-float-right" id="edit${member.id}" onclick="OnMouseUp(new AddressBook('${member.id}','','${v3x:toHTML(member.email)}'))" title="<fmt:message key='addressbook.done.label' />" ></div>
			</v3x:column>
			
			<v3x:column  width="20%" align="left" label="addressbook.account_form.companyName.label"
				 className="cursor-hand sort" type="String" alt="${member.companyName}">
				 ${v3x:toHTML(member.companyName)} &nbsp;&nbsp;</v3x:column>
				
			<v3x:column  width="20%"  align="left" label="addressbook.company.level.label${v3x:suffix()}"
				 className="sort" type="String"
			    alt="${member.companyLevel}"
				>${v3x:toHTML(member.companyLevel)} &nbsp;&nbsp;</v3x:column>
				
		 	<v3x:column  width="20%" align="left"  label="addressbook.company.telephone.label" type="String"
			  alt="${member.companyPhone}">${v3x:toHTML(member.companyPhone)}&nbsp;&nbsp;
			</v3x:column>
			
			 <v3x:column  width="15%" align="left" label="addressbook.mobilephone.label"  className="sort" type="String"  alt="${member.mobilePhone}" >
				 ${member.mobilePhone}&nbsp;&nbsp;
			</v3x:column>
			</v3x:table>
		    </form>
		    <iframe id="theLogIframe" name="theLogIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
    </div>
  </div>
</div>
<script>
initIpadScroll("listMember_div",520,700);
</script>
</body>
</html>