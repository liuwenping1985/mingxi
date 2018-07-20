<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style type="text/css">
.style1 {
	text-align: left;
}

.style3 {
	text-align: center;
}
</style>
<%@ include file="../exchangeHeader.jsp"%>
<title><fmt:message key='exchange.account.add' /></title>
</head>
<body scroll='no' onkeydown="listenerKeyESC()">
<form action="" id="form1" method="POST">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><fmt:message key='exchange.account.add' /></td>
	</tr>
	<tr>
		<td class="bg-advance-middel" height="100%">
		<div class="scrollList">
		<table width="100%" height="40%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
								<td height="30" class="style1" colspan="2">
								<fmt:message key='exchange.account.externalAccount'/>:</td>
			</tr>

			<tr>
								<td height="30" align="right" class="style1">
								<input id="externalUnitName" name="externalUnitName"
									 style="width: 300px" type="text" inputName="<fmt:message key='exchange.account.externalAccount'/>"
					maxSize="50" validate="notNull,maxLength"></td>
				<input style="display: none;"></input>
								<td class="style3">
								<input name="add" type="button" onclick="addExtenalAccount()" value="<fmt:message key='exchange.account.addlabel'/>"></td>
			</tr>
			<tr>
				<td height="30" class="style1" colspan="2">联系人:</td>
			</tr>
			<tr>
				<td colspan="2"><input size="49" name ="relName" id ="relName" value=""/></td>
			</tr>
			<tr>
				<td height="30" class="style1" colspan="2">联系电话:</td>
			</tr>
			<tr>
				<td colspan="2"><input size="49" name ="telphone" id ="telphone" value=""/></td>
			</tr>
			<tr>
								<td height="30" class="style1" colspan="2">
								<fmt:message key='exchange.account.added' />：</td>
			</tr>

			<tr>
								<td height="30" class="style1" style="width: 118px">
								<select id="externalUnitSel" name="externalUnitSel" onchange="showDel()" style="width: 300px" multiple="multiple">
				</select></td>
								<td class="style3">
								<input name="del" id="del" onclick="delSelectedAcconut()" type="button" disabled="true" value="<fmt:message key='exchange.account.del' />"></td>
			</tr>
		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="right" class="bg-advance-bottom">
			<input type="button" onclick="subminForm()" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;
			<input type="button" onclick="commonDialogClose('win123')" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2"> 
		</td>
	</tr>
</table>
</form>
</body>
<script language="JavaScript">
	var currentMemberId = '${currentMemberId}';
	function addExtenalAccount() {
		if (!checkForm(document.getElementById("form1"))) {
			return;
		}
		var extenalAccountStr = document.forms[0].externalUnitName.value;
		if (extenalAccountStr == "" || extenalAccountStr == null) {
			alert(v3x.getMessage("ExchangeLang.outter_unit_name_input_error"));
			return;
		}

		try {
			var requestCaller = new XMLHttpRequestCaller(this, "exchangeAccountManager", "containExternalAccount", false);
			requestCaller.addParameter(1, 'String', extenalAccountStr);
			requestCaller.addParameter(2, "long", '${domainId}');
			rs = requestCaller.serviceRequest();
		}
  		catch (ex1) {
			alert("Exception : " + ex1);
		}
		if ("false" == rs) {
			var isPageRe = false;
			var selectObj = document.forms[0].externalUnitSel;
			for ( var i = 0; i < selectObj.length; i++) {
				if (extenalAccountStr == selectObj[i].text) {
					document.forms[0].externalUnitName.value = "";
					isPageRe = true;
					break;
				}
			}
			if (isPageRe) {
				alert(v3x.getMessage("ExchangeLang.outter_unit_alter_add_repetition"));
			} else {
				var extenalAccountOption = document.createElement('option');
				extenalAccountOption.text = extenalAccountStr;
				selectObj.add(extenalAccountOption);
			}
			document.forms[0].externalUnitName.value = "";
		} else {
			document.forms[0].externalUnitName.value = "";
			alert(v3x.getMessage("ExchangeLang.outter_unit_alter_add_repetition"));
		}
	}
	function showDel() {
		var selectObj = document.forms[0].externalUnitSel;
		var selOptiongSize = selectObj.options.length;
		if (selOptiongSize > 0) {
			var delBtnObj = document.forms[0].del;
			delBtnObj.disabled = false;
		}
	}
	function delSelectedAcconut() {
		var ops = document.forms[0].externalUnitSel;
		for ( var i = 0; i < ops.length; i++) {
			if (ops[i].selected) {
				document.getElementById("externalUnitSel").remove(i);
				i--;
			}
		}
	}

	
    function ValiTel(telphone){
    	var regBox = {
        	regMobile : /^1\d{10}$/
	    }
	    var mflag = regBox.regMobile.test(telphone);
    	if(telphone==""||telphone==null){
    		return true;
    	}
	    if (!mflag) {
	        return false;
	    }else{
	        return true;
	    };
    }

	function subminForm() {
		var telphone = $("#telphone").val();
			var relName = $("#relName").val();
			var type = transParams._window.Constants_ExchangeAccount;
			var id = type + "DataBody";
			var Area1Obj = transParams._window.Area1;
			//取得外部单位所在的select对象
			var extenalAccountListObj = Area1Obj.firstChild;
			//取得select的options
			var optionArray = extenalAccountListObj.options;
			var parentDocument = transParams._window.document;
			var selectObj = document.forms[0].externalUnitSel;
			var selOptiongSize = selectObj.options.length;
			if (selOptiongSize > 0) {
				var extenalAccountStr = "";
				for ( var i = 0; i < selOptiongSize; i++) {
					var paerntOption = parentDocument.createElement('option');
					var optionObj = selectObj.options[i];
					if (i == 0) {
						extenalAccountStr = optionObj.text;
					} else {
						extenalAccountStr = extenalAccountStr + "↗" + optionObj.text;
					}
				}
				try {
					var requestCaller = new XMLHttpRequestCaller(this, "exchangeAccountManager", "batchCreate", false);
					requestCaller.addParameter(1, 'String', extenalAccountStr);
					requestCaller.addParameter(2, "String", "");
					requestCaller.addParameter(3, "String", relName);
					requestCaller.addParameter(4, "String", telphone);
					rs = requestCaller.serviceRequest();
				}
		  		catch (ex1) {
					alert("Exception : " + ex1);
				}
		  		transParams._callbackRefresh();
				commonDialogClose('win123');
			} else {
				alert(v3x.getMessage("ExchangeLang.outter_unit_alter_add_null"));
			}
	}
</script>
</html>