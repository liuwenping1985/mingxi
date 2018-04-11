<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <%-- <script src="<c:url value="/apps_res/addressbook/js/jquery.js${v3x:resSuffix()}" />"></script> --%>
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
    <script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    var showIndex = 0;
    var onceShowNum=6;
    var memberSize = 0;
    $().ready(function() {
    	 init();
    	 memberSize = '${resultCount}';
    	 if(memberSize ==0 || memberSize=='0'){
    		 var nullHtml='<div align="center"><img width="103" height="129" style="display: inline-block;margin-top: 150px;" src="/seeyon/apps_res/pubinfo/image/null.png"><div style="font-size: 14px;color: #999;margin-top: 5px;">${ctp:i18n("addressbook.set.nodata")}</div></div>';
	    	$("#showArea").before(nullHtml);
    		 return;
    	 }
    	 showMore();
    }); 
    function init(){
    	showIndex = 0;
    	$("#showMore").hide();
    	$("#cardListDiv").children('dv').remove();  
    }
    
    function showMore(){
	   	var showStart = showIndex;
	   	var showEnd = showIndex+onceShowNum;
	    if(memberSize-showEnd<=0){
	    	showEnd=memberSize;
	    	$("#showMore").hide();
	    }else{
	    	$("#showMore").show();
	    }
	    showIndex = showEnd;
    	var memberhtml = getHtml(showStart,showEnd);
    	$("#showArea").before(memberhtml);
    	var jsFilePath= "<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />";
    	//alert(jsFilePath);
    	$.getScript(jsFilePath);
    }
    
    function getHtml(showStart,showEnd){
 	   	var htmlStr="";
    	<c:forEach items="${members}"  var="obj" varStatus="status">
    		var index='${status.count}';
     		if(parseInt(showStart+1) <= parseInt(index) && parseInt(showEnd) >= parseInt(index)){
     			var name = getSubValue("${v3x:toHTML(obj.name)}",28);
     			var companyName = getSubValue("${v3x:toHTML(obj.companyName)}",30); 
     			var companyLevel = getSubValue("${v3x:toHTML(obj.companyLevel)}",30); 
     			var companyPhone = getSubValue("${v3x:toHTML(obj.companyPhone)}",30);
     			var mobilePhone = getSubValue("${v3x:toHTML(obj.mobilePhone)}",30);
     			var fileName = "/seeyon/apps_res/v3xmain/images/personal/pic.gif";
     			var memberId = "${obj.id}";
     			var memberInfo = memberId+"_"+name;
     			htmlStr+=
 					"<div class='pageTur  '  >"+
 					"<em class='pageTurning '></em>"+
 					"<div class='cd_list overflow cd_show left'>"+
 						"<em class='choose  current_card'>"+
 					"<input type='hidden' id='memberInfo' value=\""+memberInfo+"\"></em>"+
 						"<div class='cardMsg'>"+
 							"<div class='cd_img left'>"+
 								"<span class=''>"+
 									"<img src='"+fileName+"' width='50' height='50' class='radius'>"+
 								"</span>"+
 							"</div>"+
 							"<dl class='left'>"+
 								"<dd class='cd_name'><span>"+name+"</span></dd>"+
 								"<dt class='cd_detail'>"+
 									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.account')}</span>"+
 									"<span class='cd_message'>"+companyName+"</span>"+
 								"</dt>"+
 								"<dt class='cd_detail'>"+
 									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.memberleavel')}</span>"+
 									"<span class='cd_message'>"+companyLevel+"</span>"+
 								"</dt>"+
 								"<dt class='cd_detail'>"+
 									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.tel')}</span>"+
 									"<span class='cd_message'>"+companyPhone+"</span>"+
 								"</dt>"+
 								"<dt class='cd_detail'>"+
 									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.handphone')}</span>"+
 									"<span class='cd_message'>"+mobilePhone+"</span>"+
 								"</dt>"+
 							"</dl>"+
 						"</div>"+
 					"</div>"+
 				"</div>";
    		}
    	</c:forEach>  
 		return htmlStr;
    }
</script>
</head>
<body  onclick="parent.hideMenu();">
		<div class="cardList">
			<div class="card ht" style="overflow-y:scroll;">
				<div class="littleCard overflow" id="cardListDiv">
					<input id="showArea" type="hidden"/>
				</div>
		    	 <div class="showMore" id="showMore">
					<a onclick="javascript:showMore();"><font >${ctp:i18n('addressbook.set.showmore')}</font></a>
			    </div>

			</div>
		</div>
</body>



</html>