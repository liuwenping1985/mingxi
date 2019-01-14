<%--
 $Author: lilong $
 $Rev: 4423 $
 $Date:: 2012-09-24 18:13:06#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<script type="text/javascript" language="javascript">
var grid;
$().ready(function() {
  var mManager = new xcmemberManager();
  var oManager = new orgManager();
  var imanager = new iOManager();
  var rManager = new roleManager();
  var loginAccountId = $.ctx.CurrentUser.loginAccount;
  var disableModifyLdapPsw = "${disableModifyLdapPsw}";//ctpConfig配置是否OA可以修改ldap密码
  var isNewMember = false;
  var preDeptId = "";
  var preDeptName = "";
  var o = null;//列表过滤条件
  var msg = '${ctp:i18n("info.totally")}';
  $("tr[class='forInter']").show();
  $("tr[class='forOuter']").hide();
  //列表
  grid = $("#memberTable").ajaxgrid({
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
      width: '8%'
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
      width: '12%'
    },
    {
      display: "${ctp:i18n('org.account_form.sortId.label')}",
      name: 'sortId',
      sortType:'number',
      sortable: true,
      width: '5%'
    },
    {
      display: "${ctp:i18n('org.member_form.deptName.label')}",
      name: 'departmentName',
      sortable: true,
      width: '13%'
    },
    {
      display: "${ctp:i18n('org.member_form.primaryPost.label')}",
      name: 'postName',
      sortable: true,
      width: '13%'
    },
    {
      display: "${ctp:i18n('org.member_form.levelName.label')}",
      name: 'levelName',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('org.metadata.member_type.label')}",
      sortable: true,
      codecfg: "codeId:'org_property_member_type'",
      name: 'typeName',
      width: '8%'
    },
    {
      display: "${ctp:i18n('org.metadata.member_state.label')}",
      sortable: true,
      codecfg: "codeId:'org_property_member_state'",
      name: 'stateName',
      width: '8%'
    }],x
    managerName: "xcmemberManager",
    managerMethod: "show4DeptAdmin",
    parentId: 'center',
    vChange: true,
    render: rend,
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
  function getCount(){
    cnt = grid.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
  $("#welcome").show();
  $("#form_area").hide();
  $("#button_area").hide();
  function rend(txt, data, r, c) {
    if (c == 5 || c == 6 || c == 7) {
      if (txt == '待定') {
        return '<font color="red">' + txt + '</font>';
      } else {
        return txt;
      }
    } else if(c == 2) {
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
  $("#memberTable").ajaxgridLoad(o);

  //页面按钮
  $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: newMember
    },
    {
      id: "edit",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: editMember
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 delete del_16",
      click: delMembers
    },
    {
      id: "filter",
      name: "${ctp:i18n('member.filter')}",
      className: "ico16 personnel_filter_16",
      subMenu: [{
        name: "${ctp:i18n('member.all')}",
        click: function() {
          o = new Object();
          $("#memberTable").ajaxgridLoad(o);
          grid.grid.resizeGridUpDown('down');
        }
      },
      {
        name: "-------------"
      },
      {
        name: "${ctp:i18n('member.in.manager')}",
        click: function() {
          o = new Object();
          o.condition = 'state';
          o.value = 1;
          o.enabled = true;
          $("#memberTable").ajaxgridLoad(o);
          grid.grid.resizeGridUpDown('down');
        }
      },
      {
        name: "${ctp:i18n('member.out.manager')}",
        click: function() {
          o = new Object();
          o.condition = 'state';
          o.value = 2;
          o.enabled = false;
          $("#memberTable").ajaxgridLoad(o);
          grid.grid.resizeGridUpDown('down');
        }
      },
      {
        name: "-------------"
      },
      {
        name: "${ctp:i18n('account.start')}",
        click: function() {
          o = new Object();
          o.enabled = true;
          o.state = 1;
          $("#memberTable").ajaxgridLoad(o);
          grid.grid.resizeGridUpDown('down');
        }
      },
      {
        name: "${ctp:i18n('account.stop')}",
        click: function() {
          o = new Object();
          o.enabled = false;
          o.state = 1;
          $("#memberTable").ajaxgridLoad(o);
          grid.grid.resizeGridUpDown('down');
        }
      }]
    },
    {
      id: "more",
      name: "${ctp:i18n('member.advanced')}",
      className: "ico16 setting_16",
      subMenu: [{
        name: "${ctp:i18n('member.batch.list.modify')}",
        click: function() {
          var boxs = $("#memberTable input:checked");
          if (boxs.length === 0) {
            $.alert(" ${ctp:i18n('org.member_form.choose.personnel.edit')}");
            return;
          } else {
            var membersIds = "";
            var isDeptAdminOrManager = "";
            boxs.each(function() {
              membersIds += $(this).val() + ",";
            });
            isDeptOrManager = mManager.checkMember4DeptRole(membersIds);
            if(isDeptOrManager.deptName != '') {
                $.alert(isDeptOrManager.deptName+" ${ctp:i18n('member.deptmaster.or.admin.not.batupate')}");
                var temRoles = isDeptOrManager.deptIds.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked",false);
                }
                return false;
            } else {
              dialog4Batch = $.dialog({
                url: "<c:url value='/organization/member.do' />?method=batchUpdatePre&isDeptAdmin=true",
                title: "${ctp:i18n('member.batch.list.modify')}",
                width: 320,
                height: 330,
                transParams: membersIds
              });
            }
          }
        }
      }]
    },
    {
      id: "leaveMember",
      name: "${ctp:i18n('member.out.manager.procedure')}",
      className: "ico16 staff_transferred_out_16",
      click: memberLeave
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

  //查看人员信息
  function viewDetail(id) {
    $("#form_area").clearform();
    $("#secondPostIds").val("");//OA-41812
    var mDetail = mManager.viewOne(id);
    $("#form_area").show();
    $("#welcome").hide();
    $("#memberForm").fillform(mDetail);
    //回显人物头像
    showImage();
    $("#loginName").attr("readonly","readonly");
    $("#form_area").resetValidate();
    $("#isChangePWD").val("false");
    fillSelectPeople(mDetail);
    $("#button_area").hide();
    $("#memberForm").disable();
    $("#isLoginNameModifyed").val(false);
    ldapSet4Edit();
    showConPostInfo(mDetail.conPostsInfo);
    $('#sssssssss').height($('#grid_detail').height()).css('overflow', 'auto');
  }
  //头像回写
  function showImage() {
    //回显人物头像
    var path = _ctxServer;
    var imageid=$("#imageid").val();
    var defaultImageid="${ctp:avatarImageUrl(1)}";
    var url="";
    if("" == imageid || ""==imageid.trim()){
        url = defaultImageid;
    }else{
        url = path+imageid;
    }
    var imgStr="<img src='"+url+"' width='100px' height='120px'>";
    $("#viewImageIframe").get(0).innerHTML = imgStr;
  }

  //选人界面的回写方法
  function fillSelectPeople(memberData) {
    if (null != memberData["orgDepartmentId"]) {
      //部门
      var deptInfo = oManager.getDepartmentById(memberData["orgDepartmentId"]);
      if (null != deptInfo) {
        $("#deptName").val(deptInfo.name);
        $("#orgDepartmentId").val(memberData["orgDepartmentId"]);
      }
    }
    if (null != memberData["orgPostId"]) {
      //主岗
      var primaryPostInfo = oManager.getPostById(memberData["orgPostId"]);
      if (null != primaryPostInfo) {
        $("#primaryPost").val(primaryPostInfo.name);
        $("#orgPostId").val(memberData["orgPostId"]);
      }
    }
    if (null != memberData["orgLevelId"]) {
      //职务级别
      var levelInfo = oManager.getLevelById(memberData["orgLevelId"]);
      if (null != levelInfo) {
        $("#levelName").val(levelInfo.name);
        $("#orgLevelId").val(memberData["orgLevelId"]);
      }
    }
  }

  //表格单击时间
  function clickGrid(data, r, c) {
    viewDetail(data.id);
  }

  //表格双击事件
  function dblclkGrid(data, r, c) {
    $("#form_area").clearform();
    var mDetail = new Object();
    mDetail = mManager.viewOne(data.id);
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
    $("#welcome").hide();
    $("#state").disable();
    isNewMember = false;
    $("#lconti").hide();
    ldapSet4Edit();
    $("#isLoginNameModifyed").val(false);
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }


  function newMember(argument) {
     //清除新建后记忆图片 
    var imgStr="<img src='${ctp:avatarImageUrl(1)}' width='100px' height='120px'>";
    $("#viewImageIframe").get(0).innerHTML = imgStr;
    grid.grid.resizeGridUpDown('middle');
    $("#memberForm").clearform();
    $("#secondPostIds").val("");//OA-41812
    $("#roles").val("");
    $("#roleIds").val("");
    $("#id").val("-1");
    $("#orgAccountId").val(loginAccountId);//新建人员时追加当前登录单位id，以备判断人员角色
    $("#form_area").show();
    $("#welcome").hide();
    $("#memberForm").enable();
    $("#button_area").show();
    $("#button_area").enable();
    $("#btnArea").show();
    $("#btnArea").enable();
    $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
    $("#sortIdtype1").attr("checked", "checked");
    if ("" !== preDeptId) {
      $("#orgDepartmentId").val(preDeptId);
      $("#deptName").val(preDeptName);
    }
    
    var preSortId = oManager.getMaxMemberSortByAccountId(loginAccountId);
    $("#sortId").val(parseInt(preSortId) + 1);
    isNewMember = true;
    $("#primaryLanguange").val("zh_CN");
    $("#type").val("1");
    $("#state").val("1");
    $("#state").disable();
    $("#lconti").show();
    //对新建的人员默认给一个最低级别的职务
    var lowestLevel = oManager.getLowestLevel(loginAccountId);
    if(null != lowestLevel) {
      $("#levelName").val(lowestLevel.name);
      $("#orgLevelId").val(lowestLevel.id);
    }
    //默认给人员普通角色
    var role = rManager.getDefultRoleByAccount(loginAccountId);
    if(null != role) {
      $("#roles").val(role.showName);
      $("#roleIds").val(role.id);
    }
    //ldap/ad
    if('true' == "${isLdapEnabled}") {
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
    //新建时屏蔽显示兼职的信息框
    $("#conPostsTr").hide();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
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

  /** 离职办理 */
  function memberLeave() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0 || boxs.length > 1) {
      $.alert('${ctp:i18n("member.leave")}');
      return;
    }

    var memberId = boxs[0].value;
    var member = mManager.viewOne(memberId);

    $.confirm({
      title: "${ctp:i18n('common.prompt')}",
      msg: $.i18n("member.leave.confirm", member.name),
      ok_fn: function() {
        var dialog = $.dialog({
          id : "showLeavePageDialog",
          url: "<c:url value='/organization/memberLeave.do' />?method=showLeavePage&memberId=" + memberId,
          title: $.i18n("member.leave.label") + " : " + member.name,
          width: 700,
          height: 560,
          targetWindow:window.top,
          buttons: [{
              id : "okButton",
              text: $.i18n('common.button.ok.label'),
              handler: function() {
                  var rv = dialog.getReturnValue();
              },
              OKFN : function(){
                  member.state = 2;
                  dialog.close();
                  
                  grid.grid.resizeGridUpDown('down');
                  var o = new Object();
                  o.enabled = true;
                  $("#memberTable").ajaxgridLoad(o);
              }
          },
          {
              id : "cancelButton",
              text: $.i18n('common.button.cancel.label'),
              handler: function() {
                  dialog.close();
              }
          }]
        });
      },
      cancel_fn: function() {location.reload();}
    });
  }

  /** 人员调出 */
  function cancelMember() {
    var confirm = $.confirm({
      'title': "${ctp:i18n('common.prompt')}",
      'msg': "${ctp:i18n('member.selected.staff.callout')}",
      ok_fn: function() {
        var boxs = $("#memberTable input:checked");
        if (boxs.length === 0) {
          $.alert("${ctp:i18n('member.choose.staff.callout.info')}");
          return;
        } else if (boxs.length >= 1) {
          var members = new Array();
          var membersIds = "";
          var isDeptAdminOrManager = "";
          boxs.each(function() {
            membersIds += $(this).val() + ",";
            members.push($(this).val());
          });
          isDeptAdminOrManager = mManager.checkMember4DeptRole(membersIds);
          if("" != isDeptAdminOrManager) {
            $.alert(isDeptAdminOrManager+" ${ctp:i18n('member.deptmaster.or.admin.not.operation')}");
            return false;
          } else {
            mManager.cancelMember(members, {
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
        }
      },
      cancel_fn: function() {location.reload();}
    });
  }
  function delMembers() {
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
            cancel_fn: function() {location.reload();}
          });
      }
  }

  //人员修改
  function editMember() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert(" ${ctp:i18n('org.member_form.choose.personnel.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
      return;
    }
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").clearform();
    $("#secondPostIds").val("");//OA-41812
    var mDetail = mManager.viewOne(boxs[0].value);
    $("#password").val("~`@%^*#?");
    $("#password2").val("~`@%^*#?");
    $("#sortIdtype1").attr("checked", "checked");
    $("#memberForm").enable();
    $("#memberForm").fillform(mDetail);
    showImage();
    $("#loginName").attr("readonly","readonly");
    $("#isChangePWD").val("false");
    fillSelectPeople(mDetail);
    $("#button_area").show();
    $("#form_area").show();
    $("#welcome").hide();
    isNewMember = false;
    $("#lconti").hide();
    $("#state").disable();
    $("#lconti").hide();
    ldapSet4Edit();
    $("#isLoginNameModifyed").val(false);
    showConPostInfo(mDetail.conPostsInfo);
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

  var searchObj4Org = "";
  //搜索框
  var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      var s = searchobj.g.getReturnValue();
      if(null != o && null != o.enabled) {
        s.enabled = o.enabled;
      }
      if('state' == o.condition) {
        s.state = o.value;
      }
      if(null != o.state) {
        s.state = o.state;
      }
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
      id: 'search_post',
      name: 'search_post',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.primaryPost.label')}",
      value: 'orgPostId',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',onlyLoginAccount: true"
    },
    {
      id: 'search_level',
      name: 'search_level',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.levelName.label')}",
      value: 'orgLevelId',
      comp: "type:'selectPeople',panels:'Level',selectType:'Level',maxSize:'1',onlyLoginAccount: true"
    }, {
      id: 'search_enable',
      name: 'search_enable',
      type: 'select',
      text: "${ctp:i18n('level.select.state')}",
      value: 'enable',
      codecfg:"codeId:'common.enabled'"
    }]
  });
