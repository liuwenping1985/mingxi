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
<%@ include file="/WEB-INF/jsp/common/commonColList.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/portal.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    var searchobj;
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
            //页签判断
            var entityType = $.trim('${param.entityType}');
            if(entityType === '1'){
            	 $('#colSupervise').attr('class','current');
            }else if(entityType === '2'){
            	$('#edocSupervise').attr('class','current');
            }else{
            	$('#allSupervise').attr('class','current');
            }
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
                text: "${ctp:i18n('cannel.display.column.subject.label')}",//标题
                value: 'subject',
                maxLength:100
            });
            condition.push({
                id: 'importent',
                name: 'importent',
                type: 'select',
                text: "${ctp:i18n('common.importance.label')}",//重要程度
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
            var hasBarCode = "${ctp:hasPlugin('barCode')}";
            //扫一扫
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
                top:35,
                right:10,
                searchHandler: function(){
                    
                    $("#moreList").ajaxgridLoad(getSearchValueObj());
                },
                conditions:condition
            });
            //表格加载
            var colModel = new Array();
            var rowStr = "${param.rowStr}";//需要显示的列
            rowStr = rowStr.split(",");

            /**
             *当前待办人只在首页更多中加，不在首页中出现，故直接在jsp中加入，不在后台xml中配置
             
            if(rowStr.indexOf("currentNodesInfo")==-1){
	            var last = rowStr[rowStr.length-1];
	            var last2 = rowStr[rowStr.length-2];
	            rowStr.splice(rowStr.length-2,2);
	            rowStr.push("currentNodesInfo");
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
         	 //协同时 少2列 (公文文号、发文单位)
            if($.trim('${param.entityType}') == '1'){
            	//判断是否有公文文号
            	if("${param.rowStr}".indexOf(',edocMark') != -1){
            		len = len -1;
            	}
            	//判断是否有发文单位
            	if("${param.rowStr}".indexOf(',sendUnit') != -1){
            		len = len -1;
            	}
            	titleLen = 40;
            }
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
            colModel.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'id',width : idL + '%',isToggleHideShow:false});
            for(var i = 0;i < rowStr.length;i++){
                var colNameStr = rowStr[i];
                //标题
                if("subject" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'title',width : titleLen + '%',sortable : true});
                }
                //发起时间
                if("receiveTime" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'sendDate',width : width + '%',sortable : true});
                }
              	//流程期限
                if("deadlineName" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.date.deadlineName.label')}",name : 'deadlineDatetime',width : width + '%',sortable : true});
                }
                //协同时不显示公文的信息
                if($.trim('${param.entityType}') != '1'){
                	//公文文号(公文字段)
                    if("edocMark" == colNameStr){
                        colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : width + '%',sortable : true});
                    }
                    //发文单位 (公文字段)
                    if("sendUnit" == colNameStr){
                        colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.sendUnit.label')}",name : 'sendUnit',width : width + '%',sortable : true});
                    }
                }
                //发起人
                if("sendUser" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'senderName',width : width + '%',sortable : true});
                }
                if("deadline" == colNameStr){
                	colModel.push({ display : "${ctp:i18n('supervise.col.deadline')}",name : 'awakeDate',width : width + '%',sortable : true});
                }
                //分类
                if("category" == colNameStr){
                    colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'appName',width : width + '%',sortable : true});
                }
              	//当前待办人
                if("currentNodesInfo" == colNameStr){
                	colModel.push({ display : "${ctp:i18n('collaboration.list.currentNodesInfo.label')}",name : 'currentNodesInfo',width : width + '%',sortable : true});
                }
            }
            var grid = $('#moreList').ajaxgrid({
                callBackTotle: function(t){
                    $("#totalPending").text(t);
                },
                colModel: colModel,
                render : rend,
                click: clickRow,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "superviseManager",
                managerMethod : "getSuperviseList4Portal"
            });
            //回调函数
            function rend(txt, data, r, c, col) {
                if(col.name == "id"){
                    txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
                } else if(col.name == "title"){
                    //加图标
                    //重要程度
                    if(data.importantLevel !=null && data.importantLevel !="" && data.importantLevel != 1){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttachment === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"&&data.bodyType!=="HTML"){
                        var bodyType = data.bodyType;
                        //公文，会议 属于迁移应用保存的bodyType类型是字符串所以此处做适配正文类型图标 --xiangfan
                        if(bodyType == "OfficeWord"){
                           bodyType = 41;
                        }else if(bodyType == "OfficeExcel"){
                           bodyType = 42;
                        }else if(bodyType == "WpsWord"){
                           bodyType = 43;
                        }else if(bodyType == "WpsExcel"){
                           bodyType = 44;
                        }
                        txt = txt+ "<span class='ico16 office"+bodyType+"_16'></span>";
                    }
                    txt = "<a class='color_black'>"+txt+"</a>";
                }else if(col.name == "appName"){
                	//判断是否有资源菜单
                	var isHave = false;
                	if(data.entityType == 1){
                		//判断协同
                		if($.ctx.resources.contains('F01_supervise')){
                			isHave = true;
                		}
                	}else {
                		//判断公文
                		if($.ctx.resources.contains('F07_edocSupervise')){
                			isHave = true;
                		}
                	}
                	if(isHave){
	                    txt = "<a href='javascript:void(0)' class='noClick' onclick='linkToSupervise("+data.entityType+")'>"+txt+"</a>";
                	}
                }else if(col.name == "currentNodesInfo"){
                    //增加打开连接
                    if(txt==null){
                    	txt="";
                    }
                    txt = "<a class='color_black noClick' href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.appType+"\",\"true\")'>"+txt+"</a>";
                }else if(col.name == "awakeDate"){
                	if(data.isRed == true){
                        txt = "<span class='color_red'>"+txt+"</span>";
                    }
                }
				 // 当流程期限超期后，把流程期限标红
				if(col.name == "deadlineDatetime"){
					if(data.workflowTimeout == true){
						txt = "<span class='color_red'>"+txt+"</span>";
					}
				}
                return txt;
           }
            //点击事件
            function clickRow(data,rowIndex, colIndex){
         	   linkToSummary(data.affairId,escapeStringToHTML(escapeStringToHTML(data.title)),data.summaryId,data.status,data.entityType);
            }

           //全部绑定点击事件
           $('#allSupervise').click(function(){
               //将搜索条件框置为默认情况
               searchobj.g.hideItem(searchobj.p.id,true);
               $(this).parent().find('li').each(function(){
                   $(this).attr('class','');
               });
               $(this).parent().find('#allSupervise').attr('class','current');
               //给标志位赋值
               /* $('#entityType').val('all');
               var o = new Object();
               searchConditon(o);
               $("#moreList").ajaxgridLoad(o); */
               var url = _ctxPath + "/supervise/supervise.do?method=moreSupervise&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&rowStr=${param.rowStr}&columnsName=${ctp:encodeURI(columnsName)}";
               window.location.href = url;
           });
           //协同绑定点击事件
           $('#colSupervise').click(function(){
               //将搜索条件框置为默认情况
               searchobj.g.hideItem(searchobj.p.id,true);
               $(this).parent().find('li').each(function(){
                   $(this).attr('class','');
               });
               $(this).parent().find('#colSupervise').attr('class','current');
               //给标志位赋值
               $('#entityType').val('1');
               /* var o = new Object();
               o.entityType = [1];
               searchConditon(o);
               $("#moreList").ajaxgridLoad(o); */
               var url = _ctxPath + "/supervise/supervise.do?method=moreSupervise&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&rowStr=${param.rowStr}&entityType=1&columnsName=${ctp:encodeURI(columnsName)}";
               window.location.href = url;

           });
           //公文绑定点击事件
           $('#edocSupervise').click(function(){
               //将搜索条件框置为默认情况
               searchobj.g.hideItem(searchobj.p.id,true);
               $(this).parent().find('li').each(function(){
                   $(this).attr('class','');
               });
               $(this).parent().find('#edocSupervise').attr('class','current');
               //给标志位赋值
               $('#entityType').val('2');
               /* var o = new Object();
               o.entityType = [2];
               searchConditon(o);
               $("#moreList").ajaxgridLoad(o); */
               var url = _ctxPath + "/supervise/supervise.do?method=moreSupervise&fragmentId=${param.fragmentId}&ordinal=${param.ordinal}&rowStr=${param.rowStr}&entityType=2&columnsName=${ctp:encodeURI(columnsName)}";
               window.location.href = url;
           });
           

        });

        function linkToSupervise(app){
        	if(app=='2'){
        		app=4;
        	}
            window.location.href = _ctxPath + "/supervise/supervise.do?method=listSupervise&app=" + app;
        }
        function linkToSummary(affairId,subject,summaryId,status,app){
            var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=supervise&type=0&affairId=" + affairId;
            if(app==2){
            	url = _ctxPath + "/edocController.do?method=detailIFrame&summaryId="+summaryId+"&openFrom=supervise&affairId="+affairId+"&type="+status;
            }
            getCtpTop().showSummayDialogByURL(url,subject,null);
        }
        //二维码传参chenxd
        function precodeCallback(){
        	var obj = getSearchValueObj();
        	obj.openFrom = "moreSupervise";
        	return obj;
        }
        //查询条件封装
        function searchConditon(obj){
            var condtionType = $('#condtionType').val();
            var condtionValue = $('#condtionValue').val();
            if("importLevel" == condtionType){
                obj.importLevel = [condtionValue];
            }
            if("category" == condtionType){
                obj.category = [condtionValue];
            }
            if("templete" == condtionType){
         	   obj.templete = [condtionValue];
            }
        }
        function getSearchValueObj(){
        	var o = new Object();
            //判断是全部、协同、公文
            var value = $.trim('${param.entityType}');
            if('' === value){
                o.entityType = [1,2];
            }else if('1' === value){
                o.entityType = [1];
            }else if('2' === value){
                o.entityType = [2];
            }
            searchConditon(o);
            var result = searchobj.g.getReturnValue();
            if($.trim(result) != ""){
            	var val = result.value;
                var choose = result.condition;
                if(choose === 'subject'){
                    o.subject = [val];
                }else if(choose === 'importLevel'){
                    var level = o.importLevel;
                    if($.trim(level) !="" && level[0].indexOf(val) == -1){
                        o.importLevel = [-1];
                    }else{
                        o.importLevel = [val];
                    }
                }else if(choose === 'sender'){
                    o.sender = [val];
                }else if(choose === 'createDate'){
                    var fromDate = $.trim($('#from_datetime').val());
                    var toDate = $.trim($('#to_datetime').val());
                    o.createDate = [fromDate,toDate];
                    if(fromDate != "" && toDate != "" && fromDate > toDate){
                        $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
                        return;
                    }
                }
            }
            return o;
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north f0f0f0" id="north">
            <div class="padding_b_10">
              <div class="clearfix">
                  <span class="left color_666 font_size14 padding_l_10 padding_t_5">${ctp:toHTML(columnsName)}${ctp:i18n_1('common.items.count.label',total)}</span><!-- 督办事项 -->
              </div>
              <div class="common_tabs clearfix margin_l_5 margin_t_10 f0f0f0">
                   <ul class="left">
                       <li id="allSupervise">
                          <a href="javascript:void(0)" class="border_b">${ctp:i18n('section.panel.all.label')}${ctp:i18n_1('common.items.count.label',total)}</a><!-- 全部 -->
                       </li>
                       <c:if test="${ctp:hasPlugin('collaboration')}">
                       		<c:if test="${isShowCol}"><%-- 如果流程来源只是公文 就去掉协同页签 OA-17749--%>
	                            <li id="colSupervise">
	                            	<c:choose>
	                            		<c:when test="${isShowEdoc}">
	                            			<a href="javascript:void(0)" class="border_b">${ctp:i18n('section.app.collaboration.label')}${ctp:i18n_1('common.items.count.label',colSize)}</a><!-- 协同 -->
	                            		</c:when>
	                            		<c:otherwise>
	                            			<a href="javascript:void(0)" class="border_b last_tab">${ctp:i18n('section.app.collaboration.label')}${ctp:i18n_1('common.items.count.label',colSize)}</a><!-- 协同 -->
	                            		</c:otherwise>
	                            	</c:choose>
	                            </li>
                       		</c:if>
                       </c:if>

                       <c:if test="${ctp:hasPlugin('edoc')}">
                       		<c:if test="${isShowEdoc}">
	                       		<li id="edocSupervise">
	                          		<a href="javascript:void(0)" class="border_b last_tab">${ctp:i18n('section.app.edoc.label')}${ctp:i18n_1('common.items.count.label',edocSize)}</a><!-- 公文 -->
	                       		</li>
                       		</c:if>
                       </c:if>
                   </ul>
              </div>
              <div id="toolbars"> </div>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="moreList"></table>
        </div>
        <!-- 判断是全部、协同、公文 -->
        <input type="hidden" id="entityType" value="all"/>
        <!-- 栏目编辑 流程来源 类型 -->
        <input type="hidden" id="condtionType" value="${condtionType}"/>
        <!-- 栏目编辑 流程来源 值 -->
        <input type="hidden" id="condtionValue" value="${condtionValue}"/>
    </div>
    <ctp:webBarCode readerId="PDF417Reader" readerCallBack="codeCallback" decodeParamFunction="precodeCallback" decodeType="codeflowurl"/>
</body>
</html>
