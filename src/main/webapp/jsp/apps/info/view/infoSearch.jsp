<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<html class="h100b">
    <head>
        <title>信息查询</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <script type="text/javascript" src="${path}/ajax.do?managerName=infoSearchManager"></script>
        <script type="text/javascript" src="${path}/apps_res/info/js/info_list/infoSearch.js${ctp:resSuffix()}"></script>
    </head>
    <body class="h100b">
        <div id="layout">
            <div class="layout_north bg_color" id="north">
                <div id="title" class="bg_color font_size12" style="height: 20px;line-height: 20px;padding: 5px;vertical-align: middle;" >
                    <span>${ctp:i18n('infosend.label.queryCondition')}<!-- 查询条件 --></span>
                    <a id="show_more">${ctp:i18n('infosend.label.moreCondition')}<!-- 更多条件 --><span class="ico16 arrow_2_b"></span></a>
                </div>
                <div class="form_area" id="query">
                    <form name="infoQuery" id="infoQuery" method="post" class="align_center">
                       <input type="hidden" id="reportDate" name="reportDate" value="">
                       <input type="hidden" id="publishLastTime" name="publishLastTime" value="">
                       <div id="commonQuery" style="height:70px">
                            <table  style="height: 100%;width:98%;" border="0" cellSpacing="10" cellPadding="10">
                                <tr>
                                    <td align="right" nowrap="nowrap" width="13%">${ctp:i18n("infosend.search.infoSubject")}：</td>
                                    <td width="20%" align="left"><input id="subject" class="w100b" type="text" name="subject"/></td>
                                    <td align="right" nowrap="nowrap" width="13%"><!-- 信息类型 -->${ctp:i18n('infosend.listInfo.category')}：</td>
                                    <td width="20%" align="left">
                                        <input id="infoCategoryNames" class="w100b"  type="text"  name="infoCategoryNames"/>
                                        <input type="hidden" id="infoCategoryIds" name="infoCategoryIds"/>
                                    </td>
                                    <td align="right" nowrap="nowrap" width="14%"><!-- 采用期刊 -->${ctp:i18n('infosend.state.label.useJournals')}：</td>
                                    <td width="20%"align="left">
                                        <input id="infoMagazineNames" class="w100b"  type="text"  name="infoMagazineNames"/>
                                        <input id="infoMagazineIds" type="hidden" name="infoMagazineIds" value="">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" nowrap="nowrap">${ctp:i18n("infosend.listInfo.reportDept")}：</td>
                                    <td align="left">
                                        <input type="text" id="reportDept" name="reportDept" class="comp w100b"
                                             comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Department',returnValueNeedType:true,minSize:0"/>
                                    </td>
                                    <td align="right" nowrap="nowrap"><!-- 发布时间 -->${ctp:i18n('infosend.listInfo.score.publishTime')}：</td>
                                    <td align="left" nowrap="nowrap">
                                        <input id="from_publishDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                                        <span class="padding_lr_5">-</span>
                                        <input id="to_publishDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                                    </td>
                                    <td id="magazineidTDName" align="right" nowrap="nowrap" style="display: none;"><!-- 期号 -->${ctp:i18n('infosend.magazine.auditPending.issue')}：</td>
                                    <td id="magazineidTDValue" align="left" style="display: none;"><input id="magazineNo" class="w100b" type="text" name="magazineNo"/></td>
                                </tr>
                            </table>
                        </div>
                        <div id="moreQuery" style="display: none;height: 40px">
                            <table  style="height: 100%;width:98%;margin-top: -10px;" border="0" cellSpacing="10" cellPadding="10">
                                <tr>
                                    <td align="right" nowrap="nowrap" width="13%" id="reportUnitTd">${ctp:i18n("infosend.listInfo.reportUnit")}：</td>
                                    <td width="20%" align="left">
                                        <input type="text" id="reportUnit" name="reportUnit" class="comp w100b"
                                             comp="type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',returnValueNeedType:true,minSize:0"/>
                                    </td>
                                    <td align="right" nowrap="nowrap"  width="13%">${ctp:i18n('infosend.search.reportDate')}：</td>
                                    <td width="20%" align="left" nowrap="nowrap">
                                        <input id="from_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                                        <span class="padding_lr_5">-</span>
                                        <input id="to_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                                    </td>
                                    <td align="right" nowrap="nowrap"  width="14%"><!-- 发布范围 -->${ctp:i18n('infosend.state.label.publishRange')}：</td>
                                    <td width="20%" align="left">
                                        <input id="publishRange" class="w100b" type="text" name="publishRange"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </form>
                    <div id="button" class="common_checkbox_box align_center clearfix padding_t_10 padding_b_10">
                        <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_confirm_button" onclick="searchInfo();"><!-- 查询 -->${ctp:i18n('infosend.label.query')}</a>&nbsp;<%--查询 --%>
                        <a href="javascript:void(0)" class="common_button common_button_gray" id="edit_cancel_button" onclick="resetQuery();"><!-- 重置 -->${ctp:i18n('infosend.label.stat.button.reset')}</a>
                    </div>
                </div>
                <div style="float: left;line-height: 20px;padding: 5px;vertical-align: middle;" class="font_size12"><!-- 查询结果 -->${ctp:i18n('infosend.state.label.queryResult')}：</div>
                <div style="float: left;" id="toolbars"></div>
            </div>
            <div class="layout_center over_hidden" id="center">
                <table  class="flexme3" id="infoSearch"></table>
            </div>
        </div>
        <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
    </body>
</html>