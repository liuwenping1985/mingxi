<%--
 $Author: sunzhemin $
 $Rev: 50930 $
 $Date:: 2015-07-27 15:05:08#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=roleManager,orgManager"></script>
<script type="text/javascript">
var nowtab = 1;
var msg = '${ctp:i18n("info.totally")}';
var oManager = new orgManager();
var roleman = new roleManager();
var isallowaccpriv = roleman.getGroupPrivType();
var isgroup = oManager.isGroup();
if (isgroup) {
  nowtab = 0;
} else {
  nowtab = 1;
}
$().ready(function() {

  var isallow = true;
  if (!isgroup && isallowaccpriv == false) {
    isallow = false;
  }
  $("#tab0").click(function() {
    $(this).parent().addClass('current').siblings().removeClass('current');
    nowtab = 0;
    loadTable0();
    /**fb---分级保护插件启用 单位管理员不可进行人员角色分配（去掉）*/
/*     if(!$.ctx.plugins.contains('secret')){
    	toolbar.showBtn("distribution");
    } */
	toolbar.showBtn("distribution");
    toolbar.showBtn("viewmember");

  });
  $("#tab1").click(function() {
    $(this).parent().addClass('current').siblings().removeClass('current');
    nowtab = 1;
    loadTable1();
    if (isgroup) {
      toolbar.hideBtn("distribution");
      toolbar.hideBtn("viewmember");
    }
  });
  $("#tab2").click(function() {
    $(this).parent().addClass('current').siblings().removeClass('current');
    nowtab = 2;
    loadTable2();
    if (isgroup) {
      toolbar.hideBtn("distribution");
      toolbar.hideBtn("viewmember");
    }
  });
  // 列表
  var mytable = $(".mytable").ajaxgrid({
    /* click : clk, */
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('role.name')}",
      name: 'showName',
      sortable: true,
      width: '40%'
    },
    {
      display: "${ctp:i18n('role.type')}",
      name: 'type',
      sortable: true,
      width: '10%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.RoleTypeEnum'"
    },
    {
      display: "${ctp:i18n('role.code')}",
      name: 'code',
      sortable: true,
      width: '25%'
    },
    {
      display: "${ctp:i18n('level.select.state')}",
      name: 'enabled',
      sortable: true,
      width: '10%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.RoleEnabledEnum'"
    },
    {
      display: "${ctp:i18n('role.default')}",
      name: 'isBenchmark',
      sortable: true,
      width: '10%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.RoleIsDefaultEnum'"
    }],
    width: 'auto',
    parentId: "roleList_stadic_body_top_bottom",
    //height:$("#layoutCenter").height()-65,
    managerName: "roleManager",
    managerMethod: "findRoles",
    vChangeParam: {
      overflow: "auto"
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    vChange: true,
    callBackTotle: getCount

  });

  // 手动加载表格数据
  reloadtab();
  var searchobj;
  var ver = "${ctp:getSystemProperty('org.isGroupVer')}";
  //
  if (isgroup||ver=="false") {
	  searchobj = $.searchCondition({
		    top: 2,
		    right: 10,
		    searchHandler: function() {
		      var result = searchobj.g.getReturnValue();
		      if (result) {
		        if (nowtab == 1) {
		          loadTable1(result.condition, result.value);
		        } else if (nowtab == 2) {
		          loadTable2(result.condition, result.value);
		        } else if (nowtab == 0) {
		          loadTable0(result.condition, result.value);
		        }

		      } else {
		        reloadtab();
		      }
		    },
		    conditions: [{
		      id: 'name',
		      name: 'name',
		      type: 'input',
		      text: "${ctp:i18n('role.name')}",
		      value: 'name'
		    },
		    {
		      id: 'type',
		      name: 'type',
		      type: 'select',
		      text: "${ctp:i18n('role.type')}",
		      value: 'type',
		      items: [{
		        text: "${ctp:i18n('role.fixed')}",
		        value: '1'
		      },

		      {
		        text: "${ctp:i18n('role.add')}",
		        value: '3'
		      }]
		    },
		    {
		      id: 'enabled',
		      name: 'enabled',
		      type: 'select',
		      text: "${ctp:i18n('level.select.state')}",
		      value: 'enabled',
		      items: [{
		        text: "${ctp:i18n('role.start')}",
		        value: 'true'
		      },
		      {
		        text: "${ctp:i18n('role.stop')}",
		        value: 'false'
		      }]
		    },
		    {
		      id: 'code',
		      name: 'code',
		      type: 'input',
		      text: "${ctp:i18n('role.code')}",
		      value: 'code'
		    }]
		  });
  }else{
	  searchobj = $.searchCondition({
		    top: 2,
		    right: 10,
		    searchHandler: function() {
		      var result = searchobj.g.getReturnValue();
		      if (result) {
		        if (nowtab == 1) {
		          loadTable1(result.condition, result.value);
		        } else if (nowtab == 2) {
		          loadTable2(result.condition, result.value);
		        } else if (nowtab == 0) {
		          loadTable0(result.condition, result.value);
		        }

		      } else {
		        reloadtab();
		      }
		    },
		    conditions: [{
		      id: 'name',
		      name: 'name',
		      type: 'input',
		      text: "${ctp:i18n('role.name')}",
		      value: 'name'
		    },
		    {
		      id: 'type',
		      name: 'type',
		      type: 'select',
		      text: "${ctp:i18n('role.type')}",
		      value: 'type',
		      items: [
		      {
		        text: "${ctp:i18n('role.reciprocal')}",
		        value: '2'
		      },
		      {
		        text: "${ctp:i18n('role.add')}",
		        value: '3'
		      }]
		    },
		    {
		      id: 'enabled',
		      name: 'enabled',
		      type: 'select',
		      text: "${ctp:i18n('level.select.state')}",
		      value: 'enabled',
		      items: [{
		        text: "${ctp:i18n('role.start')}",
		        value: 'true'
		      },
		      {
		        text: "${ctp:i18n('role.stop')}",
		        value: 'false'
		      }]
		    },
		    {
		      id: 'code',
		      name: 'code',
		      type: 'input',
		      text: "${ctp:i18n('role.code')}",
		      value: 'code'
		    }]
		  });
  }


  // 工具栏
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "create1",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        newRole();
      }
    },
    {
      id: "modify",
      name: "${ctp:i18n('label.modify')}",
      className: "ico16 editor_16",
      click: function() {
        updateRole();
      }
    },
    {
      id: "delete",
      name: "${ctp:i18n('role.delete')}",
      className: "ico16 del_16",
      click: function() {
        deleteRole();
      }
    },
    {
      id: "more",
      name: "${ctp:i18n('member.advanced')}",
      className: "ico16 setting_16",
      subMenu: [{
        name: "${ctp:i18n('role.adv.copy')}",
        click: function() {
          var v = $("#mytable").formobj({
            gridFilter: function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          if (v.length < 1) {
            $.alert("${ctp:i18n('member.choose.delete')}");

          } else {
            copyrole(v);
          }
        }
      },
      {
        name: "${ctp:i18n('role.start')}",
        click: function() {
          var v = $("#mytable").formobj({
            gridFilter: function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          if (v.length < 1) {
            $.alert("${ctp:i18n('member.choose.delete')}");

          } else {
            var rManager = new roleManager();
            var roles = new Array();
            $(v).each(function(index, domEle) {
              roles.push(domEle.id);
            });
            if (isgroup && isallowaccpriv == true && nowtab != 0) {
              var confirm = $.confirm({
                'msg': "${ctp:i18n('role.groupsyc.confirm')}",
                ok_fn: function() {
                  if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
                  rManager.enableRole(roles, {
                    success: function() {
                      $.infor("${ctp:i18n('label.operation.success')}");
                      reloadtab();
                    }
                  });
                },
                cancel_fn: function() {}
              });
            } else {
              if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
              rManager.enableRole(roles, {
                success: function() {
                  $.infor("${ctp:i18n('label.operation.success')}");
                  reloadtab();
                }
              });
            }

          }
        }
      },
      {
        name: "${ctp:i18n('role.stop')}",
        click: function() {
          var v = $("#mytable").formobj({
            gridFilter: function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });

          if (v.length < 1) {
            $.alert("${ctp:i18n('member.choose.delete')}");
          } else {
            if (v[0].isBenchmark == true) {
              $.alert("${ctp:i18n('role.defult.cannot')}");
              return;
            }
            var rManager = new roleManager();
            var roles = new Array();
            $(v).each(function(index, domEle) {
              roles.push(domEle.id);
            });
            if (isgroup && isallowaccpriv == true && nowtab != 0) {
              var confirm = $.confirm({
                'msg': "${ctp:i18n('role.groupsyc.confirm')}",
                ok_fn: function() {
                  if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
                  rManager.disenableRole(roles, {
                    success: function() {
                      $.infor("${ctp:i18n('label.operation.success')}");
                      reloadtab();
                    }
                  });

                },
                cancel_fn: function() {}
              });
            } else {
              if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
              rManager.disenableRole(roles, {
                success: function() {
                  $.infor("${ctp:i18n('label.operation.success')}");
                  reloadtab();
                }
              });
            }

          }
        }
      },
      {
        name: "${ctp:i18n('role.defult.set')}",
        click: function() {
          var v = $("#mytable").formobj({
            gridFilter: function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
          if (v.length != 1) {
            $.alert("${ctp:i18n('depatition.chosce')}");
          } else {

            if (v[0].enabled == false) {
              $.error("${ctp:i18n('role.disable.defult.cannot')}");
              return;
            }
            if(v[0].bond == "0") {
                $.error("${ctp:i18n('zuzhirole.disable.defult.cannot')}");
                return;
              }
            var rManager = new roleManager();
            if (isgroup && isallowaccpriv == true && nowtab != 0) {
              var confirm = $.confirm({
                'msg': "${ctp:i18n('role.groupsyc.confirm')}",
                ok_fn: function() {
                  if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
                  rManager.defultRole(v[0].id, {
                    success: function() {
                      $.infor("${ctp:i18n('label.operation.success')}");
                      reloadtab();
                    }
                  });

                },
                cancel_fn: function() {}
              });
            } else {
              if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
              rManager.defultRole(v[0].id, {
                success: function() {
                  $.infor("${ctp:i18n('label.operation.success')}");
                  reloadtab();
                }
              });
            }

          }
        }
      }]
    },
    {
      id: "allocated",
      name: "${ctp:i18n('role.allocated.resource')}",
      className: "ico16 redistribution_16",
      click: function() {
        var boxs = $(".mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (boxs.length === 0 || boxs.length > 1) {
          $.alert("${ctp:i18n('role.choose')}");
          return;
        } else {
          var id = boxs[0].id;
          selectResource(id);
        }
      }
    },
    {
      id: "distribution",
      name: "${ctp:i18n('role.distribution.personnel')}",
      className: "ico16 redistribution_16",
      click: function() {
        var boxs = $(".mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (boxs.length === 0 || boxs.length > 1) {
          $.alert("${ctp:i18n('role.choose')}");
          return;
        } else {
          var id = boxs[0].id;
          if (boxs[0].enabled == false) {
            $.alert("${ctp:i18n('role.disable.noallc')}");
            return;
          }
          role2people(id);
        }
      }
    },
    {
      id: "view",
      name: "${ctp:i18n('role.resource.view')}",
      className: "ico16 search_16",
      click: function() {
        var boxs = $(".mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (boxs.length === 0 || boxs.length > 1) {
          $.alert("${ctp:i18n('role.choose')}");
          return;
        } else {
          var id = boxs[0].id;
          showResource(id);
        }
      }
    },
    {
      id: "viewmember",
      name: "${ctp:i18n('role.check')}",
      className: "ico16 search_16",
      click: function() {
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length != 1) {
          $.alert("${ctp:i18n('role.choose')}");

        } else {
          var dialog = $.dialog({
            id: 'viewmembersdialog',
            url: '${path}/organization/role.do?method=showMembers4RoleCon&roleid=' + v[0].id + '&bond=' +v[0].bond,
            title: "${ctp:i18n('role.check')}",
            targetWindow: getCtpTop(),
            width: 600,
            buttons: [{
              id: 'cancel',
              //disabled: true,
              //hide:true,
              text: "${ctp:i18n('label.close')}",
              handler: function() {
                //dialog.disabledBtn('ok');
                dialog.close({
                  isFormItem: true
                });
              }
            }]
          });
          //$("#viewmembersmytable").ajaxgridLoad(v[0]);
        }
      }
    }
//    ,
//    {
//      id: "pertype",
//      type: "select",
//      value: "1",
//      text: "${ctp:i18n('role.permission.allowaccount.no')}",
//      onchange: changetype,
//      items: [{
//        text: "${ctp:i18n('role.permission.allowaccount.yes')}",
//        value: '2'
//      }]
//
//    }
    ]
  });
  $("#pertype").val(isallowaccpriv);
  if (isgroup == true) {
    //toolbar.hideBtn("viewmember");
    //toolbar.hideBtn("distribution");

  } else {
    $("#pertype").hide();

  }
  if (isallow == false) {
    toolbar.hideBtn("create1");
    toolbar.hideBtn("modify");
    toolbar.hideBtn("delete");
    toolbar.hideBtn("more");
    toolbar.hideBtn("allocated");
  }
  //fb 加载时
if(!$.ctx.plugins.contains('secret')){
	toolbar.showBtn("distribution");
}else{
/* 	toolbar.hideBtn("distribution"); */
}

});
function changetype() {
  var rManager = new roleManager();
  //rManager.setGroupPrivType($("#pertype").val());
  if ($("#pertype").val() == "1") {
    isallowaccpriv = "1";
    $.infor("${ctp:i18n('role.permission.allowaccount.no.config')}");
  } else {
    $.infor("${ctp:i18n('role.permission.allowaccount.yes.config')}");
    isallowaccpriv = "2";
  }
}
function copyrole(v) {

  var dialog = $.dialog({
    id: 'copydialog',
    htmlId: 'copy123',
    height: 80,
    title: "${ctp:i18n('level.select.choose')}",
    buttons: [{
      id: 'ok',
      text: "${ctp:i18n('common.button.ok.label')}",
      handler: function() {
        var type = "";
        if ($("input[name=copyrole]:eq(0)").is(':checked')) {
          type = type + "2";
        }
        if ($("input[name=copyrole]:eq(1)").is(':checked')) {
          type = type + "1";
        }
        var rManager = new roleManager();
        if (isgroup && isallowaccpriv == true && nowtab != 0) {
          var confirm = $.confirm({
            'msg': "${ctp:i18n('role.groupsyc.confirm')}",
            ok_fn: function() {
              try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
              rManager.copyrole(v, type, {
                success: function() {
                  dialog.close({
                    isFormItem: true
                  });
                  $.infor("${ctp:i18n('organization.ok')}");
                  reloadtab();
                }
              });
            },
            cancel_fn: function() {}
          });
        } else {
          try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
          rManager.copyrole(v, type, {
            success: function() {
              dialog.close({
                isFormItem: true
              });
              $.infor("${ctp:i18n('organization.ok')}");
              reloadtab();
            }
          });
        }

      }
    },
    {
      id: 'cancel',
      //disabled: true,
      //hide:true,
      text: "${ctp:i18n('systemswitch.cancel.lable')}",
      handler: function() {
        //dialog.disabledBtn('ok');
        dialog.close({
          isFormItem: true
        });
      }
    }]
  });
}

