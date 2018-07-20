<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
    <head> 
    <title>取消发布</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script>
    	function OK() {
    		return $("#comment").val();
    	}
    </script>
    </head>
    <body style="padding: 0px 26px;" class="page_color h100b over_hidden" scroll="no">
    
    <table class="popupTitleRight" border="0" cellSpacing="0" cellPadding="0" width="100%" height="100%">
	<tbody><tr>
		<td class="PopupTitle" height="20"><fmt:message key="col.repeal.comment"></fmt:message></td>
	</tr>
	<tr>
		<td class="bg-advance-middel">
		<table class="font_size12" border="0" cellSpacing="0" cellPadding="0" width="100%">
				<tbody><tr>
					<td height="28" vAlign="top">
                        ${ctp:i18n('infosend.magazine.publish.label.revokeRemind')}<!-- 撤销操作不可恢复!若确认撤销流程，请输入撤销附言： -->
					</td>
				</tr>
				<tr>
					<td height="100%">
                        <!-- 撤销附言 -->
                        <div id="combinedQueryDIV">
                            <textarea id="comment" name="comment" class="validate" style="width: 100%; height: 140px;" validate="type:'string',name:'${ctp:i18n('infosend.magazine.label.revokeName')}',notNull:true,minLength:0,maxLength:100" inputName="${ctp:i18n('infosend.magazine.label.revokeName')}"></textarea><!-- 撤销附言 -->
                        </div>
						<span class="description-lable">
						${ctp:i18n_1('infosend.label.charactor.limit', '100')}<!-- 100字以内 -->
						</span><br>
					</td>
				</tr>
			</tbody></table>
			</td>
		</tr>
	</tbody></table>
    </body> 
</html>