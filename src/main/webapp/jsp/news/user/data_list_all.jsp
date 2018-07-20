<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(
		new WebFXMenuButton(
			"returnBtn", 
			"<fmt:message key="oper.return" />", 
			"window.location.href='${newsDataURL}?method=userList';", 
			"<c:url value='/common/images/toolbar/back.gif'/>", 
			"", 
			null
			)
	);
	
	if('${isGroup}' == 'true')
	  //TODO yangwulin 2012-10-29 getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(21, '${theType.typeName}'); 
	else
	  //TODO yangwulin 2012-10-29 getA8Top().showLocation(704, '${theType.typeName}');
</script>
</head>
<body style="padding:5px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag" colspan="2">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="oper.view" /><fmt:message key="news.data_shortname" /></a></div>
				<div class="tab-tag-right-sel"></div>
                <c:if test="${sessionScope['news.isShowPublish'] || isShowPublish}">		
				<div class="tab-separator"></div>
				
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel"><a href="${newsDataURL}?method=publishListMain&condition=type&textfield=${sessionScope['news.typeId']}" class="non-a"><fmt:message key="oper.publish" /><fmt:message key="news.data_shortname" /></a></div>
				<div class="tab-tag-right"></div>
                </c:if>				
			</div>
<!-- 查找 start -->
			<form action="${newsDataURL}" name="searchForm" id="searchForm" method="post"
				onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="<c:out value='${param.more}' />" name="more">	
	
	      <div class="div-float-right">

		<div class="div-float">
			<select name="condition" id="condition" 
			onChange="showNextCondition(this)" class="condition">
				<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				<option value="title"><fmt:message key="news.data.title" /></option>
				<option value="type"><fmt:message key="news.data.type" /></option>
				<option value="keywords"><fmt:message key="news.data.keywords" /></option>
				<option value="brief"><fmt:message key="news.data.brief" /></option>
			</select>
		</div>

		<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
		<div id="titleDiv" class="div-float">
			<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
		</div>
		<div id="typeDiv" class="div-float hidden">
			<select name="textfield" id="textfield" style="width:130px"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				<c:forEach items="${typeList}" var="type">
					<option value="${type.id}">${type.typeName}</option>
				</c:forEach>
			</select>
		</div>
		
		<div id="keywordsDiv" class="div-float hidden">
			<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
		</div>
		<div id="briefDiv" class="div-float hidden">
			<input type="text" name="textfield" class="textfield"  maxlength="50" onkeydown="javascript:searchWithKey()">
		</div>
		
		<!-- 按钮事件已经封装，直接copy -->
		<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	</div>
	</form>
<!-- 查找 end -->
		</td>
	</tr>
	<tr>
		<td colspan="2" class="tab-body-border">
			<form>
			<v3x:table htmlId="listTable" data="list" var="bean" isChangeTRColor="false">
				<v3x:column width="25%" type="String" label="news.biaoti.label" className="cursor-hand sort" 
				hasAttachments="${bean.attachmentsFlag}" bodyType="${bean.dataFormat}" read="true" maxLength="50" alt="${bean.title}" symbol="...">
					<c:if test="${bean.topOrder>0}">
					<font color="red">[<fmt:message key="label.new.word" />]</font>
					</c:if>
					<a href="javascript:openWin('${newsDataURL}?method=userView&id=${bean.id}')" class='titleDefaultCss'>${v3x:getLimitLengthString(bean.title,30,'...')}</a>
				</v3x:column>
				<v3x:column width="15%" type="String"
					label="news.data.type" className="sort"
					value="${bean.type.typeName}"
					maxLength="22" symbol="..."
					>
					
				</v3x:column>
				<v3x:column width="25%" type="String"
					label="news.data.publishDepartmentId" className="sort"
					property="publishDepartmentName" maxLength="50" alt="${bean.publishDepartmentName}"
					>
				</v3x:column>
				<v3x:column width="10%" type="String"
					label="news.data.createUser" className="sort">
					${bean.createUserName}
				</v3x:column>
				<v3x:column width="15%" type="Date"
					label="news.data.createDate" className="sort">
					<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
				</v3x:column>
			</v3x:table>
			</form>
		</td>
	</tr>
</table>
</body>
</html>