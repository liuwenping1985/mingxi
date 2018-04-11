<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title></title>
    <%-- <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/skin.css${v3x:resSuffix()}" />" /> --%>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <%-- <script src="<c:url value="/apps_res/addressbook/js/jquery.js${v3x:resSuffix()}" />"></script> --%>
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
     <script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    var addrelation="${ctp:i18n('peoplecard.addrelpeple.js')}";
    $().ready(function() {
    	/* $("#content_card").css("height","950px"); */
    	frameId = "personalFrame";
    	accountId = '${loginAccount}';
    	accountName = '${loginAccountName}';
    	$("#currentAccountId").html(getSubValue(accountName,34));
    	$("#accountId").val(accountId);
    	//creataAccountTree();
    	$("#treeFrame").attr("src","/seeyon/addressbook.do?method=treeOwnTeam&addressbookType=1&accountId="+accountId);
    	var showType = $("#showType").val();
    	$("#listFrame").attr("src","/seeyon/addressbook.do?method=initList&addressbookType=4&showType="+showType+"&accountId="+accountId);
    	$("#frameUrl").val("/seeyon/addressbook.do?method=initList&addressbookType=4&showType="+showType+"&accountId="+accountId);
    	setHeight();
    	if(showType=="card"){
    		$("#cardButtonDiv").show();
    	}else{
    		$("#cardButtonDiv").hide();
    	}
    	
    	//当浏览器不支持placeholder属性时，调用placeholder函数
    	if(!supportPlaceholder){
    	    $('input').each(function(){
    	        text = $(this).attr("placeholder");
    	        if($(this).attr("type") == "text"){
    	            placeholder($(this));
    	        }
    	    });
    	}
    });
   
    
    function doActive(type,memberId,name,emailAddress,relateType){
     	var top = getA8Top();
    	var i = 0;
    	var dialog;
     	while ($(top.document).find("#main").length == 0 && i < 5) {
    		top = top.v3x.getParentWindow().getA8Top();
    		i++;
    	}
    	//发消息
    	if(type=="sendmsg"){
        	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc') || i > 1){
        	}else{
        		var message = top.getUCStatus();
        		if (message != '') {
        		  try{
        			$.alert(message);
        		  }catch(e){
        		    alert(message);
        		  }
        		  return;
        		}
        		top.sendUCMessage(name,memberId);
        	}
    	}
    	
    	if(type=="sendcollaboration"){
        	//发协同
        	if(!$.ctx.resources.contains("F01_newColl") || ("${v3x:hasPlugin('collaboration')}" == 'false')){
        	}else{
    		    var params = {
    		            personId : memberId,
    		            from : 'peopleCard'
    		    }
    		    collaborationApi.newColl(params);
        	}
    	}
    	
    	if(type=="addcorrelation"){
        	//加为关联
        	if(relateType==''){
        	/* 	$("#addcorrelation").attr("title","加为关联人员");
        		$("#addcorrelation").show(); */
            		dialog = $.dialog({
            			title: addrelation,
            		    id: 'url',
            		    url: '/seeyon/relateMember.do?method=addRelativePeople&receiverId='+memberId,
            		    width: 400,
            		    height: 200
            		});
        	}else{
        		/* $('#addcorrelation').unbind("click"); 
        		$("#addcorrelation").attr("title",content.relateType); */
        		//$("#addcorrelation").hide();
        	}
    	}
    	
    	if(type=="sendemail"){
        	//发送邮件
        	if(!$.ctx.resources.contains("F12_mailcreate") || i > 1 || ("${v3x:hasPlugin('webmail')}" == 'false')){
        	}else{
        			if(emailAddress!=""){
        				sendMail(emailAddress);
        			}
        	}
    	}
    	
    	if(type=="sendSMS"){
        	//发消息
        	if(!$.ctx.CurrentUser.canSendSMS){
        	}else{
        			sendSMS(memberId);
        	}
    	}
    	
    }
    </script>
</head>

<body style="background:#e9eaec;" >
<input type="hidden" id="accountId" value=""/>
     <div id='layout' class="container overflow comp" comp="type:'layout'" >
        <div class="layout_west" layout="width:273,minWidth:100,maxWidth:273" style="overflow: hidden;">
            	<div class="centerBar  left ">
					<div class="header">
						<div>
							<div class="searchBox">
								<input id="searchContent" maxlength="12" type="text" placeholder="${ctp:i18n('addressbook.set.inputkeyword')}"/>
								<em class="icon16 search_icon16" onclick="searchContacts()"></em>
							</div>
						</div>
					</div>
					<div class="orgnazitionTree overflow">
						<div class="companyCheck" style="display: none;">
							<span name="currentAccountId" id="currentAccountId"></span>
							<em class="icon16 downCheck_icon16 "></em>
						</div>
 						<div id="accountContent" class="border_all bg_color_white" style="width:270px; position: absolute;display: none;height:300px;overflow-y: auto;" >
							<ul id="accountTree" name="accountTree" class="ztree" style="margin-top:0; width:90%;"></ul>
						</div> 
						<div class="treeList_div">
							<div class="treeList   ht " style="height:550px;">
								<iframe width="100%" height="100%" id="treeFrame" name="treeFrame" src="" frameborder="0"></iframe>
							</div>
						</div>
					</div>
				</div>
        </div>
        <div class="layout_center" layout="width:200,minWidth:50,maxWidth:200" style="height:100px; overflow-x: hidden;overflow-y: hidden;">
           	<div class="left" style="width: 100%;">
				<div class="cardList">
					<div class="header ">
						<div class="btnSet overflow">
							<div class="left" id="cardButtonDiv">
								<ul class="overflow">
									<!--
									 <li class="left innerChild"><em id="checkBox_h" class="checkBox_h icon16 containChildren_icon16 checkBox_h_current"></em><span>含子部门成员</span></li> 
									 <li class="left btnLine"><em></em></li>
									-->
									
								</ul>
							</div>
							<div class="right">
								<ul class="overflow triggerUl ">
									<li class="left tableList" onclick="showlistType('card');" title="${ctp:i18n('addressbook.set.showcard')}"><em class="icon16 tableList_Current_icon16"></em></li>
									<li class="left list" onclick="showlistType('list');" title="${ctp:i18n('addressbook.set.showlist')}"><em class="icon16 list_icon16"></em></li>
								</ul>
							</div>
						</div>
					</div>
						<input type="hidden" id="showType" value="list">
						<input type="hidden" id="frameUrl" value="">
						<iframe  style="height: 100px;width: 100%;" id="listFrame" name="listFrame" src="" frameborder="0" scrolling="yes"></iframe>
						<%@ include file="/WEB-INF/jsp/addressbook/bigCard.jsp"%>
			  </div>
			</div>
        </div>
    </div>
</body>
</html>