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
<script type="text/javascript" src="${path}/ajax.do?managerName=accountManager"></script>
<script type="text/javascript">
function initPwd(){
	var adminPass1 = $("#adminPass1").val();
	var adminPass = $("#adminPass").val();
	if((adminPass1 == "" || adminPass1 ==" ") && adminPass != ""){
		 $("#adminPass1").val(adminPass);
	}
}
var aManager = new accountManager();
$().ready(function() {
  $("#isLdapEnabled").val(aManager.isEnableLdap());
  $("#unitTable").ajaxgrid({
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('org.account_form.name.label')}",
      name: 'name',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.account_form.sortId.label')}",
      name: 'sortId',
      sortType:'number',
      sortable: true,
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.account_form.shortname.label')}",
      name: 'shortName',
      sortable: true,
      width: '15%'
    },
    {
      display: "${ctp:i18n('org.account_form.superior.label')}",
      name: 'superiorName',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.account_form.code.label')}",
      name: 'code',
      sortable: true,
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.account_form.adminName.label')}",
      name: 'loginName',
      sortable: true,
      width: '15%'
    }],
    managerName: "accountManager",
    managerMethod: "showAccounts",
    parentId: $(".layout_center").eq(0).attr("id"),
    vChange: true,
    vChangeParam: {
      overflow: "hidden",
      autoResize: false
    },
    showTableToggleBtn: false,
    resizable: false,
    dblclick: dblclk,
    render: rend,
    //click: clickGrid,
    slideToggleBtn: false
  });

  function rend(txt, data, r, c) {
    if (c == 1) {
      return '<a href="javascript:viewByName(\'' + data.id + '\')" id="panle' + r + '">' + txt + '</a>';
    } else return txt;
  }
  //表格加载
  var o = new Object();
  $("#unitTable").ajaxgridLoad(o);
  //机构树
  $("#unitTree").tree({
    idKey: "id",
    pIdKey: "parentId",
    nameKey: "name",
    onClick: clk,
    onDblClick: treeDBClk,
    enableAsync : true,
    managerName : "accountManager",
    managerMethod : "showAccountTree",
    nodeHandler: function(n) {
      if(n.data.parentId == '-1') {
        n.open = true;
      } else {
        n.open = false;
      }
      
    }
  });
  $("#unitTree").treeObj().reAsyncChildNodes(null,"refresh",false);

  //表格单击事件
  function clickGrid(data, r, c) {
    clk('','',data);
  }
  //机构树上的单点击事件
  function clk(e, treeId, node) {
    if (node.id === '-1') { //点击集团显示列表
      $("#table_area").show();
      $("#form_area").hide();
      var o = new Object();
      $("#unitTable").ajaxgridLoad(o);
      $("#id").val("-1");
      $("#orgAccountId").val("-1");
      $("#path").val("-1");
      $("#ldapSet").hide();
    } else { //点击单位回填form
      viewOne(node.id);
    }
  }

  //机构树上双击修改事件
  function treeDBClk(e, treeId, node) {
    if(null == node) return;
    editDetail(node.id);
  }

  //表格上双击事件
  function dblclk(data, r, c) {
    editDetail(data.id);
  }

  //页面按钮
  var toolBarVar = $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: newAccount
    },
    {
      id: "edit",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: editAccount
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 delete del_16",
      click: delAccount
    }]
  });

  //连续添加机构
  function newAccount4conti() {
    //代码重复
    $("#id").val("-1");
    $("#name").val("");
    $("#shortName").val("");
    $("#secondName").val("");
    $("#code").val("");
    $("#description").val("");
    $("#adminName").val("");
    $("#adminPass").val("123456");
    $("#adminPass1").val("123456");
    $("#sortId").val(parseInt($("#sortId").val()) + 1);

    $("#form_area").enable();
    $("#form_area").show();
    $("#table_area").hide();
    $("#button_area").show();
    $("#button_area").enable();
    $("#id").val("-1");
    if ($("#orgAccountId").val() === '-1') {
      //不点击树上节点直接点新建单位默认上级单位是集团，先写死  TODO
      $("#superiorName").comp({
        value: 'Account|-1730833917365171641',
        text: "${ctp:i18n('account.group')}"
      });
    } else {
      //自动新建自动关联从左侧树选中过来的上级单位
      var pName = $("#unitTree").treeObj().getSelectedNodes()[0].name;
      $("#superiorName").comp({
        value: 'Account|' + $("#orgAccountId").val(),
        text: pName
      });
    }
    //自动增加连续排序号
    var preSortId = aManager.getMaxSort();
    $("#sortId").val(parseInt(preSortId) + 1);
    $("#sortIdtype1").attr("checked", "checked");
    $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
    //单位管理员信息框
    $("#adminName").removeAttr("readonly");
    $("#adminPasswordtr").show();
    $("#validatepasswordtr").show();
    $("#pswpromotetr").show();
    $("tr[class='nonGroup']").show();
    $("tr[class='nonGroup']").enable();
    //!!防止由于集团版的input引起id相同无法提交
    $("tr[class='cGroup']").disable();
    $("tr[class='cGroup']").hide();
    $("#pswchecktr").hide();
    $("#lianxu").show();
    $("#copyGL").show();
    //默认选择全部可见
    $("input[name='permissionType']").get(0).checked=true;
    $("#sLevel").attr("checked",false);
    $("#pLevel").attr("checked",false);
    $("#xLevel").attr("checked",false);
    $("#range").val("");
    //ldap/ad
    if('true' == $("#isLdapEnabled").val()) {
      $("#ldapSet").show();
    } else {
      $("#ldapSet").hide();
    }
    disRange0();
    //单位登录页
    $("input[name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
    $("#customLoginUrlTr").hide();
    $("#customLoginUrlDescTr").hide();
  }

  //新建机构
  function newAccount() {
    $("#lianxu").show();
    $("#copyGL").show();
    $("#form_area").clearform();
    $("#form_area").enable();
    $("#form_area").show();
    $("#table_area").hide();
    $("#button_area").show();
    $("#button_area").enable();
    $("#id").val("-1");
    if ($("#orgAccountId").val() === '-1') {
      var rootAcc = aManager.viewAccount('-1730833917365171641');
      $("#superiorName").comp({
        value: 'Account|-1730833917365171641',
        text: rootAcc.name
      });
    } else {
      //自动新建自动关联从左侧树选中过来的上级单位
      if($("#unitTree").treeObj().getSelectedNodes()[0]){
        var pName = $("#unitTree").treeObj().getSelectedNodes()[0].name;
        $("#superiorName").comp({
          value: 'Account|' + $("#orgAccountId").val(),
          text: pName
        });
      }
    }
    //自动增加连续排序号
    var preSortId = aManager.getMaxSort();
    if(preSortId==-1) {preSortId=0}//集团排序号是-1，自增需要从1开始，排序号不能填0
    $("#sortId").val(parseInt(preSortId) + 1);
    $("#sortIdtype1").attr("checked", "checked");
    $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
    //默认勾选连续添加勾选复制集团职务
    $("#copyGroupLevel").attr("checked", "checked");
    $("#isCopyGroupLevel").val("1");
    $("#conti").attr("checked", "checked");
    //单位管理员信息框
    $("#adminName").removeAttr("readonly");
    $("#adminPasswordtr").show();
    $("#validatepasswordtr").show();
    $("#pswpromotetr").show();
    $("tr[class='nonGroup']").show();
    $("tr[class='nonGroup']").enable();
    //!!防止由于集团版的input引起id相同无法提交
    $("tr[class='cGroup']").disable();
    $("tr[class='cGroup']").hide();
    $("#pswchecktr").hide();

    //新建时不显示并发设置
    $(".permission").hide();

    //默认选择全部可见
    $("input[name='permissionType']").get(0).checked=true;
    $("#pType").val("1");
    disRange0();
    //ldap/ad
    if('true' == $("#isLdapEnabled").val()) {
      $("#ldapSet").show();
    } else {
      $("#ldapSet").hide();
    }
    $("input[name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
    $("#customLoginUrlTr").hide();
    $("#customLoginUrlDescTr").hide();
  }
  //修改一个
  function editAccount() {
    var aDetail = new Object();
    if ($("#id").val() !== "-1") {
      aDetail = aManager.viewAccount($("#id").val());
    } else {
      var boxs = $("#unitTable input:checked");
      if (boxs.length === 0) {
        $.alert("${ctp:i18n('account.team.choose.edit')}");
        return;
      } else if (boxs.length > 1) {
        $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
        return;
      } else {
        aDetail = aManager.viewAccount(boxs[0].value);
        $("#sortIdtype1").attr("checked", "checked");
      }
    }
    $("#lianxu").hide();
    $("#copyGL").hide();
    $("#form_area").clearform();
    $("#accountForm").enable();
    $("#table_area").hide();
    $("#button_area").show();
    $("#form_area").show();
    $("#form_area").fillform(aDetail);
    showPermission(aDetail);
    if(aDetail.enabled == true || aDetail.enabled == 'true') {
      $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
    } else {
      $("input[type='radio'][name='enabled'][value='false']").attr("checked", "checked");
    }
    $("#superiorName").comp({
      value: 'Account|' + aDetail["superior"],
      text: aDetail['superiorName'],
      excludeElements: 'Account|' + aDetail.id
    });

    $("#sortIdtype1").attr("checked", "checked");
    $("#permissionType1").attr("checked", "checked");
    $("#checkManager").removeAttr("checked");
    $("#pswchecktr").show();
    
    $("#range").comp({ value: '', text: '' });
    if (aDetail.group === 'true') {
      $("tr[class='nonGroup']").hide();
      $("tr[class='cGroup']").show();
      $("tr[class='nonGroup']").disable();
      $("tr[class='cGroup']").enable();
      $("#lianxu").hide();
    } else {
      $("tr[class='nonGroup']").show();
      $("tr[class='cGroup']").hide();
      $("tr[class='cGroup']").disable();
      $("tr[class='nonGroup']").enable();
    }
    //单位可见
    dealAccess(aDetail);
    //ldap/ad
    if('true' == $("#isLdapEnabled").val()) {
      $("#ldapSet").show();
    } else {
      $("#ldapSet").hide();
    }
    //单位管理员框
    $("#adminName").attr("readonly", "readonly");
    $("#adminPasswordtr").hide();
    $("#validatepasswordtr").hide();
    $("#pswpromotetr").hide();
    //单位登录页选项回写
    if(aDetail.customLogin == 'true') {
      $("input[name='isCustomLoginUrl'][value='true']").attr("checked", "checked");
      $("#customLoginUrlTr").show();
      $("#customLoginUrlDescTr").show();
      $("#customLoginUrl").val(aDetail.customLoginUrl);
    } else {
      $("input[name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
      $("#customLoginUrlTr").hide();
      $("#customLoginUrlDescTr").hide();
    }
  }
  //删除单位
  function delAccount() {
    var accoutIds = new Array();
    if ($("#id").val() === '-1730833917365171641') {
      $.alert("${ctp:i18n('account.group.not.delete')}");
      return;
    } else if ($("#id").val() !== "-1") {
      $.confirm({
        title: "${ctp:i18n('common.prompt')}",
        msg: "${ctp:i18n('account.delete.ok.manager')}",
        ok_fn: function() {
          accoutIds.push($("#id").val());
          aManager.delAccounts(accoutIds, {
            success: function() {
              $.messageBox({
                id: 'delOKBox',
                title: "${ctp:i18n('common.prompt')}",
                type: 0,
                imgType:0,
                msg: "${ctp:i18n('organization.ok')}",
                ok_fn: function() {
                  location.reload();
                }
              });
            }
          });
        }
      });
    } else {
      var boxs = $("#unitTable input:checked");
      if (boxs.length === 0) {
        $.alert("${ctp:i18n('account.group.choose.delete')}");
        return;
      } else {
        var isG = false;
        boxs.each(function() {
          if ($(this).val() === '-1730833917365171641') {
            $.alert("${ctp:i18n('account.group.not.delete')}!");
            isG = true;
          } else {
            accoutIds.push($(this).val());
          }
        });
        if(!isG) {
          $.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('account.delete.ok.manager')}",
            ok_fn: function() {
              aManager.delAccounts(accoutIds, {
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
          });
        }
      }
    }
  }
  //add account
  $("#btnok").click(function() {
    if (!($("#accountForm").validate())) return;
    $("#accountForm").resetValidate();
    if ($("#adminPass").val() !== $("#adminPass1").val()) {
      $.messageBox({
        'title': "${ctp:i18n('common.prompt')}",
        'type': 0,
        'imgType': 2,
        'msg': "${ctp:i18n('account.system.newpassword.again.not.consistent')}"
      });
      $("#adminPass").val("");
      $("#adminPass1").val("");
      $("#adminPass").focus();
      return;
    }
    if(!checkCustomLoginUrl()) {//5.1新属性如果开启自定义登录页，则为必填项
      return;
    }
    if('true' == "${isLdapEnabled}") {
      if($("#ldapOu").val() == '') {
        $.alert("${ctp:i18n('org.alert.ldapOUNotNull')}");
        return;
      }
    }
    if ($("#id").val() === '-1') {
      if("checked" === $("#copyGroupLevel").attr("checked")) {
        $("#isCopyGroupLevel").val("1");
      } else {
        $("#isCopyGroupLevel").val("0");
      }
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      aManager.createAcc($("#accountForm").formobj(), {
        success: function(accBean) { 
          $("#id").val(accBean);
          if ($("#conti").attr("checked") === "checked") {
            newAccount4conti();
            $("#unitTree").treeObj().reAsyncChildNodes(null,"refresh",false);
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
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
    } else {
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      aManager.updateAcc($("#accountForm").formobj(), {
        success: function(accBean) {
          $("#id").val(accBean);
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              if($("#id").val() == "-1730833917365171641") {
                getCtpTop().refreshAccountName($("#gshortName").val(),$("#secondName").val());//OA-22912
              }
              location.reload();
            }
          });
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
    }
  });
  //取消按钮
  $("#btncancel").click(function() {
    $("#form_area").clearform();
    location.reload();
  });

  $("#table_area").show();
  $("#form_area").hide();

  $("#checkManager").click(function() {
    //单位管理员框
    if ($("#checkManager").attr("checked") === "checked") {
      $("#adminName").removeAttr("readonly");
      $("#adminPasswordtr").show();
      $("#validatepasswordtr").show();
      $("#pswpromotetr").show();
      $("#pswchecktr").show();
      $("#checkManager").val("1");
      $("#adminPass").val("");
      $("#adminPass1").val("");
    } else {
      //单位管理员框
      $("#adminName").attr("readonly", "readonly");
      $("#adminPasswordtr").hide();
      $("#validatepasswordtr").hide();
      $("#pswpromotetr").hide();
      $("#pswchecktr").show();
      $("#checkManager").val("0");
      $("#adminPass").val("~`@%^*#?");
      $("#adminPass1").val("~`@%^*#?");
    }
  });

  function editDetail(accountId) {
    if (accountId === '-1') { //点击根显示列表
      $("#table_area").show();
      $("#form_area").hide();
      var o = new Object();
      $("#unitTable").ajaxgridLoad(o);
      $("#id").val("-1");
      $("#orgAccountId").val("-1");
      $("#path").val("-1");
    } else {
      var aDetail = aManager.viewAccount(accountId);
      $("#form_area").clearform();
      $("#sortIdtype1").attr("checked", "checked");
      $("#accountForm").enable();
      $("#table_area").hide();
      $("#button_area").show();
      $("#form_area").show();
      $("#form_area").fillform(aDetail);
      showPermission(aDetail);
      if(aDetail.enabled == true || aDetail.enabled == 'true') {
        $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
      } else {
        $("input[type='radio'][name='enabled'][value='false']").attr("checked", "checked");
      }
      $("#superiorName").comp({
        value: 'Account|' + aDetail["superior"],
        text: aDetail['superiorName'],
        excludeElements: "Account|" + aDetail.id
      });

      $("#sortIdtype1").attr("checked", "checked");
      $("#checkManager").removeAttr("checked");
      $("#pswchecktr").show();
      
      $("#range").comp({value: '',text: ''});
      $("#copyGL").hide();
      $("#lianxu").hide();
      //ldap/ad
      if('true' == $("#isLdapEnabled").val()) {
        $("#ldapSet").show();
      } else {
        $("#ldapSet").hide();
      }
      if (aDetail.group === 'true') {
        $("tr[class='nonGroup']").hide();
        $("tr[class='cGroup']").show();
        $("tr[class='nonGroup']").disable();
        $("tr[class='cGroup']").enable();
      } else {
        $("tr[class='nonGroup']").show();
        $("tr[class='cGroup']").hide();
        $("tr[class='cGroup']").disable();
        $("tr[class='nonGroup']").enable();
      }
      dealAccess(aDetail); //单位访问权限回写
      //单位管理员框
      $("#adminName").attr("readonly", "readonly");
      $("#adminPasswordtr").hide();
      $("#validatepasswordtr").hide();
      $("#pswpromotetr").hide();
      //单位登录页选项回写
      if(aDetail.customLogin == 'true') {
        $("input[name='isCustomLoginUrl'][value='true']").attr("checked", "checked");
        $("#customLoginUrlTr").show();
        $("#customLoginUrlDescTr").show();
        $("#customLoginUrl").val(aDetail.customLoginUrl);
      } else {
        $("input[name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
        $("#customLoginUrlTr").hide();
        $("#customLoginUrlDescTr").hide();
      }
    }
  }

  //单位自定义登录页
  function checkCustomLoginUrl() {
    if($('input[name="isCustomLoginUrl"]:checked').val() == 'true') {
      var _customLoginUrl = $("#customLoginUrl").val().trim();
      var patten1 = /^[a-z]*$/g;;//英文字母
      var patten2 = /\s+/;//不能有空格
      if(_customLoginUrl == '') {
        $.alert("${ctp:i18n('custom.loginurl.null')}");
        $("#customLoginUrl").focus();
        return false;
      } else if(_customLoginUrl.length > 20) {
        $.alert("${ctp:i18n('custom.loginurl.tolong')}");
        $("#customLoginUrl").focus();
        return false;
      } else if(!patten1.test(_customLoginUrl)) {
        $.alert("${ctp:i18n('custom.loginurl.nomeng')}");
        $("#customLoginUrl").focus();
        return false;
      } else if(patten2.test(_customLoginUrl)){
        $.alert("${ctp:i18n('custom.loginurl.noblank')}");
        $("#customLoginUrl").focus();
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
  $('input[name="isCustomLoginUrl"]').bind('click',function() {
    dealCustomLogin();
  });

  //搜索框
  var searchobj = $.searchCondition({
    top: 2,
    right: 10,
    searchHandler: function() {
      var s = searchobj.g.getReturnValue();
      $("#table_area").show();
      $("#form_area").hide();
      $("#unitTable").ajaxgridLoad(s);
    },
    conditions: [{
      id: 'search_all',
      name: 'search_all',
      text: "${ctp:i18n('post.all')}",
      value: 'all'
    },
    {
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('org.dept.form.name')}",
      value: 'name'
    },
    {
      id: 'search_shortName',
      name: 'search_shortName',
      type: 'input',
      text: "${ctp:i18n('org.dept.shortened.form.name')}",
      value: 'shortName'
    },
    {
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('org.account_form.code.label')}",
      value: 'code'
    }]
  });

  /******ldap/ad*******/
  //弹出选择目录树的界面
  $("#ldapOu").click(function() {
    var sendResult =  $.dialog({
	      url: "/seeyon/ldap/ldap.do?method=viewOuTree",
      width: "410",
      height: "325",
	      scrollbars: "yes",
	      title: " ",
	      buttons: [{
		    id: "ldapOK",
		    text: "${ctp:i18n('common.button.ok.label')}",
		    handler: function() {
		      var rvalue = sendResult.getReturnValue();
		      if (!rvalue) {
		      	sendResult.close();
      return;
    } else {
			      document.getElementById("ldapOu").value = rvalue;
			    }
		      sendResult.close();
    }
		  }]
	    });
  });
  /********************/

  //单位可见，选中一类其他类后面的选项disable
  $("[name='permissionType']").click(function() {
    var pFlag = $("input[name='permissionType']:radio:checked").val();
    if (0 == pFlag) {
      disRange0();
    } else if (1 == pFlag) {
      disRange1();
    } else {
      disRange2();
    }
  });
});


function viewByName(id) {
  viewOne(id);
}

function dealCustomLogin(){
  var is_CunstomLoginUrl = $('input[name="isCustomLoginUrl"]:checked').val();
  if('true' == is_CunstomLoginUrl || true == is_CunstomLoginUrl) {
    $("#customLoginUrlTr").show();
    $("#customLoginUrlDescTr").show();
    $("input[type='radio'][name='isCustomLoginUrl'][value='true']").attr("checked", "checked");
  } else if('false' == is_CunstomLoginUrl || false == is_CunstomLoginUrl) {
    $("#customLoginUrlTr").hide();
    $("#customLoginUrlDescTr").hide();
    $("input[type='radio'][name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
  }
}

/**显示许可数*/
function showPermission(aDetail) {
  if(aDetail.isGroup) {
    $("#serverPermissionGroup").get(0).innerHTML = aDetail.serverPermission;
    $("#m1PermissionGroup").get(0).innerHTML = aDetail.m1Permission;
    $("#unitRegCounts").get(0).innerHTML = aDetail.unitRegCounts;
  } else {
    $("#serverPermission").get(0).innerHTML = aDetail.serverPermission;
    $("#m1Permission").get(0).innerHTML = aDetail.m1Permission;
  }
}

function viewOne(id) {
  var aDetail = aManager.viewAccount(id);
  
  $("#form_area").clearform();
  $("#form_area").show();
  $("#button_area").hide();
  $("#table_area").hide();
  $("#sortIdtype1").attr("checked", "checked");
  $("#checkManager").removeAttr("checked");
  $("#form_area").fillform(aDetail);
  showPermission(aDetail);
  if(aDetail.enabled == true || aDetail.enabled == 'true') {
    $("input[type='radio'][name='enabled'][value='true']").attr("checked", "checked");
  } else {
    $("input[type='radio'][name='enabled'][value='false']").attr("checked", "checked");
  }
  if (aDetail.group === 'true') {
    $("tr[class='nonGroup']").hide();
    $("tr[class='cGroup']").show();
  } else {
    $("tr[class='nonGroup']").show();
    $("tr[class='cGroup']").hide();
    //上级单位回写
    $("#superiorName").comp({
      value: 'Account|' + aDetail["superior"],
      text: aDetail['superiorName'],
      excludeElements: parseElements('Account|' + aDetail.id)
    });
    $("#adminPasswordtr").hide();
    $("#validatepasswordtr").hide();
    $("#pswpromotetr").hide();
    $("#orgAccountId").val(id);
    $("#range").comp({value: '',text: ''});
    dealAccess(aDetail); //单位访问权限回写
    //单位登录页选项回写
    if(aDetail.customLogin == 'true') {
      $("input[name='isCustomLoginUrl'][value='true']").attr("checked", "checked");
      $("#customLoginUrlTr").show();
      $("#customLoginUrlDescTr").show();
      $("#customLoginUrl").val(aDetail.customLoginUrl);
    } else {
      $("input[name='isCustomLoginUrl'][value='false']").attr("checked", "checked");
      $("#customLoginUrlTr").hide();
      $("#customLoginUrlDescTr").hide();
    }
  }
  //ldap/ad
  if('true' == $("#isLdapEnabled").val()) {
    $("#ldapSet").show();
  } else {
    $("#ldapSet").hide();
  }
  $("#accountForm").disable();
}
//用于回写单位分级设置的分级选中的方法
function dealAccess(aDetail) {
  var permisson = $("input[type='radio'][name='permissionType']");
  permisson.each(function() {
    if (aDetail.permissionType == $(this).val()) $(this).attr("checked", "checked");
  });
  if (0 == aDetail.permissionType) {
    disRange0();
    //统一设置
    if (aDetail.isCanAccess) {
      $("#pType").val("1");
    } else {
      $("#pType").val("0");
    }
  } else if (1 == aDetail.permissionType) {
    disRange1();
    //分级设置
    if ('1' == aDetail.sLevel) {
      $("#sLevel").attr("checked", "checked");
    }
    if ('1' == aDetail.pLevel) {
      $("#pLevel").attr("checked", "checked");
    }
    if ('1' == aDetail.xLevel) {
      $("#xLevel").attr("checked", "checked");
    }
  } else {
    disRange2();
    //自由设置
    if (aDetail.isCanAccess) {
      $("#rangType").val("1");
    } else {
      $("#rangType").val("0");
    }
    $("#range").comp({
      value: aDetail.strValueId,
      text: aDetail.strValueName
    });
  }
}

function disRange0() {
  $("#pType").enable();
  $("#pType").val("1");
  $("#sLevel").disable();
  $("#pLevel").disable();
  $("#xLevel").disable();
  $("#rangType").disable();
  $("#permissionType4tr").disable();
}
function disRange1() {
  $("#pType").disable();
  $("#sLevel").enable();
  $("#pLevel").enable();
  $("#xLevel").enable();
  $("#rangType").disable();
  $("#permissionType4tr").disable();
}
function disRange2() {
  $("#pType").disable();
  $("#sLevel").disable();
  $("#pLevel").disable();
  $("#xLevel").disable();
  $("#rangType").enable();
  $("#rangType").val("1");
  $("#permissionType4tr").enable();
}
</script>