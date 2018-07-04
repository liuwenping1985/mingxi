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
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript">
    var leaderObj = new Object();
    var accountId = "";
    /* 我的上级和我的同事的更多显示参数 */
    //var showLeadersIndex = 0;
    var showColleaguesIndex = 0;
    //var leadersList;
    var colleaguesList;
    var onceShowNum=16;
    
    /*所有联系人的更多显示参数 */
    var contactsShowStart = 0;
    var contactsShowEnd = 0;
    // contactsShowNum这个值设置大一些，先不进行分配加载了
    var contactsShowNum = 999999;
    var contactsShowMore = 200;
    var contactsHalfKey = "";
    var contactsHalfNum = 0;
    var contacts;
    $().ready(function() {
    	accountId = $("#accountId", parent.document).val();
    	var aManager = new addressBookManager();
    	var placeholder = "${ctp:i18n('addressbook.set.inputkeyword')}";
    	var searchContent = $("#searchContent",parent.document).val().trim();
    	searchContent = searchContent.replace(placeholder,"").trim();
        contacts = aManager.getContactsByAccountId(accountId,searchContent,"");
        fillcontacts();
    		
        if(contacts==""){
    	    $("#contactInfoDiv",parent.document).hide();
    		clearCard();
    		initRelation();
    		return;
        }
        var firstMemberId =  contacts[0].I;
    	
    	showMoreContacts();
    	fillCardInfo(firstMemberId);
    	fillRelationInfo(firstMemberId,accountId);
    	
        $("#contactInfoDiv",parent.document).show();
    	
        //加载完数据之后，获取显示的猎头字母数组
        var arrDl=[];
        var msgList_all=$(".msgList_all  ");
        dl=msgList_all.children("dl");

        for(var i=0;i<dl.length;i++){
        	dd=$(dl[i]).children("dd");
        	ddHTML=dd.children("span").html();
        	
        	if(ddHTML=="#"){
        		ddHTML="other";
        	}
        	arrDl.push(ddHTML);
        	//console.log(dd.position().top);
        }
        

        $(".msgList_all  ").scroll(function(){
        	$(".headList").addClass("show");
        	$(".headList").removeClass("hide");
        	for(var j=0;j<arrDl.length;j++){
        		var ddHeight=$("#"+arrDl[j]).height()+16;
        		
        		if($("#"+arrDl[j]).position().top>-ddHeight&& $("#"+arrDl[j]).position().top<5){
        			$(".ListBar",".headList").html(arrDl[j]);
        		}
        		
        	}
        });
    });
    
    function fillcontacts(){
    	$("#msgList_all").children('dv').remove();  
    }
    
    function showMoreContacts(){   		   
    	    contactsShowEnd = contactsShowNum;
		   	if(contactsShowStart>0){
		   		contactsShowEnd = contactsShowStart + contactsShowMore;
		   	}
		    if(contacts.length-contactsShowEnd<=0){
		    	contactsShowEnd=contacts.length;
		    	contactsHalfKey = "";
		    	//不能继续加载
		    }else{
		    	//可以进行下拉加载
		    }
		    
		    //一个字母下已经加载了一部分数据，现在开始加载后面剩余的数据
		    var contactsHalfHtml = getContactsHalfHtml(contactsShowStart,contactsShowEnd,contactsHalfKey);
		    if(contactsHalfKey!="" &&　contactsHalfHtml!=""){
			    $("#"+contactsHalfKey+"_ContactsArea").before(contactsHalfHtml);
		    }

		    if(contactsHalfNum<contactsShowMore){
			    //加载了一次当前key下的数据加载完了,继续加载后面的数据
			    contactsHalfKey = "";
			    if(contactsShowStart+contactsHalfNum < contactsShowEnd){
			    	//本地数据还没有加载完
		    		var contactsHtml = getContactsHtml(contactsShowStart+contactsHalfNum,contactsShowEnd);
			    	contactsShowStart = contactsShowEnd;
			    	$("#showContactsArea").before(contactsHtml);
			    }
		    } 
		    
  	   }
    
    
    function getContactsHalfHtml(showStart,showEnd,contactsHalfKey){
    	var html = new StringBuffer();
    	contactsHalfNum = 0;
    	if(contactsHalfKey==""){
    		return html;
    	}
    	
    	for(var i=showStart; i<showEnd; i++)  {
    		if(contacts[i].K.replace("\|","")!=contactsHalfKey){
    			return html;
    		}
    		contactsHalfNum++;
    		var memberId = contacts[i].I;
 			var name = getSubValue(contacts[i].N,12);
 			var mobilePhone = getSubValue(contacts[i].M,13);
 			
 			html.append("<dt class=\"dtBG\" onclick=\"showdetail('"+memberId+"');\">")
 				.append("<span class=\"msgList_name\">"+name+"</span>")
				.append("<span class=\"msgList_phone\">"+mobilePhone+"</span>")
				.append("</dt>");
    	}
    	
    	return html.toString();
    }
    
    
    function getContactsHtml(showStart,showEnd){
    	var html = new StringBuffer();
    	contactsHalfNum = 0; 
    	if(contacts.length==0){
    		return "";
    	}
    	var initKey=contacts[showStart].K.replace("\|","");
    	var showkey = initKey;
    	if(showkey =="other"){
    		showkey = "#";
    	}
		var html_before="<dl class='"+initKey+"' id='"+initKey+"'><dd><span class='anchor'>"+showkey+"</span></dd>"; 				
		var html_after="<input id='"+initKey+"_ContactsArea' type='hidden'/></dl>";
		var html_middle = new StringBuffer();
		for(var i=showStart; i<showEnd; i++)  {
			var memberId = contacts[i].I;
 			var name = getSubValue(contacts[i].N,12);
 			var mobilePhone = getSubValue(contacts[i].M,13);
 			var key = contacts[i].K.replace("\|","");
			contactsHalfKey = key;
 			if(initKey!=key){
 				//如果找不到对应key的内容，则从头开始添加
 				html.append(html_before).append(html_middle.toString()).append(html_after);
 				initKey = key;
 				showkey = initKey;
 		    	if(showkey =="other"){
 		    		showkey = "#";
 		    	}
 			    html_before="<dl class='"+initKey+"' id='"+initKey+"'><dd><span class='anchor'>"+showkey+"</span></dd>";	
 			    html_after="<input id='"+initKey+"_ContactsArea' type='hidden'/></dl>";
 			    html_middle = new StringBuffer();
 				html_middle.append("<dt class=\"dtBG\" onclick=\"showdetail('"+memberId+"');\">")
 						   .append("<span class=\"msgList_name\">"+name+"</span>")
 						   .append("<span class=\"msgList_phone\">"+mobilePhone+"</span>")
 					       .append("</dt>");
 			}else{
 				html_middle.append("<dt class=\"dtBG\" onclick=\"showdetail('"+memberId+"');\">")
 						   .append("<span class=\"msgList_name\">"+name+"</span>")
 						   .append("<span class=\"msgList_phone\">"+mobilePhone+"</span>")
 						   .append("</dt>");	
 			}
 			
 			if(i+1==showEnd){
 				html.append(html_before).append(html_middle.toString()).append(html_after);
 			}

		}
		
		return html.toString();
    }
    

    function clearCard(){
    	$(".cd_name", parent.document).html("&nbsp;");
        $("#deptName", parent.document).html("");
        $("#postName", parent.document).html("");
        $("#officeNum", parent.document).html("");
        $("#mobilePhone", parent.document).html("");
        $("#email", parent.document).html("");
        $("#location", parent.document).html("");
        $("#reporter", parent.document).html("");
        $("#gender", parent.document).html("");
        $("#code", parent.document).html("");
        $("#levelName", parent.document).html("");
        $("#postCode", parent.document).html("");
        $("#website", parent.document).html("");
        $("#blog", parent.document).html("");
        $("#weixin", parent.document).html("");
        $("#memo", parent.document).html("");
        $("#memo", parent.document).html("");
        $("#fileName", parent.document).attr('src',"/seeyon/apps_res/v3xmain/images/personal/pic.gif");
    }
    
    function initCardinfo(content){
    	$("#customerField",parent.document).children('dt').remove();
    	$(".cd_name", parent.document).html(getSubValue(content.memberName,28).escapeHTML());
    	$(".cd_name", parent.document).attr("title",content.memberName.escapeHTML());
    	
        $("#deptName", parent.document).html(getSubValue(content.deptName,30).escapeHTML());
        $("#deptName", parent.document).attr("title",content.deptName.escapeHTML());
        
        $("#postName", parent.document).html(getSubValue(content.postName,30).escapeHTML());
        $("#postName", parent.document).attr("title",content.postName.escapeHTML());
        
        $("#officeNum", parent.document).html(getSubValue(content.officeNum,30));
        $("#officeNum", parent.document).attr("title",content.officeNum);
        
        $("#mobilePhone", parent.document).html(getSubValue(content.mobilePhone,30));
        $("#mobilePhone", parent.document).attr("title",content.mobilePhone);
        
        $("#email", parent.document).html(getSubValue(content.email,30));
        $("#email", parent.document).attr("title",content.email);
        
        if(content.isInternal=="true"){
        	$("#innerArea", parent.document).show();
        	$("#blankArea", parent.document).hide();
        	
	        $("#location", parent.document).html(getSubValue(content.location,30));
	        $("#location", parent.document).attr("title",content.location);
	        
	        $("#reporter", parent.document).html(getSubValue(content.reporter,30));
	        $("#reporter", parent.document).attr("title",content.reporter);
        }else{
        	$("#innerArea", parent.document).hide();
        	$("#blankArea", parent.document).show();
        }
        if(content.gender=="1"){
	        $("#gender", parent.document).html("${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}");
	        $("#gender", parent.document).attr("title","${ctp:i18n('org.memberext_form.base_fieldset.sexe.man')}");
        }else if(content.gender=="2"){
        	$("#gender", parent.document).html("${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}");
        	$("#gender", parent.document).attr("title","${ctp:i18n('org.memberext_form.base_fieldset.sexe.woman')}");
        }
        $("#code", parent.document).html(content.code);
        $("#code", parent.document).attr("title",content.code);
        
        $("#levelName", parent.document).html(getSubValue(content.levelName,30));
        $("#levelName", parent.document).attr("title",content.levelName);
        
        $("#postCode", parent.document).html(getSubValue(content.postCode,30));
        $("#postCode", parent.document).attr("title",content.postCode);
        
        $("#website", parent.document).html(getSubValue(content.website,30));
        $("#website", parent.document).attr("title",content.website);
        
        $("#blog", parent.document).html(getSubValue(content.blog,30));
        $("#blog", parent.document).attr("title",content.blog);
        
        $("#weixin", parent.document).html(getSubValue(content.weixin,30));
        $("#weixin", parent.document).attr("title",content.weixin);
        
        $("#memo", parent.document).html(getSubValue(content.memo,30));
        $("#memo", parent.document).attr("title",content.memo);
        
	    $("#fileName", parent.document).attr('src',content.fileName);
	    
	    var htmlStr="";
	    var customerAddressbookSize=content.customerAddressbookSize;
	    	if(parseInt(customerAddressbookSize)>0){
	    		for(var i=0;i<parseInt(customerAddressbookSize);i++){
	    			var customerName = eval("content.customerName"+i);
	    			var subCustomerName = getSubValue(customerName,8);
	    			var customerValue = eval("content.customerValue"+i);
	    			var subCustomerValue = getSubValue(customerValue,30);
	    			htmlStr+="<dt class='cd_detail'><span class='cd_bar' title='"+customerName+"'>"+subCustomerName+" :</span><span class='cd_message' title='"+customerValue+"'>&nbsp;"+subCustomerValue+"</span></dt>"
	    		}
	    	}
	     $("#showArea",parent.document).before(htmlStr);
	     
	    parent.addActive(content);
    }
    
    //卡片信息
    function fillCardInfo(memberId){
    	clearCard();
     	$.ajax({
    		sync : true,
    		type: "POST",
    		url: "/seeyon/addressbook.do?method=getMemberInfoById",
    		data: {"memberId": memberId,"accountId":accountId},
    		dataType : 'text',
   	        success : function(data) {
   	    	  var content = jQuery.parseJSON(data);
   	    	  initCardinfo(content);
   	        },
   	        error : function(XMLHttpRequest, textStatus, errorThrown) {
   	          clearCard();
   	          alert("失败");
   	        }
    	}); 
    }
    
    function initRelation(){
        //showLeadersIndex = 0;
        showColleaguesIndex = 0;
    	$("#leaderDiv",parent.document).children('dt').remove();  
    	$("#colleaguesDiv",parent.document).children('dt').remove();  
    	//$("#showMoreLeaders", parent.document).hide();
    	$("#showMoreColleagues", parent.document).hide();
    }
    
    
   //上级领导和同事
    function fillRelationInfo(memberId,accountId){
    	initRelation();
    	var aManager = new addressBookManager();
    	var relationInfoMap = aManager.getRelationInfoByMemberId(memberId,accountId);
    	
/*         leadersList = relationInfoMap["leaders"];
        showMore("leaders"); */
    	
        if(relationInfoMap != null){
	        colleaguesList = relationInfoMap["colleagues"]; 
	        showMore("colleagues");
        }
    }
   
   function showMore(showType){
/* 	   if(showType=="leaders"){
		   	var showStart = showLeadersIndex;
		   	var showEnd = showLeadersIndex+onceShowNum;
		    if(leadersList.length-showEnd<=0){
		    	showEnd=leadersList.length;
		    	$("#showMoreLeaders", parent.document).hide();
		    }else{
		    	$("#showMoreLeaders", parent.document).show();
		    }
	    	showLeadersIndex = showEnd;
	    	var leaderhtml = getRelationHtml(leadersList,showStart,showEnd);
	    	$("#showleadersArea", parent.document).before(leaderhtml);
	   } */
	   
	   if(showType=="colleagues"){
		   	var showStart = showColleaguesIndex;
		   	var showEnd = showColleaguesIndex+onceShowNum;
		    if(colleaguesList.length-showEnd<=0){
		    	showEnd=colleaguesList.length;
		    	$("#showMoreColleagues", parent.document).hide();
		    }else{
		    	$("#showMoreColleagues", parent.document).show();
		    }
	    	showColleaguesIndex = showEnd;
	    	var colleagueshtml = getRelationHtml(colleaguesList,showStart,showEnd);
	    	$("#showColleaguesArea", parent.document).before(colleagueshtml);
	   }
   }
   
   function getRelationHtml(list,showStart,showEnd){
	   	var htmlStr="";
		for(i=showStart;i<showEnd;i++){ 
			var name = list[i]["name"];
			name = getSubValue(name,8);
			var memberId = list[i]["id"];
			var fileName = list[i]["description"];
		 	if(i%4 == 0){ 
		 		htmlStr+="<dt class='relation_LIST left '>"+
		    			    "<div class='list_IMG'>"+
			    				"<span>"+
			    					"<a><img src='"+fileName+"' width='50' height='50' class='radius' onclick=\"showV3XMemberCard('"+memberId+"',window)\"/></a>"+
			    				"</span>"+
		    			   " </div>"+
			    			"<div class='list_NAME'>"+
			    				"<span>"+name+"</span>"+
			    			"</div>"+
		    		       "</dt>";
	 		}else{
	 			htmlStr+="<dt class='relation_LIST left marginLeft40' >"+
							    "<div class='list_IMG'>"+
				    				"<span>"+
				    				"<a><img src='"+fileName+"' width='50' height='50' class='radius'onclick=\"showV3XMemberCard('"+memberId+"',window)\" /></a>"+
				    				"</span>"+
							   " </div>"+
				    			"<div class='list_NAME'>"+
				    			"<span>"+name+"</span>"+
				    			"</div>"+
					  	    "</dt>";
			} 
		}
		return htmlStr;
   }
    
    function showdetail(memberId){
    	fillCardInfo(memberId);
    	fillRelationInfo(memberId,accountId);
    }
    
    </script>
