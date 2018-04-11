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
	
	var textArr= ['发起数量+处理数量','发起数量+处理数量','发送计划数量', '回执会议数量','新增文档数量','新闻/公告阅读数量+<br/>调查的回复数量+讨论/分享的评论数量'];
	var option = {
	    tooltip : {
	        trigger: 'item',
	      	formatter: function (p) {
	      		var ret = p.name +'('+ textArr[p.dataIndex] +')<br/>';
	        	ret = ret + p.seriesName +':'+p.value+'个<br/>';
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
	option.xAxis[0].data = ['自由协同','模板流程','计划发送','会议回执','新增文档','文化建设'];
	option.series[0].data = retMap.memberData;
	option.series[1].data = retMap.depData;
	
// 	et = echarts.init(document.getElementById("echart"));
// 	et.setOption(option);
	var theme = {backgroundColor: '#F9F9F9',grid:{x:50,x2:60,y:30,y2:40}};
	seeyonUiChartApi.render({dom:"echart", option: option, native: false, theme:theme});
});
</script>
</html>