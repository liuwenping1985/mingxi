<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script>

var appType = "${formVO.appType}";
var optionFormatSet = "${formVO.optionFormatSet}";
var currentUserDomainId = ${currentUser.loginAccount};
var isMyDomain = "${currentUser.loginAccount==formVO.domainId}"=="true";
var formIsSystem = "${formVO.isSystem}"=="true";
var _editFlag = "${ctp:escapeJavascript(param.editFlag)}";
var _isSubmitting = false;//全局变量，标注是否正在提交，直接按钮置灰同样可能导致重复提交

$(document).ready(function () {
	
	if(!isGroup) {
		$("#authLabelTr").hide();
		$("#authDataTr").hide();
	}
	
	loadDisabledData();
	
	//上传发文单 
	if('${operType}' == 'add'){
		newUploadForm();
	}
	
	infoFormDisplay();
	
	$("#formShow").click(function() {
		if(!$(this).hasClass("current")) {
			$("#formSet").removeClass("current");
			$(this).addClass("current");
			$("#fieldOne").show();
			$("#fieldTwo").hide();
		}
	});
	
	$("#formSet").click(function() {
		if(!$(this).hasClass("current")) {
			$("#formShow").removeClass("current");
			$(this).addClass("current");
			$("#fieldOne").hide();
			$("#fieldTwo").show();
		}
	});
	
	$("#elementRequired").find("input[fieldName='subject']").val(1);
	$("#elementRequired").find("input[fieldName='category']").val(1);
	$("#elementRequired").find("input").click(function() {
		var elementId = $(this).attr("elementId");
		if($(this).attr("checked")=="true" || $(this).attr("checked")=="checked") {//如果被选中
			$(this).val(1);
			$("#elementId_"+elementId).val(1);
		} else {
			$(this).val(0);
			$("#elementId_"+elementId).val(0);
		}
	});
	
	$("#edit_cancel_button").click(function() {
		parent.location.reload();
	});
	
	$("#edit_confirm_button").click(function() {
		
		//Ajax验证不通过时，无法修改_isSubmitting的值，将此注释掉，但是快速点击可能造成多次提交
		//if(_isSubmitting){//正在执行提交
		//	return;
		//}
		_isSubmitting = true;//开始提交
		
		var attachmentInputs = document.getElementById("attachmentInputs");
	    var form = $("#dataForm");
		if(!checkForm(form)) {
			_isSubmitting = false;
			return;//验证form
		}
		var xml = document.getElementById("xml");
		var xsl = document.getElementById("xsl");
		if(xml ==null || xsl==null || xml.value=="" || xsl.value ==""){
			$.alert($.i18n('govform.info.alert.chooseInfoformFile'));//请先上传一个报送单样式文件
			_isSubmitting = false;
			return false;
		}
		submitForm();
	});

	//提交后保存公文单信息
	var attFileDomain = document.getElementById("attFileDomain");
	if(attFileDomain) {
		attFileDomain.innerHTML = "${v3x:escapeJavascript(param.attachmentStr)}";
	}
	
	if(_editFlag != "true"){
		var tempLayout = $("#layout").layout();
		tempLayout.setSouth(0);
	}
});

function loadDisabledData() {
	viewDownUp();
	if("${ctp:escapeJavascript(param.editFlag)}"!="true") {
		$(".form_area").find("input").each(function(index, elem) {
			$(this).attr("disabled", "true");
		});
		$(".form_area").find("select").each(function(index, elem) {
			$(this).attr("disabled", "true");
		});
		$("#description").attr("readOnly", "true");
	} else {
		$("#settingTable2").find("input").each(function(index, elem) {
			if(formIsSystem) {
				if($(this).attr("type")=="button") {
					$(this).attr("disabled", "true");	
				}
			} else {
				if($(this).attr("name")=="button_otherOpinion") {
					$(this).attr("disabled", "true");	
				}
			}
		});
		if('${operType}' == 'modify') {
			if(isMyDomain) {//当前单位
				if(formIsSystem) {//系统
					$("#name").attr("disabled", true);
				}
				$("#description").removeAttr("readOnly");
			} else {//外单位
				$("#name").attr("disabled", true);
				$("#description").attr("readOnly", "true");
			}
		} else {//新建
			$("#description").removeAttr("readOnly");
		}
		if(isMyDomain && !formIsSystem) {
			authGovForm();
		}
	}
}

