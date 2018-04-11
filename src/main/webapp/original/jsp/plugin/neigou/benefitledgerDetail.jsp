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
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=neigouBenefitLedgerManager"></script>
<script type="text/javascript">
	$().ready(function() {
				var pManager = new neigouBenefitLedgerManager();
				var bfid = "${bfid}";
				var searchobj = $.searchCondition({
							top : 8,
							right : 10,
							searchHandler : function() {
								var s = searchobj.g.getReturnValue();
								s.id = bfid;
								$("#mytable").ajaxgridLoad(s);
							},
							conditions : [
									{//发起人
										id : 'search_name',
										name : 'search_name',
										text : "${ctp:i18n('neigou.plugin.band.omname')}",
										value : 'orgmember',
										type : 'selectPeople',
										comp : "type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1"
									} ]
								});
			 //加载按钮
				 var toolbar = $("#toolbar").toolbar({
						 right:10,
						toolbar: [{
						  id: "back",
						  name: "${ctp:i18n('common.toolbar.back.label')}",
						  className: "",
						  click: function() {
								$("#benefitledger").submit();
						 }
						},{				
						id : "daochu",
						name : "${ctp:i18n('neigou.plugin.excel.export')}",
						className : "ico16 export_excel_16",
						click : function() {
						$.confirm({'msg' : "${ctp:i18n('neigou.plugin.excel.exportdetail')}",
									ok_fn : function() {
										$("#result").val(bfid);
										$("#downLoad").submit();
									}
								});
								}					
					}]
				  });		

				var mytable = $("#mytable").ajaxgrid({//加载副页面
							colModel : [
									{	display : "${ctp:i18n('neigou.plugin.band.omname')}",
										name : 'omname',
										width : '10%',
										sortable : true
									},
									{	display : "${ctp:i18n('neigou.plugin.band.ouname')}",
										sortable : true,
										name : 'ouname',
										width : '15%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.olname')}",
										sortable : true,
										name : 'olname',
										width : '15%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.opname')}",
										sortable : true,
										name : 'opname',
										width : '15%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.standard')}",
										sortable : true,
										name : 'standard',
										width : '15%'
									} ,
									{	display : "${ctp:i18n('neigou.plugin.band.bstate')}",
										sortable : true,
										name : 'status',
										codecfg:"codeType:'java',codeId:'com.seeyon.apps.neigou.util.LogStatusEnum',query:'success'",
										width : '10%'
									},
									{	display : "${ctp:i18n('neigou.plugin.band.sync')}",
										sortable : true,
										name : 'failreason',
										width : '20%'
									}],
							managerName : "neigouBenefitLedgerManager",
							managerMethod : "viewBenefitledgerFiInfo",
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
						o.id = bfid;
						$("#mytable").ajaxgridLoad(o);
						mytable.grid.resizeGridUpDown('down');
			});
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="comp"
			comp="type:'breadcrumb',code:'F21_neigou_benefitledger'"></div>
		<div class="layout_north" layout="height:40,sprit:false,border:false">
			<div id="toolbar"></div>
		</div>
		<div class="layout_center over_hidden" layout="border:false"
			id="center">
			<table id="mytable" class="flexme3" border="0" cellspacing="0"
				cellpadding="0"></table>
		</div>
		<form hidden="hidden" id="benefitledger"
			action="${path}/neigou/neigouBenefitLedgerController.do?method=benefitledger"
			method="post">
		</form>
		<form hidden="hidden" id="downLoad"
			action="${path}/neigou/neigouBenefitLedgerController.do?method=downLoad"
			method="post">
			<input type="hidden" id="result" name="result" value="">
		</form>
	</div>
</body>
</html>