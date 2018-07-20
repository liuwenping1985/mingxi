<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<head>    
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
		var processing= "false";
		var hasDiagram = "true";    
		var caseProcessXML = "";
		var caseLogXML = "";
		var caseWorkItemLogXML = "";
		var showMode = 1;
		var currentNodeId = null;
		var showHastenButton = "true";    
		var editWorkFlowFlag = "true";
		var appName= "";
		var isTemplete = "false";
		var templeteCategrory="";
		var isFromEdoc = true;

		var editWorkFlowFlag = "true";

		var jsMenuLocalId=201;
		var baseUrl='${supervise}?method=';
		var hasWorkflow = <c:out value='${hasWorkflow}' default='false' />;

		var selectedElements = null;
		
		var status = '${status}'; //改督办项得状态  未办结/已办结
		var label = '${label}';

		function showDigarm(id,edocId) {
			//frameNames = frameNames || "";
			//判断是否当前用户是否仍然是公文督办人
			if(!isStillSupervisor(edocId)){
				window.location.reload();
				return false;
			}
			var _url = "${supervise}?method=showDigarm&superviseId="+id+"&comm=toxml";
	    	var rv = v3x.openWindow({
	       		 url: _url,
	       		 width: 860,
		       	height: 690,
		       	resizable: "no"
	    	});
			if(rv){
				window.location.reload();
			}
			//var sendForm = document.getElementById("sendForm");
			//sendForm.action = '${supervise}?method=changeProcess&superviseId='+superviseId+'&caseId='+caseId+'&edocId='+edocId;
			//if(rv==true){
			//	sendForm.submit();
			//}
	 }
	
	
	function findListByStatus(status){
	
		document.sendForm.action = '${supervise}?method=list&status='+status;
		document.sendForm.submit();
	}
	
		function showAffair(){
		var checkedIds = document.getElementsByName('id');
		var len = checkedIds.length;
    	var str = "";
    	var selectCount = 0;
		  
		for(var i = 0; i < len; i++) {
			var checkedId = checkedIds[i];
			if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
				str = checkedId.getAttribute("summaryId");
				selectCount++;
			}
		}
			
		if(selectCount == 0){
			//alert("selectCount == 0");
		  	alert(_("collaborationLang.col_alertSelOneSuperviseDetail"));
		  	return;
		}
		if(selectCount > 1){
			alert(_("collaborationLang.col_alertSelectOnlyOne"));
			return;
		}
		var rv = v3x.openWindow({
       		 url: "${supervise}?method=showAffairEntry&summaryId=" + str,
       		 height: 400,
       		 width: 700
    	});
    	//GOV-4620 公文督办-已办结，选中一条公文点击办理情况后关闭再点击删除 删除不了
    	//关闭窗口后再刷新列表页面
		window.location.href='${supervise}?method=list&status='+status+"&edocType=${param.edocType}";
	}
	
	//删除督办记录
	function deleteItem() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
					str += checkedId.value;
					str +=","
				}
			}
			
		 //-- justify is any id has been chose.
		  
		  if(str==null || str==""){
		  	alert(_("edocLang.edoc_alertSelOneSuperviseDetail"));
		  	return false;
		  }

		 //-- justification end.	
		 	
			str = str.substring(0,str.length-1);
			
			if(window.confirm(_("edocLang.edoc_supervise_delete_alert"))){
				document.location.href='${supervise}?method=deleteSuperviseDetail&id='+str;
				window.location.href='${supervise}?method=list&status=1';
			}
	}
		
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	

	myBar.add(
		new WebFXMenuButton(
			"edoc.supervise.transacted.without", 
			"<fmt:message key='common.toolbar.transacted.without.label' bundle='${v3xCommonI18N}'/>", 
			"findListByStatus(0)", 
			[4,2],
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
			"edoc.supervise.transacted.done", 
			"<fmt:message key='common.toolbar.transacted.done.label' bundle='${v3xCommonI18N}'/>",  
			"findListByStatus(1)", 
			[4,3], 
			"", 
			null
			)
	);
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.showAffair.label' bundle='${v3xCommonI18N}'/>", 
			"showAffair();", 
			[4,4],
			"", 
			null
			)
	);		
	
	if(status == 1){//如果改事项已办结,出现删除按钮
		myBar.add(
			new WebFXMenuButton(
				"newBtn", 
				"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
				"deleteItem();", 
				[1,3],
				"", 
				null
				)
		);	
	}
	
	function editPlan(id){
		//parent.detailFrame.location.href="${supervise}?method=detail&superviseId="+id+"&openModal=list";	
		
		var _url = "${supervise}?method=detail&superviseId="+id+"&openModal=list";
		v3x.openWindow({
			url:  _url,
			FullScrean: 'yes',
			resizable : 'no'
		});
		
	}
	
	function showByStatus(){
		window.document.searchForm.submit();
	}

	function changeDate(who){
		whenstart('${pageContext.request.contextPath}', this, width, height);
	}

	function parseDate_v2(dateStr){//原addDate.js中parseDate存在转换后月份加1的问题。
		var ds = dateStr.split("-");
		var y = parseInt(ds[0], 10);
		var m = parseInt(ds[1], 10);
		var d = parseInt(ds[2], 10);
	
		return new Date(y, m-1, d);
	}

	function selectDateTime(request,obj,width,height,superviseId,subject,label){
		
		var org_value = obj.value;//取得原始督办时间
		var now = new Date();//当前系统时间
		//设置allowEmpty，会由JSCalendar.js中的innerhtml来控制是否加入“清空”（false不加入清空）		
		whenstart(request,obj, width, height,"datetime",false);
		if(obj.value == undefined || obj.value == "undefined" || !obj || obj.value == ''){
			return;
		}
		var obj_date = parseDate_v2(obj.value);//设定后的督办时间
		

		if(org_value==obj.value){//如果选择日期等于督办日期,不做任何操作
			obj.value = org_value;
			return false;
		}

		if(obj_date<now){
			if(!window.confirm(v3x.getMessage("edocLang.edoc_alertTimeIsOverDue"))){
				obj.value = org_value;
				return false;
			}
		}

		

		
		var sendForm = document.getElementById("sendForm");
		sendForm.action = '${supervise}?method=change&superviseId='+superviseId +'&endDate='+obj.value+'&subject='+encodeURI(subject)+'&label='+label;
		sendForm.submit();
		
		parent.location.reload(true);
	}
	
	function showDescription(superviseId,content,label){
		var _url = baseUrl + 'showDescription&superviseId='+superviseId+'&content='+encodeURI(content);
		var content = v3x.openWindow({
			url:  _url,
			height : 370,
			width  : 350,
			resizable : 'no'
		});
	 	if(content!=null){
			sendForm.method="POST";
			sendForm.action = '${supervise}?method=updateContent&superviseId='+superviseId+'&label='+label+'&content='+encodeURIComponent(content);
			sendForm.submit();
			
		parent.location.reload(true);			
		}
	}
	
	function showDigramOnly(edocId,superviseId){
		var _url = "${supervise}?method=showDigramOnly&edocId="+edocId+"&superviseId="+superviseId;
    	var rv = v3x.openWindow({
        	url: _url,
        	width: 860,
        	height: 690,
        	resizable: "no"
    });
	if(rv){
		parent.parent.location.reload(true);
	}
        //        parent.location.href = '../../../portal/_ns:YVAtMTBkZjFmNmRjMWItMTAwMDF8YzB8ZDB8ZV9zcGFnZT0xPS9jb2xsYWJvcmF0aW9uLmRv/seeyon/collaboration.psml?method=collaborationFrame&from=Pending'
        //        top.showPanel('collaboration_pending');
	}
	
	function showLog(superviseId){
		var _url = "${supervise}?method=logEntry&superviseId="+superviseId;
		v3x.openWindow({
			url: _url,
			height : 600,
			width  : 800
		});
	}
	
	function doMySearch(){
		var textX = document.getElementById("textfieldX");
		var textY = document.getElementById("textfieldY");
		var textA = document.getElementById("textfieldA");
		var textB = document.getElementById("textfieldB");

		if(textX && textY && textX.value != '' && textY.value != ''){
			var date1 =  parseDate(textX.value);
			var date2 =  parseDate(textY.value);
			
			if(date1 > date2){
				alert(_("edocLang.log_search_overtime"));
			    textX.value = '';
		        textY.value = '';
				return;
			}
		}
		
		
		if(textA && textB && textA.value != '' && textB.value != ''){
			var date1 =  parseDate(textA.value);
			var date2 =  parseDate(textB.value);
			
			if(date1 > date2){
				alert(_("edocLang.log_search_overtime"));
			    textA.value = '';
			    textB.value = '';
				return;
			}
		}
		
		doSearch();
		
	}
	
	function pressSearch(){
		if(event.keyCode == 13){
				doMySearch();
    		}
	}
