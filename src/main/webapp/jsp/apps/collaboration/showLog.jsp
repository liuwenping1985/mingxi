<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/design/formDevelopmentOfadv.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" src="/seeyon/ajax.do?managerName=govdocExchangeManager,colManager"></script>
</head>
<body id='layout' class="comp" comp="type:'layout'">
	<table class="flexme3" id="logDetail"></table>
</body>
<script type="text/javascript">
	var from = '${from}';
	var colModel = [{
		display :"处理人",//处理人
		name : 'userName',
		width : '15%'
	},{
		display :"手机号码",//手机号码
		name : 'phone',
		width : '15%'
	},{
		display :"处理时间",//处理时间
		name : 'time',
		width : '20%'
	},{
		display : "描述",//描述
		name : 'description',
		width : '30%'
	},{
		display :"意见",//当前状态
		name : 'backOpinion',
		width : '20%'
	}];
	if(from != 'lianhe'){
		colModel = [{
			display :"处理人",//处理人
			name : 'userName',
			width : '15%'
		},{
			display :"手机号码",//手机号码
			name : 'phone',
			width : '15%'
		},{
			display :"处理时间",//处理时间
			name : 'time',
			width : '20%'
		},{
			display : "描述",//描述
			name : 'description',
			width : '26%'
		},{
			display :"当前状态",//当前状态
			name : 'status',
			width : '10%'
		},{
			display :"撤销/回退意见",//当前状态
			name : 'backOpinion',
			width : '20%'
		}];
	}
	$('#logDetail').ajaxgrid({
		colModel : colModel,
		render : rend,
		height : 365,
		showTableToggleBtn : true,
		vChange : true,
		vChangeParam : {
			overflow : "hidden",
			autoResize : true
		},
		isHaveIframe : true,
		slideToggleBtn : true,
		managerName : "govdocExchangeManager",
		managerMethod : "getGovdocExchangeDetailLogByDetailId"
	});
	
	$("table.flexme3").ajaxgridLoad({detailId:"${detailId}"});
	function rend(txt, data, r, c) {
		if(from != 'lianhe'){
			if(c == 4){
				if(data.status == 0){
					return "待发送";
				}else if(data.status == 1){
					return "待签收";
				}else if(data.status == 2){
					return "已签收";
				}else if(data.status == 3){
					return "已签收";
				}else if(data.status == 4){
					return "进行中";
				}else if(data.status == 10){
					return "已回退";
				}else if(data.status == 11){
					return "已撤销";
				}else if(data.status == 12){
					return "已终止";
				}else if(data.status == 13){
					return "已结束";
				}
			}
		}
		return txt;
	}
</script>
</html>