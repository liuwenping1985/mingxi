<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp"%>
<!DOCTYPE html>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=cubeAuthManager"></script>
<title>${ctp:i18n('colCube.auth.list.title')}</title>
</head>
<script type="text/javascript">
//------------i18n国际化区域 start
//新建
var i18n_new = "${ctp:i18n('colCube.auth.list.new')}";
//编辑
var i18n_edit = "${ctp:i18n('colCube.auth.list.edit')}";
//删除
var i18n_delete = "${ctp:i18n('colCube.auth.list.delete')}";
// ------------i18n国际化区域 end
var cubeAuthManager_ = new cubeAuthManager();
var grid_totals = "${gridTotal}";
$(document).ready(function() {
  // 定义页面表格上方的菜单项
  $("#toolbar_reporting").toolbar({
	searchHtml:"search",
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
	//searchHTML : 'search',
    click : testclick,
    dblclick : dblclick,
    render : render,
    callBackTotle : callBackTotle,
    colModel : [ {
      display : 'id',
      name : 'id',
      width : '5%',
      align : 'left',
      sortable : false,
      type : 'checkbox'
    }, {
      display : "${ctp:i18n('colCube.auth.list.personsName')}",
      name : 'personsName',
      width : '45%',
      sortable : false,
      align : 'left',
      cutsize : 20
    },  {
      display : "${ctp:i18n('colCube.auth.list.queryRangs')}",
      name : 'queryRangs',
      width : '45%',
      sortable : false,
      align : 'left',
      cutsize : 20
    } ],
    managerName : "cubeAuthManager",
    managerMethod : "findCubeAuthList",
    usepager: true,
    showTableToggleBtn: false,
    parentId: $('.layout_center').eq(0).attr('id'),
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

  //给子页面赋值总条数
  function callBackTotle(e){
    grid_totals = e;
    set_iframe_total();
  }
  /**
   * 解析某些需要特别取数据的列
   */
  function render(text, data, rowIndex, colIndex ,colum) {
    var currentColumName = colum.name;
    if (currentColumName == "id") {
      return '<span class="grid_black"><input type="checkbox" value="' + data.id + '"></span>';
    } else if (currentColumName == "personsName") {
      return "<span class='grid_black'>"+data.personsName+"</span>";
    } else if(currentColumName == "queryRangs"){
        return "<span class='grid_black'>"+data.queryRangs+"</span>";
    } else {
      return "<span class='grid_black'>"+text+"</span>";
    }
  }

  function testclick(data, rowIndex, colIndex) {
    $("#authDetail").attr("src","${url_colCube_authDetailEdit}&authId=" + data.id+"&flag=readOnly&totals="+grid_totals);
    report_grid.grid.resizeGridUpDown("middle");
  }
  function dblclick(data, rowIndex, colIndex) {
    $("#authDetail").attr("src","${url_colCube_authDetailEdit}&flag=edit&authId=" + data.id+"&totals="+grid_totals);
    report_grid.grid.resizeGridUpDown("middle");
  }
  /**
   * 执行报表新增操作的方法
   */
  function add_report() {
	$("#authDetail").attr("src","${url_colCube_authDetail}&reportId=${reportId}&flag=add&totals="+grid_totals);
	report_grid.grid.resizeGridUpDown("middle");
// 	$("#authDetail")[0].contentWindow.check("add");
  }

  /**
   * 执行报表编辑操作的方法
   */
  function edit_report() {
    var checkedValue = getCheckedData();
    if (checkedValue == undefined || checkedValue.length == 0) {
    	$.alert("${ctp:i18n('colCube.auth.list.dialog.choseEdit')}");
      //$.alert("请选择一条需要编辑的选项!");
      return;
    } else if (checkedValue.length > 1) {
      $.alert("${ctp:i18n('colCube.auth.list.dialog.tooMuchEdit')}");
      return;
    } else {
      $("#authDetail").attr("src","${url_colCube_authDetailEdit}&authId=" + checkedValue[0].id+"&flag=edit&totals="+grid_totals);
    }
    report_grid.grid.resizeGridUpDown("middle");
//     $("#authDetail")[0].contentWindow.check("edit");
  }

  /**
   * 执行报表删除操作的方法
   */
  function delete_report() {
    // 获取选中的数据集合
    var checkedValue = getCheckedData();
    if (checkedValue == undefined || checkedValue.length == 0) {
      $.alert("${ctp:i18n('colCube.auth.list.dialog.choseDelete')}");
      return;
    }

    var confirm = $.confirm({
      'msg' : "${ctp:i18n('colCube.auth.list.dialog.promptDelete')}",
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
      deleteReport[i] = checkedValue[i].id+"|2";
    }
    var proce = $.progressBar({
      text : "${ctp:i18n('colCube.auth.list.dialog.deleting')}"
    });
    var user=$.ctx.CurrentUser;
    cubeAuthManager_.deleteCubeAuth(user,deleteReport, {
      success : function(result) {
        load_report();
        proce.close();
      }
    });
  }
  $("#authDetail").attr("src","${url_colCube_authDetail}&reportId=${reportId}&welcome=true&totals="+grid_totals);
});

function set_iframe_total(){
  var detailTotals = $(window.frames["authDetail"].document).find("#totals");
  if(detailTotals==null || detailTotals.length==0){
		  $("#authDetail").contents().find("#totals").html(grid_totals);
  }
  detailTotals.html(grid_totals);
}

/**
 * 刷新当前的grid，加载grid数据
 */
function load_report() {
  var o = new Object();
  o.reportId = "${reportId}";
   o.createOrg=$.ctx.CurrentUser.loginAccount;
  $("#report_grid").ajaxgridLoad(o);
  //OA-71919进入协同立方设置-授权设置界面，面包屑中点击一下【协同立方设置】刷新列表，然后查看总计条数，显示为0了（高频偶发）
  //set_iframe_total();
  //try{set_iframe_total();}catch(e){}  
  //report_grid.grid.resizeGrid(250);
}
</script>
<body class="h100b over_hidden page_color">
<div id='layout' class="comp page_color" comp="type:'layout'">
    <div class="layout_north" layout="height:30,sprit:false">
        <div id="toolbar_reporting"></div>
        <!-- 
        <div id="search" class="hidden">
        	<a href="#">【权限日志】</a>   
        	查询人员:<input class="comp" name="name" value="" type="text">
		</div>
         -->
    </div>
    <div class="layout_center page_color over_hidden" layout="border:false">
        <table id="report_grid" style="display: none;"></table>
        <div id="grid_detail">
           <iframe id="authDetail" width="100%" height="100%" frameborder="0"></iframe>
        </div>
    </div>
</div> 
</body>
</html>