function viewDownUp() {
	var fileId = "${attachment.fileUrl}";
	var createdate = "${createdate}";
	var filename = "${attachment.filename}";
	var type = $("#type").val();
	if(type == "") {
		type = "${paramMap.type}";
	}
	var aHtml = "<A HREF=\"/seeyon/fileDownload.do?method=download&appType="+appType+"&isSystemForm="+formIsSystem+"&formType="+type+"&fileId="+fileId+"&v=${attachment_v}&createDate="+createdate+"&filename="+encodeURI(filename)+"\" target=\"temp_iframe\" \>${ctp:i18n('addressbook.toolbar.download.label')}</A>";
	$("#downFormDiv").html(aHtml);
	
	if("${ctp:escapeJavascript(param.editFlag)}"!="true") {
		$("#upForm").hide();
		$("#downFormDiv").show();
		$("#shu").hide();
	} else {
		if('${operType}' == 'modify') {
			if(isMyDomain) {//当前单位
				if(formIsSystem) {//系统
					$("#upForm").hide();
					$("#downFormDiv").show();
					$("#shu").hide();
				} else {//用户
					$("#upForm").show();
					$("#downFormDiv").show();
					$("#shu").show();
				}
			} else {//外单位
				$("#upForm").hide();
				$("#downFormDiv").show();
				$("#shu").hide();
			}
		} else {
			$("#upForm").show();
			$("#downFormDiv").hide();
			$("#shu").hide();
		}
	}
}

function setFormData_beforeSubmit() {
	$("#isDefault").val($("input[name='isDefault0']:checked").val());
	$("#status").val($("input[name='status0']:checked").val());
	$("#dataForm").append("<input type='hidden' name='listStr' value='${listStr}' />");
}

function checkFormData_beforeSubmit() {
	setFormData_beforeSubmit();
	reloadFormatSet_beforeSubmit();
	if($("#name").val() != "") {
    	var manager = new govformAjaxManager();
		var obj = new Object();
		obj.formId = $("#formId").val();
		obj.appType = appType;
		obj.type = $("#type").val();
		obj.name = $("#name").val();
		var msg = manager.ajaxCheckFormName(obj);
		if(msg == true) {
			$.alert($.i18n('govform.info.alert.renameInfoform'));//报送单名称已经存在,请重新命名
			return false;
		}
		if($("#isDefault").val()=="1" && $("#status").val()=="0") {
			$.alert($.i18n('govform.info.alert.infoformWrongUse'));//报送单使用状态错误,默认报送单不能设置成停用状态！
			return false;
		}
		if($("#description").val().length > 80) {
			$.alert("报送单描述长度不能大于80个字。");
			return false;
		}
	}
	return true;
}

function submitForm() {
	if(!checkFormData_beforeSubmit()) {
		_isSubmitting = false;
		return;
	}
	var form = $("#dataForm");
	if($("#formId").val()=="0") {//新建
	    form.attr("action", _ctxPath + "/govform/govform.do?method=saveForm");
	} else {//修改
	    form.attr("action", _ctxPath + "/govform/govform.do?method=updateForm");
	}
	form.jsonSubmit({
        validate : true,
        errorIcon : true,
        beforeSubmit : function() {
        	$("#edit_confirm_button").attr("disabled", true);
        	$("#edit_cancel_button").attr("disabled", true);
        },
        callback:function(args) {
        	_isSubmitting = false;
        	if(args == "success" || args.indexOf("success")>=0) {
        		parent.location.reload();	
        	}
        }
    });
}

