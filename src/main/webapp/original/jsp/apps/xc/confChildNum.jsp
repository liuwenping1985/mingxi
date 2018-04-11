<%@ page language="java" contentType="text/html; charset=UTF-8"  %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/ldap/ldap_tools_js.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
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
        id : "saveChildNum",
        name : "${ctp:i18n('xc.SubAccountName.add')}",//新建
        className: "ico16",
		  click: function() {
              dialog = $.dialog({
                id:"batchDia",
                url: "${path}/xc/xcController.do?method=saveChild_num",
                title: "${ctp:i18n('xc.SubAccountName.add')}",
                width: 320,
                height: 330,
                buttons: [{
    				text: "${ctp:i18n('common.button.ok.label')}",
    				isEmphasize: true,
    				handler: function() {
						 var rv = dialog.getReturnValue();
						 //处理返回值
						 var num=rv.num;
						 var childnumdesc=rv.childnumdesc;
						 if(num==''){
							$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
						 	return ;
						 }
						 if(childnumdesc.length>100){
							$.alert("${ctp:i18n('xc.SubAccountName.desc.length')}");//描述信息不能大于150个字符长！
							return false;
						 }
						 var ret=ajax_xcSynManager.saveChildNum(num,childnumdesc);
						 if(ret=="success"){
							 dialog.close();
							 location.reload();
						 }else{
							$.alert("${ctp:i18n('xc.SubAccountName.alert.have')}");//子账号已存在！
							return false;
						 }

    				}
    			},
    			{
    				text: "${ctp:i18n('common.button.cancel.label')}",
    				handler: function() {
    					dialog.close();
    				}
    			}]
              });
        }
      },
		  {
        id : "updateChildNum",
        name : "${ctp:i18n('xc.syn.operate.update')}",//修改
        className: "ico16",
		  click: function() {
          var boxs = $("#mytable input:checked");
          if (boxs.length == 0) {
			  $.alert("${ctp:i18n('xc.SubAccountName.update.chose')}");//请选择要修改的数据！
            return;
          }
          if (boxs.length!= 1) {
			  $.alert("${ctp:i18n('xc.SubAccountName.update.choseOne')}");//只能修改一条数据！
            return;
          } else {
            var childnumIds = "";
            boxs.each(function() {
              childnumIds += $(this).val() + ",";
            });
				dialog = $.dialog({
                id:"batchDia",
                url: "${path}/xc/xcController.do?method=childnum_Update&childnumIds="+childnumIds,
                title: "${ctp:i18n('xc.syn.operate.update')}",
                width: 320,
                height: 330,
                buttons: [{
    				text: "${ctp:i18n('common.button.ok.label')}",
    				isEmphasize: true,
    				handler: function() {
						var rv = dialog.getReturnValue();
						//处理返回值
						var num=rv.num;
						var childnumdesc=rv.childnumdesc;
						var childnumIds = rv.childnumIds;
						$("#num").val(num);
						$("#childnumIds").val(childnumIds);
						$("#desc").val(childnumdesc);
						var oldnum = rv.oldnum;
						if(num==''){
							$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
							return ;
						}
						var ret=ajax_xcSynManager.checkChildNum(num,"U");
						var oldret=ajax_xcSynManager.checkChildNum(oldnum,"U");

						if(oldnum==num){
							if(ret=="chose"){
							 var confirm = $.confirm({
											'title': "${ctp:i18n('xc.SubAccountName.del')}",//删除子账户
											'msg': "${ctp:i18n('xc.SubAccountName.alert.update.have')}",//子账号已有数据绑定确定要修改?xc.SubAccountName.alert.update.have
											ok_fn: function() {
												try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc($.i18n('xc.syn.start.js'));}catch(e){}
												dialog.close();
												$("#memberBatFormUpdate").submit();
											},
											cancel_fn: function() {return false;}
										  });
							}else{
								try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc($.i18n('xc.syn.start.js'));}catch(e){}
								dialog.close();
								$("#memberBatFormUpdate").submit();
							}
						}
						else if(oldnum!=num){
						if(ret!="success"){
							$.alert("${ctp:i18n('xc.SubAccountName.alert.update.ok.have')}");//新账号不能与原有账号重复！
							return false;
						}else{
							try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc($.i18n('xc.syn.start.js'));}catch(e){}
							dialog.close();
							$("#memberBatFormUpdate").submit();
							}
						 }
    				}
    			},
    			{
    				text: "${ctp:i18n('common.button.cancel.label')}",
    				handler: function() {
    					dialog.close();
    				}
    			}]
              });
          }
   }
      },{
        id : "delete",
        name : "${ctp:i18n('xc.syn.operate.delete')}",//删除
        className: "ico16 delete del_16",
		click: del
      }]
    });
var mytable = $("#mytable").ajaxgrid({
			 //2 height :100%,
				 // usepager:false,
	  //click:updateChildNum,
      colModel : [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },{
        display : "${ctp:i18n('xc.syn.SubAccountName')}",//子账户
        name : 'childnum',
        width : '15%',
        sortname : 'childnum',
      },{
        display : "${ctp:i18n('xc.SubAccountName.list.desc')}",//子账户描述
        name : 'childnumdesc',
        width : '80%',
        sortname : 'childnumdesc',
      }],
	 // vChange: true,
      managerName : "xcSynManager",
      managerMethod : "ListChildNum",
	  parentId: 'center',
		  //usepager:true
    });
	var o = new Object();
    $("#mytable").ajaxgridLoad();
    function del(){
     var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('xc.SubAccountName.del.chose')}");//请选择要删除的子账户！
          return;
      } else {
          var confirm = $.confirm({
            'title': "${ctp:i18n('xc.SubAccountName.del')}",//删除子账户
            'msg': "${ctp:i18n('xc.SubAccountName.alert.del')}",//确定要删除所选子账户
            ok_fn: function() {
              var boxs = $("#mytable input:checked");
              if (boxs.length === 0) {
                $.alert("${ctp:i18n('xc.SubAccountName.del.chose')}");//请选择要删除的子账号
                return;
              } else if (boxs.length >= 1) {  
                var childnumIds = new Array();
                boxs.each(function() {
                  childnumIds.push($(this).val());
                });
	             var S=ajax_xcSynManager.deleteChildnum(childnumIds);
				 if(S=="success"){
					 $("#mytable").ajaxgridLoad();
				 }else{
					 $.alert("${ctp:i18n('xc.SubAccountName.alert.del.have')}");//当前子账户有数据绑定！
					 return false;
				 }
              }
            }
          });
      }
 } 
});

</script>
 <style type="text/css">
   .condition-search-div {
  width: 50px;
}

    </style>
</head>
<body class="over_hidden">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'xc005'"></div> 
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
	<div class="form_area" display="none">
	 <form id="memberBatFormUpdate" name="memberBatFormUpdate"  method="post" action="xcController.do?method=child_num" >
		<input type="hidden" id="childnumIds" name="childnumIds" value=""/>
		<input type="hidden" id="num" name="num" value=""/>
		<input type="hidden" id="desc" name="desc" value=""/>
	 </form>
   </div>
</body>
</html>