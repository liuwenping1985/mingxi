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
		var sys_isGroupVer = "${sys_isGroupVer}";
		var ngManager = new neigouSynLogManager();
		   //$("#viewSynLog").hide();
		//搜索框
		if(sys_isGroupVer=='false'){
			 var searchobj = $.searchCondition({
				   top:8,
				   right:10,
				   searchHandler: function() {
					  var s = searchobj.g.getReturnValue();
					  $("#mytable").ajaxgridLoad(s);
					},
					 conditions: [
					/* {
					  id: 'search_sAccount',
					  name: 'search_sAccount',
					  text: "${ctp:i18n('neigou.plugin.band.unit')}",
					  value: 'orgname',
					  type: 'selectPeople',
					  comp: "type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:1"
					}, */
					{//同步方式
					  id: 'search_status',
					  name: 'search_status',
					  text: "${ctp:i18n('neigou.plugin.band.synchronously')}",
					  value: 'ntype',
					  type: 'select',
					  codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.LogTypeEnum',query:'manual'",
					},
					{//同步时间
					 id: 'search_time',
					 name: 'search_time',
					 type: 'datemulti',
					 text: "${ctp:i18n('neigou.plugin.band.syntime')}",
					 value: 'synch_time',
					 ifFormat:'%Y-%m-%d',
					 dateTime: false
					}]
				 });
		}else{
			 var searchobj = $.searchCondition({
				   top:8,
				   right:10,
				   searchHandler: function() {
					  var s = searchobj.g.getReturnValue();
					  $("#mytable").ajaxgridLoad(s);
					},
					 conditions: [
					{
					  id: 'search_sAccount',
					  name: 'search_sAccount',
					  text: "${ctp:i18n('neigou.plugin.band.unit')}",
					  value: 'orgname',
					  type: 'selectPeople',
					  comp: "type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:1"
					}, 
					{//同步方式
					  id: 'search_status',
					  name: 'search_status',
					  text: "${ctp:i18n('neigou.plugin.band.synchronously')}",
					  value: 'ntype',
					  type: 'select',
					  codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.LogTypeEnum',query:'manual'",
					},
					{//同步时间
					 id: 'search_time',
					 name: 'search_time',
					 type: 'datemulti',
					 text: "${ctp:i18n('neigou.plugin.band.syntime')}",
					 value: 'synch_time',
					 ifFormat:'%Y-%m-%d',
					 dateTime: false
					}]
				 });
		}
		 
		  
		//显示按钮
		/* var toolbar = $("#toolbar").toolbar({
			toolbar: [
			{ id: "delete",
			  name: "${ctp:i18n('common.button.delete.label')}",
			  className: "ico16 del_16",
			  click: function() {
				var v = $("#mytable").formobj({
				  gridFilter: function(data, row) {
					return $("input:checkbox", row)[0].checked;
				  }
				});

				if (v.length < 1) {
				  $.alert("${ctp:i18n('neigou.plugin.band.delete')}");

				} else {
				  var name = "";
				  for (i = 0; i < v.length; i++) {
					if (i != v.length - 1) {
					  name = name + v[i].name + "、";
					} else {
					  name = name + v[i].name;
					}
				  }
				  $.confirm({
					//'msg': $.i18n('没什么'),
					'msg': "${ctp:i18n('neigou.plugin.band.del.ok.js')}",
					ok_fn: function() {
				    ngManager.deNeiGoulog(v, {
					  success: function() {
						location.reload();
					  }
				    });
					}
				  });
				};
			  }
			},{
			  id: "deleteAll",
			  name: "${ctp:i18n('neigou.button.clear.label')}",
			  className: "ico16 del_16",
			  click: function() {
				$.confirm({
					'msg': "${ctp:i18n('neigou.plugin.band.clear')}",
					ok_fn: function() {
					  ngManager.deNeiGoulogAll( {
						success: function() {
							location.reload();
						}
					  });
					}
				  });
				}
			}
			]
		  }); */
		 //加载表单 
		  var mytable = $("#mytable").ajaxgrid({
			colModel: [{
			  display: 'id',
			  name: 'id',
			  width: '5%',
			  sortable: true,
			  align: 'center',
			  type: 'checkbox'
			},
			{
			  display: "${ctp:i18n('neigou.plugin.band.unit')}",
			  name: 'name',
			  width: '35%',
			  sortable: true
			},
			{
			  display: "${ctp:i18n('neigou.plugin.band.synchronously')}",
			  name: 'type',
			  width: '15%',
			  codecfg: "codeType:'java',codeId:'com.seeyon.apps.neigou.util.LogTypeEnum',query:'manual'",
			  sortable: true
			},
			{
			  display: "${ctp:i18n('neigou.plugin.band.syntime')}",
			  sortable: true,
			  name: 'synTime',
			  width: '20%'
			},
			{
			  display: "${ctp:i18n('neigou.plugin.band.oper')}",
			  sortable: true,
			  sortname: 'operation',
			  name: 'operation',
			  width: '25%'
			}],
			managerName: "neigouSynLogManager",
			managerMethod: "showNeigouSynLog",
			parentId: 'center',
			vChangeParam: {
			  overflow: 'hidden',
			  position: 'relative'
			},
			vChange: true,
			vChangeParam: {
			  overflow: "hidden",
			  autoResize: false
			},
			showTableToggleBtn: false,
			resizable: false,
			render: rend,
			slideToggleBtn: false
		  });
		  var o = new Object();
		  $("#mytable").ajaxgridLoad(o);
		  mytable.grid.resizeGridUpDown('down');

		  function rend(txt, data, r, c) {
			if (c == 4) {
			  return '<a >' + txt + '</a>';
			} else return txt;
		  }

		  $("td[abbr='operation']").live('click',function(){
		  var v = $("#mytable").formobj({
				gridFilter : function(data, row) {
				  return $("input:checkbox", row)[0].checked;
				}
			  });
			showview(v[0]["id"]);
		 });
		
		function showview(nid){
			$("#logid").val(nid);
			$("#showLogDetail").submit();
		}
		 
	
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
   <form hidden="hidden" id="showLogDetail"
			action="${path}/neigou/neigouSynLogController.do?method=showLogDetail"
			method="post">
			<input type="hidden" id="logid" name="logid" value="">
	</form>
</div>
</body>
</html>