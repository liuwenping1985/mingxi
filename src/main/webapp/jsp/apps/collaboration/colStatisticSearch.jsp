<%--
 $Author:  zhangxw$
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
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager"></script>
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
            //判断是否有新建协同的资源权限，如果没有则屏蔽转发协同
            if ($.ctx.resources.contains('F01_newColl')) {
                //转发协同
                toolbarArray.push({
                    id: "ForwardCol",
                    name: "${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}",
                    className: "ico16 forwarding_16",
                    click: transmitCol
                 });
            };
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
                colModel: [ {
                    display: "${ctp:i18n('common.subject.label')}",//标题
                    name: 'subject',
                    sortable : true,
                    width: '40%'
                },{
                    display: "${ctp:i18n('cannel.display.column.sendUser.label')}",//发起人
                    name: 'startMemberName',
                    sortable : true,
                    width: '8%'
                }, {
                    display: "${ctp:i18n('common.date.sendtime.label')}",//发起时间
                    name: 'startDate',
                    sortable : true,
                    width: '10%'
                }, {
                    display: '${ctp:i18n("cannel.display.column.receiveTime.label")}',//接收时间
                    name: 'receiveTime',
                    sortable : true,
                    width: '10%'
                }, {
                    display: "${ctp:i18n('common.date.donedate.label')}",//处理时间
                    name: 'dealTime',
                    sortable : true,
                    width: '10%'
                }, {
                    display: "${ctp:i18n('pending.deadlineDate.label')}",//处理期限（节点期限）
                    name: 'deadLineDateName',
                    sortable : true,
                    width: '8%'
                }, {
                    display: "${ctp:i18n('collaboration.track.state')}",//跟踪状态
                    name: 'track',
                    width: '6%'
                },{
                    display: '${ctp:i18n("processLog.list.title.label")}',//流程日志
                    name: 'processId',
                    width: '6%'
                }],
                click: clickRow,
                dblclick: dbclickRow,
                render : rend,
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
                managerName : "colManager",
                managerMethod : "getStatisticSearchCols"
            });
            //页面底部说明加载
            $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listStatistic&size="+grid.p.total);

            function clickRow(data,rowIndex, colIndex) {
            	var openFrom = "F8Reprot";
            	//个人报表时
            	if('${isTeamReport}' !== '1' && data.affair.memberId == '${CurrentUser.id}'){
            		var state = $.trim(data.affair.state);
                	if(state === '2'){
                		openFrom = "listSent";
                	}else if(state === '3'){
                		openFrom = "listPending";
                	}else if(state === '4'){
                		openFrom = "listDone";
                	}
            	}
            	grid.grid.resizeGridUpDown('middle');
                $('#summary').attr("src",getCollDetailUrl(data.affairId,'','',openFrom,''));
            }
            //双击事件
            function dbclickRow(data,rowIndex, colIndex){
            	var openFrom = "F8Reprot";
            	//个人报表时
            	if('${isTeamReport}' !== '1' && data.affair.memberId == '${CurrentUser.id}'){
            		var state = $.trim(data.affair.state);
                	if(state === '2'){
                		openFrom = "listSent";
                	}else if(state === '3'){
                		openFrom = "listPending";
                	}else if(state === '4'){
                		openFrom = "listDone";
                	}
            	}
                var url = getCollDetailUrl(data.affairId,'','',openFrom,'');
                var title = data.subject;
                doubleClick(url,title);
            }
        });

        function rend(txt, data, r, c) {
            if(c === 0){
                //加图标
                //重要程度
                if(data.importantLevel !=="" && data.importantLevel !== 1){
                    txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt;
                }
                //附件
                if(data.hasAttsFlag === true){
                    txt = txt + "<span class='ico16 affix_16'></span>" ;
                }
                //协同类型
                if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                    txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
                }
                //流程状态
                if(data.state !== null && data.state !=="" && data.state != "0"){
                    txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
                }
                //如果设置了处理期限(节点期限),添加超期图标
                if(data.deadLineDateTime != null){
                    if(data.isCoverTime){
                        //超期图标
                        txt = txt + "<span class='ico16 extended_red_16'></span>" ;
                    }else{
                        //未超期图标
                        txt = txt + "<span class='ico16 extended_blue_16'></span>" ;
                    }
                }
            }else if(c===5){
	           	 if(data.isCoverTime){
	                 //超期图标
	                 txt = "<span class='color_red'>"+txt+"</span>" ;
	            }
        	} else if(c === 6){
            	if($.trim(data.track) === '1'){
            		txt = "${ctp:i18n('common.true')}";
            	}else{
            		txt = "${ctp:i18n('common.false')}";
            	}
            }else if (c === 7){
                return "<a class='ico16 view_log_16 noClick' href='javascript:void(0)' onclick='showDetailLogDialog(\""+data.summary.id+"\",\""+data.processId+"\",2)'></a>";
            }
            return txt;
        }
        //转发协同
        function transmitCol(){
            gridChangeTable();
            var reportTitle = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
            //debugger;
            $("#listStatistic > TR, #listStatistic > TD,#listStatistic > TH,#listStatic > TBODY,#listStatistic").each(function(){
				$(this).removeAttr("sizset").removeAttr("sizcache");
            });
            var contentHtml = $("#center").html();
            //contentHtml = contentHtml.replace(/sizset=['"](false|true)['"]/g,"").replace(/sizcache\d*=['"][\d ]*['"]/g,"").replace(/<br\/>/g,"");;
           //alert(contentHtml);
            //contentHtml = escapeStringToHTML(contentHtml);
            contentHtml = contentHtml;
            //alert(contentHtml);
            getA8Top().up.throughListForwardCol(contentHtml.replace(/<(br|BR)\s*\/\s*>/g,""),reportTitle);
        }
        //Excel导出
        function exportExcel(){
            $("#queryConditionForm").attr("action", "${path}/collaboration/collaboration.do?method=exportColSummaryExcel");
            $("#queryConditionForm").submit();
        }

        //打印绩效报表穿透查询列表
        function printListCol(){
            grid.grid.resizeGridUpDown('down');
            var printSubject ="";
            var printsub = "${ctp:i18n('performanceReport.queryMain_js.throughQueryDialog.title')}";//绩效报表穿透查询列表;
            printsub = "<center><span style='font-size:24px;line-height:24px;margin-top:10px'>"+printsub+"</span><hr style='height:1px' class='Noprint'></hr></center>";

            var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
            var colBody ="<div>"+ $('#center').html() + "</div>";
            colBody = colBody.replace(/<div[^>]*?id="?grid_detail"?[^>]*?>[\s\S]*?<\/div>/ig, "");
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
        <input type="hidden" name="bodyType" value="${bodyType}">
        <input type="hidden" name="CollType" value="${CollType}">
        <input type="hidden" name="templateId" value="${templateId}">
        <input type="hidden" name="start_time" value="${start_time}">
        <input type="hidden" name="end_time" value="${end_time}">
        <input type="hidden" name="state" value="${state}">
        <input type="hidden" name="user_id" value="${user_id}">
        <input type="hidden" name="coverTime" value="${coverTime}">
        <input type="hidden" name="isGroup" value="${isGroup}">
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
