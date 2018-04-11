<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../edocHeader.jsp" %>
<script>

    window.transParams = window.transParams || window.parent.transParams;//弹出框参数传递
    
    /**
     *内部方法，向上层页面返回参数
     */
    function _returnValue(value){
        if(transParams.popCallbackFn){//该页面被两个地方调用
            transParams.popCallbackFn(value);
        }else if(transParams.parentWin.taohongWhenTemplateCallback){
        	transParams.parentWin.taohongWhenTemplateCallback(value);
        }else{
        	window.returnValue = ret;
        }
    }
    
    /**
     *内部方法，关闭当前窗口
     */
    function _closeWin(){
        if(transParams.popWinName){//该页面被两个地方调用
            transParams.parentWin[transParams.popWinName].close(transParams.parentWin[transParams.popWinName].index);
        }else{
            transParams.parentWin.taohongWhenTemplateWin.close(transParams.parentWin.taohongWhenTemplateWin.index);
        }
    }

	function returnUrl_old(){

		var str = document.getElementById("fileUrl").value;
		
		var taohongSendUnitType = 1;
		var typeInput = document.getElementsByName("taohongSendUnitType"); 
		if(typeInput[0].checked) {
			taohongSendUnitType = typeInput[0].value; 
		} else {
			taohongSendUnitType = typeInput[1].value;
		}
		
		if(isUniteSend && templateType=="edoc")
		{
		  var ret=new Array(2);
		  ret[0]=str;
		  ret[1]="1";
		  if(document.getElementsByName("contentNum")[1].checked)
		  {
		    ret[1]="2";
		  } 
		  ret[2] = taohongSendUnitType;
		  _returnValue(ret);
		}
		else
		{
			str += "&"+taohongSendUnitType;
			_returnValue(str);
		}
		
		_closeWin();
	}


	function returnUrl(){

		var str = document.getElementById("fileUrl").value;
		if(isUniteSend && templateType=="edoc")
		{
		  var ret=new Array(2);
		  ret[0]=str;
		  ret[1]="1";
		  if(document.getElementsByName("contentNum")[1].checked)
		  {
		    ret[1]="2";
		  }
		  _returnValue(ret);
		}
		else
		{
		    _returnValue(str);
		}
		_closeWin();
	}

	var isUniteSend=${param.isUniteSend};	
	var templateType="${param.templateType}";
</script>
</head>
<body bgColor="#f6f6f6">
<c:if test="${error!=null}">
	<script>
		alert(v3x.getMessage('edocLang.edoc_docTemplate_file_notFound'));
		_closeWin();
	</script>
</c:if>
<c:if test="${haveRecord == true }">
	<script>
		alert(v3x.getMessage('edocLang.edoc_docTemplate_record_notFound'));
		_closeWin();
	</script>	
</c:if>
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="20" class="PopupTitle">&nbsp;</td>
		</tr>
		<tr>
		<td height=60%>
<div style="padding:12px;width=100%;height=75%">
	<table width="100%" height="100%" border="0" cellspacing="5" cellpadding="0" align="center">
	<c:if test="${param.isUniteSend && param.templateType=='edoc'}">
	<tr align="center">
		<td  colspan="2" class="new-column">
			<div nowrap="nowrap" align="left">
			<fmt:message key='templete.select_content.label' />
			
			<label for="contentNum1">
			<input type="radio" value="1" id="contentNum1" name="contentNum" checked> <fmt:message key='edoc.contentnum1.label'/>
			</label>
			<label for="contentNum2">
			<input type="radio" value="2" id="contentNum2" name="contentNum"> <fmt:message key='edoc.contentnum2.label'/>
			</label></div>
		</td>
	</tr>
	</c:if> 
	<tr align="center">
		<td class="new-column"  nowrap="nowrap" align="left" colspan="2">
			<div nowrap="nowrap" align="left"><fmt:message key='templete.select_template.label' /></div>
			<select id="fileUrl" name="fileUrl" style="width:300px">
				<c:forEach items="${templateList}" var="bean">
					<option value="${bean.fileUrl}&${bean.textType}">${bean.name}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	</table>
</div>
</td>
</tr>
	<tr  align="center" valign="bottom">
	<td height="42" align="right" class="bg-advance-bottom">
		<input name="Submit" type="button" onClick="returnUrl();" class="button-default_emphasize"
			value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />
		<input name="close" type="button" onclick="_closeWin();" class="button-default-2"
			value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" />
	</td>
	</tr>
</table>
</body>
</html>