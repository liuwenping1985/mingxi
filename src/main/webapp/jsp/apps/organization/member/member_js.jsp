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
<%@ include file="/WEB-INF/jsp/apps/ldap/ldap_tools_js.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=memberManager,iOManager,orgManager,roleManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=ldapBindingMgr"></script>
<script type="text/javascript" language="javascript">
var dialog4Role;
var dialog4Batch;
var dialog;
var grid;
$().ready(function() {
  var s;//查询条件
  var isSearch =false;//保存前是进行的查询
  //为点击某部门自动将人员部门信息关联增加的变量
  var preDeptId = '';
  var preDeptName = '';
  var msg = '${ctp:i18n("info.totally")}';
  var filter = null;//列表过滤查询条件
  var loginAccountId = $.ctx.CurrentUser.loginAccount;
  var isNewMember = false;
  var disableModifyLdapPsw = "${disableModifyLdapPsw}";//ctpConfig配置是否OA可以修改ldap密码
  var mManager = new memberManager();
  var oManager = new orgManager();
  var imanager = new iOManager();
  var rManager = new roleManager();
  $("tr[class='forInter']").show();
  $("tr[class='forOuter']").hide();
  $("#button_area").hide();
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
    }],
    managerName: "memberManager",
    managerMethod: "showByAccount",
    parentId: 'center',
    vChange: true,
    render: rend,
    vChangeParam: {
      overflow: "hidden",
      position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
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
  //第一次加载表格，只加载单位内启用的人员
  filter = new Object();
  filter.enabled = true;
  $("#memberTable").ajaxgridLoad(filter);
  //部门树
  $("#deptTree").tree({
    idKey: "id",
    pIdKey: "parentId",
    nameKey: "name",
    onClick: showMembersByDept,
    nodeHandler: function(n) {
      if (n.data.parentId == n.data.id) {
        n.open = true;
      } else {
        n.open = false;
      }
    }
  });

  //手动去除部门树上的节点选择状态
  function cancelSelectTree() {
    $("#deptTree").treeObj().cancelSelectedNode();
    preDeptId = '';
    searchobj.g.clearCondition();
    s = searchobj.g.getReturnValue();
  }
  var westHide = false;
  //页面按钮
  var toolBarVar = $("#toolbar").toolbar({
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
            url: '${path}/organization/organizationControll.do?method=importExcel&importType=member',
            title: "${ctp:i18n('import.excel')}",
            closeParam:{
              'show':true,
              handler:function(){
                filter = new Object();
                filter.enabled = true;
                isSearch = false;
                $("#memberTable").ajaxgridLoad(filter);}
            }
          });
        }
      },
      {
        name: "${ctp:i18n('org.template.excel.download')}",
        click: function() {
          var downloadUrl = "${path}/organization/organizationControll.do?method=downloadTemplate&type=Member";
          var eurl = "<c:url value='" + downloadUrl + "' />";
          exportIFrame.location.href = eurl;
        }
      },
      {
        name: "${ctp:i18n('org.post_form.export.exel')}",
        click: function() {
          if(oManager.getOrgExportFlag() || oManager.getOrgExportFlag() == 'true') {
            $.alert("${ctp:i18n('org.alert.info')}");
            return;
          } else {
            $.alert({
              'title': "${ctp:i18n('common.prompt')}",
              'msg': "${ctp:i18n('member.export.prompt.wait')}",
              ok_fn: function() {
                imanager.canIO({
                    success: function(rel) {
                      if ('ok' == rel) {
                        var downloadUrl_e = "${path}/organization/member.do?method=exportMembers&condition="+encodeURI($.toJSON(s))+"&filter="+$.toJSON(filter)+"&orgDepartmentId="+preDeptId;
                        var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
                        exportIFrame.location.href = eurl_e;
                      }
                    }
                  });
                }
            });
          }
        }
      },
      {
        id: 'importLDIF',
        name: "${ctp:i18n('ldap.impPost.ldif')}",
        click: impPost
      }]
    },
    {
      id: "filter",
      name: "${ctp:i18n('member.filter')}",
      className: "ico16 personnel_filter_16",
      subMenu: [{
        name: "${ctp:i18n('member.all')}",
        click: function() {
          filter = new Object();
          filter.enabled = null;
          isSearch = false;
          $("#memberTable").ajaxgridLoad(filter);
          grid.grid.resizeGridUpDown('down');
          cancelSelectTree();
        }
      },
      {
        name: "-------------"
      },
      {
        name: "${ctp:i18n('member.in.service')}",
        click: function() {
          filter = new Object();
          filter.condition = 'state';
          filter.value = 1;
          filter.enabled = true;
          isSearch = false;
          $("#memberTable").ajaxgridLoad(filter);
          grid.grid.resizeGridUpDown('down');
          cancelSelectTree();
        }
      },
      {
        name: "${ctp:i18n('member.out.service')}",
        click: function() {
          filter = new Object();
          filter.condition = 'state';
          filter.value = 2;
          filter.enabled = false;
          isSearch = false;
          $("#memberTable").ajaxgridLoad(filter);
          grid.grid.resizeGridUpDown('down');
          cancelSelectTree();
        }
      },
      {
        name: "-------------"
      },
      {
        name: "${ctp:i18n('account.start')}",
        click: function() {
          filter = new Object();
          filter.enabled = true;
          isSearch = false;
          $("#memberTable").ajaxgridLoad(filter);
          grid.grid.resizeGridUpDown('down');
          cancelSelectTree();
        }
      },
      {
        name: "${ctp:i18n('account.stop')}",
        click: function() {
          filter = new Object();
          filter.enabled = false;
          isSearch = false;
          $("#memberTable").ajaxgridLoad(filter);
          grid.grid.resizeGridUpDown('down');
          cancelSelectTree();
        }
      }]
    },
    {
      id: "more",
      name: "${ctp:i18n('member.advanced')}",
      className: "ico16 setting_16",
      subMenu: [{
        id:"cancelMemberBtn",
        name: "${ctp:i18n('member.callout')}",
        click: cancelMember
      },
      {
        name: "${ctp:i18n('member.batch.list.modify')}",
        click: function() {
          var boxs = $("#memberTable input:checked");
          if (boxs.length === 0) {
            $.alert(" ${ctp:i18n('org.member_form.choose.personnel.edit')}");
            return;
          } else {
            var membersIds = "";
            var isDeptOrManager = "";
            boxs.each(function() {
              membersIds += $(this).val() + ",";
            });
            isDeptOrManager = mManager.checkMember4DeptRole(membersIds);
            if(isDeptOrManager.deptName.trim() != '') {
                $.alert(isDeptOrManager.deptName+" ${ctp:i18n('member.deptmaster.or.admin.not.batupate')}");
                var temRoles = isDeptOrManager.deptIds.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked",false);
                }
                return false;
            } else {
              dialog4Batch = $.dialog({
                id:"batchDia",
                url: "<c:url value='/organization/member.do' />?method=batchUpdatePre&isDeptAdmin=false",
                title: "${ctp:i18n('member.batch.list.modify')}",
                width: 320,
                height: 330,
                transParams: membersIds
              });
            }
          }
        }
      },
      {
        name: "${ctp:i18n('member.tree.structure')}",
        click: function() {
          var layout = $("#layout").layout();
          if (!westHide) {
            layout.setWest(0);
            westHide = true;
          } else {
            layout.setWest(200);
            westHide = false;
          }
        }
      }]
    },
    {
      id: "leaveMember",
      name: "${ctp:i18n('member.out.service.procedure')}",
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

  //区分集团版企业版隐藏人员调出按钮
  if ("${isGroupVer}" == "false" || "${isGroupVer}" == false) {
    toolBarVar.hideBtn("cancelMemberBtn");
  }
  
  //查看人员信息
  function viewDetail(id) {
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").clearform();
    $("#secondPostIds").val("");//OA-41812
    var mDetail = mManager.viewOne(id);
    $("#form_area").show();
    $("#welcome").hide();
    $("#memberForm").fillform(mDetail);
    $("#loginName").attr("readonly","readonly");
    //头像回写
    showImage();
    $("#form_area").resetValidate();
    $("#isChangePWD").val("false");
    fillSelectPeople(mDetail);
    $("#button_area").hide();
    $('#sssssssss').height($('#grid_detail').height()).css('overflow', 'auto');
    $("#memberForm").disable();
    ldapSet4Edit();
    showConPostInfo(mDetail.conPostsInfo);
    $("#isLoginNameModifyed").val(false);
  }
  /*人员头像回填*/
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
    if (null != memberData["orgDepartmentId"] || '-1' != memberData["orgDepartmentId"]) {
      //部门
      var deptInfo = oManager.getDepartmentById(memberData["orgDepartmentId"]);
      if (null != deptInfo) {
        $("#deptName").val(deptInfo.name);
        $("#orgDepartmentId").val(memberData["orgDepartmentId"]);
      }
    }
    if (null != memberData["orgPostId"] || '-1' != memberData["orgPostId"]) {
      //主岗
      var primaryPostInfo = oManager.getPostById(memberData["orgPostId"]);
      if (null != primaryPostInfo) {
        if(primaryPostInfo.enabled == false) {
          $("#primaryPost").val("待定");
          $("#orgPostId").val(-1);
        } else {
          $("#primaryPost").val(primaryPostInfo.name);
          $("#orgPostId").val(memberData["orgPostId"]);
        }
      }
    }
    if (null != memberData["orgLevelId"] || '-1' != memberData["orgLevelId"]) {
      //职务级别
      var levelInfo = oManager.getLevelById(memberData["orgLevelId"]);
      if (null != levelInfo) {
        $("#levelName").val(levelInfo.name);
        $("#orgLevelId").val(memberData["orgLevelId"]);
      }
    }
  }

  //表格单击事件
  function clickGrid(data, r, c) {
    viewDetail(data.id);
  }

  //表格双击事件
  function dblclkGrid(data, r, c) {
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
    showConPostInfo(mDetail.conPostsInfo);
    $("#isLoginNameModifyed").val(false);
    $("#memberForm").resetValidate();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }
  
  function newMember() {
    $("#password").val("123456");
    $("#password2").val("123456");
    isNewMember = true;
    $("#isNewMember").val("true");
    var imgStr="<img src='${ctp:avatarImageUrl(1)}' width='100px' height='120px'>";
    $("#viewImageIframe").get(0).innerHTML = imgStr;
    grid.grid.resizeGridUpDown('middle');
    $("#memberForm").clearform();
    $("#secondPostIds").val("");//OA-41812
    $("#loginName").removeAttr("readonly");
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
    $("#lconti").show();
    $("#primaryLanguange").val("zh_CN");
    $("#type").val("1");
    $("#state").val("1");
    $("#state").disable();
    //对新建的人员默认给一个最低级别的职务
    var lowestLevel = oManager.getLowestLevel(loginAccountId);
    if(null != lowestLevel) {
      $("#levelName").val(lowestLevel.name);
      $("#orgLevelId").val(lowestLevel.id);
    }
    //默认给人员一个普通角色
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
    } else {
      $("#ldapSet_tr0").hide();
      $("#ldapSet_tr1").hide();
      $("#ldapSet_tr2").hide();
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

  //点击部门树某一部门展现某部门的人员
  function showMembersByDept(e, treeId, node) {
  	isSearch=false;
    grid.grid.resizeGridUpDown('down');
    $("#welcome").show();
    $("#form_area").hide();
    $("#button_area").hide();
    if (node.parentId === 0) {
      preDeptId = '';
      preDeptName = '';
      filter.showByType = null;
      $("#memberTable").ajaxgridLoad(filter);
    } else {
      //var o2 = new Object();
      filter.showByType = "showByDepartment";
      filter.deptId = node.id;
      $("#memberTable").ajaxgridLoad(filter);
      preDeptId = node.id;
      preDeptName = node.name;
    }
  }
  /** 离职办理 */
  function memberLeave() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0 || boxs.length > 1) {
      $.alert('${ctp:i18n("member.leave")}');
      return;
    }

    var memberId = boxs[0].value;
    var member = mManager.viewOne(memberId);

    if(navigator.userAgent.toLowerCase().indexOf("nt 10.0")!=-1&&navigator.userAgent.toLowerCase().indexOf("trident")!=-1){
      var leaveConfirm=confirm($.i18n("member.leave.confirm", member.name));
      if(leaveConfirm==true){
        var dialog = $.dialog({
            id : "showLeavePageDialog",
            url: "<c:url value='/organization/memberLeave.do' />?method=showLeavePage&memberId=" + memberId,
            title: $.i18n("member.leave.label") + " : " + member.name,
            width: 700,
            height: 540,
            targetWindow:window.top,
            isClear:false,//OA-49174
            buttons: [{
                id : "okButton",
                text: $.i18n('common.button.ok.label'),
                handler: function() {
                    var rv = dialog.getReturnValue();
                    $.messageBox({
                        'title': "提示",
                        'type': 0,
                        'imgType':0,
                        'msg': "操作成功!",
                        ok_fn: function() {
                        	   member.state = 2;
                               dialog.close();
                               
                               grid.grid.resizeGridUpDown('down');
                               $("#welcome").show();
                               $("#form_area").hide();
                               filter.enabled = true;
                               $("#memberTable").ajaxgridLoad(filter);
                        }
                      });
                },
                OKFN : function(){
                    member.state = 2;
                    dialog.close();
                    
                    grid.grid.resizeGridUpDown('down');
                    $("#welcome").show();
                    $("#form_area").hide();
                    filter.enabled = true;
                    $("#memberTable").ajaxgridLoad(filter);
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
      }else{
        return false;
      }
    }else{
      $.confirm({
        title: "${ctp:i18n('common.prompt')}",
        msg: $.i18n("member.leave.confirm", member.name),
        ok_fn: function() {
          var dialog = $.dialog({
            id : "showLeavePageDialog",
            url: "<c:url value='/organization/memberLeave.do' />?method=showLeavePage&memberId=" + memberId,
            title: $.i18n("member.leave.label") + " : " + member.name,
            width: 700,
            height: 540,
            targetWindow:window.top,
            isClear:false,//OA-49174
            buttons: [{
                id : "okButton",
                text: $.i18n('common.button.ok.label'),
                handler: function() {
                    var rv = dialog.getReturnValue();
                    $.messageBox({
                        'title': "提示",
                        'type': 0,
                        'imgType':0,
                        'msg': "操作成功!",
                        ok_fn: function() {
                        	   member.state = 2;
                               dialog.close();
                               
                               grid.grid.resizeGridUpDown('down');
                               $("#welcome").show();
                               $("#form_area").hide();
                               filter.enabled = true;
                               $("#memberTable").ajaxgridLoad(filter);
                        }
                      });
                },
                OKFN : function(){
                    member.state = 2;
                    dialog.close();
                    
                    grid.grid.resizeGridUpDown('down');
                    $("#welcome").show();
                    $("#form_area").hide();
                    filter.enabled = true;
                    $("#memberTable").ajaxgridLoad(filter);
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
        }
      });
    }
  }

  /** 人员调出 */
  function cancelMember() {
    var boxs = $("#memberTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.canel')}");
      return;
    } else {
      $.confirm({
        'title': "${ctp:i18n('common.prompt')}",
        'msg': "${ctp:i18n('organization_post_cancel_ysno')}",
        ok_fn: function() {
          if (boxs.length === 0) {
            $.alert("${ctp:i18n('org.member_form.choose.personnel.canel')}");
            return;
          } else if (boxs.length >= 1) {
            var membersIds = "";
            var members = new Array();
            var isDeptOrManager = "";
            boxs.each(function() {
              membersIds += $(this).val() + ",";
              members.push($(this).val());
            });
            isDeptOrManager = mManager.checkMember4DeptRole(membersIds);
            if(isDeptOrManager.deptName.trim() != '') {
                $.alert(isDeptOrManager.deptName+" ${ctp:i18n('member.deptmaster.or.admin.not.operation')}");
                var temRoles = isDeptOrManager.deptIds.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked",false);
                }
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
                    	isSearch = false;
                      $("#memberTable").ajaxgridLoad(filter);
                    }
                  });
                }
              });
            }
          }
        },
        cancel_fn: function() {isSearch = false;$("#memberTable").ajaxgridLoad(filter);}
      });
    }
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
      $.alert("${ctp:i18n('org.member_form.choose.personnel.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
      return;
    } else {
      document.getElementById("isNewMember").value = false;
      grid.grid.resizeGridUpDown('middle');
      $("#form_area").clearform();
      $("#secondPostIds").val("");//OA-41812
      var mDetail = mManager.viewOne(boxs[0].value);
      $("#password").val("~`@%^*#?");
      $("#password2").val("~`@%^*#?");
      $("#sortIdtype1").attr("checked", "checked");
      $("#memberForm").fillform(mDetail);
      showImage();
      $("#loginName").attr("readonly","readonly");
      $("#isChangePWD").val("false");
      fillSelectPeople(mDetail);
      $("#loginName").attr('readonly','readonly');
      $("#button_area").show();
      $("#form_area").show();
      $("#welcome").hide();
      isNewMember = false;
      $("#lconti").hide();
      $("#memberForm").enable();
      $("#state").disable();
      ldapSet4Edit();
      showConPostInfo(mDetail.conPostsInfo);
      $("#isLoginNameModifyed").val(false);
      $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
    }
  }

  //搜索框
  var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      s = searchobj.g.getReturnValue();
      s.enabled = filter.enabled;
      if('state' == filter.condition) {
        s.state = filter.value;
      }
      if(null != filter.state) {
        s.state = filter.state;
      }
      // if(null != preDeptId || '' != preDeptId) {
      //   s.orgDepartmentId = preDeptId;
      // }
      isSearch =true;
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
      text: "${ctp:i18n('import.type.dept')}",
      value: 'orgDepartmentId',
      comp: "type:'selectPeople',panels:'Department',selectType:'Department',maxSize:'1',onlyLoginAccount: true"
    },
    {
      id: 'search_post',
      name: 'search_post',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.primaryPost.label')}",
      value: 'orgPostId',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',onlyLoginAccount: true"
    },
    {//副岗查询
      id: 'search_secpost',
      name: 'search_secpost',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.secondPost.label')}",
      value: 'secPostId',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',onlyLoginAccount: true"
    },
    {
      id: 'search_level',
      name: 'search_level',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.levelName.label')}",
      value: 'orgLevelId',
      comp: "type:'selectPeople',panels:'Level',selectType:'Level',maxSize:'1',onlyLoginAccount: true"
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
    $("#secondPost").val("");
    $("#secondPostIds").val("");
    $("#ldapUserCodes").val("");
    $("#sortId").val(parseInt($("#sortId").val()) + 1);
    $("#roles").val('');
    $("#roleIds").val('');
    var role = rManager.getDefultRoleByAccount(loginAccountId);
    if(null != role) {
      $("#roles").val(role.showName);
      $("#roleIds").val(role.id);
    }
	  //勾选连续添加后列表根据之前的条件自动刷新列表
    filter = new Object();
    if ("" !== preDeptId) {
      filter.deptId = preDeptId;
      filter.enabled = true;
      filter.showByType = "showByDepartment";
    } else {
      filter.enabled = true;
    }
    isSearch =false;
    $("#memberTable").ajaxgridLoad(filter);
    $("#form_area").show();
    $("#welcome").hide();
    $("#memberForm").resetValidate();
  }
  //清除已有的头像信息,回归默认头像
  function clearAddImage(){
    $("#imageid").val("");
    //回归到默认头像
    var imgStr="<img src='${ctp:avatarImageUrl(1)}' width='100px' height='120px'>";
    $("#viewImageIframe").get(0).innerHTML = imgStr;
  }
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
  //绑定选人界面区域
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
      returnValueNeedType: false,
      callback: function(ret) {
        $("#deptName").val(ret.text);
        $("#memberForm #orgDepartmentId").val(ret.value);
        // 如果换了部门就把原来的部门角色清除
        if($("#id").val() != -1) {
          var tempOne = mManager.viewOne($("#id").val());
          if($("#orgDepartmentId").val() != tempOne.orgDepartmentId) {
            $("#roles").val("");
            $("#roleIds").val("");
            var noDeptRoles = mManager.noDeptRoles($("#id").val());
            $("#roles").val(noDeptRoles.roles);
            $("#roleIds").val(noDeptRoles.roleIds);
          } else if($("#orgDepartmentId").val() == tempOne.orgDepartmentId) {
            $("#roles").val("");
            $("#roleIds").val("");
            $("#roles").val(tempOne.roles);
            $("#roleIds").val(tempOne.roleIds);
          }
        }
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
    var sP4People = $("#secondPostIds").val();
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Post',
      onlyLoginAccount: true,
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
      returnValueNeedType: false,
      callback: function(ret) {
        $("#levelName").val(ret.text);
        $("#orgLevelId").val(ret.value);
      }
    });
  });

  $("#roles").click(function() {
    dialog4Role = null;
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
            entityIds = entityIds + $("#secondPostIds").val() + ",";
            var mManager2 = new memberManager();
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
          $("#memberForm").validate();
          dialog4Role.close();
        }
      }]
    });
    $("#memberForm").resetValidate();
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
      var mManager2 = new memberManager();
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
    //密码一致校验
    if ($("#password").val() !== $("#password2").val()) {
      $.alert("${ctp:i18n('account.system.newpassword.again.not.consistent')}");
      $("#password").val("");
      $("#password2").val("");
      $("#password").focus();
      return;
    }
    //输入正确性校验
    if(!($("#memberForm").validate())){
        $("#button_area").enable();
        return;
    }
    if($("#orgPostId").val() == '-1') {
      $.alert("请选择主岗！");//OA-54001
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
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
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
                filter = new Object();
                if ("" !== preDeptId) {
                  filter.deptId = preDeptId;
                  filter.showByType = "showByDepartment";
                } else {
                  filter.enabled = true;
                }
                $("#memberTable").ajaxgridLoad(filter);
                grid.grid.resizeGridUpDown('down');
                getCount();
                $("#form_area").hide();
                $("#button_area").hide();
                $("#welcome").show();
                
              }
            });
          }
        }
      });
    } else {
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      mManager.updateMember($("#memberForm").formobj(), {
        success: function(memberBean) {
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              //filter = new Object();
              if ("" !== preDeptId) {
                filter.deptId = preDeptId;
                filter.showByType = "showByDepartment";
              } else {
                filter.enabled = true;
              }
              if(isSearch){
              	$("#memberTable").ajaxgridLoad(s);
              }else{
              	$("#memberTable").ajaxgridLoad(filter);
              }
              
              grid.grid.resizeGridUpDown('down');
              getCount();
              $("#form_area").hide();
              $("#button_area").hide();
              $("#welcome").show();
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

  /******ldap/ad******/
  //屏蔽和现实ldap的按钮
  if('true' == "${isLdapEnabled}") {
    $("tr[class='ldapClass']").show();
    $("#ldapSet_tr1").show();
    $("#ldapSet_tr2").hide();
  } else {
    $("tr[class='ldapClass']").hide();
    toolBarVar.hideBtn("importLDIF");
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
  //LDAP导入文件
  function impPost() {
    var sendResult = v3x.openWindow({
      url: "/seeyon/ldap/ldap.do?method=importLDIF",
      width: "390",
      height: "155",
      resizable: "false",
      scrollbars: "yes"
    });
    if (!sendResult) {
      return;
    } else {
      filter = new Object();
      filter.enabled = null;
      isSearch = false;
      $("#memberTable").ajaxgridLoad(filter);
      grid.grid.resizeGridUpDown('middle');
      getCount();
      $("#welcome").show();
    }
  }
  /******ldap/ad end ******/
  /***conPostInfoTr兼职信息的显示与隐藏**/
  function showConPostInfo(conPosts) {
    if("" === conPosts || null === conPosts || undefined === conPosts) {
      $("#conPostsTr").hide();
    } else {
      $("#conPostsTr").show();
    }
  }
  //离职人员点启用自动置为在职
  $(".m_enable").bind('click',function() {
    var is_checkEnable = $('input[name="enabled"]:checked').val();
    if('true' == is_checkEnable) {
      $("#state").val("1");
    }
  });

  $('#grid_detail').resize(function(){
    if ($("#button_area").is(":hidden")) {
      $('#sssssssss').height($(this).height() - 0).css('overflow', 'auto');
    } else {
      $('#sssssssss').height($(this).height() - 38).css('overflow', 'auto');
    }
  });
});
</script>