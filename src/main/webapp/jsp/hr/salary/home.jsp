<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>

<body class="tab-body" scroll="no">
 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="border_lr">

 <tr>
		<td>
		<iframe noresize="noresize" frameborder="no" src="${urlHrSalary}?method=homeEntry" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>
<script type="text/javascript">
showCtpLocation("F03_hrSalary");
getA8Top().endProc();
function sendMessageConfirm(key,state){
	if("impErr" == state){
		parent.getCtpTop().$.messageBox({
	        'type': 100,
	        imgType:2,
	        title:"<fmt:message key='hr.salary.import.sysMsg' bundle='${v3xHRI18N}'/>",
	        'msg': '<span style=""><fmt:message key='hr.salary.import.successpart' bundle='${v3xHRI18N}'/></span><br><br><span style=""><fmt:message key='hr.salary.import.success.messageState' bundle='${v3xHRI18N}'/></span>',
	        buttons: [{
				id:'btn1',
	            text: "<fmt:message key='hr.record.send.label' bundle='${v3xHRI18N}'/>",
	            handler: function () { 
	            	sendMessage(true,key,state); 
	            }
	        }, {
				id:'btn2',
	            text: "<fmt:message key='hr.record.cancel.label' bundle='${v3xHRI18N}'/>",
	            handler: function () { 
	            	sendMessage(false,key,state);
	            }
	        }]
	    });
	}else{
		parent.getCtpTop().$.messageBox({
	        'type': 100,
	        imgType:0,
	        title:"<fmt:message key='hr.salary.import.sysMsg' bundle='${v3xHRI18N}'/>",
	        'msg': '<span style=""><fmt:message key='hr.salary.import.success' bundle='${v3xHRI18N}'/></span><br><br><span style=""><fmt:message key='hr.salary.import.success.messageState' bundle='${v3xHRI18N}'/></span>',
	        buttons: [{
				id:'btn1',
	            text: "<fmt:message key='hr.record.send.label' bundle='${v3xHRI18N}'/>",
	            handler: function () { 
	            	sendMessage(true,key,state); 
	            }
	        }, {
				id:'btn2',
	            text: "<fmt:message key='hr.record.cancel.label' bundle='${v3xHRI18N}'/>",
	            handler: function () { 
	            	sendMessage(false,key,state);
	            }
	        }],
	        close_fn : closeFn
	    });
	}
	
}

function closeFn(){
	getA8Top().reFlesh();
}

function sendMessage(sendState,key,state){
	var datas={sendState:sendState,sendKey:key};
	ajax_sendSalaryMessage(datas,key);
	if("impErr" != state){
		closeFn();
	}
}

function ajax_sendSalaryMessage(datas){
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "salaryManager", "sendSalaryMessage", false);
		requestCaller.addParameter(1, "String", datas.sendState);
		requestCaller.addParameter(2, "String", datas.sendKey);
		requestCaller.serviceRequest();
	}catch(e){
		alert(e);
	}
}


</script>
</body>


</html>