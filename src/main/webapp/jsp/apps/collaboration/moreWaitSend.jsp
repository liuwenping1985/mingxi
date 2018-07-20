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
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<c:set value="${ctp:getSystemProperty('edoc.isG6') }" var="isG6Ver" />
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="${path}/ajax.do?managerName=colManager,pendingManager,edocManager"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
  	//服务器时间和本地时间的差异
	var server2LocalTime = <%=System.currentTimeMillis()%> - new Date().getTime();
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
            $("#toolbars").toolbar({
                toolbar: [{
                    id: "send",
                    name: "${ctp:i18n('collaboration.newcoll.send')}",//发送
                    className: "ico16 send_16",
                    click:confirmSend
                },{
                    id: "edit",
                    name: "${ctp:i18n('collaboration.edit.label')}",//编辑
                    className: "ico16 editor_16",
                    click:confirmEdit
                }],
                borderTop:false,
                borderLeft:false,
                borderRight:false
            });
            //搜索框
            var searchobj = $.searchCondition({
                top:33,
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
                        if(fromDate != "" && toDate != "" && fromDate > toDate){
                            $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
                            return;
                        }
                        o.textfield = fromDate;
                        o.textfield1 = toDate;
                    }else if(choose === 'subState'){
                        o.textfield = $.trim($('#subStateName').val());
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
                    id: 'datetime',
                    name: 'datetime',
                    type: 'datemulti',
                    text: "${ctp:i18n('common.date.createtime.label')}",//创建时间
                    value: 'createDate',
                    dateTime: false,
                    ifFormat:'%Y-%m-%d'
                }, {
                    id: "subStateName",
                    name: 'subStateName',
                    type: 'select',
                    text: "${ctp:i18n('common.coll.state.label')}",//状态
                    value: 'subState',
                    items: [{
                        text: '${ctp:i18n("collaboration.substate.3.label")}',//撤销
                        value: '3'
                    }, {
                        text: '${ctp:i18n("collaboration.substate.1.label")}',//草稿
                        value: '1'
                    }, {
                      text: '${ctp:i18n("collaboration.substate.new.2.label")}',//回退 要包含指定回退
                      value: '2,16,18'
                    }]
                  }]
            });
            
            var rowStr = "${rowStr}";//需要显示的列
            var cells = rowStr.split(",");
            var len = cells.length;
            //计算每一列的宽度，id 占4%，不计算在内
            //默认ID宽度
            var idL = 4;
            //默认宽度（不包含标题）
            var width = 10;
            //默认的标题宽度
            var titleLen = 40;
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
          	//定义表格 数据对象
            var colModels = new Array();
            colModels.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'workitemId',width : '4%',isToggleHideShow:false});
            for(var i = 0;i < cells.length;i++){
                var colNameStr = cells[i];
              	//标题
                if("subject" == colNameStr){
                	colModels.push({display: "${ctp:i18n('common.subject.label')}",name: 'subject',sortable : true,width: titleLen + '%'});
                	continue;
                }
              	//创建时间
              	if("receiveTime" == colNameStr){
              		colModels.push({display: "${ctp:i18n('common.date.createtime.label')}",name: 'createDate',sortable : true,width: width + '%'});
              		continue;
              	}
              	//状态
              	if("state" == colNameStr){
              		colModels.push({display: "${ctp:i18n('common.coll.state.label')}",name: 'subState',sortable : true,width: width + '%'});
              		continue;
              	}
              	//类型
              	if("category" == colNameStr){
              		colModels.push({display: "${ctp:i18n('common.resource.body.type.label')}",name: 'categoryLabel',sortable : true,width: width + '%'});
              		continue;
              	}
            }
            //表格加载
            var grid = $('#moreList').ajaxgrid({
                colModel: colModels,
                click: linkToSummary,
                dblclick: dblclickEdit,
                id:'gridId',//给grid设置id，用来控制复选框的选择
                render : rend,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "colManager",
                managerMethod : "getMoreList4SectionContion"
            });
            //定义setTimeout执行方法
            var TimeFn = null;
            //定义单击事件
            function linkToSummary(data,rowIndex, colIndex){
                // 取消上次延时未执行的方法
                clearTimeout(TimeFn);
                var app = data.applicationCategoryKey;
                var affairId = data.id;
                var url;
                if(app == 19 || app == 20 || app == 21){
                    url = _ctxPath + "/edocController.do?method=detailIFrame&from=listWaitSend&affairId="+affairId;
                }else{
                    url= _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listWaitSend&affairId=" + affairId;
                }
                TimeFn = setTimeout(function(){
                    doubleClick(url,data.subject);
                },300);
            }
            //双击事件
            function dblclickEdit(data,rowIndex, colIndex){
                // 取消上次延时未执行的方法
                clearTimeout(TimeFn);
                edit(data.id,data.objectId,data.subState,data.applicationCategoryKey,data.templateId);
            }
            
            //回调函数
            function rend(txt, data, r, c, col) {
                if (col.name=='workitemId'){
                    //if(data.hasResPerm == false){
                    //    txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" disabled class="noClick" row="'+r+'" value="'+data.id+'">';
                    //}else{
                        txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
                    //}
                }
                
                if(col.name=='subject'){
                    //加图标
                    //重要程度
                    if(data.importantLevel != null && data.importantLevel !=="" && data.importantLevel !== 1 
                    		&& data.importantLevel <6 && data.importantLevel > 0){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttsFlag === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //协同类型
                    if($.trim(data.bodyType) !== "" && data.bodyType !== "10" && data.bodyType !== "30"){
                    	var bodyTypeClass = convertPortalBodyType(data.bodyType);
                    	if (bodyTypeClass != "html_16") {
                    		txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
                    	}
                    }
                }else if (col.name=='subState') {
                    var key = "collaboration.substate.new."+data.subState+".label";
                    txt = $.i18n(key);
                    
                } else if(col.name=='categoryLabel'){
                	if(data.hasResPerm == true){
	                    txt = "<a href='javascript:void(0)' onclick='linkToWaitSend(\""+data.applicationCategoryKey+"\")'>"+txt+"</a>";
                	}
                }
                return txt;
           }
            function convertPortalBodyType(bodyType) {
        		var bodyTypeClass = "html_16";
        		if("FORM"==bodyType || "20"==bodyType) {
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
           
           //编辑
           function confirmEdit(){
               var rows = grid.grid.getSelectRows();
               var count = rows.length;
               if(count == 0){
                   //请选择要编辑的事项
                   $.alert("${ctp:i18n('collaboration.grid.alert.selectEdit')}");
                   return;
               }
               if(count > 1){
                   //只能选择一条事项进行编辑
                   $.alert("${ctp:i18n('collaboration.grid.alert.selectOneEdit')}");
                   return;
               }
               var affairId = rows[0].id;
               var summaryId = rows[0].objectId;
               var subState = rows[0].subState;
               var app=rows[0].applicationCategoryKey;
               var templateId = rows[0].templateId;
               edit(affairId,summaryId,subState,app,templateId);
           }
           function edit(affairId,summaryId,subState,app,templateId){
        	   if(app == 1 && !$.ctx.resources.contains('F01_newColl') && templateId == 'null') {
                   $.alert($.i18n('collaboration.listWaitSend.noNewCol'));
                   return false;
               }
               var backBoxToEdit = false;
               //退回和指定退回的数据在待发中编辑的时候不能调用模板
               if(subState==2||subState==16||subState==18){
        		   backBoxToEdit=true;
        	   }
               if(app == 1 && !$.ctx.resources.contains('F01_newColl') && !templateId) {
                   $.alert("${ctp:i18n('collaboration.listWaitSend.noNewCol')}");
                   return false;
               }
               if(app == 19 && !$.ctx.resources.contains('F07_sendNewEdoc')){ //发文
                   $.alert("${ctp:i18n('alert_not_edoccreate')}");
                   return false;
               }else if( app == 20 ){//收文
				   if("${isG6Ver}"=="false" && !$.ctx.resources.contains('F07_recRegister' )){
					   $.alert("${ctp:i18n('alert_not_edocregister')}");
	                   return false;
				   }
				   if("${isG6Ver}"=="true" && !$.ctx.resources.contains('F07_recListFenfaing' )){
					   $.alert("${ctp:i18n('edoc.alert_not_edocfengfa')}");
	                   return false;
				   }
                   
               }else if(app == 21 && !$.ctx.resources.contains('F07_signNewEdoc')){//签报
                   $.alert("${ctp:i18n('alert_not_edoccreate')}");
                   return false;
               }
               
               if(app == 19){ //发文
            	   window.location =_ctxPath + "/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&from=newEdoc&summaryId="+summaryId+"&edocType=0&affairId="+affairId+"&isSendBackBox=false&backBoxToEdit="+backBoxToEdit;
               }else if(app == 20){//收文
            	   window.location =_ctxPath + "/edocController.do?method=entryManager&entry=recManager&recListType=listDistribute&toFrom=newEdoc&from=newEdoc&summaryId="+summaryId+"&edocType=1&affairId="+affairId+"&isSendBackBox=false&backBoxToEdit="+backBoxToEdit;
               }else if(app == 21){//签报
            	   window.location =_ctxPath + "/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&from=newEdoc&summaryId="+summaryId+"&edocType=2&affairId="+affairId+"&isSendBackBox=false&backBoxToEdit="+backBoxToEdit;
               }else{
            	   editCol(affairId,summaryId,subState);  
               }
               
           }
           //发送
           function confirmSend(){
               var rows = grid.grid.getSelectRows();
               var count = rows.length;
               if(count == 0){
                   //请选择要发送的事项
                   $.alert("${ctp:i18n('collaboration.moreWaitSend.selectSend')}");
                   return;
               }
               if(count > 1){
                   //只能选择一条事项进行发送
                   $.alert("${ctp:i18n('collaboration.moreWaitSend.selectOneSend')}");
                   return;
               }

               var app=rows[0].applicationCategoryKey;
               if(app == 1 && !$.ctx.resources.contains('F01_newColl') && rows[0].templateId == 'null') {
                   $.alert($.i18n('collaboration.listWaitSend.noNewCol'));
                   return false;
               }
               if(app == 19 && !$.ctx.resources.contains('F07_sendNewEdoc')){ //发文
                   $.alert("${ctp:i18n('alert_not_edoccreate')}");
                   return false;
               }else if(app == 20 && !$.ctx.resources.contains('F07_recRegister')){//收文
            	   if("${isG6Ver}"=="false" && !$.ctx.resources.contains('F07_recRegister' )){
					   $.alert("${ctp:i18n('alert_not_edocregister')}");
	                   return false;
				   }
				   if("${isG6Ver}"=="true" && !$.ctx.resources.contains('F07_recListFenfaing' )){
					   $.alert("${ctp:i18n('edoc.alert_not_edocfengfa')}");
	                   return false;
				   }
               }else if(app == 21 && !$.ctx.resources.contains('F07_signNewEdoc')){//签报
                   $.alert("${ctp:i18n('alert_not_edoccreate')}");
                   return false;
               }
               send();
           }
           function send(){
               var rows = grid.grid.getSelectRows();
               var affairId = $.trim(rows[0].id);
               var summaryId = $.trim(rows[0].objectId);
               var app=$.trim(rows[0].applicationCategoryKey);
               $("#summaryId").val(summaryId);
               $("#affairId").val(affairId);
               //检查流程期限是不是比当前日期早
               var deadlineDatetime=rows[0].processDatetime;
               if(typeof(deadlineDatetime)!="undefined"){
                 var nowDatetime=new Date();
                 if(deadlineDatetime && (nowDatetime.getTime()+server2LocalTime) > new Date(deadlineDatetime.replace(/-/g,"/")).getTime()){
                   $.alert($.i18n('collaboration.deadline.sysAlert'));
                   return;
                 }
               }
       
               if(app == 19 ||app == 20 ||app == 21){//公文的直接发送

              	  var objectId = $.trim(rows[0].objectId);
            	  var _edocManager = new edocManager();
          
            	  var isQuick = _edocManager.isQuickSend(objectId,{
	
						success:function(_isQuick){
							if(_isQuick == 'true'){
								if(app == 19){
									$.alert($.i18n("edoc.send.alert.isquickSend"));
						            return;
						    	}else if(app == 20){
						    		$.alert($.i18n("edoc.send.alert.isquickEdocRec"));
						            return;
						    	}
							}else{
								sendFromWaitSend(summaryId,affairId,app);
							}
						},
						error : function(request, settings, e){
		                    $.alert(e);
		                }
                	  });
               }else{//其他模块的直接发送
                   //查询processId
                   var colM = new colManager();
                   colM.getSummaryById(summaryId,{
                        success: function(data){
                            var templeteId = $.trim(data.templeteId);
                            var processId = $.trim(data.processId);
                            var bodyType = $.trim(rows[0].bodyType);
                            var newflowType = data.newflowType;
                            if(templeteId != "" && rows[0].subState != '16' && newflowType != '2'){
                               if(!(checkTemplateCanUse(templeteId))){
                                    $.alert("${ctp:i18n('template.cannot.use')}");
                                    return;
                                }
                             }
                            sendFromWaitSendList(bodyType,processId,templeteId,summaryId);
                            try{closeOpenMultyWindow(affairId,false);}catch(e){};
                        }
                   })
               }
           }
        });
        
        function linkToWaitSend(app){
        	//公文
            if(app == 19 || app==20 || app==21||app==401||app==402||app==403 ){
              var edocType = 0;
              if(app == 19){
              	edocType = 0;
              	url = "/edocController.do?method=entryManager&entry=sendManager&toFrom=listWaitSend&edocType=0";
              }else if(app == 20){
            	url = "/edocController.do?method=entryManager&entry=recManager&toFrom=listWaitSend&edocType=1";
              }else if(app==401||app==402||app==403){
              	 url="/collaboration/collaboration.do?method=listWaitSend&app=4&_resourceCode=F20_govDocWaitSend";
              }else{
            	url = "/edocController.do?method=entryManager&entry=signReport&toFrom=listWaitSend&edocType=2";
              }
            }else{
                url = "/collaboration/collaboration.do?method=listWaitSend";
            }
            window.location.href = _ctxPath + url;
        }
        
        //公文的直接发送
        function sendFromWaitSend(summaryId,affairId,app) {
        	$("#sendForm").attr("action", _ctxPath + "/edocController.do?method=sendImmediate&clickFrom=portal&summaryId="+summaryId+"&affairId="+affairId+"&app="+app+"&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&rowStr=${param.rowStr}&columnsName=${ctp:encodeURI(columnsName)}");
           $("#sendForm").jsonSubmit();
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north bg_color" id="north">
            <div class="clearfix">
                <span class="left color_gray2 font_size24 padding_l_10 padding_t_5 font_bold">${ctp:toHTML(columnsName)}${ctp:i18n_1('common.items.count.label',total)}</span><!-- 待发事项 -->
            </div>
            <div id="toolbars"> </div>  
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="moreList"></table>
        </div>
        <input type="hidden" id="fragmentId" value="${params.fragmentId}"/>
        <input type="hidden" id="ordinal" value="${params.ordinal}"/>
        <input type="hidden" id="state" value="${params.state}"/>
        <input type="hidden" id="isTrack" value="${params.isTrack}"/>
    </div>    
    <!-- 点击发送时 调用该域 -->
    <form id="sendForm" method="post">
        <input type="hidden" id="affairId" name="affairId"/>
        <input type="hidden" id="summaryId" name="summaryId"/>
    </form>
    <div id="workflow_definition" style="display: none">
	    <input type="hidden" id="process_desc_by">
	    <input type="hidden" id="process_xml">
	    <input type="hidden" id="readyObjectJSON">
	    <input type="hidden" id="workflow_data_flag" name="workflow_data_flag" value="WORKFLOW_SEEYON">
	    <input type="hidden" id="process_info">
	    <input type="hidden" id="process_subsetting">
	    <input type="hidden" id="moduleType" value='1' >
	    <input type="hidden" id="workflow_newflow_input">
	    <input type="hidden" id="process_rulecontent"/>
	    <input type="hidden" id="workflow_node_peoples_input">
	    <input type="hidden" id="workflow_node_condition_input">
    </div>
</body>
</html>
