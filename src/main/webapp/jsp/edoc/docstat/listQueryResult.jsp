<!DOCTYPE html>
<html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<head>
<title>Insert title here</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
<!--

//showCtpLocation("F07_edocStat", {surffix : "<fmt:message key='edoc.stat.query.label.title' />"});
showCtpLocation("F07_edocStat");

	function showDetail(id) {
		parent.bottom.location.href = "${edocStat}?method=edocDetail&id="+id;
	}

//-->
</script>
<style>
.nowrap{
	white-space: nowrap;
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<body scroll="no">
<form name="statForm" id="statForm" method="post">
<div class="main_div_row2">
  <div class="right_div_row2" style="padding-top:0;">
    <div class="center_div_row2" id="scrollListDiv"  style="top:0;bottom:6px;">
				<c:choose>
					<c:when test="${resultType == 'acchivedEdocStat' }">
					<v3x:table data="${edocStats}" var="edocStat1" isChangeTRColor="true" showHeader="true" showPager="true" className="sort ellipsis">
							<v3x:column width="10%" label="edoc.element.doctype" alt="${edocStat1.docType}" symbol="..." value="${edocStat1.docType}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="18%" label="edoc.element.subject" alt="${edocStat1.subject}" symbol="..." value="${edocStat1.subject}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%"  label="edoc.element.secretlevel.simple" alt="${edocStat1.secretLevel}" symbol="..." value="${edocStat1.secretLevel}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
						    <v3x:column width="10%" label="edoc.element.wordno.label" alt="${edocStat1.docMark}" value="${edocStat1.docMark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.wordinno.label" alt="${edocStat1.serialNo}" value="${edocStat1.serialNo}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%"  label="edoc.edoctitle.createPerson.label" alt="${edocStat1.createUser}" symbol="..." value="${edocStat1.createUser}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.edoctitle.pigeonhole.label"  onClick="showDetail('${edocStat1.id}');" type="Date" className="cursor-hand sort nowrap">
								<fmt:formatDate value='${edocStat1.archivedTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />
							</v3x:column>
							<v3x:column width="7%" label="edoc.form.sort" value="${edocStat1.edocType }" maxLength="10" symbol="..." onClick="showDetail('${edocStat1.id}')" type="String"  className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="8%" type="String" label="edoc.edoctitle.pigeonholePath.label" className="cursor-hand sort nowrap" onClick="showDetail('${edocStat1.id}');">
								<span onmouseover="showWholePath('${edocStat1.logicalPath}',this)">${edocStat1.archiveName}&nbsp;</span>
							</v3x:column>
							<v3x:column width="7%" label="edoc.stat.remark.label" value="${edocStat1.remark}"  maxLength="10" symbol="..." onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
						</v3x:table>
					</c:when>
					<c:when test="${resultType == 'recEdoc' }">
						<v3x:table data="${edocStats}" var="edocStat1" isChangeTRColor="true" showHeader="true" showPager="true" className="sort ellipsis">
							<v3x:column width="10%" label="edoc.element.doctype" alt="${edocStat1.docType}" symbol="..." value="${edocStat1.docType}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="18%" label="edoc.element.subject" alt="${edocStat1.subject}" symbol="..." value="${edocStat1.subject}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.secretlevel.simple" alt="${edocStat1.secretLevel}" symbol="..." value="${edocStat1.secretLevel}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.wordno.label" alt="${edocStat1.docMark}" value="${edocStat1.docMark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.wordinno.label" alt="${edocStat1.serialNo}" value="${edocStat1.serialNo}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.edoctitle.regDate.label"  onClick="showDetail('${edocStat1.id}');" type="Date" className="cursor-hand sort nowrap">
								<fmt:formatDate value='${edocStat1.createDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />
							</v3x:column>
							<v3x:column width="10%" label="edoc.edoctitle.fromUnit.label" value="${edocStat1.account }" maxLength="15" symbol="..." onClick="showDetail('${edocStat1.id}');" type="String"  className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" type="String" label="edoc.edoctitle.pigeonholePath.label" className="cursor-hand sort nowrap" onClick="showDetail('${edocStat1.id}');">
								<span onmouseover="showWholePath('${edocStat1.logicalPath}',this)">${edocStat1.archiveName}&nbsp;</span>
							</v3x:column>
							<v3x:column width="12%" label="edoc.stat.remark.label" maxLength="10" symbol="..." value="${edocStat1.remark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
						</v3x:table>
					</c:when>
					<c:when test="${resultType== 'signReport' }">
						<v3x:table data="${edocStats}" var="edocStat1" isChangeTRColor="true" showHeader="true" showPager="true" className="sort ellipsis">
							<v3x:column width="10%" label="edoc.element.doctype" alt="${edocStat1.docType}" symbol="..." value="${edocStat1.docType}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="20%" label="edoc.element.subject" alt="${edocStat1.subject}" symbol="..." value="${edocStat1.subject}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.secretlevel.simple" alt="${edocStat1.secretLevel}" symbol="..." value="${edocStat1.secretLevel}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.wordinno.label" alt="${edocStat1.serialNo}" value="${edocStat1.serialNo}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" maxLength="15" label="edoc.edoctitle.createPerson.label" alt="${edocStat1.createUser}" symbol="..." value="${edocStat1.createUser}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.edoctitle.createDate.label"  onClick="showDetail('${edocStat1.id}');" type="Date" className="cursor-hand sort nowrap">
								<fmt:formatDate value='${edocStat1.createDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />
							</v3x:column>
							<v3x:column width="10%" label="edoc.element.sendunit" value="${edocStat1.account }" maxLength="15" symbol="..." onClick="showDetail('${edocStat1.id}');" type="String"  className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" type="String" label="edoc.edoctitle.pigeonholePath.label" className="cursor-hand sort nowrap" onClick="showDetail('${edocStat1.id}');">
								<span onmouseover="showWholePath('${edocStat1.logicalPath}',this)">${edocStat1.archiveName}&nbsp;</span>
							</v3x:column>
							<v3x:column width="10%" label="edoc.stat.remark.label" value="${edocStat1.remark}" maxLength="10" symbol="..." onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
						</v3x:table>
					</c:when>
					<c:otherwise>
						<v3x:table data="${edocStats}" var="edocStat1" isChangeTRColor="true" showHeader="true" showPager="true" className="sort ellipsis">
							<v3x:column width="10%" label="edoc.element.doctype" alt="${edocStat1.docType}" symbol="..." value="${edocStat1.docType}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="20%" label="edoc.element.subject" alt="${edocStat1.subject}" symbol="..." value="${edocStat1.subject}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.secretlevel.simple" alt="${edocStat1.secretLevel}" symbol="..." value="${edocStat1.secretLevel}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.wordno.label" alt="${edocStat1.docMark}" value="${edocStat1.docMark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.edoctitle.createDate.label"  onClick="showDetail('${edocStat1.id}');" type="Date" className="cursor-hand sort nowrap">
								<fmt:formatDate value='${edocStat1.createDate}' type='both' dateStyle='full' pattern='yyyy-MM-dd' />
							</v3x:column>
							<v3x:column width="10%" label="edoc.element.issuer" value="${edocStat1.issUser}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
							<v3x:column width="10%" label="edoc.element.sendtounit" value="${edocStat1.sendTo }" maxLength="15" symbol="..." onClick="showDetail('${edocStat1.id}');" type="String"  className="cursor-hand sort nowrap"></v3x:column>
							
							<v3x:column width="10%" type="String" label="edoc.edoctitle.pigeonholePath.label" className="cursor-hand sort nowrap" onClick="showDetail('${edocStat1.id}');">
								<span onmouseover="showWholePath('${edocStat1.logicalPath}',this)">${edocStat1.archiveName}&nbsp;</span>
							</v3x:column>
							<v3x:column width="10%" label="edoc.stat.remark.label" maxLength="15" symbol="..." value="${edocStat1.remark}" onClick="showDetail('${edocStat1.id}');" type="String" className="cursor-hand sort nowrap"></v3x:column>
						</v3x:table>
					</c:otherwise>
				</c:choose>
 			</div>
 		 </div>
</div>
</form>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
if(this.name == 'top') {//第二次查询
	showDetailPageBaseInfo("bottom", "<fmt:message key='edoc.stat.query.label.title' />", [1,2], null, _("edocLang.detail_info_4007"));
} else {//第一次加载
	showDetailPageBaseInfo("parent.bottom", "<fmt:message key='edoc.stat.query.label.title' />", [1,2], null, _("edocLang.detail_info_4007"));
}
</script>
</body>