//-->

</script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;		
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onload="setMenuState('${label}');">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td height="26" class="webfx-menu-bar">
			<script type="text/javascript">
			   <v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
				document.write(myBar);	
				document.close();
			</script>
		</td>
		<td class="webfx-menu-bar"><form action="" name="searchForm" id="searchForm" method="get"  onkeypress="pressSearch();" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
            <input type="hidden" name="status" id="status" value="${status}" />		
            <input type="hidden" name="edocType" id="edocType" value="${edocType}">	
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" onChange="showNextSpecialCondition(this)" class="" style="height:90%;margin-top:0px;margin-bottom:0px;">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="subject"><fmt:message key="edoc.supervise.title" /></option>
					    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
				 		<option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>  
					    <option value="createPerson"><fmt:message key="edoc.supervise.sender" /></option>					    
					    <option value="createDate"><fmt:message key="edoc.supervise.startdate" /></option>
					    <option value="supervisors"><fmt:message key="edoc.supervise.supervisor" /></option>
					    <option value="awakeDate"><fmt:message key="edoc.supervise.deadline" /></option>
					    <c:if test="${edocType==1}">
					    <option value="sendUnit"><fmt:message key="edoc.supervise.sendUnit" /></option>
					    </c:if>
					    <%-- 根据国家行政公文规范,去掉主题词
					    <option value="keywords"><fmt:message key="edoc.element.keyword"/></option> --%> 
					    <option value="secretLevel"><fmt:message key="edoc.element.secretlevel.simple"/></option>
					    <option value="urgentLevel"><fmt:message key="edoc.element.urgentlevel"/></option>
					    
					    
				  	</select>
			  	</div>
			  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="supervisorsDiv" class="div-float hidden"><input type="text" name="textfield"  class="textfield"></div>
			  	<div id="createPersonDiv" class="div-float hidden"><input type="text" name="textfield"  class="textfield"></div>

			  	<div id="createDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="textfieldX" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="textfieldY" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<div id="awakeDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="textfieldA" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="textfieldB" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<c:if test="${edocType==1}">
			  	<div id="sendUnitDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	</c:if>		  	
			  	<div id="secretLevelDiv" class="div-float hidden">
			  		<select name="textfield" class="condition" style="width:90px">
			  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
			  			<c:forEach var="secret" items="${colMetadata['edoc_secret_level'].items}"> 
			  				<c:if test="${secret.state == 1}">
			  				<option value="${secret.value}">
			  					<c:choose>
								<c:when test="${secret.i18n == 1 }">
								<fmt:message key="${secret.label}"/>
								</c:when>
								<c:otherwise>
								${secret.label}
								</c:otherwise>
								</c:choose>
			  				</option>
			  				</c:if>
			  			</c:forEach>
			  		</select>	
			  	</div>
			  	<div id="urgentLevelDiv" class="div-float hidden">
			  		<select name="textfield" class="condition" style="width:90px">
			  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
			  			<c:forEach var="urgent" items="${colMetadata['edoc_urgent_level'].items}"> 
			  				<c:if test="${urgent.state == 1}">
			  				<option value="${urgent.value}">
			  				<c:choose>
								<c:when test="${urgent.i18n == 1 }">
								<fmt:message key="${urgent.label}"/>
								</c:when>
								<c:otherwise>
								${urgent.label}
								</c:otherwise>
								</c:choose>
			  				</option>
			  				</c:if>
			  			</c:forEach>
			  		</select>
			  	</div>
			  	<div onclick="javascript:doMySearch()" class="condition-search-button"></div>
		  	</div></form>
		</td>		
	</tr>
