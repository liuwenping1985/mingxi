<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${name}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<body style="width: 100%;height: 100%">
<c:if test="${code eq '' }">
<div class="comp" comp="type:'breadcrumb',comptype:'location'"></div>
</c:if>
<c:if test="${code ne '' }">
<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'${code }'"></div>
</c:if>
	<div id="contentDiv" style="width: 100%;height: 100%;overflow: hidden;">
		<div id="tabs2" class="comp" comp="type:'tab',parentId:'contentDiv',showTabIndex:${empty param.from ? '0' : '3'}">
		    <div id="tabs2_head" class="common_tabs clearfix">
		    	<ul class="left">
		            <li><a id="btn3" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.coltype.Pending.label") }</span></a></li>
		            <li><a id="btn4" href="javascript:void(0)" tgt="formFlowFrame" ><span>${ctp:i18n("collaboration.coltype.Done.label") }</span></a></li>
		            <li><a id="btn1" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.state.11.waitSend") }</span></a></li>
		            <li><a id="btn2" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.coltype.Sent.label") }</span></a></li>
                    <c:if test="${CurrentUser.externalType == 0}">
		                <li><a id="btn5" href="javascript:void(0)" tgt="formFlowFrame" class='last_tab'><span>${ctp:i18n("bizconfig.supervise.label") }</span></a></li>
                    </c:if>
		        </ul>
		    </div>
		    <div id='tabs2_body' class="common_tabs_body border_all">
			 	<iframe id="formFlowFrame"class="w100b h100b" src="" border="0" frameBorder="no" ></iframe>
		    </div>
		 </div>
	</div>
<script type="text/javascript">
	$(document).ready(function() {
		$("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=${empty param.from ? 'listPending' : 'listSent' }&srcFrom=bizconfig&condition=templeteIds&textfield=${not empty templateIds ? templateIds : param.templeteId}");
		$("#btn1").click(function(){
			$("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listWaitSend&srcFrom=bizconfig&condition=templeteIds&textfield=${not empty templateIds ? templateIds : param.templeteId}");
		});
		$("#btn2").click(function(){
			$("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listSent&srcFrom=bizconfig&condition=templeteIds&textfield=${not empty templateIds ? templateIds : param.templeteId}");
		});
		$("#btn3").click(function(){
			$("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listPending&srcFrom=bizconfig&condition=templeteIds&textfield=${not empty templateIds ? templateIds : param.templeteId}");
		});
		$("#btn4").click(function(){
			$("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listDone&srcFrom=bizconfig&condition=templeteIds&textfield=${not empty templateIds ? templateIds : param.templeteId}");
		});
		$("#btn5").click(function(){
			$("#formFlowFrame").prop("src","${path }/supervise/supervise.do?method=listSupervise&app=1&srcFrom=bizconfig&condition=templeteIds&templeteIds=${not empty templateIds ? templateIds : param.templeteId}");
		});
	});
    
    function closeAndFresh() {
        var _win = $("#formFlowFrame")[0].contentWindow;
        _win.location =  _win.location;
    }
</script>
</body>
</html>