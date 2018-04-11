
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript">
var RightData = new Properties();
$(document).ready(function(){
  	$("#select_selected").click(addToRight);
  	$("#select_unselect").click(delect);
	$('#up').click(function() {
		upordown(-1);
	});
	$('#down').click(function() {
		upordown(1);
	});
	showRightDatas();
	$("#formField").click(function(){
		leftupclick();
	});
	$("#sysField").click(function(){
		leftdownclick();
	});
	$("#formField,#sysField").dblclick(function(){
		addToRight();
	});
	$('#rightdataarea').dblclick(function() {
		delect();
	});
	$('#searchbtn').click(function() {
		search();
	});
	$("#searchtext").keyup(function(event) {
		if (event.keyCode == 13) {
			search();
		}
	});
});

function search() {
	var	value =  $('#searchtext').val();
	$("#formField").empty();
	$("#sysField").empty();
	$("#formField4search option").each(function(){
		if(value == "") {
			$("#formField").append($(this).clone());
		}else {
			if($(this).text().indexOf(value) != -1) {
				$("#formField").append($(this).clone());
			}
		}
	});
	$("#sysField4search option").each(function(){
		if(value == "") {
			$("#sysField").append($(this).clone());
		}else {
			if($(this).text().indexOf(value) != -1) {
				$("#sysField").append($(this).clone());
			}
		}
	});
}

function leftupclick() {
	if($("#sysField")!=null){
		$("#sysField").find("option:selected").attr("selected",false);
	}
}

function leftdownclick() {
	if($("#formField")!=null){
		$("#formField").find("option:selected").attr("selected",false);
	}
}

function upordown(nDir) {
	var selectObj = document.getElementById("rightdataarea");
	if (selectObj.selectedIndex < 0)
		return;
	if (nDir < 0) {
		if (selectObj.selectedIndex == 0)
			return;
	} else {
		if (selectObj.selectedIndex == selectObj.options.length - 1)
			return;
	}
	var opt = selectObj.options[selectObj.selectedIndex];;
	var otheropt = selectObj.options[selectObj.selectedIndex + nDir];
	var name = opt.attributes['name'].value;
	var fieldname = opt.attributes['fieldname'].value;
	var tablename =opt.attributes['tablename'].value;
	var title=opt.attributes['title'].value;
	var text=opt.text;
	opt.attributes['name'].value=otheropt.attributes['name'].value;
	opt.attributes['fieldname'].value=otheropt.attributes['fieldname'].value;
	opt.attributes['tablename'].value=otheropt.attributes['tablename'].value;
	opt.attributes['title'].value=otheropt.attributes['title'].value;
	opt.text=otheropt.text;
	otheropt.attributes['name'].value=name;
	otheropt.attributes['fieldname'].value=fieldname;
	otheropt.attributes['tablename'].value=tablename;
	otheropt.attributes['title'].value=title;
	otheropt.text=text;
	selectObj.selectedIndex += nDir;
}


/**
 * 数据域添加到右边框中
 */
function addToRight(){
	var leftarea =  $("#leftarea").find("select option:selected");
	if (leftarea.get(0)) {
		var options = "";
		if("${flag}" == "1") {//数据数据项
			if(objlength()>1) {
				$.alert("${ctp:i18n('form.binddesign.phone.image.onlyone.alert')}");
				return;
			}
			for(var i=0;i<leftarea.length;i++) {
				var lefta=$(leftarea[i]);
				var inputType = lefta.attr("finalinputtype");
				if((inputType == "image" || inputType == "barcode") && imageTooMany()){
					$.alert("${ctp:i18n('form.binddesign.phone.image.onlyone.alert')}");
					return;
				}
			}
		}
		for(var i=0;i<leftarea.length;i++) {
			var lefta=$(leftarea[i]);
			if(!RightData.containsKey(lefta.val())){
				options += "<option name='"+lefta.val()+"' fieldname='"+lefta.attr("fieldname")+"' tablename='"+lefta.attr("tablename")+"' title='"+lefta.attr("fieldname")+"'>"+lefta.attr("fieldname")+"</option>";
				RightData.put(lefta.val(),lefta.attr("fieldname"));
			}
		}
		$("#rightdataarea").append(options);

	}
}

function objlength() {
	return $("#leftarea").find("select option:selected[finalinputtype='image']").length + $("#leftarea").find("select option:selected[finalinputtype='barcode']").length;
}

function imageTooMany() {
	var imageIsExist = false;
	var imageFieldStr = "${imageFields}";
	var imageFields;
	var index = 0;
	if(imageFieldStr != "") {
		imageFields = imageFieldStr.split(",");
		$("#rightdataarea option").each(function(){
			var formFieldName = $(this).attr("name");
			for(var i=0;i<imageFields.length;i++) {
				if(formFieldName == imageFields[i]) {
					index ++;
					break;
				}
			}
			if(index > 0){
				imageIsExist = true;
				return false;
			}
		});
	}
	return imageIsExist;
}

/**
 * 从右边移除
 */
function delect(){
	var selectObj = document.getElementById("rightdataarea");
	removeOption(selectObj);
}

function removeOption(selobj) {
	if (selobj.selectedIndex > -1) {
		var opt = selobj.options[selobj.selectedIndex];
		selobj.remove(selobj.selectedIndex);
		RightData.remove($(opt).attr("name"));
		removeOption(selobj);
	}
}

