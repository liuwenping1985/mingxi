<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
        .stadic_bottom_height{
            height:140px;
            bottom:0;
        }
        .stadic_body_top_bottom{
            bottom:140px;
            top:0px;
        }

    </style>
</head>
<script type="text/javascript">

var parentWindow = null;//父页面窗口

$(document).ready(function () {
	var parentWindow = window.dialogArguments.win;
	var auditer = parentWindow.$("#auditerIds").val();//读取已选的审核人
	
	var resetSelected = $("[type=checkbox]");
	for(var i=0; i<resetSelected.length; i++){
		var _currentId = $(resetSelected[i]).attr("value");
		if(auditer != "" && auditer.indexOf(_currentId)>0) {
			$(resetSelected[i]).attr("checked", true);
		} else {
			$(resetSelected[i]).attr("checked", false);
		}
	}	

	$("#selectAllCheckbox").click(function(){
    	if($(this).prop("checked")) {
    	   $("#peoplesTbody :checkbox").prop("checked",true);
    	} else {
    		$("#peoplesTbody :checkbox").prop("checked",false);
    	}
    });
	
});
function OK() {
	var o = new Object();
	var auditerNames = "";
	var auditerIds = "";
	var selected = $("input:checked[type=checkbox]");
	for(var i=0; i<selected.length; i++) {
		if($(selected[i]).attr("value") == "on") {
			continue;
		}
		auditerNames += $(selected[i]).parent().parent().find("td").eq(1).html() + "，";
		auditerIds += "Member|"+$(selected[i]).attr("value")+ ",";
	}
	if(auditerIds!="" && auditerNames!=""){
		auditerNames = auditerNames.substring(0, auditerNames.length-1);
		auditerIds = auditerIds.substring(0, auditerIds.length-1);
	}
	o.auditerNames = auditerNames;
	o.auditerIds = auditerIds;
	
	//parentWindow.$("#auditer").val(auditerNames);
	/* if(auditerIds !== ""){
		parentWindow.$("#audit_label").html($.i18n('infosend.magazine.label.selectedAuditor'));//已选择审核人
	}else {
		parentWindow.$("#audit_label").html($.i18n('infosend.magazine.label.selectAuditor'));//请选择审核人
	}
	parentWindow.$("#auditerIds").val(auditerIds); */

	return o;
}
</script>


<body class="h100b over_hidden">
    <div class="h100b">
        <div class=" stadic_layout_body stadic_body_top_bottom h100b">
            <div class="font_size12 margin_5" style="margin: 16px 26px 0px 26px;">${ctp:i18n("workflow.hasten.selectPeople.please.label") }</div>
            <div class="border_all margin_5" style="height:260;margin: 6px 26px 16px 26px;">
            	<table class="only_table edit_table no_border" border="0" cellspacing="0" align="center"  cellpadding="0" width="100%">
                <thead>
                    <tr>
                        <th width="20"><input id="selectAllCheckbox" type="checkbox"/></th>
                        <th style="border-right:0;">${ctp:i18n("common.name.label") }</th>
                    </tr>
                </thead>
                <tbody id="peoplesTbody" style="overflow:auto;">
					<c:forEach items="${auditers}" var="d">
                           <tr class="sort">
                               <td><input type="checkbox" name="member" value="${d.id}"</td>
                               <td style="border-right:0;">${ctp:toHTML(d.name)}</td>
                           </tr>
   					</c:forEach>
                </tbody>
            	</table>
            </div>
        </div>
    </div>
</body>
</html>