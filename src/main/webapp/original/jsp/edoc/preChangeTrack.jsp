<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../common/INC/noCache.jsp"%>
<%@ include file="edocHeader.jsp"%>
<title><fmt:message key="common.track.setting" bundle="${v3xCommonI18N}" /></title>

<script type="text/javascript">

    window.transParams = window.transParams || window.parent.transParams || {};//弹出框参数传递

	/**
	 *内部方法，向上层页面返回参数
	 */
	function _returnValue(value){
	    if(transParams.popCallbackFn){//该页面被两个地方调用
	        transParams.popCallbackFn(value);
	    }else{
	        //这个页面原有逻辑没有回调函数
	    }
	}
	
	/**
	 *内部方法，关闭当前窗口
	 */
	function _closeWin(){
	    if(transParams.popWinName){//该页面被两个地方调用
	        transParams.parentWin[transParams.popWinName].close();
	    }else{
	        window.close();
	    }
	}

var _parent = window.opener;
var trackStart="${trackStatus}";
if(window.dialogArguments){
	_parent = window.dialogArguments;
}
if(window.transParams.parentWin){
    _parent = window.transParams.parentWin;
}
var from = "${param.from}";//从什么地方进来的，列表/协同详细页面/...
function ok(){
	var form = document.getElementById("trackForm");
	  var affairid=document.getElementById('affairId').value;
	var track = true;
	var trackMode = '1';
    if(document.getElementById("track_mode").value == '0'){
		trackMode = '0';
		track = false;
	}
    
	var trackLable = v3x.getMessage("collaborationLang.track_" + track);
	var obj = _parent.document.getElementById("track${param.affairId}");
	if(obj){
		if(from == 'collaborationTopic'){	//从协同详细页面点进来的切换图片
			if( trackMode == '1'){//跟踪
				obj.src = "<c:url value='/apps_res/collaboration/images/workflowDealDetail.gif' />";
				obj.title="<fmt:message key='track.no.label'/>";
			}else{
				obj.src = "<c:url value='/apps_res/collaboration/images/workflowDealDetail.gif' />"
				obj.title="<fmt:message key='track.label'/>";
			}
		}else {
			obj.innerText = trackLable;
		}
	  
	}
	var isTrackPartMember ="";
	if(trackMode == '1' && document.getElementById("trackRange_part").checked == true){
		isTrackPartMember  = "&trackMembers=" +document.getElementById("trackMembers").value;
	}
	form.action ="edocController.do?method=changeTrack&trackMode="+trackMode+isTrackPartMember;
    form.submit();
    //_closeWin();//在后台关闭，前台关闭请求不会提交
}

function show(){
	var track_mode = document.getElementById("track_mode").value;
	 var all = document.getElementById("trackRange_all");
     var part = document.getElementById("trackRange_part");
    if(track_mode == '1'){
		document.getElementById("trackRange").style.display="";
		if(part.checked==false){
			all.checked=true;
		 }	
	}else{
		document.getElementById("trackRange").style.display="none";	
		document.getElementById("trackMembers").value='';	
		
	}
}
function setPeople(elements){
	var tarckName="";
	var memeberIds = "";
	if(elements){
		for(var i= 0 ;i<elements.length ; i++){
			if(memeberIds ==""){
				memeberIds = elements[i].id;
			}else{
				memeberIds +=","+elements[i].id;
			}
			 tarckName+=elements[i].name+",";
		}
		document.getElementById("trackMembers").value = memeberIds;
		 trackNameFun(tarckName);
	}
	
}
//截取跟踪指定人长度
function trackNameFun(res){
	var userName="";
	var nameSprit="";
  	userName=res.substring(0,res.length-1);
  	//只显示前三个名字
  	nameSprit=res.split(",");
  	if(nameSprit.length>3){
  		nameSprit=res.split(",", 3);
  		nameSprit+="...";
  	}
  	$("#zdgzryName").attr("title",userName);
	var partText = document.getElementById("zdgzryName");
	partText.style.display="";
	 $("#zdgzryName").val(nameSprit);
}
function selectAll(){
    var partText = document.getElementById("zdgzryName");
    partText.style.display="none";
}
function trackName(){
    var mids="${trackIds}";
	var isFlag="${isTrack}";
	if("" != mids && isFlag=="true"){
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocManager", "getTrackName",false);
		requestCaller.addParameter(1, "String", mids);
		var strName=requestCaller.serviceRequest();
        $("#zdgzryName").val(strName);
        $("#zdgzryName").attr("title",strName);
        var partText = document.getElementById("zdgzryName");
        partText.style.display="";
        document.getElementById("trackMembers").value = mids;
	}
}
function trackRangeFun(){
	 var partText = document.getElementById("zdgzryName");
     partText.style.display="";
	selectPeopleFun_track();
}

