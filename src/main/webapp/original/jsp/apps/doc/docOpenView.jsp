<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%@ include file="docHeader.jsp"%>
</head>
	
	<frameset cols=",45" rows="*" id="docOpenMainFrame" >
		<c:choose>
			<c:when test="${param.versionFlag eq 'HistoryVersion'}">
				<frame src="${detailURL}?method=docOpenMenu&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}" frameborder="no" noresize="noresize" name="docOpenMenuFrame" id="docOpenMenuFrame" scrolling="NO">
		        <frame src="${detailURL}?method=docOpenLabel&versionFlag=${param.versionFlag}&docVersionId=${param.docVersionId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}&baseObjectId=${param.baseObjectId }&baseApp=${param.baseApp }" frameborder="no" name="docOpenLabelFrame" id="docOpenLabelFrame" scrolling="no" noresize="noresize">
			</c:when>
			<c:otherwise>
				<frame src="${detailURL}?method=docOpenMenu&docResId=${param.docResId}&openFrom=${param.openFrom}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&commentEnabled=${param.commentEnabled}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}&baseObjectId=${param.baseObjectId }&baseApp=${param.baseApp }" frameborder="no" noresize="noresize" name="docOpenMenuFrame" id="docOpenMenuFrame" scrolling="NO">	
		     	<frame src="${detailURL}?method=docOpenLabel&docResId=${param.docResId}&docLibId=${param.docLibId}&docLibType=${param.docLibType}&all=${param.all}&edit=${param.edit}&add=${param.add}&readonly=${param.readonly}&browse=${param.browse}&isBorrowOrShare=${param.isBorrowOrShare}&list=${param.list}&isLink=${param.isLink}&baseObjectId=${param.baseObjectId }&baseApp=${param.baseApp }" frameborder="no" name="docOpenLabelFrame" id="docOpenLabelFrame" scrolling="no" noresize="noresize">
			</c:otherwise>
		</c:choose>
	</frameset>

<noframes>
</noframes>
</html>