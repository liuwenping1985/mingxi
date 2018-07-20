<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${url_ajax_performanceReportManager}"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=reportAuthManager"></script>
<title>${ctp:i18n('performanceReport.authorize.list.title')}</title>
</head>
<script type="text/javascript">
//------------i18n国际化区域 start
//新建
var i18n_new = "${ctp:i18n('performanceReport.authorize.list.new')}";
//编辑
var i18n_edit = "${ctp:i18n('performanceReport.authorize.list.edit')}";
//删除
var i18n_delete = "${ctp:i18n('performanceReport.authorize.list.delete')}";
// ------------i18n国际化区域 end
var reportAuthManager_= new reportAuthManager();

$(document).ready(function() {
  // 定义页面表格上方的菜单项
  $("#toolbar_reporting").toolbar({
    toolbar : [ {
      id : "add",
      name : i18n_new,
      className : "ico16",
      click : add_report
    }, {
      id : "edit",
      name : "${ctp:i18n('report.reportDesign.button.edit')}",
      className : "ico16 editor_16",
      click : edit_report
    }, {
      id : "delete",
      name : i18n_delete,
      className : "ico16 del_16",
      click : delete_report
    } ]
  });

  // 定义表格数据
  var report_grid = $("#report_grid").ajaxgrid({
    click : testclick,
    dblclick : dblclick,
    render : render,
    colModel : [ {
      display : 'id',
      name : 'id',
      width : '5%',
      align : 'left',
      sortable : false,
      type : 'checkbox'
    }, {
      display : "${ctp:i18n('performanceReport.authorize.list.personsName')}",
      name : 'personsName',
      width : '35%',
      sortable : false,
      align : 'left',
      cutsize : 10
    }, {
      display : "${ctp:i18n('performanceReport.authorize.list.templatesName')}",
      name : 'templatesName',
      width : '60%',
      sortable : false,
      align : 'left',
      cutsize : 10
    } ],
    managerName : "reportAuthManager",
    managerMethod : "findOldReportAuthList",
    usepager: true,
    showTableToggleBtn: false,
    parentId: "center",
    isHaveIframe:true,
    vChange: true,
    vChangeParam: {
        overflow: "hidden",
        autoResize:true
    },
    slideToggleBtn: true
  });

  //第一次加载Grid
  load_report();
  
  /**
   * 解析某些需要特别取数据的列
   */
  function render(text, data, rowIndex, colIndex ,colum) {
   var currentColumName = colum.name;
    if (currentColumName == "id") {
      return '<span class="grid_black"><input type="checkbox" value="' + data.id + '"></span>';
    } else if (currentColumName == "personsName") {
      return "<span class='grid_black'>"+data.personsName+"</span>";
    } else if (currentColumName == "templatesName"){
      return "<span class='grid_black'>"+data.templatesName+"</span>";
    } else if(currentColumName == "queryFields"){
      return "<span class='grid_black'>"+data.queryFields+"</span>";
    } else if(currentColumName == "queryRangs"){
        return "<span class='grid_black'>"+data.queryRangs+"</span>";
    } else {
      return "<span class='grid_black'>"+text+"</span>";
    }
  }

  function testclick(data, rowIndex, colIndex) {
	  $("#authDetail").attr("src","${url_performanceReport_authEdit}&authId=" + data.id+"&parentId="+${parentId});
	  report_grid.grid.resizeGridUpDown("middle");
  }
  function dblclick(data, rowIndex, colIndex) {
	  $("#authDetail").attr("src","${url_performanceReport_authEdit}&hasButton=true&authId=" + data.id+"&parentId="+${parentId});
	  report_grid.grid.resizeGridUpDown("middle");
  }

  /**
   * 执行报表新增操作的方法
   */
  function add_report() {
    $("#authDetail").attr("src","${url_performanceReport_personRight}&hasButton=true&reportId=${reportId}&isNew=true"+"&parentId="+${parentId});
    report_grid.grid.resizeGridUpDown("middle");
  }

  /**
   * 执行报表编辑操作的方法
   */
  function edit_report() {
    var checkedValue = getCheckedData();
    if (checkedValue == undefined || checkedValue.length == 0) {
    	$.alert("${ctp:i18n('performanceReport.authorize.dialog.choseEdit')}");
      //$.alert("请选择一条需要编辑的选项!");
      return;
    } else if (checkedValue.length > 1) {
      $.alert("${ctp:i18n('performanceReport.authorize.dialog.tooMuchEdit')}");
      return;
    } else {
      $("#authDetail").attr("src","${url_performanceReport_authEdit}&hasButton=true&authId=" + checkedValue[0].id+"&parentId="+${parentId});
      report_grid.grid.resizeGridUpDown("middle");
    }
  }

  /**
   * 执行报表删除操作的方法
   */
  function delete_report() {
    // 获取选中的数据集合
    var checkedValue = getCheckedData();
    if (checkedValue == undefined || checkedValue.length == 0) {
      $.alert("${ctp:i18n('performanceReport.authorize.dialog.choseDelete')}");
      return;
    }

    var confirm = $.confirm({
      'msg' : "${ctp:i18n('performanceReport.authorize.dialog.promptDelete')}",
      cancel_fn : function() {
      },
      ok_fn : function() {
        delete_ajax(checkedValue);
      }
    });
  }

  /**
   * 获取选中的grid数据集合
   */
  function getCheckedData() {
    var checkedData = $("#report_grid").formobj({
      gridFilter : function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    return checkedData;
  }

  /**
   * ajax批量删除选中的grid数据
   */
  function delete_ajax(checkedValue) {
    var deleteReport = new Array();
    for ( var i = 0; i < checkedValue.length; i++) {
      deleteReport[i] = checkedValue[i].id+"|1";
    }
    var proce = getCtpTop().$.progressBar({
      text : "${ctp:i18n('performanceReport.authorize.dialog.deleting')}"
    });
   	var user=$.ctx.CurrentUser; 
    reportAuthManager_.deleteReportAuth(user,deleteReport, {
      success : function(result) {
        load_report();
        $("#authDetail").attr("src","${url_performanceReport_personRight}&reportId=${reportId}&parentId=${parentId}");
        report_grid.grid.resizeGridUpDown("down");
        proce.close();
      }
    });
  }
  $("#layout").css({"border-left":"1px solid #b6b6b6"});
});

/**
 * 刷新当前的grid，加载grid数据
 */
function load_report() {
  var o = new Object();
  o.reportId = "${reportId}";
  o.createOrg=$.ctx.CurrentUser.loginAccount;
  $("#report_grid").ajaxgridLoad(o);
 // report_grid.grid.resizeGrid(250);
}
</script>
<body class="h100b over_hidden page_color">
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false,border:false">
        <div id="toolbar_reporting"></div>
    </div>
    <div class="layout_center page_color over_hidden" id="center" layout="border:false">
        <table id="report_grid" style="display: none;"></table>
        <div id="grid_detail">
        	<iframe id="authDetail" src="${url_performanceReport_personRight}&reportId=${reportId}&parentId=${parentId}" width="100%" height="100%" frameborder="0"></iframe>
        </div>
    </div>
</div> 
</body>
</html>