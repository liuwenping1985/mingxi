<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../edocHeader.jsp" %>
<%@page import="com.seeyon.v3x.edoc.manager.EdocSwitchHelper"%>
<html>
<head>
<c:set value="${param.selDocmark=='my:doc_mark' && isEdocMarkFenduan }" var="docMarkFenduanFlag" />
<c:set value="${param.selDocmark=='my:serial_no'}" var="serialNoFenduanFlag" />
<c:set value="${param.selDocmark=='my:sign_mark'}" var="signMarkFenduanFlag" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="edoc.docmark.chooseallmark" /></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/selectbox.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/jquery.jetspeed.json.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--

    window.transParams = window.transParams || window.parent.transParams;//获取上一个页面传入参数
	
	// 改变文号输入方式
	function changeMode() {
		var mode = document.getElementsByName("mode");
		var selectDiv = document.getElementById("select_div");
		var selectReserveDiv = document.getElementById("selectReserve_div");
		var inputDiv = document.getElementById("input_div");
		if (mode[0].checked) {
			selectDiv.style.display = "";
			selectReserveDiv.style.display = "";
			inputDiv.style.display = "none";
		} else if(mode[1].checked) {
			selectDiv.style.display = "";
			selectReserveDiv.style.display = "";
			inputDiv.style.display = "none";
		} else {
			selectDiv.style.display = "";
			selectReserveDiv.style.display = "";
			inputDiv.style.display = "";
			myform.hand_write.focus();
		}
	}
	//点击文字使相应的Radio被选中
	function setModeChecked(index){
		var mode = document.getElementsByName("mode");
		if(index=='0'){
			mode[0].checked=true;
		}else if(index=='1'){
			mode[1].checked=true;
		}else if(index=='2'){
			mode[2].checked=true;
		}
		changeMode();
	}
	$(function(){
		$('select#definitionId').change(function() {
			var options = {
				url: '${mark}?method=changeDocMarkDef',
				params: {definitionId: $(this).val()},
				success: function(json) {
					var options = "";
					for (var i = 0; i < json.length; i++) {	
						options += '<option title="' + json[i].optionName + '" value="' + json[i].optionValue + '" markNumber="' + json[i].optionMarkNumber + '" yearNo="' + json[i].optionYearNo + '">' + escapeStringToHTML(json[i].optionName) + '</option>';
					}
					$("select#chooseId").html(options);
				}
			};
			getJetspeedJSON(options);
		});
		
		$('select#definitionIdReserve').change(function() {
			var options = {
				url: '${mark}?method=changeDocMarkDefReserve&edocId=${param.edocId}',
				params: {definitionId: $(this).val()},
				success: function(json) {
					var options = "";
					for (var i = 0; i < json.length; i++) {
						options += '<option title="' + json[i].optionName + '" value="' + json[i].optionValue + '" markNumber="' + json[i].optionMarkNumber + '" yearNo="' + json[i].optionYearNo + '">' + escapeStringToHTML(json[i].optionName) + '</option>';
					}
					$("select#chooseIdReserve").html(options);
				}
			};
			getJetspeedJSON(options);
		});
		
		if("${serialNoFenduanFlag}" == "true" || "${signMarkFenduanFlag}"=="true") {
			setModeChecked("2");
		}
	});
	
	function doIt() {
		var arr = new Array();
		var mode = document.getElementsByName("mode");
		if (mode[0].checked) {
			if (myform.chooseId.options.selectedIndex == -1) {
				if("${personInput}"=="false" || "${docMarkFenduanFlag}"=="true") {
					alert(v3x.getMessage('edocLang.doc_mark_alter_not_select_not_allow_edit'));
				} else {
					alert(v3x.getMessage('edocLang.doc_mark_alter_not_select'));
				}
				return false;
			}
			
			var chooseIdOption = myform.chooseId.options[myform.chooseId.options.selectedIndex];
			var definitionIdOption = myform.definitionId.options[myform.definitionId.options.selectedIndex];
			var a = definitionIdOption.value;
			var b = chooseIdOption.text;
			arr[0] = a + "|" + b + "|" + chooseIdOption.getAttribute("markNumber") + "|2";
			arr[1] = b;
			arr[3] = b + definitionIdOption.getAttribute("_shotAccountName");
			arr[4] = definitionIdOption.value;
			arr[5] = chooseIdOption.getAttribute("yearNo");
		}
		else if(mode[1].checked) {
			if (myform.chooseIdReserve.options.selectedIndex == -1) {
				if("${personInput}"=="false" || "${docMarkFenduanFlag}"=="true") {
					alert(v3x.getMessage('edocLang.doc_mark_reserve_alter_not_select_not_allow_edit'));
				} else {
					alert(v3x.getMessage('edocLang.doc_mark_reserve_alter_not_select'));
				}
				return false;
			}
			var chooseIdOption = myform.chooseIdReserve.options[myform.chooseIdReserve.options.selectedIndex];
			var definitionIdOption = myform.definitionIdReserve.options[myform.definitionIdReserve.options.selectedIndex];
			var a = chooseIdOption.value;
			var b = chooseIdOption.text;
			
			arr[0] = a + "|" + b + "|" + chooseIdOption.getAttribute("markNumber") + "|4";
			arr[1] = b;
			arr[3] = definitionIdOption.getAttribute("_shotAccountName");
			arr[4] = definitionIdOption.value;
			arr[5] = chooseIdOption.getAttribute("yearNo");
		} else {
			if (myform.hand_write.value.trim() == "") {
				if("${param.selDocmark}" == "my:serial_no") {
					alert("请输入一个内部文号");
				} else if("${param.selDocmark}" == "my:sign_mark") {
					alert("请输一个签收编号");
				} else {
					alert(v3x.getMessage('edocLang.doc_mark_alter_not_write'));	
				}
				myform.hand_write.value = "";
				myform.hand_write.focus();
				return false;
			}
			//OA-44762处理公文时，公文文号手动输入特殊字符后，报JS
			//文号不能输入特殊字符
			if(/[\\|'"@#￥%]/.test(myform.hand_write.value.trim())) {
                alert(_("edocLang.edoc_mark_isnotwellformated"));
                return false;
            }
			arr[0] = "0|" + myform.hand_write.value + "||3";
			arr[1] = myform.hand_write.value;
		}
		arr[2]=myform.selmark[0].checked?"my:doc_mark":"my:doc_mark2";
		return arr;
	}
	
	 document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];
             if(e && e.keyCode==13){ // enter 键
               var parentDialog = window.parentDialogObj["markDialog"].getTransParams();  
               parentDialog.dialogSure(parentDialog.obj);
            }
     }; 
	
	function OK(){
		return doIt();
	}

