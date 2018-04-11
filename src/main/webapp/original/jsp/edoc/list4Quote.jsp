<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<style>
SELECT{
		FONT-SIZE: 12px; 
		height: 18px;
		line-height: 18px;
		FONT-FAMILY: Times New Roman
}
input.common_over_page_txtbox{height:18px;line-height: 18px;}
</style>
</head>
<script type="text/javascript">
<!--
window.onload = function(){
	//showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");

	var cid = document.getElementsByName("id");
	<c:forEach items="${csList}" var="obj" varStatus="status">
	if(parent.fileUploadAttachments.containsKey("${obj.affairId}")){
		var i = "${status.index}";
		cid[i].checked="checked";
	}
	</c:forEach>
	
	$("#bodyIDpending tr td").removeAttr("onclick");
}

function changeColType(obj){
	/*
	var begin = document.getElementById("createDateBegin").value;
	var end = document.getElementById("createDateEnd").value;
	if(new Date(begin.replace(/-/g,"/")) > new Date(end.replace(/-/g,"/"))){
		document.getElementById("createDateBegin").value = end;
	}*/
	var sel = document.getElementById("condition");
	sel.options[0].selected=true;
	
	if(obj.checked){
		doSearch();
	}
}

function openDetail(subject, _url) {
  // 'subject'判断是否是交换公文
  
    _url = genericURL + "?method=detailIFrame&" + _url;
    v3x.openWindow({
      url: _url,
      FullScrean: 'yes',
      dialogType: 'open',
      closePrevious : "no"
    }); 
}

function deselectItem(affairId){
	   $(":checkbox").each(function(){
		   if(this.value == affairId){
				this.checked = false;
				return;
			}
		});
}   

//选中关联项
function _doSelectData(obj, jsSubject, pType, pAffairId){
    
    var rBrReg = /<br\/?>/ig;
    var rBrReg1 = /\r/ig;
    var rBrReg2 = /\n/ig;
    var rBrReg3 = /\r\n/ig;
    jsSubject = jsSubject.replace(rBrReg, "");
    jsSubject = jsSubject.replace(rBrReg1, "");
    jsSubject = jsSubject.replace(rBrReg2, "");
    jsSubject = jsSubject.replace(rBrReg3, "");
    
    parent.quoteDocumentSelected(obj, jsSubject, pType, pAffairId)
}

//--> 
</script>
<body scroll="no" onkeypress="listenerKeyESC()">
<form action="" name="searchForm" id="searchForm" method="get" onkeypress="doSearchEnter()" onsubmit="return false" style="margin: 0px">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	
	<tr class="webfx-menu-bar bg_color">
		<td height="22" class="webfx-menu-bar-gray bg_color">
		<c:if test="${v3x:hasPlugin('edoc')}">
			<label for="sentC"><input id="sentC" name="appType" type="radio" value="19" onclick="changeColType(this)" ${(param.appType eq '19' || empty param.coltype) ? 'checked' : ''}><fmt:message key="application.19.label"  bundle='${v3xCommonI18N}'/></label>
			<label for="pendingC"><input id="pendingC" name="appType" type="radio" value="20" onclick="changeColType(this)" ${param.appType eq '20' ? 'checked' : ''}><fmt:message key="application.20.label"  bundle='${v3xCommonI18N}'/></label>
		</c:if>
			<label for="doneC"><input id="doneC" name="appType" type="radio" value="21" onclick="changeColType(this)" ${param.appType eq '21' ? 'checked' : ''}><fmt:message key="application.21.label" bundle='${v3xCommonI18N}' /></label>
		</td>
		<td class="webfx-menu-bar bg_color">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<div class="div-float-right">
				<div class="div-float">				
				  	<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
					    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
					    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
					    <option value="startMemberName"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" /></option>
					    <option value="createDate"><fmt:message key="common.date.sendtime.label" bundle="${v3xCommonI18N}" /></option>
				  	</select>
			  	</div>
			  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="startMemberNameDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	
			  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	
			  	<div id="createDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="createDateBegin" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="createDateEnd" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<span onclick="javascript:doSearch()" class="condition-search-button"></span>
		  	</div>
		</td>
		
	</tr>
	</table>
	<table  width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="2">
		<div class="scrollList">
			<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<c:set var="i" value="0" />
			<v3x:table htmlId="pending" data="csList" var="col" isChangeTRColor="false" subHeight="30">
			
				<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />
					<c:set var="click" value="openDetail('', 'from=Done&openFrom=glwd&affairId=${col.affairId}')"/>
				<c:set var="dblclick"  value="openDetail('', 'from=Done&openFrom=glwd&affairId=${col.affairId}')"/>
				<c:set var="isRead" value="true"/>
				<v3x:column width="5%" align="center" label="">
				<c:set var="i" value="${i+1}" />
				<fmt:formatDate value="${col.summary.createTime}" pattern="yyyy-MM-dd HH:mm:ss" var="createDate"/>
					<input type='checkbox' name='id' value="${col.affairId}" createDate="${createDate }"
					  onclick="_doSelectData(this, '${v3x:escapeJavascript(col.summary.subject)}', 'edoc', '${col.affairId}')" />
				</v3x:column>				
				
				<v3x:column width="10%" type="String" label="edoc.state.label" className="sort" read="${isRead}"
				 maxLength="16"  symbol="..." >
				 <c:choose>
				 <c:when test="${col.state==2}">
				 <fmt:message key='common.toolbar.state.sended.label' bundle='${v3xCommonI18N}' />
				 </c:when>
				 <c:when test="${col.state==3}">
				 <fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}' />
				 </c:when>
				 <c:when test="${col.state==4}">
				 <fmt:message key='common.toolbar.state.done.label' bundle='${v3xCommonI18N}' />
				 </c:when>
				 </c:choose>
				 
				 </v3x:column>
				<v3x:column width="55%"   symbol="..." type="String" label="common.subject.label" className="cursor-hand sort blue  mxtgrid_black" read="${isRead}"
				bodyType="${col.bodyType}" value="${col.summary.subject}" importantLevel="${col.summary.urgentLevel}" hasAttachments="${col.summary.hasAttachments}" href="javascript:openDetail('', 'from=Done&openFrom=glwd&affairId=${col.affairId}')" />
				<v3x:column width="15%" type="String" label="edoc.element.wordno.label" className="sort" read="${isRead}"
				value="${col.summary.docMark}"  symbol="..." />
				<v3x:column width="15%" type="String" label="edoc.element.wordinno.label" className="sort" read="${isRead}"
				value="${col.summary.serialNo}"  symbol="..." />				
				<v3x:column width="15%" type="String" label="common.sender.label" value="${col.summary.startMember.name}" className="sort" read="${isRead}"/>
				<v3x:column width="15%" type="Date" label="common.date.sendtime.label" className="sort" read="${isRead}">
					<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>
				</v3x:column>
			</v3x:table>
			</form>
		</div>
		</td>
	</tr>		
</table>

 </form>
<script type="text/javascript">
<!--
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>