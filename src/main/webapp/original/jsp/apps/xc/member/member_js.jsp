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
<script type="text/javascript" src="${path}/ajax.do?managerName=memberManager,iOManager,orgManager,roleManager,xcmemberManager,xcSynManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=ldapBindingMgr"></script>
<script type="text/javascript" language="javascript">
//var html = "<span class='nowLocation_ico'><img src='/seeyon/main/skin/frame/harmony/menuIcon/personal.png'></img></span><span class='nowLocation_content'>携程集成配置 > 授权人及子账户同步</span>";
  //   getCtpTop().showLocation(html);
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
  var xcmManager = new xcmemberManager();
  var mManager = new memberManager();
  var oManager = new orgManager();
  var imanager = new iOManager();
  var rManager = new roleManager();
  var xcManager = new xcSynManager();
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
    },{
      display: "${ctp:i18n('xc.syn.confirmPerson')}",
      sortable: true,
      name: 'certigierName',
      width: '8%'
    },
    {
      display: "${ctp:i18n('xc.syn.confirmPersonEmail')}",
      sortable: true,
      name: 'certigierEmail',
      width: '25%'
    },
	{
      display: "${ctp:i18n('xc.syn.SubAccountName')}",
      sortable: true,
      name: 'subAccountName',
      width: '8%'
    },
	{
      display: "${ctp:i18n('xc.table.th.3.js')}",
      sortable: true,
      name: 'synState',
      width: '8%'
    }],
    managerName: "xcmemberManager",
    managerMethod: "showByAccount",
    parentId: 'center'
   // vChange: true,
   // render: rend,
   // vChangeParam: {
    //  overflow: "hidden",
     // position: 'relative'
   // },
   // slideToggleBtn: true,
   // showTableToggleBtn: true,
    //callBackTotle:getCount
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
    toolbar: [
	 {
      id: "certigier",
      name: "${ctp:i18n('xc.syn.confirmPersonSet')}",
      className: "ico16 authorize_16",
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
            //isDeptOrManager = xcmManager.checkMember4DeptRole(membersIds);
              dialog4Batch = $.dialog({
                id:"batchDia",
                url: "${path}/xc/member.do?method=syn_Update&isDeptAdmin=false&select=certigier",
                title: "${ctp:i18n('xc.syn.confirmPersonSet')}",
                width: 320,
                height: 330,
                transParams: membersIds,
				buttons: [{
    				text: "${ctp:i18n('common.button.ok.label')}",
    				isEmphasize: true,
    				handler: function() {
						var rv = dialog4Batch.getReturnValue();
						synOK(rv);
					}
				},
    			{
    				text: "${ctp:i18n('common.button.cancel.label')}",
    				handler: function() {
    					dialog4Batch.close();
    				}
    			}]
              });
            //}
          }
        }
    },
		  {
      id: "chilenum",
      name: "${ctp:i18n('xc.syn.SubAccountNameSet')}",
      className: "ico16",
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
            //isDeptOrManager = xcmManager.checkMember4DeptRole(membersIds);
           /* if(isDeptOrManager.deptName.trim() != '') {
                $.alert(isDeptOrManager.deptName+" ${ctp:i18n('member.deptmaster.or.admin.not.batupate')}");
                var temRoles = isDeptOrManager.deptIds.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked",false);
                }
                return false;
            } else {*/
              dialog4Batch = $.dialog({
                id:"batchDia",
                url: "${path}/xc/member.do?method=syn_Update&isDeptAdmin=false&select=childnum",
                title: "${ctp:i18n('xc.syn.SubAccountNameSet')}",
                width: 320,
                height: 330,
                transParams: membersIds,
				buttons: [{
    				text: "${ctp:i18n('common.button.ok.label')}",
    				isEmphasize: true,
    				handler: function() {
						var rv = dialog4Batch.getReturnValue();
						synOK(rv);
					}
				},
    			{
    				text: "${ctp:i18n('common.button.cancel.label')}",
    				handler: function() {
    					dialog4Batch.close();
    				}
    			}]
              });
           // }
          }
        }
    }]
  });

	function synOK(rv){
		var id=rv.certigierId;
		var ids =rv.ids; 
		if(ids.indexOf(id)>-1&&id!=""){
			$.alert("${ctp:i18n('xc.syn.return.5.js')}");//被授权人不能与授权人是同一个人！
			return false;
		}
		if("childnum"==rv.sel){
			if(rv.typeName==null){
				$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
				return ;
			}
		}
		if("certigier"==rv.sel){
			if(rv.certigier==''){
				$.alert("${ctp:i18n('xc.syn.return.4.js')}");//必填项不能为空
				return ;
			}
			var email= xcManager.getEmail(id);
			if(email==''||email==null){
				$.alert("${ctp:i18n('xc.syn.return.6.js')}");//邮箱不能为空
				return false;
			}
		 }
		dialog4Batch.close();
		 try{if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc($.i18n('xc.syn.start.js'));}catch(e){};
		//$("#certigierForm").submit();
		xcManager.synMember(rv.typeName,rv.certigier,rv.ids,rv.certigierId);
		location.reload();
	}


  //区分集团版企业版隐藏人员调出按钮
  var apiKey=$("#apiKey").val();
  if (apiKey!="true") {
    toolBarVar.disabled("certigier");
	toolBarVar.disabled("chilenum");
  }else{
    toolBarVar.enabled("certigier");
	toolBarVar.enabled("chilenum");
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
    var member = xcmManager.viewOne(memberId);

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
              },
              OKFN : function(){
                  member.state = 2;
                  dialog.close();
                  
                  grid.grid.resizeGridUpDown('down');
                  $("#welcome").show();
                  $("#form_area").hide();
                  filter.enabled = true;
                  isSearch = false;
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
            isDeptOrManager = xcmManager.checkMember4DeptRole(membersIds);
            if(isDeptOrManager.deptName.trim() != '') {
                $.alert(isDeptOrManager.deptName+" ${ctp:i18n('member.deptmaster.or.admin.not.operation')}");
                var temRoles = isDeptOrManager.deptIds.split(",");
                for(i=0;i<temRoles.length;i++) {
                    $("input[value='"+temRoles[i]+"']").attr("checked",false);
                }
                return false;
            } else {
              xcmManager.cancelMember(members, {
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

  

 

  //搜索框
  var searchobj = $.searchCondition({
    top: 7,
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
      text: "${ctp:i18n('member.list.find.name')}",//姓名
      value: 'name',
      maxLength:40
    },
    {
      id: 'search_department',
      name: 'search_department',
      type: 'selectPeople',
      text: "${ctp:i18n('import.type.dept')}",//部门
      value: 'orgDepartmentId',
      comp: "type:'selectPeople',panels:'Department',selectType:'Department',maxSize:'1',onlyLoginAccount: true"
    },
    {
      id: 'search_post',
      name: 'search_post',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.primaryPost.label')}",//主岗
      value: 'orgPostId',
      comp: "type:'selectPeople',panels:'Post',selectType:'Post',maxSize:'1',onlyLoginAccount: true"
    },{
      id: 'search_level',
      name: 'search_level',
      type: 'selectPeople',
      text: "${ctp:i18n('org.member_form.levelName.label')}",//职务级别
      value: 'orgLevelId',
      comp: "type:'selectPeople',panels:'Level',selectType:'Level',maxSize:'1',onlyLoginAccount: true"
    },
    {
      id: 'certigier_name',
      name: 'certigierName',
      type: 'input',
      text: "${ctp:i18n('xc.syn.confirmPerson')}",//授权人
      value: 'certigierName',
      maxLength:40
    },{
      id: 'confirmPersonEmail',
      name: 'certigierEmail',
      type: 'input',
      text: "${ctp:i18n('xc.syn.confirmPersonEmail')}",//授权人邮箱
      value: 'certigierEmail',
      maxLength:40
    },{
      id: 'subAccountName',
      name: 'subAccountName',
      type: 'input',
      text: "${ctp:i18n('xc.syn.SubAccountName')}",//子账号
      value: 'subAccountName',
      maxLength:40
    },{
      id: 'sysn_state',
      name: 'synState',
      type: 'select',
      text: "${ctp:i18n('xc.table.th.3.js')}",//同步状态
      value: 'synState',
      maxLength:40,
	  items: [{
	            text: "${ctp:i18n('xc.syn.state.1.js')}",// 成功
	            value: "1"
	        }, {
	            text: "${ctp:i18n('xc.syn.state.2.js')}",//失败
	            value: "2"
	        }]
    }
	]
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
          var tempOne = xcmManager.viewOne($("#id").val());
          if($("#orgDepartmentId").val() != tempOne.orgDepartmentId) {
            $("#roles").val("");
            $("#roleIds").val("");
            var noDeptRoles = xcmManager.noDeptRoles($("#id").val());
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
});
</script>