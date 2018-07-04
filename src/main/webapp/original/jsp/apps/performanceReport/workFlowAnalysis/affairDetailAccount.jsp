<%--
 $Author:  xiaol$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>

<%-- xuqw注释，这个文件已经被删除了， 有问题找我 <%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %> --%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>协同统计查询</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script>
    <script type="text/javascript" src="${path }/apps_res/workFlowAnalysis/js/workflowAnalysis.js"></script>
    <script type="text/javascript">
    	var win=getA8Top().up;
        var grid;
        $(document).ready(function () {
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

            var toolbarArray = new Array();
             //转发协同
            toolbarArray.push({
                  id: "ForwardCol",
                  name: "${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}",
                  className: "ico16 forwarding_16",
                  click: transmitCol 
            });
            //查看流程
            toolbarArray.push({
                id: "pigeonhole",
                name: "${ctp:i18n('performanceReport.workflow.processflow.view')}",
                className: "ico16 flow_view_16",
                click: showDigarm
            });
            //Excel导出
            toolbarArray.push({
                id: "pigeonhole",
                name: "${ctp:i18n('performanceReport.queryMain.tools.reportToExcel')}",
                className: "ico16 export_excel_16",
                click: exportExcel
            });
            //打印
            toolbarArray.push({
                id: "print",
                name: "${ctp:i18n('collaboration.newcoll.print')}",
                className: "ico16 print_16",
                click: printListCol
            });
            

            //工具栏
            $("#toolbars").toolbar({
                toolbar: toolbarArray
            });
            //表格加载
            grid = $('#listStatistic').ajaxgrid({
                colModel:[{
                    display: "${ctp:i18n('performanceReport.workflow.process.header')}",//流程标题
                    name: 'subject',
                    sortable : true,
                    width: '20%'
                },{
                    display: "${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.runTime')}",//运行时长
                    name: 'runWorkTime',
                    sortable : true,
                    width: '20%'
                },{
                    display: "${ctp:i18n('performanceReport.workFlowAnalysis.charEfficiency')}",//运行效率
                    name: 'efficiency',
                    width: '20%'
                },{
                    display: "${ctp:i18n('performanceReport.workFlowAnalysis.efficiency.workFlowDeadline')}",//流程期限
                    name: 'deadline',
                    sortable : true,
                    width: '20%'
                }, {
                    display: "${ctp:i18n('performanceReport.workflow.timeouts.label')}",//超时时长
                    name: 'overWorkTime',
                    width: '20%'
                }],
                render:rend,
                height: 200,
                showTableToggleBtn: true,
                parentId: $('.layout_center').eq(0).attr('id'),
                vChange: true,
                vChangeParam: {
	                overflow: "hidden",
					autoResize:true
	            },
                isHaveIframe:true,
                slideToggleBtn:true,
                callBackTotle:getTotal,
                managerName : "workFlowAnalysisManager",
                managerMethod : "getComprehensiveList",
                dblclick : showDetail,
      			click : showDetail
            });
            var o=new Object();
        	o.templeteId="${templeteId}";
        	o.beginDate="${beginDate}";
        	o.endDate="${endDate}";
        	$("#listStatistic").ajaxgridLoad(o);
        });    
        function rend(txt, data, r, c) {
        	return "<span class='grid_black'>"+txt+"</span>";
        }
        
        function showDetail(data, r, c){
        	openDetailWindow('${path}',data.id,data.subject,data.appTypeName,'comprehensive');
        }
        
        
   function openDetailWindow(baseUrl,summaryId,subject,_appEnumStr,from) {
  		var title = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";
		var templeteId = "";
		try{
			templeteId = templeteId_;
		}catch(e){
			var hstr = self.location.href;
			templeteId = workflowAnalysisParseParam(hstr,"templeteId");
		}
		if (templeteId == "") {
			alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
			return ;
		}
		var queryParamsAboutApp = "";
		if (_appEnumStr && (_appEnumStr == 'recEdoc' || _appEnumStr == 'sendEdoc'|| _appEnumStr == 'signReport' || 
				_appEnumStr == 'edocSend' || _appEnumStr == 'edocRec' || _appEnumStr == 'edocSign' 
			)) {
			queryParamsAboutApp = "&appName=4&appTypeName="+_appEnumStr;
		}
	  	  
	      queryDialog = $.dialog({
	      	  id: 'url',
	          url: baseUrl+"/performanceReport/WorkFlowAnalysisController.do?method=showFlowNodeDetailFrame&summaryId="+summaryId
				+"&pageFlag="+from+"&templeteId="+templeteId
				+"&subject="+encodeURI(subject)+queryParamsAboutApp,
	          width : $(getCtpTop().document).width()-100,
	          height : $(getCtpTop().document).height()-100,
	          title :title,
	          transParams: {
	        	pwindow : window,
				closeAndForwordToCol: throughListForwardCol
	          },
	          buttons : [ {
	              text : "${ctp:i18n('performanceReport.queryMain_js.button.close')}",//关闭
	              handler : function() {
	            	  queryDialog.close();
	              }
	          } ]
	      });
	}
	
	function throughListForwardCol(content, reportTitle){
		if(queryDialog)
	 		queryDialog.close();
 		$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
 		$('#reportContent').val(content);
 		$('#reportTitle').val(reportTitle);
 		$("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
 		$("#queryConditionForm").submit();
  }
        function getTotal(total){
        	   //页面底部说明加载
            $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listStatistic&size="+total);
        }
        
           //转发协同 
        function transmitCol(){
            gridChangeTable();
            var reportTitle = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
            var contentHtml = $('#center').html();
            getA8Top().up.throughListForwardCol(contentHtml,reportTitle);
        }
        /**
         * 查看流程
         */
        function showDigarm() {
            var templeteId = $("#templeteId").val();
            if (templeteId == "") {
                alert(v3x.getMessage("V3XLang.common_select_templete_process_label"));
                return ;
            }
            $.post("${path}/performanceReport/WorkFlowAnalysisController.do?method=viewWorkflow",{templeteId:templeteId},function(data){
                var ptemplateId=data;
                showWFTDiagram(window,ptemplateId,window);
            });
        }
        //Excel导出
        function exportExcel(){
	        	var templeteId=$("#templeteId").val();
	        	var beginDate=$("#beginDate").val();
	        	var endDate=$("#endDate").val();
 	        	var templeteSubject=encodeURIComponent('综合分析');
	        	var searchForm = document.getElementById("queryConditionForm");
	        	
	        	searchForm.action = "${path}/performanceReport/WorkFlowAnalysisController.do?method=exportProcessExcel&templeteSubject="+templeteSubject+"&templeteId="+templeteId+"&beginDate="+beginDate+"&endDate="+endDate;
	        	searchForm.target = "temp_iframe";
	        	searchForm.submit();
       	 	}

        //打印绩效报表穿透查询列表
        function printListCol(){
            grid.grid.resizeGridUpDown('down');
            var printSubject ="";
            var printsub = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
            printsub = "<center><span style='font-size:24px;line-height:24px;margin-top:10px'>"+printsub+"</span><hr style='height:1px' class='Noprint'></hr></center>";
            
            var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
            var colBody ="<div>"+ $('#center').html() + "</div>";

            var printSubFrag = new PrintFragment(printColBody,printsub);  
            var colBodyFrag= new PrintFragment(printSubject,colBody);  
            var cssList = new ArrayList();
            
            var pl = new ArrayList();
            pl.add(printSubFrag);
            pl.add(colBodyFrag);
            printList(pl,cssList);
        }
        function gridChangeTable() {
          //拖动列表打印样式替换
            var mxtgrid = jQuery(".flexigrid");
            if(mxtgrid.length > 0 ){
                jQuery(".hDivBox thead th div").each(function(){
                    var _html = $(this).html();
                    $(this).parent().html(_html);
                });
                var tableHeader = jQuery(".hDivBox thead");
                
                jQuery(".bDiv tbody td div").each(function(){
                    var _html = $(this).html();
                    $(this).parent().html(_html);
                });
                
                var tableBody = jQuery(".bDiv tbody");
                var str = "";
                var headerHtml =tableHeader.html();
                var bodyHtml = tableBody.html();
                if(headerHtml == null || headerHtml == 'null')
                    headerHtml ="";
                if(bodyHtml == null || bodyHtml=='null'){
                    bodyHtml="";
                }
                if(mxtgrid.hasClass('dataTable')){
                  str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
                }else{
                  str+="<table class='table-header-print' border='0' cellspacing='0' cellpadding='0'>"
                }
                str+="<thead>";
                str+=headerHtml;
                str+="</thead>";
                str+="<tbody>";
                str+=bodyHtml;
                str+="</tbody>";
                str+="</table>";
                var parentObj = mxtgrid.parent();
                mxtgrid.remove();
                parentObj.html(str);
                jQuery(".flexigrid a").removeAttr('onclick');
            }


            function closeCollDealPage(){
                var fromDialog = true;
                var dialogTemp= null;
                try{
                  dialogTemp=window.parentDialogObj['url'];
                }catch(e){
                  fromDialog = false;
                }
                try{
                    window.parent.$('#summary').attr('src','');
                }catch(e){//弹出对话框模式
                    try{
                        if(window.dialogArguments){
                            window.dialogArguments[0].attr('src','');
                        }
                      
                    }catch(e){}
                }
               
                //首页更多
                try{
                  if(window.dialogArguments){
                      if(typeof(window.dialogArguments.callbackOfPendingSection) == 'function'){
                          var iframeSectionId=window.dialogArguments.iframeSectionId;
                          var selectChartId=window.dialogArguments.selectChartId;
                          var dataNameTemp=window.dialogArguments.dataNameTemp;
                          window.dialogArguments.callbackOfPendingSection(iframeSectionId,selectChartId,dataNameTemp);
                          return;
                      }
                      if(typeof(window.dialogArguments.callbackOfEvent) == 'function'){
                        window.dialogArguments.callbackOfEvent();
                        return;
                      }
                  }
                }catch(e){
                }
                if(dialogTemp!=null&&typeof(dialogTemp)!='undefined'){
                    dialogTemp.close();
                }
                //不是dialog方式打开的都用window.close
                if(!fromDialog){
                    window.close();
                }
            }
        }
    </script>
</head>
<body>
    <form id="queryConditionForm" action="" method="post">
		<input type="hidden" id="templeteId" name="templeteId" value="${templeteId }"/>
		<input type="hidden" id="beginDate" name="beginDate" value="${beginDate }"/>
		<input type="hidden" id="endDate" name="endDate" value="${endDate }"/>
    </form>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listStatistic"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
