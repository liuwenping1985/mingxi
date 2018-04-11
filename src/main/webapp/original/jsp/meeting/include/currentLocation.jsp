<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

var spans = document.getElementsByTagName('span');
for (var i = 0; i < spans.length; i++) {
	var span = spans[i];
	var current = span.getAttribute('current');
	if(current=='true') { 
		var div = $(span).find("div[@class*='tab-tag-middel-sel']");
		if(div) {
			showCtpLocation(span.getAttribute('resCodeParent'), {surffix : div.html()});
		}
	}
}

</script>
</head>
<body>


</body>
</html>