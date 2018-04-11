<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html id="ht" class="h100b w100b">
<head>
<style>
	.calendar_icon{
		top:5px!important;
	}
	.comp{
		width:100%;
	}
	._input{
		width:150px;
	}
	#content:hover{
		border:solid 1px #e7e7e7!important;
	}
	#querySave{
		width:auto!important;
	}
</style>
</head>
<body class="h100b w100b">
	<div class="h100b w100b" id="content" style="overflow: auto;">
			<table class="w100b" id="lbsTab" style="background-color: #F4F4F4; height: 35px;" class="margin_l_10" border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<c:if test="${isAttendanceAdmin eq true || isDept eq true}">
							<th nowrap="nowrap" style="text-align: right;">
								<label class='margin_r_10 th_name' style="font-size: 12px" for='text'>${ctp:i18n("attendance.name.label")}:</label>
							</th>
							<td nowrap="nowrap" class="_input">
								<div class="_input">
									<input class="w100b" type="text" id="memberName" value="" onclick="selectMember()" /> 
									<input type="hidden" id="memberId" value="" />
								</div>
							</td>
							<th nowrap="nowrap" class="padding_l_10" style="text-align: right;">
								<label class='margin_r_10 th_name' style="font-size: 12px" for='text'>${ctp:i18n("attendance.department.label")}:</label>
							</th>
							<td nowrap="nowrap" class="_input">
								<div class="_input">
									<input class="w100b" type="text" id="dptName" value="" onclick="selectDepartment()" /> 
									<input type="hidden" id="dptId" value="" />
								</div>
							</td>
						</c:if>
						<th nowrap="nowrap" class="padding_l_10" style="text-align: right;">
							<label class='margin_r_10 th_name' style="font-size: 12px" for='text'>${ctp:i18n("attendance.time.label")}:</label>
						</th>
						<td nowrap="nowrap" class="_input">
							<div class="_input">
								<input id="startTime" class="comp" type="text" value="${startTime}" readonly="readonly" 'notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true">
							</div>
						</td>
						<td nowrap="nowrap">-</td>
						<td nowrap="nowrap" class="_input">
							<div class="_input">
								<input id="endTime" class="comp" type="text" value="${endTime}" readonly="readonly" 'notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:true">
							</div>
						</td>
						<td class="padding_l_10" nowrap="nowrap">
							<div class="margin_l_10">
								<input id="onlyOne" type="checkbox" value="1" />
								<label class="margin_l_10" style="font-size: 12px">${ctp:i18n("attendance.sign.onlyOne.label")}</label>
							</div>
						</td>
						<td class="padding_l_30" nowrap="nowrap">
							<a id="querySave" href="javascript:void(0);" onclick="querySave();" style="width: 5px; height: 20px" class="common_button"> 
								<span class="ico16 search_16" style="margin-left: 4px; margin-top: -4px"></span>
							</a>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="hidden" id="departmentEle" name="departmentEle" value="${deptList}" /> 
			<input type="hidden" id="isHr" value="${isHr}" /> 
			<input type="hidden" id="isDept" value="${isDept}" /> 
			<input type="hidden" id="columns" value="${columns}" /> 
			<input type="hidden" id="columnsCount" value="${columnsCount}" />
		<div id="lbsList" class="margin_t_10">
			<table class='w100b'>
				<tbody id="lbsList-tbody">
				</tbody>
			</table>
		</div>
	</div>
</body>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/attendance/js/lbsPortalSearch.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	$(function() {
		$(".mycal").each(function() {
			$(this).compThis();
		}).addClass("w100b");

		var width = "${width}";
		if (width < 5) {
			$("#content").css("overflow-y", "auto");
			$("#lbsList,#lbsTab").css("width", "609px");
		}
		querySave();
	});
</script>
</html>