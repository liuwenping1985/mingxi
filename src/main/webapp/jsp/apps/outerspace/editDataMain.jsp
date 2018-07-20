
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>编辑数据</title>
<style type="text/css">
#systemMenuTree {height:300px;overflow-y:auto;overflow-x:auto;}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=outerspaceManager"></script>
<script>
  $(document).ready(function() {
      var msg = '${ctp:i18n("info.totally")}';
	  
	  var mytable = $("#mytable").ajaxgrid({
      colModel : [ {
        display : 'id',
        name : 'id',
        width : '4%',
        sortable : false,
        align : 'center',
        type : 'checkbox'
      }, {
        display : '名称',
        name : 'subject',
        sortable : true,
        width : '28%'
      }, {
          display : '摘要',
          name : 'remark',
          sortable : true,
          width : '50%'
      }, {
    	  display : '发布时间',
          name : 'createTime',
          sortable : true,
          width : '18%'
      }],
      click : tclk,
      dblclick : dblclk,
      managerName : "outerspaceManager",
      managerMethod : "getSectionListsBySectionId",
      params : {
        sectionId : "${sectionId}"
      },
      render : rend,
      parentId:"center",
      slideToggleBtn : true,
      vChange: true,
      vChangeParam: {
          autoResize:true
      }
    });
	  
    $("#manual").show();
    $("#count").html(msg.format(mytable.p.total));
    
    function rend(txt, data, r, c) {
    	return txt;
    }
	var myToolbar = $("#toolbar2").toolbar({
      	searchHtml: 'sss',
      	toolbar: [
		{
	      id: "deleteData",
	      name: "${ctp:i18n('link.jsp.del')}",
	      className: "ico16 del_16",
		  click:function(){
			  var checkedIds = $("input:checked", $("#mytable"));
			  if (checkedIds.size() == 0) {
			    $.alert("${ctp:i18n('outerspace.select.delete.data.prompt')}");
			  } else {
					var ids = "";
					for(var i=0; i<checkedIds.size(); i++){
						var checkedId = $(checkedIds[i]).attr("value");//选中行数据的ID号
						ids = ids+checkedId;
						if(i!=checkedIds.size()-1){
							ids = ids+",";
						}
					}
			    	
			    $.post("${path}/outerspace/outerspaceController.do?method=deleteOuterspaceSectionList&ids="+ids, function(data){
			    	if(data == "true"){
						refreshTable();
					}else{
						$.alert("删除失败，请稍后重试！");
					}
			    });
			  }
		   }
		}
		]
	  });  
	  
	//双击列表中一行
    function dblclk(data, r, c) {

	}

	//记录单击事件触发的次数
	var clkCount = 0;
	//单击列表中一行，下面form显示详细信息
  	function tclk(data, r, c) {
  	  
    }
    
  });
  
  //刷新列表
  function refreshTable(){
	  window.location.reload(true);
  }
  
</script>
</head>
<body>
    <c:set var="noLocationCode" value="门户空间设置"></c:set>
    <div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
            <div class="comp" comp="type:'breadcrumb',code:'${noLocationCode}'"></div>
        	<div id="toolbar2"></div>
        </div>
        <div class="layout_center over_hidden" id="center" layout="border:false">
            <table id="mytable" class="flexme3" style="display: none"></table>
        </div>
    </div>
</body>
</html>