<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<script type="text/javascript" src="${path}/common/js/V3X.js"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=superviseManager"></script>
<script text="text/javascript">
  $(function() {
      //定义列表
      var grid =  $("#mytable").ajaxgrid({
          colModel : [{ display : "${ctp:i18n('supervise.col.hastenTime')}",     
              name : "sendTime",
              width : "25%"
          },
          { display : "${ctp:i18n('supervise.col.hastener')}",   
              name : "senderName",
              width : "25%"
          },
          { display : "${ctp:i18n('supervise.col.receiver')}",        
              name : "receiverName",
              width : "25%"
          },  
          { display : "${ctp:i18n('supervise.col.content')}",       
              name : "content",
              width : "25%"
          }],
      width : 800,
      height: 400,
      parentId:"qq",
      resizable:false,
      managerName : "superviseManager",
      managerMethod : "getLogByDetailId"
    });
    //手动加载表格数据 
    var aa = $("#mysearch").formobj();
    $("#mytable").ajaxgridLoad(aa);
    
  });
  
</script>
<style type="text/css">
.div-float{
    float:left;
}

</style>
</head>
  
<body id="qq" class="body-pading h100b over_hidden" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <input type="hidden" id="summaryId" />
    <input type="hidden" id="id" />
    <input type="hidden" id="status" />
    
    <div id='layout'>
            <div class="layout_north page_color" id="north">
                <div id="sss" class="hidden">
                    <div class="common_search_box right clearfix" id="mysearch">
                        
                        <input type="text" id="superviseId" value="${param.superviseId }"/>            
                    </div>
                </div>
            </div>
    
    
    <div class="list">
            <div class="button_box clearfix">
            <form id="myform" method="post" action="">
                <table id="mytable" style="display: none"></table>
             </form>
            </div>
        </div>

</body>

</html>