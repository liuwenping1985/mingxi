<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp" %>
<!DOCTYPE html>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"  src="${path}/apps_res/colCube/js/seeyon.ui.peopleSquare-debug.js${v3x:resSuffix()}"></script>
<script type="text/javascript"  src="${path}/apps_res/webmail/js/webmail.js${v3x:resSuffix()}"></script>
<script type="text/javascript"  src="${path}/apps_res/sms/js/sms.js${v3x:resSuffix()}"></script>
<c:if test="${ctp:hasPlugin('collaboration')}">
<script type="text/javascript" src="${path}/apps_res/collaboration/js/CollaborationApi.js${v3x:resSuffix()}"></script>
</c:if>
<title>layout</title> 
<style>
    <c:choose>
        <c:when test="${fromPortal != '1'}">
            .stadic_head_height{
                height:60px;
            }
            .stadic_body_top_bottom{
                bottom: 0px;
                top:60px;
            }
        </c:when>
        <c:otherwise>
            .stadic_head_height {
                height: 0px;
            }
            .stadic_body_top_bottom {
                bottom: 0px;
                top: 0px;
            }
        </c:otherwise>
    </c:choose>
</style>
<script type="text/javascript" src="${url_ajax_collCubeManager}"></script>

<script type="text/javascript"> 
var cardMini;
var json;
var items;
//当前人员有全查看其协同立方的人员（在点击查询人员或点击人员关系指数框时赋值）
var authMember;
//当前登录人员
var centerUserId = $.ctx.CurrentUser.id;
var obj;
var queryDialog;
function passThroughCollCube(userId1,userId2,dateType,event_type){
	var title="${ctp:i18n('colCube.auth.passThrough.list')}";
	var url_=_ctxPath +"/colCube/colCube.do?method=queryCollCubeDetailList&user_Id1="+userId1+"&user_Id2="+userId2+"&dateType="+dateType+"&event_type="+event_type;
	getA8Top().up = window;
	queryDialog = $.dialog({
          id : 'url',
          url : url_,
          width : $(getCtpTop().document).width()-100,
          height : $(getCtpTop().document).height()-100,
          title : title,
          targetWindow : getCtpTop(),
          transParams: {
        	pwindow : window,
			closeAndForwordToCol: throughListForwardCol
          },
          closeParam:{ 
                'show':true, 
                autoClose:false, 
                handler:function(){ 
                   queryDialog.close();
                } 
            }, 
            buttons: [{ 
                text: "${ctp:i18n('common.button.close.label')}", 
                handler: function () { 
                	queryDialog.close();
                } 
            }] 
      });
}

    //穿透列表转发协同 --xiangfan
  function throughListForwardCol(content, reportTitle){
	 if(queryDialog) { queryDialog.close();}
	 var colParam = 
     {
			 subject : reportTitle,
    		 bodyContent : content
     };
     collaborationApi.newColl(colParam);
	 
     /* $("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
     $('#reportContent').val(content);
     $('#reportTitle').val(reportTitle);
	 $("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
	 $("#queryConditionForm").submit(); */
  }
  
