<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="head.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
showCtpLocation("F13_imo");
</script>
<script type="text/javascript">

function openThisWindow()
{
    var sendResult = v3x.openWindow({
	    url : "${imoURL}?method=openModelWindow",
	   width : "400",
	   height : "130",
	   scrollbars:"no"
	});
	if(!sendResult){
	   return;
	}else{
		var x = sendResult.split(",");
		var p1=x[0];
		var p2=x[1];
	    asynchronism(p1,p2);
	}
	
}
function opentruestartWindow(){
	if(confirm("<fmt:message key='org.synchron.startallyes'/>")){
		if(confirm("<fmt:message key='org.synchron.sureagain'/>")){
			 asynchronismAll();
		}
	}
}
function asynchronismAll()
{
	try {
	//定义回调函数
	 getA8Top().startProc('');
	   disableButton("start");
	   enableButton("stop");
	   
	this.invoke = function(ds) {
		try {
			if(ds != null && (typeof ds == 'string'))
			{
			getA8Top().endProc();
			disableButton("stop");
	        enableButton("start");
	        alert(ds);
			window.parent.frames["detailFrame"].location.reload();
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
	var requestCaller = new XMLHttpRequestCaller(this, "ajaxIMOSynchronManager", "asynchronismAll",true);
	requestCaller.serviceRequest();
	}
	catch (ex1) {
		alert("Exception : " + ex1);
	}
}
    function stopSyn()
    {
    	  var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxIMOSynchronController", "stopSynHand",false);
		  var ds1 = requestCaller1.serviceRequest();
		 if(ds1 != null && (typeof ds1 == 'string'))
		  {
	           disableButton("stop");
	           enableButton("start");
	          getA8Top().endProc();
		  }
    }
	function asynchronism(p1,p2)
		{
	    try {
	   getA8Top().startProc('');
	   disableButton("start");
	   enableButton("stop");
    	var isdel=p1;
	    var isovr=p2;
	     
	//定义回调函数
	this.invoke = function(ds) {
		try {
			if(ds != null && (typeof ds == 'string'))
			{
			getA8Top().endProc();
			disableButton("stop");
	        enableButton("start");
	        alert(ds);
	        window.parent.frames["detailFrame"].location.reload();
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxIMOSynchronManager", "asynchronism",true);
		requestCaller.addParameter(1, "String", isdel);
		requestCaller.addParameter(2, "String", isovr);
		requestCaller.serviceRequest();
		}
		catch (ex1) {
			alert("Exception : " + ex1);
		}
}
		
		 function toAutoSet()
		 {
		 parent.detailFrame.document.location.href = "${imoURL}?method=toAutoSynchron&editContent="+1;
		 
		 }
		 
</script>
</head>

<body scroll="no">
<table height="30" width="100%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td height="22" class="webfx-menu-bar">
				<script type="text/javascript">
					var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />" , "" );
					myBar.add(new WebFXMenuButton("startall","<fmt:message key='org.synchron.startall'/>","opentruestartWindow()","<c:url value='/apps_res/imo/images/handsyn.gif'/>","<fmt:message key='org.synchron.startallon'/>", null));
					myBar.add(new WebFXMenuButton("start","<fmt:message key='org.synchron.start'/>","openThisWindow()","<c:url value='/apps_res/imo/images/handsyn.gif'/>","<fmt:message key='org.synchron.starton'/>", null));
					//myBar.add(new WebFXMenuButton("stop","<fmt:message key='org.synchron.stopsynding'/>","stopSyn()","<c:url value='/apps_res/plugin/imo/images/stopsyn.gif'/>","", null));
					//myBar.add(new WebFXMenuButton("autoset","<fmt:message key='org.synchron.autoset'/>","toAutoSet()","<c:url value='/apps_res/plugin/imo/images/autosyn.gif'/>","", null));
					//var myBar2 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />" , "" );
					document.write(myBar);
					//document.write(myBar2);
					document.close();
		    	</script>
	
		</td>
	</tr>
</table>
<script type="text/javascript">
disableButton("stop");
</script>
</body>
</html>