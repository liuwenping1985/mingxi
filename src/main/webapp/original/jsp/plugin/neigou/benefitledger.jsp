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
						$("benefitledgerinfo").hide();
						//搜索框
						var searchobj = $
								.searchCondition({
									top : 8,
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
												value : 'boontype'
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
												value : 'starttime',
												ifFormat : '%Y-%m-%d',
												dateTime : false
											},
											{//订单号
												id : 'search_filed',
												name : 'search_filed',
												type : 'input',
												text : "${ctp:i18n('neigou.plugin.band.ornum')}",
												value : 'billno'
											} ]
								});

						//加载表单 
						var mytable = $("#mytable")
								.ajaxgrid(
										{  colModel : [
													{
														display : 'id',
														name : 'id',
														width : '5%',
														sortable : true,
														align : 'center',
														type : 'checkbox'
													},
													{
														display : "${ctp:i18n('neigou.plugin.band.type')}",
														name : 'boontype',
														width : '20%',
														align : 'center',
														sortable : true
													},
													{
														display : "${ctp:i18n('neigou.plugin.band.name')}",
														sortable : true,
														name : 'name',
														width : '20%'
													},
													{
														display : "${ctp:i18n('neigou.plugin.band.bytime')}",
														sortable : true,
														name : 'starttime',
														sortname : 'starttime',
														sortType : 'number',
														width : '25%'
													},
													{
														display : "${ctp:i18n('neigou.plugin.band.ornum')}",
														sortable : true,
														name : 'billno',
														sortname : 'billno',
														sortType : 'number',
														width : '30%'
													} ],
											managerName : "neigouBenefitLedgerManager",
											managerMethod : "showNeigouBenefitLedger",
											parentId : 'center',
											vChangeParam : {
												overflow : 'hidden',
												position : 'relative'
											},
											slideToggleBtn : true,
											showTableToggleBtn : true,
											render: rend,
											vChange : true
										});
						var o = new Object();
						$("#mytable").ajaxgridLoad(o);
						mytable.grid.resizeGridUpDown('down');

						 function rend(txt, data, r, c) {
							if (c == 4) {
							  return '<a href="javascript:viewByBillno(\'' + data.id + '\')" id="billno' + r + '">' + txt + '</a>';
							} else return txt;
						  }
						
						function griddblclick() {
							var v = $("#mytable").formobj({
								gridFilter : function(data, row) {
									return $("input:checkbox", row)[0].checked;
								}
							});
							if (v.length < 1) {
								$.alert("${ctp:i18n('post.chosce.modify')}");
							} else if (v.length > 1) {
								$
										.alert("${ctp:i18n('once.selected.one.record')}");
							} else {
								var aid = v[0]["id"];
								$("#bfid").val(aid);
								$("#benefitledgerDetail").submit();
							}
						}

					});
	function viewByBillno(id) {
		$("#bfid").val(id);
		$("#benefitledgerDetail").submit();
	}
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
		<form hidden="hidden" id="benefitledgerDetail"
			action="${path}/neigou/neigouBenefitLedgerController.do?method=benefitledgerDetail"
			method="post">
			<input type="hidden" id="bfid" name="bfid" value="">
		</form>
		<form hidden="hidden" id="downLoad"
			action="${path}/neigou/neigouBenefitLedgerController.do?method=downLoad"
			method="post">
			<input type="hidden" id="result" name="result" value="">
		</form>
	</div>
</body>
</html>