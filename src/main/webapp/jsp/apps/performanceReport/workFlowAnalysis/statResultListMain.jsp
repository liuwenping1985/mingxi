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
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>协同统计查询</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=workFlowAnalysisManager"></script>
    <script type="text/javascript">
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
            if("${isAdmin}"=='false'){
            	 toolbarArray.push({
                     id: "ForwardCol",
                     name: "${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}",
                     className: "ico16 forwarding_16",
                     click: transmitCol 
                });
            }
            
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
                colModel:getColumn(),
                render:rend,
                height: 200,
                showTableToggleBtn: true,
                parentId: $('.layout_center').eq(0).attr('id'),
               // vChange: true,
                vChangeParam: {
	                overflow: "hidden",
					autoResize:true
	            },
                isHaveIframe:true,
                slideToggleBtn:true,
                usepager: true,
                callBackTotle:getTotal,
                managerName : "workFlowAnalysisManager",
                managerMethod : "getWorkStateList"
            });
            var o = new Object();
            o.appType="${appType}";   
            o.entityId="${entityId}";
            o.entityType="${entityType}";
            o.state="${state}";
            o.beginDate="${beginDate}";
            o.endDate="${endDate}";
            o.templateId="${templateId}";
            o.statScope="${statScope}";
            $("#listStatistic").ajaxgridLoad(o);
        });    
        
        function getTotal(total){
     	   //页面底部说明加载
         $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listStatistic&size="+total);
     	}
        function getColumn(){
        	var state="${state}";
        	var arr = new Array();
     	 	var object1 = new Object();
     	 	object1.display="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}"
      		object1.name = "subject";
      		object1.sortable = true;
      		if(state=='4'){
	      		object1.width='22%'
      		}else{
      			object1.width='25%';
      		}
      		arr.push(object1);
      		
      		object1 = new Object()
      		object1.display="${ctp:i18n('performanceReport.workFlowAnalysis.create.person')}"
      		object1.name = "sender";
      		object1.sortable = true;
      		if(state=='2'){
      			object1.width='25%'
      		}else if(state=='3'){
      			object1.width='13%'
      		}else{
      			object1.width='8%'
      		}
      		arr.push(object1);
      		
      		if(state!='-1'){
      			object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.queryMain.textbox.sendTime.name')}"
      			object1.name = "createTime";
      			object1.sortable = true;
      			if(state=='2'){
      				object1.width='25%'
      			}else{
      				object1.width='15%'
      			}
      			arr.push(object1);
        	}
        	if(state!=2){
        		object1 = new Object()
      			object1.display="${ctp:i18n('common.workflow.handler')}"
      			object1.name = "hander";
      			object1.sortable = true;
      			if(state=='2'){
      				object1.width='25%'
      			}else if(state=='3'){
      				object1.width='13%'
      			}else{
      				object1.width='8%'
      			}
      			arr.push(object1);
        	}
        	
        	if(state=='-1'||state=="3"){
        		object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workflow.recevie.time')}"
      			object1.name = "receviewTime";
      			object1.sortable = true;
      			object1.width='15%'
      			arr.push(object1);
        	}
        	
        	if(state=='-1'||state=='4'){
        	    object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workFlowAnalysis.runWorkTim')}"//处理时间
      			object1.name = "completeTime";
      			object1.sortable = true;
      			object1.width='15%'
      			arr.push(object1);
        	}
        	
        	if(state=='4'){
        		object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workflow.dealTime.date')}"
      			object1.name = "dealline";
      			object1.sortable = true;
      			object1.width='15%'
      			arr.push(object1);
        	}
        	if(state=='-1'){
        		object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workflow.timeouts.label')}"//超时时长
      			object1.name = "overWorkTime";
      			object1.sortable = true;
      			object1.width='15%'
      			arr.push(object1);
        	}
        	
        	if(state!=='1'&&state!='2'){
        	    object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workflow.processing.period')}"//处理期限
      			object1.name = "processDate";
      			object1.sortable = true;
      			if(state=='4'){
      				object1.width='10%'
      			}else if(state=='-1'){
      				object1.width='10%'
      			}else{
      				object1.width='17%'
      			}
      			arr.push(object1);
        	}
        	
        	if(state != '3'){
        		object1 = new Object()
      			object1.display="${ctp:i18n('performanceReport.workFlowAnalysis.isfinished')}"
      			object1.name = "isfinished";
      			object1.sortable = true;
      			if(state=='2'){
      				object1.width='25%'
      			}else if(state=='4'){
      				object1.width='10%'
      			}
      			arr.push(object1);
        	}
     		return arr;
        }
        function rend(txt, data, r, c) {
           return "<span class='grid_black'>"+txt+"</span>";
        }
        
        //转发协同 
        function transmitCol(){
            gridChangeTable();
            var reportTitle = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
            var contentHtml = $('#center').html();
            getA8Top().up.throughListForwardCol(contentHtml,reportTitle);
        }
        //Excel导出
        function exportExcel(){
				var searchForm = document.getElementById("queryConditionForm");
				var url = "${path}/performanceReport/WorkFlowAnalysisController.do?method=exportExcelWorkflowState";
				searchForm.action = url;
				searchForm.target = "temp_iframe";
				searchForm.submit();
       	 	}

        //打印绩效报表穿透查询列表
        function printListCol(){
            grid.grid.resizeGridUpDown('down');
            var printSubject ="";
			var printsub = "";
			try{
				printsub = window.parentDialogObj.url.title;
			}catch(e){
				printsub = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
			}
            printsub = "<center><span style='font-size:24px;line-height:24px;margin-top:10px'>"+printsub+"</span><hr style='height:1px' class='Noprint'></hr></center>";
            printsub = printsub + " <input type='hidden' id='myprint' name='myprint'></input>";
            var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
            var colBody ="<div>"+ $('#center').html() + "</div>";

            var printSubFrag = new PrintFragment(printColBody,printsub);  
            var colBodyFrag= new PrintFragment(printSubject,colBody);  
            var cssList = new ArrayList();
            cssList.add("/apps_res/collaboration/css/collaboration.css");
            
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
    	<input type="hidden" id="appType" name="appType" value="${appType }"/>
		<input type="hidden" id="entityType" name="entityType" value="${entityType }"/>
		<input type="hidden" id="entityId" name="entityId" value="${entityId }"/>
		<input type="hidden" id="state" name="state" value="${state }"/>
		<input type="hidden" id="beginDate" name="beginDate" value="${beginDate }"/>
		<input type="hidden" id="endDate" name="endDate" value="${endDate }"/>
		<input type="hidden" id="templateId" name="templateId" value="${templateId }"/>
		<input type="hidden" id="appName" name="appName" value="${appName }"/>
		<input type="hidden" id="statScope" name="statScope" value="${statScope }"/>
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
