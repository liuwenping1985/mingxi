
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@page import="com.seeyon.v3x.exchange.util.Constants"%>
<%@page import="com.seeyon.v3x.edoc.manager.EdocSwitchHelper"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<%@ include file="edocHeader.jsp" %>
	<title><fmt:message key="showDiagram.title"/></title>
	<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
	<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>            
	<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' var="printLabel"/>
	<fmt:message key="common.attribute.label" bundle="${v3xCommonI18N}" var="attributeLabel" />
	<script type="text/javascript">
	<!--
	function parseDate_v2(dateStr){//原addDate.js中parseDate存在转换后月份加1的问题。
		var ds = dateStr.split("-");
		var y = parseInt(ds[0], 10);
		var m = parseInt(ds[1], 10);
		var d = parseInt(ds[2], 10);
	
		return new Date(y, m-1, d);
	}
	
	function selectDateTime(request,obj,width,height){
	var org_value = obj.value;//取得原始督办时间
	var now = new Date();//当前系统时间
	//var obj_date = now.format("yyyy-MM-dd");
	//设置allowEmpty，会由JSCalendar.js中的innerhtml来控制是否加入“清空”（false不加入清空）
	whenstart(request,obj, width, height,"datetime",false);
	
	//OA-49034督办未办结列表修改督办日期，提示：小于当前日期，但是实际上不小于当前日期
    //var obj_date = parseDate_v2(obj.value);//设定后的督办时间
    var obj_date = new Date(obj.value.replace(/-/g,"/"));
	if(obj.value == undefined || obj.value == "undefined" || !obj || obj.value == ''){
		return;
	}
	var now_value = obj.value;//取得更改后督办时间
	if(now_value==org_value){
		return;
	}else{
		if(obj.value!="undefined" && obj.value != "" && obj_date<now){
			if(!window.confirm(v3x.getMessage("collaborationLang.col_alertTimeIsOverDue"))){
				obj.value = org_value;
				return;
			}
		}
	}
	}
	
	function submitSupervise(){
		var superviseForm = document.getElementById("superviseForm");
		if(!checkForm(superviseForm))return;//验证form
		superviseForm.submit();
		if('${param.openModal}'=='list') {
			parent.parent.parent.location.href= parent.parent.parent.location;
		} else if(window.dialogArguments) {
			if(window.dialogArguments.parent.parent.parent && window.dialogArguments.parent.parent.parent.$("#superviseList")[0]) {
				window.dialogArguments.parent.parent.parent.$("#superviseList").ajaxgridLoad();
			}
			window.close();
		} else{
			window.close();
		}		
	}
	function showDigramOnly(summaryId,superviseId){
		var _url = "${supervise}?method=showDigramOnly&summaryId="+summaryId+"&superviseId="+superviseId;
		var _url = "${supervise}?method=showDigramOnly&edocId="+summaryId+"&superviseId="+superviseId;
    	var rv = v3x.openWindow({
        	url: _url,
        	width: 860,
        	height: 690,
        	resizable: "no",
        	dialogType : "open"
    	});
		if(rv){
			parent.superviseIframe.location.href = parent.superviseIframe.location;
		}
	}
	function showLog(superviseId){
		var _dialogType = "modal";
		var isChrome = navigator.userAgent.toLowerCase().match(/chrome/) != null;
		if (isChrome){        
			_dialogType='open';
		}
		var _url = 'detaillog/detaillog.do?method=showSuperviseLog&summaryId=${param.summaryId}';
		v3x.openWindow({
			url: _url,
			height : 600,
			width  : 800,
			resizable: "no",
			dialogType : _dialogType
		});
	}
	//-->
	</script>
</head>
<body scroll="no">
 <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key="edoc.superviseTitle.label" bundle="${colI18N}" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" height="100%">
			<div class="scrollList">
			<form action="${supervise}?method=changeSupervise" name="superviseForm" target="superIframe" id="superviseForm" method="post">
				<input type="hidden" name="superviseId" value="${bean.id}">
				<table width="95%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td width="60"  height="25"><fmt:message key="edoc.supervise.supervisor" />:</td>
						<td align="left">
							<input type="text" readonly="readonly" value='${bean.supervisors}' class="input-100per">
						</td>
					</tr>
					<tr>
						<td width="60"  height="25"><fmt:message key="edoc.supervise.deadline" />:</td>
						<c:set var="clc" value="selectDateTime('${pageContext.request.contextPath}',this,400,200);"  />
						<td align="left">
						<fmt:formatDate value='${bean.awakeDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="endDate"/>
						<input type="text" readonly="readonly" validate="notNull" inputName="<fmt:message key="edoc.supervise.deadline" />" onClick="${(finished!=null && finished==true)?'':clc}" id="awakeDate" name = "awakeDate" value='${endDate}' class="input-100per">
						</td>
					</tr>
					<tr>
						<td width="60"  height="25"><fmt:message key="edoc.hasten.daily.label" bundle="${colI18N}"/>:</td>
						<td align="left">${bean.count}&nbsp;<span class="ico16 view_log_16 cursor-hand" style="vertical-align: middle;" onclick="showLog('${bean.id}');" /></td>
					</tr>
					<tr>
						<td width="60"  height="25"><fmt:message key="col.supervise.title" bundle="${colI18N}"/>:</td>
						<td align="left">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">
							<textarea rows="5" class="input-100per"  name="title" id="title" readonly="readonly">${bean.title}</textarea>
						</td>
					</tr>
					<tr>
						<td width="60"  height="25"><fmt:message key="edoc.supervise.remark" bundle="${colI18N}"/>:</td>
						<td align="left">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2"><textarea rows="7" class="input-100per"  ${(finished!=null && finished==true)?'readonly':'' } inputName="<fmt:message key="col.supervise.remark"  bundle="${colI18N}"/>"  validate="maxLength"  maxSize="200" name="description" id="description" >${bean.description}</textarea></td>
					</tr>
				</table>
			
			</form>
			</div>
			<iframe name="superIframe" id="superIframe" width="0" height="0" frameborder="0"></iframe>
		</td>
	</tr>
	<tr class="${(finished!=null && finished==true)?'hidden':''}">
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="submitSupervise()" value="<fmt:message key="save.and.close"/>"/>
		</td>
	</tr>
</table>
</body>
</html>