<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=EDGE">
<%@ include file="../exchangeHeader.jsp"%>

<style type="text/css">
 html,body {
	width: 100%;
	height: 100%;
	border: 0;
	margin: 0;
	padding: 0;
}
</style>

<script type="text/javascript">

	function checkExchangeRole(typeAndIds)
	{
	try{
	  var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocExchangeManager", "checkExchangeRole",false);
  	  requestCaller.addParameter(1, "String", typeAndIds);  
	  var ds = requestCaller.serviceRequest();
	  if(ds=="check ok"){return true;}
	  else if(ds=="unknow err")
	  {
	    alert(_("ExchangeLang.alert_check_exchangeRole"));
	  }
	  else if(ds.indexOf("LOGOUT")>-1)
	  {
	  	alert(ds);
	  }
	  else
	  {
	    alert(_("ExchangeLang.alert_set_exchangeRole",ds));
	  }
	 }catch(e)
	 {
	   alert(e.description);
	 }
	  return false;
	}
	//ajax判断单位中是否有已经发送的单位.
	function ajaxCheckSomeUnitSent(recordId,unitIds){
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxSendEdocManager", "ajaxCheckContainSpecialUnit", false);
		requestCaller.addParameter(1,"Long", recordId);
		requestCaller.addParameter(2,'String',unitIds);
		return requestCaller.serviceRequest();
	}
	
	
	function oprateSubmit(){
		var hasSursen = "${v3x:hasPlugin('sursenExchange')}";	  
		var id = document.getElementById("id").value;
		var  grantedDepartId= document.getElementById("grantedDepartId").value;
		
		var _innerExchange = false;//是否勾选内部交换，没有书生插件表示勾选了书生交换
		var _sursenExchange = false;//是否勾选书生交换
        var _innerCheckObj = document.getElementById("internalExchange");
        var _sursenCheckObj = document.getElementById("sursenExchange");
        
        if(_innerCheckObj){
       		 if(_innerCheckObj.checked){
            	_innerExchange = true;
       		 }
        }else{
            //没有书生插件
            _innerExchange = true;
        }
        
        if(_sursenCheckObj && _sursenCheckObj.checked){
            _sursenExchange = true;
        }
		
		var checkSendContentType = "${contentType}";
		// 如果不选择 内部交换和 书生交换  则提示  请选择交换类型
		if(hasSursen == "true" && !_innerExchange && !_sursenExchange){
			alert("<fmt:message key='edoc.pleaseChoose.exchangeMode' />"); // 请选择交换方式
			return false;
		}
		if(hasSursen == "true" && _sursenExchange){
			if(checkSendContentType != "OfficeWord" && checkSendContentType != "OfficeExcel"){
				alert("<fmt:message key='edoc.textFormat.notSupported' />");  //  正文格式不支持，书生只支持word及excel正文！
				return ;
			}
			if(parseInt(${subjectWords}) >200){
				alert("<fmt:message key='edoc.sursenSubject.limitWords' />"); // 书生交换标题不能超过200个字符!
				return ;
			}
		}
		//lijl添加,得到送往单位名称
		if('${param.reSend}'=='true') {//补发提示
			var ret = ajaxCheckSomeUnitSent(id,grantedDepartId);
			//转收文类型，不能重复发送
			if("${bean.isTurnRec}" == "1"){
				var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeTurnRecManager", "isCanSent", false);
				requestCaller.addParameter(1,"String", "${bean.edocId}");
				requestCaller.addParameter(2,"String", grantedDepartId);
				ret = requestCaller.serviceRequest();
				if(ret!='true' ) {
					alert(_("ExchangeLang.alert_edoc_hasSendThese_notSend",ret));
					return;
				}
			}
			else{
				//只选书生交换补发的时候不提示重复发送
				if(ret != 'N' && _innerExchange) {
					if(!confirm(_("ExchangeLang.alert_edoc_hasSendThese",ret)))return;
				}
			}
			
		}
		var obj = document.getElementById("detailForm");
		if(_innerExchange || hasSursen == "false"){

			var  depart= document.getElementById("depart").value;
			if("" == depart || depart == null){
				alert(_("ExchangeLang.exchange_account_to_notnull"));
				return;
			}

		
			if(!checkForm(obj)){
	     		return;//验证form
			}
			
			//校验送往单位长度，因为和checkForm校验长度算法不一致，单独校验
			var sendTo = document.getElementById("depart");
			if(sendTo){
				var msg = "";
				msg = validTextareaLength(sendTo.value,4000,"<fmt:message key="exchange.edoc.sendToNames" />",msg);
				if(msg != ""){
					alert(msg);
					return;
				}
			}
	
			if(checkExchangeRole(obj.grantedDepartId.value)==false){return;}
		}

		
		var opsub = document.getElementById("oprateBut");
		opsub.disabled=true;
		obj.submit();		
	}

	function _init_(){
	    initParentTitle();
	    fixGridHeight();//grid高度处理
	}
	
	function initParentTitle(){
        //parent.document.title="${v3x:toHTML(bean.subject)}";
        //GOV-4925 【发文管理-分发】和【收文管理-签收】列表里打开标题有空格的公文时，IE标题里显示有&nbsp字符
		parent.document.title="<v3x:out value='${bean.subject}' escapeJavaScript='true' />";
	}
	
	//老组件没有滚动条的情况先也预留了滚动条高度，这里做修复
	function fixGridHeight(){
        var gHeadHeight = 26;
        var totalHeight = 130;//总高度
        
        var $gBodyEl = $("#bDivsendDetail");
        
        var gTempHeight = $gBodyEl.height();
        var gBodyHeight = parseInt(gTempHeight, 10);
        if(gBodyHeight != 0 && (gBodyHeight + gHeadHeight < totalHeight)){
            gBodyHeight = totalHeight - gHeadHeight;
            $gBodyEl.height(gBodyHeight);
        }else{
            setTimeout(fixGridHeight,300);
        }
	}
	
</script>
</head>
<body scroll="no"  onload="_init_();">
<div class="newDiv" style="width:100%;height:100%;" >
<input type="hidden" name="category" id="category" value="${category}" >
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr>
	<td height="8">
	
	<c:if test="${param.modelType != 'toSend'}">
	<script type="text/javascript">
	getDetailPageBreak();
	</script>
	</c:if>

	</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<div style="height: 100%">
		   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td class="categorySet-1" width="4"></td>
                <td id="typeLabel" name="typeLabel" class="categorySet-title" width="80" nowrap="nowrap">
                    <fmt:message key="exchange.lable.send" />
                </td>
                <td class="categorySet-2" width="7"></td>
                <td class="categorySet-head-space">&nbsp;</td>
            </tr>
           </table>
		</div>
		</td>
	</tr>
	<tr>
		<td valign="top" class="categorySet-head">
		    <div id="send_div" class="categorySet-body" style="overflow-x:hidden;padding: 0;">
                <%@include file="edoc_send_detail.jsp"%>
            </div> 
		</td>
	</tr>
</table>
</div>
</body>
</html>
