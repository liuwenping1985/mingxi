<%--
 $Author:  苗永锋$
 $Rev:  $
 $Date:: 2012-12-21#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/commonColList.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>

<c:if test="${ctp:hasPlugin('meeting')}">
<jsp:include page="/WEB-INF/jsp/meeting/dialog/meeting_reply_card_dialog.jsp"></jsp:include>
</c:if>
<!DOCTYPE html>
<html>
<title>${ctp:escapeJavascript(columnsName)}</title>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/batch.js${ctp:resSuffix()}"></script>
    <c:if test="${ctp:hasPlugin('infosend')}">
	     <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/common/magazine_publish_common.js${ctp:resSuffix()}"></script>
    </c:if>
    <script type="text/javascript">
    var emailShow = ${v3x:hasPlugin('webmail')};
    var hasMeetingPlug="${ctp:hasPlugin('meeting')}";
        var grid;
		var notEdocregister=false;
		var notMemberdocregister=false;
		var searchobj;
		var isV5Member = ${CurrentUser.externalType == 0};
        $(document).ready(function () {
            if (isV5Member) {
				getCtpTop().hideLocation();
            }
            var submenu = new Array();
            //判断是否有新建协同的资源权限，如果没有则屏蔽转发协同
            if ($.ctx.resources.contains('F01_newColl')) {
                //协同
                submenu.push({name: "${ctp:i18n('common.toolbar.transmit.col.label')}",click: transmitCol });
            };
            //判断是否有转发邮件的资源权限，如果没有则屏蔽转发协同
            if ($.ctx.resources.contains('F12_mailcreate')) {
                //邮件
                submenu.push({name: "${ctp:i18n('common.toolbar.transmit.mail.label')}",click: transmitMail });
            };

           var toolbarmenu = new Array();
           toolbarmenu.push({id: "batchDeal",name: "${ctp:i18n('batch.title')}",className: "ico16 batch_16",click:batchDeal});
           if($.ctx.resources.contains('F01_newColl') || $.ctx.resources.contains('F12_mailcreate')){
           		toolbarmenu.push({id: "transmit",name: "${ctp:i18n('common.toolbar.transmit.label')}",className: "ico16 forwarding_16",subMenu: submenu});
           }

         	//工具栏
            $("#toolbars").toolbar({
                borderLeft:false,
                borderTop:false,
                borderRight:false,
                toolbar:toolbarmenu
            });
            //转协同
            function transmitCol(){
                transmitColFromGrid(grid);
            }
          	//批处理
            function batchDeal(){
                var checkBoxs= grid.grid.getSelectRows();
            	if(checkBoxs.length<1||!checkBoxs){
            		$.alert("${ctp:i18n('collaboration.listPending.selectBatchData')}");
            		return ;
            	}

            	var process = new BatchProcess();
            	for(var i = 0 ; i < checkBoxs.length;i++){
            			var affairId = checkBoxs[i].id;
            			var subject = checkBoxs[i].subject;
            			//var category =  checkBoxs[i].category||"1";
                        //没有category属性，改为app。主要修复公文无法批处理的错误 --xiangfan
            			var category =  checkBoxs[i].applicationCategoryKey||"1";
            		    if(category == "19" || category == "20" || category == "21"){//公文发文(19) 收文(20) 签报(21)
            		        category = "4";//公文
            		    }
            			var summaryId =  checkBoxs[i].objectId;
            			if(process.batchOpinion == "0" || process.batchOpinion == null){
            				process.batchOpinion = checkBoxs[i].disAgreeOpinionPolicy == null ? "0": checkBoxs[i].disAgreeOpinionPolicy=="1"?"3":"0";//意见是否必填，3,不同意时，意见必填
            			}
            			process.addData(affairId,summaryId,category,subject);
            	}
            	
            	if(!process.isEmpty()){
            		var r = process.doBatch();
            	}else{
            		$.alert("${ctp:i18n('collaboration.listPending.selectBatchData')}");
            		return ;
            	}
            }
          	var appConditon = new Array();
          	var hasCol = "${ctp:hasPlugin('collaboration')}";
          	var hasEdoc = "${ctp:hasPlugin('edoc')}";
          	var hasMeeting = "${ctp:hasPlugin('meeting')}";
          	var hasInfosend = "${ctp:hasPlugin('infosend')}";
          	var hasBbs = "${ctp:hasPlugin('bbs')}";
            var hasInquiry = "${ctp:hasPlugin('inquiry')}";
            var hasNews = "${ctp:hasPlugin('news')}";
            var hasBulletin = "${ctp:hasPlugin('bulletin')}";
            var hasOffice = "${ctp:hasPlugin('office')}";
            
            //协同
            if("true"==hasCol){
                appConditon.push({text: "${ctp:i18n('application.1.label')}",value: '1'});
            }
            //公文
            if ("true"==hasEdoc) {
                appConditon.push({text: "${ctp:i18n('application.4.label')}",value: '4,16,19,20,21,22,23,24,34'});
            }
            //会议
            if ("true"==hasMeeting) {
                appConditon.push({text: "${ctp:i18n('application.6.label')}",value: '6,29'});
            }
          	//信息报送
          	if ("true"==hasInfosend && ${ctp:getSystemProperty('edoc.isG6')} ) {
                appConditon.push({text: "${ctp:i18n('govinfo.label')}",value: '32'});
            }
            //公共信息
            if ("true"==hasBbs || "true"==hasBulletin || "true"==hasInquiry || "true"==hasNews) {
                appConditon.push({text: "${ctp:i18n('collaboration.application.public.label')}",value: '7,8,9,10'});
            }
            //综合办公
            if ("true"==hasOffice) {
                appConditon.push({text: "${ctp:i18n('collaboration.application.office.label')}",value: '26'});
            }

            var levelCondition = new Array();
            levelCondition.push({text: "${ctp:i18n('common.importance.putong')}",value: '1'}); //普通
            if ("true"==hasEdoc && isV5Member) {
        	   levelCondition.push({text: "${ctp:i18n_1('collaboration.pendingsection.importlevl.pingAnxious',i18nValue2)}",value: '2'}); //--平急（公文）/重要（协同、表单
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.important')}",value: '3'}); //加急 (公文)/非常重要（协同、表单）
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.urgent')}",value: '4'}); //特急（公文）
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.teTi')}",value: '5'}); //-特提（公文）	
            } else {
            	levelCondition.push({text: "${ctp:i18n('common.importance.zhongyao')}",value: '2'}); //--重要
            	levelCondition.push({text: "${ctp:i18n('common.importance.feichangzhongyao')}",value: '3'}); //--非常重要
            }
            
            
            //调查
            if ("true"==hasInquiry) {
                //待填写的调查不进入代理，待审核的调查进入代理；待填写和待审核的调查都进入待办
                if("${param.from}" != "Agent"){
                    appConditon.push({text: "${ctp:i18n('application.10.label')}",value: '10'});
                }
            }

            //查询条件
            var condition = new Array();
            condition.push({
                id: 'title',
                name: 'title',
                type: 'input',
                text: "${ctp:i18n('cannel.display.column.subject.label')}",//标题
                value: 'subject',
                maxLength:100
            });
            condition.push({
                id: 'importent',
                name: 'importent',
                type: 'select',
                text: "${ctp:i18n('common.importance.label')}",//重要或紧急程度
                value: 'importLevel',
                items: levelCondition
            });
            condition.push({
                id: 'sender',
                name: 'sender',
                type: 'input',
                text: "${ctp:i18n('common.sender.label')}",//发起人
                value: 'sender'
            });
            condition.push({
                id: 'datetime',
                name: 'datetime',
                type: 'datemulti',
                text: "${ctp:i18n('common.date.sendtime.label')}",//发起时间
                value: 'createDate',
                dateTime: false,
                ifFormat:'%Y-%m-%d'
            });
            condition.push({
                id: 'receivetime',
                name: 'receivetime',
                type: 'datemulti',
                text: "${ctp:i18n('cannel.display.column.receiveTime.label')}",//接受时间
                value: 'receiveDate',
                dateTime: false,
                ifFormat:'%Y-%m-%d'
            });
            condition.push({
                id: 'subState',
                name: 'subState',
                type: 'select',
                text: "${ctp:i18n('collaboration.deadLine.subState')}",//处理状态
                value: 'subState',
                items: [{
                	 text: "${ctp:i18n('common.not.read.label')}",//未读
                     value: '11'
                    }, {
                    	text: "${ctp:i18n('common.read.label')}",//已读
                        value: '12,31,32,33'
                    },{
                        text: "${ctp:i18n('collaboration.dealAttitude.temporaryAbeyance')}",//暂存待办
                        value: '13,19'   //19公文在办指定回退
                    },  {
                        text: "${ctp:i18n('collaboration.label.berolled.back')}",//被回退
                        value: '4'
                    }, {
                        text: "${ctp:i18n('collaboration.label.berolled.speback')}",//指定回退
                        value: '15'
                    }
                ]
            });
            if(isV5Member){
	            condition.push({
	                id: 'applicationEnum',
	                name: 'applicationEnum',
	                type: 'select',
	                text: "${ctp:i18n('common.app.type')}",//应用类型
	                value: 'applicationEnum',
	                items: appConditon
	            });
            }
            condition.push({
            	id:'nodeDeadLine',
            	name:'nodeDeadLine',
            	type:'datemulti',
            	text:"${ctp:i18n('collaboration.nodeDeadLine.expectedProcessTime')}",// 处理期限
            	value:'expectedProcessTime',
            	ifFormat:'%Y-%m-%d',
            	dateTime:false
            });
            
            var hasBarCode = "${ctp:hasPlugin('barCode')}";
            //扫一扫
            if (hasBarCode=="true") {
	            condition.push({id:'saoyisao',
	                name:'saoyisao',
	                type:'barcode',
	                text: $.i18n('common.barcode.search.saoyisao'),  //扫一扫
	                value:'barcode'
	            });
            }

            //搜索框
            searchobj = $.searchCondition({
                top:8,
                right:10,
                searchHandler: function(){
                   
                    var val = searchobj.g.getReturnValue();
                    if(val !== null){
                    	//o.page=1;//查询的时候重置页码为第一页
                        $("#moreList").ajaxgridLoad(getSearchValueObj());
                        setTimeout(function(){
                            try{
                            	loadTitle(grid.p.total);
                            }catch(e){}
                        },1000);
                    }
                },
                conditions: condition
            });
            var colModel = new Array();
            var rowStr="${rowStr}";//需要显示的列
            var rowStr=rowStr.split(",");
            var len = rowStr.length + 2;
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
            colModel.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'workitemId',width : '4%',isToggleHideShow:false});
        	//标题
            colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'subject',width : titleLen+'%',sortable : true});
          	//发起人
        	if('${param.from}' === 'Agent'){
           		colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'createMemberName',width : width+'%',sortable : true});
           	}else{
	            if(rowStr.indexOf("sendUser")!=-1){
	            	colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'createMemberName',width : width+'%',sortable : true});
	            }
           	}
			//上一处理人      
			if(rowStr.indexOf("preApproverName") != -1){
		        colModel.push({ display : "${ctp:i18n('cannel.display.column.preApprover.label')}",name : 'preApproverName',width : width+'%',sortable : true});
			}
          	//发起时间
            colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'createDate',width : width+'%',sortable : true});
           	//接收时间/召开时间段   该字段不受编辑页面的设置影响，无论怎么设置都要显示
           	//如果是代理列表时
           	if('${param.from}' === 'Agent'){
	            colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.receiveTime.label')}",name : 'receiveTimeAll',width : width+'%',sortable : true});
	            colModel.push({ display : "${ctp:i18n('common.workflow.deadline.date')}",name : 'deadLine',width : width + '%',sortable : true});
           		//分类
           		colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : width+'%',sortable : true});
           	}else{
           		for(var i=0;i<rowStr.length;i++){
                	var colNameStr=rowStr[i];
                	//接收时间
    	            if("receiveTime"==colNameStr){
			            colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.receiveTime.label')}",name : 'receiveTimeAll',width : width+'%',sortable : true});
    	            }
    	          	//处理期限
					if("deadLine"==colNameStr){
			            colModel.push({ display : "${ctp:i18n('common.workflow.deadline.date')}",name : 'deadLine',width : width + '%',sortable : true});
    	            }
    	          	//公文文号(公文字段)
    	            if("edocMark"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : width+'%',sortable : true});
    	            }
    	          	//发文单位 (公文字段)
    	            if("sendUnit"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.sendUnit.label')}",name : 'sendUnit',width : width+'%',sortable : true});
    	            }
    	          	//会议地点(会议字段)
    	            if("placeOfMeeting"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.placeOfMeeting.label')}",name : 'placeOfMeeting',width : width+'%',sortable : true});
    	            }
    	           	//主持人(会议字段)
    	            if("theConferenceHost"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.theConferenceHost.label')}",name : 'theConferenceHost',width : width+'%',sortable : true});
    	            }
    	          	//已处理人数/总人数(会议、调查字段)
    	            if("processingProgress"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('collaboration.pendingSection.processingProgress.label')}",name : 'processingProgress',width : width+'%',sortable : true});
    	            }
    	          	//分类
    	            if("category"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : width+'%',sortable : true});
    	            }
    	          	//节点名称
    	            if("policy"==colNameStr){
    	            	colModel.push({ display : "${ctp:i18n('cannel.display.column.policy.label')}",name : 'policyName',width : (width - 2)+'%',sortable : true});
    	            }

                }
           	}
           	
            //加载当前位置
            loadTitle(0);

            //表格加载
            setTimeout(function(){
                
                grid = $('#moreList').ajaxgrid({
                    id:'gridId',//给grid设置id，用来控制复选框的选择
                    callBackTotle: function(t){
                        $("#totalPending").text(t);
                     },
                    colModel:colModel ,
                    render : rend,
                    click: clickRow,
                    parentId: $('.layout_center').eq(0).attr('id'),
                    resizable:false,
                    managerName : "pendingManager",
                    managerMethod : "getMore${param.from}List4SectionContion",   //  getMoreList4SectionContion | getMoreAgentList4SectionContion
                    callBackTotle : _gridCallback
                }) ;
                loadTitle(grid.p.total);
            },300);
            
            //回掉函数
            function _gridCallback(){
            	if("true" == hasMeetingPlug){
            		showMeetingReplyCard();
            	}
            }
            
            //回调函数
            function rend(txt, data, r, c,col) {
              //未读  11  加粗显示
              var subState = data.subState;
              if(subState == 11){
                  txt = "<span class='font_bold'>"+txt+"</span>";
              }

			  // 当处理期限超期后，把处理期限标红
			  if(col.name ==='deadLine' && data.dealTimeout=== true){
				txt = "<span class='color_red left flagClass text_overflow'>"+txt+"</span>";
			  }

                var app = data.applicationCategoryKey;
            	if (col.name == "workitemId"){
            		//待发送公文（22）、待签收公文（23）、待登记公文（24）、信息报送（32）、待分发（34）
            		if(app==6||app==29||app==8||app==9||app==10||app==7||app==26||app==22||app==23||app==24||app==32||app==34){
            			txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" disabled class="noClick" row="'+r+'" value="'+data.id+'">';
            		}else{
            			txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
            		}
            	}
                if(col.name === 'subject'){
                	//如果是代理要加粗显示
                	data.subject = escapeStringToHTML(data.subject);
					if("${param.from}" == "Agent" && data.subState == 11){
						txt = "<span class='font_bold'>"+txt+"</span>";
                	}
                    //加图标
                    //重要程度
                    if(data.importantLevel !=null && data.importantLevel !=""&& (data.importantLevel == 2||data.importantLevel == 3||data.importantLevel == 4||data.importantLevel == 5)){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttachments === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                  	//视频图标 1普通会议 2视频会议
                    if(data.meetingNature === "2") {
                        txt = txt + "<span class='ico16 bodyType_videoConf_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"&&data.bodyType!=="HTML"){
                        var bodyType = data.bodyType;
               			var bodyTypeClass = convertPortalBodyType(bodyType);
               			if (bodyTypeClass !="html_16") {
               			    txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
               			}
                    }
                    if(data.showClockIcon==true&&data.dealTimeout=== true){
                    	txt = txt + "<span class='ico16 extended_red_16'></span>";
                    }else if(data.showClockIcon == true && data.overTime=== false){
                    	txt = txt + "<span class='ico16 extended_blue_16'></span>";
                    }

                    var app = data.applicationCategoryKey;

                    txt = "<a class='color_black'>"+txt+"</a>";

                } else if(col.name === 'categoryLabel'){
                	//代理时，将分类链接去掉
                	if((app == 24 && '${isRegistRole}'!='true') || '${param.from}' === 'Agent'){
                	}else{
	                	if(data.hasResPerm==true){
	                		if(txt.indexOf("span")){//给span增加 noClick class 避免触发外层的js方法打开待办事项
		                		txt=txt.replace("class=\'","class=\'noClick ");
		                	}
                            if (data.categoryOpenType && data.categoryOpenType == 3) {
                              txt = "<a class='noClick' onclick=\"openCtpWindow({'url':'" + _ctxPath + data.categoryLink + "'})\">" + txt + "</a>";
                            } else {
	                		  txt = "<a class='noClick' onclick=\"openLink('" + data.categoryLink + "')\">" + txt + "</a>";
                            }
	                    }else{
	                    	txt = "<span>"+txt+"</span>";
	                    }
                	}
                } else if(col.name == 'processingProgress') {//信息回执卡
                	//会议类型
                    if(app == 6) {
                    	txt = "";
                        txt += '<div class="replyCard" style="display:inline-block; padding:0px;" id="replyCard'+data.objectId+'" objectId="'+data.objectId+'">';
						txt += "<span>"+data.processedNumber+'/'+data.totalNumber+"</span>";
						txt += '</div>';
                    }
                }
                return txt;
           }

            if("true" == hasMeetingPlug){
        		showMeetingReplyCard();
        	}

			/** 信息报送 */
			if(typeof(initInfoPublish_portal)!='undefined') {
				initInfoPublish_portal(3);
			}
            

			if(notEdocregister){
			  alert("${ctp:i18n('collaboration.listPending.notEdocregister')}");
			}
			if(notMemberdocregister){
			  alert("${ctp:i18n('collaboration.listPending.notMemberdocregister')}");
			}

        });


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

        function openLink(link) {
        	try{
        		window.location.href("/seeyon"+link);
        	}catch(e){//非IE跳转
        		window.location.href="/seeyon"+link;
        	}
        }
      //取消加粗
        function cancelBold(id){
          var obj = $("#row"+id).find(".font_bold");
          if(obj!=null && typeof(obj)!='undefined')  obj.removeClass("font_bold");
        }
        var TimeFn = null;
        //点击事件
        function clickRow(data,rowIndex, colIndex){
        	openDetail(data.link,encodeURIat(data.subject),data.openType,data.id,data.applicationCategoryKey,data.applicationSubCategoryKey,data.memberId);
        }
        function openDetail(link,title,openType,id,app,subApp,memberId) {
            // 取消上次延时未执行的方法
            clearTimeout(TimeFn);
            cancelBold(id);
            //执行延时
            TimeFn = setTimeout(function(){
                if((app!='22'&&app!='23') && !isAffairValid(id)){
                    $("#moreList").ajaxgridLoad();
                    return;
                }
            	var _url = _ctxPath+link;
            	if(app == '6' && '${param.from}' === 'Agent') {//会议查看,代理
                    _url = _url+'&proxy=1&proxyId='+ memberId;
                } 
            	if(openType == '2') {
            		openLink(link);
            	} else {
    				var isInfoPublish = false;
    				if(app=='32') {
    					if(subApp=='3') {
    						isInfoPublish =  true;
    					}
    				}
    				if(isInfoPublish==true) {
    					openMagazinePublishDialog(id);
    				} else {
    					var params = {callback:closeAndFresh,callbackOfPendingSection:closeAndFresh, pwindow:window};
    					getCtpTop().showSummayDialogByURL(_url,title,params);
    				}
            	}
            },300);  
        }
        function closeAndFresh(){
              $('#moreList').ajaxgridLoad();
              setTimeout(function(){
                  loadTitle(grid.p.total);
              },1000);

        }
        function linkToSummary(app, objectId, affairId, subject){
            var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId=" + affairId;
            if(app == '6') {//会议查看
            	 url = _ctxPath + '/mtMeeting.do?method=mydetail&id='+objectId+'&affairId=' + affairId;
            } else if(app == '29') {
            	 url = _ctxPath + "/meetingroom.do?method=createPerm&openWin=1&id=" + objectId+"&affairId="+affairId;
            } else if(app == '19' || app == '20' || app == '21'){
                 url = _ctxPath + "/edocController.do?method=detail&from=Pending&affairId="+affairId;
            }
            var params = {callback:closeAndFresh};
            getCtpTop().showSummayDialogByURL(url,subject,params);
        }

        //当前位置显示
        function loadTitle(total) {
          //栏目更多样式调整
            var titleTipFlag = ${param.from eq 'Agent'};
            var titleTip;
            var columnsName="${ctp:escapeJavascript(columnsName)}";
            if(titleTipFlag){
                titleTip = "${ctp:i18n_1('collaboration.protal.more.agent.label','"+total+"')}";
            }else{
            	if(columnsName){
					titleTip=columnsName+"("+total+" "+"${ctp:i18n('collaboration.protal.more.pending.label.item')}"+")";
				}else{
					titleTip = "${ctp:i18n_1('collaboration.protal.more.pending.label','"+total+"')}";
				}
            }
            if (isV5Member) {
	            getCtpTop().showMoreSectionLocation(titleTip);
            }
        }
        //二维码传参chenxd
        function precodeCallback(){
           	var obj = getSearchValueObj();
           	obj.openFrom = "morePending";
           	return obj;
        }
        
        function getSearchValueObj(){
        	 var o = new Object();
             o.fragmentId = $.trim($('#fragmentId').val());
             o.state = $.trim($('#state').val());
             o.ordinal = $.trim($('#ordinal').val());
             o.isTrack = $.trim($('#isTrack').val());
             var choose = $('#'+searchobj.p.id).find("option:selected").val();
             
             if(choose === 'subject'){
            	 o.condition = choose;
                 o.textfield = $.trim($('#title').val());
                 $('#from_datetime').val("");
                 $('#to_datetime').val("");
             }else if(choose === 'importLevel'){
            	 o.condition = choose;
                 o.textfield = $.trim($('#importent').val());
                 $('#from_datetime').val("");
                 $('#to_datetime').val("");
             }else if(choose === 'subState'){
            	 o.condition = choose;
                 o.textfield = $.trim($('#subState').val());
                 $('#from_datetime').val("");
                 $('#to_datetime').val("");
             }else if(choose === 'applicationEnum'){
            	 o.condition = choose;
                 o.textfield = $.trim($('#applicationEnum').val());
                 $('#from_datetime').val("");
                 $('#to_datetime').val("");
             }else if(choose === 'sender'){
            	 o.condition = choose;
                 o.textfield = $.trim($('#sender').val());
                 $('#from_datetime').val("");
                 $('#to_datetime').val("");
             }else if(choose === 'createDate'){
            	 o.condition = choose;
                 var fromDate = $.trim($('#from_datetime').val());
                 var toDate = $.trim($('#to_datetime').val());
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能早于结束时间
                     return;
                 }
                 o.textfield = fromDate;
                 o.textfield1 = toDate;
             }else if(choose === 'receiveDate'){
            	 o.condition = choose;
                 var fromDate = $.trim($('#from_receivetime').val());
                 var toDate = $.trim($('#to_receivetime').val());
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能早于结束时间
                     return;
                 }
                 o.textfield = fromDate;
                 o.textfield1 = toDate;
             }else if(choose === 'expectedProcessTime'){
            	 o.condition = choose;
                 var fromDate = $('#from_nodeDeadLine').val();
                 var toDate = $('#to_nodeDeadLine').val();
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                     return;
                 }
                 o.textfield = fromDate;
                 o.textfield1 = toDate;
             }
             return o;
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12 comp" comp="type:'layout'">
       <c:if test="${ctp:hasPlugin('infosend')}">
           <jsp:include page="/WEB-INF/jsp/apps/info/common/magazine_publish_common.jsp"></jsp:include>
        </c:if>
        <div class="layout_north bg_color" id="north" layout="height:40,sprit:false,border:false">
            <div>
                <div id="toolbars"> </div>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="minHeight: 20,border:false">
        	<div class="border_lr">
        	<table  class="flexme3" id="moreList"></table>
        	</div>
        </div>
        <input type="hidden" id="fragmentId" value="${params.fragmentId}"/>
	       <input type="hidden" id="ordinal" value="${params.ordinal}"/>
	       <input type="hidden" id="state" value="${params.state}"/>
	       <input type="hidden" id="isTrack" value="${params.isTrack}"/>
	       <input type="hidden" id="from" value="${param.from}"/>
    </div>
    <ctp:webBarCode readerId="PDF417Reader" readerCallBack="codeCallback" decodeParamFunction="precodeCallback" decodeType="codeflowurl"/>
</body>
</html>
