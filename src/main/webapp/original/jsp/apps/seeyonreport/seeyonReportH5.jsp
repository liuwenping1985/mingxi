<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${subject}</title>
<script type="text/javascript">
	//集群相关信息
	var isCluster = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().isClusterEnabled()%>";
	var mainHost = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().getClusterMainHost()%>";
	var mainHostPort = "<%=com.seeyon.ctp.cluster.ClusterConfigBean.getInstance().getClusterMainHostPort()%>";
	var conditionJSON = ${conditionJSON};
	var reportlet = "${reportlet}";
	
	window.onload = function() {
		var reportShow = document.getElementById("reportShow");
		//构建HTML
		var html = "";
		for (var key in conditionJSON) {
			html += '<input type="hidden" id="' + key + '" name="paramName_' + key +'" value = "' + cjkEncode(conditionJSON[key]) +'">';
		}
		html += '<input type="hidden" id="templateId" name ="templateId" value="${templateId}">';
		html += '<input type="hidden" id="memberId" name ="memberId" value="${CurrentUser.id}">';
		
		//构建URL
		var url = "../../seeyonreport/ReportServer?reportlet=" + cjkEncode(reportlet);
		url = url + "&a8ServerIp=${oahost_ip}&a8ServerPort=${oahost_port}";
		url = url + "&__showtoolbar__=false&__byPagesSize__=false";
			
		reportShow.setAttribute("action", url+ "&op=h5");
		reportShow.innerHTML = html;
		
		reportShow.submit();
	}
	
	function cjkEncode(text) {       
	    if (text == null) {       
	        return "";       
	    }       
	    var newText = "";       
	    for (var i = 0; i < text.length; i++) {       
	        var code = text.charCodeAt (i);        
	        if (code >= 128 || code == 91 || code == 93) {//91 is "[", 93 is "]".       
	            newText += "[" + code.toString(16) + "]";       
	        } else {       
	            newText += text.charAt(i);       
	        }       
	    }       
	    return newText;       
	}
</script>

</head>
<body>
    <form id="reportShow" method="post">
    	<%@include file="seeyonReportDataParameters.jsp"%>
    </form>
</body>
</html>