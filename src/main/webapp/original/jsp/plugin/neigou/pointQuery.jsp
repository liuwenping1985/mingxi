<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>

<style>
.stadic_head_height {
	height: 0px;
}

.stadic_body_top_bottom {
	bottom: 37px;
	top: 0px;
}

.stadic_footer_height {
	height: 37px;
}
.toobar_head{
	font-size: 16px;
	font-family: Verdana;
	font-weight: bolder;
	color: #888888;
}
.toobar_div{
	min-width: 66px; 
	float: left; 
	margin-right: 10px;
}
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=neigouPointManager"></script>
<script type="text/javascript">
	$().ready(function() {
		var pManager = new neigouPointManager();
		var rcall = new XMLHttpRequestCaller(this,
				"neigouPointManager", "getDongJiePoint", false);
		var pointdata = rcall.serviceRequest();

		$("#toolbar").toolbar({
			});
		
		if (pointdata == null) {
					$("#_allpoint").html("<h2 class='toobar_head'>${ctp:i18n('neigou.plugin.band.allpoint')}:<span>0</span></h2>");
					$("#_freeze").html("<h2 class='toobar_head'>${ctp:i18n('neigou.plugin.band.allfreezpoint')}:<span>0</span></h2>");
					$("#_ypoint").html("<h2  class='toobar_head'>${ctp:i18n('neigou.plugin.band.allavailpoint')}:<span>0</span></h2>");
				} else {
					$("#_allpoint").html("<h2  class='toobar_head'>${ctp:i18n('neigou.plugin.band.allpoint')}:<span>"
											+ pointdata.get("allpoint")+ "</span></h2>");
					$("#_freeze").html("<h2  class='toobar_head'>${ctp:i18n('neigou.plugin.band.allfreezpoint')}:<span>"
											+ pointdata.get("ponit")+ "</span></h2>");
					$("#_ypoint").html("<h2  class='toobar_head'>${ctp:i18n('neigou.plugin.band.allavailpoint')}:<span>"
											+ pointdata.get("ypoint")+ "</span></h2>");
				}

		//搜索框
		var searchobj = $.searchCondition({
					top : 10,
					right : 10,
					searchHandler : function() {
						var s = searchobj.g.getReturnValue();
						$("#mytable").ajaxgridLoad(s);
					},
					conditions : [
							{//福利类型
								id : 'search_type',
								name : 'search_type',
								type : 'input',
								text : "${ctp:i18n('neigou.plugin.band.type')}",
								value : 'typeVal'
							},
							{//发起人
								id : 'search_name',
								name : 'search_name',
								text : "${ctp:i18n('neigou.plugin.band.name')}",
								value : 'name',
								type : 'selectPeople',
								comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1"
							},
							{//发起时间查询
								id : 'search_time',
								name : 'search_time',
								type : 'datemulti',
								text : "${ctp:i18n('neigou.plugin.band.bytime')}",
								value : 'time',
								ifFormat : '%Y-%m-%d',
								dateTime : false
							},
							{//订单号
								id : 'search_filed',
								name : 'search_filed',
								type : 'input',
								text : "${ctp:i18n('neigou.plugin.band.ornum')}",
								value : 'ornum'
							} ]
				});
				//加载表单 
				var mytable = $("#mytable").ajaxgrid(
						{colModel : [
									{	display : 'id',
										name : 'id',
										width : '5%',
										sortable : true,
										align : 'center',
										type : 'checkbox'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.type')}",
										name : 'showvalue',
										width : '15%',
										sortable : true
									},
									{	display : "${ctp:i18n('neigou.plugin.band.name')}",
										sortable : true,
										name : 'name',
										width : '15%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.bytime')}",
										sortable : true,
										name : 'sdate',
										sortname : 'sdate',
										sortType : 'number',
										width : '20%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.ornum')}",
										sortable : true,
										name : 'field0005',
										sortname : 'field0005',
										sortType : 'number',
										width : '25%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.freezpoint')}",
										sortable : true,
										name : 'field0009',
										sortname : 'field0009',
										sortType : 'number',
										width : '20%'
									} ],
							managerName : "neigouPointManager",
							managerMethod : "showNeigouPoint",
							parentId : 'center',
							vChangeParam : {
								overflow : 'hidden',
								position : 'relative'
							},
							slideToggleBtn : true,
							showTableToggleBtn : true,
							vChange : true
						});
				var o = new Object();
				$("#mytable").ajaxgridLoad(o);
				mytable.grid.resizeGridUpDown('down');
		});
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp" comp="type:'breadcrumb',code:'F21_neigou_pointquery'"></div>
		<div class="layout_north" layout="height:48,sprit:false,border:false">        
			<div id="toolbar">
				<div id="_allpoint" class="toobar_div" style="margin-left: 30px;"></div>
				<div id="_freeze" class="toobar_div" style="margin-left: 2px;"></div>
				<div id="_ypoint" class="toobar_div" style="margin-left: 2px;"></div>
			</div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
		</div>
	</div>
</body>
</html>