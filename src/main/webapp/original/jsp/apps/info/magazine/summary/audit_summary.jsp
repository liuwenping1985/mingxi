<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-09-07#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>${ctp:toHTML(magazineVO.infoMagazine.subject)}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript" src="${path}/ajax.do?managerName=infoDocManager"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/doc/js/docFavorite.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/info/js/magazine/summary/audit_summary.js${ctp:resSuffix()}"></script>

<script type="text/javascript">
var openFrom = "${ctp:escapeJavascript(openFrom)}";
var isDealPageShow = "${isDealPageShow}";
var affairId = '${param.affairId}';
var commentCount = '${fn:length(commentList)}';
var _isViewPage = '${isViewPage}';//是否为查看页面连接标记
var _currentUserId = "${user.id}";
var  magazineId="${magazineVO.infoMagazine.id}";
var cnaEdit=false;
var isDialog = true;
<c:if test="${isViewPage=='true' }">
   var officecanSaveLocal = 'false';//用于查看页面连接时不能进行保存操作
</c:if>
</script>


<style type="text/css">
.title_view .title_area {
	max-width: 70px;
	width: 70px;
}

.stadic_layout_body{
    position: static;/*覆盖all-main.css的定位方式*/
    margin-top: 10px;
}
</style>
</head>

<body class="h100b over_hidden page_color"  onunload="">
	<input type="hidden" name="openFrom" id="openFrom" value="${ctp:toHTML(openFrom)}" />
	<input type="hidden" name="subject" id="subject" value="${ctp:toHTML(magazineVO.infoMagazine.subject)}" />
	<div id='layout' class="comp" comp="type:'layout'">

		<c:if test="${openFrom=='Pending' }">
		<div class="layout_east" id="east">
            <!--处理区域-->
            <div id="deal_area_show" class="font_size12 align_center h100b hidden hand">
                <span class="ico16 arrow_2_l"></span><br />${ctp:i18n('collaboration.summary.handleOpinion')}
            </div>
            <jsp:include page="audit_deal.jsp" />
        </div><!-- layout_east -->
        </c:if>

		<div class="layout_center over_hidden h100b" id="center">

			<div class="h100b stadic_layout">
				<c:if test="${openFrom=='Pending' }">
 				<div class="stadic_head_height" id="summaryHead">
             		<!--标题+附件区域-->
                    <div id="colSummaryData" class="newinfo_area title_view">
                    	<table border="0" cellspacing="0" cellpadding="0" width="100%">
                                <tr>
                                    <th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>
                                        <div class="title_area w100b">${ctp:i18n('infosend.magazine.list.condition.subject')}<!-- 期刊名称 -->：</div><!-- 标题 -->
                                    </th>
                                    <td width="38%" class="align_left">
                                        <b>${ctp:toHTML(magazineVO.infoMagazine.subject)}</b>
                                    </td>
                                    <th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>
                                        <div class="title_area w100b">${ctp:i18n('infosend.magazine.manager.issue')}<!-- 期号 -->：</div><!-- 期号 -->
                                    </th>
                                    <td width="38%" class="align_left">
                                    	<b>${magazineVO.infoMagazine.magazineNo }</b>
                                    </td>
                                </tr>
                                <tr>
                                    <th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>
                                        <div class="title_area w100b">${ctp:i18n('infosend.score.create.user')}<!-- 创建人 -->：</div><!-- 创建人 -->
                                    </th>
                                    <td width="38%" class="align_left">
                                    	<b>${magazineVO.createUserNameAndTime }</b>
                                    </td>
                                    <th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>
                                        <div class="title_area w100b">${ctp:i18n('infosend.magazine.auditDone.reviewer')}<!-- 审核人 -->：</div><!-- 审核人 -->
                                    </th>
                                    <td width="38%" class="align_left">
                                    	<b>${magazineVO.auditMemberNames }</b>
                                    </td>
                                </tr>
                            </table>
                    </div><!-- colSummaryData -->
             	</div><!-- stadic_head_height -->
             	</c:if>
  				<div id="content_workFlow" class="stadic_layout_body stadic_body_top_bottom processing_view align_center border_t w100b content_view" style="width: 100%;top:0px;visibility: visible;">

                    <ul class="view_ul align_left content_view" id='display_content_view'>
                    	<li id="cc" class="view_li" style="min-width:786px;min-height:620px;">
					        <jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
					    </li>
					    <!--附言区域-->
					    <jsp:include page="/WEB-INF/jsp/common/content/comment.jsp" />
					</ul>

             	</div><!-- stadic_layout_body -->

        	</div><!-- stadic_layout -->

		</div><!-- layout_center -->

	</div><!-- layout -->

</body>
