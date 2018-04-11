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
    <title>已发事项</title>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/collaboration.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" charset="UTF-8" src="${path}/apps_res/collaboration/js/portal.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
    var searchobj;
    var isV5Member = ${CurrentUser.externalType == 0};
        $(document).ready(function () {
            if (isV5Member) {
				getCtpTop().hideLocation();
            }
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
            var levelCondition = new Array();
            levelCondition.push({text: "${ctp:i18n('common.importance.putong')}",value: '1'}); //普通
            var hasEdoc = "${ctp:hasPlugin('edoc')}";
            if ("true"==hasEdoc && isV5Member) {
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
                id: 'datetime',
                name: 'datetime',
                type: 'datemulti',
                text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
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
                    
                    var val = searchobj.g.getReturnValue();
                    if(val !== null){
                        $("#moreList").ajaxgridLoad(getSearchValueObj());
                    }
                },
                conditions: condition
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
                click: clickRow,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "pendingManager",
                managerMethod : "getMoreList4SectionContion"
            });
            //回调函数
            function rend(txt, data, r, c,col) {
                if(col.name == "subject"){
                    //加图标
                	//流程状态
                    if(data.summaryState !== null && data.summaryState !=="" && data.summaryState != "0"){
                        txt = "<span class='ico16  flow"+data.summaryState+"_16 '></span>"+ txt ;
                    }
                    //重要程度
                    if(data.importantLevel != null && data.importantLevel !=""&& data.importantLevel != 1
                            && data.importantLevel <6 && data.importantLevel > 0){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttachments){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
                    	var bodyTypeClass = convertPortalBodyType(data.bodyType);
                    	if (bodyTypeClass !="html_16") {
                    		txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
                    	}
                    }
                    txt = "<a class='color_black'>"+txt+"</a>";
                }else if(col.name == "categoryLabel"){
                	if(data.hasResPerm == true){
	                    txt = "<a href='javascript:void(0)' class='noClick' onclick='linkToSent("+data.applicationCategoryKey +")'>"+txt+"</a>";
                	}
                }else if(col.name == "currentNodesInfo"){
                    //增加打开连接
                    if(txt==null){
                    	txt="";
                    }
                    if(data.processId != 0){
                    	txt = "<a class='color_black noClick' href='javascript:void(0)' onclick='showFlowChart(\""+ data.caseId +"\",\""+data.processId+"\",\""+data.templeteId+"\",\""+data.activityId+"\",\""+data.applicationCategoryKey+"\",\""+data.spervisor+"\")'>"+txt+"</a>";
                    }
                } 
                return txt;
           }    
           
        });
      	//点击事件
        function clickRow(data,rowIndex, colIndex){
    	  
        	linkToSummary(data.id,escapeStringToHTML(escapeStringToHTML(data.subject)),data.applicationCategoryKey);
        }
        function linkToSent(app){
            if(app ===19){ //公文-发文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=sendManager&listType=listSent";
            }else if(app ===20){ //公文-收文
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=recManager&listType=listSent";
            }else if(app ===21){ //公文-签报
              window.location.href = _ctxPath + "/edocController.do?method=entryManager&entry=signReport&listType=listSent";
            }else {
              window.location.href = _ctxPath + "/collaboration/collaboration.do?method=listSent";
            }
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
        //二维码传参chenxd
        function precodeCallback(){
        	var obj = getSearchValueObj();
        	obj.openFrom = "moreSent";
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
            }else if(choose === 'createDate'){
            	o.condition = choose;
                var fromDate = $.trim($('#from_datetime').val());
                var toDate = $.trim($('#to_datetime').val());
                o.textfield = fromDate;
                o.textfield1 = toDate;
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert("${ctp:i18n('collaboration.rule.date')}");//结束时间不能早于开始时间
                    return;
                }
            }
            return o;
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north f0f0f0" id="north">
            <div style="padding-bottom:40px;">
                <div class="clearfix">
                    <span class="left color_666 font_size14 padding_l_10 padding_t_5" >${ctp:toHTML(columnsName)}${ctp:i18n_1('common.items.count.label',total)}</span><!-- 已发事项 -->
                </div>
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
        
    </div>
    </div>
    <ctp:webBarCode readerId="PDF417Reader" readerCallBack="codeCallback" decodeParamFunction="precodeCallback" decodeType="codeflowurl"/>
</body>
</html>