</head>
<body style="background:#e9eaec;overflow:auto" onclick="parent.hideMenu();">
<div class="container overflow">
<div class="centerBar  left ">
	<div class="orgnazitionTree  overflow">
		<div class="contacts_li_div  " >
			<div class="msgList_all  " style="overflow-y:auto;" >
			
			    <input id="showContactsArea" type="hidden" />
			</div>
			
		</div>
		<div class="searchBar ">
			<ul class="termBar">
				<li >A</li>
				<li >B</li>
				<li >C</li>
				<li >D</li>
				<li >E</li>
				<li >F</li>
				<li >G</li>
				<li >H</li>
				<li >I</li>
				<li >J</li>
				<li >K</li>
				<li >L</li>
				<li >M</li>
				<li >N</li>
				<li >O</li>
				<li >P</li>
				<li >Q</li>
				<li >R</li>
				<li >S</li>
				<li >T</li>
				<li >U</li>
				<li >V</li>
				<li >W</li>
				<li >X</li>
				<li >Y</li>
				<li >Z</li>
				<li >#</li>
			</ul>
		</div>
		<div class="currHover hide">
			<span class="currHover_span"></span>
		</div>
		<div class="currList headList hide">
			<div class="ListBar"></div>
		</div>
		<div class="currList nextList hide">
			<div class="ListBar"></div>
		</div>
	</div>
</div>
</div>
</body>
	
</html>