function clk(data, r, c) {
  $("#selectResouce").attr("src", "../privilege/resource.do?method=getTree&roleId=" + data.id);
}

// 查看资源
function showResource(id) {
  var dialog = $.dialog({
    url: _ctxPath + '/privilege/resource.do?method=getTree&roleId=' + id,
    width: 300,
    height: 400,
    targetWindow: getCtpTop(),
    title: "${ctp:i18n('label.check')}",
    buttons: [{
      text: "${ctp:i18n('label.close')}",
      handler: function() {
        dialog.close();
      }
    }]
  });
}

// 分配资源
function selectResource(id) {
  var dialog = $.dialog({
    id: 'treedialog',
    url: _ctxPath + '/privilege/resource.do?method=getTree&cmd=selectAll&showAll=1&roleId=' + id + '&appResCategory=1&isAllocated=true',
    width: 300,
    height: 400,
    targetWindow: getCtpTop(),
    isDrag:false,
    title: "${ctp:i18n('role.allocated.resource')}",

    buttons: [{
    	id:"submit",
        text: "${ctp:i18n('common.button.ok.label')}",
        handler: function() {
        	dialog.getReturnValue();
        }
      },
      {
      	id:"close",
      text: "${ctp:i18n('label.close')}",
      handler: function() {
        dialog.close();
      }
    }]
  });
  /* $("#selectResouce").attr(
        "src",
        '../privilege/resource.do?method=getTree&cmd=selectAll&showAll=1&roleId='
            + id+'&appResCategory=1&isAllocated=true'); */
}

