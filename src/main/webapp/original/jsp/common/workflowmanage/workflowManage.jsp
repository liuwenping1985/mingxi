<%--
 $Author: zhangxw $
 $Rev: 2034 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>流程管理</title>
    <%-- <link rel="stylesheet" type="text/css" href="../../../css/common.css">
    <script type="text/javascript" src="${path}/common/js/ui/calendar/calendar-zh-debug.js"></script>
    <script type="text/javascript" src="../../../ctp/i18n-debug.js"></script> --%>

    <script type="text/javascript" src="${path}/ajax.do?managerName=workflowManageManager"></script>
    <script type="text/javascript">
    function getOperationTypeValue(){
    	if($("#selfCreate").attr("checked")=="checked"){
    		return $("#selfCreate").val();
    	}
    	if($("#templateFlow").attr("checked")=="checked"){
    		return $("#templateFlow").val();
    	}
    }
    	function search(flag){
    		if(!validate()){
    		    $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能大于结束时间
    			return;
    		}
    		var o = new Object();
    		if(flag=="refresh"){
    			o.condition=$("#conditionValue").val();
        	    o.subject=$("#subjectValue").val();
        	    o.senders=$("#sendersValue").val();
        	    o.flowstate=$("#flowstateValue").val(); 
        	    o.beginDate=$("#beginDateValue").val();
        	    o.endDate=$("#endDateValue").val();
        	    o.operationType=$("#operationTypeValue").val();
        	    o.operationTypeIds=$("#operationTypeIdsValue").val();
    		}else{
    		  o.condition=$("#condition").val();
    	      o.subject=$("#subject").val();
    	      o.senders=$("#sendersStr").val();
    	      o.flowstate=$("input[name='flowstate']:checked").val(); 
    	      o.beginDate=$("#beginDate").val();
    	      o.endDate=$("#endDate").val();
    	      o.operationType=getOperationTypeValue();
    	      o.operationTypeIds=$("#operationTypeIds").val();
              //保存本次查询信息
              $("#conditionValue").val(o.condition);
    	      $("#subjectValue").val(o.subject);
    	      $("#sendersValue").val(o.senders);
    	      $("#flowstateValue").val(o.flowstate); 
    	      $("#beginDateValue").val(o.beginDate);
    	      $("#endDateValue").val(o.endDate);
    	      $("#operationTypeValue").val(o.operationType);
    	      $("#operationTypeIdsValue").val(o.operationTypeIds);
    		}
    		$("#mytable").ajaxgridLoad(o);
    	}
    	function validate(){
    		try{
	    		var beginDate=$("#beginDate").val();
	    	    var endDate=$("#endDate").val();
	    	    if(beginDate === "" || endDate === ""){
	    	    	return true;
	    	    }else{
	    	    	//OA-68717
					var strDate = beginDate.replace(/-/g,"/");
					var begin = new Date(strDate);
					strDate = endDate.replace(/-/g,"/");
	    	    	var end = new Date(strDate);
	    	    	
	    	    	if (begin > end){
	    	    	   return false;
	    	    	}
	    	    }
    		}catch(e){}
    	    return true;
    	}

			function repealWorkflow(tWindow,caseId,processId,isTemplate,vWindow,appName,dialog){
	                var summaryId=$("#summaryIdValue").val();
	                var vouch=$("#vouchValue").val();
					var isGroupAdmin = "${CurrentUser.groupAdmin}";
					var isAdministrator = "${CurrentUser.administrator}";
					var condition=$("#condition").val();
					var isAdmin = (isGroupAdmin== "true" || isAdministrator=="true");
	                if((isAdmin == true && condition == "2") || (vouch!='1' && vouch!=1)){
	                var lockWorkflowRe = lockWorkflow(processId, '${CurrentUser.id}', 12);
		                if(lockWorkflowRe[0] == "false"){
		                    $.alert(lockWorkflowRe[1]);
		                    return;
		                }
		                if((isAdmin == true && condition == "2")){
			                			                			          
							 var _colManager = new colManager();
    						 var params = new Object();
    						 params["summaryId"] = summaryId;
		                	var canDealCancel = _colManager.checkIsCanRepeal(params);
		                    if(canDealCancel.msg == "${ctp:i18n('collaboration.cannotRepeal_workflowIsVouched')}" 
								|| canDealCancel.msg == "${ctp:i18n('collaboration.cannotRepeal_workflowIsAudited')}"){
		                    	if(!confirm("${ctp:i18n('collaboration.confirmRepeal.workflowIsRollback')}")){
		                    		//核定的时候撤销流程解锁点取消  要解开流程锁
		                    		releaseWorkflowByAction(processId, '${CurrentUser.id}', 12);
									return;
								}
		                    }
		                							
		                }
	         	    //撤销流程
	        	    var repealdialog = $.dialog({
	                    url: "${path}/workflowmanage/workflowmanage.do?method=showRepealCommentDialog",
	                    width:450,
	                    height:240,
	                    title:"${ctp:i18n('common.repeal.workflow.label')}",  //撤销流程
	                    targetWindow:getCtpTop(),
	                    buttons : [ {
	                    	id: 'okBtn',
	                        text : "${ctp:i18n('permission.confirm')}",//确定
	                        handler : function() {
	                          var returnValue = repealdialog.getReturnValue();
	                          if(returnValue){
	                            repealdialog.disabledBtn("okBtn");
	                        	var wmManager = new workflowManageManager();
	               		        var tempMap = new Object();
	               		        tempMap["page"] = "workflowManager";
	               		        tempMap["repealComment"] = returnValue[0];
	               		        tempMap["summaryId"] = summaryId; 
	               		        tempMap["appName"] = appName;
	               		        wmManager.transRepal(tempMap, {
	               		            success: function(msg){
	               		                if(msg==null||msg==""){
	               		                	search("refresh");
	               		                }else{
	               		                 $.alert(msg);
	               		                }
	               		             	repealdialog.close();
	                                 	dialog.close();
	               		            }
	               		        });
	                  	      }
	                        }
	                      }, {
	                        text : "${ctp:i18n('permission.cancel')}",//取消
	                        handler : function() {
	                            releaseWorkflowByAction(processId, '${CurrentUser.id}', 12);
	                        	repealdialog.close();
	                        }
	                      } ],
	                      closeParam:{
	                          show:true,
	                          handler:function(){
	                              releaseWorkflowByAction(processId, '${CurrentUser.id}', 12);
	                          }
	                        }
	                  });
	                }else{
	                    $.alert("${ctp:i18n('collaboration.common.workflow.processHasBeenApp')}");//该流程已核定，不能撤销！
	                }
	    		
	    	}
    	function stopWorkflow(tWindow,caseId,processId,isTemplate,vWindow,appName,dialog){
           
    		var obj = canStopFlow(caseId);
   		    //不能回退
   		    if(obj[0] === 'false'){
   		        $.alert(obj[1]);
   		        return;
   		    }	
    		    
    		var lockWorkflowRe = lockWorkflow(processId, '${CurrentUser.id}', 11);
            if(lockWorkflowRe[0] == "false"){
                $.alert(lockWorkflowRe[1]);
                return;
            }
    		$.messageBox({
    		    'type' : 1,
    		    'imgType':4,
    		    'title':"${ctp:i18n('system.prompt.js')}",
    		    'msg' : "${ctp:i18n('collaboration.confirmStepStopItem')}",//'确认要终止流程?该操作不能恢复!',
    		    ok_fn : function() {
        	    	var wmManager = new workflowManageManager();
    		        var tempMap = new Object();
    		        tempMap["summaryId"] = $("#summaryIdValue").val();
    		        tempMap["appName"] = appName;
    		        wmManager.transStepStop(tempMap, {
    		            success: function(msg){
    		                if(msg==null||msg==""){
    		                	search("refresh");
    		                }else{
    		                    $.alert(msg);
    		                }
    		            }
    		        });
    		        dialog.close();
    		    },
                cancel_fn:function(){
                    releaseWorkflowByAction(processId, '${CurrentUser.id}', 11);
                    //repealConfirm.close();
                }
    		  });
    	}
    	function reset(){
    		window.location.reload();
    	}
    	/**
    	 * 明细日志 弹出对话框
    	 * showFlag  初始化时 显示的内容 1:显示处理明细 2:显示流程日志 3:显示催办(督办)日志
    	 */
    	function showDetailLogDialog(summaryId,processId,showFlag){
    	    var dialog = $.dialog({
    	        //url : _ctxPath+'/collaboration/collaboration.do?method=showDetailLog&summaryId='+summaryId+'&processId='+processId+"&showFlag="+showFlag,
    	        url : _ctxPath+'/detaillog/detaillog.do?method=showDetailLog&summaryId='+summaryId+'&processId='+processId+"&showFlag="+showFlag,
    	        width : 1040,
    	        height : 590,
    	        title : "${ctp:i18n('collaboration.sendGrid.findAllLog')}", //查看明细日志
    	        targetWindow:getCtpTop()
    	    });
    	}
    	function rend(txt,data, r, c) {
    		if(c===4){
    			/* 当前待办人 */
    	    	return "<a href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.appEnumStr+"\")'>"+txt+"</a>";
    	    }else if (c == 6){
    	    	/* 编辑流程 */
    	    	txt="<span class='ico16 process_16' onclick=\"$(\'#summaryIdValue\').val(\'"+data.summaryId+"\');$(\'#vouchValue\').val(\'"+data.vouch+"\');adminWFCDiagram(window.parent,\'"+data.caseId+"\',\'"+data.processId+"\',"+data.isFromTemplete+",window.parent,\'"+data.appEnumStr+"\',repealWorkflow,stopWorkflow,\'"+data.accountId+"\',\'"+data.defaultNodeName+"\',\'"+data.defaultNodeLable+"\');\" title=''></span>";
    	    	return txt;
    	    }else if(c==7){
    	    /* 	明细日志 */
    	    	return "<span class='ico16 view_log_16' onclick='showDetailLogDialog(\""+data.summaryId+"\",\""+data.processId+"\",2)' title=''></span> ";
    	    }else {
    	    	return txt;
    	    }
    	}
    	//显示流程图
		function showFlowChart(_contextCaseId,_contextProcessId,_templateId,_contextActivityId,_appName){
		    var showHastenButton='false';
		    var supervisorsId="";
		    var isTemplate=false;
		    var operationId="";
		    var senderName="";
		    var openType=getA8Top();
		    if(_templateId&&"undefined"!=_templateId){
		        isTemplate=true;
		    }
		    showWFCDiagram(openType,_contextCaseId,_contextProcessId,isTemplate,showHastenButton,supervisorsId,window, _appName, false ,_contextActivityId,operationId,'' ,senderName);
		}
    	// 打印 
        function popprint(content) {
            var printContentBody = "";
            var cssList = new ArrayList();
            var pl = new ArrayList();
            var contentBody = content ;
            var contentBodyFrag = "" ;
            cssList.add("${path}/skin/default/skin.css");
            contentBodyFrag = new PrintFragment(printContentBody, contentBody);
            pl.add(contentBodyFrag);
            printList(pl,cssList);
        }
    	function templateChooseCallback(ids,names){
    		$("#templateName").val(names);
    		$("#operationTypeIds").val(ids);
    	}

        $(document).ready(function () {
            //<点击选择>
            new inputChange($("#senders"), "${ctp:i18n('collaboration.common.workflow.clickSelect')}");
            $("#senders").removeClass("color_gray");
            
            $("#templateName").click(function(){
            	templateChoose(templateChooseCallback,null,true,"","MaxScope","",null);
           });
            $("#queryBtn").click(function(){
            	search('search');
           });
            $("#resetBtn").click(function(){
            	reset();
           });
            $("#selfCreate").click(function(){
                //<点击选择>
            	$("#templateName").attr("disabled",true).val("${ctp:i18n('collaboration.common.workflow.clickSelect')}");
           });
             $("#templateFlow").click(function(){
                 //<点击选择>
				$("#templateName").attr("disabled",false).val("${ctp:i18n('collaboration.common.workflow.clickSelect')}");
            });
			$("#condition").change(function(){
			    // 每次选择应用分类的时候，清空已经选择的模板
			    rv = null;
			    $("#templateName").val("");
    			$("#operationTypeIds").val("");
    			templateOrginalData = null;
				if($("#condition").val()==2){
					$("#selfCreate").attr("disabled",true);
					$("#templateFlow").click();
				}else{
					$("#selfCreate").attr("disabled",false);
					$("#selfCreate").click();
				}
			});
			
            $("#senders").click(function(){
    			var tempValue=$("#sendersStr").val();
    			var tempText=$("#senders").val();
            	 $.selectPeople({
          	        type:'selectPeople'
          	        ,panels:'Department,Outworker'
          	        ,selectType:'Member,Department,Account'//,Team,Post,Level,Role,Email,Mobile
          	        ,minSize:0
          	        ,text:"${ctp:i18n('common.default.selectPeople.value')}"
          	        ,returnValueNeedType: true
          	        ,showFlowTypeRadio: false
          	        ,onlyLoginAccount:${!CurrentUser.groupAdmin}
          	        ,showConcurrentMember:true  //是否显示兼职人员(只外单位)
          	        //,maxSize:10
          	        ,params:{
          	        	text : tempText,
          	           value: tempValue
          	        }
          	        ,targetWindow:getCtpTop()
          	        ,callback : function(res){
          	            if(res && res.text){
          	            	$("#sendersStr").val(res.value);
          	            	$("#senders").val(res.text);
          	            } else {
          	            	$("#sendersStr").val("");
          	            	$("#senders").val("${ctp:i18n('collaboration.common.workflow.clickSelect')}");
          	            }
          	        }
          	    });
            });
            var toolbar = $("#toolbar").toolbar({
                toolbar: [{
                    id: "exportExcel",
                    name: "${ctp:i18n('workflow.workflowManager.exportExcel')}" ,   //  导出Excel
                    className: "ico16 export_excel_16",
                    click : function(){
                    	var param = new Object();
                    	param["condition"] = $("#conditionValue").val();
                    	param["subject"]=$("#subjectValue").val();
                    	param["senders"]=$("#sendersValue").val();
                    	param["flowstate"]=$("#flowstateValue").val();
                    	param["beginDate"]=$("#beginDateValue").val();
                    	param["endDate"]=$("#endDateValue").val();
                    	param["operationTypeIds"]=$("#operationTypeIdsValue").val();
                    	param["operationType"]=$("#operationTypeValue").val();
                	    var url = "${path}/workflowmanage/workflowmanage.do?method=workflowDataToExcel";
                	    $.batchExport($("#mytable")[0].p.total,function(page,size){
                	    	param["page"]=page;
                	    	param["size"]=size;
                	    	param["fileName"]="workflowData_"+page;//文件名
                        getCtpTop().onbeforeunload = null;
                	    	$("#editFlowForm").jsonSubmit({
                             	"action":url,
                             	"paramObj":param,
                             	callback : function() {
                                getCtpTop().bindOnbeforeunload();
                              }
                         	});
                        });
                     	 /* $("#editFlowForm").jsonSubmit({
                         	"action":url,
                         	"paramObj":param,
                         	callback : function() {}
                     	}); */
                     }
                }, {
                    id: "print",
                    name: "${ctp:i18n('collaboration.newcoll.print')}",  //打印
                    className: "ico16 print_16",
                    click : function(){
                    	//var html = $('#mytable')[0].outerHTML;
                    	var html = $('#mydata').clone(true);
                    	$("span", html).removeAttr("onclick");
                        popprint(html.html());
                     }
                }]
            });
            //表格
            var grid = $("#mytable").ajaxgrid({
            	render : rend,
                colModel: [{
                    display: "${ctp:i18n('common.subject.label')}",//标题
                    name: 'subject',
                    width: '30%'
                }, {
                    display: "${ctp:i18n('collaboration.common.workflow.theirDepartments')}",  //所属部门
                    name: 'depName',
                    width: '15%'
                }, {
                    display: "${ctp:i18n('cannel.display.column.sendUser.label')}",//发起人
                    name: 'initiator',
                    width: '10%'
                }, {
                    display: "${ctp:i18n('common.date.sendtime.label')}",//发起时间
                    name: 'sendTime',
                    width: '15%'
                },{
                    display:  $.i18n("collaboration.list.currentNodesInfo.label"),//当前处理人
                    name: 'currentNodesInfo',
                    sortable : true,
                    width: '12%'
                },{
                    display: "${ctp:i18n('collaboration.process.cycle.label')}",//流程期限
                    name: 'deadlineDatetimeName',
                    width: '15%'
                },{
                    display: "${ctp:i18n('collaboration.common.workflow.flowControl')}",//流程控制
                    name: 'workflow',
                    width: '10%'
                }, {
                    display: "${ctp:i18n('processLog.list.title.label')}",//流程日志
                    name: 'processLog',
                    width: '8%'
                }],
                height:($(document).height()-45-245),
                managerName: "workflowManageManager",
                managerMethod: "testPaging" 
            });
            $("#mytable").ajaxgridLoad();
            $("input").attr("autocomplete","off");
            $("select").attr("autocomplete","off");
        });
    </script>
