<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>listhome</title>
</head>
<script type="text/javascript">
  var listType = "${listType}";
  $().ready(
      function() {
        var btns = new Array("myPlan", "othersPlan", "planSearch","planStatics");
        for ( var i = 0; i < btns.length; i++) {
          $("#" + btns[i]).bind('click', loadFrame);
        }
        
        if(listType=="otherPlan"){
        	$("#tab_iframe").attr("src", array["othersPlan"]);
        	$("#otherPlanTr").addClass("current");
        	$("#myPlanTr").removeClass("current");
        }else{
        	$("#tab_iframe").attr("src", array["myPlan"]);
        }
      });
  var array = new Array();
  array["myPlan"] = "plan.do?method=getPlanList&to=myplan&type="+'${simplePlan.type}';
  array["othersPlan"] = "plan.do?method=getPlanList&to=planmanage&type="+'${simplePlan.type}';
  array["planSearch"] = "../form/queryResult.do?method=queryIndex&formType=4";
  array["planStatics"] = "../report/queryReport.do?method=index&formType=4";
  var loadFrame = function() {
    currentTab = this.id;
    $("#tab_iframe").attr("src", array[currentTab]);
    if(currentTab=='planStatics'||currentTab=='planSearch'){
		$("#tabs_body").addClass("border_all");
    }else{
    	$("#tabs_body").removeClass("border_all");
    }
  };

  
</script>
<body class="h100b over_hidden">
    <div>
         <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F02_planListHome'"></div>
    </div>
    <div id='layout' class="comp page_color" comp="type:'layout'">
        <div class="layout_north" layout="height:32,sprit:false,border:false" id="north">
            <div id="tabs" class="comp page_color" comp="type:'tab'">
                <div id="tabs_head" class="common_tabs clearfix margin_t_5">
                    <ul class="left">
                        <li id="myPlanTr" class="current"><a id="myPlan"  hideFocus="true" href="javascript:void(0)" tgt="tab_iframe" class="no_b_border"><span>${ctp:i18n('plan.tab.myplan')}</span></a></li>
                        <li id="otherPlanTr"><a id="othersPlan" hideFocus="true" href="javascript:void(0)" tgt="tab_iframe" class="no_b_border"><span>${ctp:i18n('plan.tab.othersplan')}</span></a></li>
                        <c:if test="${isA6 == false}">
                            <li><a id="planSearch" hideFocus="true" href="javascript:void(0)" tgt="tab_iframe" class="no_b_border"><span>${ctp:i18n('plan.button.planquery')}</span></a></li>
                            <li><a id="planStatics" hideFocus="true" href="javascript:void(0)" class="last_tab no_b_border" tgt="tab_iframe"><span>${ctp:i18n('plan.button.planstatics')}</span></a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
        <div id="tabs_body" class="layout_center page_color over_hidden" layout="border:false" style="overflow:hidden;">
                <iframe id="tab_iframe" name="tab_iframe" border="0" src="" frameBorder="no" width="100%" height="100%"></iframe>
        </div>
    </div>
</body>
</html>