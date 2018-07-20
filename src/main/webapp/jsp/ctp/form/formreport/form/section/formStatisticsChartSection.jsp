<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/queryReport/formreport_chart.js.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
$(document).ready(function() {
	var ecahrt = ${echartVo};
	var type = "echarts";
	var echartData = new Object();
	
	if(undefined != ecahrt && undefined != ecahrt.option){
		var chartType = "${chartType}";
		type = ecahrt.type;
		echartData = drawingChart2(chartType,JSON.parse(ecahrt.option),"chart1");
	}else{
		echartData = drawingEmptyChart2("chart1")
	}
	
});


</script>
</head>
<body class="h100b over_hidden">
  <div class="stadic_body_top_bottom  w100b h100b">
      <div class="h100b over_hidden" id="chart1"></div>
  </div>
</body>
</html>