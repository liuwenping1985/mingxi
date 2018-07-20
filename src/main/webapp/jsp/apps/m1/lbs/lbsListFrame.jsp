<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html id="ht" class="h100b w100b">       
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/m1/js/lbsPortalSearch.js${ctp:resSuffix()}"></script>
<script type="text/javascript"src="${path}/ajax.do?managerName=mLbsRecordManager"></script>
<head>
</head>
<body class="h100b w100b">
  <div class="h100b w100b" id="content">
	<div class="w100b" align="center"  style="background-color:#F4F4F4;height:35px;">
      <table class="w100b" id="lbsTab" style="padding-top:5px"class="margin_l_10" border="0" cellspacing="0" cellpadding="0">
      	<tbody>
      		<tr>
      			<c:if test="${isAdmin eq 'true'}">
      			<th nowrap="nowrap"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.name.label")}:</label></th>
      			<td nowrap="nowrap">
      				<div>
      					<input class="w100b" type="text" id="memberName" value=""/>
      					<input type="hidden" id="memberId" value=""/>
      				</div>
      			</td>
      			<th nowrap="nowrap" class="padding_l_10"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.department.label")}:</label></th>
      			<td nowrap="nowrap">
      				<div>
      					<input class="w100b" type="text" id="dptName" value=""/>
      					<input type="hidden" id="dptId" value=""/>
      				</div>
      			</td>
      			</c:if>
      			<th nowrap="nowrap" class="padding_l_10"><label class='margin_r_10 th_name' style="font-size:12px" for='text'>${ctp:i18n("lbs.time.label")}:</label></th>
      			<td nowrap="nowrap">
      				<div>
      					<input id="startTime" type="text" class="comp mycal validate" validate='notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true">
      				</div>
      			</td>
      			<td nowrap="nowrap">-</td>
      			<td nowrap="nowrap">
      				<div>
      					<input id="endTime"  type="text" class="comp mycal validate" validate='notNull:true' comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true">
      				</div>
      			</td>
      			<td class="padding_l_10" nowrap="nowrap"> 
      				<div class="margin_l_10">
      					<input id="onlyOne" type="checkbox" value="1"/><label class="margin_l_10" style="font-size:12px">${ctp:i18n("lbs.sign.onlyOne.label")}</label>
      				</div>
      			</td>
      			<td class="padding_l_30" nowrap="nowrap">
      				<a id="querySave" style="width:5px;height:20px" class="common_button common_button_gray">
      					<span class="ico16 search_16" style="margin-left:-4px;margin-top:-4px"></span>
      				</a>
      			</td>
      		</tr>
      	</tbody>
      </table>
      <input type="hidden" id="columns" value="${columns}"/>
      <input type="hidden" id="columnsCount" value="${columnsCount}"/>
      </div>
      <div id="lbsList" class="margin_t_10">
      </div>
     <div>
</body>
<script type="text/javascript">
	$(function(){
		var width="${width}";
		if(width<5){
			$("#content").css("overflow-y","auto");
			$("#lbsList,#lbsTab").css("width","609px");
		}
		querySave();
	})
</script>
</html>