</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
<form name="sendForm" id="sendForm" method="post">
<input type="hidden" name="caseProcessXML" id="caseProcessXML" value="${caseProcessXML }">
<input type="hidden" name="caseLogXML" id="caseLogXML" value="${caseLogXML }">
<input type="hidden" name="caseWorkItemLogXML" id="caseWorkItemLogXML" value="${caseWorkItemLogXML }">
<input type="hidden" name="process_desc_by" id="process_desc_by" value="" />
<input type="hidden" name="process_xml" id="process_xml" value="" />
<input type="hidden" name="actorId" value="${actorId}"/> 
<input type="hidden" name="activityId" id="activityId" value="">
<input type="hidden" name="workflowInfo" class="input-100per cursor-hand">
<input type="hidden" name="content" id="content" value="" />
<input type="hidden" name="processId" id="processId" value="">
<input type="hidden" name="operationType" id="operationType" value="">
<input type="hidden" name="edocType" id="edocType" value="${edocType}">
<c:set var="defClass" value="cursor-hand sort" />
<c:if test="${status == 1}">
	<c:set var="defClass" value="sort" />
</c:if>
<span id="selectPeoplePanel"></span>

<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" className="sort ellipsis">
	<v3x:column width="33" align="center"
		label="<input type='checkbox' onclick='selectAllValues(this, \"id\")'/>" className="cursor-hand sort">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" summaryId="${bean.edocId}" <c:if test="${bean.id==param.id}" >checked</c:if> />
	</v3x:column>
	<%--
	<v3x:column width="9%" type="String" onClick="editPlan('${bean.id}');" align="left"
		label="edoc.supervise.secretlevel" className="cursor-hand sort">
			<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${bean.secretLevel}"/>
	</v3x:column>
	--%>
	<v3x:column width="9%" type="String" onClick="editPlan('${bean.id}');" align="left"
		label="edoc.supervise.type" className="cursor-hand sort">
			<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.edocType}" />
	</v3x:column>
	<v3x:column width="27%" type="String" maxLength="26" onClick="editPlan('${bean.id}');" align="left" value="${bean.title}"
		label="edoc.supervise.title" className="cursor-hand sort" hasAttachments="${bean.hasAttachment}" 
		importantLevel="${bean.urgentLevel}" bodyType="${bean.bodyType}" symbol="...">
	</v3x:column>

	<v3x:column width="8%" type="String" onClick="editPlan('${bean.id}');" align="left" maxLength="10"
		label="edoc.supervise.sender" className="cursor-hand sort" alt="${bean.sender}" symbol="...">
		${bean.sender}
	</v3x:column>
	<fmt:formatDate value="${bean.startDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd" var="ampDate"/>
	<v3x:column width="10%" type="String" onClick="editPlan('${bean.id}');" align="left"
		label="edoc.supervise.startdate" className="cursor-hand sort" alt="${ampDate}" value="${ampDate}">
		
	</v3x:column>
	<v3x:column width="9%" type="String" onClick="editPlan('${bean.id}');" align="left"
		label="edoc.supervise.supervisor" value="${bean.supervisor}" maxLength="12" className="cursor-hand sort" alt="${bean.supervisor}" symbol="...">
		
	</v3x:column>

	<fmt:message var="isOvertop" key='process.mouseover.overtop.${bean.workflowTimeout}.title'/>
	<v3x:column width="9%" type="String" onClick="editPlan('${bean.id}');" align="center"  className="cursor-hand sort deadline-${bean.workflowTimeout}"
		label="process.cycle.label"  maxLength="15" symbol="...">
		<span id="deadline${bean.id}"><v3x:metadataItemLabel metadata="${deadlineMetadata}" value="${bean.deadline}"/></span>
		<script>
		try{
			if(document.getElementById("deadline${bean.id}").innerHTML.length==0){
				var nowMinitueValue=${bean.deadline};
				var nowDayValue=Math.floor(nowMinitueValue/60/24);
				var minitueValue_mod=nowMinitueValue%(60*24);
				var nowHourValue=Math.floor(minitueValue_mod/60);
				var minitueValue_mod_2=minitueValue_mod%60;
				var nowDayValueStr=nowDayValue!=0?(nowDayValue+"天"):"";
				var nowHourValueStr=nowHourValue!=0?(nowHourValue+"小时"):"";
				var minitueValue_mod_2_str=minitueValue_mod_2!=0?(minitueValue_mod_2+"分钟"):"";
				document.getElementById("deadline${bean.id}").innerHTML=nowDayValueStr+nowHourValueStr+minitueValue_mod_2_str;
			}
		}catch(e){}
		</script>
	</v3x:column>
	<v3x:column width="11%" type="String" onClick="editPlan('${bean.id}');" align="center"  className="cursor-hand sort deadline-${bean.workflowTimeout}"
		label="process.deadlineTime.label"  maxLength="15" symbol="...">
		${v3x:showDeadlineTime(bean.createTime,bean.deadline)!=null?(v3x:showDeadlineTime(bean.createTime,bean.deadline)):"无"}	
	</v3x:column>

	<c:choose>
		<c:when test="${bean.isRed == true}">
			<c:set value="red-input" var="secondClass" /> 
		</c:when>	
		<c:when test="${bean.isRed == false}">
			<c:set value="" var="secondClass" />		
		</c:when>		
		<c:otherwise>
			<c:set value="" var="secondClass" />		
		</c:otherwise>
	</c:choose>
	<c:if test='${bean.status==0}'> 
			<c:set var="clc" value="selectDateTime('${pageContext.request.contextPath}',this,400,200,'${bean.id}','','${label}');"  />
	</c:if>