//点击断号表中的选项，输入框中输入默认的值
function onselect2(V){   

	if(V.selectedIndex!=-1){
	     var selectedOption=V.options[V.selectedIndex];   
	        
	     var handWriteObj=document.getElementById("hand_write");   
	   
	     handWriteObj.value=selectedOption.text;   
     }
} 

function closeWin1() {
    transParams.parentWin.openMarkChooseWindowWin.close();
}

//-->
</script>
<style>

@-moz-document url-prefix() {
#hand_write{
    margin-top:30px;
}
}
</style>

</head>
<body scroll="no">
<form name="myform" onSubmit="return doIt();">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="popupTitleRight">
	
	<tr style="display:${!(serialNoFenduanFlag||signMarkFenduanFlag) ? '0':'none'}"><%-- 公文断号选择 --%>
		<td height="10px" class="PopupTitle">
			<fmt:message key="edoc.docmark.chooseallmark" />
		</td>
	</tr>
	
	<tr height="16px;" style="display:${!(serialNoFenduanFlag||signMarkFenduanFlag) ? '0':'none'}"><%-- 断号选择 --%>
		<td height="10px;" class="padding010">
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="50%" nowrap="nowrap" height="10">
							<input type="radio" id="mode0" name="mode" onClick="changeMode();" checked="true">
							<a href="javascript:setModeChecked('0')">
								<label for="mode0"><fmt:message key="edoc.mark.input.chosetype" /></label>
							</a>
					</td>
				</tr>
			</table>
		</div>	
		</td>
	</tr>
	
	<tr height="140px" style="display:${!(serialNoFenduanFlag||signMarkFenduanFlag) ? '0':'none'}"><%-- 断号选择下拉框 --%>
		<td valign="top" class="padding010">
			<div id="select_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">	
			    <tr>			
					<td class="new-column" width="420px" nowrap="nowrap">
						<select id="definitionId" name="definitionId" class="input-100per" style="margin:6px 0;">
							<c:forEach items="${markDefs}" var="markDef">
								<option _shotAccountName="<c:out value="${markDef.accountShotName}" escapeXml="true" />" title='<c:out value="${markDef.wordNo}" escapeXml="true" /><c:out value="${markDef.accountShotName}" escapeXml="true" />' value="${markDef.markDefinitionId}">
								  <c:out value="${markDef.wordNo}" escapeXml="true" /><c:out value="${markDef.accountShotName}" escapeXml="true" />
								</option>
							</c:forEach>
						</select>
					</td>
				</tr>

				<tr>
				<td class="new-column" width="75%" nowrap="nowrap">
					<select id="chooseId" name="chooseId" size="${param.edocType=='0'?'8':'16'}"  class="input-100per" onclick="onselect2(this)">
						<c:forEach items="${edocMarks}" var="edocMark">
							<option title='<c:out value="${edocMark.markNo}" escapeXml="true" />' value="${edocMark.edocMarkId}" 
								markNumber="${edocMark.markNumber}" 
								yearNo="${edocMark.yearNo }" 
								yearEnabled="${edocMark.yearEnabled }" 
								twoYear="${edocMark.twoYear }" 
								markLength="${edocMark.markLength }">${ctp:toHTML(edocMark.markNo)}</option>
						</c:forEach>
					</select>
					</td>	
				</tr>
			</table>
			</div>
		</td>
	</tr>
	
	<tr height="16px" style="display:${param.edocType=='0'?'':'none'}"><%-- 预留文号选择下拉框 --%>
		<td height="10px;" class="padding010" style="padding-top:10px;">
		<div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="50%" nowrap="nowrap" height="10">
							<input type="radio" id="mode1" name="mode" onClick="changeMode();">
							<a href="javascript:setModeChecked('1')">
								<label for="mode1"><fmt:message key="edoc.mark.reserve.up" /></label>
							</a>
					</td>
				</tr>
			</table>
		</div>	
		</td>
	</tr>
	
	<tr height="140px" style="display:${param.edocType=='0'?'':'none'}"><%-- 预留文号选择下拉框 --%>
		<td valign="top" class="padding010">
			<div id="selectReserve_div">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">		
				<tr>		
					<td class="new-column" width="75%" nowrap="nowrap">
						<select id="definitionIdReserve" name="definitionIdReserve" class="input-100per"  style="margin:6px 0;">
							<c:forEach items="${markDefs}" var="markDef">
							    <c:if test="${markDef.categoryCodeMode eq 0}">
								    <option _shotAccountName="<c:out value="${markDef.accountShotName}" escapeXml="true" />" title='<c:out value="${markDef.wordNo}" escapeXml="true" /><c:out value="${markDef.accountShotName}" escapeXml="true" />' value="${markDef.markDefinitionId}">
								        <c:out value="${markDef.wordNo}" escapeXml="true" /><c:out value="${markDef.accountShotName}" escapeXml="true" />
								    </option>
								</c:if>
							</c:forEach>
						</select>
					</td>
				</tr>

				<tr>
				<td class="new-column" width="75%" nowrap="nowrap">
					<select id="chooseIdReserve" name="chooseIdReserve" size="8"  class="input-100per">
						<c:forEach items="${reserveNumberList}" var="reserveNumber">
							<option title='<c:out value="${reserveNumber.docMark}" escapeXml="true" />' 
								value="${reserveNumber.markDefineId}" 
								markNumber="${reserveNumber.markNoVo.markNo}" 
								yearNo="${reserveNumber.markNoVo.yearNo }" 
								yearEnabled="${reserveNumber.markNoVo.yearEnabled }" 
								twoYear="${reserveNumber.markNoVo.twoYear }" 
								markLength="${reserveNumber.markNoVo.markLength }">${ctp:toHTML(reserveNumber.docMark)}</option>
						</c:forEach>
					</select>
					</td>	
				</tr>
			</table>
			</div>
		</td>
	</tr>
	
	<tr height="10px" style="display:${(!docMarkFenduanFlag||signMarkFenduanFlag) ? '0':'none'}">
		<td class="new-column padding010" width="50%" nowrap="nowrap" style="padding-top:10px;">
			<div style="display:${isBoundWordNo == 'true' or !personInput ? 'none' :'block'}" >
				<input type="radio" id="mode2" name="mode" onClick="changeMode();" ${personInput?'':'disabled'}>
				<a href="javascript:setModeChecked('2')">
					<c:choose>
						<c:when test="${serialNoFenduanFlag }">
							<label for="mode2">内部文号输入</label>
						</c:when>
						<c:when test="${signMarkFenduanFlag }">
							<label for="mode2">签收编号输入</label>
						</c:when>
						<c:otherwise>
							<label for="mode2"><fmt:message key="edoc.mark.input.handtype" /></label>
						</c:otherwise>
					</c:choose>
				</a>
			</div>
		</td>
	</tr>
	
	<tr height="30px" style="display:${(!docMarkFenduanFlag||signMarkFenduanFlag) ? '0':'none'}">
		<td class="padding010">
			<div id="input_div" style="display:none">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="new-column" nowrap="nowrap">
						<!-- <fmt:message key='edoc.mark.input.plea' /> ：-->
						<input type="text" name="hand_write"  id="hand_write" onKeyPress="" class="input-300px lastInput">
					</td>	
				</tr>
			</table>
			</div>
		</td>
	</tr>

	<tr style="display:${param.twoDocmark=='true'?'block':'none'}">
		<td class="padding010">
			<div id="selDocmark_div" style="display:${param.twoDocmark=='true'?'block':'none'}">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td class="new-column" nowrap="nowrap">	
						<label for="selmark1">					
							<input type="radio" id="selmark1" name="selmark" checked  ${personInput?'':'disabled'}><fmt:message key="edoc.element.wordno.label" />
						</label>
						</td>
						<td>
						<label for="selmark2">
						<input type="radio" id="selmark2" name="selmark" ${param.selDocmark=='my:doc_mark2'?'checked':''}><fmt:message key="edoc.element.wordno2.label" />
						</label>
						</td>	
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>

</form>
</body>
</html>