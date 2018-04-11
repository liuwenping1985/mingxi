<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/datarelation/datarelationHeader.jsp"%>
<link rel="stylesheet" href="${path}/apps_res/datarelation/css/dataRelationConfig.css${ctp:resSuffix()}">
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
.rightMaxWidth{
    display:block;white-space:nowrap; overflow:hidden; text-overflow:ellipsis;max-width: 230px;
    color: #FFF;
}
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script> 
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/datarelation/js/formSelectWin.js"></script> 
</head>
<body class="h100b over_hidden">
  <div id='layout' class="comp" comp="type:'layout'">
    <div class="layout_north" layout="height:40,sprit:false,border:false">
      <div class="right" style="margin-right:100px;">
          <!-- 我创建的 -->
          <label for="creater" class="font_size12" onclick="fnBarQuery();"> 
          <input id="creater" type="radio" name="range" ${param.range ne 'account'?'checked':''} value="creater"/>
            ${ctp:i18n("bizconfig.create.my")}
          </label>
           <!-- 本单位所有 --> 
           <label for="account" class="font_size12" onclick="fnBarQuery();">
            <input id="account" type="radio" name="range" ${param.range eq 'account'?'checked':''} value="account"/>
            ${ctp:i18n("bizconfig.create.all")}
           </label>
      </div>
    </div>
    <div class="layout_west" layout="width:265,sprit:false,border:false" style="overflow:hidden;">
      <div class="border_all margin_l_10" style="width: 245px;height: 470px; overflow:auto;">
        <div id="formTemplateTree"></div>
     </div>
    </div>
    <div class="layout_center" layout="border:false,sprit:false">
      <!--中间区域 --><!-- 左右按钮 -->
      <div class="center" style="position:absolute; right:3px; padding-top:200px;height:32px;">
        <p id="columnRight">
            <span class="ico16 select_selected" onClick="fnMoveRight()"></span>
        </p>
        <br>
        <p id="columnLeft">
            <span class="ico16 select_unselect" onClick="fnMoveLeft()"></span>
        </p>
      </div>
    </div>
    <div class="layout_east" layout="width:270,minWidth:50,border:false,sprit:false">
      <!--  右边区域 -->
      <div class="border_all" style="width: 245px; height: 470px;" ondblclick="fnMoveLeft()">
          <span id="rightOption" class="rightMaxWidth font_size12 margin_t_5 margin_l_5 bg_color_blueLight hand"></span>
      </div>
    </div>
  </div>
</body>
</html>