function showRightDatas(){
	var param = window.dialogArguments;
	if(param && param.phoneFields && param.phoneFields != "") {
		var phoneFields = param.phoneFields.split(",");
		var phoneDisplay = param.phoneDisplay.split(",");
		for(var i=0;i<phoneFields.length;i++) {
			$("#rightdataarea").append("<option name='"+phoneFields[i]+"' fieldname='"+phoneDisplay[i]+"' tablename='"+phoneFields[i]+"' title='"+phoneDisplay[i]+"'>"+phoneDisplay[i]+"</option>");
			RightData.put(phoneFields[i],phoneDisplay[i]);
		}
	}
}

function OK(){
	var returnValue = new Array();
	var parentWin = window.dialogArguments.document;
	$("#rightdataarea option").each(function(index){
		var fieldName = $(this).attr("name");
		var fieldDisplay = $(this).attr("fieldname");
		returnValue[index] = {fieldName:fieldName,fieldDisplay:fieldDisplay};
	});
	/*if(returnValue.length == 0) {
		$.alert("${ctp:i18n('form.binddesign.phone.formfield.notnull.alert')}");
		return ;
	}*/
	return returnValue;
}
</script>
</head>
<body style="overflow: hidden;">
	<form id="datamatch" method="post" action="" onSubmit="" name="datamatch" target="" class="font_size12">
		<div id="tabs2" class="comp" comp="type:'tab',width:585,height:410">
            <div id="tabs2_body" class="common_tabs_body ">
            	<div id="tab1_div">
            		<table>
            			<tr>
            				<td width="270" id="leftarea">
								<%-- 表单数据域 --%>
			           			<div class="w100b" style="text-align: left;line-height: 20px;height: 28px;">${ctp:i18n('form.compute.formdata.label')}
									<span id="showsearch">:
										<input type="text" id="searchtext" style="width:50%;"/>
										<span class="ico16 search_16" id="searchbtn" href="javascript:void(0)"></span>
									 </span>
								</div>
			           			<div class="w100b" style="height: 270px;">
					               	<select class="border_all" name="formField" id="formField" style="width: 100%;height: 100%;" multiple="multiple" size="11">
										<c:forEach items="${flag eq '1' ? showFieldList : searchFieldList}" var="field" varStatus="status">
											<option value="${field.ownerTableName}.${field.name}" fieldname="${field.display}" tablename="${field.ownerTableName}" finalinputtype="${field.finalInputType}">[<c:if test="${field.masterField}">${ctp:i18n('form.base.mastertable.label')}</c:if><c:if test="${!field.masterField}">${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}</c:if>]${field.display}</option>
					                   	</c:forEach>
					               	</select>
					           </div>
					           <%-- 系统数据域 --%>
				           	   <div class="w100b" style="text-align: left;line-height: 20px;">${ctp:i18n('form.forminputchoose.systemdata')}</div>
				           	   <div class="w100b" style="height: 130px;">
				               		<select class="border_all" name="sysField" id="sysField" style="width: 100%;height: 100%;" multiple="multiple" size="11">
				                   		<c:forEach items="${flag eq '1' ? showSystemVarList : searchSystemVarList}" var="sys" varStatus="status">
											<option value="${sys.key}" fieldname="${sys.text}" >${sys.text}</option>
				                   		</c:forEach>
				               		</select>
				           	   </div>
            				</td>
            				<td>
            					<span id="select_selected" class="ico16 select_selected"></span><br><br>
		           				<span id="select_unselect" class="ico16 select_unselect"></span>
            				</td>
            				<td width="270">
            					<div class="clearfix" style="line-height: 20px;height: 28px;">
				           		<%-- 已选择数据域 --%>
				               <div id="left0" class="left" style="width:120px" >${ctp:i18n('form.forminputchoose.chooseddata')}</div>
				           		</div>
								<select name="dataarea" id="rightdataarea" size="24" multiple="multiple" style="width: 270px;height: 420px;"></select>
            				</td>
							<td id="UpAndDown"  width="40" align="center" valign="middle">
								<div >
									<span id="up"  class="ico16 sort_up"></span>
									<br><br>
									<span id="down"  class="ico16 sort_down"></span>
								</div>
							</td>
            			</tr>
            		</table>
               </div>
          </div>
     </div>
</form>
<select class="border_all" name="formField4search" id="formField4search" style="display: none" >
	<c:forEach items="${flag eq '1' ? showFieldList : searchFieldList}" var="field" varStatus="status">
		<option value="${field.ownerTableName}.${field.name}" fieldname="${field.display}" tablename="${field.ownerTableName}" finalinputtype="${field.finalInputType}">[<c:if test="${field.masterField}">${ctp:i18n('form.base.mastertable.label')}</c:if><c:if test="${!field.masterField}">${ctp:i18n('formoper.dupform.label')}${field.ownerTableIndex}</c:if>]${field.display}</option>
	</c:forEach>
</select>
<select class="border_all" name="sysField4search" id="sysField4search" style="display: none">
	<c:forEach items="${flag eq '1' ? showSystemVarList : searchSystemVarList}" var="sys" varStatus="status">
		<option value="${sys.key}" fieldname="${sys.text}" >${sys.text}</option>
	</c:forEach>
</select>
</body>
<%@ include file="../../common/common.js.jsp" %>
</html>
