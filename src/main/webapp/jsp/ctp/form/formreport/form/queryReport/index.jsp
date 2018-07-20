<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${url_ajax_reportViewManager}"></script>
<title>${ctp:i18n("report.queryReport.tree.formReport")}</title>
<script type="text/javascript">
  //------------i18n国际化区域 start
  // ------------i18n国际化区域 end
  var reportViewManager_ = new reportViewManager();
</script>
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
    
  function showDetail(reportId){
    if(reportId == undefined){
       $("#rightFrame").attr("src",url_queryReport_goIndexIntro+"&reportSize=${reportSize}&formType=${formType}");
    }else{
      $("#rightFrame").attr("src",url_queryReport_goIndexRight+"&reportId="+reportId+"&type=query");
    }
  }
</script>
</head>
<body class="h100b overflow_hidden page_color" >
    <div id='layout'>
        <c:if test="${formType ne '4' }">
        <div class="comp"comp="type:'breadcrumb',comptype:'location',code:'F08_reportviewindex'"></div>
        </c:if>
        <div class="layout_west" id="west" style="overflow:auto;">
            <div class="tree_area padding_t_10" style="overflow:visible;height: 95%;">
            
              <table border="0" cellspacing="0" cellpadding="0" id="selinfo">
                <tr >
                    <td width="100">
                       <div>
                            <select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="margin_l_5"  style="height: 22px; font-size: 12px;">
                                <option value="">--${ctp:i18n('form.query.chooseCondition')}--</option>
                                <option value="queryName">${ctp:i18n('form.flow.templete.name')}</option>
                                <c:if test="${categoryId == 1 }">
                                	<option value="categoryName">${ctp:i18n('form.app.affiliatedapply.label')}</option>
                                </c:if>
                            </select>
                        </div>
                    </td> 
                    <td <c:if test="${mysel !='mysel'}"> class="hidden" </c:if>  id="editTr">
                            <input class="margin_l_5" type="text" name="data" id="data" value="" style="width:80px;"/>
                            <input type="hidden" name="categoryId" value="${categoryId }" id="categoryId" />
                    </td>
                    <td>
                        <div class="left" id="searchBtn"><EM class="ico16 search_16"></EM></div>
                    </td>
                </tr>
            </table>
            
            <ul id="leftTree" class="treeDemo_0 ztree"></ul>
            </div>
        </div>
        <!--查询设置&结果-->
        <div class="layout_center" id="center" style="overflow: hidden;">
            <iframe id="rightFrame" name="rightFrame" frameborder="0" width="100%" height="100%" src="${url_queryReport_goIndexIntro}&reportSize=${reportSize}&formType=${formType}"> </iframe>
        </div>
    </div>
</body>
<script type="text/javascript">
//查询切换条件
function showNextSpecialCondition(obj){
    $("#data").val("");
    if($(obj).val()==""){
        $("#editTr").removeClass("hidden").addClass("hidden");
    }else{
        $("#editTr").removeClass("hidden");
    }
}

var formType = null;
<c:if test="${!empty formType}">
formType = "${ctp:toHTML(formType)}";
</c:if>

function searchParam(){
   if($("#condition").val()!=""){
       $("body").jsonSubmit( {
           action : url_queryReport_index+"&formType="+formType,
           domains : ["selinfo"],
           debug : false,
           validate : false,
           beforeSubmit:function(){
               processBar =  new MxtProgressBar({text: "正在进行条件查询...."});
           }
    });
  }else if($("#condition").val()=="")
  {
  	  var categoryId = $("#categoryId").val();
      location.href=url_queryReport_index+"&formType="+formType+"&templateCategoryId="+categoryId;
  }
}
$(function(){
    $("#searchBtn").click(function() {
        searchParam();
    });
    $("#data").keyup(function(e){
        if(e.keyCode ==13){
            searchParam();
        }
    });
});
</script>
</html>
