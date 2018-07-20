<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@include file="head.jsp"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
showCtpLocation("F13_videoconference");
</script>
<script type="text/javascript">

function openThisWindow()
{

    var sendResult = v3x.openWindow({
	    url : "${videoconfURL}?method=openModelWindow",
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
    function stopSyn()
    {
    	  var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxVideoConfController", "stopSynHand",false);
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
			}
		}
		catch (ex1) {
		  alert("Exception : " + ex1);
		}
	}
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxVideoConferenceManager", "asynchronism",true);
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
		 parent.detailFrame.document.location.href = "${videoconfURL}?method=toAutoSynchron&editContent="+1;
		 
		 }
		 
</script>
</head>

<body scroll="no">
<table height="30" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar">
				<script type="text/javascript">
					var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />" , "" );
					myBar.add(new WebFXMenuButton("start","<fmt:message key='org.synchron.start' bundle='${v3xVideoconf}'/>","openThisWindow()","<c:url value='/apps_res/videoconference/images/handsyn.gif'/>","", null));
					document.write(myBar);
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