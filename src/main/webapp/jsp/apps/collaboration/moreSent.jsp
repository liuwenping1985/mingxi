<%--
 $Author:  翟锋$
 $Rev:  $
 $Date:: 2012-12-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/portal.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
	function loadTitle(total) {
				 
                      //栏目更多样式调整
                        var titleTipFlag = ${param.from eq 'Agent'};
                        var titleTip;
                        if("${param.columnsName}"!="" && "${param.columnsName}"!="null") {
                        	titleTip = "${param.columnsName}" + "(" + total+ "项)";
                        } else {
            	            if(titleTipFlag){
            	                titleTip = "${ctp:i18n_1('collaboration.protal.more.agent.label','"+total+"')}";
            	            }else{
            	            	titleTip = "${ctp:i18n_1('collaboration.protal.more.pending.label','"+total+"')}";
            	            }
                        }
					
                        getCtpTop().showMoreSectionLocation(titleTip);
              }
        $(document).ready(function () {
          getCtpTop().hideLocation(); 
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 65,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
			function showTimeLineView(){
				
				$("#timeLineView").attr("height","100%");
				$("#timeLineView").css("height","100%");
				$("#timeLineView").show();
				$("#center").hide();
			}
			function hideTimeLineView(){
				$("#center").show();
				$("#timeLineView").hide();
			}
			function createEdoc(){
				
				hideTimeLineView();
				
			}
		
            function doneEdoc(){
                window.location.href='/seeyon/collaboration/pending.do?method=morePending&fragmentId=2487048259612723566&ordinal=0&currentPanel=sources&rowStr=subject,receiveTime,sendUse&columnsName=考勤记录';
                hideTimeLineView();
            }
			function todoEdoc2(){
				hideTimeLineView();
			}
			function doneEdoc2(){
				hideTimeLineView();
			}
			function createKaoqin(){
               
                $.get("/seeyon/rikaze.do?method=getUserLevelName",function(data){

                   
                    var level = data.level;
                    if(level.name=="正地"||level.name=="副地"){
                        window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=-4342177955300749683");
                    }else if(level.name=="正县"||level.name=="副县"){
                        window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=1564627605772716658");
                    }else {
                        window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=3678542318590706209");
                    }

                });
				
            }
            function getStatKaoqin(){
                window.open("/seeyon/report/queryReport.do?method=goIndexRight&reportId=-3712757300794145459&type=query");
            }
            function getQueryKaoqin(){
                window.open("/seeyon/form/queryResult.do?method=queryExc&hidelocation=false&type=query&queryId=-7609051453161517870");
            }
            function getStatPeixun(){
                window.open("/seeyon/report/queryReport.do?method=goIndexRight&reportId=2852760056941922668&type=query");
            }
            function getQueryPeixun(){
                window.open("/seeyon/form/queryResult.do?method=queryExc&hidelocation=false&type=query&queryId=-2647021732741689992");
            }
			function createPeixun(){
				window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=-2371613798075315656");
			}
			function timelineView(){
				
				showTimeLineView();
				
			}

			 var toolbarmenu = new Array();
             if("${param.columnsName}"=="考勤记录"){
             window.parent.$(".layout_content_main_content").css("top","50px");
				
                        toolbarmenu.push({id: "create-edoc",name: "已发",className: "ico16 sent_16",click:createEdoc});
                        toolbarmenu.push({id: "done-edoc",name: "待处理",className: "ico16 forwarding_16",click:doneEdoc});
						toolbarmenu.push({id: "done-edoc",name: "新建",className: "ico16 new_16",click:createKaoqin});
                        toolbarmenu.push({id: "done-edoc",name: "工作日记",className: "ico16 batch_16",click:timelineView});
                        toolbarmenu.push({id: "done-edoc",name: "考勤查询",className: "ico16 batch_16",click:getQueryKaoqin});
                        toolbarmenu.push({id: "done-edoc",name: "考勤统计",className: "ico16 batch_16",click:getStatKaoqin});
                        $("#toolbars").toolbar({
                            borderLeft:false,
                            borderTop:false,
                            borderRight:false,
                            toolbar:toolbarmenu
                         });
                       }else if("${param.columnsName}"=="培训记录"){
                        window.parent.$(".layout_content_main_content").css("top","50px");
							toolbarmenu.push({id: "todo-edoc-2",name: "已培训事项",className: "ico16 batch_16",click:todoEdoc2});
							toolbarmenu.push({id: "done-edoc-2",name: "待培训",className: "ico16 forwarding_16",click:doneEdoc2});
                            toolbarmenu.push({id: "done-edoc-2",name: "新建",className: "ico16 forwarding_16",click:createPeixun});
                            toolbarmenu.push({id: "done-edoc",name: "培训查询",className: "ico16 batch_16",click:getQueryPeixun});
                            toolbarmenu.push({id: "done-edoc",name: "培训统计",className: "ico16 batch_16",click:getStatPeixun});

            $("#toolbars").toolbar({
                borderLeft:false,
                borderTop:false,
                borderRight:false,
                toolbar:toolbarmenu
            });
           }
            //搜索框
            var searchobj = $.searchCondition({
                top:2,
                right:10,
                searchHandler: function(){
                    var o = new Object();
                    o.fragmentId = $.trim($('#fragmentId').val());
                    o.state = $.trim($('#state').val());
                    o.ordinal = $.trim($('#ordinal').val());
                    o.isTrack = $.trim($('#isTrack').val());
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    o.condition = choose;
                    if(choose === 'subject'){
                        o.textfield = $.trim($('#title').val());
                    }else if(choose === 'importLevel'){
                        o.textfield = $.trim($('#importent').val());
                    }else if(choose === 'createDate'){
                        var fromDate = $.trim($('#from_datetime').val());
                        var toDate = $.trim($('#to_datetime').val());
                        o.textfield = fromDate;
                        o.textfield1 = toDate;
                        if(fromDate != "" && toDate != "" && fromDate > toDate){
                            $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
                            return;
                        }
                    }
                    var val = searchobj.g.getReturnValue();
                    if(val !== null){
                        $("#moreList").ajaxgridLoad(o);
                    }
                },
                conditions: [{
                    id: 'title',
                    name: 'title',
                    type: 'input',
                    text: '${ctp:i18n("cannel.display.column.subject.label")}',//标题
                    value: 'subject',
                    maxLength:100
                }, {
                    id: 'importent',
                    name: 'importent',
                    type: 'select',
                    text: '${ctp:i18n("common.importance.label")}',//重要程度
                    value: 'importLevel',
                    <c:choose>
						<c:when test="${(v3x:getSysFlagByName('col_showRelatedProject') == false)}">
					items: [{
                        text: "${ctp:i18n('common.importance.putong')}",//普通
                        value: '1'
                    }, {
                        text: "${ctp:i18n('collaboration.pendingsection.old.importlevl.pingAnxious')}",//重要（协同、表单
                        value: '2'
                    }, {
                        text: "${ctp:i18n('collaboration.pendingsection.old.importlevl.important')}",//非常重要（协同、表单）
                        value: '3'
                    }]
						</c:when>
				    	<c:otherwise>
				    items: [{
                        text: "${ctp:i18n('common.importance.putong')}",//普通
                        value: '1'
                    }, {
                        text: "${ctp:i18n_1('collaboration.pendingsection.importlevl.pingAnxious',i18nValue2)}",//--平急（公文）/重要（协同、表单
                        value: '2'
                    }, {
                        text: "${ctp:i18n('collaboration.pendingsection.importlevl.important')}",//加急 (公文)/非常重要（协同、表单）
                        value: '3'
                    }, {
                        text: "${ctp:i18n('collaboration.pendingsection.importlevl.urgent')}",//特急（公文）
                        value: '4'
                    }, {
                        text: "${ctp:i18n('collaboration.pendingsection.importlevl.teTi')}",//-特提（公文）
                        value: '5'
                    }]
				    	</c:otherwise>
				    </c:choose>
                },{
                    id: 'datetime',
                    name: 'datetime',
                    type: 'datemulti',
                    text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
                    value: 'createDate',
                    dateTime: false,
                    ifFormat:'%Y-%m-%d'
                }]
            });
            var colModel = new Array();
            var rowStr = "${param.rowStr}";//需要显示的列
            rowStr = rowStr.split(",");

            var len = rowStr.length;
            //计算每一列的宽度，id 占4%，不计算在内
            //默认ID宽度
            var idL = 4;
            //默认宽度（不包含标题）
            var width = 10;
            //默认的标题宽度
            var titleLen = 50;
            //总宽度，总宽度 = 98 - ID宽度-默认标题宽度(其中的2%留给纵向的滚动条)
            var totalL = 98 - idL - titleLen;
            //取余,余数将被计算到标题的宽度上
            var s = totalL%len;
            if(s == 0){
            	width = totalL/len;
            	titleLen += width; 
            }else{
            	width = (totalL-s)/len;
            	titleLen += width +s ;
            }
            colModel.push({display: 'id',name: 'workitemId',width: '4%',type: 'checkbox',isToggleHideShow:false});
            for(var i=0;i<rowStr.length;i++){
                var colNameStr=rowStr[i];
                //标题
                if("subject"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'subject',width : titleLen + '%',sortable : true});
                }
                if("publishDate" == colNameStr){
                	//发起时间
                    colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'createDate',width : width + '%',sortable : true});
                }
                //公文文号(公文字段)
                if("edocMark" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : width + '%',sortable : true});
                }                
              	
                //类型 
                if("category" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : width + '%',sortable : true});
                }
                if("currentNodesInfo" == colNameStr){       
                	colModel.push({ display : "${ctp:i18n('collaboration.list.currentNodesInfo.label')}",name : 'currentNodesInfo',width : width + '%',sortable : true});
                }
            }
            //表格加载
            var grid = $('#moreList').ajaxgrid({
                colModel: colModel,
                render : rend,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "colManager",
                managerMethod : "getMoreList4SectionContion"
            });
			loadTitle(grid.p.total);
            //回调函数
            function rend(txt, data, r, c,col) {
                if(col.name == "subject"){
                    //加图标
                    //重要程度
                    if(data.importantLevel != null && data.importantLevel !==""&& data.importantLevel !== 1
                            && data.importantLevel <6 && data.importantLevel > 0){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttsFlag === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                    	var bodyTypeClass = convertPortalBodyType(data.bodyType,data.applicationCategoryKey);
                    	if (bodyTypeClass !="html_16") {
                    		txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
                    	}
                    }
                    txt = "<a class='color_black' href='javascript:void(0)' onclick='linkToSummary(\""+data.id+"\",\""+escapeStringToHTML(escapeStringToHTML(data.subject))+"\","+data.applicationCategoryKey+")'>"+txt+"</a>";
                }else if(col.name == "categoryLabel"){
                	if(data.hasResPerm == true){
	                    txt = "<a href='javascript:void(0)' onclick='linkToSent("+data.applicationCategoryKey +")'>"+txt+"</a>";
                	}
                }else if(col.name == "currentNodesInfo"){
                    //增加打开连接
                    if(txt==null){
                    	txt="";
                    }
                    if(data.processId != 0){
                    	txt = "<a class='color_black' href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.applicationCategoryKey+"\",\""+data.spervisor+"\")'>"+txt+"</a>";
                    }
                } 
                return txt;
           }    
           
        });
        function linkToSent(app){
            if(app ===19){ //公文-发文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=sendManager&listType=listSent";
            }else if(app ===20){ //公文-收文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=recManager&listType=listSent";
            }else if(app ===21){ //公文-签报
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=signReport&listType=listSent";
            }else if(app ===401||app==402||app==403||app==404){ //公文-签报
              window.location.href = _ctxPath + "/govDoc/govDocController.do?method=listSent&app=4&_resourceCode=F20_gocDovSend";
            }else {
              window.location.href = _ctxPath + "/collaboration/collaboration.do?method=listSent";
            }
        }
        
        function convertPortalBodyType(bodyType,applicationCategoryKey) {
    		var bodyTypeClass = "html_16";
    		if(("FORM"==bodyType || "20"==bodyType)&&isForm(applicationCategoryKey)) {
    			bodyTypeClass = "form_text_16";
    		} else if("TEXT"==bodyType || "30"==bodyType) {
    			bodyTypeClass = "txt_16";
    		} else if("OfficeWord"==bodyType || "41"==bodyType) {
    			bodyTypeClass = "doc_16";
    		} else if("OfficeExcel"==bodyType || "42"==bodyType) {
    			bodyTypeClass = "xls_16";
    		} else if("WpsWord"==bodyType || "43"==bodyType) {
    			bodyTypeClass = "wps_16";
    		} else if("WpsExcel"==bodyType || "44"==bodyType) {
    			bodyTypeClass = "xls2_16";
    		} else if("Pdf" == bodyType || "45"==bodyType) {
    			bodyTypeClass = "pdf_16";
    		} else if("videoConf" == bodyType) {
    			bodyTypeClass = "meeting_video_16";
    		}
    		return bodyTypeClass;
    	}
        function isForm(applicationCategoryKey){
        	if(applicationCategoryKey&&(applicationCategoryKey=="400"||applicationCategoryKey=="401"||
        			applicationCategoryKey=="402"||applicationCategoryKey=="403"||applicationCategoryKey=="404")){
        		return false;
        	}
        	return true;
        }
        function linkToSummary(affairId,subject,app){
            var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listSent&affairId=" + affairId;
            if(app === 19 || app === 20 || app === 21){
                //公文已发详细from参数值统一改为listSent
            	url = _ctxPath + "/edocController.do?method=detail&from=listSent&affairId="+affairId;
            }
            var width = $(getA8Top().document).width() - 60;
            var height = $(getA8Top().document).height() - 50;
            getCtpTop().showSummayDialogByURL(url,subject,null);
        }
        
    </script>
	<style>
	.flex2222{
		top:30px !important;
	}
	
	</style>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north bg_color" id="north">
            <div class="border_lr border_t padding_b_5">
                            <div id="toolbars"> </div>
                        </div>
        </div>
		
        <div class="layout_center flex2222 over_hidden" style="top:30px" id="center">
            <table  class="flexme3" id="moreList"></table>
			
        </div>
		<iframe  id="timeLineView" style="width:100%;height:90%;margin-top:50px" src="/seeyon/calendar/calEvent.do?method=calEventView4Rkz&type=month"></iframe>
        <input type="hidden" id="fragmentId" value="${params.fragmentId}"/>
        <input type="hidden" id="ordinal" value="${params.ordinal}"/>
        <input type="hidden" id="state" value="${params.state}"/>
        <input type="hidden" id="isTrack" value="${params.isTrack}"/>
        
    </div>
    </div>
</body>
</html>
