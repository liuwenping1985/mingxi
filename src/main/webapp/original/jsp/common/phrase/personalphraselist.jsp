<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/phrase/personalphraselist.js.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>${ctp:i18n('phrase.per.newphrase')}</title>
</head>
<body>
    <div id='layout'>
        <div class="layout_north" id="north">
            <div class="font_size12 padding_5">
                <span class="left margin_t_5">${ctp:i18n('phrase.sys.js.neworupdate')}</span>
                <span class="right"><a href="javascript:updateOradd()" class="common_button common_button_gray">${ctp:i18n('phrase.per.newphrase')}</a></span>
            </div>
        </div>
        <div class="layout_center over_hidden" style="overflow:scroll" id="center">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table" id="personaltable">
                <thead>
                    <tr>
                        <th width="70%">${ctp:i18n('phrase.per.content')}</th>
                        <th>${ctp:i18n('phrase.per.update')}</th>
                        <th>${ctp:i18n('phrase.per.delete')}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="erow">
                        <td>1</td>
                        <td><em class="ico16"></em></td>
                        <td><em class="ico16"></em></td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td><em class="ico16"></em></td>
                        <td><em class="ico16"></em></td>
                    </tr>
                    <tr class="erow">
                        <td>1</td>
                        <td><em class="ico16"></em></td>
                        <td><em class="ico16"></em></td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td><em class="ico16"></em></td>
                        <td><em class="ico16"></em></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <div id="searchId" class="hidden">
    	<input type="hidden" id="perphraseId"></input>
        <table width="90%" height="50%" align="center">
            <tr>
                <td>
                    <div class="common_txtbox clearfix">
                        <textarea id="phraseDes" cols="30" rows="8" class="padding_5 w100b"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="font_size12 padding_t_5" style="color:#888888">${ctp:i18n('phrase.sys.sm')}
    ${ctp:i18n('phrase.sys.cyycd')}
                </td>
            </tr>
        </table>
    </div>
</body>
</html>