function reloadFormatSet_beforeSubmit() {
	var showLastOptionOnly = "1";
	var showDeptOrgn = "0";
	var dealTimeFormt = "0";
	var optionTypeVal = $('input:radio[name="optionType"]:checked').val();
	var showOrgnDeptVal = $('input:radio[name="showOrgnDept"]:checked').val();
	var dealTimeFormtVal = $('input:radio[name="dealTimeFormt"]:checked').val();
	showLastOptionOnly = optionTypeVal;
	if(optionTypeVal==null || optionTypeVal=="") {
		showLastOptionOnly = "1";
	}
	var optionType = optionTypeVal;
	if(showLastOptionOnly == "3") {
		showLastOptionOnly = "1";
	} else if(showLastOptionOnly == "4") {
		showLastOptionOnly = "2";
	} else {
		optionType = "0";
	}
	if("0" == showOrgnDeptVal) {
		showDeptOrgn = "0";
	} else if("1" == showOrgnDeptVal) {
		showDeptOrgn = "1";
	} else if("2" == showOrgnDeptVal) {
		showDeptOrgn = "2";
	}
	if(dealTimeFormtVal=="" || dealTimeFormtVal=="1") {
		dealTimeFormt = "1";
	}
	optionFormatSet = showLastOptionOnly + ","+showDeptOrgn+"," + dealTimeFormt+","+optionType;
	$("#optionFormatSet").val(optionFormatSet);
}

function infoFormDisplay(){
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	//buttondnois();
	document.getElementById("content").value = xsl.value;
	if(xml.value!="" && xsl.value!="") {
		try{
			initSeeyonForm(xml.value, xsl.value);
			autoWidthAndHeight(true);
			//setObjEvent();
		}catch(e){
			$.alert("信息单数据读取出现异常! 错误原因 : "+e);
			return false;
		}
		//substituteLogo(logoURL);
		return false;
	} else {
		autoWidthAndHeight(false);
	}
}

function autoWidthAndHeight(isLoadForm) {
	var formBottomHeight = 35;
	if(isLoadForm) {
		
		//OA-68237 兼容多行的高度问题
		var htmlChildDivs = $("#html").children("div");
		var height = 0;
		for(var i = 0; i < htmlChildDivs.length; i++){
			height += $(htmlChildDivs[i]).height();
		}
		
		$("#html").height(height);
		$("#fieldset").height($("#html").height() + 35);
		$("#formTable1").height($("#fieldset").height());
		
		var length = ${fn:length(processList)};
		var lineHeight = 25;
		var paddingTop = 10;
		var paddingBottom = 10;
		var noteTableHeight = $("#noteTable").height();
		$("#settingTable2").height(lineHeight * (length+1));
		$("#settingDiv2").height(paddingTop + lineHeight*(length+1) +  noteTableHeight + paddingBottom);
		var moreHeight = 0;
		if($("#formTable1").height() < $("#formTable2").height()) {
			moreHeight = $("#leftTable").height();
		} else {
			moreHeight = $("#formTable1").height();
		}
		$("#formDiv").height(moreHeight + 25);
		$(".stadic_content").height($("#formDiv").height() + formBottomHeight);
		$(".stadic_right").height($("#formDiv").height() + formBottomHeight);
	} else {
		var leftHeight = $("#leftTable").height();
		var commonTabHeight = $("#common_tabs").height();
		$(".stadic_right").height(leftHeight);
		$(".stadic_content").height(leftHeight);
		$("#formDiv").height(leftHeight -  commonTabHeight - formBottomHeight);
		$("#fieldTwo").height($("#formDiv").height());
	}
}

