<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title><!-- 意见保留设置 -->
<%@ include file="edocHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

    window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递

	/**
	 *内部方法，向上层页面返回参数
	 */
	function _returnValue(value){
	    if(transParams.popCallbackFn){//该页面被两个地方调用
	        transParams.popCallbackFn(value);
	    }else{
	        transParams.parentWin.seletcOpinionTypeCallback(value);
	    }
	}

	/**
	 *内部方法，关闭当前窗口
	 * @param:clickCancle是否是直接点击的取消按钮
	 */
	function _closeWin(clickCancle){
	     
	    if(clickCancle === 'true' && transParams.parentWin.enablePrecessButtonEdoc){
            transParams.parentWin.enablePrecessButtonEdoc();
        }
	     
	    if(transParams.popWinName){//该页面被两个地方调用
	        transParams.parentWin[transParams.popWinName].close();
	    }else{
	        transParams.parentWin.seletcOpinionTypeWin.close();
	    }
	}
</script>
</head>
<script>
function updateState(){
	var summaryId=document.getElementById("summaryId").value;
	var policy=document.getElementById("policy").value;
	var optionWay=document.getElementsByName("optionWay");
	var optionType=document.getElementById("optionType").value;
	var optionWayValue = "";
	for (i=0;i<optionWay.length;i++){ 
		if(optionWay[i].checked){
			optionWayValue=optionWay[i].value;
		}
	}
	var url=genericURL+"?method=upOptionState&summaryId="+summaryId+"&policy="+encodeURIComponent(policy)+"&optionWay="+optionWayValue
	    +"&optionType="+optionType+"&affairId=${param.affairId}&ndate="+new Date().getTime();
	$('#opinionForm').ajaxSubmit({
        url : url,
    	type : 'post',
    	async : false,
        success : function(data) {
            transParams.parentWin.document.getElementById("optionWay").value=optionWayValue;
			_returnValue(true);
			setTimeout(_closeWin, 100);//延迟关闭，不然会报就Query不存在
        }
    });
}
</script>
<body>
	<form id="opinionForm" action="">
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='edoc.form.flowperm.setup'/></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- lijl添加(意见保留设置 ) -->
					<input type="hidden" name="optionType" id="optionType" value="${optionType}">
					<input type="hidden" name="optionId"   id="optionId" value="${optionId}">
					<input type="hidden" name="summaryId"   id="summaryId" value="${summaryId}">
					<input type="hidden" name="policy"   id="policy" value="${policy}">
					<input type="hidden" name="affairId"   id="affairId" value="${affairId}">
					<fmt:message key="edoc.form.flowperm.setup" />:
				</td>
				<td>
					<!-- lijl添加(只保留最后一次处理意见 )-->
					<input type="radio" id="optionType3" name="optionWay" value="${optionType}_1" checked="checked"/>
					<LABEL for="optionType3"><fmt:message key="edoc.form.flowperm.showLastOptionOnly-s" /></LABEL>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
					<!-- lijl添加(保留所有意见) -->
					<input type="radio" id="optionType4" name="optionWay" value="${optionType}_2" />
					<LABEL for="optionType4"><fmt:message key="edoc.form.flowperm.all-s" /></LABEL>
				</td>
			</tr>
			</table>
			</td>
		</tr>
		<tr>
				<td height="42" align="right" class="bg-advance-bottom">
					<input type="button"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize" onclick="updateState();" />
					<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:_closeWin('true');" />
			   </td>
			</tr>
		</table>
	</form>
</body>
</html>