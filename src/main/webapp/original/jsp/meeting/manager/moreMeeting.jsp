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
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript">
        $(document).ready(function () {
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
            //搜索框
            var searchobj = $.searchCondition({
                top:35,
                right:10,
                searchHandler: function(){
                    var o = new Object();
                    o.fragmentId = $.trim($('#fragmentId').val());
                    o.state = $.trim($('#state').val());
                    o.meeting_category = $.trim($('#meeting_category').val());
                    o.ordinal = $.trim($('#ordinal').val());
                    o.isTrack = $.trim($('#isTrack').val());
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
                }]
            });
            
            var colModel = new Array();
            var rowStr="${rowStr}";//需要显示的列
            rowStr=rowStr.split(",");
            colModel.push({ display : '<input type="checkbox" onclick="getGridSetAllCheckBoxSelect123456(this,\'gridId_classtag\')">',name : 'workitemId',width : '4%',isToggleHideShow:false});
            for(var i=0;i<rowStr.length;i++){
                var colNameStr=rowStr[i];
                //标题
                if("subject"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.subject.label')}",name : 'subject',width : '40%',sortable : true});
                    //处理期限
                    colModel.push({ display : "${ctp:i18n('common.workflow.deadline.date')}",name : 'deadLine',width : '10%',sortable : true});
                    colModel.push({ display : "${ctp:i18n('common.date.sendtime.label')}",name : 'createDate',width : '10%',sortable : true});
                }
                //公文文号(公文字段)
                if("edocMark"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.edocMark.label')}",name : 'edocMark',width : '10%',sortable : true});
                }
                //发文单位 (公文字段)
                if("sendUnit"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.sendUnit.label')}",name : 'sendUnit',width : '10%',sortable : true});
                }
                //会议地点(会议字段)
                if("placeOfMeeting"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.placeOfMeeting.label')}",name : 'placeOfMeeting',width : '13%',sortable : true});
                }
                //主持人(会议字段)
                if("theConferenceHost"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.cannel.display.column.theConferenceHost.label')}",name : 'theConferenceHost',width : '10%',sortable : true});
                }
                //发起人
                if("sendUser"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('common.sender.label')}",name : 'createMemberName',width : '7%',sortable : true});
                }
                //接收时间
                if("receiveTime"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('collaboration.receive.time.label')}",name : 'receiveTime',width : '10%',sortable : true});
                }
                //类型 
                if("category"==colNameStr){
                    colModel.push({ display : "${ctp:i18n('cannel.display.column.category.label')}",name : 'categoryLabel',width : '6%',sortable : true});
                }
            }
            //表格加载
            var grid = $('#moreList').ajaxgrid({
                colModel: colModel,
                render : rend,
                parentId: $('.layout_center').eq(0).attr('id'),
                resizable:false,
                managerName : "pendingManager",
                managerMethod : "getMoreList4SectionContion"
            });
            //回调函数
            function rend(txt, data, r, c, col) {
                if(col.name == "workitemId"){
                    txt='<input type="checkbox" name="workitemId" gridrowcheckbox="gridId_classtag" class="noClick" row="'+r+'" value="'+data.id+'">';
                }
                if(col.name == "subject"){
                    //加图标
                    //重要程度
                    if(data.importantLevel !=null&&data.importantLevel !=""&& data.importantLevel != 1){
                        txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
                    }
                    //附件
                    if(data.hasAttachments === true){
                        txt = txt + "<span class='ico16 affix_16'></span>" ;
                    }
                  	//视频图标 1普通会议 2视频会议
                    if(data.meetingNature === "2") {
                        txt = txt + "<span class='ico16 meeting_video_16'></span>" ;
                    }
                    //协同类型
                    if(data.bodyType!=="" && data.bodyType!==null && data.bodyType!=="10" && data.bodyType!=="30" && data.bodyType!=="HTML"){
                    	var bodyType = data.bodyType;
               			var bodyTypeClass = convertPortalBodyType(bodyType);
               			if (bodyTypeClass !="html_16") {
               			    txt = txt+ "<span class='ico16 "+bodyTypeClass+"'></span>";
               			}
                    }
                    txt = "<a class='color_black' onclick='linkToSummary(\""+data.entityId+"\",\""+data.subject+"\","+data.applicationCategoryKey+",\""+data.objectId+"\")'>"+txt+"</a>";
                }else if(col.name == "categoryLabel"){
                    txt = "<a onclick='linkToDone("+data.applicationCategoryKey +")'>"+txt+"</a>";
                }
                return txt;
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
        
        function linkToDone(app){
            if(app === 6){//会议应用
              window.location.href = _ctxPath + "/meetingNavigation.do?method=entryManager&entry=meetingDone";
            }else if(app === 29){//会议室
              window.location.href = _ctxPath + "/meetingroom.do?method=index";
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
            var params = {pwindow:window};
            getCtpTop().showSummayDialogByURL(url,subject,params);
        }
    </script>
</head>
<body>
    <div id='layout' class="font_size12">
        <div class="layout_north bg_color" id="north">
            <div class="border_lr border_t" style="padding-bottom:35px;">
                <div class="clearfix">
                    <span class="left color_gray font_size24 padding_l_10 padding_t_5">${ctp:i18n_1('meeting.portal.more.done.label',total)}</span><!-- 已发事项 -->
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
        <input type="hidden" id="isTrack" value="${params.isTrack}"/>
        <input type="hidden" id="meeting_category" value="${meeting_category}"/>
        
    </div>
    </div>
</body>
</html>
