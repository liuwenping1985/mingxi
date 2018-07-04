<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript">
var accountId = "${accountId}";
var isgroup = ${isGroup};
$().ready(function() {
  var cnt;
  var msg = "${ctp:i18n("info.totally")}";
  var pManager = new teamManager();
  var oManager = new orgManager();
  var memberId = "${v3x:currentUser().id}";
  var fromSection = "${fromSection}";//OA-44664 修改此BUG这里如果是从栏目点进来的自动隐藏面包屑
  if("true"==fromSection || true == fromSection) {
    getCtpTop().hideLocation();
  }
  
  var deptIds="";
	//从部门管理--部门组管理进入，能管理当前部门管理员所管理的所有部门的管理员建立的组
	var deptList = oManager.getDeptsByAdmin(memberId, accountId);
		for(i=0;i<deptList.length;i++){
			if(i==0){
				deptIds = deptList[i]['id'];
			}else{
				deptIds += ","+deptList[i]['id'];
			}
		}
		
  var depts = oManager.getLoginMemberDepartment(accountId);
  $("#mustBelong").hide();
  $("#mustScope").hide();
  if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
	$("#mustBelong").show();
	 if ($('input:radio[name="scope"]:checked').val() == "1") {
		$("#mustScope").show();
	}
    $("#scopein").comp({showDepartmentsOfTree:deptIds});
    $("#ownerId").comp({selectType:'Department',showDepartmentsOfTree:deptIds});//OA-46860
  }
  $("#postform").hide();
  $("welcome").show();
  $("#button").hide();
  function addform() {
    $("#postform").show();
    $("#postform").enable();
    $("#postform").clearform({
      clearHidden: true
    });
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
    $("#conti").attr("checked", 'checked');
    pManager.addTeam(accountId, {
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);
      }
    });
    $("#teamLeader").comp({
      excludeElements: '',
      value: '',
      text: ''
    });
    $("#teamMember").comp({
      excludeElements: '',
      value: '',
      text: ''
    });
    $("#teamSuperVisor").comp({
      excludeElements: '',
      value: '',
      text: ''
    });
    $("#teamRelative").comp({
      excludeElements: '',
      value: '',
      text: ''
    });
    $("input[name=enabled]:eq(0)").attr("checked", 'checked');
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("input[name=scope]:eq(1)").attr("checked", 'checked');
    if (oManager.isDepartmentAdmin()) {
      $("#type").val(2);
    } else {
      $("#type").val(2);
    }
    $("#type").disable();
    $("#scopeout").disable();
    
    $("#mustScope").hide();
    if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
  	 if ($('input:radio[name="scope"]:checked').val() == "1") {
  		$("#mustScope").show();
  	}
    }
	 
    mytable.grid.resizeGridUpDown('middle');
  }

  $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
      }
    },
    {
      id: "modify",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: dbclk
    },
    {
      id: "delete",
      name: "${ctp:i18n('common.button.delete.label')}",
      className: "ico16 del_16",
      click: function() {
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
          $.alert("${ctp:i18n('team.delete')}");
        } else {
          $.confirm({
            'msg': "${ctp:i18n('team.delete.ok')}",
            ok_fn: function() {
              pManager.deleteTeam(v, {
                success: function() {
                  location.reload();
                }
              });
            }
          });
        };
      }
    }]
  });

  var mytable = $("#mytable").ajaxgrid({
    click: gridclk,
    dblclick: dbclk,
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('team.name')}",
      sortable: true,
      name: 'name',
      width: '20%'
    },
    {
      display: "${ctp:i18n('team.sort')}",
      sortable: true,
      name: 'sortId',
      sortType: 'number',
      width: '14%'
    },
    {
      display: "${ctp:i18n('team.charge')}",
      sortable: true,
      name: 'teamLeader',
      width: '14%'
    },
    {
      display: "${ctp:i18n('level.select.state')}",
      sortable: true,
      codecfg: "codeId:'common.enabled'",
      name: 'enable',
      width: '14%'
    },

    {
      display: "${ctp:i18n('team.type')}",
      sortable: true,
      name: 'type',
      width: '14%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.TeamTypeEnum'"
    },
    {
      display: "${ctp:i18n('team.privilege')}",
      sortable: true,
      name: 'scope',
      width: '14%',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.TeamScopeEnum'"
    }],
    managerName: "teamManager",
    managerMethod: "showTeamList",
    parentId: 'center',
    vChangeParam: {
      overflow: "hidden",
      position: 'relative'
    },
    slideToggleBtn: true,
    vChange: true,
    callBackTotle: getCount
  });
  var o = new Object();
  o.accountId = accountId;
  $("#mytable").ajaxgridLoad(o);
  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#button").hide();
    $("#postform").show();
    $("#welcome").hide();
    var postdetil = pManager.viewTeam(data.id);
    $("#addForm").fillform(postdetil);
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    
    $("#postform").disable();
    $("#mustScope").hide();
    if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
  	 if ($('input:radio[name="scope"]:checked').val() == "1") {
  		$("#mustScope").show();
  	}
    }
    $('#sssssssss').height($('#grid_detail').height() - 0).css('overflow', 'auto');
  }
  function dbclk() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('post.chosce.modify')}");
      return;
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
      return;
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mpostdetil = pManager.viewTeam(v[0]["id"]);
      $("#postform").enable();
      $("#postform").clearform({
        clearHidden: true
      });
      $("#postform").show();
      $("#addForm").fillform(mpostdetil);
      $("#teamLeader").comp({
        excludeElements: $("#teamSuperVisor").val() + "," + $("#teamRelative").val() + "," + $("#teamMember").val()
      });
      $("#teamMember").comp({
        excludeElements: "Team|"+v[0]["id"]+","+$("#teamSuperVisor").val() + "," + $("#teamRelative").val() + "," + $("#teamLeader").val()
      });
      $("#teamSuperVisor").comp({
        excludeElements: $("#teamMember").val() + "," + $("#teamRelative").val() + "," + $("#teamLeader").val()
      });
      $("#teamRelative").comp({
        excludeElements: $("#teamMember").val() + "," + $("#teamRelative").val() + "," + $("#teamLeader").val()
      });
      $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
      $("#conti").removeAttr("checked");

      $("#button").show();
      $('#sssssssss').height($('#grid_detail').height() - 38).css('overflow', 'auto');
      $("#lconti").hide();
      $("#welcome").hide();
      $("#type").disable();
      if ($("input[name=scope]:eq(1)").attr("checked")) {
        $("#scopeout").disable();
      }
      $("#mustScope").hide();
      if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
    	 if ($('input:radio[name="scope"]:checked').val() == "1") {
    		$("#mustScope").show();
    	}
      }
    }
  }
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#scope_radio :radio").change(function() {
    if ($('input:radio[name="scope"]:checked').val() == "1") {
      $("#scopeout").enable();
      $("#mustScope").hide();
      if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
    	 if ($('input:radio[name="scope"]:checked').val() == "1") {
    		$("#mustScope").show();
    	}
      }
    } else {
      $("#scopeout").disable();
      $("#mustScope").hide();
      $("#scopein_txt").val("");
      $("#scopein").val("");
    }
  });
  
  
  $("#scopein_txt").click(function() {
      var oid = $("#ownerId").val();
      if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()){
       $.selectPeople({
           params:{value:$("#scopein").val()},
           type: 'selectPeople',
             panels:'Department',
             hiddenPostOfDepartment:true,
             selectType:'Department',
             minSize:0,
             isNeedCheckLevelScope:false,
             onlyLoginAccount:true,
             accountId:'${accountId}',
             showDepartmentsOfTree:deptIds,
              callback: function(ret) {
                  $("#scopein_txt").val(ret.text);
                  $("#scopein").val(ret.value);
              }});
      }else{
      if(isgroup){
        $.selectPeople({
          params:{value:$("#scopein").val()},
          type: 'selectPeople',
            panels:'Account,Department,Post,Level',
            hiddenPostOfDepartment:true,
            isNeedCheckLevelScope:false,
            minSize:0,
            selectType:'Department,Account,Post,Level',
            accountId:'${accountId}',
            callback: function(ret) {
                $("#scopein_txt").val(ret.text);
                $("#scopein").val(ret.value);
            }});
      }else{
        $.selectPeople({
          params:{value:$("#scopein").val()},
          type: 'selectPeople',
            panels:'Department,Post,Level',
            hiddenPostOfDepartment:true,
            isNeedCheckLevelScope:false,
            minSize:0,
            selectType:'Department,Account,Post,Level',
            onlyLoginAccount:true,
            accountId:'${accountId}',
            callback: function(ret) {
                $("#scopein_txt").val(ret.text);
                $("#scopein").val(ret.value);
            }});
      }
    }
  });
  $("#btnok").click(function() {
    if (! ($("#postform").validate())) {
      return;
    }
    if (oManager.isDepartmentAdmin() && !oManager.isHRAdmin()) {
    	var ownerIdValue = $("#ownerId").val();
    	if(ownerIdValue==null || ownerIdValue==""){
    		 $.alert("${ctp:i18n('team.check.belongnotnull')}");   		
    		return;
    	}
    	if ($('input:radio[name="scope"]:checked').val() == "1") {
	    	var scopein_txtValue = $("#scopein_txt").val();
	    	if(scopein_txtValue==null || scopein_txtValue==""){
	    		 $.alert("${ctp:i18n('team.check.scopenotnull')}");   		
	    		return;
	    	}
    	}
    }
    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    pManager.saveTeam(accountId, $("#addForm").formobj(), {
      success: function(levelBean) {
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc()
          }
        } catch(e) {};
        $("#teamLeader").comp({
          excludeElements: '',
          value: '',
          text: ''
        });
        $("#teamMember").comp({
          excludeElements: '',
          value: '',
          text: ''
        });
        $("#teamSuperVisor").comp({
          excludeElements: '',
          value: '',
          text: ''
        });
        $("#teamRelative").comp({
          excludeElements: '',
          value: '',
          text: ''
        });
        $("#mytable").ajaxgridLoad(o);
        if ($("#conti").attr("checked") == "checked") {
          addform();
        } else {
          $("#postform").hide();
          $("#button").hide();
          $("#welcome").show();
        }
      }
    });
  });

  var searchobj = $.searchCondition({
    top: 7,
    right: 10,
    searchHandler: function() {
      var ssss = searchobj.g.getReturnValue();
      ssss.accountId = accountId;
      $("#mytable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('team.name')}",
      value: 'name'
    },
    {
      id: 'search_enable',
      name: 'search_enable',
      type: 'select',
      text: "${ctp:i18n('level.select.state')}",
      value: 'enable',
      codecfg: "codeId:'common.enabled'"

    },
    {
      id: 'search_scope',
      name: 'search_scope',
      type: 'select',
      text: "${ctp:i18n('team.privilege')}",
      value: 'scope',
      codecfg: "codeType:'java',codeId:'com.seeyon.ctp.organization.enums.TeamScopeEnum'"

    }]
  });

  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }

  $('#grid_detail').resize(function() {
    if ($("#button").is(":hidden")) {
      $('#sssssssss').height($(this).height() - 0).css('overflow', 'auto');
    } else {
      $('#sssssssss').height($(this).height() - 38).css('overflow', 'auto');
    }
  });
});
</script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp" comp="type:'layout'">
 	<c:if test="${ctp:isRoleByCode('GroupAdmin')!=true || accountId==-1730833917365171641}">
	    <div id="breadCrumb4Team" class="comp" comp="type:'breadcrumb',code:'T02_showTeamframe'"></div>
	    <div id="breadCrumb4Team1" class="comp" comp="type:'breadcrumb',code:'T02_showTeamframe1'"></div>
    </c:if>
    
    <div class="layout_north" layout="height:40,sprit:false,border:false">
        <div id="searchDiv"></div>
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
        <div id="grid_detail" class="">
            <div>
                <div class="clearfix" id="sssssssss">
                    <div id="welcome">
                        <div class="color_gray margin_l_20">
                            <div class="clearfix">
                                <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n('team.info')}</h1>
                                <div class="font_size12 left margin_t_20 margin_l_10">
                                    <div class="margin_t_10 font_size14">
                                        <span id="count"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="line_height160 font_size14">
                                <c:choose>
                                    <c:when test="${isGroup}">${ctp:i18n('organization.detail_info_team_group')}</c:when>
                                    <c:otherwise>${ctp:i18n('organization.detail_info_team_account')}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div id="postform">
                        <%@include file="teamform.jsp" %></div>
                </div>
                <div class="">
                    <div id="button" align="center" class="page_color button_container padding_t_5 border_t" style="height:35px;">
                        <div class="common_checkbox_box clearfix page_color">
                            <label for="conti" class="margin_r_10 hand" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>