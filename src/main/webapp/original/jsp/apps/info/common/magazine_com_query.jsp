<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
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
            o.state = $('#state').val();
            o.listType = listType;
            o.condition = "comQuery";
            o.listFrom = "magazineManagerList";
			//按时间查询
            var date = "";
            //报审时间
            var fromDate = $('#from_createTime').val();
            var toDate = $('#to_createTime').val();
            if(fromDate != "" && toDate != "" && fromDate > toDate){
            	$.alert($.i18n('infosend.magazine.alert.fromTimeToEnd', $.i18n('infosend.label.baoshenTime')));//报审时间的开始时间不能大于结束时间
                return;
            }
            if(fromDate !="" || toDate!="") {
            	date = fromDate+'#'+toDate;
                o.createTime = date;
            }

            //审核时间
            fromDate = $('#from_auditTime').val();
            toDate = $('#to_auditTime').val();
            if(fromDate != "" && toDate != "" && fromDate > toDate){
                $.alert($.i18n('infosend.magazine.alert.fromTimeToEnd', $.i18n('infosend.magazine.label.auditTime')));//审核时间的开始时间不能大于结束时间
                return;
            }
            if(fromDate !="" || toDate!="") {
            	date = fromDate+'#'+toDate;
                o.auditTime = date;
            }

            //发布时间
            fromDate = $('#from_publishTime').val();
            toDate = $('#to_publishTime').val();
            if(fromDate != "" && toDate != "" && fromDate > toDate){
                $.alert($.i18n('infosend.magazine.alert.fromTimeToEnd', $.i18n('infosend.magazine.publishDone.publishTime')));//发布时间的开始时间不能大于结束时间
                return;
            }
            if(fromDate !="" || toDate!="") {
            	date = fromDate+'#'+toDate;
                o.publishTime = date;
            }

            window.dialogArguments[0].loadFormData(o);
            colseQuery();
        }
    </script>
    </head>
    <body class="h100b over_hidden">
        <div class="form_area" id="combinedQueryDIV">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_center">
                <table  style="height: 100%;width:98%;" border="0" cellSpacing="10" cellPadding="10">
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n('infosend.magazine.comQuery.journalName')}</td>
                        <td width="29%" align="left"><input id="subject" class="w100b" type="text" name="subject"/></td>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n('infosend.magazine.comQuery.journalStates')}</td>
                        <td width="20%"align="left">
							<select class="w100b" name="state" id="state">
								<option value="-1">${ctp:i18n('infosend.magazine.comQuery.all')}</option>
								<option value="0,2">${ctp:i18n('infosend.magazine.comQuery.go')}</option>
								<option value="1,3,4,7,9">${ctp:i18n('infosend.magazine.comQuery.issued')}</option>
								<option value="5">${ctp:i18n('infosend.magazine.comQuery.unpublish')}</option>
								<option value="6">${ctp:i18n('infosend.magazine.comQuery.notPass')}</option>
							</select>
						</td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n('infosend.magazine.comQuery.created')}</td>
                        <td align="left" nowrap="nowrap" colspan="3" width="85%">
                            <input id="from_createTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span style="width:10%" class="padding_lr_20">-</span>
                            <input id="to_createTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n('infosend.magazine.comQuery.auditTime')}</td>
                        <td align="left" nowrap="nowrap" colspan="3" width="85%">
                            <input id="from_auditTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span style="width:10%" class="padding_lr_20">-</span>
                            <input id="to_auditTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>

                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n('infosend.magazine.comQuery.published')}</td>
                        <td align="left" nowrap="nowrap" colspan="3" width="85%">
                            <input id="from_publishTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span style="width:10%" class="padding_lr_20">-</span>
                            <input id="to_publishTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>

                </table>
            </form>
        </div>
    </body>
</html>