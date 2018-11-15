<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>${ctp:i18n("report.queryReport.tree.formReport")}</title>
<script>
  var item=0;//监督变量
  //初始JS
  $(document).ready(function() {
    initClickEvent();
    addButtonEvent();
    initPageDisplay();
    initChart();
  });
  
  function initChart(){
	  $("#selctChart").hide();
	  if($("#selctChart option").length>0){
		  $("#chartLi").show();
	  }else{
		  $("#chartLi").hide();
	  }
  }

    function initPageDisplay(){
           $("#searchResultDiv").show();
           search();
     }
  
  function initClickEvent() {
    //点击表格事件
    $("#gridLi").click(function() {
      item=0;
      //图切换到表需要重新统计
      $("#chartLi").removeClass("current");
      $("#gridLi").addClass("current");
      $("#content").contents().find("#chartDiv").addClass("hidden");
      $("#content").contents().find("#gridDiv").empty();
      $("#content").contents().find("#gridDiv").removeClass("hidden");
      $("#selctChart").hide();
      search();
    });
    //点击图表事件
    $("#chartLi").click(function() {
        item=1;
      $("#gridLi").removeClass("current");
      $("#chartLi").addClass("current");
      $("#selctChart").show();
      $("#content").contents().find("#gridDiv").addClass("hidden");
      $("#content").contents().find("#chartDiv").removeClass("hidden");
      if(window.frames["content"].drawingDefualt){
      	window.frames["content"].drawingDefualt();
      }
    });
  }

  function search(){
        var url = "${url_queryReport_showReportGrid}&reportId=${reportId}&fromPortal=2&formType=1&formMasterId=${formMasterId}&source=data_content";
        //以表单的方式提交统计条件
        //url=encodeURI(url);
        $("#contentForm").attr("action",url);
        $("#contentForm").submit();
        $("#searchResultDiv").show();
        addButtonEvent();
}

function removeChart(){
  try{
    //协同V5.0 OA-31215 在窗口关闭前后清除图表数据，以防止flash_removeCallback错误
    $("#drawingArea").empty();  
  }catch(e){}
}

    function addButtonEvent() {
        $("#selctChart").removeAttr("disabled");
        $("#selctChart").unbind("click");
        //选择图表 下拉框事件
        $("#selctChart").unbind("click").bind("change").change(function(){
           var val= $(this).val();
           if(val!="null")
           {
               var values=val.split("=");//获得表单值 values[0] 表单名称values[1]
               window.frames["content"].imgnumber=parseInt(values[0]);
               if(window.frames["content"].drawingDefualt){
               	window.frames["content"].drawingDefualt(); //绘图
               }
           }else{
               $("#myimages").html("${ctp:i18n('report.queryReport.index_right.statResult.chart')}");
           }
        });
    }
</script>

</head>
<body class="h100b page_color" onunload="removeChart()">
        <div class="stadic_layout w100b h100b hidden" style="margin-top:10px;" id="searchResultDiv">
        	<div id="gridOrChart" class="common_toolbar_box">
	            <div class="common_tabs clearfix stadic_layout_head stadic_head_height">
	                <span class="left margin_b_10">
	                    <li id="gridLi" class="current"><a hideFocus style="WIDTH: auto" class="last_tab" href="javascript:void(0)">
	                    	${ctp:i18n('report.queryReport.index_right.statResult.grid')}</a></li><!-- 表格 -->
	                    <li id="chartLi"><a hideFocus  class="last_tab" href="javascript:void(0)"><span id="myimages">
	                    	${ctp:i18n('report.queryReport.index_right.statResult.chart')}</span></a></li><!-- 图表 -->
	                	<li>&nbsp&nbsp&nbsp&nbsp</li>
	                	<select id="selctChart">
			               <c:forEach items="${charts }" var="chart" varStatus="status">
			                    <option value="${status.count-1}=${chart.name }"}">${chart.name }</option>
			               </c:forEach>
			            </select>
	                </span>
	            </div>
        	</div>
            <div id="result" class="align_center border_t common_tabs_body stadic_layout_body stadic_body_top_bottom" style="top:28px;bottom:0px; background:#fff;">
	            <div id="gridDiv" class="absolute h100b" width="100%" height="96%" style="top:0px;bottom:0px;left:0;right:0;background:#fff;">
	                <iframe id="content" name="content" frameborder="0" src="" width="100%" height="96%"  ></iframe>
	                <form id="contentForm" style="display:none" enctype="multipart/form-data" method="post" target="content">
	                	<input id="stateCon" name="stateCon" value="${fn:escapeXml(stateCon)}">
	                	<c:if test="${hasUserInput == true}">
	                	<input id="userFastCon" name="userFastCon" value="[]">
	                	</c:if>
	                </form>
	            </div>
        	</div>
        </div>
</body>
</html>
