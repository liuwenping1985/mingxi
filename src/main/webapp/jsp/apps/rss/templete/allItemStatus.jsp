<%--
 $Author: muyx $
 $Rev: 1.0 $
 $Date:: 2012-9-12 下午6:44:33#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<script type="text/javascript">
    var _no_Subscribe =${empty channelInfos};
</script>
<ul id="div_ul_table_title" class="border_b font_size12 color_red">
    <table class="w100b">
        <tr>
            <td><h3>${ctp:i18n('rss.recently.label')}(${count})</h3></td>
            <td class="align_right padding_r_10"><c:if test="${pageCount>1 && pageNo!=1}">
                    <a href="javascript:void(0)" onclick="goPage('${pageNo-1}');">${ctp:i18n('taglib.list.table.page.prev.label')}
                    </a>
                </c:if> ${pageHtml} <c:if test="${pageCount>1 && pageNo!=pageCount}">
                    <a href="javascript:void(0)" onclick="goPage('${pageNo+1}');">
                        ${ctp:i18n('taglib.list.table.page.next.label')}</a>
                </c:if>
            </td>
        </tr>
    </table>
</ul>
<div class="set_search">
    <ul class="search_all_result padding_0 margin_lr_0 margin_t_0">
        <c:if test="${empty channelInfos}">
            <!-- 你还没有订阅信息 -->
            <li class="align_center color_gray"><h1><${ctp:i18n('rss.no.subscribe.info')}></h1>
            </li>
        </c:if>
        <c:forEach items="${channelInfos}" var="item" varStatus="info">
            <li class="padding_10">
                <table class="w100b">
                    <tr>
                        <td><a href="javascript:void(0)" class="search_title margin_r_10 padding_b_5"
                            id="href_title_${item.channelItem.id}" sid="${item.channelItem.id}"
                            channelItemId="${item.channelItem.id }" channelId="${item.channelItem.categoryChannelId}"
                            itemLink="${item.channelItem.link }"> <span class="ico16 arrow_2_r"></span>
                                ${item.channelItem.title } </a> <span id="div_img_redflag_${item.channelItem.id }"> <%-- 红旗 --%>
                        </span> <a href="javascript:void(0)" id="href_img_redflag_${item.channelItem.id }"
                            sid="${item.channelItem.id }" channelId="${item.channelItem.categoryChannelId}"
                            isReadFlag="${item.isReaded}">[${ctp:i18n('rss.button.markasread.label')}] <%-- 标记为已读 --%>
                        </a>
                        </td>
                        <td class="align_right padding_r_10"><span class="color_gray">${item.distanceTime}</span> <a
                            href="javascript:void(0)" id="href_expand_${item.channelItem.id}"
                            sid="${item.channelItem.id}"> <%-- 展开[折叠] --%> </a>
                        </td>
                    </tr>
                </table>
                <div id="p_describse_${item.channelItem.id}" class="margin_t_10">
                    <%-- 内容 --%>
                    ${item.channelItem.describse}
                </div>
            </li>
        </c:forEach>
    </ul>
</div>
<ul id="div_ul_table_title" class="border_b font_size12 green">
    <table class="w100b">
        <tr>
            <td></td>
            <td class="align_right padding_r_10"><c:if test="${pageCount>1 && pageNo!=1}">
                    <a href="javascript:void(0)" onclick="goPage('${pageNo-1}');">${ctp:i18n('taglib.list.table.page.prev.label')}
                    </a>
                </c:if> ${pageHtml} <c:if test="${pageCount>1 && pageNo!=pageCount}">
                    <a href="javascript:void(0)" onclick="goPage('${pageNo+1}');">
                        ${ctp:i18n('taglib.list.table.page.next.label')}</a>
                </c:if>
            </td>
        </tr>
    </table>
</ul>