<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	function rend(txt, data, r, c) {
		return "<a href='#' onclick='showSummary(\""+data.summaryId+"\")'>"+txt+"</a>";
	}
	
	function showSummary(summaryId){
	    window.parent.showDetail(summaryId);
	}
	
	$(function(){
		$('#turnSendEdocInfo').ajaxgrid({
	        colModel: [{
	            display: '日期',
	            name: 'turnDate',
	            sortable : true,
	            width: '50%'
	        },{
	            display: '单位',
	            name: 'unitName',
	            sortable : true,
	            width: '50%'
	        }],
	        render : rend,
	        height: 255,
	        showTableToggleBtn: true,
	        vChange: false,
	        vChangeParam: {
	            overflow: "hidden",
	            autoResize:true
	        },
	        isHaveIframe:false,
	        slideToggleBtn:false,
	        managerName : "govdocRelationManager",
	        managerMethod : "findList"
	    });
	});
	function loadData(){
		var o = new Object();
	    o.referenceId = $("#referenceId").val();
	    o.type = $("#type").val();
	    $('#turnSendEdocInfo').ajaxgridLoad(o);
	}
</script>
</head>
<body onload="loadData()">
	<input id="referenceId" type="hidden" value="${referenceId }"/>
	<input id="type" type="hidden" value="${type }"/>
        <table  class="flexme3 " id="turnSendEdocInfo"></table>
</body>
</html>