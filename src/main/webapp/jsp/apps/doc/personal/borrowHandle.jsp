<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@page import="java.util.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n('doc.lending.request')}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/doc.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var jsURL = "${path}/doc.do";
<%@ include file="/WEB-INF/jsp/apps/doc/js/docUtil.js"%>
<%@ include file="/WEB-INF/jsp/apps/doc/js/borrowHandle.js"%>
try{
	var tohtml="<span class='nowLocation_content'>"+
	"<a title='${ctp:i18n('channel.doc.label.A8')}'>${ctp:i18n('channel.doc.label.A8')}</a> > "+	
	"<a href='###' onclick='javascript:showMenu(\"${path}/doc/knowledgeController.do?method=personalKnowledgeCenterIndex\")'"+
	" title='${ctp:i18n('doc.jsp.knowledge.center')}'>${ctp:i18n('doc.jsp.knowledge.center')}</a> > "+
    '<a href="###" title="'+'${ctp:i18n("doc.lending.request")}"'+'onclick="javascript:showMenu(\''+'${path}/doc/knowledgeController.do?method=link&prefix=personal&path=borrowHandle'+'\')">'+
    "${ctp:i18n('doc.lending.request')}</a></span>";
    
	showCtpLocation("",{html:tohtml});
}catch(e){
}

</script>
</head>
<body class="page_color">
<div class="area_page bg_color_white">
        <div class="border_b clearFlow padding_b_5 bg_color_gray">
            <div class="hr_heng"></div> 
            <div class="color_gray  font_size14 margin_t_5 margin_l_10">
                ${ctp:i18n('doc.lending.request')}(<span id="dataTotalId">0</span>${ctp:i18n('doc.jsp.open.body.comment.items')})
            </div>
        </div>
        <div class="padding_10">
            <%--请求消息 --%>
            <ul id="ulContentId" class="bg_color_white clearfix">
            </ul>
            <!-- 分页条 -->
            <%@ include file="/WEB-INF/jsp/apps/doc/flipInfoBar.jsp"%>
        </div>

        <!-- JS拼装的模版   -->
    <div id="templeteDivId" class="display_none">
        <li class="qingqiu padding_10 border_b_gray left_ie6"><img id="borrowUserImg" onclick="javascript:fnPersonCard(this);"
            class="radius left margin_l_10 margin_b_10 margin_r_20 hand personCard" src=""
            width="42" height="42" />
            <div class="over_auto_hiddenY">
                <div class="clearfix">
                    <span class="left"><a id="borrowUserName" onclick="javascript:fnPersonCard(this);"
                        class="left margin_r_5">${ctp:i18n('doc.author')}</a><span class="left margin_r_5">${ctp:i18n('doc.jsp.properties.label.borrow')}</span><span
                        id="styleId" defclass="left margin_r_5 ico16"></span><a id="frName" 
                        class="left margin_r_5" onclick="javascript:fnOpenDoc(this);"></a><span id="avgScore" defclass="left"></span>
                    </span> <span id="borrowTimeString" class="color_gray right"></span>
                </div>
                <div class="over_auto_hiddenY left_ie6">
                    <div id="borrowMsg" class="line_height180 margin_t_5 font_size12"></div>
                    <div class="clearfix margin_t_10">
                        <span class="left margin_t_5"><span id="logicalPathTemp"><a 
                                onclick="javascript:fnToDocPath(this);"></a> </span>${ctp:i18n('doc.file.path')}:<span
                            id="logicalPathNames"></span> </span>
                        <%--删除 <span class="qingqiu_item hidden right margin_l_10"><a
                            id="hrefDelBorrowId"  onclick="javascript:fnDelBorrow(this);">${ctp:i18n('doc.jsp.properties.share.delete')}</a>
                        </span> --%>
                        <span class="qingqiu_item hidden right margin_l_10"><a id="hrefIgnoreBorrowId" 
                            onclick="javascript:fnIgnoreBorrow(this);">${ctp:i18n('doc.ignore')}</a> </span> <span
                            class="qingqiu_item hidden right margin_l_10"><a id="hrefRefuseBorrowId" 
                            onclick="javascript:fnRefuseBorrow(this);">${ctp:i18n('doc.refuse')}</a> </span> <span
                            class="qingqiu_item hidden right margin_l_10"><a id="hrefAgreeBorrowId" 
                            onclick="javascript:fnAgreeBorrow(this);">${ctp:i18n('doc.agreed.to.borrowing')}</a> </span>
                    </div>
                </div>
            </div>
        </li>
    </div>
 </div>
</body>
</html>