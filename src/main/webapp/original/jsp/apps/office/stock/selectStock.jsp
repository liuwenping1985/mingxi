<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp"%>
<html class="h100b over_hidden">
<head>
<style type="text/css">
.stadic_head_height{
    height:40px;
}
.stadic_layout_body{
    bottom: 0px;
    top: 40px;
	overflow:hidden;
}
.border_l{
	height:76%;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.stock.select.please.js')}</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/stockUse.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/stock/selectStock.js"></script>
</head>
<body class="h100b over_hidden">
<div id='layout' class="comp" comp="type:'layout'">
  <div class="layout_west" layout="width:140,border:false,spiretBar:{show:true,handlerL:function(){pTemp.layout.setWest(0);},handlerR:function(){pTemp.layout.setWest(160);}}">
    <div class="stadic_layout border_r">
      <div id="stockTree"></div>
    </div>
  </div>
  <div class="layout_center" id="layoutCenterDiv" layout="border:false">
    <div id="docEditDiv" class="display_none h100b over_hidden">
      <iframe id="docEditFrame" src="" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>
    </div>
    <div id="centerTableDiv" class="stadic_layout border_l">
      <div class="stadic_layout_head stadic_head_height">
        <div id="toolbar"></div>
      </div>
      <div id="staticBodyDiv" class="stadic_layout_body">
        <table id="stockTab" style="display: none;"></table>
      </div>
    </div>
    <%-- 新增展示区域 --%>
	<div>
       <table width="100%" height="90" border="0" cellspacing="0" cellpadding="0" class="border_t" >
           <tr>
               <td style="padding-left: 15px; line-height:30px; height: 30px;">${ctp:i18n("channel.selected.label")}</td>
           </tr>
           <tr>
                <td style="height:60px;"><div style="height:60px; width: 98%;margin-left:5px; overflow-y: auto" id="selected2Area"></div></td>
           </tr>
		</table>
	</div>
  </div>
</div>
</body>
</html>