</script>
</head>

<body scroll="no" onload="trackName();" onkeypress="listenerKeyESC()">
<c:set value="${v3x:parseElementsOfIds(trackIds, 'Member')}" var="mids"/>
<v3x:selectPeople id="track" panels="Department,Team,Post,Outworker,RelatePeople" selectType="Member" jsFunction="setPeople(elements)" originalElements="${mids}"/>	

<form id="trackForm" name="trackForm" action="" target="trackIframe" method="post" >
<input type="hidden" value="" name="trackMembers" id="trackMembers">
<input type="hidden" name="affairId" id="affairId" value="${param.affairId}">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="30%" class="PopupTitle"><fmt:message key="common.track.setting" bundle="${v3xCommonI18N}" /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  	<tr>
				<td height="40%" colspan="2" style="padding-left:50px;">
					<fmt:message key="track.label"/>
					<select id="track_mode" name="track_mode" style='width:120px' onchange="show()" ${isWorkFlowFinished ? "disabled" : ""}>
						<option value="1" ${isTrack? 'selected':''}> <fmt:message key="common.yes" bundle="${v3xCommonI18N}" /></option>
						<option value="0" ${!isTrack? 'selected':''}> <fmt:message key="common.no" bundle="${v3xCommonI18N}" /> </option>
					</select>
					
				</td>
			</tr>
			<tr id="trackRange" style="display: ${isTrack? '':'none'}">
				<td height="40%" align="center">
				<div align="left"  style="padding-left:  50px;">
					<label for="trackRange_all" style="padding-right: 50px;">
						<input type="radio" name="trackRange" id="trackRange_all" onclick="selectAll()" value="1" ${trackStatus eq 1 and trackIds ==''? 'checked' : ''}
						${isWorkFlowFinished ? "disabled" : ""} />
						<fmt:message key="col.track.all" bundle="${v3xCommonI18N}" />
					</label>
					</div>
					<div  align="left" style="padding-left:  50px;">
					<label for="trackRange_part">
						<input type="radio" name="trackRange"  id="trackRange_part" onclick="trackRangeFun()" value="0" ${(trackStatus eq 2 or trackStatus eq 1)  and trackIds !=''? 'checked' : ''}
						${isWorkFlowFinished ? "disabled" : ""} />
						<fmt:message key="col.track.part" bundle="${v3xCommonI18N}" />
						 <input type="text" style="display: none" id="zdgzryName" name="zdgzryName" size="10" onclick="selectPeopleFun_track()"/>
					</label>
					</div>
					<!--<%--被选中并且流程结束 --%> 母军，王为同意屏蔽
					OA-69300协同、公文：到已办页面，点击对跟踪的修改，流程结束的，多了个查看
					<c:if test="${not empty trackIds and isWorkFlowFinished}">
						<span class="link-blue" onclick="selectPeopleFun_track()">
							<fmt:message key="col.track.part.see" bundle="${v3xCommonI18N}" />
						</span>
					</c:if>
				-->
				</td>
				<td height="40%" align="center">
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="30%" align="center" class="bg-advance-bottom">
			<c:if test="${!isWorkFlowFinished}">
				<input type="button" name="b1" onclick="ok()" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default_emphasize"/>&nbsp;
			</c:if>
			<input type="button" name="b2" onclick="_closeWin()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</td>
	</tr>
</table>

</form>
<iframe src="" name="trackIframe" id="trackIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>