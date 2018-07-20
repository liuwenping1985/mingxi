<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">

if(isLocationOnLoad == false) {
	showEdocLocation();
}

function showEdocLocation() {
	$("span.resCode").each(function() {
		if($(this).attr('current')=='true' || $(this).attr('current')==undefined) {
			var div = null;
			try{
				div = $(this).find("div[@class*='tab-tag-middel-sel']");
			}catch (e){//目前有些代码用的jq1.4，有的用了jq1.8，所以做了个try catch。WTF！
				div = $(this).find("div[class*='tab-tag-middel-sel']");
			}
			if(div!=null && div.html()!=null) {
				//showCtpLocation($(this).attr('resCodeParent'), {surffix : div.html()});
				showCtpLocation($(this).attr('resCodeParent'));
			}
		}
	});
}

</script>
</head>
<body>


</body>
</html>