<fmt:formatDate value='${bean.endDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="endDate"/>	
	<v3x:column width="10%" type="String" onClick="${clc}"  align="center"
		label="edoc.supervise.deadline" className="cursor-hand sort ${secondClass}" 
		value="${endDate}" 
		>
	</v3x:column>
	<v3x:column width="6%" type="String" align="center"
		label="edoc.supervise.press" className="cursor-hand sort">
				<label class="like-a" onclick="showLog('${bean.id}');" id="hastenTimes_${bean.id}">${bean.count}<fmt:message key="edoc.supervise.count" /></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span class="icon_com  reminders_com" <c:if test="${status==0 }">  onclick="showDigramOnly('${bean.edocId}','${bean.id}');" </c:if> >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>		
	</v3x:column>
	<c:if test="${status==0}">
	<v3x:column width="10%" type="String"
		label="edoc.supervise.changeflow" className="${defClass}">	
		<c:if test="${v3x:getBrowserFlagByRequest('HideBrowsers', pageContext.request)}"><span class="icon_com display_block flow_com"  <c:if test='${bean.status==0}'> onclick="showDigarm('${bean.id}','${bean.edocId}');" </c:if> ></span></c:if>
	</v3x:column>
	</c:if>
	<v3x:column width="9%" type="String" onClick='showDescription("${bean.id}","${v3x:toHTML(bean.content)}","${label}");'
		label="edoc.supervise.description" className="cursor-hand sort" align="center">
		[<a href="###" title="<c:out value='${bean.description}' escapeXml='true' default='${bean.description}' />"><fmt:message key="edoc.supervise.content" /></a>]
	</v3x:column>	
</v3x:table>
</form>
</div>
  </div>
</div>
<iframe name="toXmlFrame" scrolling="no" frameborder="1" height="0px" width="0px"></iframe>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.title' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2016"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>