<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<div id="comment_deal" class="display_none">
	<input type="hidden" id="id" value="${commentDraft.id}"> 
	<input type="hidden" id="pid" value="0"> 
	<input type="hidden" id="clevel" value="1">
	<input type="hidden" id="path" value="${contentContext.commentMaxPath}">
	<input type="hidden" id="moduleType" value="${contentContext.moduleType}"> 
	<input type="hidden" id="moduleId" value="${contentContext.moduleId}"> 
	<input type="hidden" id="attitude"> 
	<input type="hidden" id="ctype" value="0"> 
	<input type="hidden" id="content"> 
	<input type="hidden" id="hidden">
	<input type="hidden" id="isHidden">
	<input type="hidden" id="showToId"> 
	<input type="hidden" id="currentAffairId" value="${contentContext.affairId }">
	<input type="hidden" id="sendAffairId" value="${summaryVO.sendAffair.id }">
	<input type="hidden" id="infoId" value="${summaryVO.summary.id }">
	<input type="hidden" id="policy" value="${summaryVO.affair.nodePolicy }">
	<input type="hidden" id="relateInfo"> 
	<input type="hidden" id="pushMessage" value="false"> 
	<input type="hidden" id="pushMessageToMembers">
</div>
