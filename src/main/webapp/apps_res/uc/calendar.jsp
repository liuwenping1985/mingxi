<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
﻿<!DOCTYPE html>
<html class="h100b">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title></title>
</head>
<script type="text/javascript">
	var parentWindowData = window.parentDialogObj["dialog_calendar"].getTransParams();
	var defaultStartDate = parentWindowData["startDate"];
	var defaultEndDate = parentWindowData["endDate"];
	if(defaultStartDate == null || defaultEndDate == null){
		defaultStartDate = new Date().setDate(01);
		defaultEndDate = new Date();
	}
	function OK(){
		var start = $('#start_time').val();
		var end = $('#end_time').val();
		return start +"&" + end;
	}
</script>
<style>
	.w120{
		width :140px;
	}
</style>
<body class="body-pading over_hidden">
    <div class="font_size12 form_area">
        <table cellpadding="0" width="410" class='margin_l_5' cellspacing="0">
            <tr>
                <td nowrap="nowrap" class='font_size12 padding_b_5' colspan="2">
                	<span id='startTile'></span><input id="start_time" class=" w120" readonly="readonly"/>
                </td>
                <td width ='10'>&nbsp;</td>
                <td nowrap="nowrap" class='font_size12 padding_b_5' colspan="2">
                	<span id='endTitle'></span><input id="end_time" class=" w120"  readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td class="td" id="start" colspan="2">
                    <script>
                   		var dates = new Date().setDate(01);
                		$('#start_time').val(new Date(dates).getFullYear()+"-"+(new Date(dates).getMonth()+1)+"-"+new Date(dates).getDate());
                		$('#end_time').val(new Date().getFullYear()+"-"+(new Date().getMonth()+1)+"-"+new Date().getDate());
                        var c1 = $.calendar({
                            displayArea: 'start_time',
                            flat: 'start',
                            returnValue: true,
                            date: defaultStartDate,
                            onUpdate: showStart,
                            height:'190',
                            ifFormat: "%Y-%m-%d",
                            daFormat: "%Y-%m-%d",
                            showsTime: false,
                            weekNumbers : false,
                            hideOkClearButton:true
                        });
                        function showStart(date){
                            $('#start_time').val(date);
                        }
                    </script>
                </td>
                <td width='10'>&nbsp;</td>
                <td class="td" id="end" colspan="2">
                    <script>
                        var c2 = $.calendar({
                            displayArea: 'end_time',
                            flat: 'end',
                            returnValue: true,
                            date: defaultEndDate,
                            onUpdate: showEnd,
                            height:'190',
                            ifFormat: "%Y-%m-%d",
                            daFormat: "%Y-%m-%d",
                            showsTime: false,
                            weekNumbers : false,
                            hideOkClearButton:true
                        });
                        function showEnd(date){
                           $('#end_time').val(date);
                        }
                    </script>
                </td>
            </tr>
        </table>
    </div>
</body>
<script type="text/javascript">
var startTitle = parentWindowData['startTitle'];
$('#startTile').html(startTitle);
var endTitle = parentWindowData['endTitle'];
$('#endTitle').html(endTitle);
</script>
