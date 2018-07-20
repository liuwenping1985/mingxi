<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>listDesc</title>
</head>
<style>
<!--
*{
	padding: 0px;
	margin: 0px;
}
html, body {
 height:100%;
 overflow: hidden;
}
.countNumber{
	font-weight: bolder;
	font-size: 16px;
}

#titleDiv{
	position: absolute;
	left: 30px;
	top: 20px;
	width: 500px;
	z-index:2;
}

.title{
	font-size: 26px;
	font-family: Verdana;
	font-weight: bolder;
	padding-right: 20px;
}

#Layer1 {
	font-size: 12px;
	position: absolute;
	width: 660px;
	height: 78px;
	z-index: 1;
	left: 30px;
	top: 80px;
	color: #969696;
}
#imgDiv{
    height: 70px;
    width: 160px;
}
#pagebreakspare{
	position: absolute;
	top: 0;
	left: 0;
	z-index: 1000;
}
#footerpadding{
	position: absolute;
	bottom: 0;
	left: 0;
	z-index: 999;
	border-bottom:10px solid #ededed;
	width: 100%;
}
li{
	line-height: 19px;
	margin-left:10px;
}
//-->
</style>
<body>
	<div id="allDiv" style="">
	    <div id="titleDiv" class="clearfix">
	        <span class="title">
	        <c:if test="${type eq 1}">${ctp:i18n('plan.type.dayplan')}</c:if>
	        <c:if test="${type eq 2}">${ctp:i18n('plan.type.weekplan')}</c:if>
	        <c:if test="${type eq 3}">${ctp:i18n('plan.type.monthplan')}</c:if>
	        <c:if test="${type eq 4}">${ctp:i18n('plan.type.anyscopeplan')}</c:if>
	        </span>
	        <span class="font_size12" style="padding:20px;">
	            <span class="margin_t_10 font_size14">${ctp:i18n('plan.desc.total')} 
	                <span class="countNumber">${planListCount }</span> ${ctp:i18n('plan.desc.article')}
	            </span>
	        </span>
	    </div>
	    <div id="Layer1">
	  		<ul id="descriptionPlace">
	  			<li>${ctp:i18n('plan.desc.listdesc.firstsentence')}</li> 
	  			<li>${ctp:i18n('plan.desc.listdesc.secondsentence')}</li> 
	  			<li>${ctp:i18n('plan.desc.listdesc.thirdsentence')}</li>
	  		</ul>
	  		
		</div>
    </div>
</body>
</html>