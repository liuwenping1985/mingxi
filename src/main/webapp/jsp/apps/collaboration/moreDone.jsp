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
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/portal.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
	//console.log(window.location.href);
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
function peixundone(){

}

function peixunpending(){
    window.location.href='/seeyon/collaboration/pending.do?method=morePending&fragmentId=-7000417139596900184&ordinal=0&currentPanel=sources&rowStr=subject,sendUser&columnsName=培训记录';

}

function kaoqinsent(){
    window.location.href='/seeyon/collaboration/collaboration.do?method=moreSent&fragmentId=3685384193582450260&ordinal=0&rowStr=subject,publishDate,currentNodesInfo&columnsName=考勤记录';
    
    hideTimeLineView();
}
function kaoqinpending(){
    
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
             function todoEdoc(){
                         window.location.href='/seeyon/collaboration/pending.do?method=morePending&fragmentId=-8831171015220966891&ordinal=0&currentPanel=sources&rowStr=subject,deadLine,edocMark,sendUnit,sendUser&columnsName=待办公文';
                        }
                        function doneEdoc(){
							
                            window.location.href='/seeyon/collaboration/collaboration.do?method=moreDone&fragmentId=-2229139237615680120&ordinal=0&rowStr=subject,createDate,receiveTime,edocMark,sendUnit,currentNodesInfo,sendUser,deadline&columnsName=已办公文&isGroupBy=false';
                        }
                         function todoEdoc2(){
                            window.location.href='/seeyon/collaboration/pending.do?method=morePending&fragmentId=-8831171015220966891&ordinal=1&currentPanel=sources&rowStr=subject,deadLine,edocMark,sendUnit,sendUser&columnsName=待阅公文';
                         }
                        function doneEdoc2(){
                           window.location.href='/seeyon/collaboration/collaboration.do?method=moreDone&fragmentId=-2229139237615680120&ordinal=1&rowStr=subject,createDate,receiveTime,edocMark,sendUnit,currentNodesInfo,sendUser,deadline&columnsName=已阅公文&isGroupBy=false';
                        }
             var toolbarmenu = new Array();
             if("${param.columnsName}"=="已办公文"){
             window.parent.$(".layout_content_main_content").css("top","50px");
                        toolbarmenu.push({id: "todo-edoc",name: "待办",className: "ico16 batch_16",click:todoEdoc});
                         toolbarmenu.push({id: "done-edoc",name: "已办",className: "ico16 forwarding_16",click:doneEdoc});

                                   $("#toolbars").toolbar({
                                       borderLeft:false,
                                       borderTop:false,
                                       borderRight:false,
                                       toolbar:toolbarmenu
                                   });
                       }else if("${param.columnsName}"=="已阅公文"){
                        window.parent.$(".layout_content_main_content").css("top","50px");
                         toolbarmenu.push({id: "todo-edoc-2",name: "待阅",className: "ico16 batch_16",click:todoEdoc2});
                         toolbarmenu.push({id: "done-edoc-2",name: "已阅",className: "ico16 forwarding_16",click:doneEdoc2});

            $("#toolbars").toolbar({
                borderLeft:false,
                borderTop:false,
                borderRight:false,
                toolbar:toolbarmenu
            });

                       } else if("${param.columnsName}"=="培训记录"){

                            toolbarmenu.push({id: "todo-edoc-2",name: "已培训事项",className: "ico16 batch_16",click:peixundone});
							toolbarmenu.push({id: "done-edoc-2",name: "待培训",className: "ico16 forwarding_16",click:peixunpending});
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
                    o.section = $.trim($('#section').val());
                    o.isGroupBy = $('#isGroupBy').val();
                    var choose = $('#'+searchobj.p.id).find("option:selected").val();
                    o.condition = choose;
                    if(choose === 'subject'){
                        o.textfield = $.trim($('#title').val());
                    }else if(choose === 'importLevel'){
                        o.textfield = $.trim($('#importent').val());
                    }else if(choose === 'sender'){
                        o.textfield = $.trim($('#sender').val());
                    }else if(choose === 'createDate'){
                        var fromDate = $.trim($('#from_datetime').val());
                        var toDate = $.trim($('#to_datetime').val());
                        o.textfield = fromDate;
                        o.textfield1 = toDate;
                        if(fromDate != "" && toDate != "" && fromDate > toDate){
                            $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
                            return;
                        }
                    }else if(choose === 'dealDate'){
                        var fromDate = $.trim($('#from_dealtime').val());
                        var toDate = $.trim($('#to_dealtime').val());
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
                    text: "${ctp:i18n('cannel.display.column.subject.label')}",//标题
                    value: 'subject',
                    maxLength:100
                }, {
                    id: 'importent',
                    name: 'importent',
                    type: 'select',
                    text: "${ctp:i18n('common.importance.label')}",//重要程度
                    value: 'importLevel',
                    <c:choose>
						<c:when test="${(v3x:getSysFlagByName('col_showRelatedProject') == 'false')}">
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
                    id: 'sender',
                    name: 'sender',
                    type: 'input',
                    text: "${ctp:i18n('common.sender.label')}",//发起人
                    value: 'sender'
                }, {
                    id: 'datetime',
                    name: 'datetime',
                    type: 'datemulti',
                    text: "${ctp:i18n('common.date.sendtime.label')}",//发起时间
                    value: 'createDate',
                    dateTime: false,
                    ifFormat:'%Y-%m-%d'
                }, {
                    id: 'dealtime',
                    name: 'dealtime',
                    type: 'datemulti',
                    text: "${ctp:i18n('common.date.donedate.label')}",//处理时间
                    value: 'dealDate',
                    dateTime: false,
                    ifFormat:'%Y-%m-%d'
                }]
            });
            
            var colModel = new Array();
            var rowStr = "${rowStr}";//需要显示的列
            rowStr = rowStr.split(",");

            
            var len = rowStr.length;
            //计算每一列的宽度，id 占4%，不计算在内
            //默认ID宽度
            var idL = 4;
            //默认宽度（不包含标题）
            var width = 10;
            //默认的标题宽度
            var titleLen = 20;
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
            colModel.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'workitemId',width : idL +'%',isToggleHideShow:false});
            for(var i=0;i<rowStr.length;i++){
                var colNameStr=rowStr[i];
                //标题
                if("subject"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'subject',width : titleLen + '%',sortable : true});
                }
                //公文文号(公文字段)
                if("edocMark" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : width + '%',sortable : true});
                }
                //发文单位 (公文字段)
                if("sendUnit" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.sendUnit.label')}",name : 'sendUnit',width : width + '%',sortable : true});
                }
                //会议地点(会议字段)
                if("placeOfMeeting" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.placeOfMeeting.label')}",name : 'placeOfMeeting',width : width + '%',sortable : true});
                }
                //主持人(会议字段)
                if("theConferenceHost" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.theConferenceHost.label')}",name : 'theConferenceHost',width : width + '%',sortable : true});
                }
                if("createDate" == colNameStr){
                	//发起时间
                    colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'createDate',width : width + '%',sortable : true});
                }
                //处理时间/召开时间
                if("receiveTime" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.doneTime.label')}",name : 'completeTime',width : width + '%',sortable : true});
                }
                
                if("deadline" == colNameStr){
                	//处理期限
                    colModel.push({ display : "${ctp:i18n('common.workflow.deadline.date')}",name : 'deadLine',width : width + '%',sortable : true});
                }
              	//发起人
                if("sendUser" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'createMemberName',width : width + '%',sortable : true});
                }
                //类型 
                if("category" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : width + '%',sortable : true});
                }

              	//当前待办人
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
            function rend(txt, data, r, c, col) {

                if(col.name == "workitemId"){
                    txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
                }
                if(col.name == "subject"){
                    //加图标
                    //重要程度
                    if(data.importantLevel !==null&&data.importantLevel !==""&& data.importantLevel !== 1){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttsFlag === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!=="" && data.bodyType!==null && data.bodyType!=="10" && data.bodyType!=="30" && data.bodyType!=="HTML"){
                    	var bodyType = data.bodyType;
               			var bodyTypeClass = convertPortalBodyType(bodyType,data.applicationCategoryKey);
               			if (bodyTypeClass !="html_16") {
               			    txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
               			}
                    }
                    txt = "<a class='color_black' href='javascript:void(0)' onclick='linkToSummary(\""+data.id+"\",\""+escapeStringToHTML(escapeStringToHTML(data.subject))+"\","+data.applicationCategoryKey+",\""+data.objectId+"\")'>"+txt+"</a>";
                }else if(col.name == "currentNodesInfo"){
                    //增加打开连接
                    if(txt==null){
                    	txt="";
                    }
                    txt=txt.replace("...","");
                    txt = "<a class='color_black' href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.applicationCategoryKey+"\",\""+data.spervisor+"\")'>"+txt+"</a>";
                }else if(col.name == "categoryLabel"){
                	if(data.hasResPerm == true){
                		txt = "<a href='javascript:void(0)' onclick='linkToDone("+data.applicationCategoryKey +")'>"+txt+"</a>";
                	}
                }
                return txt;
           }    
           
        });
        
        function convertPortalBodyType(bodyType,applicationCategoryKey) {
    		var bodyTypeClass = "html_16";
    		if(("FORM"==bodyType || "20"==bodyType)&&isForm(applicationCategoryKey)) {
    			bodyTypeClass = "form_text_16";
    		} else 
    		if("TEXT"==bodyType || "30"==bodyType) {
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
		
        function linkToDone(app){
            if(app === 6){//会议应用
              window.location.href = _ctxPath + "/meetingNavigation.do?method=entryManager&entry=meetingDone";
            }else if(app === 29){//会议室
              window.location.href = _ctxPath + "/meetingroom.do?method=index";
            }else if(app ===19){ //公文-发文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=sendManager&listType=listDoneAll";
            }else if(app ===401||app==402||app==403||app===404){ //新公文
            	if(app===401){
            		window.location.href = _ctxPath + "/govDoc/govDocController.do?method=govDocSend&_resourceCode=F20_govDocSendManage&source=portal&info=done";
            	}else if(app===402){
            		window.location.href = _ctxPath + "/govDoc/govDocController.do?method=govDocReceive&_resourceCode=F20_receiveManage&source=portal&info=done";
            	}else if(app===404){
            		window.location.href = _ctxPath + "/govDoc/govDocController.do?method=govDocSend&isSignReport=true&_resourceCode=F20_receiveManage&source=portal&info=done";
            	}
              
            }else if(app ===20){ //公文-收文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=recManager&listType=listDoneAll";
            }else if(app ===21){ //公文-签报
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=signReport&listType=listDoneAll";
            }else if(app == '24'){ //待登记公文
                url = _ctxPath + "/edocController.do?method=entryManager&entry=recManager&listType=listV5RegisterDone"; 
            }else {
              window.location.href = _ctxPath + "/collaboration/collaboration.do?method=listDone";
            }
        }
        
        function linkToSummary(affairId,subject,app,objectId){
            var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId=" + affairId;
            if(app === 6){//会议应用
              url = _ctxPath + "/mtMeeting.do?method=mydetail&id="+objectId;
            }else if(app === 19 || app === 20 || app === 21){
            	url = _ctxPath + "/edocController.do?method=detailIFrame&from=Done&affairId="+affairId;
            }else if(app === 29){//会议室
              url = _ctxPath + "/meetingroom.do?method=createPerm&openWin=1&id="+objectId;
            }
            getCtpTop().showSummayDialogByURL(url,subject,null);
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north bg_color" id="north">
            <div class="border_lr border_t padding_b_5">
                            <div id="toolbars"> </div>
                        </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="moreList"></table>
        </div>
        <input type="hidden" id="fragmentId" value="${params.fragmentId}"/>
        <input type="hidden" id="ordinal" value="${params.ordinal}"/>
        <input type="hidden" id="state" value="${params.state}"/>
        <input type="hidden" id="isTrack" value="${params.isTrack}"/>
        <input type="hidden" id="section" value="${section}"/>
        <input type="hidden" id="isGroupBy" value="${isGroupBy}"  >
    </div>
</body>
</html>
