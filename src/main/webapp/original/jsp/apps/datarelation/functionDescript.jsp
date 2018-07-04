<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../ctp/common/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>功能说明</title>
<style type="text/css">
	.description{
	  padding: 40px;
	  font-size: 14px;
	}
	.font_size{
		font-size: 14px;
	}
	.font_color{
	    color: #215968;
	    padding-top: 5px;
	}
</style>
<script type="text/javascript">
function showTemplImg(){
	  var fndesc = $.dialog({
        url : _ctxPath + "/dataRelation.do?method=showTemplImg",
        title : $.i18n("datarelation.descript.title.js"),
        width : 1010,
        height : 580,
        targetWindow : getCtpTop()
    });  
}
</script>
</head>
<body>
<div >
  <div class="description">
    <span>${ctp:i18n('datarelation.descript.content1.js')}<span><br><br>
    <span>${ctp:i18n('datarelation.descript.content2.js')}</span>
    <span style="color: #3ACBFA;cursor: pointer;" onclick="showTemplImg()">${ctp:i18n('datarelation.descript.content3.js')}</span><br><br>
    <div class="font_size">${ctp:i18n('datarelation.descript.content4.js')}</div>
    <div class="font_color">
      <span>${ctp:i18n('datarelation.descript.content5.js')}</span>
      <span>${templateName}</span>
    </div>
    <div class="font_color">
     <span>${ctp:i18n('datarelation.descript.content7.js')}</span>
     <span>${formName}</span>
    </div>
    <div class="font_color">
      <span>${ctp:i18n('datarelation.descript.content9.js')}</span>
      <span>${createMemberName}</span>
    </div>
    <div class="font_color">
     <span>${ctp:i18n('datarelation.descript.content11.js')}</span>
     <span>${departName}</span>
    </div><br>
    <div class="font_size"><span>${ctp:i18n('datarelation.descript.content13.js')}</span></div>
    <div class="font_size"><span>${ctp:i18n('datarelation.descript.content14.js')}</span></div>
    <div class="font_color"><span>${ctp:i18n('datarelation.descript.content15.js')}</span></div>
    <div class="font_color" style="margin-left: 22px;"><span>${ctp:i18n('datarelation.descript.content16.js')}</span></div>
    <div class="font_color" style="margin-left: 22px;"><span>${ctp:i18n('datarelation.descript.content17.js')}</span></div>
    <br>
    <div >
      <c:if test="${local=='en'}">
       <img src="${path}/apps_res/datarelation/image/dataImg_en.jpg" >
      </c:if>
      <c:if test="${local!='en'}">
       <img src="${path}/apps_res/datarelation/image/dataImg.png" >
      </c:if>
    </div>
  </div>
</div>
</body>
</html>