<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/ldap/ldap_tools_js.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="${path}/ajax.do?managerName=xcSynManager"></script>
<script type="text/javascript" language="javascript">
  var _path = "${path}";
  var _apiKey = "${apiKey}";
  var ajax_xcSynManager = new xcSynManager();

var mytable;
<!-- 客开 start 查询列表js-->
$().ready(function(){
	 $("#toolbar").toolbar({
      toolbar : [{
        id : "delete",
        name : "${ctp:i18n('xc.syn.operate.delete')}",//选择删除同步日志
        className: "ico16 delete del_16",
		click: del
      },{
        id : "deleteAll",
        name : "${ctp:i18n('xc.syn.delall.js')}",//清空同步日志xc.syn.delall.js
        className: "ico16 delete del_16",
		click: delAll
      }]
    });
		 var mytable = $("#mytable").ajaxgrid({
			 //2 height :100%,
				 // usepager:false,
      colModel : [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },{
        display : "${ctp:i18n('xc.syn.name.js')}",//姓名
        name : 'username',
        width : '10%',
        sortname : 'username',
      },{
        display : "${ctp:i18n('xc.syn.type.dept.js')}",//部门
        name : 'department',
        width : '15%'
      }, {
        display : "${ctp:i18n('xc.syn.type.account.js')}",//单位
        name : 'unit',
        width : '20%'
      },  {
        display : "${ctp:i18n('xc.syn.syntime.js')}",//同步时间
        name : 'operatedate',
        width : '10%'
      }, 
	  {
        display : "${ctp:i18n('xc.syn.operate')}",//操作
        name : 'operate',
        width : '5%'
      },
		  {
        display : "${ctp:i18n('xc.table.th.3.js')}",//状态
        name : 'state',
        width : '5%'
      },
		  {
        display : "${ctp:i18n('xc.syn.case.js')}",//原因
        name : 'cause',
        width : '30%'
      }],
	 // vChange: true,
      managerName : "xcSynManager",
      managerMethod : "xcsyrecord",
	  parentId: 'center',
		  //usepager:true
    });
	var o = new Object();
    $("#mytable").ajaxgridLoad();
	  var searchobj = $.searchCondition({
		   searchHandler: function() {
         orgname = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(orgname);
        },
        top: 7,
        right: 10,
        conditions: [{
          id: 'name',
          name: 'textfield',
          type: 'input',
          text: "${ctp:i18n('xc.syn.name.js')}",
          value: 'name'
        },{
          id: 'unit',
          name: 'unit',
          type: 'input',
          text: "${ctp:i18n('xc.syn.type.account.js')}",
          value: 'unit'
        },{
          id: 'department',
          name: 'textfield',
          type: 'input',
          text: "${ctp:i18n('xc.syn.type.dept.js')}",
          value: 'department'
        },{
          id: 'operate',
          name: 'textfield',
          type: 'select',
          text: "${ctp:i18n('xc.syn.operate')}",
          value: 'operate',
			   items: [{
	            text: "${ctp:i18n('xc.syn.operate.add')}",// 增加
	            value: "增加"
	        }, {
	            text: "${ctp:i18n('xc.syn.operate.update')}",//修改
	            value: "修改"
	        }, {
	            text: "${ctp:i18n('xc.syn.operate.delete')}",//删除
	            value: "删除"
	        }]
			  
        },{
          id: 'state',
          name: 'textfield',
          type: 'select',
          text: "${ctp:i18n('xc.table.th.3.js')}",
          value: 'state',
			   items: [{
	            text: "${ctp:i18n('xc.syn.state.1.js')}",// 成功
	            value: "成功"
	        }, {
	            text: "${ctp:i18n('xc.syn.state.2.js')}",//失败
	            value: "失败"
	        }]
        },{
          id: 'beginDate',
          name: 'textfield',
          type: 'datemulti',
          text: "${ctp:i18n('xc.syn.syntime.js')}",
          value: 'beginDate',
          ifFormat:'%Y-%m-%d',
          dateTime: false
        }]
			  });
});


function delAll(){
 var confirm = $.confirm({
            'title': "删除日志title",
            'msg': "${ctp:i18n('xc.syn.askdelall.js')}",//是否要删除所选择的记录
            ok_fn: function() {
            var success= ajax_xcSynManager.delAll();
			 if(success=="success"){
			 location.reload();
			 }
            },
            cancel_fn: function() {
				location.reload();
				}
          });
}
function del(){
 var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('xc.syn.messagedel.js')}");//请选择要删除的记录！
          return;
      } else {
          var confirm = $.confirm({
            'title': "删除日志title",
            'msg': "${ctp:i18n('xc.syn.askdel.js')}",//是否要删除所选择的记录
            ok_fn: function() {
              var boxs = $("#mytable input:checked");
              if (boxs.length === 0) {
                $.alert("${ctp:i18n('xc.syn.messagedel.js')}");//请选择要删除的记录！
                return;
              } else if (boxs.length >= 1) {  
                var members = new Array();
                boxs.each(function() {
                  members.push($(this).val());
                });
             var S=ajax_xcSynManager.deleteXCsyrecord(members);
			 if(S=="success"){
			 location.reload();
			 }
              }
            },
            cancel_fn: function() {location.reload();}
          });
      }
}

</script>
 <style type="text/css">
   .condition-search-div {
  width: 50px;
}

    </style>
</head>
<body class="over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'xc003'"></div> 
 <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb'"></div>
<!--查询小按钮 start-->
<div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
	 <div id="toolbar"></div>
	<div class="div-float-right condition-search-div"></div>
</div>
<!--查询小按钮 end-->
       <div  class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" style="display: none" class="flexme3">
		</table><!--列表table -->
		</div>
	</div>
</body>
</html>