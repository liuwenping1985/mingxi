<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key='edoc.Temporary.todo.remind'/></title>
<script>
<!-- 
function doSelectZcdbTime(){
	 var _parent = transParams.parentWin;
	 
	var isNotRemind=document.getElementById("isShow");
	if(isNotRemind.checked){
		_parent.isCancelZcdbTime=false;
		if(document.getElementById("nowzcdbTime")!=null){
				_parent.document.getElementById("zcdbTime").value ="";
		}
		transParams.parentWin.doZcdbCallback('true');
		commonDialogClose('win123');
		return;
	}
	var sDate = document.getElementById("nowzcdbTime");
	if(sDate.value == null || sDate.value == ""){
			alert(_("edocLang.edoc_zcdb_selectRemindTime"));
			return;
	}
	 


	 if(document.getElementById("nowzcdbTime")!=null){
		_parent.document.getElementById("zcdbTime").value = document.getElementById("nowzcdbTime").value;
	 }
	 _parent.isCancelZcdbTime=false;
	 transParams.parentWin.doZcdbCallback('true');
	 commonDialogClose('win123');
}

var selectDateTimeCallback_param = {};//选择时间传入回调的值
function selectDateTime(request,obj,width,height){
    
    selectDateTimeCallback_param.obj = obj;
    whenstart(request,obj, width, height,'datetime',false,320,320,{callBackFun:selectDateTimeCallback});
    if(v3x.getBrowserFlag('openWindow') != false){//通过模态窗口打开的
        _vilidateDate(obj);
    }
}

/**
 * 时间选择控件回调函数
 */
function selectDateTimeCallback(retValue){
    var obj = selectDateTimeCallback_param.obj;
    obj.value = retValue;
    _vilidateDate(obj);
}

/**
 * 选时间界面，组件会根据浏览器执行不同的逻辑
 */
function _vilidateDate(obj){
    var now = new Date();//当前系统时间
    if(obj.value != ""){
        var days = obj.value.substring(0,obj.value.indexOf(" "));
        var hours = obj.value.substring(obj.value.indexOf(" "));
        var temp = days.split("-");
        var temp2 = hours.split(":");
        var d1 = new Date(parseInt(temp[0],10),parseInt(temp[1],10)-1,parseInt(temp[2],10),parseInt(temp2[0],10),parseInt(temp2[1],10));
        if(d1.getTime()<now.getTime()){
            //GOV-3460 公文管理，设置暂存代办 提醒时间时，设置小于当前时间也能成功
            document.getElementById("nowzcdbTime").value = "";
            alert(_("edocLang.edoc_zcdb_remind_later_than_now"));
            return false;
        }
    }
}

function initZcdbTime(){
	 var _parent = transParams.parentWin;
	 if(_parent == null){
	    _parent = window.dialogArguments;
	 }
	 if(_parent.document.getElementById("zcdbTime")!=null &&_parent.document.getElementById("zcdbTime").value!=""){
			document.getElementById("nowzcdbTime").value = _parent.document.getElementById("zcdbTime").value;
	 }else{
	      document.getElementById("nowzcdbTime").disabled=true;
	      document.getElementById("isShow").checked="checked";
	 }
}

function changeTimeInputOro(flag){
	if(!flag){
		document.getElementById("nowzcdbTime").disable=false;
	}else{
		document.getElementById("nowzcdbTime").disable=true;
	}
}
//lijl添加,选择不提醒禁用提醒时间文本框
function changeIsShow(flag){
	if(flag.checked){
		document.getElementById("nowzcdbTime").disabled=true;
	}else{
		document.getElementById("nowzcdbTime").disabled=false;
	}
}
//-->
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" onload="initZcdbTime()">
<form name="listForm" id="listForm" action="" method="get" onsubmit="return false" style="margin: 0px">
 <table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
        <td align="center">
               <fmt:message key='zcdbremindtime.label'/>：<input type="text" name="zcdbTime" id="nowzcdbTime" class="cursor-hand"  readonly="true"
           		   onclick="selectDateTime('${pageContext.request.contextPath}',this,400,200);">
        </td>
	</tr>
		<tr>
        <td align="left"  style="padding-left:50px;" valign="top">
           	<input type="checkbox" name="isShow" id="isShow" class="cursor-hand" onclick="changeIsShow(this)">
           	<fmt:message key='zcdb.Noremindtime.label'/>
        </td>
	</tr>
	<tr>
		<td height="30" align="right" class="bg-advance-bottom" valign="bottom">
			<input type="button" onclick="doSelectZcdbTime();" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize">&nbsp;
		</td>
	</tr>
</table>
</form>
</body>
</html>