//连续添加人员，保留部门排序号岗位职务
  function clear4addconti() {
    //清除头像
    clearAddImage();
    //连续添加被选中时，按钮显示正常
    $("#button_area").enable();
    $("#id").val("-1");
    $("#name").val("");
    $("#loginName").val("");
    $("#password").val("123456");
    $("#password2").val("123456");
    $("#birthday").val("");
    $("#officenumber").val("");
    $("#telnumber").val("");
    $("#emailaddress").val("");
    $("#description").val("");
    $("#ldapUserCodes").val("");
    $("#roles").val('');
    $("#roleIds").val('');
    var role = rManager.getDefultRoleByAccount(loginAccountId);
    if(null != role) {
      $("#roles").val(role.showName);
      $("#roleIds").val(role.id);
    }
    $("#sortId").val(parseInt($("#sortId").val()) + 1);
    var o = new Object();
    o.enabled = true;
    $("#memberTable").ajaxgridLoad(o);
    $("#memberForm").resetValidate();
  }
  //清除已有的头像信息,回归默认头像
  function clearAddImage(){
    $("#imageid").val("");
    //回归到默认头像
    var imgStr="<img src='${ctp:avatarImageUrl(1)}' width='100px' height='120px'>";
    $("#viewImageIframe").get(0).innerHTML = imgStr;
  }

  //绑定选人界面区域
  var deptIds = new Array();
  deptIds = ${deptIds};
  //部门
  $("#deptName").click(function() {
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Department',
      minSize: 1,
      maxSize: 1,
      onlyLoginAccount: true,
      returnValueNeedType: false,
      callback: function(ret) {
        var isCluded = $.inArray(ret.value, deptIds);
        var tempDeptName = ret.text;
        if(-1 == isCluded) {
          $.alert($.i18n('member.dept.not.in.manager.depts.js').format(tempDeptName));
          return true;
        }
        $("#deptName").val(ret.text);
        $("#orgDepartmentId").val(ret.value);
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
      returnValueNeedType: false,
      callback: function(ret) {
        $("#primaryPost").val(ret.text);
        $("#orgPostId").val(ret.value);
      }
    });
  });
  //副岗
  $("#secondPost").click(function() {
    var sP4People = $("#secondPost4SelectPeople").val();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Post',
      minSize: 0,
      params:{value:sP4People},
      onlyLoginAccount: true,
      returnValueNeedType: true,
      callback: function(ret) {
        $("#secondPost").val(ret.text);
        $("#secondPostIds").val(ret.value);
        $("#secondPost4SelectPeople").val(ret.value);
        if ($("#secondPostIds").val().indexOf("Department_Post|"+$("#orgDepartmentId").val()+"_"+$("#orgPostId").val()) !== -1) {
          $.alert("${ctp:i18n('member.mainpost.vicepost.not.same')}");
          $("#secondPost").val("");
          $("#secondPostIds").val("");
          $("#secondPost4SelectPeople").val("");
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
      returnValueNeedType: false,
      callback: function(ret) {
        $("#levelName").val(ret.text);
        $("#orgLevelId").val(ret.value);
      }
    });
  });
  //角色
  $("#roles").click(function() {
    $("#memberForm").resetValidate();
    var tRoles = $("#roleIds").val();
    dialog4Role = $.dialog({
      url: "<c:url value='/organization/member.do' />?method=member2Role",
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
            entityIds = entityIds + $("#orgPostId").val() + ",";
            entityIds = entityIds + $("#orgLevelId").val() + ",";
            var mManager2 = new xcmemberManager();
            var cMemberNoRoles = mManager2.checkNoRoles(entityIds);
            if(cMemberNoRoles) {
              $.alert("${ctp:i18n('member.role.checkroles')}");
              var defultRole = rManager.getDefultRoleByAccount(loginAccountId);
              if(null != defultRole) {
                $("#roles").val(defultRole.showName);
                $("#roleIds").val(defultRole.id);
              }
            } else {
              $("#roles").val("");
              $("#roleIds").val("");
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
            $("#roles").val(roleStr);
            $("#roleIds").val(roleIds);
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
          $("#state").val("1");
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

  // 表单JSON无分区无分组提交事件
  $("#btnok").click(function() {
    //人员无角色的校验2013-8-1由于需求变更修改代码
    if($("#roleIds").val() == "") {
      var entityIds = "";
      entityIds = entityIds + $("#orgAccountId").val() + ",";
      entityIds = entityIds + $("#orgDepartmentId").val() + ",";
      entityIds = entityIds + $("#orgPostId").val() + ",";
      entityIds = entityIds + $("#orgLevelId").val() + ",";
      entityIds = entityIds + $("#secondPostIds").val() + ",";
      var mManager2 = new xcmemberManager();
      var cMemberNoRoles = mManager2.checkNoRoles(entityIds);
      if(cMemberNoRoles) {
        $.alert("${ctp:i18n('member.role.checkroles')}");
        var defultRole = rManager.getDefultRoleByAccount(loginAccountId);
        if(null != defultRole) {
          $("#roles").val(defultRole.showName);
          $("#roleIds").val(defultRole.id);
        }
        return;
      } 
    }
    //密码一致
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
    if('true' == "${isLdapEnabled}") {
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
      mManager.createMember($("#memberForm").formobj(), {
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
    $("#memberForm").clearform();
    location.reload();
  });

  /******ldap/ad******/
  //屏蔽和现实ldap的按钮
  if('true' == "${isLdapEnabled}") {
    $("tr[class='ldapClass']").show();
    $("#ldapSet_tr1").show();
    $("#ldapSet_tr2").hide();
  } else {
    $("tr[class='ldapClass']").hide();
  }
  function ldapSet4Edit() {
    if('true' == "${isLdapEnabled}") {
      $("#ldapSet_tr0").hide();
      $("#ldapSet_tr1").show();
      $("#ldapSet_tr2").hide();
      if('true' == disableModifyLdapPsw || true == disableModifyLdapPsw) {
        $("#password").disable();
        $("#password2").disable();
      }
    }
  }
  /******ldap/ad end ******/
  //离职人员点启用自动置为在职
  $(".m_enable").bind('click',function() {
    var is_checkEnable = $('input[name="enabled"]:checked').val();
    if('true' == is_checkEnable) {
      $("#state").val("1");
    }
  });
  /***conPostInfoTr兼职信息的显示与隐藏**/
  function showConPostInfo(conPosts) {
    if("" === conPosts || null === conPosts || undefined === conPosts) {
      $("#conPostsTr").hide();
    } else {
      $("#conPostsTr").show();
    }
  }
  if ($("#button_area").is(":hidden")) {
    $('#sssssssss').height($(this).height() - 0).css('overflow', 'auto');
  } else {
    $('#sssssssss').height($(this).height() - 38).css('overflow', 'auto');
  }
});
</script>