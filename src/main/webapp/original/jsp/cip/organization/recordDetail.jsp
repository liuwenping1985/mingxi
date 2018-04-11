<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript"
    src="${path}/ajax.do?managerName=cipSynRecordManager"></script>
<script type="text/javascript">
$().ready(function() {
   var recordManager  =  new cipSynRecordManager();
	
	//搜索框
	var searchobj = $.searchCondition({
				top : 10,
				right : 10,
				searchHandler : function() {
					var s = searchobj.g.getReturnValue();
					s.recordid = $("#recordid").val();
					$("#mytable").ajaxgridLoad(s);
				},
				conditions : [
						{	id : 'action',
							name : 'action',
							type : 'input',
							text : "${ctp:i18n('cip.org.sync.record.data')}",
							value : 'action'
						},
						{	id : 'data',
							name : 'data',
							type : 'input',
							text : "${ctp:i18n('cip.org.sync.record.action')}",
							value : 'data'
						},
						{	id : 'memo',
							name : 'memo',
							type : 'input',
							text : "${ctp:i18n('cip.org.sync.record.memos')}",
							value : 'memo'
						}]
			});

	//加载表单 
	var mytable = $("#mytable").ajaxgrid(
		{	colModel : [
					{	display : "${ctp:i18n('cip.org.sync.record.data')}",
						sortable : true,
						name : 'action',
						width : '20%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.action')}",
						sortable : true,
						name : 'data',
						width : '30%'
					},
					{	display : "${ctp:i18n('cip.org.sync.record.memos')}",
						sortable : true,
						name : 'memo',
						width : '50%'
					} ],
			managerName : "cipSynRecordManager",
			managerMethod : "showRecordDetailInfo",
			parentId : 'center',
			vChangeParam : {
				overflow : 'hidden',
				position : 'relative'
			},
			vChange : true
		});
		var o = new Object();
		o.recordid = $("#recordid").val();
		$("#mytable").ajaxgridLoad(o);



	});
        
</script>
</head>
<body>
	<input type="hidden" id="recordid" value="${recordid }">
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',code:'F21_neigou_pointquery'"></div>
		<div class="layout_north" layout="height:48,sprit:false,border:false">      
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
		</div>
	</div>
</body>
</html>