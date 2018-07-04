<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title></title>
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/common.css${v3x:resSuffix()}" />" />
    <link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/addressbook/css/index.css${v3x:resSuffix()}" />" />
    <script src="<c:url value="/apps_res/addressbook/js/index.js${v3x:resSuffix()}" />"></script>
    <script src="<c:url value="/apps_res/addressbook/js/common.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    $().ready(function() {
    	/* $("#content_card").css("height","950px"); */
    	frameId = "privateFrame";
    	accountId = '${loginAccount}';
    	accountName = '${loginAccountName}';
    	$("#currentAccountId").html(getSubValue(accountName,34));
    	$("#accountId").val(accountId);
    	//creataAccountTree();
    	$("#treeFrame").attr("src","/seeyon/addressbook.do?method=treeOwnTeam&addressbookType=2&accountId="+accountId);
    	var showType = $("#showType").val();
    	$("#listFrame").attr("src","/seeyon/addressbook.do?method=initList&addressbookType=2&showType="+showType+"&accountId="+accountId);
    	$("#frameUrl").val("/seeyon/addressbook.do?method=initList&addressbookType=2&showType="+showType+"&accountId="+accountId);
    	setHeight();
    	
    	$('#searchContent').keydown(function(e){
    		if(e.keyCode==13){
    			searchContacts();
    		}
    		}); 
    	
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
<%-- 							<div class="left" id="cardButtonDiv">
								<ul class="overflow">
									<!-- <li class="left innerChild"><em id="checkBox_h" class="checkBox_h icon16 containChildren_icon16 checkBox_h_current"></em><span>含子部门成员</span></li> -->
									<li class="left btnLine"><em></em></li>
									<c:if test="${ctp:hasPlugin('uc')}">
										<li class="left sendMsg_h" onclick="listFrame.window.sendMsg();"><em class="icon16 messageImg_icon16"></em><span>发送消息</span></li>
									</c:if>
								</ul>
							</div> --%>
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
						<%-- <%@ include file="/WEB-INF/jsp/addressbook/bigCard.jsp"%> --%>
			  </div>
			</div>
        </div>
    </div>
</body>
</html>