function role2people(id) {

  var dialog = $.dialog({
    id: 'role2people',
    url: _ctxPath + '/organization/role.do?method=showEntity4Role&roleId=' + id,
    width: 500,
    targetWindow: getCtpTop(),
    height: 180,
    title: "${ctp:i18n('role.authorization')}",
    buttons: [{
      text: "${ctp:i18n('label.save')}",
      id: 'role2people_ok',
      handler: function() {
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        var members = dialog.getReturnValue();
        var rManager = new roleManager();
        dialog.close();
        rManager.batchRole2Entity(id, members, {
          success: function() {
            $.infor("${ctp:i18n('label.operation.success')}");
            try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
          }
        });

      }
    },
    {
      text: "${ctp:i18n('label.close')}",
      id: 'role2people_canel',
      handler: function() {
        dialog.close();
      }
    },{
      text: "${ctp:i18n('common.button.ok.label')}",
      id: 'role2people_colse',
      handler: function() {
        dialog.close();
      }
    }]
  });
  var role = oManager.getRoleById(id);
  if (role.bond == "2") {
    dialog.hideBtn("role2people_ok");
    dialog.hideBtn("role2people_canel");
  }else{
  	dialog.hideBtn("role2people_colse");
  }
}

function loadTable1(condition, value) {

  var o1 = new Object();
  o1.bond = 1;
  if (condition) {
    if (condition == "name") {
      o1.name = value;
    } else if (condition == "type") {
      o1.type = value;
    } else if (condition == "enabled") {
      o1.enabled = value;
    } else if (condition == "code") {
      o1.code = value;
    }
  }
  //eval("o1." + condition + " = '" + value + "';");
  $("#mytable").ajaxgridLoad(o1);

}
function loadTable2(condition, value) {
  var o2 = new Object();
  o2.bond = 2;
  if (condition) {
    if (condition == "name") {
      o2.name = value;
    } else if (condition == "type") {
      o2.type = value;
    } else if (condition == "enabled") {
      o2.enabled = value;
    } else if (condition == "code") {
      o2.code = value;
    }
  }
  $("#mytable").ajaxgridLoad(o2);
}
function loadTable0(condition, value) {
  var o0 = new Object();
  o0.bond = 0;
  if (condition) {
    if (condition == "name") {
      o0.name = value;
    } else if (condition == "type") {
      o0.type = value;
    } else if (condition == "enabled") {
      o0.enabled = value;
    } else if (condition == "code") {
      o0.code = value;
    }
  }
  $("#mytable").ajaxgridLoad(o0);
}

