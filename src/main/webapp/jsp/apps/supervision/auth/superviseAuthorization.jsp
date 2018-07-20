<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>督办台账单授权</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/passwdcheck.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/agent/css/agent.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="${path}/ajax.do?managerName=supervisionManager"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/agent/js/agent.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript">
	showCtpLocation('F22_supervisionLedger');
	function notNull(){
		var ownerName = document.getElementById("ownerName").value;
		if(ownerName==null||ownerName==""){
			alert("授权人不能为空 ");
			return false;
		}
		//document.getElementById("postForm").action="/supervision/supervisionAuth.do?method=handlesuperviseAuth";
		//document.getElementById("postForm").submit();
		var ownerId=$("#ownerId").val();
		var formIdStr="${formIdStr}";
		var form = new supervisionManager();
			form.changeOwner(formIdStr,ownerId,{
				success : function(msg) {
					if (msg === 'true') {
						$.infor({
							'msg':$.i18n('form.formlist.changeownersucess'),// 更换表单所属人成功!
							ok_fn:function (){
								window.location.reload(true);
							}});
					} else {
						//更换表单所属人失败!
						$.alert($.i18n('form.formlist.changeownererror'));
					}
				},
				error : function(e) {
					// 更换表单所属人失败!
					$.alert($.i18n('form.formlist.changeownererror'));
				}
			});
	}
	
	function showEdit(){
		document.getElementById("submitOk").style.display= "";		
		document.getElementById("ownerName").disabled="";
	}
	
	// 取消编辑
	function notEdit(){
		window.location.reload(true);
		//document.getElementById("submitOk").style.display= "none";		
		//document.getElementById("ownerName").disabled="disabled";
	}
	
	function choseOwner(){
		var dialog = $.dialog({
			url:_ctxPath + "/supervision/supervisionAuth.do?method=setOwner",
		    title : $.i18n('form.base.setformaffiliatedperson.label'),//设置表单所属人
		    width:600,
			height:400,
			targetWindow:getCtpTop(),
			transParams:window,
		    buttons : [{
		    	text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
		    	id:"sure",
		    	handler : function() {
		    		var isOK = dialog.getReturnValue();
		    		if(isOK) dialog.close();
		    	}
		    }, {
		    	text : $.i18n('form.query.cancel.label'),
		    	id:"exit",
		    	handler : function() {
		    		dialog.close();
		    	}
		    }]
		});
	}

</script>

</head>
<body scroll="no" style="overflow:auto;">
	<form id="postForm"  method="post">
		<input type="hidden" name="id" id="logerName" value="${logerName}" />
		<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="" align="center">
			<tr>
				<td height="12" colspan="2" class="border_b">
					<script type="text/javascript">
						var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","");
						// Add By Lif Start
						myBar.add(new WebFXMenuButton("mod",$.i18n('common.toolbar.update.label'),"showEdit()",[1,2],"", null));
						// Add End
						document.write(myBar);
				    	document.close();
			    	</script>
			    </td>
			</tr>
			<tr >
				<td valign="top">
				<div style="padding:40px">
				<fieldset style="height:200px;line-height: 100px;"><legend>　授权　</legend>
				   <div id="editmanageradmins" style="vertical-align: middle">
				   <table width="45%" border="0" cellspacing="0" cellpadding="0" align="center">					
						<tr>
							<td class="bg-gray" width="20%" nowrap="nowrap"><label for="name"> <font color="red">*</font>督办台账单所属人:</label>							
							</td>
							<td class="new-column" width="80%">
								<input  type="text" disabled  onclick="choseOwner()" id="ownerName"  name="ownerName" title="" value="${ownerName}">
								<input type="hidden" name="ownerId" id="ownerId" value="${ownerId}">
							</td>
						</tr>
					</table>
					</div>
				</fieldset>
				</div>
				</td>
			</tr>
			<tr id="submitOk" style="display:none">
				<td height="42" align="center" class="bg-advance-bottom" >
					<input type="button" onclick="notNull()" value="确定"  class="button-default_emphasize">&nbsp;
					<input type="button" id="outUpdate0" onclick="notEdit();" value="取消"class="button-default-2">
				</td>
			</tr>
		</table>
</form>
<div class="hidden">
<iframe id="temp_iframe" name="temp_iframe">&nbsp;</iframe>
</div>
</body>
<script>
	<c:if test="${param.result == true }">
		showEdit();
	</c:if>
</script>
</html>