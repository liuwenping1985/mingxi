<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="/WEB-INF/jsp/apps/collaboration/js/template_pub.js.jsp" %>
<script type="text/javascript" src="${path}/ajax.do?managerName=collaborationTemplateManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<script>
//var sortdialog;
//公文
var edocCategory = "4";
var edocsendCategory = "19";
var edocrecCategory = "20";
var sginReportCategory = "21";

$(document).ready(function () {
    //隐藏当前位置
    //getCtpTop().hideLocation();
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 30,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
    // 协同
    var collCategory = "1";

    var toolbar =  $("#toolbar").toolbar({
      // 配置模板
      toolbar : [ {
        id : "config",
        name : "${ctp:i18n('template.templatePub.configurationTemplates')}", //配置模板
        className : "ico16 setting_16",
        click : function() {
          var dialog = $.dialog({
            url : '${path}/collTemplate/collTemplate.do?method=templateConfig',
            width : 700, 
            height : 500, 
            title : "${ctp:i18n('template.templateConfigFrame.configTemplate')}", //配置模板（发布到空间）
            targetWindow : getCtpTop(),
            buttons : [ {
              text : "${ctp:i18n('template.category.submit.label')}",
              handler : function() {
                var callerResponder = new CallerResponder();
                callerResponder.success = function(jsonObj) {
                  loadTable();
                  dialog.close();
                };
                callerResponder.sendHandler = function(b, d, c) {
                    var confirm = "";
                    confirm = $.confirm({
                        'msg': "${ctp:i18n('privilege.resource.confirmSubmit.info')}",
                        ok_fn: function () {
                            b.send(d, c);
                        }
                    });
                }
                var result = dialog.getReturnValue();
                if(result){
                  var ids = new Array();
                  $(result).each(function(index, elem){
                    ids.push(elem);
                  });
                  var manage = new templateManager();
                  manage.updateTempleteConfig(ids, callerResponder);
                }
              }
            }, {
              text : "${ctp:i18n('template.category.cancel.label')}",
              handler : function() {
                dialog.close();
              }
            }]
          });
        }
      // 排序设置
      }, {
        id : "sort",
        name : "${ctp:i18n('template.templateConfigFrame.sortSettings')}", //排序设置
        className : "ico16 sort_16",
        click : function() {
          parent.sortdialog = $.dialog({
            url : '${path}/collTemplate/collTemplate.do?method=showTempleteSort',
            width : 300, 
            height : 270, 
            title : "${ctp:i18n('template.templateConfigFrame.templateSort')}", //模板排序
            transParams : 1,
            targetWindow:getCtpTop(),
            buttons : [ {
              id : "sortSubmit",
              text : "${ctp:i18n('template.category.submit.label')}",
              handler : function() {
                var callerResponder = new CallerResponder();
                callerResponder.success = function(jsonObj) {
                  loadTable();
                  if(parent.sortdialog != null){
                    parent.sortdialog.close();
                    parent.sortdialog = null;
                  }
                };
                var result = parent.sortdialog.getReturnValue();
                if(result){
                  var ids = new Array();
                  $(result).each(function(index, elem){
                    ids.push(elem);
                  });
                  var manage = new collaborationTemplateManager();
                  manage.updateTempleteConfigSort(ids, callerResponder);
                }
              }
            }, {
              text : "${ctp:i18n('template.category.cancel.label')}",
              handler : function() {
                parent.sortdialog.close();
                parent.sortdialog = null;
              }
            }]
          });
        }
      }, {
        id : "cancel",
        name : "${ctp:i18n('template.templateConfigFrame.unpublish')}",  //取消发布
        className : "ico16 unpublish_16",
        click : function() {
          var sum = 0 ;
          var ids = new Array();
          var i = 0;
          $("#collaborationTemplateTable :checkbox").each(function(){
              if ($(this).attr("checked")) {
                  sum ++ ;
                  i ++ ;
                  ids.push($(this).val());
              }
          });
          if (sum > 0){
            deleteTemplateConfig(ids);
          } else {
              //请选择模板
              $.alert("${ctp:i18n('template.templateChooseM.pleaseTemplate')}");
          }
        }
      }]
    });
    var grid = $("#collaborationTemplateTable").ajaxgrid({
        colModel : [ {
        display : '',
        name : 'id',
        width : '4%',
        type : 'checkbox'
      }, {
        display : "${ctp:i18n('template.categorylist.name.label')}",
        name : 'subject',
        width : '74%',
        sortable : true
      }, {
        display : "${ctp:i18n('template.categorylist.type.label')}",
        name : 'type',
        width : '20%',
        codecfg : "codeType:'java',codeId:'com.seeyon.apps.template.enums.TemplateTypeEnums'",
        sortable : true
      }],
      click: clickRow,
      render : rend,
      managerName : "collaborationTemplateManager",
      managerMethod : "getPersonalTemplete",
      parentId: $('.layout_center').eq(0).attr('id'),
      vChange: true,
      callBackTotle: function(obj){
        $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateOperDes&from=templateConfig&total="+obj);
      },
      vChangeParam: {
          overflow: "hidden",
          autoResize:true
      },
      slideToggleBtn: true
    });
    var o = new Object();
    o={category:"${category}"};
    $("#collaborationTemplateTable").ajaxgridLoad(o);
    
    function clickRow(data, rowIndex, colIndex) {
      grid.grid.resizeGridUpDown('middle');
      var rows = grid.grid.getSelectRows();
      if(rows.length < 1){
          return;
      }
      var templateId = rows[0].id;
      if(data.moduleType == edocCategory 
              || edocsendCategory == data.moduleType 
              || edocrecCategory == data.moduleType 
              || sginReportCategory == data.moduleType){
    	  $("#left_div").hide();
            $("#templateOperDes").attr("src",_ctxPath+"/edocTempleteController.do?method=systemDetail&templeteId="+templateId);
      } else if(data.moduleType == 401 
	        || data.moduleType == 402||data.moduleType == 404){
	    	//if(app == "4"){
	    		nodeId = data.id;
				nodeModuleType = data.moduleType;
	    		workflowId = data.workflowId;
	    		$("#left_div").show();
	    		govdocShowDocPage();
				document.getElementById("editFrame").contentWindow.location.href = _ctxPath+"/form/bindDesign.do?method=editFrame" + "&fbid="+templateId;
	    		//$("#templateOperDes").attr("src",_ctxPath + "/content/content.do?isFullPage=true&moduleId="+data.extraMap["formId"]+"&moduleType=35&rightId=-2&viewState=4");
	    	//}else{
	    	//	$("#templateOperDes").attr("src",_ctxPath+"/edocTempleteController.do?method=systemDetail&templeteId="+templateId);
	    	//}
	  } else if(data.moduleType == 32){
		  $("#left_div").hide();
    	$("#templateOperDes").attr("src",_ctxPath+"/govTemplate/govTemplate.do?method=templateInfoDetail&templateId="+templateId);
      } else{
    	  $("#left_div").hide();
        $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateDetail&templateId="+templateId+"&openFrom=tempConfigFrame");
      }
    }
    
    function rend(txt,data, r, c) {
      if(c === 1){
        if(data.moduleType!=="" && data.moduleType!==null){
          if (data.moduleType == 4 || data.moduleType == 19 || data.moduleType == 20 || data.moduleType == 21 
        		  || data.moduleType == 401 || data.moduleType == 402|| data.moduleType == 404) {
            txt = txt+ "<span class='ico16 red_text_template_16'></span>";
          }else if(data.moduleType == 32){
			// 添加信息报送的图标
        	  txt = txt+ "<span class='ico16 infoTemplate_16'></span>";
          }else {
            if ("workflow" === data.type) {
              txt = txt+ "<span class='ico16 flow_template_16'></span>";
            } else if ("text" === data.type) {
              txt = txt+ "<span class='ico16 format_template_16'></span>";
            } else if ("template" === data.type && "20" === data.bodyType) {
              txt = txt+ "<span class='ico16 form_temp_16'></span>";
            } else {
              txt = txt+ "<span class='ico16 collaboration_16'></span>";
            }
          }
        }
      }
      if (c === 2){
        if(!data.system){
          return "${ctp:i18n('collaboration.showAttributeSet.personalTemplates')}"; //个人模版
        }else if(data.moduleType == '401'){
        	return "发文模板";
        }else if(data.moduleType == '402'){
        	return "收文模板";
        }else if(data.moduleType== '404'){
        	return "签报模板";
        } else if(data.bodyType === "20"){
          return "${ctp:i18n('template.templateConfigFrame.formTemplate')}"; //表单模板
        } else if(data.moduleType == '32'){
		  return "${ctp:i18n('collaboration.info.template.label')}";
        } else{
          return txt;
        }
      }
      return txt;
    }

    //搜索框
    var topSearchSize = 2;
    if($.browser.msie && $.browser.version=='6.0'){
        topSearchSize = 5;
    }
    var searchobj = $.searchCondition({
      top:topSearchSize,
      right:5,
      searchHandler: function(){
        var result = searchobj.g.getReturnValue();
        if(result){
          loadTable(result.condition, result.value);
        }else{
          loadTable();
        }
      },
      conditions: [
        { id: 'subject',
          name: 'subject',
          type: 'input',
          text: "${ctp:i18n('template.categorylist.name.label')}",
          validate: false,
          value: 'subject'
        }
      ]
    });
});

