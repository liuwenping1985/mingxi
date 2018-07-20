<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript">
	window.onload = function(){		
		if('${condition}' == '')
			return;
		if('${condition}' == 'publishUserId')
			bulShowCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />", '${param.showPer}');	
		else 
			bulShowCondition("${condition}", "<v3x:out value='${textfield}' escapeJavaScript='true' />");		
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(
		new WebFXMenuButton(
			"returnBtn", 
			"<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />", 
			"window.location.href='${bulDataURL}?method=userList';", 
			"<c:url value='/common/images/toolbar/back.gif'/>", 
			"", 
			null
			)
	);
	
	if('${isGroup}' == 'true')
		getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(22, '${theType.typeName}'); 
	else
		getA8Top().showLocation(703, '${theType.typeName}');
</script>
</head>
<body style="padding:5px;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="28" class="tab-tag"  colspan="2">
			<div class="div-float">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel"><a href="#" class="non-a"><fmt:message key="oper.view" /><fmt:message key="bul.data_shortname" /></a></div>
				<div class="tab-tag-right-sel"></div>
				<%-- 
				--%>
				<c:if test="${sessionScope['bulletin.isShowPublish'] || isShowPublish}">		
								<div class="tab-separator"></div>
								<div class="tab-tag-left"></div>
								<div class="tab-tag-middel"><a href="${bulDataURL}?method=publishListIndex&condition=type&textfield=${sessionScope['bulletin.typeId']}" class="non-a"><fmt:message key="oper.publish" /><fmt:message key="bul.data_shortname" /></a></div>
								<div class="tab-tag-right"></div>
				</c:if>
			</div>
			<!-- 查找 start -->
	
	<form action="${bulDataURL}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		<input type="hidden" value="<c:out value='${param.more}' />" name="more">
		<input type="hidden" value='${typeId}'  name="typeId">
		
		<div class="div-float-right">

			<div class="div-float">
				<select name="condition"  id="condition"
				onChange="showNextCondition(this)" class="condition">
					<option value="title"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					<option value="title"><fmt:message key="bul.data.title" /></option>
									<option value="publishUserId"><fmt:message key="bul.data.publishUser" /></option>
									<option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>

				</select>
			</div>
	
			<!-- 每一个选项对应一个DIV，它的id命名规定为"选项option.value + Div" input框规定为textfield -->
							<div id="titleDiv" class="div-float">
								<input type="text" name="textfield" id="titleInput" class="textfield">
							</div>


		<div id="publishUserIdDiv" class="div-float hidden">		
		<v3x:selectPeople id="per" panels="Department" selectType="Member" jsFunction="setPublisher(elements)" maxSize="1" minSize="1"  />
		<script type="text/javascript">     showOriginalElement_per = false; </script>
			<input type="hidden" name="textfield" id="per_textfield"  value="" >
			<input type="hidden" name="showPer" id="showPer"  value="" >
			<input type="text" name="publisher" id="publisher" class="textfield" onclick="selectPeopleFun_per()">
		</div>
		<div id="publishDateDiv" class="div-float hidden">		
			<input type="text" name="textfield" id="dateInput" class="textfield" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
 		</div>

			<!-- 按钮事件已经封装，直接copy -->
			<div onclick="javascript:doSearch()" class="condition-search-button"></div>
	
		</form>			
			<!-- 查找 end -->
		</td>
	</tr>
	<tr>
		<td colspan="2" class="tab-body-border">
			<form>
				<v3x:table htmlId="listTable" data="list" var="bean" isChangeTRColor="false">
					<c:choose>
						<c:when test="${bean.readFlag}">
							<c:set value="title-already-visited" var="readStyle" />
						</c:when>
						<c:otherwise>
							<c:set value="title-more-visited" var="readStyle" />
						</c:otherwise>
					</c:choose>
					<v3x:column type="String" label="bul.biaoti.label" className="cursor-hand sort" hasAttachments="${bean.attachmentsFlag}"
						bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}" read="true" maxLength="23" symbol="...">
						<c:if test="${bean.topOrder>0}">
							<font color="red">[<fmt:message key="label.top" />]</font>
						</c:if>
						<a href="javascript:openWin('${bulDataURL}?method=userView&id=${bean.id}')" class="${readStyle}">${v3x:getLimitLengthString(bean.title,35,'...')}</a>
					</v3x:column>
					<v3x:column width="15%" type="String"
						label="bul.data.type" className="sort" value="${bean.type.typeName}"
						 maxLength="20" symbol="..."
						/>
					<v3x:column width="100" type="String" 
						label="common.issueScope.label" className="sort" 
						value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" 
						maxLength="16" symbol="..."/>
					<v3x:column width="10%" type="String"
						label="bul.data.createUser" className="sort" value="${v3x:showMemberName(bean.createUser)}"
						maxLength="15" symbol="..."/>
					<v3x:column width="15%" type="Date"
						label="bul.data.createDate" className="sort">
						<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
					</v3x:column>
				</v3x:table>
			</form>
		</td>
	</tr>
</table>
</body>
</html>