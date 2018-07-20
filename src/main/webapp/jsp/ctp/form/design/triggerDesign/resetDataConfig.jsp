<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>resetDataConfig</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=getmember"></script>
<script type="text/javascript">
	/**
	 * 修改配置时，系统会自动把上次存储的配置值（字符串），返还给你，具体填充到form自行负责
	 */
	//防止json为空 报错
	  var json = '${enumList}';
	  if(json == ""){
		  json = "{}";
	  }
	  var enumList = $.parseJSON(json);
	  
	function init(config) {
		var filObj = $.parseJSON(config);
		$("#field1").val(filObj["field1"]).trigger("change");
		$("#cale1").val(filObj["cale1"]);
		$("#formulaId1").val(filObj["formulaId1"]);
		$("#fieldValue1").val(filObj["fieldValue1"]);
		
		$("#field2").val(filObj["field2"]).trigger("change");
		$("#cale2").val(filObj["cale2"]);
		$("#formulaId2").val(filObj["formulaId2"]);
		$("#fieldValue2").val(filObj["fieldValue2"]);
		
		$("#field3").val(filObj["field3"]).trigger("change");
		$("#cale3").val(filObj["cale3"]);
		$("#formulaId3").val(filObj["formulaId3"]);
		$("#fieldValue3").val(filObj["fieldValue3"]);
		var p = window.parent;
		if(true == $("#triggerName",p.window.document).prop("disabled")){
			$(":input").prop("disabled",true);
		}
	}
	
	function setContentValue(ov){
		$("#fieldValue"+currentidx).val(ov);
	}
	var currentidx = 1;
	function setCal(o,i){
		currentidx = i;
		var formulaType = _formulaType_number;
		if($(o).attr("dataType") == "VARCHAR"){
			formulaType = _formulaType_varchar;
		}
		var formulaArgs = getFormulaArgs(setContentValue,'0',formulaType,
				$(o).val(),null);
	    formulaArgs.title = "设置计算值";
	    formulaArgs.allowSubFieldAloneUse = false;
	    formulaArgs.hasDifferSubField = false;
	 	formulaArgs.noCheck = false;
		formulaArgs.flowTitle = true;//特殊参数流程应用绑定，1 不能有+号，2不能有重复项
		showFormula(formulaArgs);			
	}
	
	function sChange(sl){
		var op = $(":selected",sl);
		var idx = $(sl).attr("idx");
		var tr1 = $(sl).parents("tr:eq(0)");
		if(op.attr("inputType") == "text" || op.attr("inputType") == "textarea" ){
			$(".td_",tr1).html('<input inputType="'+op.attr("inputType")+'" dataType="'+op.attr("dataType")+'" id="fieldValue'+idx+'" class="w100b" name="fieldValue'+idx+'"   type="text" onClick="setCal(this,'+idx+');"  /> ');
			$("#cale"+idx).val("cale");
		}else if(op.attr("inputType") == "radio" || op.attr("inputType") == "select" ){
			$("#cale"+idx).val("val");
			var h = '<select id="fieldValue'+idx+'" class="w100b" name="fieldValue'+idx+'">';
			var f = $(sl).val();
			var ob = enumList[f];
			for(var s=0;s<ob.length;s++){
				var enumObj = ob[s]
				if(enumObj.showvalue == ""){
					continue;
				}
				h = h + '<option value="'+enumObj.id+'">'+enumObj.showvalue+'</option>';
			}
			h = h + "</select>";
			$(".td_",tr1).html(h);
		}else{
			$(".td_",tr1).html('<input id="fieldValue'+idx+'" class="w100b" name="fieldValue'+idx+'"   type="text" /> ');
			$("#cale"+idx).val("val");
		}
	}

	/**
	 * 将配置值自行拼接成字符串返回给表单，表单负责存储，具体格式没有要求，自行决定
	 * @return string
	 */
	function OK() {
		var result = $("table").formobj({validate : false});
		return $.toJSON(result);
	}
</script>

</head>
<body>
	<table border="0" cellSpacing="0" cellPadding="2" width="100%" height="60" class="form_area padding_5 margin_t_10">
		<tbody>
			<tr>
				<td  width="5%" >
				</td>
				<td width="30%" noWrap="nowrap" align="right">
				<select id="field1"  class="w100b" idx='1' onchange="sChange(this)">
					<option value="" inputType="" dataType=""></option>
					<c:forEach items="${showList}" var="field" varStatus="status">
					<option  value="${field.name }" inputType="${field.inputType }" dataType="${field.fieldType }">${field.display}</option>
					</c:forEach>
				</select>
				<input type="hidden" id="cale1" value="cale">
				<input type="hidden" id="formulaId1" value="">
				</td>
				<td>=</td>
				<td class="td_">
					<input id="fieldValue1" class="w100b" name="fieldValue1"   type="text"  /> 
				</td>
				<td  width="15%"></td>
			</tr>
			<tr>
				<td  width="5%" ></td>
				<td width="30%" noWrap="nowrap" align="right">
				<select id="field2"  class="w100b" idx='2' onchange="sChange(this)">
					<option value="" inputType="" dataType=""></option>
					<c:forEach items="${showList}" var="field" varStatus="status">
					<option  value="${field.name }" inputType="${field.inputType }" dataType="${field.fieldType }">${field.display}</option>
					</c:forEach>
				</select>
				<input type="hidden" id="cale2" value="cale1">
				<input type="hidden" id="formulaId2" value="">
				</td>
				<td>=</td>
				<td class="td_">
					<input type="text" class="w100b" id="fieldValue2"   name="fieldValue2" />
				</td>
				<td  width="15%"></td>
			</tr>
			<tr>
				<td  width="5%" ></td>
				<td width="30%" noWrap="nowrap" align="right">
				<select id="field3"  class="w100b" idx='3' onchange="sChange(this)">
					<option value="" inputType="" dataType=""></option>
					<c:forEach items="${showList}" var="field" varStatus="status">
					<option  value="${field.name }" inputType="${field.inputType }" dataType="${field.fieldType }">${field.display}</option>
					</c:forEach>
				</select>
				<input type="hidden" id="cale3" value="cale1">
				<input type="hidden" id="formulaId3" value="">
				</td>
				<td>=</td>
				<td class="td_">
					<input type="text" class="w100b" id="fieldValue3"   name="fieldValue3" />
				</td>
				<td  width="15%"></td>
			</tr>
		</tbody>
	</table>
	<%@ include file="../../common/common.js.jsp" %>
</body>

</html>