</head>
<body class="page_color">
<form id="editFlowForm" name="editFlowForm">
	<input type="hidden" id="process_desc_by" name="process_desc_by" value="">
	<input type="hidden" id="process_xml" name="process_xml" value=""> 
	<input type="hidden" id="process_info" name="process_info" value=""> 
	<input type="hidden" id="process_rulecontent" name="process_rulecontent" value=""> 
	<input type="hidden" id="process_subsetting" name="process_subsetting"  value=""> 
	<input type="hidden" id="workflow_newflow_input" name="workflow_newflow_input" value=""> 
	<input type="hidden" id="workflow_node_peoples_input" name="workflow_node_peoples_input" value=""> 
	<input type="hidden" id="workflow_node_condition_input" name="workflow_node_condition_input" value=""> 
</form>
	
	<input type="hidden" id="summaryIdValue" name="summaryIdValue" value=""> 
	<input type="hidden" id="vouchValue" name="vouchValue" value=""> 
    
    <input type="hidden" id="conditionValue" class=""/>
    <input type="hidden" id="subjectValue" class=""/>
    <input type="hidden" id="sendersValue" class=""/>
    <input type="hidden" id="flowstateValue" class=""/>
    <input type="hidden" id="beginDateValue" class=""/>
    <input type="hidden" id="endDateValue" class=""/>
    <input type="hidden" id="operationTypeValue" class=""/>
    <input type="hidden" id="operationTypeIdsValue" class=""/>
    
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F01_wfmanage'"></div>
    <!-- <div class="hr_heng"></div> -->
    <div id="toolbar"></div>
    <div class="hr_heng"></div>
    <table cellpadding="0" cellspacing="0" border="0" class="font_size12 margin_l_20 margin_t_10">
        <tr>
            <td width="100" class="align_right padding_r_10">${ctp:i18n("common.app.type")}:</td><!-- 应用类型 -->
            <td width="220">
                <div class="common_selectbox_wrap">
                    <select id="condition" name="condition">
                        <c:if test="${ctp:hasPlugin('collaboration')}">
                            <option value="1" title="${ctp:i18n('application.1.label')}">${ctp:i18n("application.1.label")}</option><!-- 协同 -->
                        </c:if>
                        <c:if test="${ctp:hasPlugin('form')}">
                            <option value="2" title="${ctp:i18n('collaboration.common.workflow.form')}">${ctp:i18n('collaboration.common.workflow.form')}</option><!-- 表单 -->
                        </c:if>
                        <!-- 判断是否有公文插件 -->
                        <c:if test="${ctp:hasPlugin('edoc')}">
                            <option value="19" title="${ctp:i18n('collaboration.pending.lable2')}">${ctp:i18n('collaboration.pending.lable2')}</option><!-- 发文 -->
                            <option value="20" title="${ctp:i18n('collaboration.pending.lable1')}">${ctp:i18n('collaboration.pending.lable1')}</option><!-- 收文 -->
                            <option value="21" title="${ctp:i18n('collaboration.pending.lable6')}">${ctp:i18n('collaboration.pending.lable6')}</option><!-- 签报 -->
                        </c:if>
                    </select>
                </div>
            </td>
        <c:if test="${CurrentUser.groupAdmin}">
            <td class="align_right padding_r_10">${ctp:i18n('collaboration.newcoll.subject')}:</td><!-- 标题 -->
            <td>
                <div class="common_txtbox_wrap">
                    <input id="subject" name="subject" type="text" class="" maxLength="80">
                </div>
            </td>
        </tr>
        <tr>
            <td height="5" colspan="4"></td>
        </tr>
        <tr>
         	<td class="align_right padding_r_10 padding_l_30">${ctp:i18n('collaboration.common.workflow.originatingObject')}:</td><!-- 发起对象 -->
        	<td>
                <div class="common_txtbox_wrap">
                    <input type="text" id="senders" readonly="readonly" class="cursor-hand" />
                    <input type="hidden" id="sendersStr" />
                </div>
            </td>
            <td class="align_right padding_r_10 padding_l_30">${ctp:i18n("common.flow.state.label")}:</td><!-- 流程状态 -->
            <td>
                <div class="common_radio_box left margin_t_5">
                    <label for="radio11" class="margin_r_10 hand">
                        <input type="radio" value="0" id="radio11" name="flowstate" class="radio_com" checked>${ctp:i18n("collaboration.common.workflow.circulation")}</label><!-- 流转中 -->
                    <label for="radio12" class="margin_r_10 hand">
                        <input type="radio" value="1" id="radio12" name="flowstate" class="radio_com">${ctp:i18n('collaboration.state.10.stepstop')}</label><!-- 终止 -->
                    <label for="radio13" class="margin_r_10 hand">
                        <input type="radio" value="3" id="radio13" name="flowstate" class="radio_com">${ctp:i18n('collaboration.common.workflow.end')}</label><!-- 结束 -->
                </div>
            </td>
        </tr>
        <tr>
            <td height="5" colspan="4"></td>
        </tr>
        <tr>
            <td class="align_right padding_r_10">${ctp:i18n("common.date.sendtime.label")}:</td><!-- 发起时间 -->
            <td>
                <div class="common_txtbox_wrap" style="width: 90px; float: left;">
                    <input id="beginDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false,hideOkClearButton:false" value='${beginDate}' style="width:89px;"/>
                </div>
                <span class="left padding_lr_5 margin_t_5">-</span>
                <div class="common_txtbox_wrap" style="width: 90px; float: left;">
                    <input id="endDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d',cache:false,hideOkClearButton:false" value='${endDate}' style="width:89px;"/>
                </div>
            </td>
            </c:if>
            <c:if test="${!CurrentUser.groupAdmin}">
            <td class="align_right padding_r_10 padding_l_30">${ctp:i18n("collaboration.common.workflow.typeOfBusiness")}:</td><!-- 业务类型 -->
	        <td>
	            <label for="selfCreate" class="margin_r_10 hand">
	            	<input type="radio" name="operationType" id="selfCreate" class="radio_com" value="self" checked />${ctp:i18n("collaboration.common.workflow.selfbuiltProcess")}</label><!-- 自建流程 -->
	            <label for="templateFlow" class="margin_r_10 hand">
	            <input type="radio" name="operationType" id="templateFlow" class="radio_com" value="template" />${ctp:i18n("collaboration.common.workflow.templateFlow")}</label><!-- 模板流程 -->
	            <input type="text" name="templateName" id="templateName" class="cursor-hand" disabled="disabled" value="${ctp:i18n('collaboration.common.workflow.clickSelect')}"/><!-- 点击选择 -->
				<input type="hidden" name="operationTypeIds" id="operationTypeIds" value=""/> 
	        </td>
	    </tr>
        <tr>
            <td height="5" colspan="4"></td>
        </tr>
        <tr>
	             <td class="align_right padding_r_10">${ctp:i18n('collaboration.newcoll.subject')}:</td><!-- 标题 -->
            <td>
                <div class="common_txtbox_wrap">
                    <input id="subject" name="subject" type="text" class="" maxLength="80">
                </div>
            </td>
         	<td class="align_right padding_r_10 padding_l_30">${ctp:i18n('collaboration.common.workflow.originatingObject')}:</td><!-- 发起对象 -->
        	<td>
                <div class="common_txtbox_wrap">
                    <input type="text" id="senders"  readonly="readonly" class="cursor-hand" />
                    <input type="hidden" id="sendersStr" />
                </div>
            </td>
            </tr>
        <tr>
            <td height="5" colspan="4"></td>
        </tr>
        <tr>
        <td class="align_right padding_r_10">${ctp:i18n("common.date.sendtime.label")}:</td><!-- 发起时间 -->
            <td>
                <div class="common_txtbox_wrap" style="width: 90px; float: left;">
                    <input id="beginDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" value='${beginDate}' style="width:89px;"/>
                </div>
                <span class="left padding_lr_5 margin_t_5">-</span>
                <div class="common_txtbox_wrap" style="width: 90px; float: left;">
                    <input id="endDate" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'" value='${endDate}' style="width:89px;"/>
                </div>
            </td>
            <td class="align_right padding_r_10 padding_l_30">${ctp:i18n("common.flow.state.label")}:</td><!-- 流程状态 -->
            <td>
                <div class="common_radio_box left margin_t_5">
                    <label for="radio11" class="margin_r_10 hand">
                        <input type="radio" value="0" id="radio11" name="flowstate" class="radio_com" checked>${ctp:i18n("collaboration.common.workflow.circulation")}</label><!-- 流转中 -->
                    <label for="radio12" class="margin_r_10 hand">
                        <input type="radio" value="1" id="radio12" name="flowstate" class="radio_com">${ctp:i18n('collaboration.state.10.stepstop')}</label><!-- 终止 -->
                    <label for="radio13" class="margin_r_10 hand">
                        <input type="radio" value="3" id="radio13" name="flowstate" class="radio_com">${ctp:i18n('collaboration.common.workflow.end')}</label><!-- 结束 -->
                </div>
            </td>
            </c:if>
        </tr>
        <tr>
            <td height="5" colspan="4"></td>
        </tr>
        <tr style="height: 60px;">
            <td colspan="4" class="align_center">
            	<a href="javascript:void(0)" class="common_button common_button_emphasize" id="queryBtn">${ctp:i18n('template.templateChoose.inquiry')}<!-- 查询 --></a>
            	<a href="javascript:void(0)" class="common_button common_button_gray margin_l_10" id="resetBtn">${ctp:i18n('collaboration.common.workflow.reset')}<!-- 重置 --></a></td>
        </tr>
    </table>
    <!-- </div> -->
    <div class="hr_heng margin_t_10"></div>
    <p class="padding_tb_5 font_size12 margin_l_10">${ctp:i18n('collaboration.common.workflow.queryResults')}</p><!-- 查询结果 -->
    <div id="mydata"><table id="mytable" class="flexme3"></table></div>
</body>
</html>