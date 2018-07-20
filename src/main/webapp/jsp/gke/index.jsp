<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="head.jsp"%>
<script type="text/javascript">
getA8Top().hiddenNavigationFrameset();
		function chang(index){			
			for(var a = 1;a<2;a++){
			    if(a == index ){
			        var b = a;
			        document.getElementById(b+"1").className="tab-tag-left-sel";
			        document.getElementById(b+"2").className="tab-tag-middel-sel";
			        document.getElementById(b+"3").className="tab-tag-right-sel";			        			        
			    }else{
			        var c = a;
			        document.getElementById(c+"1").className="tab-tag-left";
				    document.getElementById(c+"2").className="tab-tag-middel";
				    document.getElementById(c+"3").className="tab-tag-right";
			    }
			}
			if(index == 1){
			    document.mainframe.location.href ="${gkeURL}?method=framesetThree";
			}else if(index == 2){
			    document.mainframe.location.href="${gkeURL}?method=frame";
			}
		}
</script>
</head>
<body class="tab-body">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="bottom" height="26" class="tab-tag">
			<div class="div-float">
				<div id="11" class="tab-tag-left-sel"></div>
				<div id="12" class="tab-tag-middel-sel" onclick="chang(1)"><fmt:message key="org.synchron.hand" /></div>
				<div id="13" class="tab-tag-right-sel"></div>
				
				<div class="tab-separator"></div>
				<!-- 
				<div id="21" class="tab-tag-left"></div>
				<div id="22" class="tab-tag-middel  cursor-hand" onclick="chang(2)"><fmt:message key="org.synchron.auto" /></div>
				<div id="23" class="tab-tag-right"></div>
				
				<div class="tab-separator"></div>
				 -->
			</div>
		</td>
	</tr>
	<tr>
		<td class="tab-body-bg" style="margin: 0px;padding:0px">
			<iframe frameborder="0" src="${gkeURL}?method=framesetThree" id="mainframe" name="mainframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
</table>
</body>
</html>