//新建角色
function newRole() {
  if (typeof opendialog != "undefined") {
    opendialog.getDialog();
    opendialog.autoMinfn();
    return;
  }
  var dialog = $.dialog({
    url: _ctxPath + '/organization/role.do?method=createRole',
    width: 400,
    height: 340,
    isDrag:false,
    title: "${ctp:i18n('role.add.custom')}",
    targetWindow: getCtpTop(),
    closeParam:{
      //取消遮罩
        'show':true,
        handler:function(){
            try{
                if(getCtpTop() && getCtpTop().endProc)getCtpTop().endProc();
              }catch(e){}
              dialog.close();
        }
      },
    buttons: [{
      id: "btnok",
      text: "${ctp:i18n('common.button.ok.label')}",
      isEmphasize:true,
      handler: function() {
    	if(getCtpTop().roleflag){
    		return;
    	}else{
    		getCtpTop().roleflag = true;
    	}
        try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};

        dialog.disabledBtn('btnok'); //确定按钮置灰失效
        var callerResponder = new CallerResponder();
        callerResponder.success = function(jsonObj) {
          // 手动加载表格数据
          reloadtab();
          dialog.close();
        };
        var _error = callerResponder.error;
        callerResponder.error = function(request, settings, e) {
        	_error(request, settings, e);
        	dialog.enabledBtn('btnok'); //将按钮启用生效
          };
        callerResponder.sendHandler = function(b, d, c) {
          if (confirm("${ctp:i18n('label.submit.or.not')}")) {
            b.send(d, c);
          }
        };
        var role = dialog.getReturnValue();
        if (role.valid) {
        	getCtpTop().roleflag = null;
        	dialog.enabledBtn('btnok'); //将按钮启用生效
          	return;
        }

        var rManager = new roleManager();
        var roleNew = new Object();
        roleNew.name = role.name;
        roleNew.orgAccountId = role.accountId;
        roleNew.code = role.code;
        roleNew.sortId = role.sortId;
        roleNew.enabled = role.enable == 1 ? true: false;
        roleNew.category = role.category;
        roleNew.type = role.type;
        roleNew.description = role.description;
        roleNew.bond = role.bond;
        roleNew.status = role.status;

        rManager.createRole(roleNew, callerResponder);
        getCtpTop().roleflag = null;
      }
    },
    {
      id:"btncancel",
      text: "${ctp:i18n('systemswitch.cancel.lable')}",
      handler: function() {
      //取消遮罩
        try{
          if(getCtpTop() && getCtpTop().endProc)getCtpTop().endProc();
        }catch(e){}
        dialog.close();
      }
    }]
  });
  opendialog = dialog;

}

