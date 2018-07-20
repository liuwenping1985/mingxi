<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/apps/info/include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<title>期刊关联信息</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoListManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/info_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/view/magazine_info_list.js${ctp:resSuffix()}"></script>

<script type="text/javascript">

   var _magaizneId = "${magazineId}";
   var affairState = "${param.affairState}";
</script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <a id="combinedQuery" onclick="openQueryViews('listInfoDone');" style="margin-right: 5px;margin-top:2px;" class="common_button common_button_gray">${ctp:i18n('infosend.magazine.combinedQuery')}<!-- 组合查询 --></a>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id=magazineInfoList></table>
        </div>
    </div>
</body>
</html>