function clicks(id,w) { //单击相关人员触发的事件
	//获取客户端页面宽高  
	var _client_width = document.body.clientWidth;
	var _client_height = document.body.clientHeight;
   var zoom= $("#cube")[0].style.zoom != "" ? $("#cube")[0].style.zoom:1;
   if ($.browser.mozilla){
        zoom = 1;
   		if(undefined != $("#cube").attr("zoomAttr")){
        	zoom= $("#cube").attr("zoomAttr") != "" ? $("#cube").attr("zoomAttr"):1;
   		}
   }
   var obj = $("#" + id);
   var left = obj.offset().left; 
   if (!$.browser.mozilla && !$.browser.msie){
	  left = (obj.offset().left +w)*zoom;
   }

   var top = obj.offset().top-30;
   var contentW= $("#relative_content").width();  
   var contentH=$("#relative_content").outerHeight(true);
   //left=left+ contentW < _client_width ? left : left - contentW;
   left=left+w*zoom-contentW<0?left:left+w*zoom- contentW;
   top=top+30+ contentH < _client_height ? top :_client_height-contentH-35;
   $("#relation_mark").text(json[id].total);
   if(json[id].collaboration!=0){
   	$("#collaboration").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'1')>"+json[id].collaboration+"</a>");
   }else{
   	$("#collaboration").text(json[id].collaboration);
   }
   if(json[id].officeDoc!=0){
   	$("#officeDoc").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'2')>"+json[id].officeDoc+"</a>");
   }else{
   	$("#officeDoc").text(json[id].officeDoc);
   }
   if(json[id].plan!=0){
   	$("#plan").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'3')>"+json[id].plan+"</a>");
   }else{
  	 $("#plan").text(json[id].plan);
   }
   if(json[id].meeting!=0){
   	$("#meeting").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'4')>"+json[id].meeting+"</a>");
   }else{
  	 $("#meeting").text(json[id].meeting);
   }
   if(json[id].task!=0){
   	$("#ztask").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'5')>"+json[id].task+"</a>");
   }else{
   	$("#ztask").text(json[id].task);
   }
   if(json[id].knowledge!=0){
   	$("#knowledge").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'6')>"+json[id].knowledge+"</a>");
   }else{
   	$("#knowledge").text(json[id].knowledge);
   }
   if(json[id].cultural!=0){
   	$("#cultural").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'7')>"+json[id].cultural+"</a>");
   }else{
   	$("#cultural").text(json[id].cultural);
   }
   if(json[id].event!=0){
   	$("#event").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'8')>"+json[id].event+"</a>");
   }else{
   	$("#event").text(json[id].event);
   }
   if(json[id].agent!=0){
   	$("#agent").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'9')>"+json[id].agent+"</a>");
   }else{
   	$("#agent").text(json[id].agent);
   }
   if(json[id].project!=0){
   	$("#project").html("<a onClick=passThroughCollCube('"+json[id].userId1+"','"+json[id].userId2+"',"+json[id].dateType+",'10')>"+json[id].project+"</a>");
   }else{
   	$("#project").text(json[id].project);
   }
   // 添加对协同立方和360的授权判断和链接
   $("#cube_360").css("display", "none");
   var manager = new collCubeManager();
   manager.checkAuthByMember(json[id].userId2,authMember,{success:function(returnValue){
       if(returnValue){
           $("#cube_360").css("display", "block");
           $("#cube_mini").click(function(){
             if('1' == '${ctp:toHTML(fromPortal)}'){//来自portal从portal跳转到360
               getCtpTop().$("#main").attr("src",url_colCube_colCube + "&userId="+json[id].userId2+"&fromPortal=2");
             }else{
               window.location = url_colCube_colCube + "&userId="+json[id].userId2+"&fromPortal=${ctp:toHTML(fromPortal)}";
             }
           });
           $("#360_mini").css("display", "none");
       }
   }});
    if($.isNull(json[id].emailAddress)){
    	$("#sendemail").hide();
    }else{
    	if(!$.ctx.resources.contains("F12_mailcreate")){
				$("#sendemail").hide();
		}else{
			$("#sendemail").show();
		}
    }
   	//---人员卡片start---
   	//发邮件
   	$("#sendemail").off("click").on("click",function() {
		sendMail(json[id].emailAddress);
	});
   	//发协同
	$("#sendcollaboration").unbind("click").click(function() {
		//appToColl4DialogMode('peopleCard', json[id].userId2);
		var colParam = 
	       {
				from : 'peopleCard',
				personId: json[id].userId2
	       };
	    collaborationApi.newColl(colParam);
	});
   	//发消息
   	if(getA8Top().getUCStatus||getA8Top().v3x.getParentWindow().getA8Top().getUCStatus){
		$("#sendmsg").off("click").on("click",function() {
			var message = getA8Top().getUCStatus!=undefined?getA8Top().getUCStatus():getA8Top().v3x.getParentWindow().getA8Top().getUCStatus();
			if (message != '') {
				$.alert(message);
			} else {
				getA8Top().sendUCMessage(json[id].userName2, json[id].userId2);
			}
		});
   	}else{
   		$("#sendmsg").hide();
   	}
   	//发短信
	$("#sendSMS").unbind("click").click(function() {
		sendSMS(json[id].userId2);
	});
   	
	if(centerUserId == json[id].userId2){
		$("#peopleCardUl").hide();
	}else{
		$("#peopleCardUl").show();
	}
   //---人员卡片end---
   $("#relative_content").css({"left":left,"top":top}).show();
}
function hidden(){
    $("#relative_content").hide();
}
function mouseOut(id,w) {
    var obj=$("#relative_content");
    var minLeft=obj.offset().left-w;
    var minTop = obj.offset().top;
    var maxTop = obj.offset().top+obj.height();
    var maxLeft = minLeft+w+obj.width() ;
    
    var maxLeft1 = $("#"+id).offset().left+w+$("#relative_content").width()
    var maxTop1 = obj.offset().top+$("#relative_content").height();
    
    if((maxLeft + obj.width()) > $("#layout").width()){
    	minLeft = obj.offset().left;
    	maxLeft = minLeft + obj.width();
    }
    if((maxTop + obj.height())> $("#layout").height()){
    	minTop = obj.offset().top;
    	maxTop = minTop +obj.height();
    }
    ifClose(minLeft,maxLeft,minTop,maxTop,hidden);
}
/* 
 * 中间的图标没有点击事件
function goColAllRound(id) {
    //点击中心头像
     if('1' == '${ctp:toHTML(fromPortal)}'){//来自portal从portal跳转到360
      getCtpTop().$("#main").attr("src", url_colCube_colAllRound+"&userId=${userId}&fromPortal=${ctp:toHTML(fromPortal)}");
    }else{
      window.location = url_colCube_colAllRound+"&userId=${userId}&fromPortal=${ctp:toHTML(fromPortal)}";
    } 
}
 */
