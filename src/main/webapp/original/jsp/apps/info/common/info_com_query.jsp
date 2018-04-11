<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
    <head>
    <title>${ctp:i18n("infosend.listInfo.combinedQuery")}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
    <script type="text/javascript">
        var listType = "${listType}";
        function OK() {
            var o = new Object();
            o.subject = $('#subject').val();
            o.reporter = $('#reporter').val();
            o.reportUnit = $('#reportUnit').val();
            o.reportDept = $('#reportDept').val();
            o.listType = listType;
            o.condition = "comQuery";
            if (listType == "listInfoDraft") {
                o.subState = $('#affairState').val();
                o.listFrom = "listDraft";
            } else if(listType == "listInfoReported") {
                o.publishState = $('#publishState').val();
                o.listFrom = "listSend";
            } else if(listType == "listInfoPending") {
                var fromDate = $('#from_reportDate').val();
                var toDate = $('#to_reportDate').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.reportDate = date;
                o.listFrom="listPending";
            } else if(listType == "listInfoDone") {
             	var fromDate = $('#from_reportDate').val();
                var toDate = $('#to_reportDate').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.reportDate = date;
                o.listFrom = "listDone";
            }else if(listType == "listOverAndPending"){
            	var fromDate = $('#from_reportDate').val();
                var toDate = $('#to_reportDate').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.reportDate = date;
                o.listFrom = "listDone";
            }
            return o;
            //window.dialogArguments[0].loadFormData(o);
            //colseQuery();
        }
        
        $(document).ready(function () {
        	if(!isGroup) {
        		$("#reportUnitTd").html($.i18n(unitView));
        	}
        });
    </script>
    </head>
    <body class="h100b over_hidden">
        <div class="form_area" id="combinedQueryDIV">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_center">
                <table  style="height: 100%;width:98%;" border="0" cellSpacing="10" cellPadding="10">
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n("cannel.display.column.subject.label")}：</td>
                        <td width="35%" align="left"><input id="subject" class="w100b" type="text" name="subject"/></td>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n("infosend.listInfo.reporter")}：</td>
                        <td width="35%"align="left"><input id="reporter" class="w100b"  type="text"  name="reporter"/></td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("infosend.listInfo.reportUnit")}：</td>
                        <td align="left"><input id="reportUnit" class="w100b" type="text" name="reportUnit"/></td>
                        <td align="right" nowrap="nowrap">${ctp:i18n("infosend.listInfo.reportDept")}：</td>
                        <td align="left"><input id="reportDept" class="w100b" type="text" name="reportDept"/></td>
                    </tr>
                    <c:if test="${listType == 'listInfoDraft'}">
                    <tr>
                        <td align="right" nowrap="nowrap">${ctp:i18n("infosend.listInfo.subStateName")}：</td>
                        <td align="left">
                            <select class="w100b" id="affairState" name="affairState">
                                <option value="">${ctp:i18n("infosend.listInfo.pleaseSelect")}</option>
                                <option value="1">${ctp:i18n("infosend.listInfo.draft")}</option>
                                <option value="3">${ctp:i18n("infosend.listInfo.revocation")}</option>
                                <option value="2,16,18">${ctp:i18n("infosend.listInfo.back")}</option>
                            </select>
                        </td>
                    </tr>
                    </c:if>
                    <c:if test="${listType == 'listInfoReported'}">
                    <tr>
                        <td align="right" nowrap="nowrap">${ctp:i18n("infosend.listInfo.subStateName")}：</td>
                        <td align="left">
                            <select class="w100b" id="publishState" name="publishState">
                                <option value="">${ctp:i18n("infosend.listInfo.pleaseSelect")}</option>
                                <option value="1">${ctp:i18n("infosend.label.reportSent")}</option>
                                <!-- 已采用
                                <option value="2">${ctp:i18n("infosend.listInfo.hasBeenAdopted")}</option>  -->
                                <!-- 已评分 -->
                                <option value="3">${ctp:i18n("infosend.listInfo.scored")}</option>
                            </select>
                        </td>
                    </tr>
                    </c:if>
                    <c:if test="${listType == 'listInfoPending' || listType == 'listInfoDone' || listType=='listOverAndPending'}">
                    <tr>
                        <td align="right" nowrap="nowrap">${ctp:i18n('infosend.listInfo.reportDate')}：</td>
                        <td align="left" nowrap="nowrap" colspan="3">
                            <input id="from_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span class="padding_lr_5">-</span>
                            <input id="to_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>
                    </c:if>
                </table>
            </form>
        </div>
    </body>
</html>