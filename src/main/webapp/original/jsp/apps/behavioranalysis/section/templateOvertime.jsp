<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="renderer" content="webkit|ie-comp|ie-stand">
	<title>个人行为绩效栏目</title>
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
</head>
<body class="h100b over_hidden">
  <div class="stadic_body_top_bottom  w100b h100b">
      <div class="h100b over_hidden" id="echart"></div>
  </div>
</body>
<jsp:include page="/WEB-INF/jsp/ctp/report/chart/chart_common.jsp" flush="true"/>
<script type="text/javascript">
$(document).ready(function() {
	if($("#echart").width() == 0 || $("#echart").height() ==0){
		return ;
	}
	
	var option = {
	    tooltip : {
	        trigger: 'item',
	      formatter: function (p) {
	          var ret = p.seriesName+'<br/>';
	        	ret = ret + '超期处理数量：'+p.value+'个<br/>';
	        	ret = ret + '超期处理比例：'+p.data.name;
	          return ret;
	        }
	    },
	    legend: {
	       orient:'vertical',
	       x: 'right', 
	       y: 10,
	       selectedMode:false,
	       data:['个人','部门']
	    },
	    calculable : false,
	    xAxis : [
	        {
	            type : 'category',
	            data : []
	        }
	    ],
	    yAxis : [
	        {
	          	name:'数量（个）',
	            type : 'value',
	            splitNumber:5
	        }
	    ],
	    series : [
	        {
	            name:'个人',
	            type:'bar',
	            data:[]
	        },
	        {
	            name:'部门',
	            type:'line',
	            data:[]
	        }
	    ]
	};
	var retMap = ${retMap};
	option.xAxis[0].data = retMap.timeNames;
	option.series[0].data = getDataArr(retMap.memberData);
	option.series[1].data = getDataArr(retMap.depData);
	
// 	et = echarts.init(document.getElementById("echart"));
// 	et.setOption(option);
	var theme = {backgroundColor: '#F9F9F9',grid:{x:40,x2:60,y:30,y2:40}};
 	seeyonUiChartApi.render({dom:"echart", option: option, native: false, theme: theme});
});
function getDataArr(retData){
	var retArr = new Array();
	for(var i=0;i<retData.length;i++){
		var obj = new Object()
		obj.name = retData[i][1];
		obj.value = retData[i][0];
		retArr[i] = obj;
	}
	return retArr;
}
</script>
</html>