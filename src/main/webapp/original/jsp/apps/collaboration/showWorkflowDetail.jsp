<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="bg_color_white">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
function OK(){
	
}

function toDetailInfo(data, rowIndex, colIndex){
	var url = "${path}/"+data.detailPageUrl+"&affairId="+data.affairId+"&openFrom=repealRecord&summaryId="+data.objectId+"&trackTypeRecord="+data.trackType;
 	var title = data.subject;
	var width = $(getA8Top().document).width() - 60;
 	var height = $(getA8Top().document).height() - 50;
 	var dialog = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'dialogDealColl',
        targetWindow:getCtpTop()
    });
	
}

var grid;
window.onload = function(){
	/**定义列表开始**/
	var colModel = new Array();
	var width = '36%';
	//标题
	colModel.push({ display : "${ctp:i18n('supervise.subject.label')}",name : 'subject',width : width,sortable : true});
    //发起时间
    colModel.push({ display : "${ctp:i18n('supervise.date.sendtime.label')}",name : 'senderTime',width : '20%',cutsize : 10,sortable : true});
    //撤销/回退人   
    colModel.push({ display : "${ctp:i18n('collaboration.undoRollback.staff')}",name : 'operationName',width : '15%',sortable : true});//撤销/回退人
    //撤销/回退时间       
    colModel.push({ display : "${ctp:i18n('collaboration.undoRollback.time')}",name : 'operationTime',width : '20%',sortable : true});//撤销/回退时间
	//操作内容
    colModel.push({ display : "${ctp:i18n('processLog.list.content.label')}",name : 'trackType',width : '10%',sortable : true});//操作内容
    /**定义列表结束**/
    
    grid = $("#workflowtrace").ajaxgrid({
        colModel : colModel,
        click : toDetailInfo,
        render : rend,
        height: 375,
        parentId: $('.layout_center').eq(0).attr('id'),
        showTableToggleBtn: true,
        vChange: true,
        vChangeParam:{overflow:"hidden"},
        isHaveIframe:true,
        slideToggleBtn:false,
        onSuccess:function(){},
        managerName : "traceWorkflowManager",
        managerMethod : "getPageInfoInSummaryJsp"
      });
	var obj= new Object();
	obj.affairId = '${affairId}';
	obj.app = '${app}';
    $("#workflowtrace").ajaxgridLoad(obj);
    
    function rend(txt, data, r, c) {
        if(c == 4){
			if(data.trackType == 5){
				return $.i18n("collaboration.common.cancel.label.js");//撤销
			}else{
				return $.i18n("collaboration.common.stepBack.label.js");//回退
			}
        }
		return txt;
    }
}
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()">
<div class="margin_l_10">
	<table id="workflowtrace" style="display: none"></table>
</div>
</body>
</html>