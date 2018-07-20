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
<script type="text/javascript" src="${path}/ajax.do?managerName=edocStatSetManager,memberManager,iOManager,orgManager,roleManager"></script>
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
  var mManager = new edocStatSetManager();
  var oManager = new orgManager();
  var imanager = new iOManager();
  var rManager = new roleManager();
  $("tr[class='forInter']").show();
  $("tr[class='forOuter']").hide();
  $("#button_area").hide();
  //列表
  grid = $("#statTable").ajaxgrid({
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
        display: "${ctp:i18n('hr.nameList.number.label')}",
        name: 'orderNo',
        sortable: true,
        width: '10%'
      },
    {
      display: "${ctp:i18n('addressbook.team_form.name.label')}",
      name: 'name',
      sortable: true,
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.member_form.countArea.label')}",
      name: 'deptNames',
      sortable: true,
      width: '35%'
    },
    {
        display: "${ctp:i18n('mt.mtSummaryTemplate.usedFlag')}",
        sortable: true,
        name: 'state',
        width: '10%'
    },
    {
      display: "${ctp:i18n('addressbook.category_form.memo.label')}",
      name: 'comments',
      sortable: true,
      width: '25%'
    }
   ],
    managerName: "edocStatSetManager",
    managerMethod: "findEdocStatListByAccount",
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
    if (c == 4) {
      if (txt == '1') {
        return '停用';
      } else {
        return '启用';
      }
    }else return txt; 
  }
  //第一次加载表格，只加载单位内启用的人员
  filter = new Object();
  $("#statTable").ajaxgridLoad(filter);
  //部门树
  $("#deptTree").tree({
    idKey: "id",
    pIdKey: "parentId",
    nameKey: "name",
    onClick: showStatByCategroy,
    nodeHandler: function(n) {
      if (n.data.parentId == n.data.id) {
        n.open = true;
      } else {
        n.open = false;
      }
    }
  });
  var treeObj = $.fn.zTree.getZTreeObj("deptTree");
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
      click: editStat
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 delete del_16",
      click: delMembers
    }]
  });
 

  //区分集团版企业版隐藏人员调出按钮
  if ("${isGroupVer}" == "false" || "${isGroupVer}" == false) {
    toolBarVar.hideBtn("cancelMemberBtn");
  }
  
  //查看人员信息
  function viewDetail(data) {
    grid.grid.resizeGridUpDown('middle');
    $("#form_area").clearform();
    $("#form_area").show();
    $("#welcome").hide();
    showEditArea(data.parentId);
    $("#form_area").resetValidate();
    $("#name").val(data.name);
    $("#orderNo").val(data.orderNo);
    $("#statNodePolicy").val(data.statNodePolicy); 
    $("#recNodePolicy").val(data.recNodePolicy); 
    $("#deptNames").val(data.deptNames); 
    $("#state").val(data.state); 
    $("#initState").val(data.initState); 
    $("input[name='state'][value="+data.state+"]").attr('checked','true')
    $("#comments").val(data.comments);
    initCheckBoxData(data.timeType,"timeType");
    initCheckBoxData(data.govType,"govType");
    $("#button_area").hide();
    $('#sssssssss').height($('#grid_detail').height()).css('overflow', 'auto');
    $("#memberForm").disable();
  }
  function initCheckBoxData(data,type){
	  if(data == null) return ;
	  var dArr = data.split(",")
	  if(dArr.length > 0){
		  for (var i in dArr) {
			  var value = dArr[i];
			  if(value != ""){
				if(type =="timeType"){
			      $("input[name='timeType"+value+"']").attr('checked','true');
				}else{
				  $("input[name='govType"+value+"']").attr('checked','true');
				}
			  }
		  }
      }
	  
  }
  //用于控制编辑区域显示
  function showEditArea(cateId){
	   //签收统计
	   if(cateId == 2){
		   $("#twoAuth").hide();
		   $("#explain").hide();
		   $("#sendAuth").hide();
		   $("#recAuth").hide();
		   $("#timeSection").show();
		   $("#sendCateory").hide();
		   $("#recCateory").hide();
		   $("#countCateory").hide();
		   $("#dpetLable").text("统计范围");
	   }else{ //工作统计
		   $("#twoAuth").show();
		   $("#explain").show();
		   $("#sendAuth").show();
		   $("#recAuth").show();
		   $("#timeSection").hide();
		   $("#sendCateory").show();
		   $("#recCateory").show();
		   $("#countCateory").show();
		   $("#dpetLable").text("统计范围");
	   }
  }
 
  //表格单击事件
  function clickGrid(data, r, c) {
    viewDetail(data);
  }

  //表格双击事件
  function dblclkGrid(data, r, c) {
    var mDetail = new Object();
    $("#memberForm").enable();
    $("#button_area").show();
    $("#form_area").show();
    $("#welcome").hide();
    $("#parentId").val(data.parentId);
    showEditArea(data.parentId);
    $("#id").val(data.id);
    $("#name").attr("readonly","false");
    $("#name").val(data.name);
    $("#orderNo").val(data.orderNo);
    $("#name").attr("readonly","false");
    $("#statNodePolicy").val(data.statNodePolicy); 
    $("#deptNames").val(data.deptNames); 
    $("#state").val(data.state); 
    $("input[name='state'][value="+data.state+"]").attr('checked','true')
    $("#comments").val(data.comments);   
    initCheckBoxData(data.timeType,"timeType");
    initCheckBoxData(data.govType,"govType");
    $("#memberForm").resetValidate();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }
  
  function newMember() {
	if($("#parentId").val()==-1){
		alert("请先选择新建类型，再点击新建");
		return;
	}
    grid.grid.resizeGridUpDown('middle');
    $("#memberForm").clearform();
    $("#id").val("-1");
    $("#deptIds").val("-1");
    $("#recNode").val("");
    $("#sendNode").val("");
    $("#form_area").show();
    $("#welcome").hide();
    
    showEditArea($("#parentId").val());
    $("#memberForm").enable();
    $("#button_area").show();
    $("#button_area").enable();
    $("#btnArea").show();
    $("#btnArea").enable();
    $("input[name='state'][value=0]").attr('checked','true')
    //新建时屏蔽显示兼职的信息框
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
  }

  //点击部门树某一部门展现某部门的人员
  function showStatByCategroy(e, treeId, node) {
	filter = new Object();
  	isSearch=false;
    grid.grid.resizeGridUpDown('down');
    $("#welcome").show();
    $("#form_area").hide();
    $("#button_area").hide();
 /*    if (node.parentId === 0) {
      preDeptId = '';
      preDeptName = '';
      $("#parentId").val("-1");
      filter.parentId = null;
      $("#statTable").ajaxgridLoad(filter);
    } else { */
      //var o2 = new Object();
    //初始化分页数据
      $("input.common_over_page_txtbox").val("1");
      $("#rpInputChange").val("20");
      filter.parentId = node.id;
      $("#statTable")[0].p.newp=1;
      $("#statTable")[0].p.rp=20;
      $("#statTable").ajaxgridLoad(filter);
      preDeptId = node.id;
      $("#parentId").val(node.id);
      preDeptName = node.name;
    /* } */
  }

  function delMembers() {
      var boxs = $("#statTable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('department.choose.data.delete')}");
          return;
      } else {
    	  var members = new Array();
          boxs.each(function() {
            members.push($(this).val());
          });
          mManager.checkStat(members, {
              success: function(re) {
            	  if(re == true){
            		  $.messageBox({
 	                      'title': "${ctp:i18n('common.prompt')}",
 	                      'type': 0,
 	                      'imgType':0,
 	                      'msg':'预置数据不能删除',
 	                       ok_fn: function() {
 	                         	                    	
 	                      }
 	                  });
              	  }else{
              		  var confirm = $.confirm({
          	            'title': "${ctp:i18n('common.prompt')}",
          	            'msg': "${ctp:i18n('org.member_form.choose.member.delete')}",
          	            ok_fn: function() {     
          	                mManager.deleteStat(members, {
          	                  success: function(re) {
          	                	var noticeStr = "${ctp:i18n('organization.ok')}";
          	                	
          	                    $.messageBox({
          	                      'title': "${ctp:i18n('common.prompt')}",
          	                      'type': 0,
          	                      'imgType':0,
          	                      'msg':noticeStr,
          	                      ok_fn: function() {
          	                        
          	                        /*  location.reload(); */
          	                    	 filter = new Object();
          	                         filter.parentId =$("#parentId").val();
          	                         $("#statTable").ajaxgridLoad(filter);      
          	                         grid.grid.resizeGridUpDown('down');
          	                         getCount();
          	                         $("#form_area").hide();
          	                         $("#button_area").hide();
          	                         $("#welcome").show();
          	                         treeObj.expandAll(false);
          	                    	
          	                      }
          	                    });
          	                  }
          	                });
          	              
          	            },
          	            cancel_fn: function() {
          					var filter = new Object();
          	            	if($("#parentId").val()!=-1){
          	            	filter.parentId =$("#parentId").val();
          	            	}
          	            	$("#statTable").ajaxgridLoad(filter);
          				}
          	          });
                	 
              	  }  
              }
          });
        
      }
  }

  //人员修改
  function editStat() {
    var boxs = $("#statTable input:checked");
    if (boxs.length === 0) {
      $.alert("${ctp:i18n('department.choose.data.edit')}");
      return;
    } else if (boxs.length > 1) {
      $.alert("${ctp:i18n('org.member_form.choose.personnel.one.edit')}");
      return;
    } else {
      grid.grid.resizeGridUpDown('middle');
      $("#form_area").clearform();
      var mDetail = mManager.viewOne(boxs[0].value);    
      $("input[name='state'][value="+mDetail.state+"]").attr('checked','true')
      initCheckBoxData(mDetail.timeType,"timeType");
      initCheckBoxData(mDetail.govType,"govType");    
      $("#memberForm").fillform(mDetail);  
      showEditArea(mDetail.parentId);
      $("#button_area").show();
      $("#form_area").show();
      $("#welcome").hide();
      $("#memberForm").enable();
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
      $("#statTable").ajaxgridLoad(s);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('addressbook.team_form.name.label')}",
      value: 'name',
      maxLength:40
    },
    {
      id: 'search_department',
      name: 'search_department',
      type: 'selectPeople',
      text: "统计范围",
      value: 'deptNames',
      comp: "type:'selectPeople',selectType:'Account,Department',panels:'Account,Department',onlyLoginAccount: false"
    }]
  });
  //绑定选人界面区域
  //部门
  $("#deptNames").click(function() {
	var showSelectPanels = "";
	var sfLogin = false;
	var  showSelectTypes='Account,Department';
	if($("#parentId").val()==2){
	    showSelectPanels='Account,Department';
	    sfLogin = false;
	}else{
		showSelectPanels='Department';
		 sfLogin = true;
	}
    $.selectPeople({
      panels: showSelectPanels,
      selectType: showSelectTypes,
      minSize: 1,
      maxSize: 1000,
      params:{
          value: $("#memberForm #deptIds").val()
      },
      onlyLoginAccount: sfLogin,
      hiddenPostOfDepartment:true,
      hiddenRoleOfDepartment:true,
      isCheckInclusionRelations:sfLogin,
      isAllowContainsChildDept:sfLogin,
      returnValueNeedType: false,
      callback: function(ret) {
    	  var myArray=new Array()
    	  myArray = ret.obj;
    	  var values = "";
    	  var isChoseRootUnit = 0;
    	  for(var i=0;i<myArray.length;i++){
    		  if(myArray[i].id==="-1730833917365171641"){
    			  isChoseRootUnit = 1;
    		  }
    		  if(i == myArray.length-1){
    			  values = values+ myArray[i].type+"|"+myArray[i].id;  
    		  }else{
    		      values = values+ myArray[i].type+"|"+myArray[i].id+",";
    		  }
    	 }
    	 if(isChoseRootUnit==1&&myArray.length>1){
    		 alert("选择了一级单位就不能再选择其它单位或部门,请重新选择");
    		 $("#deptNames").val("");
             $("#memberForm #deptIds").val("");
    	 }else{
          $("#deptNames").val(ret.text);
          $("#memberForm #deptIds").val(values);
          $("#memberForm").resetValidate();
    	 }
      }
    });
  });
  //判断复选框是否选中
  function checkBoxChooseCount(){
	  var checkboxCount = 0;
	  var reStr = "";
	  if($("#parentId").val()==2){//签收统计
	    	$("input[name^='timeType']").each(function (i) {
	    		if($(this).attr('checked')=="checked"){
	    			checkboxCount++;
	    		}
	    	});
	        if(checkboxCount<=0){
	        	reStr ="请选择统计的时间段";
	        }
	 }else{//工作统计
		 $("input[name^='govType']").each(function (i) {
	    		if($(this).attr('checked')=="checked"){
	    			checkboxCount++;
	    		}
	     });
		 if(checkboxCount<=0){
	        	reStr ="请选择统计的类别";
	      }
	 }
	 return reStr;
  }
  // 表单JSON无分区无分组提交事件
  $("#btnok").click(function() {
	  $(".error-title").removeClass("error-title");
	  $("div.error-form").each(function(){
		  $(this).removeClass("error-form");
		  $(this).removeData("errorIcon");
	  });
	 var reStr = checkBoxChooseCount();
    //输入正确性校验
    if(!($("#memberForm").validate())){
        $("#button_area").enable();
        return;
    }
    if(reStr != ""){
    	alert(reStr);
    	return;
    }
    $("#memberForm").resetValidate();
    if ($("#id").val() === '-1') {
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      mManager.createState($("#memberForm").formobj(), {
        success: function() {
            $.messageBox({
              'title': "${ctp:i18n('common.prompt')}",
              'type': 0,
              'imgType':0,
              'msg': "${ctp:i18n('organization.ok')}",
              ok_fn: function() {
                filter = new Object();
                filter.parentId =$("#parentId").val();
                $("#statTable").ajaxgridLoad(filter);
                grid.grid.resizeGridUpDown('down');
                getCount();
                $("#form_area").hide();
                $("#button_area").hide();
                $("#welcome").show();
                treeObj.expandAll(false);
              }
            });
            try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
    } else {
      if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
      mManager.updateState($("#memberForm").formobj(), {
        success: function() {
          $.messageBox({
            'title': "${ctp:i18n('common.prompt')}",
            'type': 0,
            'imgType':0,
            'msg': "${ctp:i18n('organization.ok')}",
            ok_fn: function() {
              filter = new Object();
              filter.parentId =$("#parentId").val();
              $("#statTable").ajaxgridLoad(filter);      
              grid.grid.resizeGridUpDown('down');
              getCount();
              $("#form_area").hide();
              $("#button_area").hide();
              $("#welcome").show();
              treeObj.expandAll(false);
            }
          });
          try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
        }
      });
      
    }
  });
  $("#statNodePolicy").click(function() {
	  selectEdocFromFlowPerm(0);
  });
  $("#recNodePolicy").click(function() {
	  selectEdocFromFlowPerm(1);
  });
  function selectEdocFromFlowPerm(type){
	  	var url="/seeyon/edocController.do?method=mtechEdocFromFlowPermFrame&type="+type;
	  	if(type == 0){
	  		url+="&node="+$('#sendNode').val();
	  	}else if(type == 1){
	  		url+="&node="+$('#recNode').val();
	  	}
		var ret = v3x.openWindow({
	        url: url,
	        height:518,
	        width:628
	    });
		if(typeof(ret) != 'undefined' && ret != null){ 			
		   if(type==0){
			   $("#sendNode").val(ret[0]);
			   $("#statNodePolicy").val(ret[1]);
			   
		   }else{
			   $("#recNode").val(ret[0]);
			   $("#recNodePolicy").val(ret[1]);
			   $("#memberForm").resetValidate();
		   }
		}
		
  }
  $("#btncancel").click(function() {
    location.reload();
  });
  $('#grid_detail').resize(function(){
    if ($("#button_area").is(":hidden")) {
      $('#sssssssss').height($(this).height() - 0).css('overflow', 'auto');
    } else {
      $('#sssssssss').height($(this).height() - 38).css('overflow', 'auto');
    }
  });
  //发送checkBox联动
  $("#sendDiv input[type='checkbox']").click(function() {
	  var cName = $(this).attr("name");
	  var countCheck = 0;
	  $("#sendDiv input[type='checkbox']").each(function(){
		  if($(this).attr("name")!='govType1'&&!$(this).attr("checked")){
			  countCheck+=1;
		  }
	  });
	 
	  //发文点击
	  if($(this).attr("checked")&&cName=='govType1') {
			  $("input[name=govType2]").attr("checked","true");
			  $("input[name=govType3]").attr("checked","true"); 
			  $("input[name=govType4]").attr("checked","true"); 
			  $("input[name=govType5]").attr("checked","true"); 
			  $("input[name=govType6]").attr("checked","true"); 			  
			  $("input[name=govType7]").attr("checked","true"); 
			  $("input[name=govType8]").attr("checked","true"); 
	 }else if(!$(this).attr("checked")&&cName=='govType1'){
			  $("input[name=govType2]").removeAttr("checked"); 
			  $("input[name=govType3]").removeAttr("checked"); 
			  $("input[name=govType4]").removeAttr("checked"); 
			  $("input[name=govType5]").removeAttr("checked"); 
			  $("input[name=govType6]").removeAttr("checked"); 			  
			  $("input[name=govType7]").removeAttr("checked"); 
			  $("input[name=govType8]").removeAttr("checked"); 
    }
  	if(countCheck ==7&&cName!='govType1'){
	  $("input[name=govType1]").removeAttr("checked"); 
 	 }
	//其它点击
	if(cName !='govType1'&&$(this).attr("checked")){
		 $("input[name=govType1]").attr("checked","true");
	}
  });
  //收文联动效果
  $("#recDiv input[type='checkbox']").click(function() {
	  var cName = $(this).attr("name");
	  var countCheck = 0;
	  $("#recDiv input[type='checkbox']").each(function(){
		  if($(this).attr("name")!='govType9'&&!$(this).attr("checked")){
			  countCheck+=1;
		  }
	  });
	 
	  //发文点击
	  if($(this).attr("checked")&&cName=='govType9') {
			  $("input[name=govType10]").attr("checked","true");
			  $("input[name=govType11]").attr("checked","true"); 
			  $("input[name=govType12]").attr("checked","true"); 
			  $("input[name=govType13]").attr("checked","true"); 
			  $("input[name=govType14]").attr("checked","true"); 			  
			  $("input[name=govType15]").attr("checked","true"); 
	 }else if(!$(this).attr("checked")&&cName=='govType9'){
			  $("input[name=govType10]").removeAttr("checked"); 
			  $("input[name=govType11]").removeAttr("checked"); 
			  $("input[name=govType12]").removeAttr("checked"); 
			  $("input[name=govType13]").removeAttr("checked"); 
			  $("input[name=govType14]").removeAttr("checked"); 			  
			  $("input[name=govType15]").removeAttr("checked"); 
    }
  	if(countCheck ==6&&cName!='govType9'){
	  $("input[name=govType9]").removeAttr("checked"); 
 	 }
	//其它点击
	if(cName !='govType9'&&$(this).attr("checked")){
		 $("input[name=govType9]").attr("checked","true");
	}
  });
  //总计联动效果
  $("#allDiv input[type='checkbox']").click(function() {
	  var cName = $(this).attr("name");
	  var countCheck = 0;
	  $("#allDiv input[type='checkbox']").each(function(){
		  if($(this).attr("name")!='govType16'&&!$(this).attr("checked")){
			  countCheck+=1;
		  }
	  });
	 
	  //发文点击
	  if($(this).attr("checked")&&cName=='govType16') {
			  $("input[name=govType17]").attr("checked","true");
			  $("input[name=govType18]").attr("checked","true"); 
			  $("input[name=govType19]").attr("checked","true"); 
			  $("input[name=govType20]").attr("checked","true"); 
			  $("input[name=govType21]").attr("checked","true"); 			  
			  $("input[name=govType22]").attr("checked","true"); 
	 }else if(!$(this).attr("checked")&&cName=='govType16'){
			  $("input[name=govType17]").removeAttr("checked"); 
			  $("input[name=govType18]").removeAttr("checked"); 
			  $("input[name=govType19]").removeAttr("checked"); 
			  $("input[name=govType20]").removeAttr("checked"); 
			  $("input[name=govType21]").removeAttr("checked"); 			  
			  $("input[name=govType22]").removeAttr("checked"); 
    }
  	if(countCheck ==6&&cName!='govType16'){
	  $("input[name=govType16]").removeAttr("checked"); 
 	 }
	//其它点击
	if(cName !='govType16'&&$(this).attr("checked")){
		 $("input[name=govType16]").attr("checked","true");
	}
  });
});

var dialogDealColl;
function showInstruction() {
	var url = "${path}/edocStatNew.do?method=showInstruction";	
  	var width = 780;
  	var height =381;
  	dialogDealColl = $.dialog({
        url: url,
        width: width,
        height: height,
        title: '统计条件说明',
        id:'dialogDealColl',
        targetWindow:getCtpTop(),
        transParams: {'parentWin':window},
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function(){
        	  dialogDealColl.close();
          }
        }        
    });
}

</script>