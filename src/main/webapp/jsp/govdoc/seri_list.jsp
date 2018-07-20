<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>AjaxPagingGrid测试</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=edocManager"></script>
<script text="text/javascript">
  $(function() {
    var t = $("#mytable").ajaxgrid({
      colModel : [{
        display : '标题',
        name : 'subject',
        width : '50%',
        align : 'left'
      }, {
        display : '公文文号',
        name : 'serialNo',
        width : '50%'
      } ],    
      click : clk,//单击事件 
      dblclick : clk,//双击事件
      managerName : "edocManager",
      managerMethod : "getSeriList"
    });
    search();
  });
  function clk(data, r, c) {
    	var url = _ctxPath + "/collaboration/collaboration.do?method=summary&detail=1&openFrom=formQuery&fromFormQuery=true&app=4&summaryId="+data.id;
     	window.open(url);
  }
  function search() {
    var o = new Object();
	o.serialNo = $("#serialNo").val();
	o.summaryId = $("#summaryId").val();
    $("#mytable").ajaxgridLoad(o);
  }
</script>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div class="classification">
        <div class="list">
            <div class="button_box clearfix">
                <table id="mytable" style="display: none"></table>
                <input type="hidden" id="serialNo" name ="serialNo" value="${serialNo }"/>
                 <input type="hidden" id="summaryId" name ="summaryId" value="${summaryId }"/>
            </div>
        </div>
    </div>
</body>
</html>