function updateRole() {

  var boxs = $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
  if (boxs.length === 0) {
    $.alert("${ctp:i18n('role.choose.edit')}");
    return;
  } else if (boxs.length > 1) {
    $.alert("${ctp:i18n('role.only.one.edit')}");
    return;
  }
  //if (boxs[0].type != 3) {
  //  $.alert(boxs[0].showName + "${ctp:i18n('role.system.preset')}");
  //  return;
  //}
  var id = boxs[0].id;
  var dialog = $.dialog({
    url: _ctxPath + '/organization/role.do?method=edit&id=' + id,
    width: 400,
    height: 340,
    isDrag: false,
    targetWindow: getCtpTop(),
    title: "${ctp:i18n('label.edit')}",
    buttons: [{
      id:"btnok",
      text: "${ctp:i18n('common.button.ok.label')}",
      handler: function() {
        var callerResponder = new CallerResponder();
        callerResponder.success = function(jsonObj) {
          dialog.close();
          // 手动加载表格数据
          reloadtab();
        };
        callerResponder.sendHandler = function(b, d, c) {
          if (confirm("${ctp:i18n('label.submit.or.not')}")) {
            b.send(d, c);
          }
        };
        var role = dialog.getReturnValue();
        if (role.valid) {
          return;
        }
        var rManager = new roleManager();
        var roleNew = new Object();
        roleNew.id = role.id;
        roleNew.name = role.name;
        roleNew.orgAccountId = role.accountId;
        roleNew.code = role.code;
        roleNew.sortId = role.sortId;
        roleNew.enabled = role.enable == 1 ? true: false;
        roleNew.category = role.category;
        roleNew.type = role.type;
        roleNew.description = role.description;
        roleNew.isBenchmark = role.isBenchmark;
        roleNew.bond = role.bond;
        roleNew.status = role.status;
        //alert(isallowaccpriv);
        if (isgroup && isallowaccpriv == true && nowtab != 0) {
          var confirm = $.confirm({
            'msg': "${ctp:i18n('role.groupsyc.confirm')}",
            ok_fn: function() {
              try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
              rManager.updateRole(roleNew, callerResponder);
            },
            cancel_fn: function() {}
          });
        } else {
          try{if(getCtpTop() && getCtpTop().startProc){getCtpTop().startProc()}}catch(e){};
          rManager.updateRole(roleNew, callerResponder);
        }

      }
    },
    {
      id:"btncancel",
      text: "${ctp:i18n('systemswitch.cancel.lable')}",
      handler: function() {
        dialog.close();
      }
    }]
  });
}
function reloadtab() {
  try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
  if (nowtab == 1) {
    loadTable1();
  } else if (nowtab == 2) {
    loadTable2();
  } else if (nowtab == 0) {
    loadTable0();
  }
}
function getTableChecked() {
  return $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
}
function deleteRole() {
  var roles = new Array();
  var tesBS = new roleManager();
  var v = getTableChecked();
  if (v.length === 0) {
    $.alert("${ctp:i18n('role.choose.delete')}");
    return;
  } else {
    var checkResult = true;
    $(v).each(function(index, domEle) {
      if (domEle.type === 3 && domEle.isBenchmark === false) {
        roles.push(domEle.id);
      } else {
        $.alert(domEle.showName + "${ctp:i18n('role.system.preset.not.delete')}");

        checkResult = false;
      }
    });
    if (!checkResult) return;
    $.confirm({
      'msg': "${ctp:i18n('role.choose.sure.delete')}",
      ok_fn: function() {
        if (isgroup && isallowaccpriv == true && nowtab != 0) {
          var confirm = $.confirm({
            'msg': "${ctp:i18n('role.groupsyc.confirm')}",
            ok_fn: function() {
              tesBS.deleteRole(roles, {
                success: function() {
                  reloadtab();
                }
              });
            },
            cancel_fn: function() {}
          });
        } else {
          tesBS.deleteRole(roles, {
            success: function() {
              reloadtab();
            }
          });
        }

      }
    });
  }
}
function getCount() {
  cnt = mytable.p.total;
  $("#count").get(0).innerHTML = msg.format(cnt);
}
</script>