/**
 *协同V5.0 OA-24129
 * 判断哪些插件在使用，只显示使用的插件
 */
function initPluginEnable(){
  cubeIndexSet = ${cubeIndexSet};
  for(var i=0;i<cubeIndexSet.length;i++){
  	$("#"+cubeIndexSet[i].item).parent("li").show();
  }
  var h1 = 66;
  if ($.browser.mozilla){
  	h1 = 72;
  }
  $("#relative_content").css({"height":Math.ceil(cubeIndexSet.length/2)*22+h1+"px"});
  
  /*
  if(!$.ctx.plugins.contains('collaboration')){
    $("#collaboration").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('edoc')){
    $("#officeDoc").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('plan')){
    $("#plan").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('meeting')){
    $("#meeting").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('agent')){
    $("#agent").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('project')){
    $("#project").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('taskmanage')){
    $("#ztask").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('doc')){
    $("#knowledge").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('calendar')){
    $("#event").parent("li").hide();
  }
  if(!$.ctx.plugins.contains('bbs') && !$.ctx.plugins.contains('news') && !$.ctx.plugins.contains('inquiry') && !$.ctx.plugins.contains('bulletin')){
    $("#cultural").parent("li").hide();
  }  */
  
  	//人员卡片 图标显示控制
 	if(!$.ctx.resources.contains("F01_newColl")){
		$("#sendcollaboration").hide();
  	}
	if(!$.ctx.CurrentUser.canSendSMS){
		$("#sendSMS").hide();
	}
	if($.ctx.CurrentUser.admin||!$.ctx.plugins.contains('uc')){
		$("#sendmsg").hide();
	}
}
/**
 * 过滤掉积分为0的人员
 */
