<%--
 $Author:  jiahl$
 $Rev:  $
 $Date:: 2014-01-21#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=restUserManager"></script>
<script type="text/javascript">
var restUserManager = new restUserManager();
var msg = '${ctp:i18n("info.totally")}';
$().ready(function() {
  var mytable = $("#mytable").ajaxgrid({
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
      display: "${ctp:i18n('usersystem.restUser.userName')}",
      name: 'userName',
      sortable: true,
      width: '15%'
    },
   
    {
      display: "${ctp:i18n('usersystem.restUser.loginName')}",
      name: 'loginName',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('usersystem.restUser.enable')}",
      name: 'enabled',
      sortable: true,
      width: '10%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.usersystem.enums.RestUserEnableEnum'"
    },
    {
        display: "${ctp:i18n('usersystem.restUser.loginIp')}",
        name: 'loginIp',
        sortable: true,
        width: '25%'
      },
    {
      display: "${ctp:i18n('usersystem.restUser.createTime')}",
      name: 'createTime',
      sortable: true,
      width: '15%'
    },
      {
          display: "${ctp:i18n('usersystem.restUser.updateTime')}",
          name: 'updateTime',
          sortable: true,
          width: '15%'
        }
      ],
    width: 'auto',
    parentId: "roleList_stadic_body_top_bottom",
    //height:$("#layoutCenter").height()-65,
    managerName: "restUserManager",
    managerMethod: "findUser",
    vChangeParam: {
      overflow: "auto"
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    vChange: true,
    callBackTotle: getCount

  });
   reloadtab();
  var searchobj;
  var ver = "${ctp:getSystemProperty('org.isGroupVer')}";
    //搜素栏查询
    searchobj = $.searchCondition({
        top: 2,
        right: 10,
        searchHandler: function() {
            var result = searchobj.g.getReturnValue();
            if (result) {
              loadTable1(result.condition, result.value);
            }
        },
        conditions: [{
          id: 'userName',
          name: 'userName',
          type: 'input',
          text: "${ctp:i18n('usersystem.restUser.userName')}",
          value: 'userName'
        },
        {
          id: 'loginName',
          name: 'loginName',
          type: 'input',
          text: "${ctp:i18n('usersystem.restUser.loginName')}",
          value: 'loginName'
        },
        {
          id: 'enabled',
          name: 'enabled',
          type: 'select',
          text: "${ctp:i18n('usersystem.restUser.enable')}",
          value: 'enabled',
          items: [{
            text: "${ctp:i18n('usersystem.restUser.trueflag')}",
            value: '1'
          },
          {
            text: "${ctp:i18n('usersystem.restUser.falseflag')}",
            value: '0'
          }]
        }]
      });
  // 工具栏
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "create1",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        newUser();
      }
    },
    {
      id: "modify",
      name: "${ctp:i18n('label.modify')}",
      className: "ico16 editor_16",
      click: function() {
       updateUser();
      }
    }
    /*,
    {
      id: "delete",
      name: "${ctp:i18n('usersystem.restUser.deleteUser')}",
      className: "ico16 del_16",
      click: function() {
        deleteUser();
      }
    } */, 
    {
        id: "checkresource",
        name: "${ctp:i18n('usersystem.restUser.checkResource')}",
        className: "ico16 search_16",
        click: function() {
          showRescource();
        }
      },
      {
        id: "authorize",
        name: "${ctp:i18n('usersystem.restUser.authorize')}",
        className: "ico16 authorize_16",
        click: function() {
          authorize();
        }
      },
      {
          id: "restlog",
          name: "${ctp:i18n('restlog.title.info')}",
          className: "ico16 view_log_16",
          click: function() {
        	  restlogs();
          }
        }
    ]
  });
  
  //新建用户
  function newUser(){
   if (typeof opendialog != "undefined") {
      opendialog.getDialog();
      opendialog.autoMinfn();
      return;
  }
  var dialog = $.dialog({
    url: _ctxPath + '/usersystem/restUser.do?method=createUser',
    width: 400,
    height: 340,
    isDrag:false,
    title: "${ctp:i18n('usersystem.restUser.newUserTitle')}",
    targetWindow: getCtpTop(),
    buttons: [{
      id: "btnok",
      text: "${ctp:i18n('common.button.ok.label')}",
      handler: function() {
    	  
    	  var user = dialog.getReturnValue();
          if (user==undefined||user.valid) {
            return;
          }
          if (user.passWord != user.passWord2) {
              $.alert("${ctp:i18n('usersystem.newpassword.again.not.consistent')}");
              return;
          }
          var userManager = new restUserManager();
          var userNew = new Object();
          userNew.userName = user.userName;
          userNew.loginName = user.loginName;
          userNew.passWord = user.passWord;
          userNew.type = user.type;
          userNew.loginIp = user.loginIp;
          userNew.enabled = user.enable;
          userNew.userOrder = user.userOrder;
          userNew.validationip = user.validationip;
          userManager.createUser(userNew, {
        	  success:function(result){
        	      if(result != 0){
            		  // 手动加载表格数据
                      reloadtab();
                      dialog.close();
        	      }else{
        	          $.alert("${ctp:i18n('usersystem.restUser.loginName.repeat')}");
        	      }
        	  }
          });
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
  opendialog = dialog; 
}

  //修改用户
function updateUser() {
  var boxs = $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
  if (boxs.length === 0) {
    $.alert("${ctp:i18n('usersystem.restUser.choose.edit')}");
    return;
  } else if (boxs.length > 1) {
    $.alert("${ctp:i18n('usersystem.restUser.only.one.edit')}");
    return;
  }
  var id = boxs[0].id;  
  var dialog = $.dialog({
    url: _ctxPath + '/usersystem/restUser.do?method=edit&id=' + id,
    width: 400,
    height: 340,
    isDrag: true,
    targetWindow: getCtpTop(),
    title: "${ctp:i18n('label.edit')}",
  buttons: [{
      id:"btnok",
      text: "${ctp:i18n('common.button.ok.label')}",
      handler:  function() {
       
        var user = dialog.getReturnValue();
          if (user==undefined||user.valid) {
            return;
          }
          if (user.passWord != user.passWord2) {
              $.alert("${ctp:i18n('usersystem.newpassword.again.not.consistent')}");
              return;
          }
          var userManager = new restUserManager();
          var userNew = new Object();
          userNew.id = user.id;
          userNew.userName = user.userName;
          userNew.loginName = user.loginName;
          userNew.passWord = user.passWord;
          userNew.type = user.type;
          userNew.loginIp = user.loginIp;
          userNew.enabled = user.enable;
          userNew.userOrder = user.userOrder;
          userNew.createTime = user.createTime;
          userNew.resourceAuthority = user.resourceAuthority;
          userNew.validationip = user.validationip;
          userManager.updateUser(userNew, {
            success:function(result){
                if(result != 0){
                    // 手动加载表格数据
                    reloadtab();
                    dialog.close();
                }else{
                    $.alert("${ctp:i18n('usersystem.restUser.loginName.repeat')}");
                }
            }
          });
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
//rest 日志
function restlogs(){

	  var dialog = $.dialog({
	    url: _ctxPath + '/restlog.do?method=restLogList',
	    width: 1000,
	    height: 800,
	    isDrag: true,
	    targetWindow: getCtpTop(),
	    title: "${ctp:i18n('restlog.title.info')}",
	  buttons: [
	    {
	      id:"btncancel",
	      text: "${ctp:i18n('systemswitch.cancel.lable')}",
	      handler: function() {
	        dialog.close();
	      }
	    }]
	    
	  });
}

//授权
function authorize() {
  var boxs = $(".mytable").formobj({
     gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
  if (boxs.length === 0) {
    $.alert("${ctp:i18n('usersystem.restUser.choose.authorize')}");
    return;
  } else if (boxs.length > 1) {
    $.alert("${ctp:i18n('usersystem.restUser.only.one.authorize')}");
    return;
  }
  var id = boxs[0].id;  
  var dialog = $.dialog({
    url: _ctxPath + '/usersystem/restUser.do?method=authorizeUser&id=' + id + '&callType=0',
    width: 400,
    height: 340,
    isDrag: true,
    targetWindow: getCtpTop(),
    title: "${ctp:i18n('usersystem.restUser.authorize')}",
  buttons: [{
      id:"btnok",
      text: "${ctp:i18n('common.button.ok.label')}",
      handler:  function() {
       
        var user = dialog.getReturnValue();
          if (user==undefined||user.valid) {
            return;
          }
          var userManager = new restUserManager();
          var resourceId = user.resourceId;
          var userId =user.id;
          userManager.updateResource(resourceId,userId, {
            success:function(){
              // 手动加载表格数据
                  reloadtab();
                  dialog.close();
            }
          });
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

//查看资源
function showRescource() {
  var boxs = $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
  if (boxs.length === 0) {
    $.alert("${ctp:i18n('usersystem.restUser.choose.checkResource')}");
    return;
  } else if (boxs.length > 1) {
    $.alert("${ctp:i18n('usersystem.restUser.only.one.checkResource')}");
    return;
  }
  var id = boxs[0].id;  
  var dialog = $.dialog({
    url: _ctxPath + '/usersystem/restUser.do?method=authorizeUser&id=' + id + '&callType=1',
    width: 400,
    height: 340,
    isDrag: true,
    targetWindow: getCtpTop(),
    title: "${ctp:i18n('usersystem.restUser.checkResource')}",
  buttons: [
    {
      id:"btncancel",
      text: "${ctp:i18n('systemswitch.cancel.lable')}",
      handler: function() {
        dialog.close();
      }
    }]
    
  });
}

//获取选中
function getTableChecked() {
  return $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
}

//删除用户
function deleteUser() {
  var users = new Array();
  var userManager = new restUserManager();
  var v = getTableChecked();
  if (v.length === 0) {
    $.alert("${ctp:i18n('usersystem.restUser.choose.delete')}");
    return;
  } else {
    var checkResult = true;
    $(v).each(function(index, domEle) {
        users.push(domEle.id);
    });
    if (!checkResult) return;
      $.confirm({
            'msg': "${ctp:i18n('usersystem.restUser.delete.info')}",
            ok_fn: function() {
              userManager.deleteUser(users, {
                success: function() {
                  reloadtab();
                }
              });
            },
            cancel_fn: function() {}
          });
    }
  }
  
  //获取总条目数
  function getCount(){
		 cnt = mytable.p.total;
     $("#count").get(0).innerHTML = msg.format(cnt);
  }
  
  //加载用户列表
  function reloadtab(){
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
  }
  
//按条件加载用户列表
  function loadTable1(condition, value) {
    var o = new Object();
    if(condition){
      if (condition == "userName") {
          o.userName = value;
      } else if (condition == "loginName") {
          o.loginName = value;
       } else if (condition == "enabled") {
          o.enabled = value;
      }
    }
    $("#mytable").ajaxgridLoad(o);
  }
});

</script>