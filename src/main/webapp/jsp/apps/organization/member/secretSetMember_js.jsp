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
<script type="text/javascript">
var orgAccountId = "";
$(document).ready(function(){
    var searchobj = $.searchCondition({
        top:6,
        right:10,
        searchHandler: function(){
    	var inputValue = searchobj.g.getReturnValue();
    	var searchValue = inputValue.value;
    	var oDept = new Object();
    	if(orgAccountId.length != 0){
    	oDept.orgAccountId = orgAccountId;//传递的部门accountId
    	}
    		oDept.memberName = searchValue;//传递的部门accountId
	  $("#memberTable").ajaxgridLoad(oDept);
        },
        conditions: [{
            id: 'title',//查询条件生成input/select/data的id
            name: 'title',//查询条件生成input/select/data的name
            type: 'input',//类型: [input:输入框] [select:下拉选择] [datemulti:时间段]
            text: '姓名',//查询条件名称
            value: 'name'//查询条件value
        }]
    });
    //设置默认值
  //  searchobj.g.setCondition("title","aaaaa");
});

</script>
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
  var app = '${app}';
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
  if(app == '2'){

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
      width: '24%'
    },
    {
      display: "${ctp:i18n('org.member_form.levelName.label')}",
      name: 'levelName',
      sortable: true,
      width: '8%'
    }
    ,
    {
        display: "${ctp:i18n('org.member.roles')}",
        sortable: true,
        codecfg: "codeId:'org_property_member_state'",
        name: 'showName',
        width: '75%'
      }],
    managerName: "memberManager",
    managerMethod: "getAllMemberList",
    vChange: false,
    render: rend,
    vChangeParam: {
      overflow: "hidden",
      position: 'relative'
    },
    slideToggleBtn: false,
    //parentId:'center',
    height:$(document).height()-100,
    showTableToggleBtn: true,
    callBackTotle:getCount
  });}else{

	  grid = $("#memberTable").ajaxgrid({
		    colModel: [{
		      display: 'id',
		      name: 'id',
		      width: '6%',
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
		      width: '20%'
		    },
		    {
		      display: "${ctp:i18n('org.member_form.levelName.label')}",
		      name: 'levelName',
		      sortable: true,
		      width: '14%'
		    }
		    ,
		    {
		      display: "${ctp:i18n('org.member_form.primaryPost.label')}",
		      name: 'postName',
		      sortable: true,
		      width: '20%'
		    },
		    {
		      display: "${ctp:i18n('org.metadata.member_type.label')}",
		      sortable: true,
		      codecfg: "codeId:'org_property_member_type'",
		      name: 'typeName',
		      width: '15%'
		    },
		    {
		      display: "${ctp:i18n('secret.user.set.secret')}",
		      sortable: true,
		      codecfg: "codeId:'org_property_member_state'",
		      name: 'secretlevel',
		      width: '16%'
		    }],
		    managerName: "memberManager",
		    managerMethod: "getAllMemberList",
		    vChange: false,
		    render: rend,
		    vChangeParam: {
		      overflow: "hidden",
		      position: 'relative'
		    },
		    slideToggleBtn: false,
		    //parentId:'center',
		    height:$(document).height()-100,
		    showTableToggleBtn: true,
		    callBackTotle:getCount
		  });

	  }
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

 $("#unitTree").tree({
    idKey: "id",
    pIdKey: "parentId",
    nameKey: "name",
    onClick: clk,
    enableAsync : true,
    managerName : "memberManager",
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
	  var oDept = new Object();
	  orgAccountId = node.id;
	  oDept.orgAccountId = node.id;//传递的部门accountId
	  $("#memberTable").ajaxgridLoad(oDept);
 }



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