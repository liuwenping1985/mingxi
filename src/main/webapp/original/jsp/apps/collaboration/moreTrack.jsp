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
<%@ include file="/WEB-INF/jsp/common/commonColList.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/portal.js${ctp:resSuffix()}"></script>
        <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
        var grid;
        var searchobj;
        $(document).ready(function () {
          getCtpTop().hideLocation(); 
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 67,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
            
            var levelCondition = new Array();
            levelCondition.push({text: "${ctp:i18n('common.importance.putong')}",value: '1'}); //普通
            var hasEdoc = "${ctp:hasPlugin('edoc')}";
            if ("true"==hasEdoc) {
        	   levelCondition.push({text: "${ctp:i18n_1('collaboration.pendingsection.importlevl.pingAnxious',i18nValue2)}",value: '2'}); //--平急（公文）/重要（协同、表单
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.important')}",value: '3'}); //加急 (公文)/非常重要（协同、表单）
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.urgent')}",value: '4'}); //特急（公文）
        	   levelCondition.push({text: "${ctp:i18n('collaboration.pendingsection.importlevl.teTi')}",value: '5'}); //-特提（公文）	
            } else {
            	levelCondition.push({text: "${ctp:i18n('common.importance.zhongyao')}",value: '2'}); //--重要
            	levelCondition.push({text: "${ctp:i18n('common.importance.feichangzhongyao')}",value: '3'}); //--非常重要
            }
            
          	//查询条件
            var condition = new Array();
            condition.push({
                id: 'title',
                name: 'title',
                type: 'input',
                text: '${ctp:i18n("cannel.display.column.subject.label")}',//标题
                value: 'subject',
                maxLength:100
            });
            condition.push({
                id: 'importent',
                name: 'importent',
                type: 'select',
                text: '${ctp:i18n("common.importance.label")}',//重要程度
                value: 'importLevel',
                items: levelCondition
            });
            condition.push({
                id: 'sender',
                name: 'sender',
                type: 'input',
                text: '${ctp:i18n("common.sender.label")}',//发起人
                value: 'sender'
            });
            condition.push({
                id: 'datetime',
                name: 'datetime',
                type: 'datemulti',
                text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
                value: 'createDate',
                dateTime: false,
                ifFormat:'%Y-%m-%d'
            });
          	//扫一扫
            var hasBarCode = "${ctp:hasPlugin('barCode')}";
            if (hasBarCode=="true") {
	            condition.push({id:'saoyisao',
	                name:'saoyisao',
	                type:'barcode',
	                text: $.i18n('common.barcode.search.saoyisao'), //扫一扫
	                value:'barcode'
	            });
            }
            
            //搜索框
            searchobj = $.searchCondition({
                top:33,
                right:10,
                searchHandler: function(){
                    
                    var val = searchobj.g.getReturnValue();
                    if(val !== null){
                        $("#moreList").ajaxgridLoad(getSearchValueObj());
                    }
                },
                conditions: condition
            });
            $("#toolbars").toolbar({
                toolbar: [{
                    id: "cancelTrack",
                    name: "${ctp:i18n('track.button.cancel.label')}",//取消跟踪
                    className: "ico16 cancel_track_16",
                    click:cancelTrack
                }],
                borderTop:false,
                borderLeft:false,
                borderRight:false
            });
            
            var colModel = new Array();
            var rowStr="${rowStr}";//需要显示的列
            var rowStr=rowStr.split(",");

            /**
             *当前待办人只在首页更多中加，不在首页中出现，故直接在jsp中加入，不在后台xml中配置
             
            if(rowStr.indexOf("currentNodesInfo")==-1){
	            var last = rowStr[rowStr.length-1];
	            var last2 = rowStr[rowStr.length-2];
	            rowStr.splice(rowStr.length-2,2);
	            if(!rowStr.contains("currentNodesInfo")){
	                rowStr.push("currentNodesInfo");
	            }
	            rowStr.push(last2);
	            rowStr.push(last);
            }*/
            
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
            colModel.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'workitemId',width : idL + '%',isToggleHideShow:false});
            for(var i=0;i<rowStr.length;i++){
              var colNameStr=rowStr[i];
              //标题
              if("subject"==colNameStr){
                  colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'subject',width : titleLen + '%',sortable : true});
              }
              //公文文号(公文字段)
              if("edocMark"==colNameStr){
                  colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : width + '%',sortable : true});
              }
              //发文单位 (公文字段)
              if("sendUnit"==colNameStr){
                  colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.sendUnit.label')}",name : 'sendUnit',width : width + '%',sortable : true});
              }
              //发起人
              if("sendUser"==colNameStr){
                  colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'createMemberName',width : width + '%',sortable : true});
              }
              //发起时间
              if("receiveTime"==colNameStr){
                colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'createDate',width : width + '%',sortable : true});
              }
              
              if ("deadline"==colNameStr) {
                //处理期限
                colModel.push({ display : "${ctp:i18n('common.workflow.deadline.date')}",name : 'deadLine',width : width + '%',sortable : true});
              };
              
              //类型 
              if("category"==colNameStr){
                  colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : width + '%',sortable : true});
              }

              //当前待办人
              if("currentNodesInfo" == colNameStr){       
              	  colModel.push({ display : "${ctp:i18n('collaboration.list.currentNodesInfo.label')}",name : 'currentNodesInfo',width : width + '%',sortable : true});
              }
            }
            //表格加载
            grid = $('#moreList').ajaxgrid({
                id:'gridId',//给grid设置id，用来控制复选框的选择
                callBackTotle: function(t){
                    $("#totalPending").text(t);
                },
                colModel: colModel,
                render : rend,
                click: clickRow,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "pendingManager",
                managerMethod : "getMoreList4SectionContion"
            });
            //回调函数
            function rend(txt, data, r, c, col) {
                if(col.name == "workitemId"){
                    txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
                }else if(col.name == "subject"){
                    //加图标
                    //重要程度
                    if(data.importantLevel!=null && data.importantLevel !=""&& data.importantLevel != 1
                    		&& data.importantLevel <6 && data.importantLevel > 0){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttachments){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //表单授权 （已发 才有）
                    if(data.authority === true && data.state === 2){
                        txt = txt + "<span class='ico16 authorize_16'></span>";
                    }
                    //协同类型
                    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                    	 //公文，会议 属于迁移应用保存的bodyType类型是字符串所以此处做适配正文类型图标 --xiangfan
                        var bodyType = data.bodyType;
                		if(bodyType != null && bodyType != "HTML") {
                			var bodyTypeClass = convertPortalBodyType(bodyType);
                			if (bodyTypeClass !="html_16") {
                			    txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
                			}
                		}
                    }
                    txt = "<a class='color_black'>"+txt+"</a>";
                }else if(col.name == "currentNodesInfo"){
                    //增加打开连接
                    if(txt==null){
                    	txt="";
                    }
                    txt = "<a class='color_black noClick' href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.applicationCategoryKey+"\",\""+data.spervisor+"\")'>"+txt+"</a>";
                } else if(col.name == "createDate") {
					var str = data.createDate;
					if(str != null && str != '') {
						txt = str;
						var tempStrs = str.split(" "); 
						var dateStrs = tempStrs[0].split("-"); 
						var year = parseInt(dateStrs[0]); 
						var month = parseInt(dateStrs[1]) - 1; 
						var day = parseInt(dateStrs[2]);
						if(year==new Date().getYear() && month==new Date().getMonth() && day==new Date().getDate()) {
							txt = "今日 "+tempStrs[1];
						}
					}
				} else if(col.name == "categoryLabel") {
                    var from;
                    var openFrom = "listSent";
                    if(1 == data.state){//待发
                        from = "${ctp:i18n('collaboration.state.11.waitSend')}";
                        openFrom = "listWaitSend";
                    }else if(2 == data.state){//已发
                        from = "${ctp:i18n('collaboration.state.12.col_sent')}";
                        openFrom = "listSent";
                    }else if(3 == data.state){//待办
                    	if(13==data.subState && (data.applicationCategoryKey == 19 || data.applicationCategoryKey==20 || data.applicationCategoryKey==21)) {
                    		from = "${ctp:i18n('collaboration.state.13.col_zcdb')}";
                    		openFrom = "listZcdb";
                    	} else {
                    		from = "${ctp:i18n('collaboration.state.13.col_pending')}";
                    		openFrom = "listPending";
                    	}
                    }else if(4 == data.state){//已办
                        from = "${ctp:i18n('collaboration.state.14.done')}";
                        openFrom = "listDone";
                    }
                    txt = txt +"("+from+")";
                    if(data.hasResPerm == true){
                    	txt = "<a href='javascript:void(0)' class='noClick' onclick='linkToTrack(\""+openFrom+"\",\""+data.state+"\",\""+data.subState+"\",\""+data.applicationCategoryKey+"\")'>"+txt+"</a>";
                    }
                }
                return txt;
           }   
           //点击事件
           function clickRow(data,rowIndex, colIndex){
        	   linkToSummary(data.id,data.state,escapeStringToHTML(escapeStringToHTML(data.subject)),data.applicationCategoryKey,data.applicationSubCategoryKey);
           }

           //取消跟踪 绑定点击事件
           function cancelTrack(){
               var selectedRow = grid.grid.getSelectRows();
               var len = selectedRow.length;
               if (len === 0) {
                   $.alert('${ctp:i18n("collaboration.track.choose")}');
                   return;
               }
               var affairId = "";
               for(i=0;i<len;i++){
                   if(i<len -1){
                       affairId += selectedRow[i].id + ",";
                   }else {
                       affairId += selectedRow[i].id;
                   }
               }
               $('#affairId').val(affairId);
               var confirm = $.confirm({
                   'msg': '${ctp:i18n("collaboration.moreTrack.sureCancelTrack")}',   //确定取消跟踪事项吗？
                   ok_fn: function () {
                       $('#domain').jsonSubmit({
                           action: _ctxPath  + "/portalAffair/portalAffairController.do?method=cancelTrack&rowStr="+rowStr+"&columnsName=${ctp:encodeURI(ctp:encodeURI(columnsName))}"
                       });
                   },
                   cancel_fn:function(){confirm.close();}
               });
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
        
        function linkToTrack(openFrom,state,subState,app){
          var url;
          //公文
          if(app == 19 || app==20 || app==21 ){
              var edocType = 0;
              var entry="sendManager";
              if(app == 19){
              	edocType = 0;
              }else if(app == 20){
              	edocType = 1;
              	entry="recManager";
              }else{
              	edocType = 2;
              	entry="signReport";
              }
              
              if(1 == state){
                url = "/edocController.do?method=entryManager&entry="+entry+"&listType=listWaitSend";
              }
              if(2 == state){
                url = "/edocController.do?method=entryManager&entry="+entry+"&listType=listSent";
              }else if(3 == state){
            	  if(subState==13) {
            		  url = "/edocController.do?method=entryManager&entry="+entry+"&listType=listZcdb";
            	  } else {
            		  url = "/edocController.do?method=entryManager&entry="+entry+"&listType=listPending";
            	  }
              }else if(4 == state){ 
                url = "/edocController.do?method=entryManager&entry="+entry+"&listType=listDone";
              }
          }else if(app == 32) {
			 if(state == 2) {//已发
				url = "/info/infomain.do?method=infoReport&listType=listInfoReported";
			 } else if(state == 3) {//待办
				url = "/info/infomain.do?method=infoAudit&listType=listInfoPending";
			 } else if(state == 4) {//已办
				url = "/info/infomain.do?method=infoAudit&listType=listInfoDone";
			 }
		  }else{
              url = "/collaboration/collaboration.do?method="+openFrom;
          }
          window.location.href = _ctxPath + url;
        }
        
        var dialogDealColl;
        function linkToSummary(affairId,state,subject,app,subApp){          
          var url;
          //公文
          if(app == 19 || app==20 || app==21){
              if(2 == state){
                  url = _ctxPath + "/edocController.do?method=detailIFrame&affairId="+affairId+
                      "&from=sended&detailType=listSent&edocId";
              }else if(3 == state){
                  url = _ctxPath + "/edocController.do?method=detailIFrame&from=Pending&affairId="+affairId;
              }else if(4 == state){
                  url = _ctxPath + "/edocController.do?method=detailIFrame&from=Done&affairId="+affairId;
              }
          }else if(app==32) {//信息报送
			if(state==2) {
				url = _ctxPath + "/info/infoDetail.do?method=summary&openFrom=Send&affairId="+affairId;
			} else if(state==3) {
				url = _ctxPath + "/info/infoDetail.do?method=summary&openFrom=Pending&affairId="+affairId;
			} else {
				url = _ctxPath + "/info/infoDetail.do?method=summary&openFrom=Done&affairId="+affairId;
			}
		  } else{
              //协同
              //默认已发
              var from = "listSent";
              if(1 === state){
                  from = "listWaitSend";
              }else if(2 === state){
                  from = "listSent";
              }else if(3 === state){
                  from = "listPending";
              }else if(4 === state){
                  from = "listDone";
              }
              url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom="+from+"&affairId=" + affairId;
          }
          var params = {callbackOfPendingSection:closeAndFresh,pwindow:window};
          getCtpTop().showSummayDialogByURL(url,subject,params);
      }
        
      function closeAndFresh() {
           getCtpTop().dialogDealColl.close();
           $('#moreList').ajaxgridLoad();
      }
      //二维码传参chenxd
      function precodeCallback(){
      	var obj = getSearchValueObj();
      	obj.openFrom = "moreTrack";
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
          }else if(choose === 'importLevel'){
        	  o.condition = choose;
              o.textfield = $.trim($('#importent').val());
          }else if(choose === 'sender'){
        	  o.condition = choose;
              o.textfield = $.trim($('#sender').val());
          }else if(choose === 'createDate'){
        	  o.condition = choose;
              var fromDate = $.trim($('#from_datetime').val());
              var toDate = $.trim($('#to_datetime').val());
              if(fromDate != "" && toDate != "" && fromDate > toDate){
                  $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
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
    <div id='layout' class="font_size12">
        <div class="layout_north f0f0f0" id="north">
            <div class="clearfix">
                <span class="left color_666 font_size14 padding_l_10 padding_t_5">${ctp:toHTML(columnsName)}${ctp:i18n_1('common.items.count.label',total)}</span><!-- 跟踪事项 -->
            </div>
            <div id="toolbars"> </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="moreList"></table>
        </div>
        <div id="domain">
            <input type="hidden" id="fragmentId" value="${params.fragmentId}"/>
	        <input type="hidden" id="ordinal" value="${params.ordinal}"/>
	        <input type="hidden" id="state" value="${params.state}"/>
	        <input type="hidden" id="isTrack" value="${params.isTrack}"/>
	        <input type="hidden" id="affairId"/>
        </div>
    </div>
    </div>
    <ctp:webBarCode readerId="PDF417Reader" readerCallBack="codeCallback" decodeParamFunction="precodeCallback" decodeType="codeflowurl"/>
</body>
</html>
