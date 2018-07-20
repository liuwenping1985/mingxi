<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<div id="contentDiv" style="display:none">
	<table width="95%" border="0" cellspacing="0" align="center" cellpadding="2" style="word-break:break-all;word-wrap:break-word">
		<tr>
			<td align="right" width="23%" valign="top"><fmt:message key='doc.metadata.def.keywords'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">
				<input type="text" id="keyword" name="keyword" size="52" value="<c:out value='${docEditVo.docResource.keyWords}' escapeXml='true' />"
					   maxSize="80" onchange="propertiesChanged()" validate="maxLength" inputName="<fmt:message key='doc.metadata.def.keywords'/>" >
			</td>
		</tr>
		<tr>
			<td align="right" width="23%" valign="top"><fmt:message key='doc.metadata.def.desc'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">
				<textarea id="description" onchange="propertiesChanged()" name="description" rows="4" cols="54" maxSize="80" validate="maxLength" inputName="<fmt:message key='doc.metadata.def.desc'/>" ><c:out value="${docEditVo.docResource.frDesc}" escapeXml="true"/></textarea>
			</td>
		</tr>
	<c:if test="${docEditVo.versionEnabled}">
		<tr>
			<td align="right" width="23%" valign="top"><fmt:message key='doc.menu.history.note.label'/>:</td><td width="2%">&nbsp;</td>
			<td valign="top">
				<textarea id="versionComment" onchange="propertiesChanged()" name="versionComment" rows="4" cols="54" maxSize="300" validate="maxLength" inputName="<fmt:message key='doc.menu.history.note.label'/>"><c:out value="${docEditVo.docResource.versionComment}" escapeXml="true"/></textarea>
			</td>
		</tr>
	</c:if>
	</table>
</div>
<div id="extendDiv" style="display:none">${html}</div>
<div id="fileReplaceDiv" style="display:none"></div>