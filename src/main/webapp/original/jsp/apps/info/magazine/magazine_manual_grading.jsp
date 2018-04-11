<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>手动评分页面</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/magazine_manual_grading.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
  var _scoreUserId = '${scoreRecord.scoreUserId}';
  var _scoreUserName = '${scoreRecord.scoreUserName}';
  var _scoreTime = "${ctp:formatDateByPattern(scoreRecord.scoreTime, 'yyyy-MM-dd')}";
</script>
</head>
<body onkeydown="">
	<table width="100%" height="100%" border="0" cellpadding="0"
		cellspacing="0" class="popupTitleRight">
		<tr>
			<td height="30" style="padding-left: 15px;">
			<span style="font-size: 12px;">${ctp:i18n('infosend.score.label.scoreTime')}<!-- 评分时间 -->:</span> 
			<input id="scoreTime" name="scoreTime" readonly="readonly" value="${ctp:formatDateByPattern(scoreRecord.scoreTime, 'yyyy-MM-dd HH:mm')}" type="text" class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"> 
			<span style="font-size: 12px;">${ctp:i18n('infosend.score.label.scoreUser')}<!-- 评分人 -->:</span>
			<%-- <input type="hidden" id="scoreUserId" name="scoreUserId" value="${scoreRecord.scoreUserId}" class="input-100per" value="" validate="name:'scoreUserId',notNull:true,type:'long',isNumber:true" /> --%>
			<input type="text" id="scoreUserName" name="scoreUserName" class="input-100per" escapeXml="true" value="${scoreRecord.scoreUserName}" /></td>
		</tr>
		<tr>
			<td height="300">
			   <iframe src="${path }/info/magazine.do?method=showScoreContent" id="mainbodyFrame" name="mainbodyFrame" style="width: 100%; height: 100%;" border="0px" frameborder="0" scrolling="no"></iframe>
			 </td>
		</tr>
		<tr>
		   <td height="20" style="padding-left: 15px;">
		      <span style="font-size: 12px;">${ctp:i18n('infosend.score.label.selectedScore')}<!-- 选中分数 -->：</span><span  style="font-size: 12px;" id="selectedSumScore">0</span>
		   </td>
		</tr>
		<tr>
			<td height="20" style="padding-left: 15px;">
			   <span style="font-size: 12px;">${ctp:i18n('infosend.score.label.addScoreNote')}<!-- 添加评分备注 -->：</span>
			</td>
		</tr>
		<tr>
			<td height="60" style="padding: 0px 15px 0px 15px;">
			   <textarea id="comment" name="comment" class="validate" style="width: 100%; height: 100%;" validate="type:'string',name:'评分备注',notNull:true,minLength:0,maxLength:85" inputName="评分备注"></textarea><!-- 评分备注 -->
			</td>
		</tr>
		<tr>
			<td height="20" style="padding-left: 15px;">
			   <span style="font-size: 12px;">${ctp:i18n_1('infosend.label.charactor.limit', '85')}<!-- 100字以内 --></span>
			</td>
		</tr>
	</table>
</body>
</html>