<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml" class="overflow">
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <script type="text/javascript" src="${path}/ajax.do?managerName=orgManager"></script>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
    <script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    var curUserId = $.ctx.CurrentUser.id;
    var showIndex = 0;
    var onceShowNum=6;
    var memberSize = 0;
    var memberJsonObj;
    var oManager;
    $().ready(function() {
    	oManager = new orgManager();
    	 init();
    	 var memberStr = '${memberStr}';
    	 if(memberStr==''){
	    	var nullHtml='<div align="center"><img width="103" height="129" style="display: inline-block;margin-top: 150px;" src="/seeyon/apps_res/pubinfo/image/null.png"><div style="font-size: 14px;color: #999;margin-top: 5px;">${ctp:i18n("addressbook.set.nodata")}</div></div>';
	    	$("#showArea").before(nullHtml);
    		 return;
    	 }else{
    		 memberJsonObj=jQuery.parseJSON(memberStr);
    	     memberSize = memberJsonObj.length;
    		 showMore();
    	 }
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
    	$(".choose").unbind("click"); 
    	$.getScript(jsFilePath);
    }
    
/*     function getHtml(showStart,showEnd){
 	   	var htmlStr="";
 	    htmlStr = getMoreHtml(showStart,showEnd);
 		return htmlStr;
    } */
    
    
    function getHtml(showStart,showEnd){
    	var htmlStr="";
    	if(memberJsonObj.length==0){
    		return "";
    	}
		for(var i=showStart; i<showEnd; i++)  {
 			var name = getSubValue(memberJsonObj[i].N,26).escapeHTML(); 
 		    var postName = getSubValue(memberJsonObj[i].P,30).escapeHTML(); 
 			var departmentName = getSubValue(memberJsonObj[i].D,30).escapeHTML(); 
 			var officeNum = getSubValue(memberJsonObj[i].O,30);
 			var mobilePhone = getSubValue(memberJsonObj[i].M,30);
 			var emailAddress = getSubValue(memberJsonObj[i].E,30);
 			var memberId = memberJsonObj[i].I;
 			var fn = memberJsonObj[i].F;
 			var fileName = oManager.getAvatarImageUrl(memberId);
 			var memberInfo = memberJsonObj[i].MI;
 			
 			var actionStr=
			"<div class='sendMessage overflow' style='position:relative;'>"+
				"<div class='msgImg_list' style='padding-bottom:0;'>"+
					"<div class='coverWhite' style='bottom:32px;'></div>"+
					"<a href='javascript:void(0)' class='button margin_l_92' name='sendcollaboration' title=\"${ctp:i18n('addressbook.set.sendcollaboration')}\" onmouseenter=\"$(this).css('background','#5093e1');$(this).children('em').css('background-position','-176px -31px');\" onmouseleave=\"$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','0 -32px');\" onclick=\"parent.doActive('sendcollaboration','"+memberId+"','"+name+"','"+emailAddress+"','')\"><em class='icon16 addConection_icon16' style='margin-bottom:3px;'></em></a>";
	    	//不能发邮件
			if(!(!$.ctx.resources.contains("F12_mailcreate") || ("${v3x:hasPlugin('webmail')}" == 'false')) && emailAddress!=""){
				actionStr+="<a href='javascript:void(0)' class='button '  name='sendemail' title=\"${ctp:i18n('addressbook.set.sendemail')}\" onmouseenter=\"$(this).css('background','#5093e1');$(this).children('em').css('background-position','-209px -31px');\" onmouseleave=\"$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-33px -31px');\" onclick=\"parent.doActive('sendemail','"+memberId+"','"+name+"','"+emailAddress+"','')\"><em class='icon16 sendMsg_icon16' style='margin-bottom:3px;'></em></a>";
			}
			//不能发短信
	    	if($.ctx.CurrentUser.canSendSMS){
	    		actionStr+="<a href='javascript:void(0)' class='button '  name='sendSMS' title=\"${ctp:i18n('addressbook.set.sendSMS')}\" onmouseenter=\"$(this).css('background','#5093e1');$(this).children('em').css('background-position','-224px -32px');\" onmouseleave=\"$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-48px -32px');\" onclick=\"parent.doActive('sendSMS','"+memberId+"','"+name+"','"+emailAddress+"','')\"><em class='icon16 sendShortMsg_icon16' style='margin-bottom:3px;'></em></a>";
	    	}
	    	if( curUserId != memberId){
		    	actionStr+="<a href='javascript:void(0)' class='button '  name='addcorrelation' title=\"${ctp:i18n('addressbook.set.addRelation')}\" onmouseenter=\"$(this).css('background','#5093e1');$(this).children('em').css('background-position','-241px -31px');\" onmouseleave=\"$(this).css('background','#f3f3f3');$(this).children('em').css('background-position','-65px -31px');\" onclick=\"parent.doActive('addcorrelation','"+memberId+"','"+name+"','"+emailAddress+"','')\"><em class='icon16 sendEmail_icon16' style='margin-bottom:3px;'></em></a>";
	    	}
			actionStr+=	"</div></div>";
	    	
	
 			htmlStr+=
					"<div class='pageTur  '  >"+
					"<em class='pageTurning ' onclick=\"showV3XMemberCard('"+memberId+"',window)\"></em>"+
					"<div class='cd_list overflow cd_show left'>"+
						"<em class='choose  current_card'>"+
					"<input type='hidden' id='memberInfo' value=\""+memberInfo+"\"></em>"+
						"<div class='cardMsg'>"+
							"<div class='cd_img left'>"+
								"<span class=''>"+
									"<img src='"+fileName+"' width='50' height='50' class='radius' onclick=\"showV3XMemberCard('"+memberId+"',window)\">"+
								"</span>"+
							"</div>"+
							"<dl class='left'>"+
								"<dd class='cd_name'><span onclick=\"showV3XMemberCard('"+memberId+"',window)\">"+name+"</span></dd>"+
								"<dt class='cd_detail'>"+
									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.dep')}</span>"+
									"<span class='cd_message'>&nbsp;"+departmentName+"</span>"+
								"</dt>"+
								"<dt class='cd_detail'>"+
									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.post1')}</span>"+
									"<span class='cd_message'>&nbsp;"+postName+"</span>"+
								"</dt>"+
								"<dt class='cd_detail'>"+
									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.officeNum')}</span>"+
									"<span class='cd_message'>&nbsp;"+officeNum+"</span>"+
								"</dt>"+
								"<dt class='cd_detail'>"+
									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.handphone')}</span>"+
									"<span class='cd_message'>&nbsp;"+mobilePhone+"</span>"+
								"</dt>"+
								"<dt class='cd_detail'>"+
									"<span class='cd_bar'>${ctp:i18n('relate.memberinfo.email')}</span>"+
									"<span class='cd_message cd_email'>&nbsp;"+emailAddress+"</span>"+
								"</dt>"+
							"</dl>"+
						"</div>"+
					"</div>"+actionStr+
				"</div>";
		}
		
		return htmlStr;
    }
    
    function sendMsg(){
    	sendMessageForAddress();
    }
    </script>
</head>
<body  onclick="parent.hideMenu();">
		<div class="cardList">
			<div class="card ht" style="overflow-y:scroll;">
				<div class="littleCard overflow" id="cardListDiv">
					<input id="showArea" type="hidden"/>
					<div class="showMore" id="showMore">
						<a onclick="javascript:showMore();"><font >${ctp:i18n('addressbook.set.showmore')}</font></a>
				    </div>
				</div>
			    

			</div>
		</div>
</body>



</html>