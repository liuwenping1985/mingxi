<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/WEB-INF/jsp/apps/collaboration/js/template_pub.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager"></script>
<script>
var categoryId = "${ctp:escapeJavascript(categoryId)}";
var templateId = "${ctp:escapeJavascript(templateId)}";
$(document).ready(function() {
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 35,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
    var grid = $("#collaborationTemplateTable").ajaxgrid({
      colModel : [ {
      display : '',
      name : 'workflowId',
      width : '5%',
      type : 'radio'
    }, {
      display : "${ctp:i18n('template.categorylist.name.label')}",
      name : 'subject',
      width : '40%',
      sortable : true
    }, {
      display : "${ctp:i18n('template.categorylist.modifytime.label')}",
      name : 'modifyDate',
      width : '25%',
      sortable : true
    }, {
      display : "${ctp:i18n('template.selectSourceTem.transformationOfApplied')}", //所属应用
      name : 'type',
      width : '15%',
      codecfg : "codeType:'java',codeId:'com.seeyon.apps.template.enums.TemplateTypeEnums'",
      sortable : true
    }, {
      display : "${param.categoryType==null || param.categoryType=='1'?ctp:i18n('template.selectSourceTem.belongsToPeople'):ctp:i18n('template.selectSourceTem.modifyname')}", //所属人
      name : 'createrName',
      width : '13%',
      sortable : true
    }],
    click: clickRow,
    render : rend,
    managerName : "collaborationTemplateManager",
    managerMethod : "selectTempletes",
    parentId: $('.layout_center').eq(0).attr('id'),
    showTableToggleBtn: true,
    parentId: 'center',
    vChange: true,
    vChangeParam: {
        overflow: "hidden",
        autoResize:true
    },
    isHaveIframe:true,
    slideToggleBtn:true
  });
  
  var o = new Object();
  o.categoryType = "${param.categoryType==null?1:ctp:escapeJavascript(param.categoryType)}";
  o.onlyFlowTemplate = true;
  o.templateId = templateId;
  $("#collaborationTemplateTable").ajaxgridLoad(o);
  
  function clickRow(data, rowIndex, colIndex) {
      grid.grid.resizeGridUpDown('middle');
      var appName = "collaboration", wendanId = "";
      switch(data.moduleType){
        case 19:{
            appName="edocSend";
            wendanId = getWenDanId(data.summary);
            break;
        }
        case 20:{
            appName="edocRec";
            wendanId = getWenDanId(data.summary);
            break;
        }
        case 21:{
            appName="edocSign";
            wendanId = getWenDanId(data.summary);
            break;
        }
      }
      var url = '${path}/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId='+data.workflowId+'&appName='+appName+'&wendanId='+wendanId;
      $("#templateOperDes").attr("src", url);
  }
  
  function getWenDanId(xmlstring){
    var wendanId = "";
    if(xmlstring!=null && $.trim(xmlstring)!=''){
        xmlstring = xmlstring.replace(/\r*\n*\s*/g,"");
        var tempRegexp = /<formId>[-+0-9]+\<\/formId\>/g;
        var temp = tempRegexp.exec(xmlstring);
        if(temp!=null){
            wendanId = temp[0].replace(/[^-+0-9]/g,"");
        }
        if(wendanId==null){
            wendanId = "";
        }
    }
    return wendanId;
  }
  
  function rend(txt,data, r, c) {
    return txt;
  }
  
  // 搜索框
  var searchobj = $.searchCondition({
    top:5,
    right:10,
    searchHandler: function(){
      var result = searchobj.g.getReturnValue();
      if(result){
        loadTable(result.condition, result.value);
      }
    },
    conditions: [
      { id: 'subject',
        name: 'subject',
        type: 'input',
        text: "${ctp:i18n('template.categorylist.name.label')}",
        validate: false,
        value: 'subject'
      },
       { id: 'modifyDate',
         name: 'modifyDate',
         type: 'datemulti',
         text: "${ctp:i18n('template.categorylist.modifytime.label')}",
         ifFormat: "%Y-%m-%d",
         value: 'modifyDate'
       }
       <c:if test="${param.categoryType != '4' && param.categoryType != '19' && param.categoryType != '20' && param.categoryType != '21'}">
       ,
      { id: 'type',
        name: 'type',
        type: 'select',
        text: "${ctp:i18n('template.selectSourceTem.transformationOfApplied')}", //所属应用
        validate: false,
        value: 'type',
        items: [
            { text: "${ctp:i18n('collaboration.saveAsTemplate.collTemplate')}", //协同模板
              value: 'template'
            }, 
            { text: "${ctp:i18n('collaboration.saveAsTemplate.flowTemplate')}", //流程模版
              value: 'workflow'
            }
        ]
      }
       </c:if>
//       , { id: 'member',
//         name: 'member',
//         type: 'input',
//         text: "所属人",
//         validate: false,
//         value: 'member'
//       }
    ]
  });
});

function loadTable(condition, value){
  var o = new Object();
  o.categoryType = '${param.categoryType==null?1:ctp:escapeJavascript(param.categoryType)}';
  o.onlyFlowTemplate = true;
  o.templateId = templateId;
  //o.categoryId = categoryId;
  if(condition && value){
    if("modifyDate" === condition){
      if(value[1] != "" && value[0] > value[1]){
        $.alert("${ctp:i18n('template.wrongdate.info')}");
        return;
      }
      eval("o.startdate = '" + value[0] +"';");
      eval("o.enddate = '" + value[1] +"';");
    }else{
      eval("o."+condition+" = '" + escape(value) +"';");
    }
  }
  $("#collaborationTemplateTable").ajaxgridLoad(o);
}

function OK(){
  var result = -1;
  $("input:radio").each(function(index, elem){
    if(elem.checked){
      result = $(elem).val();
    }
  });
  return result;
}
</script>
</head>
    <body>
      <form id="commonForm" action="" method="post">
        <input type="hidden" id="templateId">
        <input type="hidden" id="categoryId">
        <input type="hidden" id="categoryType">
      </form>
      <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3 " id="collaborationTemplateTable"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>