<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body class="h100b over_hidden">
    <div id="contentDiv" class="w100b h100b over_hidden">
        <div id="tabs" class="comp" comp="type:'tab',parentId:'contentDiv'">
            <div id="tabs_head" class="common_tabs clearfix">
                <ul class="left">
                    <li id="pending" class="current"><a hidefocus="true" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.coltype.Pending.label")}</span></a></li>
                    <li id="done"><a hidefocus="true" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.coltype.Done.label")}</span></a></li>
                    <li id="waitSend"><a hidefocus="true" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.state.11.waitSend")}</span></a></li>
                    <li id="sent"><a hidefocus="true" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("collaboration.coltype.Sent.label")}</span></a></li>
                    <c:if test="${CurrentUser.externalType == 0}">
                        <li id="supervise"><a hidefocus="true" href="javascript:void(0)" tgt="formFlowFrame"><span>${ctp:i18n("bizconfig.supervise.label")}</span></a></li>
                    </c:if>
                </ul>
            </div>
            <div id='tabs_body' class="common_tabs_body">
                <iframe id="formFlowFrame"class="w100b h100b" src="" border="0" frameBorder="no" ></iframe>
            </div>
                <!--<iframe id="pending_iframe" hSrc="${path}/collaboration/collaboration.do?method=listPending${colSuffix}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                <iframe id="done_iframe" class="hidden" hSrc="${path}/collaboration/collaboration.do?method=listDone${colSuffix}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                <iframe id="waitSend_iframe" class="hidden" hSrc="${path}/collaboration/collaboration.do?method=listWaitSend${colSuffix}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                <iframe id="sent_iframe" class="hidden" hSrc="${path}/collaboration/collaboration.do?method=listSent${colSuffix}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
                <iframe id="supervise_iframe" class="hidden" hSrc="${path}/supervise/supervise.do?method=listSupervise&app=1${supSuffix}" width="100%" height="100%" frameborder="0" scrolling="no"></iframe> -->
        </div>
    </div>
</body>
<script>
    $(document).ready(function() {
        $("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listPending${colSuffix}");
        $("#pending").click(function(){
            $("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listPending${colSuffix}");
        });
        $("#done").click(function(){
            $("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listDone${colSuffix}");
        });
        $("#waitSend").click(function(){
            $("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listWaitSend${colSuffix}");
        });
        $("#sent").click(function(){
            $("#formFlowFrame").prop("src","${path }/collaboration/collaboration.do?method=listSent${colSuffix}");
        });
        $("#supervise").click(function(){
            $("#formFlowFrame").prop("src","${path }/supervise/supervise.do?method=listSupervise&app=1${supSuffix}");
        });
    });

    function closeAndFresh() {
        var _win = $("#formFlowFrame")[0].contentWindow;
        _win.location =  _win.location;
    }
</script>
</html>