function filterScoreZero(viewList){
	var result=new Array();
	for(var i=0;i<viewList.length;i++){
		if(viewList[i].total!=0){
			result.push(viewList[i]);
		}
	}
	return result;
}
var peopleSquare;
$(function(){
    initPluginEnable();

    try{
        json = filterScoreZero((new Function("return " +'${cubeViewList}'))());
    }catch(e){
        //alert(e);
    }
    authMember = ${authMember};
    if(authMember != null && authMember.length > 0){
       new inputChange($("#choosePerson"), "${ctp:i18n('colCube.auth.query.colCube')}");
       if(centerUserId != "${centerUserId}"){
           $("#choosePerson").attr("userId","${centerUserId}");
           $("#choosePerson").val("${centerUserName}");
       }
    }else{
      $("#choosePerson,#choosePerson + span").css("display", "none");
    }
    items = new Object();
    var stepIndex = 0;
    var space = 10;
    var curSpaceIndex = 10;
    if(json!=undefined){
        items['step1'] = new Array();
        items['step2'] = new Array();
        for(var i = 0; i < json.length; i++){        
            if(i < space){
                stepIndex = 1;
            }else{
                stepIndex = 2;
            }
            if(curSpaceIndex==10){
                curSpaceIndex=1;
            }else{
                curSpaceIndex++;
            }
            items['step'+stepIndex][curSpaceIndex-1] = new Object()
            items['step'+stepIndex][curSpaceIndex-1].id = i;
            items['step'+stepIndex][curSpaceIndex-1].src = json[i].ico4Display;
            items['step'+stepIndex][curSpaceIndex-1].name = json[i].relativeUserName;
            items['step'+stepIndex][curSpaceIndex-1].total = json[i].total;
           // var relativeUserId = json[i].userId1 == centerUserId ? json[i].userId2 : json[i].userId1;
            items['step'+stepIndex][curSpaceIndex-1].relativeUserId = json[i].userId2; 
        }
    }
   
    peopleSquare = new MxtPeopleSquare({
        id: 'canvasDiv2',
        width:541,
        height:542,
        imgH:54,
        imgW:54,
        squareR:180,
        squareStep:10,
        sliderMax: 41,
        parentId: "cube",
        mouseOver: clicks,
        mouseOut:mouseOut,
        defaultPeople:{
            defaultName:'${centerUserName}',
            defaultSrc:'${centerUserIco}',
            click:function(id){}//goColAllRound
        },
        sliderHandle:function(step){
            $('#sssss').val(step);
        },
        peopleItems:items
    });   
    if("${statNum}" != "" && "${statNum}" == "20"){
      peopleSquare.squareR=210;
      peopleSquare.imgH=34;
      peopleSquare.imgW=34;
      peopleSquare.setAnimate("step2");           
      peopleSquare.updateItems("step1",523,523,130,34,34);
      $("#tewnty").attr("checked", "checked");
    }
    $("#dateType").val(${dateType});
    //OA-52166.协同立方栏目条件中设置人数为20人，修改统计时间后人数变成了10人.
    var numberId="${ctp:toHTML(numberId)}";
    if(!$.isNull(numberId)&&"1"==="${ctp:toHTML(fromPortal)}"){
    	$("#"+numberId+"").attr("checked",true);
    }
    
      //指标说明
	  $('#introOfIndex').click(function(){
		    var dialog = $.dialog({
		        id : 'dialogintroOfIndex',
		        url : url_colCube_IntroOfColCube,
		        width : 920,
		        height : 450,
		        targetWindow:getCtpTop(),
		        title : "${ctp:i18n('performanceReport.queryMain_js.help.title')}",
		        buttons : [{
		          text : "${ctp:i18n('colCube.indexSetup.href.return')}",
		          handler : function() {
		            dialog.close();
		          }
		        } ]
		      });
	  });
      if($.browser.chrome||$.browser.mozilla){
    	  $("#peopleCardUl").removeClass("margin_t_5");
      }
      $("#peopleCardUl li").css("margin-top","3px");
});
</script>
<script>
$(function () {
    var dr = $.dropdown({
        id: 'type'
    });
    initButton();
});
$(document).ready(function(){
	var zoom= $("#cube")[0].style.zoom != "" ? $("#cube")[0].style.zoom:1;
	zoom=Math.round(zoom*10)/10;
	$(".canvasName,.myName,.canvasName span.font_size14").css({"font-size":15/zoom + "px","height":"auto","width":"80px","overflow":"hidden","text-overflow":"ellipsis","white-space":"nowrap"});
	$(".canvasName span").not(".font_size14").css({"font-size":22/zoom + "px","height":"auto"});
	$("#relative_content").css("height","190px");
})
//初始化按钮事件
function initButton(){
    //20人
    $("#tewnty").click(function(){
        peopleSquare.squareR=210;
        peopleSquare.imgH=34;
        peopleSquare.imgW=34;
        peopleSquare.setAnimate("step2");           
        peopleSquare.updateItems("step1",523,523,130,34,34);
    });
    //10人
    $("#ten").click(function(){            
        peopleSquare.imgH=54;
        peopleSquare.imgW=54;
        peopleSquare.setAnimate("step1");
        peopleSquare.updateItems("step1",541,542,180);
    });
    //选择人员
    $("#choosePerson").click(function(){
             $.selectPeople({
               showRecent : false,
               type : 'selectPeople',
               panels: 'Department,Team,Post,Level,Outworker',
               selectType: 'Member',
               maxSize : 1,
               includeElements : parseElements(authMember.join(",")),
               callback : function(ret) {
                   var userId = ret.value;
                   userId = userId.substring(userId.indexOf("|") + 1);
                   $("#choosePerson").val(ret.text);
                   $("#choosePerson").attr("userId",userId);
               }
             }); 
     });
    $("#backToCenter").click(function(){
        window.location = url_colCube_colCube_currentUser+"&fromPortal=${ctp:toHTML(fromPortal)}";        
    }); 
    $("#dateType").change(function(){
    	var numberId=$(":input[name='number'][checked]").attr('id');
        window.location = url_colCube_colCube + "&userId=${centerUserId}&numberId="+numberId+"&dateType=" + $("#dateType").val()+"&fromPortal=${ctp:toHTML(fromPortal)}";
    });
}
//搜索人员查询按钮事件
function searchPerson(){
    var manager_ = new collCubeManager();
    var userId = $("#choosePerson").attr("userId");
    if(!$.isNull(userId)){
      var v = manager_.getSecurityDigest4UserId(userId);
      window.location = url_colCube_colCube + "&userId=" + userId+"&fromPortal=${ctp:toHTML(fromPortal)}";
    }
}
</script>
</head>
<body class="h100b page_color">
	<form action="#" id="queryConditionForm"  style="margin:0;padding:0;" method="post" target="main">
	</form>
    <c:if test="${fromPortal != '1' or fromPortal=='2'}"><%-- 首页portal隐藏 --%>
      <div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_systemreport',suffix:'${userName}${ctp:i18n('colCube.auth.show.colCube')}'"></div>
    </c:if>
      <div class="absolute" style="right:10px;z-index:2;">  
               <c:if test="${fromPortal != '1' }"><%-- 首页portal隐藏 --%>
               <input id="choosePerson" name="name" class="comp"  userId=""  type="text" comp="type:'search',title:'${ctp:i18n('colCube.list.detail.choosePerson')}',fun:'searchPerson'">  
               </c:if>
               <span class="display_inline-block w100 align_left margin_r_5">
                    <select id="dateType" class="w100">
                        <option value="4">${ctp:i18n('colCube.common.dateSelect.month')}</option>
                        <option value="5">${ctp:i18n('colCube.common.dateSelect.season')}</option>
                        <option value="7">${ctp:i18n('colCube.common.dateSelect.year')}</option>
                        <option value="8">${ctp:i18n('colCube.common.dateSelect.all')}</option>
                    </select> 
                </span>
                <c:if test="${fromPortal != '1'}"><%-- 首页portal隐藏 --%>
                <span title="${ctp:i18n('colCube.common.button.goMyColCube')}">             
                	<a class="btn_img" href="javascript:void(0)" id="backToCenter"><em class="ico16  back_synergy_360"></em></a>
       			</span>
       			<span>
       			<a class="btn_img margin_r_5" href="javascript:void(0)" id="introOfIndex" title="${ctp:i18n('performanceReport.queryMain_js.help.title')}"><em class="ico16 help_16"></em></a>
       			</span>
       			</c:if>
       </div>
    
    <div id='layout' class="comp" comp="type:'layout'">
            <div class="layout_north" layout="height:25,sprit:false,border:false" style="overflow:visible;">
                <div class="common_radio_box clearfix margin_t_5 margin_l_5">
                        <label class="margin_r_10 hand" for="ten">
                            <input id="ten" class="radio_com" checked="checked" name="number" value="0" type="radio">10${ctp:i18n('colCube.colCube.unit.people')}</label>
                        <label class="margin_r_10 hand" for="tewnty">
                            <input id="tewnty" class="radio_com" name="number" value="0" type="radio">20${ctp:i18n('colCube.colCube.unit.people')}</label>
					<%-- <a href="${path}/wfanalysis.do?method=overview" target="_blank">流程绩效页面</a>
					<a href="${path}/behavioranalysis.do?method=orgindex" target="_blank">组织行为绩效页面</a>
					<a href="${path}/behavioranalysis.do?method=personalindex" target="_blank">个人行为绩效页面</a> --%>
				</div>
            </div>
        
        <%-- 协同立方界面 --%>
        <div class="layout_center bg_color_white over_hidden" style="background:#cce4ff;" <c:if test="${fromPortal != '1'}">layout="border:true"</c:if>>
            <div class="absolute w100b h100b margin_0" id="cube">
                <div style="width:485px;">
                </div>
            </div>
            <%-- 人员卡片界面 --%>
            <div class="relative_detail border_all absolute font_size12 cardmini hidden" style="width: 310px;" id="relative_content" ><!--关系详情-->
                <p class="padding_5 cardmini" >
                	<label class="left margin_t_5" style="font-weight:bolder;font-size:10pt">${ctp:i18n('colCube.colCube.relationCode')}:<span id="relation_mark">0</span></label>
                	<label id="cube_360" class="right">
                		<a class="img-button " href="javascript:void(0)" id="cube_mini"><em class="ico16 back_synergy_360" style="margin-right:2px"></em>${ctp:i18n('colCube.common.crumbs.colCube')}</a>
                		<a class="img-button " href="javascript:void(0)" id="360_mini"><em class="ico16 synergy_360" style="margin-right:2px"></em>${ctp:i18n('colCube.common.crumbs.colAllRound')}</a>
                	</label>
                </p>
                <ul class="clearfix border_t margin_t_20">
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.collaboration')}：</label><span id="collaboration">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.officeDoc')}：</label><span id="officeDoc">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.agent')}：</label><span id="agent">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.meeting')}：</label><span id="meeting">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.project')}：</label><span id="project">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.plan')}：</label><span id="plan">0 </span></li>
                    <li class="w50b left" style="display: none;"><label style="margin-left: 24px">${ctp:i18n('colCube.common.list.ztask')}：</label><span id="task">0 </span></li>
                    <li class="w50b left" style="display: none;"><label>${ctp:i18n('colCube.common.list.event')}：</label><span id="event">0 </span></li>
                    <li class="w50b left" style="display: none;"><label><c:if test="${!isG6}">${ctp:i18n('colCube.common.list.knowledge')}：</c:if><c:if test="${isG6}">${ctp:i18n('colCube.common.list.knowledge.g6')}：</c:if></label><span id="knowledge">0 </span></li>
                    <li class="w50b left" style="display: none;"><label>${ctp:i18n('colCube.common.list.cultural')}：</label><span id="cultural">0 </span></li>
                </ul>
                <ul class="font_size12 align_center margin_t_5 card_operate border_t clear" id="peopleCardUl">
	        		<li class="left"><a class="img-button" id="sendcollaboration" href="javascript:void(0)"><em class="ico16 collaboration_16" style="margin-right:2px"></em>${ctp:i18n('people.send.collaborative')}</a></li>
	        		<li class="margin_t_5 left"><a class="img-button" id="sendmsg" href="javascript:void(0)"><em class="ico16 communication_16" style="margin-right:2px"></em>${ctp:i18n('people.send.msg')}</a></li>
	        		<li class="margin_t_5 left"><a class="img-button" id="sendemail" href="javascript:void(0)"><em class="ico16 email_16" style="margin-right:2px"></em>${ctp:i18n('people.send.email')}</a></li>
	    			<li class="margin_t_5 left"><a class="img-button" id="sendSMS" href="javascript:void(0)"><em class="ico16 info_16" style="margin-right:2px"></em>${ctp:i18n('people.send.SMS')}</a></li>
	    		</ul>
            </div>
        </div>
    </div>
    </body>
</html>

