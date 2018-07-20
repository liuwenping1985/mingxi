<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style>
	.stadic_head_height{
		height:0px;
	}
	.stadic_body_top_bottom{
		bottom: 37px;
 		top: 0px;
	}
	.stadic_footer_height{
		height: 37px;
	}
</style>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=departmentManager,orgManager,iOManager"></script>
<script type="text/javascript">
	var oManager = new orgManager();
$().ready(function() {
  var isA6s = "${isA6s}";//A6-s任务项，如果是A6s屏蔽部门空间这一行和选项，并默认不开启
  if(isA6s == "true") {
    $("#trDeptSpace").hide();
  }
  var dManager = new departmentManager();
  //var rolelist = dManager.getDepRoles()["deproles"];
  $("#depform").hide();
  $("#button").hide();
  function clk(e, treeId, node) {
    if (node.level == 0) {
      $("#depform").hide();
      $("#welcome").show();
      $("#button").hide();
    } else {
      var deptdetil = dManager.viewDept(node.id);
      $("#depform").clearform();
      $("#addForm").fillform(deptdetil);
      
      $("#depform").show();
      $("#welcome").hide();
      $("#button").hide();

      $("#depform").disable();
      $("#viewbutton").show();
    }
    var rolelist = dManager.getDepRoles()["deproles"];
    for(i=0;i<rolelist.length;i++){
      if(rolelist[i]['code']!="DepLeader")
      $("#deptrole"+i).addClass("w100b");
    }
  }
  function dbclk(e, treeId, node) {
    if(null == node) return;
    var nodes = $("#deptTree").treeObj().getSelectedNodes();
    if (nodes.length < 1 ) {
    	$.alert("${ctp:i18n('org.dept.must')}");
    }else if(nodes[0].level == 0){
    	return;
    }else {
      $("#depform").show();
      $("#welcome").hide();
      $("#depform").enable();
      $("#button").show();
      $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
      $("#conti").removeAttr("checked");
      $("#lconti").hide();
      $("#viewbutton").show();
      $("#deptLevel").attr("disabled",true);
    }
  }
  function treeSuccess(){
    var node = $("#deptTree").treeObj().getSelectedNodes();
    if(node && node[0]){
      var nod = $("#deptTree").treeObj().getNodeByParam("id", node[0].id);
      $("#deptTree").treeObj().selectNode(nod);
    }
    $("#name").focus();
  }
  //新建部门
  function addform() {
    $("#depform").clearform({
      clearHidden: true
    });

    $("#depform").enable();
    dManager.addDept({
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);
      }
    });
    $("#depform").show();
    $("#viewbutton").hide();
    $("#button").show();
    $("#welcome").hide();
    //自动填写上级部门
     var nodes = $("#deptTree").treeObj().getSelectedNodes();
     var rootnodes = $("#deptTree").treeObj().getNodes();
     //alert(nodes);
     if (nodes.length > 0) {
     	if(rootnodes[0].id==nodes[0].id){
     		$("#superDepartment").comp({
         value: 'Account|' + nodes[0].id,
         text: nodes[0].name
       });
     	}else{
       		$("#superDepartment").comp({
         		value: 'Department|' + nodes[0].id,
         		text: nodes[0].name
       		});
     	}
     } else {
       
       $("#superDepartment").comp({
         value: 'Account|' + rootnodes[0].id,
         text: rootnodes[0].name
       });
     }
    $("input[name=enabled]:eq(0)").attr("checked", 'checked');
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("input[name=createDeptSpace]:eq(1)").attr("checked", 'checked');
    $("#lconti").show();
    $("#name").focus();
    $("#conti").attr("checked",'checked'); 
  }

  var imanager = new iOManager();
  $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
      }
    },
    {
      id: "modify",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: function() {
        dbclk(null,null,1);
      }
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.button.delete.label')}",
      className: "ico16 del_16",
      click: function() {
        var nodes = $("#deptTree").treeObj().getSelectedNodes();
        if (nodes.length < 1 || nodes[0].level == 0) {
        	$.alert("${ctp:i18n('depatition.delete')}");		
        } else {
        	$.confirm({
            'msg': "${ctp:i18n('depatition.delete.ok')}",
            ok_fn: function() {
              //$("#depform").enable();
              dManager.deleteDept($("#addForm").formobj(), {
                success: function() {
                  var nodes = $("#deptTree").treeObj().getNodes();
                  $("#deptTree").treeObj().selectNode(nodes[0]);
                  $("#depform").hide();
                  $("#welcome").show();
                  $("#button").hide();
                  $("#deptTree").treeObj().reAsyncChildNodes(null, "refresh", false);
                }
              }
              );
            }
          });
        };
      }
    },
    {
      id: "import_export",
      name: "${ctp:i18n('export.or.import')}",
      className: "ico16 import_16",
      subMenu: [{
        name: "${ctp:i18n('import.excel')}",
        click: function() {
          dialog = $.dialog({
            width: 600,
            height: 300,
            isDrag: false,
            //targetWindow:window.parent,
            //BUG请不要打开这个属性，否则弹出窗口取得对象无法关闭这个框
            id: 'importdialog',
            url: '${path}/organization/organizationControll.do?method=importExcel&importType=department',
            title: "${ctp:i18n('import.excel')}",
            closeParam:{
              'show':true,
              handler:function(){
                $("#depform").hide();
                $("#welcome").show();
                $("#button").hide();
                $("#deptTree").treeObj().reAsyncChildNodes(null, "refresh", false);
              }
            }
          });
        }
      },
      {
        name: "${ctp:i18n('org.template.excel.download_temp')}",
        click: function() {
          var downloadUrl = "${path}/organization/organizationControll.do?method=downloadTemplate&type=Department";
          var eurl = "<c:url value='" + downloadUrl + "' />";
          exportIFrame.location.href = eurl;
        }
      },
      {
        name: "${ctp:i18n('org.post_form.export.exel')}",
        click: function() {
            $.alert({
              'title': "${ctp:i18n('common.prompt')}",
              'msg': "${ctp:i18n('member.export.prompt.wait')}",
              ok_fn: function() {
                imanager.canIO({
                    success: function(rel) {
                      if ('ok' == rel) {
                        var downloadUrl_e = "${path}/organization/department.do?method=exportDepartments";
                        var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
                        exportIFrame.location.href = eurl_e;
                      }
                    }
                  });
                }
            });
        }
      }]
    },
    {
      id: "view",
      name: "${ctp:i18n('common.toolbar.viewswitch.label')}",
      className: "ico16 view_switch_16",
      click: function() {
        location.href = "${path}/organization/department.do?method=showDepartmentFrame&style=list";
      }
    }]
  });

  $("#deptTree").tree({
    onClick: clk,
    onDblClick: dbclk,
    idKey: "id",
    pIdKey: "parentId",
    nameKey: "name",
    managerName: "departmentManager",
    onAsyncSuccess : treeSuccess,
    managerMethod: "showDepartmentTree",
    nodeHandler: function(n) {
      if (n.data.parentId == n.data.id) {
        n.open = true;
      } else {
        n.open = false;
      }
    }
  });
  $("#deptTree").treeObj().reAsyncChildNodes(null, "refresh", false);
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#btnok").click(function() {
    if(!($("#addForm").validate())){
      return;
    }
    if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
    var rootnodes = $("#deptTree").treeObj().getNodes();
    $("#orgAccountId").val(rootnodes[0].id);
    var oldid = $("#id").val();
    dManager.createDept($("#addForm").formobj(), {
      success: function(depBean) {
        try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        $("#id").val(depBean);
        var nodes = $("#deptTree").treeObj().getSelectedNodes();
        var data = $("#addForm").formobj();
        if ($("#conti").attr("checked") == "checked") {
          var tempsuperdept= $("#superDepartment").val();
          var tempsuperdept_txt= $("#superDepartment_txt").val();
          addform();
          $("#superDepartment").val(tempsuperdept);
          $("#superDepartment_txt").val(tempsuperdept_txt);
        } else {
          $("#depform").hide();
          $("#welcome").show();
          $("#button").hide();
        }
        $("#deptTree").treeObj().reAsyncChildNodes(null, "refresh", false);
        //$("#deptTree").treeObj().cancelSelectedNode();
      }
    });

  });

});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
  <div class="comp" comp="type:'breadcrumb',code:'T02_showDepartmentFrameTree'"></div>
  <div class="layout_north" layout="height:30,sprit:false,border:false">
    <div id="toolbar"></div>
  </div>
  <div class="layout_center over_hidden" layout="border:true">
    <div class="stadic_layout">
      <div class="stadic_layout_head stadic_head_height"></div>
      <div class="stadic_layout_body stadic_body_top_bottom">
        <div id="welcome">
          <div id="titleDiv" style="position: absolute;left: 140px;top: 28px;width: 440px;z-index:2;">
            <span id="titlePlace" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #6699cc;padding-right: 20px;" >${ctp:i18n('org.dept_form.manager.label')}</span>
            <div id="Layer1" style="line-height: 2;font-size: 12px;position: absolute;width: 400px;height: 78px;z-index: 1;left: 20px;top: 60px;color: #999999;">
              <ul id="descriptionPlace">${ctp:i18n('organization.detail_info_1909')}</ul>
            </div>
          </div>
        </div>
        <div id="depform" class="form_area">
          <%@include file="deptform.jsp"%></div>
      </div>
      <div class="stadic_layout_footer stadic_footer_height">
        <div id="button" align="center" class="page_color button_container">
          <div class="common_checkbox_box clearfix  bg_color border_t stadic_footer_height padding_t_5">
            <label for="conti" class="margin_r_10 hand" id="lconti">
              <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
            <a id="btnok" href="javascript:void(0)" class="common_button common_button_gray margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="layout_west"
      layout="border:true,width:200,minWidth:50,maxWidth:300">
    <div id="deptTree"></div>
  </div>
</div>
</body>
</html>