function authGovForm() {
	$("#authUnitNames").bind("click", function() {
		$.selectPeople({
			text : $.i18n('common.default.selectPeople.value'),
			value : $("#authUnitIds").val(),
	        type : 'selectPeople',
	        panels : 'Account',
	        selectType : 'Account',
	        hiddenPostOfDepartment:true,
	        hiddenRoleOfDepartment:true,
	        showFlowTypeRadio:false,
	        returnValueNeedType: false,
	        minSize: 0,
	        params : {
	           value : $("#authUnitIds").val()
	        },
	        targetWindow:getCtpTop(),
	        callback : function(res){
	        	if(res && res.obj) {
	        		if(res.value != "") {
	        			var valueArr = res.value.split(",");
	        			var textArr = res.text.split("、");
						var zddr_ids = "";
						var zddr_names = "";
						if(valueArr.length > 0) {
							for(var co = 0 ; co<valueArr.length ; co ++) {
								zddr_ids += "Account|"+valueArr[co] + ",";
								zddr_names += textArr[co]+"、";
							}
							if(zddr_ids.length > 0){
								zddr_ids = zddr_ids.substring(0, zddr_ids.length - 1);
								zddr_names = zddr_names.substring(0, zddr_names.length - 1);
							}
						}
	        		} else {
						zddr_ids = "";
						zddr_names = "";
					}
					$("#authUnitIds").val(zddr_ids);
					$("#authUnitNames").val(zddr_names);
	        	}
	        }
	    });
	});
}

/**
 * 插入附件回调
 */
function insertAtt_attEditCallback(){
    
    var atts = fileUploadAttachments.values();
    if(atts == "") {
        return false;
    }
    $("#attFileDomain").html("");
    saveAttachmentPart("attFileDomain");
    //因为需要提交页面，所以要将附件信息传递到后续页面，直接将saveAttachment产生的串传递
    var attachmentStr = document.getElementById("attachmentStr");
    var attFileDomain = document.getElementById("attFileDomain");
    if(attFileDomain && attachmentStr) {
        attachmentStr.value = attFileDomain.innerHTML;
    }
    var form=document.getElementById("dataForm");
    for(var i = 0; i< atts.size(); i++){
        var att = atts.get(i);
        document.getElementById("att_fileUrl").value = att.fileUrl;
        document.getElementById("att_createDate").value = att.createDate;
        document.getElementById("att_mimeType").value = att.mimeType;
        document.getElementById("att_filename").value = att.filename;
        document.getElementById("att_needClone").value = att.needClone;
        document.getElementById("att_description").value = att.description;
        document.getElementById("att_type").value = att.type;
        document.getElementById("att_size").value = att.size;
        
        var field = document.createElement("input");
        field.setAttribute('type','hidden');
        field.setAttribute('name','fileUrl');
        field.setAttribute('value',att.fileUrl);
        form.appendChild(field);

        var field1 = document.createElement("input");
        field1.setAttribute('type','hidden');
        field1.setAttribute('name','fileCreateDate');
        field1.setAttribute('value',att.createDate);
        form.appendChild(field1);

        var field2 = document.createElement("input");
        field2.setAttribute('type','hidden');
        field2.setAttribute('name','fileMimeType');
        field2.setAttribute('value',"'"+att.mimeType+"'");
        form.appendChild(field2);

        var field3 = document.createElement("input");
        field3.setAttribute('type','hidden');
        field3.setAttribute('name','filename');
        field3.setAttribute('value',att.filename);
        form.appendChild(field3);
        //lijl添加,3月修复包中支持ie10-------------------End
        document.getElementById("file_name").value = att.filename;
    }
    setFormData_beforeSubmit();
    form.action = _ctxPath + "/govform/govform.do?method=uploadForm&appType="+$("#appType").val();
    form.submit();
}

function newUploadForm() {
	insertAttachmentPoi('Att');
}

