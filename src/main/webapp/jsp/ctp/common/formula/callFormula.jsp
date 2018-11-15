<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="DataType.jsp"%>
<script type="text/javascript">
var formulas=${formulas};

$().ready(function() {
	showVar();
});
function fillSelect(v){
	var se = document.getElementById("formulas");
	$("#formulas").empty();
	for (var key in v) {
		var option = document.createElement("option");
		option.value = key;
		option.text = v[key].formulaAlias;
		se.add(option);
	}
}
function showVar(){
	$("#varShow").show();
	$("#funcShow").hide();
}
function showFunc(){
	$("#varShow").hide();
	$("#funcShow").show();
}
function selectFormulas(){
	var t=$("#search").val();
	var obj = new Object();
	for (var key in formulas) {
		var option = document.createElement("option");
		if(formulas[key].formulaAlias.indexOf(t)>-1){
			obj[key]=formulas[key];
		}
	}
	fillSelect(obj);
}
function chooseFormulas(){
	var v=$("#formulas").val().length>1?$("#formulas").val()[0]:$("#formulas").val();
	if(formulas[v].formulaType=='1'||formulas[v].formulaType=='0'){
		showVar();
		$("#vName").text(formulas[v].formulaName);
		$("#vType").text(getDataType(formulas[v].dataType));
		$("#vNote").text(formulas[v].description);
	}else{
		showFunc();
		$("#fName").text(formulas[v].formulaName);
		$("#fType").text(getDataType(formulas[v].dataType));
		$("#fNote").text(formulas[v].description);
		var params=formulas[v].params;
		var table=$("#fParams");
		table.empty();
		var thead='<thead style="background-color:#1166ee"><tr><td style="width:65px" align="center">${ctp:i18n("ctp.formulas.params")}</td><td style="width:65px" align="center">${ctp:i18n("ctp.formulas.dataType")}</td><td style="width:65px" align="center">${ctp:i18n("ctp.formulas.description")}</td></tr></thead>';
		table.append(thead);
		if(params!=undefined){
			for(var i = 0;i<params.length;i++){
				var tr="<tr><td align='center'>"+params[i].name+"</td><td align='center'>"+params[i].type+"</td><td align='center'>"+params[i].description+"</td></tr>";
				$(tr).appendTo(table);
			}
		}
		$("#fExp").text(formulas[v].sample);
		$("#fReturn").text(formulas[v].expectValue);
	}
}
$().ready(function() {
	fillSelect(formulas);
});
function OK(){
	var v=$("#formulas").val();
	return formulas[v];
}
</script>
</head>
<body>
<table style="padding-left:19px" width="570" height="100%" border="0" cellpadding="0"
		cellspacing="0">
		<tr height="50px">
			<td>
				<ul class="common_search">
					<li id="inputBorder" class="common_search_input"><input id="search"
						style="width: 520px" class="search_input" type="text"></li>
					<li><a
						class="common_button common_button_gray search_buttonHand"
						href="javascript:void(0)" onclick="selectFormulas();"> <em></em>
					</a></li>
				</ul>
			</td>
		</tr>
		<tr>
			<td>
				<table border="0" cellpadding="0" width="570" cellspacing="0"
					align="center">
					<tr>
						<td class="leftarea_showupdown" valign="top">
							<table class="leftarea_showupdown" cellSpacing=0 cellPadding=0
								border=0 id=leftarea>
								<tr>
									<td><select onchange="chooseFormulas();" name="formulas" id="formulas"
										multiple="multiple" style="width: 240px; height: 300px;"></select>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<table id="varShow" class="rightarea_showupdown" cellSpacing=0 cellPadding=0
								border=0>
								<tr>
									<td>
										<fieldset style="width: 300px; height: 291px">
											<table>
												<tr>
													<td style="height: 25px;white-space:nowrap" >${ctp:i18n('ctp.formulas.varName')}:</td>
													<td><label id="vName"></label></td>
												</tr>
												<tr>
													<td style="height: 30px;white-space:nowrap">${ctp:i18n('ctp.formulas.returnType')}:</td>
													<td><label id="vType"></label></td>
												</tr>
												<tr>
													<td style="height: 30px;white-space:nowrap">${ctp:i18n('ctp.formulas.description')}:</td>
													<td><label id="vNote"></label></td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
							<table id="funcShow" class="rightarea_showupdown" cellSpacing=0 cellPadding=0
								border=0>
								<tr>
									<td>
										<fieldset style="width: 300px; height: 291px">
											<table>
												<tr>
													<td style="height: 25px;width:70px;white-space: nowrap">${ctp:i18n('ctp.formulas.formulaName')}:</td>
													<td><label id="fName"></label></td>
												</tr>
												<tr>
													<td style="height: 30px;white-space:nowrap">${ctp:i18n('ctp.formulas.returnType')}:</td>
													<td><label id="fType"></label></td>
												</tr>
												<tr>
													<td style="height: 30px;white-space:nowrap">${ctp:i18n('ctp.formulas.description')}:</td>
													<td><label id="fNote"></label></td>
												</tr>
												<tr>
													<td style="height: 70px;white-space:nowrap">${ctp:i18n('ctp.formulas.params')}:</td>
													<td><table id="fParams" width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table"></table></td>
												</tr>
												<tr>
													<td style="height: 30px;white-space:nowrap">${ctp:i18n('ctp.formulas.simple')}:</td>
													<td><label id="fExp"></label><br/>${ctp:i18n('ctp.formulas.return')}<br/><label id="fReturn"></label></td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html>