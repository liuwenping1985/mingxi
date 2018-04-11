<%--
 $Author: $
 $Rev: $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript"
	src="ajax.do?managerName=commentAjaxManager"></script>
<script>
	function buildHidden(name, value) {
		return '<input type="hidden" name="'+name+'" value="'+value+'"/>';
	}
	function getReplyFormId(id) {
		return 'replyForm' + id;
	}
	function buildReplyFormHtml(module, type, subjectId, id, html) {
		return '<form id="' + getReplyFormId(id)
				+ '" action="comment.do?method=save" method="POST">'
				+ buildHidden('type', type) + buildHidden('module', module)
				+ buildHidden('subjectId', subjectId) + buildHidden('pid', id)
				+ html + '</form>';
	}
	/*
	 * 显示回复Form
	 */
	function reply(module, type, subjectId, id) {
		var formId = getReplyFormId(id);
		var form = $('#' + formId);
		// 从模板中id为replyForm的div取form的html
		var formHtml = $('#replyForm').html();
		if (form.length == 0) {
			$('#comment' + id).append(
					buildReplyFormHtml(module, type, subjectId, id, formHtml));
			bindingSubmitEvent(id);
		}
		$('#replys_' + id).show();
		$('#' + formId + ' textarea').focus();
	}

	function bindingSubmitEvent(id) {
		$('#' + getReplyFormId(id) + ' #btnSubmit').click(function() {
			submitReply(id);
		});
	}
	/**
	 * 将回复录入的HTML包装为回复Form
	 */
	function wrapReplyForm(module, type, subjectId, id, element) {
		var div = $(element);
		div.replaceWith(buildReplyFormHtml(module, type, subjectId, id, div
				.html()));
		bindingSubmitEvent(id);
	}
	function submitReply(id) {
		var manager = new commentAjaxManager();
		var obj = $('#replyForm' + id).formobj();
		manager.save(obj, {
			success : function(retObj) {
				if (appendReply)
					appendReply(obj);
			}
		});
		$('#replyForm' + id).remove();
		if (afterReplyCommit)
			afterReplyCommit(obj);
	}
</script>
<jsp:include page="template/template${commentView.module}.jsp" />