var choosePermissionDialog;
function choosePermission(flowpermName,processName) {
	if(flowpermName == "") {
		flowpermName = processName;
	}
	var type = document.getElementById("type");
	choosePermissionDialog = $.dialog({
        url: "${path}/govform/govform.do?method=openOperationChoose&appType="+appType+"&type="+type.value+"&flowpermName="+encodeURI(flowpermName)+"&processName="+encodeURI(processName),
        width: 380,
        height: 460,
        title: $.i18n('govform.label.nodeBindPermission'),//节点权限绑定
        targetWindow:getCtpTop(),
        transParams: window,
        callback : function(res) {
        	if(res) {
        		reloadPermission(res);
        	}
        	choosePermissionDialog.close();
        }
    });
}	

function reloadPermission(receivedObj, flowpermName, processName) {
	var oper_str = "";
	var ele = null;
	var value = "";
	var eleOpt = null;
	var returnOptValue = "";
	//首先取出该处理意见所绑定的权限名称
	var array = new Array();
	var newArray = new Array();
	var operation_str = document.getElementById("operation_str");
	//根据boundName(shenpi,niwen,...)动态拼接成元素的Id
	var choosedOperation_processName = document.getElementById("choosedOperation_"+processName);
	if(choosedOperation_processName!=null && choosedOperation_processName.options!=null 
			&& choosedOperation_processName.options.length!=0) {
	 	for(var x=0;x<choosedOperation_processName.options.length;x++) {
	 		if(choosedOperation_processName.options[x].getAttribute("itemList")) {
	    	 	var temp_str = choosedOperation_processName.options[x].getAttribute("itemList").split(",");
	    	 	if(temp_str.length>=1){
	    	 		for(var i=0;i<temp_str.length;i++){
	    	 			array[x] = temp_str[i];
	    	 			x++;
	    	 		}
	    	 	}
	    	} else {
	    		var tempValue = choosedOperation_processName.options[x].value;
				array[x] = tempValue;
	    	}
	  	}
	}
	if(receivedObj!=null && choosedOperation_processName!=null) {
		//ele = document.getElementById(flowpermName);
		ele = document.getElementById(processName);
		choosedOperation_processName.length = 0;
	  	var option = null;
	  	for(var i=0;i<receivedObj.length;i++){
	  		option=document.createElement("OPTION");
     		choosedOperation_processName.options.add(option);
	 		option.value=receivedObj[i][0];
	  		option.text=receivedObj[i][1];
	  		value += receivedObj[i][1];
	  		value += ",";
	  		returnOptValue += receivedObj[i][0];
	  		returnOptValue += ",";
	  		oper_str += "("+receivedObj[i][0]+")";
	  		if(operation_str.value.indexOf(receivedObj[i][0]) == -1) {
	  			operation_str.value += "("+receivedObj[i][0]+")";
	  		}
	 	}
	  	if(ele!=null) {
	  	   	ele.value = value.substring(0, value.length-1);
	  	}
	  	returnOptValue =  returnOptValue.substring(0,returnOptValue.length-1);
	  	document.getElementById("returnOperation_"+processName).value = returnOptValue;
	  	
	  	//把返回的结果与选择之前的结果相比，如果之前含有的权限没有了，即撤销了选择，存入一个新的newArray中
	  	for(var i=0;i<array.length;i++){
			var m = oper_str.indexOf(array[i]);
	  	   	if(m == -1){
	  	   		newArray[i] = array[i];
	  	   	}
		}
	    //operation_str.value += oper_str;
	    var new_operation = operation_str.value;
	    //在节点权限已选择池中依次相比，如果发现有newArray(撤销的权限)，从选择池中删除，下次再次点击选择权限就不会判断撤销的权限
	    for(var i=0;i<newArray.length;i++) {
	    	new_operation = new_operation.replace("("+newArray[i]+")", "");
	    }
	    //已选择池赋值
	    operation_str.value = new_operation;
	}
}

//
function onmouseoutA(obj) {
	$(obj).removeClass("color_red");	
	$(obj).addClass("color_blue");	
}

function onmouseoverA(obj) {
	$(obj).removeClass("color_blue");	
	$(obj).addClass("color_red");	
}

</script>