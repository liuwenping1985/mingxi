<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%@ include file="/WEB-INF/jsp/common/common.jsp"%>
    <style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
    <script type="text/javascript">
    var oManager = new orgManager();
    var accountId = "${accountId}";
$().ready(function() {
	var isA6s = "${isA6s}";//A6-s任务项，如果是A6s屏蔽部门空间这一行和选项，并默认不开启
  if(isA6s == "true") {
    $("#trDeptSpace").hide();
  }
  var superdeptid = "";
  var superdeptname = "";
  var cnt;
  var msg = '${ctp:i18n("info.totally")}';
  var dManager = new departmentManager();
  $("#depform").hide();
  $("#button").hide();
  $("#welcome").show();
  function addform() {
    $("#depform").clearform({
      clearHidden: true
    });
    $("#depform").enable();
    $("#depform").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $("#viewbutton").hide();
    $("#name").focus();
    $("#conti").attr("checked", 'checked');
    $("input[name=enabled]:eq(0)").attr("checked", 'checked');
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("input[name=createDeptSpace]:eq(1)").attr("checked", 'checked');
    $("#superDepartment").comp({
      value: superdeptid,
      text: superdeptname
    });
    dManager.addDept(accountId, {
      success: function(rel) {
        $("#sortId").val(rel["sortId"]);
      }
    });
  }
  function clk(e, treeId, node) {
    var deptdetil = dManager.viewDept(node.id);
    $("#addForm").clearform();
    $("#addForm").fillform(deptdetil);
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("#depform").show();
    $("#welcome").hide();
    $("#button").hide();
    $("#depform").disable();
    $("#viewbutton").show();
  }
  function dbclk() {
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('post.chosce.modify')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var deptdetil = dManager.viewDept(v[0]["id"]);
      $("#addForm").clearform();
      $("#addForm").fillform(deptdetil);
      $("#conti").removeAttr("checked");
      $("#depform").enable();
      $("#depform").show();
      $("#button").show();
      $("#lconti").hide();
      $("#welcome").hide();
      $("#viewbutton").show();
      $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
      $("#deptLevel").attr("disabled",true);

    }
  }
  var imanager = new iOManager();
  $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
        mytable.grid.resizeGridUpDown('middle');
      }
    },
    {
      id: "modify",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: function() {
        dbclk();
      }

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
          $.alert("${ctp:i18n('depatition.delete')}");
        } else {
          $.confirm({
            'msg': "${ctp:i18n('org.dept.choose.sure.delete')}",
            ok_fn: function() {
              dManager.deleteDepts(v, {
                success: function() {
                  $("#mytable").ajaxgridLoad(o);
                }
              }

              );
            }
          });
        };
      }
    },{
      id: "import_export",
      name: "${ctp:i18n('export.or.import')}",
      className: "ico16 import_16",
      subMenu: [{
        name: "${ctp:i18n('import.excel')}",
        click: function() {
          dialog = $.dialog({
            width: 600,
            height: 400,
            isDrag: false,
            //targetWindow:window.parent,
            //BUG请不要打开这个属性，否则弹出窗口取得对象无法关闭这个框
            id: 'importdialog',
            url: '${path}/organization/organizationControll.do?method=importExcel&importType=department&accountId=' + accountId,
            title: "${ctp:i18n('import.excel')}",
            closeParam:{
              'show':true,
              handler:function(){
                filter = new Object();
                filter.enabled = true;
                filter.accountId = accountId;
                isSearch = false;
                $("#mytable").ajaxgridLoad(filter);}
            }
          });
        }
      },
      {
        name: "${ctp:i18n('org.template.excel.download')}",
        click: function() {
          var downloadUrl = "${path}/organization/organizationControll.do?method=downloadTemplate&type=Department&accountId=" + accountId;
          var eurl = "<c:url value='" + downloadUrl + "' />";
          exportIFrame.location.href = eurl;
        }
      },
      {
        name: "${ctp:i18n('org.post_form.export.exel')}",
        click: function() {
            $.confirm({
              'title': "${ctp:i18n('common.prompt')}",
              'msg': "${ctp:i18n('member.export.prompt.wait')}",
              ok_fn: function() {
                imanager.canIO({
                    success: function(rel) {
                      if ('ok' == rel) {
                        var downloadUrl_e = "${path}/organization/department.do?method=exportDepartments&accountId=" + accountId;
                        var eurl_e = "<c:url value='" + downloadUrl_e + "' />";
                        exportIFrame.location.href = eurl_e;
                      }
                    }
                  });
                }
            });
        }
      }]
    },
    {
      id: "view",
      name: "${ctp:i18n('org.button.change.tree.label')}",
      className: "ico16 view_switch_16",
      click: function() {
        location.href = "${path}/organization/department.do?method=showDepartmentFrame&style=tree&accountId=" + accountId;
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
      display: "${ctp:i18n('org.dept_form.name.label')}",
      sortable: true,
      name: 'name',
      width: '20%'
    },
    {
      display: "${ctp:i18n('org.dept_form.code.label')}",
      sortable: true,
      name: 'code',
      width: '20%'
    },
    {
      display: "${ctp:i18n('common.sort.label')}",
      sortable: true,
      name: 'sortId',
      sortType: 'number',
      width: '8%'
    },
    {
      display: "${ctp:i18n('org.dept_form.superDepartment.label')}",
      sortable: true,
      name: 'superDepartment',
      sortname: 'type',
      width: '10%'
    },
    {
      display: "${ctp:i18n('org.dept_form.deptLeader.label')}",
      sortable: true,
      name: 'DepManager',
      width: '20%'
    },
    {
      display: "${ctp:i18n('common.state.label')}",
      sortable: true,
      codecfg: "codeId:'common.enabled'",
      name: 'enable',
      width: '8%'
    }],
    managerName: "departmentManager",
    managerMethod: "showDepList",
    parentId: 'center',
    vChangeParam: {
      overflow: "hidden",
      position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    vChange: true,
    callBackTotle: getCount
  });
  var o = new Object();
  o.accountId = accountId;
  $("#mytable").ajaxgridLoad(o);

  function gridclk(data, r, c) {
    $("#welcome").hide();
    $("#depform").disable();
    $("#depform").show();
    $("#button").hide();
    $("#viewbutton").show();
    var deptdetil = dManager.viewDept(data.id);
    $("#addForm").fillform(deptdetil);
    $("input[name=sortIdtype]:eq(0)").attr("checked", 'checked');
    
  }
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#btnok").click(function() {
    if (! ($("#addForm").validate())) {
      return;
    }
    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    dManager.postCheck($("#addForm").formobj(), {
    	success: function(checkInfo) {
    		if(checkInfo!=null && checkInfo!=""){
    		    var confirm = $.confirm({
    		        'msg': checkInfo,
    		        ok_fn: function () {
	    		            dManager.createDeptAfterCheckPost(accountId, $("#addForm").formobj(), {
	    		                success: function(depBean) {
	    		                  try {
	    		                    if (getCtpTop() && getCtpTop().endProc) {
	    		                      getCtpTop().endProc()
	    		                    }
	    		                  } catch(e) {};
	    		                  $("#mytable").ajaxgridLoad(o);
	    		                  if ($("#conti").attr("checked") == "checked") {
	    		                    superdeptid = $("#superDepartment").val();
	    		                    superdeptname = $("#superDepartment_txt").val();
	    		                    addform();
	    		                  } else {
	    		                    $("#depform").hide();
	    		                    $("#button").hide();
	    		                    $("#welcome").show();
	    		                  }
	    		                }
	    		              });
    		        },
    		        cancel_fn:function(){try {if (getCtpTop() && getCtpTop().endProc) {getCtpTop().endProc()}} catch(e) {};}
    		    });
    		}else{
    		    dManager.createDeptAfterCheckPost(accountId, $("#addForm").formobj(), {
    		        success: function(depBean) {
    		          try {
    		            if (getCtpTop() && getCtpTop().endProc) {
    		              getCtpTop().endProc()
    		            }
    		          } catch(e) {};
    		          $("#mytable").ajaxgridLoad(o);
    		          if ($("#conti").attr("checked") == "checked") {
    		            superdeptid = $("#superDepartment").val();
    		            superdeptname = $("#superDepartment_txt").val();
    		            addform();
    		          } else {
    		            $("#depform").hide();
    		            $("#button").hide();
    		            $("#welcome").show();
    		          }
    		        }
    		      });
    			
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
      text: "${ctp:i18n('org.dept.name')}",
      value: 'name'
    },
    {
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: "${ctp:i18n('org.dept_form.code.label')}",
      value: 'code'

    },
    {
      id: 's_superDepartment',
      name: 's_superDepartment',
      type: 'selectPeople',
      text: "${ctp:i18n('org.dept.parent.nodename')}",
      value: 'path',
      comp: "type:'selectPeople',panels:'Department',selectType:'Department',maxSize:'1',onlyLoginAccount:true,accountId:'${accountId}'"
    }]
  });
  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">
        <div id="toolbar"></div>
        <div id="searchDiv"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:true" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0"></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="welcome">
                        <div class="color_gray margin_l_20">
                            <div class="clearfix">
                                <h2 class="left" style="font-size: 26px;font-family: Verdana;font-weight: bolder;color: #888888;">${ctp:i18n('org.dept_form.manager.label')}</h2>
                                <div class="font_size12 left margin_t_20 margin_l_10">
                                    <div class="margin_t_10 font_size14">
                                        <span id="count"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="line_height160 font_size14">${ctp:i18n('organization.detail_info_1909')}</div>
                        </div>
                    </div>
                    <div id="depform" class="form_area">
                        <%@include file="deptform.jsp"%></div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container padding_t_5 border_t stadic_footer_height">
                        <div class="common_checkbox_box clearfix ">
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