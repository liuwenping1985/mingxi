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
<!DOCTYPE html>
<html>
<head>
<title>ConPostManagement</title>
<script type="text/javascript">
var dialog;
var dialog4Role;
/**兼职单位id*/
var conOrgAccountId = -1;
$().ready(function() {
  var msg = "${ctp:i18n('info.totally')}";
  var cManager = new conPostManager();
  var oManager = new orgManager();
  var imanager = new iOManager();
  var rManager = new roleManager();
  var showSort = true;
  if('${method}' === 'list4in') {
    var showSort = false;
    $("#notGroup").show();
  } else {
    $("#notGroup").hide();
  }
  $("#welcome").show();

  var grid = null;
  // 单位管理员增加副岗人员的列表
  if ("${method}" === "list4SecondPost") {
    grid = $("#mytable").ajaxgrid({
      colModel: [{
        display: 'id',
        name: 'memberId',
        hide: true,
        width: '3%',
        align: 'center',
        type: 'checkbox'
      },
      {
        display: "${ctp:i18n('cntPost.body.membername.label')}",
        name: 'memberName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('common.sort.label')}",
        name: 'sortId',
        sortable: true,
        width: '5%'
      },
      {
        display: "${ctp:i18n('org.member_form.deptName.label')}",
        name: 'deptName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('org.member_form.primaryPost.label')}",
        name: 'postName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('department.parttime.to.second.0')}",
        name: 'secPost0',
        sortable: true,
        width: '18%'
      },
      {
        display: "${ctp:i18n('department.parttime.to.second.1')}",
        name: 'secPost1',
        sortable: true,
        width: '18%'
      },
      {
        display: "${ctp:i18n('department.parttime.to.second.2')}",
        name: 'secPost2',
        sortable: true,
        width: '18%'
      },
      {
        display: "${ctp:i18n('org.metadata.member_type.label')}",
        sortable: true,
        codecfg: "codeId:'org_property_member_type'",
        name: 'typeName',
        width: '8%'
      }],
      managerName: "conPostManager",
      managerMethod: "list4SecondPost",
      parentId: 'center',
      vChange: false,
      vChangeParam: {
        overflow: 'hidden',
        position: 'relative'
      },
      slideToggleBtn: false,
      showTableToggleBtn: false
    });
  } else {
    grid = $("#mytable").ajaxgrid({
      click: clickGrid,
      dblclick: dblclk,
      colModel: [{
        display: 'id',
        name: 'id',
        width: '5%',
        align: 'center',
        type: 'checkbox'
      },
      {
        display: "${ctp:i18n('cntPost.body.membername.label')}",
        name: 'conMemberName',
        sortable: true,
        width: '8%'
      },
      {
        display: "${ctp:i18n('cntPost.body.number.label')}",
        name: 'conPostCode',
        sortable: true,
        width: '5%'
      },
      {
        display: "${ctp:i18n('cntPost.body.account.label')}",
        name: 'souAccountName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('common.sort.label')}",
        name: 'conSortId',
        sortable: true,
        width: '6%',
        hide: showSort,
        isToggleHideShow:!showSort
      },
      {
        display: "${ctp:i18n('cntPost.body.post.label')}",
        name: 'souPAnames',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('cntPost.body.cntaccount.label')}",
        name: 'tarAccountName',
        sortable: true,
        width: '15%'
      },
      {
        display: "${ctp:i18n('department.parttime.dept.and.posts')}",
        name: 'tarDPAnames',
        sortable: true,
        width: '15%'
      },
      {
          display: "${ctp:i18n('org.conpost.manage.creater')}",//创建人
          name: 'createUserName',
          sortable: true,
          width: '10%'
      },
      {
         display: "${ctp:i18n('common.date.createtime.label')}",
         name: 'createTime',
         sortable: true,
         width: '8%'
      },
      {
          display: "${ctp:i18n('org.conpost.manage.final.modifier')}",//最后修改人
          name: 'lastModifyUserName',
          sortable: true,
          width: '10%'
      },
      {
         display: "${ctp:i18n('common.date.lastupdate.label')}",
         name: 'updateTime',
         sortable: true,
         width: '8%'
      }],
      managerName: "conPostManager",
      managerMethod: "${method}",
      parentId: 'center',
      vChange: true,
      vChangeParam: {
        overflow: 'hidden',
        position: 'relative'
      },
      slideToggleBtn: true,
      showTableToggleBtn: true,
      callBackTotle:getCount
    });
  }

  //重新设置宽度
  $("#mytable").width($("#grid_detail").width());
  
  //搜索框
  var searchobj = $.searchCondition({
    top: 7,
    right: 10,
    searchHandler: function() {
      var s = searchobj.g.getReturnValue();
      $("#mytable").ajaxgridLoad(s);
    },
    conditions: [{//兼职人员
      id: 'search_cMemberName',
      name: 'search_cMemberName',
      type: 'input',
      text: "${ctp:i18n('member.name')}",
      value: 'cMemberName'
    },
    {//原单位
      id: 'search_sAccount',
      name: 'search_sAccount',
      text: "${ctp:i18n('org.dept.previous')}",
      value: 'sAccount',
      type: 'selectPeople',
      comp: "type:'selectPeople',panels:'Account',selectType:'Account',maxSize:'1',minSize:'0'"
    },
    {//兼职单位
      id: 'search_cAccount',
      name: 'search_cAccount',
      text: "${ctp:i18n('org.dept.parttime')}",
      value: 'cAccount',
      type: 'selectPeople',
      comp: "type:'selectPeople',panels:'Account',selectType:'Account',maxSize:'1',minSize:'0'"
    },
    {//兼职编号
      id: 'search_cCode',
      name: 'search_cCode',
      text: "${ctp:i18n('department.parttime.code')}",
      value: 'cCode',
      type: 'input'
    },
    {//兼职岗位
      id: 'search_cPost',
      name: 'search_cPost',
      text: "${ctp:i18n('org.dept.parttime.jobs')}",
      value: 'cPost',
      type: 'selectPeople',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',minSize:'0'"
    },
    {//所在部门
      id: 'search_department',
      name: 'search_department',
      type: 'selectPeople',
      text: "${ctp:i18n('import.type.dept')}",
      value: 'orgDepartmentId',
      comp: "type:'selectPeople',panels:'Department',selectType:'Department',maxSize:'1',onlyLoginAccount: true, returnValueNeedType: false"
    },
    {//主岗
      id: 'search_post',
      name: 'search_post',
      text: "${ctp:i18n('org.member_form.primaryPost.label')}",
      value: 'post',
      type: 'selectPeople',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',minSize:'0'"
    },
    {//副岗列表主岗查询
      id: 'search_sec_post',
      name: 'search_sec_post',
      text: "${ctp:i18n('org.member_form.primaryPost.label')}",
      value: 'orgPostId',
      type: 'selectPeople',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',minSize:'0',returnValueNeedType: false"
    },
    {//副岗查询
      id: 'search_secpost',
      name: 'search_secpost',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.secondPost.label')}",
      value: 'secPostId',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',onlyLoginAccount: true,returnValueNeedType: false"
    }]
  });
  //页面按钮
  var toolBarVar = $("#toolbar").toolbar({
    toolbar: [{
      id: "list4inToobar",
      name: "${ctp:i18n('department.parttime.to.this.dept')}",
      click: function() {
        location.href = "${path}/organization/conPost.do?method=list4in";
      }
    },
    {
      id: "list4outToobar",
      name: "${ctp:i18n('department.parttime.to.external.dept')}",
      click: function() {
        location.href = "${path}/organization/conPost.do?method=list4out";
      }
    },
    {
      id: "list4secondPost",
      name: "${ctp:i18n('department.parttime.to.second.dept')}",
      click: function() {
        location.href = "${path}/organization/conPost.do?method=list4SecondPost";
      }
    },
    {
    	id: "subUnitConPostBtn",
    	name: "${ctp:i18n('org.conpost.manage.subUnitConPostBtn')}",//子单位兼职管理
    	click: function() {
    		location.href = "${path}/organization/conPost.do?method=list4SubUnitManage";
    	}
    },
    {
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: newConPost
    },
    {
      id: "edit",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: editConPost
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 delete del_16",
      click: delConPost
    },
    {
      id: "batAdd",
      name: "${ctp:i18n('batch.add')}",
      className: "ico16 batch_edit_16",
      click: batAdd
    },
    {
      id: "export",
      name: "${ctp:i18n('export.excel')}",
      className: "ico16 export_16",
      click: function() {
        $.messageBox({
          'title': "${ctp:i18n('common.prompt')}",
          'type': 0,
          'msg': "${ctp:i18n('member.export.prompt.wait')}",
          'imgType':2,
          ok_fn: function() {
              imanager.canIO({
                success: function(rel) {
                  if ('ok' == rel) {
                    var s = searchobj.g.getReturnValue();
                    var downloadUrl_e = "${path}/organization/conPost.do?method=exportCnt&isIn=${method}&condition="+encodeURIComponent($.toJSON(s));
                    var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
                    exportIFrame.location.href = eurl_e;
                  }
                }
              });
            }
        });
      }
    },
    {
    	id: "conPostSwitch",
    	type: "checkbox",
    	checked:false,
    	text: "${ctp:i18n('org.conpost.manage.conPostSwitch')}",//允许父单位管理其所有子单位的兼职
    	value:"1",
    	click: conPostSwitchCheck
    }]
  });
  //设置开关选中状态
  $("#conPostSwitch").attr("checked",${conPostSwitch});
  if("${conPostSwitch}" != "true"){
	  toolBarVar.hideBtn("subUnitConPostBtn");//隐藏子单位兼职管理按钮
  }
  //区分集团管理员，单位管理员兼职到内兼职到外的搜索框和按钮
  $("#conPostSwitch").parent().hide();//隐藏下级单位兼职开关
  if("${hasSubUnit}" != "true"){
	  toolBarVar.hideBtn("subUnitConPostBtn");//隐藏子单位兼职管理按钮
  }
  if ("${method}" === "list4in") {
    toolBarVar.hideBtn("add");
    toolBarVar.hideBtn("batAdd");
    toolBarVar.selected("list4inToobar");
    searchobj.g.hideItem("search_cAccount");
    searchobj.g.hideItem("search_post");
    searchobj.g.hideItem("search_department");
    searchobj.g.hideItem("search_secpost");
    searchobj.g.hideItem("search_sec_post");
    showSort = false;
    $("#conInfo").get(0).innerHTML = "${ctp:i18n('org.conpost.manage.in')}";
  } else if ("${method}" === "list4out") {
    toolBarVar.hideBtn("add");
    toolBarVar.hideBtn("batAdd");
    toolBarVar.hideBtn("edit");
    toolBarVar.hideBtn("delete");
    toolBarVar.selected("list4outToobar");
    searchobj.g.hideItem("search_sAccount");
    searchobj.g.hideItem("search_cPost");
    searchobj.g.hideItem("search_department");
    searchobj.g.hideItem("search_secpost");
    searchobj.g.hideItem("search_sec_post");
    $("#conInfo").get(0).innerHTML = "${ctp:i18n('org.conpost.manage.out')}";
  } else if("${method}" === "list4SecondPost") {
    toolBarVar.hideBtn("add");
    toolBarVar.hideBtn("batAdd");
    toolBarVar.hideBtn("edit");
    toolBarVar.hideBtn("delete");
    toolBarVar.selected("list4secondPost");
    searchobj.g.hideItem("search_cAccount");
    searchobj.g.hideItem("search_sAccount");
    searchobj.g.hideItem("search_cPost");
    searchobj.g.hideItem("search_cCode");
    searchobj.g.hideItem("search_post");
  } else if("${method}" === "list4SubUnitManage") {
    toolBarVar.selected("subUnitConPostBtn");
    searchobj.g.hideItem("search_cCode");
    searchobj.g.hideItem("search_cPost");
    searchobj.g.hideItem("search_post");
    searchobj.g.hideItem("search_department");
    searchobj.g.hideItem("search_secpost");
    searchobj.g.hideItem("search_sec_post");
  } else if("${method}" === "list4Manager") {
	$("#conPostSwitch").parent().show();//显示下级单位兼职开关
    toolBarVar.hideBtn("list4inToobar");
    toolBarVar.hideBtn("list4outToobar");
    toolBarVar.hideBtn("list4secondPost");
    searchobj.g.hideItem("search_cCode");
    searchobj.g.hideItem("search_cPost");
    searchobj.g.hideItem("search_post");
    searchobj.g.hideItem("search_department");
    searchobj.g.hideItem("search_secpost");
    searchobj.g.hideItem("search_sec_post");
    $("#conInfo").get(0).innerHTML = "${ctp:i18n('org.conpost.manage')}";
  }
  
  //选中勾选开关
  function conPostSwitchCheck(){
	  var checkBox = $("#conPostSwitch").attr("checked");
	  var switchOn = false;
	  if(checkBox == "checked"){
		  switchOn = true;
	  }
	  cManager.conPostSwitch(switchOn);
  }

  //表格上双击事件
  function dblclk(data, r, c) {
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").show();
    $("#welcome").hide();
    var cPostDetail = new Object();
    cPostDetail = cManager.viewOne(data.id);
    if(!cPostDetail){
      $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'imgType':0,
              'msg': "${ctp:i18n('member.delete.title')}",
              ok_fn: function() {
                location.reload();
              }
       });
      return;
    }
    conOrgAccountId = cPostDetail.cAccountId;
    $("#form_area").clearform();
    $("#form_area").fillform(cPostDetail);
    $("#button_area").show();
    if ("${method}" != "list4out") {
      $("#form_area").enable();
    } else {
      $("#button_area").hide();
      $("#form_area").disable();
    }
    $("#primaryPost").disable();
    $("#cMember").disable();
    if ("${method}" == "list4in") {
      $("#cAccount").disable();
    }
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

  var o = new Object();
  $("#mytable").ajaxgridLoad(o);
  $("#form_area").hide();
  $("#button_area").hide();

  function newConPost() {
    $("#form_area").clearform({
          clearHidden: true
      });
    $("#id").val("-1");
    grid.grid.resizeGridUpDown('middle');
    conOrgAccountId = -1;
    $("#form_area").show();
    $("#welcome").hide();
    $("#form_area").enable();
    $("#primaryPost").disable();
    $("#button_area").show();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

//兼职人员原来单位id
var __sAccountId = "";
var excludeUnitIds = cManager.getIncludeUnitIds();
function editConPost() {
    var boxs = $("#mytable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('department.choose.data.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('department.choose.one.edit')}");
      return;
    }
    var itemId = boxs[0].value;
    var canDel = false;
    if("${method}" === "list4SubUnitManage") {
	    var checkMap = cManager.checkCanModify(itemId);
	    if(checkMap){
	    	canDel = checkMap.fromOutUnit;
	    	if(checkMap.toOutUnit){
		    	$.alert("${ctp:i18n('org.conpost.manage.alert.msg')}");//兼职到外部单位的人员，您无权修改！
		    	return;
	    	}
	    }
    }
    var cPostDetail = new Object();
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").show();
    $("#welcome").hide();
    cPostDetail = cManager.viewOne(itemId);
    if(!cPostDetail){
      $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'imgType':0,
              'msg': "${ctp:i18n('member.delete.title')}",
              ok_fn: function() {
                location.reload();
              }
       });
      return;
    }
    conOrgAccountId = cPostDetail.cAccountId;
    __sAccountId = cPostDetail.sAccountId;
    $("#form_area").enable();
    $("#cMember").disable();
    $("#primaryPost").disable();
    $("#form_area").clearform();
    $("#form_area").fillform(cPostDetail);
    if ("${method}" === "list4in" || canDel) {
      $("#cAccount").disable();
    }
    $("#button_area").show();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

  function viewDetail(relId) {
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").clearform();
    $("#form_area").show();
    $("#welcome").hide();
    var cPostDetail = new Object();
    cPostDetail = cManager.viewOne(relId);
    if(!cPostDetail){
      $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'imgType':0,
              'msg': "${ctp:i18n('member.delete.title')}",
              ok_fn: function() {
                location.reload();
              }
       });
      return;
    }
    conOrgAccountId = cPostDetail.cAccountId;
    $("#form_area").disable();
    $("#form_area").fillform(cPostDetail);
    $("#button_area").hide();
    $('#sssssssss').height($('#grid_detail').height()).css('overflow', 'auto');
  }
