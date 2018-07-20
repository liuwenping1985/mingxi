<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head> 
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
    .stadic_body_top_bottom{
        bottom:140px;
        top:0px;
    }
    
    /**v5.1标准弹出框内容边距为上右下左:16px 26px 16px 26px**/
    .DIALOG_CONTENT_MARGIN{
        margin: 16px 26px 16px 26px;
    }
</style>
</head>
<script type="text/javascript">
$(document).ready(function () {
    var resetSelected = $("#content input[type=checkbox]");
	var auditer = parent.$("#infoCategoryIds").val();//读取已选的信息类型
    try{
        if (auditer) {
            for(var i=0; i<resetSelected.length; i++){
                var _currentId = $(resetSelected[i]).attr("id");
                if(auditer.indexOf(_currentId) > 0){
                    $(resetSelected[i]).attr("checked",true);
                }
            }
         }
    }catch(e){}

    $("#allClick").click(function(){  
        if($(this).prop("checked")) {
    	   $("#categoryTbody :checkbox").prop("checked",true);
    	} else {
    		$("#categoryTbody :checkbox").prop("checked",false);
    	}
    });
});
function OK(){
	var selected = $("#categoryTbody input:checked[type=checkbox]");
	var object= new Object();
	var auditerNames="";
	var auditerIds="";
    var ids = "";
	for(var i=0; i<selected.length; i++){
		auditerNames += $(selected[i]).attr("name") + ",";
		auditerIds +=$(selected[i]).attr("value")+"|"+$(selected[i]).attr("name")+ ",";
        ids +=$(selected[i]).attr("value")+",";
	}
	if(auditerIds!="" && auditerNames!=""){
		auditerNames = auditerNames.substring(0, auditerNames.length-1);
		auditerIds = auditerIds.substring(0, auditerIds.length-1);
		ids = ids.substring(0, ids.length-1);
	}
	object.auditerName=auditerNames;
	object.auditerId=auditerIds;
    object.ids = ids;
	return object;
}
</script>
<body class="over_hidden h100b" >
	<div class="h100b">
		<div class=" stadic_layout_body stadic_body_top_bottom h100b">
			<div class="border_all DIALOG_CONTENT_MARGIN" >
				<table class="only_table edit_table no_border" border="0" cellspacing="0" align="center"  cellpadding="0" width="100%">
				    <thead>
				        <tr>
				            <th width="20"><input id="allClick" type="checkbox"/></th>
				            <th style="border-right:0;">${ctp:i18n("common.name.label") }</th>
				    </tr>
					</thead>
					<tbody id="categoryTbody">
						<c:forEach var="listCategory" items="${listCategory}">
						<tr class="sort">
							<td><input type="checkbox" name="${ctp:toHTML(listCategory.cateGoryName)}" value="${listCategory.cateGoryId}"</td>
							<td style="border-right:0;" title="${ctp:toHTML(listCategory.cateGoryName)}">${ctp:getLimitLengthString(ctp:toHTML(listCategory.cateGoryName),57,'...')}</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
        </div>
	</div>
</body>
</html>