<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${name}</title>
</head>
<body>
<iframe width="100%" height="100%" frameborder="0" src="${detailURL}?method=showPost&articleId=${param.articleId}&from=${param.from}&familyId=${param.familyId}&v=${ctp:digest_3(param.articleId,param.familyId,param.from)}"></iframe>
</body>
</html>