function delConPost() {
    var boxs = $("#mytable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('department.choose.data.delete')}");
      return;
    } else {
    	if(boxs.length == 1){
	    	var checkDelMsg = cManager.checkCanDel(boxs[0].value);
	    	if(checkDelMsg){
	    		$.alert(checkDelMsg);
	    		return;
	    	}
    	}
    	$.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('org.member_form.choose.member.delete')}",
            ok_fn: function() {
              if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
              var rels = new Array();
              boxs.each(function() {
                rels.push($(this).val());
              });
              var delResultMsg = cManager.delConPosts(rels, {
                success: function(delResultMsg) {
                  if(delResultMsg && delResultMsg.failCount > 0){
                	  var ur=_ctxPath + "/organization/conPost.do?method=showResult"
                      var dialog1 = $.dialog({
                          url : ur,
                          title: $.i18n('collaboration.system.prompt.js'), //消息提示
                          width: 560,
                          height: 310,
                          targetWindow: getCtpTop(),
                          isDrag:false,
                          transParams: delResultMsg,
                          closeParam:{
                  	        show:true,
                  	        autoClose:true,
                  	        handler:function(){
                  	        	location.reload();
                  	        }
                  	    },
                          buttons: [{
                              text: $.i18n('collaboration.dialog.close'),//关闭
                              handler: function () {
                                  dialog1.close();
                                  location.reload();
                              }
                          }],
                          minParam: {
                              show: false
                          },
                          maxParam: {
                              show: false
                          }
                      });
                  }else{
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
            },
            cancel_fn: function() {}
          });
    }
 }

  /**兼职人员的单位id*/
  var sourceOrgAccount = -1;
  /**联动选人界面*/
  //兼职人员
  var showRecent = true;
  var onlyShowChildrenAccount = false;
  if("${method}" === "list4SubUnitManage"){
    showRecent = false;
    onlyShowChildrenAccount = true;
  }
  $("#cMember").click(function() {
    $.selectPeople({
      type: 'selectPeople',
      panels: 'Department',
      selectType: 'Member',
      minSize: 1,
      maxSize: 1,
      onlyShowChildrenAccount: onlyShowChildrenAccount,
      showAccountShortname:'yes',
      showConcurrentMember: false,
      showRecent: showRecent,
      returnValueNeedType: false,
      callback: function(ret) {
        $("#cMember").val(ret.text);
        $("#cMemberId").val(ret.value);
        var priPost = cManager.getPriPostNameByMemberId(ret.value);
        $("#primaryPost").val(priPost.primaryPost);
        var soureMember = oManager.getMemberById(ret.value);
        sourceOrgAccount = soureMember.orgAccountId;
      }
    });
  });
  //兼职单位
  $("#cAccount").click(function() {
    if (firstMember()) {
      $.selectPeople({
        panels: 'Account',
        selectType: 'Account',
        minSize: 1,
        maxSize: 1,
        isCanSelectGroupAccount: false,
        returnValueNeedType: false,
	    onlyShowChildrenAccount: onlyShowChildrenAccount,
        callback: function(ret) {
          conOrgAccountId = ret.value;
          if (sourceOrgAccount === conOrgAccountId || __sAccountId ==conOrgAccountId) {
            $.alert("${ctp:i18n('department.parttime.this.external.not.same')}");
            return true; //true代表不关闭
          } else {
            $("#cDept").val("");
            $("#cDeptId").val("");
            $("#cPost").val("");
            $("#cPostId").val("");
            $("#cLevel").val("");
            $("#cLevelId").val("");
            $("#cRoles").val('');
            $("#cRoleIds").val('');
            $("#cAccount").val(ret.text);
            $("#cAccountId").val(ret.value);
            var cLowestLevel = oManager.getLowestLevel(conOrgAccountId);
            if(null != cLowestLevel) {
              $("#cLevel").val(cLowestLevel.name);
              $("#cLevelId").val(cLowestLevel.id);
            }
            var cRole = rManager.getDefultRoleByAccount(conOrgAccountId);
            // fix OA-25316 如果兼职单位的默认角色设置的是部门角色不显示
            if(null != cRole && cRole.bond != 2) {
              $("#cRoles").val(cRole.showName);
              $("#cRoleIds").val(cRole.id);
            }
            return false; //false代表关闭
          }
        }
      });
    }
  });
  //兼职部门
  $("#cDept").click(function() {
    if (firstMember()) {
      if (conOrgAccountId === -1) {
        $.alert("${ctp:i18n('department.choose.parttime.dept.info')}");
        return;
      }
      $.selectPeople({
        panels: 'Department',
        selectType: 'Department',
        minSize: 0,
        maxSize: 1,
        showAccountShortname:true,
        returnValueNeedType: false,
        accountId: conOrgAccountId,
        onlyLoginAccount: true,
        callback: function(ret) {
          $("#cDept").val(ret.text);
          $("#cDeptId").val(ret.value);
        }
      });
    }
  });
  //兼职岗位
  $("#cPost").click(function() {
    if (firstMember()) {
      if (conOrgAccountId === -1) {
        $.alert("${ctp:i18n('department.choose.parttime.dept.info')}");
        return;
      }
      $.selectPeople({
        panels: 'Post',
        selectType: 'Post',
        minSize: 0,
        maxSize: 1,
        showAccountShortname:true,
        returnValueNeedType: false,
        accountId: conOrgAccountId,
        onlyLoginAccount: true,
        callback: function(ret) {
          $("#cPost").val(ret.text);
          $("#cPostId").val(ret.value);
        }
      });
    }
    return;
  });
  //兼职职务级别
  $("#cLevel").click(function() {
    if (firstMember()) {
      if (conOrgAccountId === -1) {
        $.alert("${ctp:i18n('department.choose.parttime.dept.info')}");
        return;
      }
      $.selectPeople({
        panels: 'Level',
        selectType: 'Level',
        minSize: 0,
        maxSize: 1,
        showAccountShortname:true,
        returnValueNeedType: false,
        accountId: conOrgAccountId,
        onlyLoginAccount: true,
        callback: function(ret) {
          $("#cLevel").val(ret.text);
          $("#cLevelId").val(ret.value);
        }
      });
    }
    return;
  });

  //兼职角色
  $("#cRoles").click(function() {
    if (conOrgAccountId === -1) {
      $.alert("${ctp:i18n('department.choose.parttime.dept.info')}");
      return;
    }
    dialog4Role = null;
    var tRoles = $("#cRoleIds").val();
    dialog4Role = $.dialog({
      url: "<c:url value='/organization/member.do' />?method=cMember2Role&orgAccountId="+conOrgAccountId,
      title: "${ctp:i18n('member.authorize.role')}",
      width: 400,
      height: 300,
      isDrag: false,
      //targetWindow: window.parent,
      transParams: tRoles,
      buttons: [{
        id: "roleOK",
        isEmphasize:true,
        text: "${ctp:i18n('guestbook.leaveword.ok')}",
        handler: function() {
          var roleIds = dialog4Role.getReturnValue();
          var roleStr = "";
          if(roleIds.length>20){
        	  $.alert("${ctp:i18n('currentpost.role.max')}");
        	  return;
          }
          for (var i = 0; i < roleIds.length; i++) {
            var rObject = oManager.getRoleById(roleIds[i]);
            roleStr = roleStr + rObject.showName;
            if (i !== roleIds.length - 1) {
              roleStr = roleStr + ",";
            }
          };
          $("#cRoles").val(roleStr);
          $("#cRoleIds").val(roleIds);
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

  $("#btnok").click(function() {
    if ($("#cMemberId").val() === '') {
      $.alert("${ctp:i18n('department.choose.parttime.staff')}");
      return;
    }
    if ($("#cAccountId").val() === '') {
      $.alert("${ctp:i18n('department.choose.parttime.dept.info')}");
      return;
    }
    if ($("#cRoleIds").val() === '') {
      $.alert("${ctp:i18n('department.choose.parttime.role.info')}");
      return;
    }
    if(!($("#conPostForm").validate())){
      return;
    }
    $("#conPostForm").resetValidate();
    if ($("#id").val() === '-1') {
      var memberId = $("#cMemberId").val();
      if(memberId != "" && memberId != null){
	      var soureMember = oManager.getMemberById(memberId);
	      var orgDepartmentId = soureMember.orgDepartmentId;
	      var orgPostId = soureMember.orgPostId;
	      var orgLevelId = soureMember.orgPostId;
	      if(orgDepartmentId == "-1" || orgDepartmentId == "" ||
	    	 orgPostId == "-1" || orgPostId == "" ||
	    	 orgLevelId == "-1" || orgLevelId == ""){
	    	  $.alert("兼职人员主岗信息不完整，请补充完整后再设置兼职！");
	    	  return;
	      }
    	  
      }
      
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      
      cManager.createOne($("#conPostForm").formobj(), {
        success: function(cPostBean) {
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              location.reload();
            },
            close_fn: function() {
              location.reload();
            }
          });
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
    } else {
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      cManager.updateOne($("#conPostForm").formobj(), {
        success: function(cPostBean) {
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              location.reload();
            },
            close_fn: function() {
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
    $("#form_area").clearform();
  });

  function firstMember() {
    if ($("#cMemberId").val() === '') {
      $.alert("${ctp:i18n('department.choose.parttime.staff.first')}");
      return false;
    }
    return true;
  }

  function clickGrid(data, r, c) {
    viewDetail(data.id);
  }

  function batAdd() {
    dialog = $.dialog({
      url: "<c:url value='/organization/conPost.do' />?method=bat4Add",
      title: "${ctp:i18n('batch.add')}",
      isDrag: false,
      width: 400,
      height: 200,
  	  targetWindow:window
    });
  }

  function getCount(){
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }

  $('#grid_detail').resize(function(){
    if ($("#button_area").is(":hidden")) {
      $('#sssssssss').height($("#grid_detail").height() - 0).css('overflow', 'auto');
    } else {
      $('#sssssssss').height($("#grid_detail").height() - $("#button_area").height()).css('overflow', 'auto');
    }
  });
});
</script>
</head>
<body>
</body>
</html>