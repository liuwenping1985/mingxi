<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('performanceReport.common.crumbs.performReportSet')}</title>
<script>
  
  $(document).ready(function() {
    //加载左边表单树菜单
    loadReportTree();
    var productId="${ctp:getSystemProperty('system.ProductId')}";
    var treeObj = $.fn.zTree.getZTreeObj("leftTree");
    treeObj.expandAll(true);
    if("1" == "${type}"){
    	if("3"===productId||"4"===productId){
    		treeObj.selectNode(treeObj.getNodes()[0].children[0]);
    	}else{
    		treeObj.selectNode(treeObj.getNodes()[0].children[0].children[0]);
    	}
    }else if("2" == "${type}"){
    	if(window.parent.window.reportId != ''){
    		var selectReportId = window.parent.reportId;
    		if(selectReportId == '7728786349204325388'){
    			selectReportId = '8187033991580765988';
    		}else if(selectReportId == '-3648914008719078167'){
    			selectReportId = '3569160983850797390';
    		}else if(selectReportId == '-2118631663956308322'){
    			selectReportId = '516519058127931295';
    		}
    		treeObj.selectNode(treeObj.getNodeByParam('id',selectReportId));
    		window.parent.window.loadDefualtReport(window.parent.reportId);
    	}else{
    		if("3"===productId||"4"===productId){
    			treeObj.selectNode(treeObj.getNodes()[0].children[0]);
    			window.parent.window.loadDefualtReport(treeObj.getNodes()[0].children[0].id);
    		}else{
    			treeObj.selectNode(treeObj.getNodes()[0].children[0].children[0]);
    			window.parent.window.loadDefualtReport(treeObj.getNodes()[0].children[0].children[0].id);
    		}
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
      showDetail(node.data.id,node.data.parentId);
    }
  }
    
  
  function showDetail(reportId,parentId){
	  var array = "${source}".split('|');
	  var type = "${type}";
	  if("1" == type){
		  $("#rightFrame",parent.document).attr("src","${path}"+"${source}"+"&reportId="+reportId+"&parentId="+parentId); 
	  }else if("2" == type){
			  if(array.length>0){
			  	$("#rightFrame",parent.document).attr("src","${path}"+array[0]+"&reportId="+reportId+"&parentId="+parentId); 
			  }
			  if(array.length==2){
				  $("#resultFrame",parent.document).attr("src","${path}"+array[1]+"&reportId="+reportId);  
			  }
	  }
  }
  
</script>
</head>
<body class="h100b over_hidden page_color border_all">
	<div class="align_center stadic_head_height">
		<!-- <select>
		       <option>选择图表</option>
		</select>&nbsp;
		<input type="button" class="ico16 search_16"/> -->
	</div>
	<div class="tree_area margin_5 over_auto padding_t_10" >
	    <ul id="leftTree" class="treeDemo_0 ztree"></ul>
	</div>
</body>
</html>

