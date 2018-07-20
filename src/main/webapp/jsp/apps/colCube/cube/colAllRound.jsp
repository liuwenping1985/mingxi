<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/apps/colCube/common.jsp" %>
<%@ include file="/WEB-INF/jsp/apps/report/chart/chart_common.jsp"%>
<script type="text/javascript" src="${path}/common/js/V3X.js"></script>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${url_ajax_collCubeManager}"></script>
<title>layout</title>
<c:choose>
<c:when test="${fromPortal != '1'}">
<style>
.stadic_head_height {
    height: 26px;
}
.stadic_body_top_bottom {
    bottom: 0px;
    top: 26px;
}
</style>
</c:when>
<c:otherwise>
<style>
.stadic_head_height {
    height: 20px;
}
.stadic_body_top_bottom {
    bottom: 0px;
    top: 20px;
}
</style>
</c:otherwise>
</c:choose>

<script type="text/javascript">
	var queryDialog;
	//当前登录人员
	var centerUserId = $.ctx.CurrentUser.id;
	var version = "${ctp:getSystemProperty('system.ProductId')}";
  $(document).ready(function() {
  	var productId="${ctp:getSystemProperty('system.ProductId')}";
    $("#goColCube").click(function() {
    	if(version=="3"||version=="4"){
    		window.location = url_colCube_G6_colAllRound+"&fromPortal=${ctp:toHTML(fromPortal)}";
    	}else{
      		window.location = url_colCube_colCube_currentUser+"&fromPortal=${ctp:toHTML(fromPortal)}";
      	}
    });
    if(version=="3"||version=="4"){
    	$("#goBackColCubeOr360").attr("title","${ctp:i18n('colCube.common.button.goMy360Cube')}");
    }else{
    	$("#goBackColCubeOr360").attr("title","${ctp:i18n('colCube.common.button.goMyColCube')}")
    }
    var chart1 = new SeeyonChart({
      htmlId : "chart",
      width : "100%",
      heigth : "100%",
      xmlData : "${chartXML}",
      event : [{
        name : "pointClick",
        func : function(e){
        	if(e.data.Series.Name=="${ctp:i18n('colCube.chart.myWork')}"){
        		//个人协同360
          		chartDrillDown(e);
          	}
        }
      }]
    });
    function chartDrillDown(e){
    	var title="${ctp:i18n('colCube.auth.passThrough.360list')}";
    	var dateType="${dateType}";
    	var user_Id="${userId}";
    	getA8Top().up = window;
		var url_=_ctxPath +"/colCube/colCube.do?method=queryColl360DetailList&user_Id="+user_Id+"&dateType="+dateType+"&event_type="+encodeURI(e.data.Name);
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
	
    $("#dateTypeSelect").val($("#dateType").val());
    
    $("#dateTypeSelect").change(function(){
      window.location = url_colCube_colAllRound + "&userId=${userId}&v=${ctp:digest_1(userId)}&dateTypeSelect="+$("#dateTypeSelect").val()+"&fromPortal=${ctp:toHTML(fromPortal)}";
    });
    
	//指标说明
	  $('#introOfIndex').click(function(){
		    var dialog = $.dialog({
		        id : 'dialogintroOfIndex',
		        url : url_colCube_IntroOfColAllRound,
		        width : 510,
		        height : 380,
		        maxParam :{'show':true},
		        minParam :{'show':true},
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
    
    
    var authMember = ${authMember};
    if(authMember != null && authMember.length > 0){
       new inputChange($("#choosePerson"), "${ctp:i18n('colCube.auth.query.col360')}");
       if(centerUserId != "${userId}"){
           $("#choosePerson").attr("userId","${userId}");
           $("#choosePerson").val("${centerUserName}");
       }
    }else{
      $("#choosePerson,#choosePerson + span").css("display", "none");
    }
    
    $("#choosePerson").click(function(){
             $.selectPeople({
               showRecent : false,
               type : 'selectPeople',
               panels: 'Department,Team,Post,Level,Outworker',
               selectType: 'Member',
               maxSize : 1,
               includeElements : parseElements(${authMember}.join(",")),
               callback : function(ret) {
                   var userId = ret.value;
                   userId = userId.substring(userId.indexOf("|") + 1);
                   $("#choosePerson").val(ret.text);
                   $("#choosePerson").attr("userId",userId);
               }
             }); 
     });
     
  });
  
  //查看他人
  var manager_ = new collCubeManager();
  function searchPerson(){
    var userId = $("#choosePerson").attr("userId");
    if(!$.isNull(userId)){
      var v = manager_.getSecurityDigest4UserId(userId);
      window.location = url_colCube_colAllRound + "&userId=" + userId+"&v="+v+"&dateType="+$("#dateType").val()+"&fromPortal=${ctp:toHTML(fromPortal)}";
    }
  }
     //穿透列表转发协同 --xiangfan
  	function throughListForwardCol(content, reportTitle){
	 	 	if(queryDialog)
	 	queryDialog.close();
     	$("#queryConditionForm").append("<input type='hidden' id='reportContent' name='reportContent' /><input type='hidden' id='reportTitle' name='reportTitle' />");
     	$('#reportContent').val(content);
     	$('#reportTitle').val(reportTitle);
		$("#queryConditionForm").attr("action", "${path}/performanceReport/performanceQuery.do?method=reportForwardCol");
	 	$("#queryConditionForm").submit();
  	}
</script>
</head>
<body class="h100b over_hidden bg_color_none" id="body">
    <input type="hidden" id="userId" value="${userId}">
    <input type="hidden" id="dateType" value="${dateType}">
    <form action="#" id="queryConditionForm"  style="margin:0;padding:0;" method="post" target="main">
	</form>
    <div class="stadic_layout">
        <!-- 顶部 -->
        <div class="stadic_layout_head stadic_head_height">
<!--         首页portal隐藏面包屑 -->
        <c:if test="${fromPortal != '1'}">
            <div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_colCube',suffix:'${userName}${ctp:i18n('colCube.auth.show.col360')}'"></div>
            <div class="hr_heng"></div>
       	</c:if>
            <div id="searchDiv" class="absolute" style="top:2px; right:10px;z-index:2;">
            	<c:if test="${fromPortal != '1'}">
            	<input id="choosePerson" name="name" class="comp" style="height:18px" userId=""  type="text" comp="type:'search',title:'搜索人员',fun:'searchPerson'">  
                </c:if>
                <span class="display_inline-block w100 align_left margin_r_5" style="vertical-align:middle;"> 
                <select id="dateTypeSelect" class="w100">
                        <option value="1">${ctp:i18n('colCube.common.dateSelect.today')}</option>
                        <option value="2">${ctp:i18n('colCube.common.dateSelect.week')}</option>
                        <option value="4">${ctp:i18n('colCube.common.dateSelect.month')}</option>
                        <option value="7">${ctp:i18n('colCube.common.dateSelect.year')}</option>
                        <option value="8">${ctp:i18n('colCube.common.dateSelect.all')}</option>
                </select>
                </span>
                <c:if test="${fromPortal != '1'}">
                <span title="${ctp:i18n('colCube.common.button.goMyColCube')}" id="goBackColCubeOr360"> 
                    <a class="btn_img" href="javascript:void(0)" id="goColCube"><em class="ico16  back_synergy_360"></em></a>
            	</span>
            	<span>
       			<a class="btn_img margin_r_5" href="javascript:void(0)" id="introOfIndex" title="${ctp:i18n('performanceReport.queryMain_js.help.title')}"><em class="ico16 help_16"></em></a>
       			</span>
       			</c:if>
            </div>
        </div>
        <!-- 中部 -->
        <div class="stadic_layout_body stadic_body_top_bottom <c:if test='${fromPortal != 1}'>border_t</c:if> center"  style="overflow:hidden;">
            <div id="chart" class="h100b"></div>
        </div>
    </div>
</body>
</html>

