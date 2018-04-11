<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><fmt:message key="meeting.cmp.detail.ass"/></title>

<style type="text/css">

  <%-- 
          平台太水了
         视频会议 图标
  --%>
  .bodyType_videoConf{
    background: url("<c:url value="${v3x:getSkin()}/images/workspacecommon/workspacecommon.gif${v3x:resSuffix()}" />") -128px -112px no-repeat;
    padding-left: 16px;
    height: 16px;
  }
</style>

<script type="text/javascript" src="${path}/ajax.do?managerName=meetingListManager"></script>
<script type="text/javascript">

//全局的一个防止指定跟踪人字符串的信息
var zzGzr='';
$(document).ready(function () {
	new MxtLayout({
		'id': 'layout',
		'northArea': {
			'id': 'north',
			'height': 33,
			'sprit': false,
			'border': false
		},
		'centerArea': {
			'id': 'center',
			'border': false,
			'minHeight': 20
		}
	});
            
	//工具栏
          
	//搜索框
	var searchobj = $.searchCondition({
		top:3,
		right:10,
		searchHandler: function() {
			var o = new Object();
			var choose = $('#'+searchobj.p.id).find("option:selected").val();
			if(choose === 'title'){
				o.title = $('#title').val();
			}else if(choose === 'createUser'){
				o.createUser = $('#createUser').val();
			}else if(choose === 'beginDate'){
				var fromDate = $('#from_datetime').val();
				var toDate = $('#to_datetime').val();
				if(fromDate != "" && toDate != "" && fromDate > toDate){
					//$.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能大于结束时间
					return;
				}
				var date = fromDate+'#'+toDate;
				o.beginDate = date;
			}
			o.listType = $("input[name='listType']:checked").attr("listType");
			var val = searchobj.g.getReturnValue();
			if(val !== null){
				$("#listSent").ajaxgridLoad(o);
			}
		},
		conditions: [{
			id: 'title',
			name: 'title',
			type: 'input',
			text: "${ctp:i18n('cannel.display.column.subject.label')}",//标题
			validate:false,
			value: 'title',
			maxLength:100
		}, {
			id: 'createUser',
			name: 'createUser',
			type: 'input',
			text: "${ctp:i18n('cannel.display.column.sendUser.label')}",//发起人
			validate:false,
			value: 'createUser'
		}, {
			id: 'datetime',
			name: 'datetime',
			type: 'datemulti',
			text: "${ctp:i18n('messageManager.hand.starttime')}",//开始时间
			value: 'beginDate',
			ifFormat:'%Y-%m-%d',
			dateTime: true
		}]
	});
            
	//表格加载
	var grid = $('#listSent').ajaxgrid({
		render: render,
		colModel: [{
			id:'id',
			name: 'id',
			width: '4%',
			isToggleHideShow:false
		}, {
			display: "${ctp:i18n('common.subject.label')}",//标题
			name: 'title',
			sortable : true,
			width: '36%'
		},{
			display: "${ctp:i18n('cannel.display.column.sendUser.label')}",//发起人
			name: 'createUserName',
			sortable : true,
			width: '20%'
		},{
			display: "${ctp:i18n('meeting.common.date.begintime.label')}",//发起时间
			name: 'beginDate',
			sortable : true,
			width: '20%'
		},{
			display: "${ctp:i18n('common.date.endtime.label')}",//发起时间
			name: 'endDate',
			sortable : true,
			width: '20%'
		}],
		height: 400,
		showTableToggleBtn: true,
		parentId: $('.layout_center').eq(0).attr('id'),
		vChange: false,
		resizable:false,
		vChangeParam: {
			overflow: "hidden",
			autoResize:true
		},
		isHaveIframe:true,
		managerName : "meetingListManager",
		managerMethod : "getList6Quote"
	});
	
	var o = new Object();
	var stateList = document.getElementsByName('state');
	for(var i=0; i<stateList.length; i++)  {
		if (stateList[i].checked) {
			o.state = stateList[i].value;
			break;
		}
	}
	$("#listSent").ajaxgridLoad(o);
	function render(text, row, rowIndex, meetingIndex, meeting){
		if (meeting.name=="id") {
			var mapOptions = parent.fileUploadAttachments.instanceKeys.instance;
			for(var k = 0; k <mapOptions.length; k++) {
				if (mapOptions[k] == row.id){
					var content = "<input type='checkbox' checked='checked' createDate='"+row.createDate+"' beginDate='"+row.beginDate+"' endDate='"+row.endDate+"' id='boxId' name='"+row.title+"' onclick='selectMeetingInfo(this)' value='"+row.id+"'/>";
					return content;
				}
			}
			var content = "<input type='checkbox' createDate='"+row.createDate+"' beginDate='"+row.beginDate+"' endDate='"+row.endDate+"' id='boxId' name='"+row.title+"' onclick='selectMeetingInfo(this)' value='"+row.id+"'/>";
			return content;
		}
		if(meeting.name=="title") {
			var id = row.id;
			var nameContent = "<a class='card' href='#' onclick='openMeetingInfo(this)' id='"+id+"'>"+text+"</a>";  
			//加图标
			//附件
			if(row.hasAttsFlag === true){
				nameContent = nameContent + "<span class='ico16 affix_16'></span>" ;
			}
			//视频会议图标
			if(row.meetingType ==  '2'){
				nameContent = nameContent + "<span class='bodyType_videoConf inline-block'></span>" ;
		    }
			//协同类型
			if(row.bodyType!==""&&row.bodyType!==null&&row.bodyType!=="HTML") {
				nameContent = nameContent+ "<span class='ico16 "+convertPortalBodyType(row.bodyType)+"'></span>";
			}
			return nameContent;
		}
		return text;
	};
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
       
function deselectItem(affairId){
	$("#boxId[value='"+affairId+"']").attr("checked", false);
}   
  
function changeMeetingType(obj) {
   if(obj.checked) {
	   var o = new Object();
	   o.state = obj.value;
	   o.listType = obj.getAttribute("listType");
	   $("#listSent").ajaxgridLoad(o);
   }
}

function selectMeetingInfo(obj) {
   parent.quoteDocumentSelected(obj, obj.name, 'meeting', obj.value);
}

var v3x = new V3X();
function openMeetingInfo(obj) {
   var url ="${path}/mtMeeting.do?method=myDetailFrame&isQuote=true&id="+obj.id;
   v3x.openWindow({
	   url     : url,
	   FullScrean: 'yes',
	   dialogType: "open",
	   closePrevious : "no"
   });
}

</script>
</head>
<body>
    <div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div class="common_radio_box clearfix" style="padding-top: 8px;">
            	<c:if test="${ctp:hasResourceCode('F09_meetingPending') == true}">
	                <label for="pendingC" class="resCode margin_r_10 hand">
	                    <input type="radio" id="pendingC" listType="listPendingMeeting" name="listType" onclick="changeMeetingType(this)"
	                        class="radio_com" ${(param.state eq '2' || empty param.state) ? 'checked' : ''}/>${ctp:i18n('meeting.quote.list.pending')}<!-- 待召开  -->
	                </label>
                </c:if>
                <c:if test="${ctp:hasResourceCode('F09_meetingDone') == true}">
	                <label for="doneC" class="resCode margin_r_10 hand">
	                    <input type="radio" id="doneC" listType="listDoneMeeting" name="listType" name="state"  onclick="changeMeetingType(this)"
	                        class="radio_com" ${param.state eq '3' ? 'checked' : ''}/>${ctp:i18n('meeting.quote.list.done')}<!--已召开 -->
	                </label>
                </c:if>
            </div>
            <a ></a>
            <div id="toolbars"></div>  
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listSent"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary"  width="100%" height="100%" frameborder="0"  style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
