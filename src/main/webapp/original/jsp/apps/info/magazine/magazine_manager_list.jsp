<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<%-- 信息类型 --%>
<title>${ctp:i18n("infosend.listInfo.informationType")}</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=magazineListManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/magazine_list.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine/magazine_manager_list.js${ctp:resSuffix()}"></script>
</head>
<script type="text/javascript">
var hasMagazineNewRole = '${hasMagazineNewRole}';
var listType = "${listType}";
var pw;
var bodyType = "officeWorld";

function loadDefaultBodyType() {
	pw = new Object();
	try{
		var ocxObj=new ActiveXObject("HandWrite.HandWriteCtrl");
		pw.installDoc= ocxObj.WebApplication(".doc");
		pw.installWps=ocxObj.WebApplication(".wps");
	}catch(e){
		pw.installDoc=false;
		pw.installWps=false;
	}

	if(pw.installDoc && pw.installWps){
		bodyType = "officeWorld";
	}else if(pw.installWps){
		bodyType = "wpsWorld";
	}else if(pw.installDoc){
		bodyType = "officeWorld";
	}
}

function checkMagazine(obj){
	$("#magazineData").find("input").removeAttr("checked");
	$(obj).attr("checked","checked");
}

</script>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div style="float: left" id="toolbars"></div>
            <div style="float: right">
                <a id="combinedQuery" onclick="openQueryViews('${listType}');" style="margin-right: 5px;margin-top:2px;" class="common_button common_button_gray">${ctp:i18n("infosend.magazine.combinedQuery")}</a>
            </div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="magazineManagerList"></table>

        </div>
    </div>
     <iframe id="hiddenIframe" name="hiddenIframe" style="display:none"></iframe>
</body>
</html>
