<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>督办统计</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<script type="text/javascript" ${path}/ajax.do?managerName=supervisionStatManager"></script>
<style>
.stadic_head_height {
    height: 21px;
}

.stadic_body_top_bottom {
    bottom: 0px;
    top: 21px;
}
</style>
<script>
  
  
  $(document).ready(function() {
    new inputChange($("#set_display"), "点击设置显示");
    new inputChange($("#sort_display"), "点击设置排序");
    new MxtLayout({
      'id' : 'layout',
   //   'northArea' : {
    //    'id' : 'north',
    //    'height' : 26,
    //    'sprit' : false,
     //   'border' : true,
     //   'spritBar' : false
     // },
      'westArea' : {
        'id' : 'west',
        'width' : 220,
        'sprit' : true,
        'minWidth' : 0,
        'maxWidth' : 500,
        'border' : true
      },
      'centerArea' : {
        'id' : 'center',
        'border' : true,
        'minHeight' : 20,
        'border' : false
      }
    });
    //加载左边表单树菜单
    loadReportTree();
    //统计模板查询时，需要展开树
    <c:if test="${mysel =='mysel'}">
    	var treeObj = $.fn.zTree.getZTreeObj("leftTree");
    	treeObj.expandAll(true);
    </c:if>
    //移动了大小后从新统计
    $("#westSp_layout").mouseup(function(){
    	try{
    		rightFrame.window.search();
    	}catch(e){
    	}
    });
  });
  
  function loadReportTree() {
    $("#leftTree").tree({
      idKey : "id",
      pIdKey : "parentId",
      nameKey : "name",
      isParent : "isParent",
      onClick : nodeClick,
      nodeHandler : function(n) {
    	    if(n.id==1 || n.id==2){
    	    	n.open = true;
    	    }else{
        		n.open = false;
    	    }
        	n.isParent = n.data.parent;
        }
      });
  }
  
  function nodeClick(e, treeId, node){
    
    if(!node.isParent){
      showDetail(node.data.id);
    }else{
      showDetail();
    }
  }
    
  function showDetail(type){
	var statPath = "${path}/supervision/supervisionStatController.do?";
    if(type == undefined){
       $("#rightFrame").attr("src",statPath+"method=goIndexIntro&reportSize=${reportSize}");
    }else{
      $("#rightFrame").attr("src",statPath+"method=goIndexRight&type="+type);
    }
  }
</script>
</head>
<body class="h100b overflow_hidden page_color" >
    <div id='layout'>
        <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F08_reportviewindex'"></div>
        <div class="layout_west" id="west" style="overflow:auto;">
            <div class="tree_area padding_t_10" style="overflow:visible;height: 95%;">
            <ul id="leftTree" class="treeDemo_0 ztree"></ul>
            </div>
        </div>
        <!--查询设置&结果-->
        <div class="layout_center" id="center" style="overflow: hidden;">
            <iframe id="rightFrame" name="rightFrame" frameborder="0" width="100%" height="100%" src="${path}/supervision/supervisionStatController.do?method=goIndexIntro&reportSize=${reportSize}"> </iframe>
        </div>
    </div>
</body>
</html>
