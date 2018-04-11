<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript" language="javascript">
$().ready(function() {
  var cnt;
  var s;
  var msg = '${ctp:i18n("info.totally")}';
  var mManager = new memberManager();
  var oManager = new orgManager();
  var oManagerDirect = new orgManagerDirect();
  var imanager = new iOManager();
  var rManager = new roleManager();
  var disableModifyLdapPsw = "${disableModifyLdapPsw}";//ctpConfig配置是否OA可以修改ldap密码
  var loginAccountId = "${accountId}";
  var eManager = new enumManagerNew();
  var enumId = eManager.getEnumIdByProCode('work_local');
  var eDeep = eManager.getDeep(enumId);
  $("tr[class='forInter']").hide();
  $("tr[class='forOuter']").show();
  $("#button_area").hide();
  $("#form_area").hide();
  //列表
  var grid = $("#memberTable").ajaxgrid({
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('org.member_form.name.label')}",
      name: 'name',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.member_form.loginName.label')}",
      name: 'loginName',
      sortable: true,
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.member_form.code')}",
      name: 'code',
      sortable: true,
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.account_form.sortId.label')}",
      name: 'sortId',
      sortable: true,
      sortType:'number',
      width: '8%'
    },
    {
      display: "${ctp:i18n('org.external.member.form.dept')}",
      name: 'departmentName',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.external.member.form.work.scope')}",
      name: 'workscopeName',
      sortable: true,
      width: '25%'
    }],
    managerName: "memberManager",
    managerMethod: "showExtMember",
    parentId: 'center',
    vChange: true,
    vChangeParam: {
        overflow: "hidden",
        position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    render: rend,
    click: clickGrid,
    dblclick: dblclkGrid,
    callBackTotle:getCount
  });
  function rend(txt, data, r, c) {
    if(c == 2) {
      if(null==data.ldapLoginName || ""==data.ldapLoginName) {
        return txt;
      } else {
        var loginTemp = "${ctp:i18n('ldap.user.prompt.new')}";
        return txt + "<img src=<c:url value='/common/images/ldapbinding.gif' /> title='"+ loginTemp + data.ldapLoginName +"'/>";
      }
    } else return txt;
  }
  //第一次加载表格，只加载启用的人员
  var o = new Object();
  o.enabled = true;
  o.accountId = loginAccountId;
  $("#memberTable").ajaxgridLoad(o);

  //页面按钮
  $("#toolbar").toolbar({
    borderTop:false,
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: newExtMember
    },
    {
      id: "edit",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: editExtMember
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 delete del_16",
      click: delExtMembers
    },
    {
      id: "export",
      name: "${ctp:i18n('export.excel')}",
      className: "ico16 export_excel_16",
      click: exportExtMembers
    },
    {
      id: "toInter",
      name: "${ctp:i18n('turn.member.query.interior')}",
      className: "ico16 switch_internal_staff_16",
      click: toInter
    },
    {
      id: "showMemberAllRoles",
      name: "${ctp:i18n('org.member_form.showMemberAllrole')}",
      className: "ico16 roster_16",
      click: showMemberAllRoles
    }]
  });

  /**
  * 查看该人员的所有角色
  */
  function showMemberAllRoles() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.view.no')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.view.more')}");
      return;
    } else {
      dialog4Role = null;
      dialog4Role = $.dialog({
        url: "<c:url value='/organization/member.do' />?method=showMemberAllRoles&memberId="+boxs[0].value,
        title: "${ctp:i18n('org.member_form.roleList')}",
        width: 400,
        height: 300,
        buttons: [{
          id: "roleConcel",
          text: "${ctp:i18n('label.close')}",
          handler: function() {
            dialog4Role.close();
          }
        }]
      });
    }
  }

  var isNewMember = false;
  var tempVal = '';//为选人界面回写增加一个临时变量，要在新建是清空这个值
  var toInter = false;
  function newExtMember() {
    grid.grid.resizeGridUpDown('middle');
    $("#memberForm").clearform();
    $("tr[class='forInter']").hide();
    $("tr[class='forOuter']").show();
    $("#extWorkScopeValue").val("");
    $("#roles").val("");
    $("#roleIds").val("");
    $("#id").val("-1");
    $("#orgAccountId").val(loginAccountId);//新建人员时追加当前登录单位id，以备判断人员角色
    $("#form_area").show();
    $("#welcome").hide();
    $("#memberForm").enable();
    $("#button_area").show();
    $("#lconti").show();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
    $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
    $("#sortIdtype1").attr("checked", "checked");
    $("#primaryLanguange").val("zh_CN");
    var preSortId = oManagerDirect.getExtMemberMaxSortNum(loginAccountId);
    $("#sortId").val(parseInt(preSortId) + 1);
    isNewMember = true;
    $("#state").disable();
    tempVal = '';
    var role = oManager.getRoleByName('ExternalStaff',loginAccountId);
    if(null != role) {
      $("#extRoles").val(role.showName);
      $("#extRoleIds").val(role.id);
    }
    var initpwd = oManager.getInitPWDForPage();
    if(null!=initpwd && initpwd!="" && initpwd!=false){
    	initpwd = initpwd.substring(8);
    }else{
    	initpwd = "";
    }
    $("#password").val(initpwd);
    $("#password2").val(initpwd);
    //ldap/ad
    if('true' == "${isLdapEnabled}" && 'false' == "${LdapCanOauserLogon}") {
      $("input[type='radio'][name='ldapSetType'][value='select']").attr("checked", "checked");
      $("#ldapSet_tr0").show();
      $("#ldapSet_tr1").show();
      $("#ldapSet_tr2").hide();
      //ctpConfig配置禁用OA修改ldap密码则置灰
      if('true' == disableModifyLdapPsw || true == disableModifyLdapPsw) {
        $("#password").disable();
        $("#password2").disable();
      }
    }
  }
  
  //绑定ldap新建radio的选项
  $("input[type='radio'][name='ldapSetType']").click(function() {
    if($("input[type='radio'][name='ldapSetType'][value='new']").attr("checked") == "checked") {
      $("#ldapSet_tr0").show();
      $("#ldapSet_tr1").hide();
      $("#ldapSet_tr2").show();
    }
    if($("input[type='radio'][name='ldapSetType'][value='select']").attr("checked") == "checked") {
      $("#ldapSet_tr0").show();
      $("#ldapSet_tr1").show();
      $("#ldapSet_tr2").hide();
    }
  });

  function editExtMember() {
    toInter = false;
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
      return;
    } else {
        grid.grid.resizeGridUpDown('middle');
        $("#form_area").clearform();
        $("tr[class='forInter']").hide();
        $("tr[class='forOuter']").show();
        var mDetail = mManager.viewOne(boxs[0].value);
        $("#password").val("~`@%^*#?");
        $("#password2").val("~`@%^*#?");
        $("#sortIdtype1").attr("checked", "checked");
        $("#memberForm").enable();
        $("#memberForm").fillform(mDetail);
        $("#loginName").attr("readonly","readonly");
        $("#isChangePWD").val("false");
        fillSelectPeople(mDetail);
        $("#button_area").show();
        $("#form_area").show();
        isNewMember = false;
        $("#state").disable();
        $("#lconti").hide();
        $("#welcome").hide();
        ldapSet4Edit("edit",mDetail.ldapUserCodes);
        $("#isLoginNameModifyed").val(false);
        $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
    }
  }

  function delExtMembers() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel')}");
      return;
    } else {
      var confirm = $.confirm({
        'title': "${ctp:i18n('common.prompt')}",
        'msg': "${ctp:i18n('org.member_form.choose.member.delete')}",
        ok_fn: function() {
          var boxs = $("#memberTable input:checked");
          if (boxs.length === 0) {
            $.alert("${ctp:i18n('org.member_form.choose.personnel')}");
            return;
          } else if (boxs.length >= 1) {
            var members = new Array();
            boxs.each(function() {
              members.push($(this).val());
            });
            mManager.deleteMembers(members, {
              success: function() {
                $.messageBox({
                  'title': "${ctp:i18n('common.prompt')}",
                  'type': 0,
                  'imgType':0,
                  'msg': "${ctp:i18n('organization.ok')}",
                  ok_fn: function() {
                    location.reload();
                  }
                });
              }
            });
          }
        },
        cancel_fn: function() {}
      });
    }
  }
  //导出外部人员excel
  function exportExtMembers() {
    $.alert({
      'title': "${ctp:i18n('common.prompt')}",
      'msg': "${ctp:i18n('member.export.prompt.wait')}",
      ok_fn: function() {
        imanager.canIO({
          success: function(rel) {
            if ('ok' == rel) {
              var downloadUrl_e = "${path}/organization/member.do?method=exportExtMembers&accountId=${accountId}&condition="+encodeURI($.toJSON(s));
              var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
              exportIFrame.location.href = eurl_e;
            }
          }
        });
      }
    });
  }
  
  //转内部人员
  function toInter() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
      return;
    } else {
        var mDetail = new Object();
        grid.grid.resizeGridUpDown('middle');
        $("#form_area").clearform();
        mDetail = mManager.viewOne(boxs[0].value);
        $("tr[class='forInter']").show();
        $("tr[class='forOuter']").hide();
        $("#sortIdtype1").attr("checked", "checked");
        $("#memberForm").enable();
        $("#memberForm").fillform(mDetail);
        $("#loginName").attr("readonly","readonly");
        $("#isChangePWD").val("false");
        fillSelectPeople(mDetail);
        $("#button_area").show();
        $("#form_area").show();
        isNewMember = false;
        $("#state").disable();
        $("#lconti").hide();
        $("#welcome").hide();
        toInter = true;
        ldapSet4Edit("edit",mDetail.ldapUserCodes);
        $("#isLoginNameModifyed").val(false);
        //外部人员一个普通角色
        var role = rManager.getDefultRoleByAccount(loginAccountId);
        if(null != role) {
          $("#roles").val(role.showName);
          $("#roleIds").val(role.id);
        }
        $("#conPostsTr").hide();
        $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
    }
  }

  // 表单JSON无分区无分组提交事件
  $("#btnok").click(function() {
    //人员无角色的校验2013-8-1由于需求变更修改代码
    if($("#extRoleIds").val() == "") {
      var entityIds = "";
      
      entityIds = entityIds + $("#orgAccountId").val() + ",";
      entityIds = entityIds + $("#orgDepartmentId").val() + ",";
      var mManager2 = new memberManager();
      var cMemberNoRoles = mManager2.checkNoRoles(entityIds);
      if(cMemberNoRoles) {
        $.alert("${ctp:i18n('member.role.checkroles')}");
        var role = oManager.getRoleByName('ExternalStaff',loginAccountId);
        if(null != role) {
          $("#extRoles").val(role.showName);
          $("#extRoleIds").val(role.id);
        }
        return;
      }
    }
    if ($("#password").val() !== $("#password2").val()) {
      $.alert("${ctp:i18n('account.system.newpassword.again.not.consistent')}");
      $("#password").val("");
      $("#password2").val("");
      $("#password").focus();
      return;
    }
    if(!($("#memberForm").validate())){
        return;
    }
    if('true' == "${isLdapEnabled}" && 'false' == "${LdapCanOauserLogon}") {
      if($("input[type='radio'][name='ldapSetType'][value='select']").attr("checked") == "checked") {
        if($("#ldapUserCodes").val() == '') {
          $.alert("${ctp:i18n('org.alert.ldapUserCodeNotNull')}");
          return;
        }
      }
      if(isNewMember == false) {
        if($("#ldapUserCodes").val() == '') {
          $.alert("${ctp:i18n('org.alert.ldapUserCodeNotNull')}");
          return;
        }
      }
    }
    $("#memberForm").resetValidate();
    if ($("#id").val() === '-1') {
      try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){};
      mManager.createExtMember(loginAccountId, $("#memberForm").formobj(), {
        success: function(memberBean) {
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
          if ($("#conti").attr("checked") === "checked") {
            clear4addconti();
          } else {
            $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'imgType':0,
              'msg': "${ctp:i18n('organization.ok')}",
              ok_fn: function() {
                location.reload();
              }
            });
          }
        }
        
      });
    } else {
      if(toInter) {
        $("#isInternal").val("true");
      }
      try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();}catch(e){};
      mManager.updateMember($("#memberForm").formobj(), {
        success: function(memberBean) {
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              location.reload();
            }
          });
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
      
    }
  });

  $("#btncancel").click(function() {
    location.reload();
  });

  //连续添加人员，保留部门排序号岗位职务
  function clear4addconti() {
    //连续添加被选中时，按钮显示正常
    $("#button_area").enable();
    $("#id").val("-1");
    $("#name").val("");
    $("#loginName").val("");
    var initpwd = oManager.getInitPWDForPage();
    if(null!=initpwd && initpwd!="" && initpwd!=false){
    	initpwd = initpwd.substring(8);
    }else{
    	initpwd = "";
    }
    $("#password").val(initpwd);
    $("#password2").val(initpwd);
    $("#birthday").val("");
    $("#officenumber").val("");
    $("#telnumber").val("");
    $("#emailaddress").val("");
    $("#description").val("");
    $("#ldapUserCodes").val("");
    $("#sortId").val(parseInt($("#sortId").val()) + 1);
    var o = new Object();
    o.enabled = true;
    o.accountId = loginAccountId;
    $("#memberTable").ajaxgridLoad(o);
    $("#isLoginNameModifyed").val(false);
    $("#memberForm").resetValidate();
  }

  //查看人员信息
  function viewDetail(id) {
    $("#form_area").clearform();
    $("tr[class='forInter']").hide();
    $("tr[class='forOuter']").show();
    var mDetail = mManager.viewOne(id);
    $("#sortIdtype1").attr("checked", "checked");
    $("#welcome").hide();
    $("#form_area").show();
    $("#memberForm").fillform(mDetail);
    $("#loginName").attr("readonly","readonly");
    $("#form_area").resetValidate();
    $("#isChangePWD").val("false");
    fillSelectPeople(mDetail);
    $("#button_area").hide();
    ldapSet4Edit("view",mDetail.ldapUserCodes);
    $("#memberForm").disable();
    $("#isLoginNameModifyed").val(false);
    $('#sssssssss').height($('#grid_detail').height()).css('overflow', 'auto');
  }

  function clickGrid(data, r, c) {
    viewDetail(data.id);
    $("#sortIdtype1").attr("checked", "checked");
  }

  function dblclkGrid(data, r, c) {
    $("#form_area").clearform();
    var mDetail = new Object();
    mDetail = mManager.viewOne(data.id);
    $("#password").val("~`@%^*#?");
    $("#password2").val("~`@%^*#?");
    $("#sortIdtype1").attr("checked", "checked");
    $("#memberForm").enable();
    $("#memberForm").fillform(mDetail);
    $("#sortIdtype1").attr("checked", "checked");
    $("#loginName").attr("readonly","readonly");
    $("#isChangePWD").val("false");
    fillSelectPeople(mDetail);
    $("#button_area").show();
    $("#form_area").show();
    isNewMember = false;
    $("#lconti").hide();
    ldapSet4Edit("edit",mDetail.ldapUserCodes);
    $("#state").disable();
    $("#isLoginNameModifyed").val(false);
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

  //选人界面的回写方法
  function fillSelectPeople(memberData) {
    if (null != memberData["orgDepartmentId"]) {
      //部门
      var deptInfo = oManager.getDepartmentById(memberData["orgDepartmentId"]);
      if (null != deptInfo) {
        $("#extAccountName").val(deptInfo.name);
        $("#orgDepartmentId").val(memberData["orgDepartmentId"]);
      }
      tempVal = memberData["extWorkScopeValue"]
    }
  }

  //绑定选人界面区域
  //外单位
  $("#extAccountName").click(function() {
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Outworker',
      selectType: 'Department',
      minSize: 1,
      maxSize: 1,
      onlyLoginAccount: true,
      accountId:'${accountId}',
      showAllOuterDepartment: true,
      returnValueNeedType: false,
      callback: function(ret) {
        $("#extAccountName").val(ret.text);
        $("#orgDepartmentId").val(ret.value);
        var workScope = oManager.getParentUnitById(ret.value);
        if(null != workScope && undefined != workScope) {
          $("#extWorkScope").val(workScope.name);
          //自动填充工作范围
          if(workScope.type == 'Department') {
            $("#extWorkScopeValue").val("Department|"+workScope.id);
          } else {
            $("#extWorkScopeValue").val("Account|"+workScope.id);
          }
        }
      }
    });
  });
  //外单位人员工作范围
  $("#extWorkScope").click(function() {
    $("#memberForm").resetValidate();
    tempVal = $("#extWorkScopeValue").val();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department,Team',
      selectType: 'Account,Department,Member',
      minSize: 1,
      params: {value:tempVal},
      onlyLoginAccount: true,
      accountId:'${accountId}',
      hiddenSaveAsTeam: true,
      callback: function(ret) {
        $("#extWorkScope").val(ret.text);
        $("#extWorkScopeValue").val(ret.value);
      }
    });
  });
  //角色
  $("#extRoles").click(function() {
    $("#memberForm").resetValidate();
    var tRoles = $("#extRoleIds").val();
    dialog4Role = $.dialog({
      url: "<c:url value='/organization/member.do' />?method=member2Role4Ext&accountId=" + loginAccountId,
      title: "${ctp:i18n('member.authorize.role')}",
      width: 400,
      height: 300,
      isClear:false,
      transParams: tRoles,
      buttons: [{
        id: "roleOK",
        text: "${ctp:i18n('guestbook.leaveword.ok')}",
        handler: function() {
          var roleIds = dialog4Role.getReturnValue();
          if(roleIds == "") {
            var entityIds = "";
            
            entityIds = entityIds + $("#orgAccountId").val() + ",";
            entityIds = entityIds + $("#orgDepartmentId").val() + ",";
            var mManager2 = new memberManager();
            var cMemberNoRoles = mManager2.checkNoRoles(entityIds);
            if(cMemberNoRoles) {
              $.alert("${ctp:i18n('member.role.checkroles')}");
              var role = oManager.getRoleByName('ExternalStaff',loginAccountId);
              if(null != role) {
                $("#extRoles").val(role.showName);
                $("#extRoleIds").val(role.id);
              }
            } else {
              $("#extRoles").val("");
              $("#extRoleIds").val("");
            }
          } else {
            var roleStr = "";
            for (var i = 0; i < roleIds.length; i++) {
              var rObject = oManager.getRoleById(roleIds[i]);
              roleStr = roleStr + rObject.showName;
              if (i !== roleIds.length - 1) {
                roleStr = roleStr + ",";
              }
            };
            $("#extRoles").val(roleStr);
            $("#extRoleIds").val(roleIds);
          }
          dialog4Role.close();
        }
      },
      {
        id: "roleConcel",
        text: "${ctp:i18n('systemswitch.cancel.lable')}",
        handler: function() {
          dialog4Role.close();
        }
      }]
    });
  });
  //角色
  $("#roles").click(function() {
    $("#memberForm").resetValidate();
    dialog4Role = null;
    var tRoles = $("#roleIds").val();
    dialog4Role = $.dialog({
      url: "<c:url value='/organization/member.do' />?method=member2Role&accountId=" + loginAccountId,
      title: "${ctp:i18n('member.authorize.role')}",
      width: 400,
      height: 300,
      transParams: tRoles,
      buttons: [{
        id: "roleOK",
        text: "${ctp:i18n('guestbook.leaveword.ok')}",
        handler: function() {
          var roleIds = dialog4Role.getReturnValue();
          if(roleIds == "") {
            var entityIds = "";
            
            entityIds = entityIds + $("#orgDepartmentId").val() + ",";
            var mManager2 = new memberManager();
            var cMemberNoRoles = mManager2.checkNoRoles(entityIds);
            if(cMemberNoRoles) {
              $.alert("${ctp:i18n('member.role.checkroles')}");
              return;
            }
          }
          var roleStr = "";
          for (var i = 0; i < roleIds.length; i++) {
            var rObject = oManager.getRoleById(roleIds[i]);
            roleStr = roleStr + rObject.showName;
            if (i !== roleIds.length - 1) {
              roleStr = roleStr + ",";
            }
          };
          $("#roles").val(roleStr);
          $("#roleIds").val(roleIds);
          dialog4Role.close();
        }
      },
      {
        id: "roleConcel",
        text: "${ctp:i18n('systemswitch.cancel.lable')}",
        handler: function() {
          $("#memberForm").validate();
          dialog4Role.close();
        }
      }]
    });
  });
  //部门
  $("#deptName").click(function() {
    $("#memberForm").resetValidate();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Department',
      minSize: 1,
      maxSize: 1,
      onlyLoginAccount: true,
      accountId:'${accountId}',
      returnValueNeedType: false,
      callback: function(ret) {
        $("#deptName").val(ret.text);
        $("#memberForm #orgDepartmentId").val(ret.value);
      }
    });
  });
  //主岗
  $("#primaryPost").click(function() {
    $("#memberForm").resetValidate();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Post',
      selectType: 'Post',
      minSize: 1,
      maxSize: 1,
      onlyLoginAccount: true,
      accountId:'${accountId}',
      returnValueNeedType: false,
      callback: function(ret) {
        $("#primaryPost").val(ret.text);
        $("#orgPostId").val(ret.value);
      }
    });
  });
  //副岗
  $("#secondPost").click(function() {
    var sP4People = $("#secondPostIds").val();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Post',
      onlyLoginAccount: true,
      accountId:'${accountId}',
      returnValueNeedType: true,
      params:{value:sP4People},
      minSize: 0,
      callback: function(ret) {
        $("#memberForm").validate();
        $("#secondPost").val(ret.text);
        $("#secondPostIds").val(ret.value);
        if ($("#secondPostIds").val().indexOf("Department_Post|"+$("#orgDepartmentId").val()+"_"+$("#orgPostId").val()) !== -1) {
          $.alert("${ctp:i18n('member.mainpost.vicepost.not.same')}");
          $("#secondPost").val("");
          $("#secondPostIds").val("");
          return true;
        }
      }
    });
  });
  //职务
  $("#levelName").click(function() {
    $("#memberForm").resetValidate();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Level',
      selectType: 'Level',
      minSize: 1,
      maxSize: 1,
      onlyLoginAccount: true,
      accountId:'${accountId}',
      returnValueNeedType: false,
      callback: function(ret) {
        $("#levelName").val(ret.text);
        $("#orgLevelId").val(ret.value);
      }
    });
  });
  //登录名修改提示与清空密码
  $("#loginName").click(function() {
    $("#loginName").removeAttr("readonly");
    if (isNewMember || 'true' == isNewMember || undefined == isNewMember || 'undefined' == isNewMember || $("#isLoginNameModifyed").val() == 'true') {
      $("#loginName").focus();
    } else {
      var confirm = $.confirm({
        'title': "${ctp:i18n('common.prompt')}",
        'msg': "${ctp:i18n('account.system.loginstaff.info')}",
        ok_fn: function() {
          $("#loginName").focus();
          $("#isLoginNameModifyed").val(true);
          //如果ctpConfig开启了禁止OA修改LDAP密码则只修改登录名不清空密码
          var disableModifyLdapPsw = "${disableModifyLdapPsw}";
          if( ('true' == "${isLdapEnabled}") && (true==disableModifyLdapPsw || 'true'==disableModifyLdapPsw) ) {
          } else {
            $("#password").val("");
            $("#password2").val("");
            $("#isChangePWD").val("true");
          }
          $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
        },
        cancel_fn: function() {
          $("#name").focus();
          $("#loginName").attr("readonly","readonly");
        }
      });
    }
  });
  $("#password").click(function() {
    $("#isChangePWD").val("true");
  });

  //搜索框
  var searchobj = $.searchCondition({
    top: 7,
    right: 10,
    searchHandler: function() {
      s = searchobj.g.getReturnValue();
      s.accountId = loginAccountId;
      $("#memberTable").ajaxgridLoad(s);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('member.list.find.name')}",
      value: 'name',
      maxLength:40
    },
    {
      id: 'search_loginName',
      name: 'search_loginName',
      type: 'input',
      text: "${ctp:i18n('member.list.find.loginname')}",
      value: 'loginName',
      maxLength:100
    },
    {
      id: 'search_department',
      name: 'search_department',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.ExtDeptName.label')}",
      value: 'orgDepartmentId',
      comp: "type:'selectPeople',panels:'Outworker',selectType:'Department',maxSize:1,showAllOuterDepartment:'true', returnValueNeedType:'false',onlyLoginAccount:true,accountId:'${accountId}'"
    }, {
      id: 'search_enable',
      name: 'search_enable',
      type: 'select',
      text: "${ctp:i18n('level.select.state')}",
      value: 'enable',
      codecfg:"codeId:'common.enabled'"
    }]
  });
  
  function getCount(){
      cnt = grid.p.total;
      $("#count").get(0).innerHTML = msg.format(cnt); 
  }

  /******ldap/ad******/
  //屏蔽和现实ldap的按钮
  if('true' == "${isLdapEnabled}") {
    $("tr[class='ldapClass']").show();
    $("#ldapSet_tr1").show();
    $("#ldapSet_tr2").hide();
  } else {
    $("tr[class='ldapClass']").hide();
  }
  function ldapSet4Edit(type,ldapUserCodes) {
    if('true' == "${isLdapEnabled}") {
      $("#ldapSet_tr0").hide();
      $("#ldapSet_tr1").show();
      $("#ldapSet_tr2").hide();
      //开启LDAP后的功能，禁止修改密码
      if(type=="edit"){
    	  //打开了了oa不能修改ad密码的开关
	      if('true' == disableModifyLdapPsw || true == disableModifyLdapPsw) {
	    	  //如果已经绑定了，就不能修改密码
	    	  if(ldapUserCodes!="" && ldapUserCodes!=null && ldapUserCodes!=undefined){
		          $("#password").disable();
		          $("#password2").disable();
	    	  }else if('false' == "${LdapCanOauserLogon}"){//如果没有绑定，但是不允许在开启ad的情况下，oa账号登录时，也不能修改密码
		          $("#password").disable();
		          $("#password2").disable();
	    	  }
	    	  //其他情况：允许在开启ad的情况下，oa账号登录。并且账号没有进行绑定，则可以修改。
	      }
      }
    }
  }
  /******ldap/ad end ******/
  $('#grid_detail').resize(function(){
    if ($("#button_area").is(":hidden")) {
      $('#sssssssss').height($(this).height() - 0).css('overflow', 'auto');
    } else {
      $('#sssssssss').height($(this).height() - 38).css('overflow', 'auto');
    }
  });
  
  //清除工作地
  $("#erase").click(function() {
	  $("#showName").text("");
	  $('#workLocalCode').val("");
	  $('#workLocalName').val("");
  });
  
  //工作地
  $("#workspace").click(function() {
  	getlocation($('#workLocal').val(),false);
  	$('#showName').text($('#workspace').val());
  	var dialog = $.dialog({
  		width:400,
  		hight:300,
    id : 'workspaceDialog',
    htmlId : 'distpicker',
    title : "${ctp:i18n('org.select.work.place')}",
    buttons : [ {
      text : "${ctp:i18n('bulletin.issue.dialog.ok')}",
      isEmphasize: true, 
      handler : function() {
      	var code = $('#workLocalCode').val();
      	var name = $('#workLocalName').val();
      	if(code && name){
      		$('#workLocal').val(code);
        	$('#workspace').val(name);
      	}else{
      		$('#workLocal').val("");
        	$('#workspace').val("");
      	}
        dialog.close();
      }
    }, {
      text : "${ctp:i18n('bulletin.issue.dialog.cancel')}",
      handler : function() {
        dialog.close();
      }
    } ]
  });
  });
  
  $("#search_workLocal").click(function() {
	  $('#search_workLocal').val("");
	  $("#search_distpicker").enable();
	  getlocationSearch(false);
	  	var dialog = $.dialog({
	  		width:400,
	  		hight:300,
	    id : 'workspaceDialog',
	    htmlId : 'search_distpicker',
	    title : "${ctp:i18n('org.search.work.place')}",
	    buttons : [ {
	      text : "${ctp:i18n('org.select.work.place')}",
	      isEmphasize: true, 
	      handler : function() {
	      	var name = $('#search_workLocalName').val();
	      	if(name){
	      		$('#search_workLocal').val(name);
	      	}
	        dialog.close();
	      }
	    }, {
	      text : "${ctp:i18n('bulletin.issue.dialog.cancel')}",
	      handler : function() {
	        dialog.close();
	      }
	    } ]
	  });
  });
  
  // 汇报人
  $("#reporterName").click(function() {
    $("#memberForm").resetValidate();
    $.selectPeople({
      params:{
          text:$("#reporterName"),
          value:'Member|'+$("#reporter").val()
      },
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Member',
      minSize: 0,
      maxSize: 1,
      onlyLoginAccount: true,
      accountId:'${accountId}',
      returnValueNeedType: false,
      callback: function(ret) {
        $("#reporterName").val(ret.text);
        $("#reporter").val(ret.value);
      }
    });
  });
  
  function getlocation(location,isAutoSelect){
	  $('#workLocal').val(location);
	  $('#workspace').val("");
	    if(location){
	    	var workLocalName =""; 
	    	var $distpicker = $('#distpicker');
	    	var DEFAULTS =$distpicker.distpicker.Constructor.DEFAULTS;
	    	var dis = location.split(",");
	    	var _province = "";
			var _city = "";
			var _district = "";
			var others = [];
			try{
    		for(var index =0;index<dis.length;index++){
    			if(dis[index]){
    				if(index==0){
    						_province = ChineseDistricts[enumId][dis[0]];
    						workLocalName+=_province+"-";
    				}else if(index==1){
    					_city = ChineseDistricts[dis[0]][dis[1]];
    					workLocalName+=_city+"-";
    				}else if(index ==2){
    					_district =ChineseDistricts[dis[1]][dis[2]];
    					workLocalName+=_district+"-";
    				}else{
    					var temp = ChineseDistricts[dis[index-1]][dis[index]];
    					others.push(temp);
    					workLocalName+=temp+"-";
    				}
    			}
    		}
    		if(workLocalName){
    			workLocalName =workLocalName.slice(0,-1);
    			$('#workspace').val(workLocalName);
    			$('#workLocalCode').val(location);
    	      	$('#workLocalName').val(workLocalName);
    		}else{
    			$('#workspace').val("");
    		}
			}catch(e){
			}
    		$distpicker.distpicker({
    			rootElement: enumId,
    			province: _province===""?DEFAULTS.province:_province,
    	        city: _city===""?DEFAULTS.city:_city,
    	        district: _district===""?DEFAULTS.district:_district,
    	        autoSelect:isAutoSelect,
    	        selectsize: 15,
    	        level: eDeep,
    	        others: others
    	    });
	    }else{
	    	var $distpicker = $('#distpicker');
	    	$distpicker.distpicker({
	    		rootElement: enumId,
		        autoSelect:isAutoSelect,
		        selectsize: 15,
		        level: eDeep
		    });
	    }
  }
  function getlocationSearch(isAutoSelect){
  	var $distpicker = $('#search_distpicker');
  	$distpicker.distpicker({
  		rootElement: enumId,
	        autoSelect:isAutoSelect,
	        selectsize: 15,
	        level: eDeep
	    });
  }
});
</script>