function loadTable(condition, value){
  var o = new Object();
  if(condition && value){
    eval("o."+condition+" = '" + escape(value) +"';");
  }
  $("#collaborationTemplateTable").ajaxgridLoad(o);
}

//删除
function deleteTemplateConfig(ids){
  var callerResponder = new CallerResponder();
  callerResponder.success = function(jsonObj) {
    loadTable();
  };
  callerResponder.sendHandler = function(b, d, c) {
      var confirm = "";
      confirm = $.confirm({
          'msg': "${ctp:i18n('privilege.resource.confirmSubmit.info')}",
          ok_fn: function () {
              b.send(d, c);
          }
      });
  }
  var cm = new collaborationTemplateManager();
  cm.deletePersonalTempleteConfig(ids, callerResponder);
}
function addScrollForIframe(){
	  $("#templateOperDes").css("overflow","scroll");	
  }
  function govdocShowDocPage() {
  	addScrollForIframe();
  	if (nodeId=='') {
  	  return;
  	}
  	var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ nodeId + "&govdocForm=1&viewState=3&moduleType="+nodeModuleType;
  	$(".left>li").removeClass("current");
  	$("#govdocArticleBut").addClass("current");
  	$("#templateOperDes").attr('src', url);
  }
  function showGovdocContent() {
  	var editframe = document.getElementById("editFrame").contentWindow;
  	editframe.dealPopupContentWin();
  }
  //流程图
  function showWorkFlow() {
  	if (workflowId=='') {
  		return;
  	}

  	//根据模板ID去取工作流图
  	$(".left>li").removeClass("current");
  	$("#workFlowBut").addClass("current");
  	var url = _ctxPath+'/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId='
      + workflowId+'&currentUserName='+encodeURIComponent($.ctx.CurrentUser.name );
  	$("#templateOperDes").attr('src', url).css("overflow","hidden");
  }
