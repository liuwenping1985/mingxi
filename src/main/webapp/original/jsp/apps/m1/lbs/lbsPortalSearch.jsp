<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b"> 
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/m1/js/lbsPortalSearch.js${ctp:resSuffix()}"></script>
<head>
</head>
<body id="lbsTab">
	<div>
      <table class="margin_l_10" border="0" cellspacing="0" cellpadding="0">
      	<tbody>
      		<tr>
      			<th nowrap="nowrap"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.time.label")}:</label></th>
      			<td>
      				<div>
      					<input id="startTime" type="text" class="comp mycal validate" validate='notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true">
      				</div>
      			</td>
      			<td>
      				-
      			</td>
      			<td>
      				<div>
      					<input id="endTime" type="text" class="comp mycal validate" validate='notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true">
      				</div>
      			</td>
      		</tr>
      		<c:if test="${isAdmin eq 'true'}">
      		<tr>
      			<th nowrap="nowrap"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.department.label")}:</label></th>
      			<td>
      				<div>
      					<input type="text" id="dptName" value=""/>
      					<input type="hidden" id="dptId" value=""/>
      				</div>
      			</td>
      		</tr>
      		<tr>
      			<th nowrap="nowrap" align="right"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.name.label")}:</label></th>
      			<td>
      				<div>
      					<input type="text" id="memberName" value=""/>
      					<input type="hidden" id="memberId" value=""/>
      				</div>
      			</td>
      		</tr>
      		</c:if>
      	</tbody>
      </table>
      </div>
      <div style="padding-top:160px" class="padding_l_20">
      	<input type="checkbox"  id="onlyOne" value="1"/><label class="margin_l_10" style="font-size:12px">${ctp:i18n("lbs.sign.onlyOne.label")}</label>
      </div>
</body>
</html>