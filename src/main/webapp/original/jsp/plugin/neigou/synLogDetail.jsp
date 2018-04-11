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
    src="${path}/ajax.do?managerName=neigouSynLogManager"></script>
<script type="text/javascript">
	$().ready(function() {
		var logid = "${logid}";
		var ngManager = new neigouSynLogManager();
		 //加载按钮
		  var toolbar = $("#toolbar").toolbar({
				 right:10,
				toolbar: [{
				  id: "back",
				  name: "${ctp:i18n('common.toolbar.back.label')}",
				  className: "",
				  click: function() {
						$("#synLog").submit();
				 }
			 }]
		  });
			
		  var mytable = $("#mytable").ajaxgrid({
				colModel: [
				{
				  display: "${ctp:i18n('neigou.plugin.band.omname')}",
				  name: 'omname',
				  width: '20%',
				  sortable: true
				},
				{
				  display: "${ctp:i18n('neigou.plugin.band.ouname')}",
				  sortable: true,
				  name: 'ouname',
				  width: '20%'
				},
				{
				  display: "${ctp:i18n('neigou.plugin.band.state')}",
				  name: 'status',
				  width: '25%',
				  codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.LogStatusEnum',query:'success'",
				  sortable: true
				},
				{
				  display: "${ctp:i18n('neigou.plugin.band.sync')}",
				  sortable: true,
				  name: 'fail_reason',
				  width: '35%'
				}],
				managerName: "neigouSynLogManager",
				managerMethod: "showViewNeigouSynLog",
				parentId: 'center',
				vChangeParam: {
				  overflow: 'hidden',
				  position: 'relative'
				},
				slideToggleBtn: true,
				showTableToggleBtn: true,
				vChange: true
			  });
			  var o = new Object();
			  o.nid=logid;
			  $("#mytable").ajaxgridLoad(o);
			  mytable.grid.resizeGridUpDown('down');
			
		 
	});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'F21_neigou_synLog'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">        
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
    </div>
	 <form hidden="hidden" id="synLog"
			action="${path}/neigou/neigouSynLogController.do?method=synLog"
			method="post">
	</form>
</div>
</body>
</html>