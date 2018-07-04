<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE>选择日期</TITLE>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/apps/plan/output_mul_day.js.jsp"%>
<script type="text/javascript">
var myYear = "${ctp:toHTML(param.calSelectedYear)}";
var myMonthTop = "${ctp:toHTML(param.calSelectedMonth)}";
var authedUserId = "${param.authedUserId}";
var myDayOfMonth = "<c:if test="${param.type=='1'}">${param.calSelectedDate}</c:if>";
//var planType = "1"; 
var specialWork = new Properties();
var restDays = new ArrayList();
$(document).ready(function(){
	$(".month").click(selectThisMonth);
	$(".month[value='${ctp:toHTML(param.calSelectedMonth)}']").css({background:'#FFD76A'});
});
//#FFD76A 单击
//#C7C8CA 默认选中
var selectedMonth=myMonthTop,selectedYear=myYear;
function selectThisMonth(){
	var selectMonth = $(this).attr("value");
	var selectYear=$("#c_Year").html();
	selectedMonth = selectMonth;
	selectedYear = selectYear;
	fnSubmit(selectYear,selectMonth,-1);
	if(selectYear==myYear){
		$(".month[value!='${ctp:toHTML(param.calSelectedMonth)}']").css({background:''});
		if(selectMonth!=myMonthTop){
	    	$(".month[value='"+selectMonth+"']").css({background:'#C7C8CA'});
		}
	}else{
		$(".month").css({background:''});
		$(".month[value='"+selectMonth+"']").css({background:'#C7C8CA'});
	}
}
function prevYear(){
	$("#c_Year").html(parseInt($("#c_Year").html())-1);
	colorSelectedMonth($("#c_Year").html());
}
function nextYear(){
	$("#c_Year").html(parseInt($("#c_Year").html())+1);
	colorSelectedMonth($("#c_Year").html());
}
function colorSelectedMonth(toYear){
	$(".month").css({background:''});
	if(selectedYear==toYear){
		$(".month[value='"+selectedMonth+"']").css({background:'#C7C8CA'});
		
	}
	if(toYear==myYear){
		$(".month[value='${ctp:toHTML(param.calSelectedMonth)}']").css({background:'#FFD76A'});
	}
}
</script>

</HEAD>
<BODY style="FONT-SIZE: 9pt;background-color: white" leftMargin=0 topMargin=0>
	<div id="divCal">
		<c:if test="${param.type!=1}">
			<TABLE class="w100b font_size12" height="120px">
				<TBODY id="calanderContent" align="center">
					<tr>
						<TD style="height:44px;"><span class="ico16 plan_left_16" onclick="javascript:prevYear();"></span></TD>
						<td colspan="2"><SPAN id="c_Year">${param.calSelectedYear}</SPAN>${ctp:i18n('plan.date.year')}</td>
						<TD><span class="ico16 plan_right_16" onclick="javascript:nextYear();"></span></TD>
					</tr>
					<tr>
            			<td width="45px" class="month" value="1"><span>${ctp:i18n('plan.date.month.1')}</span></td>
            			<td width="45px" class="month" value="2"><span>${ctp:i18n('plan.date.month.2')}</span></td>
            			<td width="45px" class="month" value="3"><span>${ctp:i18n('plan.date.month.3')}</span></td>
            			<td width="45px" class="month" value="4"><span>${ctp:i18n('plan.date.month.4')}</span></td>
            		</tr>
            		<tr>
            			<td class="month" value="5"><span>${ctp:i18n('plan.date.month.5')}</span></td>
            			<td class="month" value="6"><span>${ctp:i18n('plan.date.month.6')}</span></td>
            			<td class="month" value="7"><span>${ctp:i18n('plan.date.month.7')}</span></td>
            			<td class="month" value="8"><span>${ctp:i18n('plan.date.month.8')}</span></td>
            		</tr>
            		<tr>
            			<td class="month" value="9"><span>${ctp:i18n('plan.date.month.9')}</span></td>
            			<td class="month" value="10"><span>${ctp:i18n('plan.date.month.10')}</span></td>
            			<td class="month" value="11"><span>${ctp:i18n('plan.date.month.11')}</span></td>
            			<td class="month" value="12"><span>${ctp:i18n('plan.date.month.12')}</span></td>
            		</tr>
				</TBODY>
			</TABLE>
		</c:if> 
		<c:if test="${param.type==1 }">
			<script type="text/javascript">
              fDrawCal(myYear,myMonthTop);
            </script>
		</c:if> 
	</div>	

</BODY>
</HTML>
