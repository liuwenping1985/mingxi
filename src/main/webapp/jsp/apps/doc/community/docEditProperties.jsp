<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<form name="mainForm" id="mainForm" action="" method="post"  target="alertIframe">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
			<div id="contentDiv" style="display:none">
				<table width="95%" border="0" cellspacing="0" align="center" cellpadding="2" class="ellipsis">
					<tr>
						<td align="right" width="23%" valign="top">${ctp:i18n('doc.jsp.knowledge.query.key')}:</td>
						<td valign="top">
							<input type="text" id="keyword" name="keyword" size="52" value="<c:out value='${doc.keyWords}' escapeXml='true' />"
								   maxSize="80" onchange="propertiesChanged();" validate="maxLength" inputName="${ctp:i18n('doc.jsp.knowledge.query.key')}" >
						</td>
					</tr>
					<tr>
						<td align="right" width="23%" valign="top">${ctp:i18n('doc.desc')}:</td>
						<td valign="top">
							<textarea id="description" onchange="propertiesChanged();" name="description" rows="4" cols="51" maxSize="500" validate="maxLength" inputName="${ctp:i18n('doc.desc')}" ><c:out value="${doc.frDesc}" escapeXml="true"/></textarea>
						</td>
					</tr>
			    	<c:if test="${doc.versionEnabled}">
			    		<tr>
			    			<td align="right" width="23%" valign="top">${ctp:i18n('doc.menu.history.note.label')}:</td>
			    			<td valign="top">
			    				<textarea id="versionComment" onchange="propertiesChanged()" name="versionComment" rows="4" cols="54" maxSize="300" validate="maxLength" inputName="${ctp:i18n('doc.menu.history.note.label')}"><c:out value="${doc.versionComment}" escapeXml="true"/></textarea>
			    			</td>
			    		</tr>
			    	</c:if>
				</table>
			</div>
		</td>
		</tr>	
		<tr><td><div id="extendDiv" style="display:none">${html}</div></td></tr>				
	</table>
</form>
<div id="fileReplaceDiv" style="display:none"></div>