</script>
</head>
<body>
  <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <!-- <div style="display: block; height: 19px" class="bg_color border_b hidden" >
                <span style="display: inline" class="common_crumbs ">
                    <span class=margin_r_10>${ctp:i18n('template.templateConfigFrame.currentLocation')}:</span><a >${ctp:i18n('template.templateConfigFrame.home')}</a>
                    <span class="common_crumbs_next margin_lr_5">-</span><a>${ctp:i18n('template.templatePub.configurationTemplates')}</a></span>
            </div>-->
            <div id="toolbar"></div> 
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3 " id="collaborationTemplateTable"></table>
            <div id="grid_detail" class="h100b">
            	<div class="common_tabs clearfix" style="display:none" id="left_div">
	                <ul class="left">
						<li id="govdocArticleBut" class="current"><a hidefocus="true" href="javascript:govdocShowDocPage()" class="border_b">${ctp:i18n('template.templateChoose.textAlone')}</a></li><!-- 文单 -->
						<li id="govdocContentBut"><a hidefocus="true" href="javascript:showGovdocContent()">${ctp:i18n('collaboration.summary.text')}</a></li><!-- 新公文正文 -->
	                    <li id="workFlowBut"><a hidefocus="true" href="javascript:showWorkFlow()">${ctp:i18n('collaboration.workflow.label')}</a></li><!-- 流程 -->
	                </ul>
	            </div>
                <iframe id="templateOperDes" width="100%" height="100%" frameborder="0" class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
    	<iframe id="editFrame" name = "editFrame" src="${path }/form/bindDesign.do?method=editFrame" style="display:none"></iframe>
</body>
</html>