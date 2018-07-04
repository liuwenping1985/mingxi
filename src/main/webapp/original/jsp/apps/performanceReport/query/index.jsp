<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryCommon.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="${path}/common/skin/default/skin.css">
<script type="text/javascript" src="${url_ajax_reportingManager}"></script>
<title>${ctp:i18n('performanceReport.selector.dir.systemdata')}</title>
  <script type="text/javascript">
  var reportId = '${reportId}';
 
  $(document).ready(function() {
    //加载左边表单树菜单
    loadReportTree();
    var productId="${ctp:getSystemProperty('system.ProductId')}";
    var treeObj = $.fn.zTree.getZTreeObj("leftTree");
    treeObj.expandAll(true);
    if(reportId != ''){
    		var selectReportId = reportId;
    		if(selectReportId == '7728786349204325388'){
    			selectReportId = '8187033991580765988';
    		}else if(selectReportId == '-3648914008719078167'){
    			selectReportId = '3569160983850797390';
    		}else if(selectReportId == '-2118631663956308322'){
    			selectReportId = '516519058127931295';
    		}
    		treeObj.selectNode(treeObj.getNodeByParam('id',selectReportId));
    		loadDefualtReport(reportId);
    }else{
    	if("3"===productId||"4"===productId){
    		treeObj.selectNode(treeObj.getNodes()[0].children[0]);
    		loadDefualtReport(treeObj.getNodes()[0].children[0].id);
    	}else{
    		//默认选择
    		treeObj.selectNode(treeObj.getNodes()[0].children[0]);
    		loadDefualtReport(treeObj.getNodes()[0].children[0].id);
    	}
    }
  });
  
  function loadReportTree() {
    $("#leftTree").tree({
      idKey : "id",
      pIdKey : "parentId",
      nameKey : "name",
      isParent : "isParent",
      onClick : nodeClick,
      nodeHandler : function(n) {
      	n.open = true;
      	n.isParent = n.data.parent;
      }
    });
  }
  
  function nodeClick(e, treeId, node){
    if(!node.isParent){
    	if("88888888" == node.data.id){
    		//协同立方
    		$("#rightFrame").attr("src","${path}/colCube/colCube.do?method=goColCube"); 
    	}else{
    		//其他三个
	      showDetail(node.data.id,node.data.parentId);
    	}
    }
  }
    
  
 function showDetail(reportId,parentId){
  var array = "${source}".split('|');
	if(array.length>0){
		 $("#rightFrame").attr("src","${path}"+array[0]+"&reportId="+reportId+"&parentId="+parentId); 
	}
	if(array.length==2){
		$("#resultFrame").attr("src","${path}"+array[1]+"&reportId="+reportId);  
	}
 }
  //layout布局问题：layout布局里嵌套的iframe页面又采用了layout布局的时候 ，需要在父页面加载完后，再给iframe赋src值，否则，iframe页面里的layout布局计算的宽度和高度都为0
 function loadDefualtReport(reportId){
  	var url="${path}/performanceReport/performanceQuery.do?method=queryMain&reportId="+reportId+"&isMore=${isMore}&personGroupTab=${personGroupTab}&tableChartTab=${tableChartTab}&params="+encodeURI("${params}");
  	$("#rightFrame").attr("src",url); 
 }
$(function(){
	if(${ctp:getSystemProperty('system.ProductId')}=="0"||${ctp:getSystemProperty('system.ProductId')}=="7"||${ctp:getSystemProperty('system.ProductId')}=="12"){
    	var html = "<span class='margin_r_10'>${ctp:i18n('seeyon.top.nowLocation.label')}</span>";
    	var items = [];
     	 items.push("<a class=\"hand\" onclick=\"showMenu('"+_ctxPath+"/performanceReport/performanceQuery.do?method=queryIndex&reportId=1024992466047550297')\">${ctp:i18n('system.menuname.WorkStatistics')}</a>");
   	 	html += items.join('<span class="common_crumbs_next margin_lr_5">-</span>');
        getCtpTop().showLocation(html);
	}
});
  </script>
</head>
<body class="h100b over_hidden page_color">
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_systemreport'"></div>
        <div class="layout_west" layout="border:false">
        	<div class="tree_area padding_t_10" style="overflow:visible;">
        		<ul id="leftTree" class="treeDemo_0 ztree"></ul>
        	</div>
        </div>
        <div class="layout_center page_color over_hidden" layout="border:false">
	       <iframe  width="100%" id="rightFrame" height="100%" frameborder="0"></iframe> 
        </div> 
    </div> 
</body>
</html>

