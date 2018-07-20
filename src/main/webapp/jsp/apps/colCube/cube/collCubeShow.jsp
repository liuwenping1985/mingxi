<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/collaboration/collFacade.js.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/taskmanage/taskInterface.js.jsp" %>
<html style="height: 100%; overflow: hidden;">
<head>
<title>Insert title here</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=collCubeManager,cubeAuthManager"></script>
<script type="text/javascript">
        var grid;
        var flag=false;
        var returnValue="";
        var event_type="${event_type}";
        $(document).ready(function () {
           $("#discuss").click(function(){
           		$(this).parent().attr('class','current');
           		$("#survey").parent().removeAttr('class');
           		var o=new Object();
            	o.user_Id1="${user_Id1}";
            	o.user_Id2="${user_Id2}";
            	o.dateType="${dateType}";
            	o.event_type="${event_type}";
            	o.ext1=$(this).attr('name');
            	$("#listStatistic").ajaxgridLoad(o);
            })
            	
           $("#survey").click(function(){
           		$(this).parent().attr('class','current');
           		$("#discuss").parent().removeAttr('class');
           		var o=new Object();
            	o.user_Id1="${user_Id1}";
            	o.user_Id2="${user_Id2}";
            	o.dateType="${dateType}";
            	o.event_type="${event_type}";
            	o.ext1=$(this).attr('name');
            	$("#listStatistic").ajaxgridLoad(o);
           })

            var toolbarArray = new Array();
                //转发协同
            toolbarArray.push({
                  id: "ForwardCol",
                  name: "${ctp:i18n('performanceReport.queryMain.tools.reportForwardCol')}",
                  className: "ico16 forwarding_16",
                  click: transmitCol 
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
            //说明
            toolbarArray.push({
                id: "showHelp",
                name: "${ctp:i18n('performanceReport.queryMain_js.help.title')}",
                className: "ico16 help_16",
                click: showHelp
            });
			
            //工具栏
            $("#toolbars").toolbar({
                toolbar: toolbarArray
            });
            
            if(event_type!='9'){
            //查询条件，代理没有查询条件
 			var searchobj = $.searchCondition({
					top:2,
					right:10,
					onchange:function(){
						$("#from_send_time,#to_send_time").val('');
						var ua = navigator.userAgent;    
						ua = ua.toLowerCase();    
						var match=/(webkit)[\/]([\w.]+)/.exec(ua)||/(opera)(?:.*version)?[\/]([\w.]+)/.exec(ua)||/(msie)([\w.]+)/.exec(ua)||!/compatible/.test(ua)&&/(mozilla)(?:.*?rv:([\w.]+))?/.exec(ua)||[];
						if(match[1]!='webkit'){
							//不是谷歌浏览器
							$(".calendar_icon").css('top','-10px');
						}
					},
                    searchHandler: function(){
						returnValue = searchobj.g.getReturnValue();
						if(returnValue!=null){
							var obj=setQueryParam(returnValue);
							$("#listStatistic").ajaxgridLoad(obj);
						}
                    },
                    conditions:getCondition()
                });
            }
            
            function getCondition(){
            	var event_type="${event_type}";
            	var arr=new Array();
            	if(event_type=="1"||event_type=="2"||event_type=="3"||event_type=="4"){
            	//协同,公文,计划,会议
            	var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//標題
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.sender')}";//发起人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.dealer')}";//处理人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="send_time";
            	object1.name="send_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('performanceReport.queryMain.textbox.sendTime.name')}";//发起时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="send_time";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="deal_time";
            	object1.name="deal_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('performanceReport.workFlowAnalysis.runWorkTim')}";//处理时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="deal_time";
      			arr.push(object1);
      			}
      			
      			if(event_type=="10"){
      				//项目
      			var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('colCube.list.detail.projectName')}";//项目名称
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.Head')}";//负责人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.Members')}";//成员
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="relation_time";
            	object1.name="relation_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="relation_time";
      			arr.push(object1);
      			}
      			
      			if(event_type=="5"){
      			//任务
      			var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('colCube.list.detail.taskName')}";//任务名称
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.Head')}";//负责人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.Members')}";//成員
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="relation_time";
            	object1.name="relation_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="relation_time";
      			arr.push(object1);
      			}
      			
      			if(event_type=="6"){
      			//知识社区
      			var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//标题
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.creator')}";//创建人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.dealer')}";//处理人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="relation_time";
            	object1.name="relation_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="relation_time";
      			arr.push(object1);
      			}
      			
      			if(event_type=="7"){
      				//文化建设
      			var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//标题
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.publish')}";//发布人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.reply')}";//回复人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="send_time";
            	object1.name="send_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.publishTime')}";//发布时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="send_time";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="deal_time";
            	object1.name="deal_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.replyTime')}";//回复时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="deal_time";
      			arr.push(object1);
      			}
      			
      			if(event_type=='8'){
      			var object1=new Object();
            	object1.id="title";
            	object1.name="title";
            	object1.type="input";
            	object1.text="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//标题
            	object1.value="title";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="sender";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.creator')}";//创建人
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="sender";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="dealer";
            	object1.name="selectPeople";
            	object1.type="selectPeople";
            	object1.text="${ctp:i18n('colCube.list.detail.Members')}";//成员
            	object1.comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Member',maxSize:1";
            	object1.value="dealer";
      			arr.push(object1);
      			var object1=new Object();
      			object1.id="event_time";
            	object1.name="event_time";
            	object1.type="datemulti";
            	object1.text="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
            	object1.ifFormat="%Y-%m-%d",
            	object1.value="send_time";
      			arr.push(object1);
      			}
      			return arr;
            }
            //表格加载
            grid = $('#listStatistic').ajaxgrid({
                colModel:getColumn(),
                render:rend,
                click : clk,
      			dblclick : dblclk,
                showTableToggleBtn: true,
                parentId: "center",
                vChange: true,
                vChangeParam: {
	                overflow: "hidden",
					autoResize:true
	            },
                isHaveIframe:true,
                slideToggleBtn:true,
                callBackTotle:getTotal,
                managerName : "collCubeManager",
                managerMethod : "queryCollCubeDetailList"
            });
            var o=new Object();
            o.user_Id1="${user_Id1}";
            o.user_Id2="${user_Id2}";
            o.dateType="${dateType}";
            o.event_type="${event_type}";
            if(o.event_type=='7'){
            	o.ext1="${ext1}"
            }
            $("#listStatistic").ajaxgridLoad(o);
        });
        
        function clk(data, r, c){
        	if(event_type!='9'){
        		if(event_type=='5'){
        			viewTaskInfo(data.id,0,0);
        		}else{
        			throughPassDetail(data, r, c,'0');
        		}
        	}
        }
        
        function dblclk(data, r, c){
        	if(event_type!='9'){
        		if(event_type=='5'){
        			viewTaskInfo(data.id,0,0);
        		}else{
        			throughPassDetail(data, r, c,'0');
        		}
        	}
        }
        function setUrl_(data){
        	var event_type="${event_type}";
        	var url_="";
        	switch(parseInt(event_type)){
        		case 1:
        			//协同
        	 		url_ = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&isCollCube=1&affairId="+data.id;
        			break;
        		case 2:
        			//公文
        			url_=_ctxPath + "/edocController.do?method=detailIFrame&from=Done&isCollCube=1&affairId="+data.id;
        			break;
        		case 3:
        			//计划
        			url_=_ctxPath+"/plan/plan.do?method=initPlanDetailFrame&readOnly=true&isRef=false&isFromRefer=true&planId="+data.id;
        			break;
        		case 4:
        			url_=_ctxPath+"/mtMeeting.do?method=myDetailFrame&id="+data.id+"&proxy=0&senderId="+data.sender_Id+"&dealerId="+data.dealer_Id+"&isCollCube=1&proxyId=-1&isCollCube=1";
        			//会议
        			break;
        		case 5:
        			//任务
        			url_=_ctxPath+"/taskmanage/taskinfo.do?method=taskDetailIndex&id="+data.id+"&from=Personal";
        			break;
        		case 6:
        			//知识社区
        			url_=_ctxPath+data.ext1+"&isCollCube=1";
        			break;
        		case 7:
        			//文化建设
        			url_=_ctxPath+data.ext1+"&isCollCube=1";
        			break;
        		case 8:
        			//日程事件
        			url_=_ctxPath+"/calendar/calEvent.do?method=editCalEvent&colCube=true&id="+data.id;
        			break;
        		case 10:
        			//项目
        			url_=_ctxPath+"/project.do?method=getProject&from=1&projectId="+data.id;
        			break;	
        	}
        	return url_;
        }
        function throughPassDetail(data,r,c,type){
        	var title="${ctp:i18n('colCube.auth.passThrough.list')}";
        	var url_=setUrl_(data);
        	var event_type="${event_type}";
        	getA8Top().opener=getA8Top();
        	var cubeAuthManager_=new cubeAuthManager;
        	if(event_type=='2'||event_type=='7'){
        		var id=data.id;
        		if(event_type==7){
        			var param=data.ext1.split('&');
        			for(var i=0;i<param.length;i++){
        				var p=param[i].split("=");
        				if(p[0]=="bid"){
        					id=p[1];
        					break;
        				}
        			}
        		}
        		//公文,文化建设
        		var resultMap=cubeAuthManager_.inProcessAuth(event_type,id);
        		if(resultMap.userAuth=="false"){
        			$.alert("${ctp:i18n('"+resultMap.title+"')}");
        			return;
        		}
        		var queryDialog = $.dialog({
          		id : 'url',
          		url : url_,
          		width : $(getCtpTop().document).width()-100,
          		height : $(getCtpTop().document).height()-100,
          		title : title,
          		closeParam:{ 
                		'show':true, 
                		autoClose:false, 
                		handler:function(){ 
                  	 	queryDialog.close();
               	 	} 
            	}, 
           	 	buttons: [{ 
                	text: "${ctp:i18n('common.button.close.label')}", 
                	handler: function () { 
                		queryDialog.close();
                	} 
            	}] 
     	 		});
        	}else{
        		if(type=='0'){
        			$("#summary").attr("src",url_);
        		}else{
        		var queryDialog = $.dialog({
          		id : 'url',
          		url : url_,
          		width : $(getCtpTop().document).width()-100,
          		height : $(getCtpTop().document).height()-100,
          		title : title,
          		closeParam:{ 
                		'show':true, 
                		autoClose:false, 
                		handler:function(){ 
                  	 	queryDialog.close();
               	 	} 
            	}, 
           	 	buttons: [{ 
                	text: "${ctp:i18n('common.button.close.label')}", 
                	handler: function () { 
                		queryDialog.close();
                	} 
            	}] 
     	 		});
        		}
        	}
        }
         function getColumn(){
        	var event_type="${event_type}";
        	var arr = new Array();
     	 	if(event_type=="1"||event_type=="2"||event_type=="3"||event_type=="4"){
     	 		//协同,公文,计划，会议
     	 		var object1 = new Object();
     	 		object1.display="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//標題
      			object1.name = "title";
      			object1.sortable = true;
      			object1.width='15%';
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.sender')}";//发起人
      			object1.width='15%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.dealer')}";//处理人
      			object1.width='15%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('performanceReport.queryMain.textbox.sendTime.name')}";//发起时间
      			object1.width='20%';
      			object1.name = "start_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('performanceReport.workFlowAnalysis.runWorkTim')}";//处理时间
      			object1.name = "event_time";
      			object1.width='20%';
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";//关联类型
      			object1.width='15%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	if(event_type=="10"){
     	 		//项目
     	 		var object1 = new Object();
     	 		object1.display="${ctp:i18n('colCube.list.detail.projectName')}";//项目名称
      			object1.name = "title";
      			object1.sortable = true;
      			object1.width='20%';
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Head')}";//负责人
      			object1.width='20%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Members')}";//成员
      			object1.width='20%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
      			object1.width='20%';
      			object1.name = "event_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";//关联类型
      			object1.width='20%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	
     	 	if(event_type=="5"){
     	 		//任务
     	 		var object1 = new Object();
     	 		object1.display="${ctp:i18n('colCube.list.detail.taskName')}";//任务名称
      			object1.name = "title";
      			object1.sortable = true;
      			object1.width='20%';
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Head')}";//负责人
      			object1.width='20%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Members')}";//成员
      			object1.width='20%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
      			object1.width='20%';
      			object1.name = "event_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";//关联类型
      			object1.width='20%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	if(event_type=="6"||event_type=="8"){
     	 		//知识社区,日程事件
     	 		     	 		var object1 = new Object();
     	 		object1.display="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//标题
      			object1.name = "title";
      			object1.sortable = true;
      			object1.width='20%';
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.creator')}";//创建人
      			object1.width='20%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	
     	 	if(event_type=="6"){
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.dealer')}";//处理人
      			object1.width='20%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
      			object1.width='20%';
      			object1.name = "event_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";//关联类型
      			object1.width='20%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	if(event_type=="8"){
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Members')}";//成员
      			object1.width='20%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Relation')}";//关联时间
      			object1.width='20%';
      			object1.name = "event_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";
      			object1.width='20%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	if(event_type==7){
     	 		var object1 = new Object();
     	 		object1.display="${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";//标题
      			object1.name = "title";
      			object1.sortable = true;
      			object1.width='15%';
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.publish')}";//发布人
      			object1.width='15%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.reply')}";//回复人
      			object1.width='15%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.publishTime')}";//发布时间
      			object1.width='20%';
      			object1.name = "start_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.replyTime')}";//回复时间
      			object1.name = "event_time";
      			object1.width='20%';
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.relationType')}";
      			object1.width='15%';
      			object1.name = "operation_type";
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     	 	if(event_type=="9"){
     	 		object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.agentContent')}";//代理内容
      			object1.width='16%';
      			object1.name = "title";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.agent')}";//代理人
      			object1.width='16%';
      			object1.name = "dealer";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.principal')}";//被代理人
      			object1.width='16%';
      			object1.name = "sender";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.Relation')}";//關聯時間
      			object1.width='16%';
      			object1.name = "event_time";
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.beginTime')}";//開始時間
      			object1.name = "start_time";
      			object1.width='18%';
      			object1.sortable = true;
      			arr.push(object1);
      			object1 = new Object();
      			object1.display="${ctp:i18n('colCube.list.detail.endTime')}";//结束时间
      			object1.name = "end_time";
      			object1.width='18%';
      			object1.sortable = true;
      			arr.push(object1);
     	 	}
     		return arr;
        }
        function rend(txt, data, r, c) {
            return "<span class='grid_black'>"+txt+"</span>";
        }
        
        function getTotal(total){
        	   //页面底部说明加载
            $('#summary').attr("src",_ctxPath + "/collaboration/collaboration.do?method=listDesc&type=listStatistic&size="+total);
        }
        //转发协同 
        function transmitCol(){
            gridChangeTable();
            var reportTitle = "${ctp:i18n('协同立方穿透列表')}";//协同立方穿透列表;
            var contentHtml = $('#center').html();
            getA8Top().up.throughListForwardCol(contentHtml,reportTitle);
        }
        
		function setQueryParam(returnValue){
            	var obj=new Object();
            	if(returnValue.condition!=''&&returnValue!=''){
    				if(returnValue.condition.indexOf("time")!=-1){
    					//有时间条件
    					obj["start_time"]= returnValue.value[0];
    					obj["end_time"]=returnValue.value[1];
    					obj["time_type"]=returnValue.condition;
    				}else if(returnValue.condition.indexOf("sender")!=-1||returnValue.condition.indexOf("dealer")!=-1){
    					//有发起人/处理人
    					obj[returnValue.condition]=returnValue.value[1].split("|")[1];
    				}else{
    					obj[returnValue.condition]=returnValue.value;
    				}
    			}
    			obj["type"]="condition";
    			obj["user_Id1"]="${user_Id1}";
    			obj["user_Id2"]="${user_Id2}";
            	obj["dateType"]="${dateType}";
            	obj["event_type"]="${event_type}";
            	if(obj["event_type"]=="7"){
            		obj["ext1"]="${ext1}";
            	}
    			return obj;
            }
          
          function fillExeclCondition(obj){
            	var cc="";
            	for(var p in obj){
            		cc+=""+p+"="+obj[p]+"&";
            	}
            	cc=cc.substring(0,cc.length-1);
            	var hh="<input type='hidden' id='condition' name='condition' value='"+cc+"'>";
            	$("#queryConditionForm").html(hh);
            }
            
        //Excel导出
        function exportExcel(){
        	var obj="";
        	if(returnValue!=""){
        		obj=setQueryParam(returnValue);
        	}else{
        		obj=setQueryParam("");
        	}
        	fillExeclCondition(obj);
            var searchForm = document.getElementById("queryConditionForm") ;
			searchForm.target = "temp_iframe";
			$("#queryConditionForm").attr("action","${path}/colCube/colCube.do?method=collCubeToExecl")
			searchForm.submit();
       	 }
		function showHelp(){
			var dialog = $.dialog({
    	    id: 'url',
    	    url: _ctxPath+"/colCube/colCube.do?method=showHelp&collType=1",
    	    width: 340,
    	    height: 280,
    	    title: "${ctp:i18n('performanceReport.queryMain_js.help.title')}",
    	    buttons: [{
    	        text: "${ctp:i18n('performanceReport.queryMain_js.button.close')}",
    	        handler: function () {
    	           dialog.close();
    	        }
    	    }]
    	});
		}
        //打印绩效报表穿透查询列表
        function printListCol(){
        	var event_type="${event_type}";
        	if(event_type==4||event_type==1){
        		$("#summary").removeAttr("src");
        	}
            grid.grid.resizeGridUpDown('down');
            var printSubject ="";
            var printsub = "${ctp:i18n('colCube.auth.passThrough.list')}";//绩效报表穿透查询列表;
            printsub = "<center><span style='font-size:24px;line-height:24px;margin-top:10px'>"+printsub+"</span><hr style='height:1px' class='Noprint'></hr></center>";
            
            var printColBody= "${ctp:i18n('performanceReport.queryMain_js.reportType.printTitle')}";
            var content=$('#center').html();
            var index=content.indexOf("grid_detail");
            content=content.substring(0,index-9);
            var colBody ="<div>"+ content + "</div>";
			
            var printSubFrag = new PrintFragment(printColBody,printsub);  
            var colBodyFrag= new PrintFragment(printSubject,colBody);  
            var cssList = new ArrayList();
            cssList.add("/apps_res/collaboration/css/collaboration.css");
            
            var pl = new ArrayList();
            pl.add(printSubFrag);
            pl.add(colBodyFrag);
            printList(pl,cssList);
            //OA-80344协同立方和协同360穿透列表点击打印，关闭打印页面返回列表界面时多出多余的滚动条
            $("#center").css("overflow-y","hidden");
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
     <form action="#" id="queryConditionForm"  style="margin:0;padding:0;" method="post" target="main">
	 </form>
	<div id='layout' class="comp" comp="type:'layout'">
        <div class="layout_north" layout="border:false,height:30,maxHeight:100,minHeight:30">
             <div id="toolbars"></div>
        </div>
       <div class="layout_center" id="center" layout="border:false" style="overflow-y:auto">
       <table class="flexme3" style="display: none" id="listStatistic"></table>
           <div id="grid_detail">
           		<iframe id="summary" width="100%" height="100%" frameborder="0"></iframe>
           </div>
        </div>
    </div>
    </div>
</body>
</html>