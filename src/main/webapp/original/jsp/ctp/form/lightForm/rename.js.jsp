<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
	var xmlString = "";
	var dialogParam = window.parentDialogObj["formInputChooseRenameDialog"].getTransParams();
	var parentWin = dialogParam[0].document;
	var rightData = dialogParam[1];
	var type = dialogParam[2];
	var treeYesObje = dialogParam[3];

	function showlabelvalue() {
		var querytext = "";
		var queryDataArea = parentWin.getElementById("rightdataarea");
		var labelObj = document.getElementById("rowheader");
		var titleObj = document.getElementById("title");
		if (queryDataArea.selectedIndex < 0){
			return;
		}else {
			querytext = queryDataArea.options[queryDataArea.selectedIndex].text;
			$("#fieldName").val(queryDataArea.options[queryDataArea.selectedIndex].value);
			if (querytext.indexOf("(") != -1) {
				labelObj.innerText = querytext.substring(0, querytext
						.indexOf("("));
				titleObj.value = querytext.substring(
						querytext.indexOf("(") + 1, querytext.indexOf(")"));
			} else {
				labelObj.innerText = querytext;
				titleObj.value = querytext;
			}
			//字段数据类型
			var _inputType = $("#inputType").val();
			
			//判断是否为组织控件
			var isOrgType = _inputType == 'member' || _inputType == 'multimember' || _inputType == 'account' || _inputType == 'multiaccount' 
				|| _inputType == 'department' || _inputType == 'multidepartment';
			
			//设置默认值
			var selectedObj = $(queryDataArea).find("option:selected");
			var renameJSON = selectedObj.attr("renameJSON");
			if($.trim(renameJSON) != ""){
				var jsonObj = $.parseJSON(renameJSON);
				if(_inputType == 'checkbox'){
					//复选框类型
					//前置标签
					$("#default_checkbox_front").val(jsonObj.frontlabelVal);
					//缺省设置
					$("#default_checkbox_select").val(jsonObj.defaultVal);
				}else if(_inputType == 'select' || _inputType == 'radio'){
					//下拉枚举类型
					//树形条件
					if(jsonObj.defaultVal == '1'){
						$("#treeYes").attr("checked","checked");
					}else if(jsonObj.defaultVal == '0'){
						$("#treeNo").attr("checked","checked");
					}
				}else if(isOrgType == true){
					//组织控件 类型
					if("text" == jsonObj.defaultType){
						$("#handTo").attr("checked","checked");
						$("#handValue").attr("disabled",false);
						$("#handValue").val(jsonObj.defaultVal);
					} else if("extend" == jsonObj.defaultType){
						$("#systemTo").attr("checked","checked");
						$("#handValue").attr("disabled",true);
						$("#systemValue").attr("disabled",false);
						$("#systemValue").val(jsonObj.defaultVal);
					}
					if(_inputType == 'department' || _inputType == 'multidepartment'){
						//树形条件
						if(jsonObj.treeShow == '1'){
							$("#treeYes").attr("checked","checked");
						}else if(jsonObj.treeShow == '0'){
							$("#treeNo").attr("checked","checked");
						}
						$("#isIncludeSubDept").val(jsonObj.isIncludeSubDept);
					}
					$("#handOrgIds").val(jsonObj.handOrgIds);
				}else if(_inputType == 'date' || _inputType == 'datetime'){
					//日期时间控件
					//预制选项
					$("#dateTimeYzxxValue").val($.toJSON(jsonObj.dateTimeYzxxValue));
					$("#dateTimeYzxxName").val(jsonObj.dateTimeYzxxName);
					//缺省选中第一项
					$("input:checkbox[name='defaultCheckFirst'][value='"+jsonObj.defaultCheckFirst+"']").attr('checked','true');
					
				}else{
					//文本 类型
					if("text" == jsonObj.defaultType){
						$("#handTo").attr("checked","checked");
						$("#handValue").attr("disabled",false);
						$("#handValue").val(jsonObj.defaultVal);
						
					} else if("extend" == jsonObj.defaultType){
						$("#systemTo").attr("checked","checked");
						$("#handValue").attr("disabled",true);
						$("#systemValue").attr("disabled",false);
						$("#systemValue").val(jsonObj.defaultVal);
					}
					
				}
				
			}
		}
	}

	$(document).ready(function() {
		showlabelvalue();
	});

	//去掉空格
	String.prototype.Trim = function() {
		return this.replace(/(^\s*)|(\s*$)/g, "");
	}

	function OK() {
		//$("#myfrm").validate();
		//重命名项
		var labelObj = document.getElementById("rowheader");
		//标题
		var titleObj = document.getElementById("title");
		//父窗口右侧所有选项
		var queryDataArea = parentWin.getElementById("rightdataarea");
		//父窗口右侧选中的项
		var slectData = queryDataArea.options[queryDataArea.selectedIndex];
		var resFlag = "false";
		if (labelObj.innerText == "") {
			return resFlag;
		}
		if (titleObj.value.Trim() == ""){
			return "${ctp:i18n('form.forminputchoose.titlecantnull')}";
		}
		//快速制单重名逻辑判断
		for(var i=0;i<queryDataArea.options.length;i++){
			var obj = queryDataArea.options[i];
			if(slectData==obj){
				continue;
			}
			var text = obj.text;
			var objname = "";
			if(text.indexOf("(")!=-1&&text.indexOf(")")!=-1){
				text = text.substring(text.indexOf("(")+1,text.indexOf(")"));
			}
			if(text.indexOf("]")!=-1){
				objname = text.substring(text.indexOf("]")+1,text.length);
			}
			if((titleObj.value.Trim() == objname)&&(obj.value!=titleObj.form.fieldName.value)||(text===titleObj.value.Trim())){
				$.alert('${ctp:i18n('form.fastmaking.rename.samename')}');
				return  resFlag;
			}
		}

		//判断修改后标题长度是否超过255
		if (len(titleObj.value.Trim()) > 255) {
			return "${ctp:i18n('form.forminputchoose.lengtherror')}";
		}
		if (isMark(titleObj.value.Trim()) == true) {
			return "${ctp:i18n('form.forminputchoose.inputerror')}";
		}
		if (isContainsValue(slectData.value, titleObj.value.Trim())) {
			if (type == 1) {//自定义查询
				return "${ctp:i18n('form.forminputchoose.customersear.error')}";
			} else if (type == 11) {//自定义统计
				return "${ctp:i18n('form.forminputchoose.customersear.reporterror')}";
			} else {
				return "${ctp:i18n('form.forminputchoose.notallowsamename')}";
			}
		}
		var resultObj = new Object();
		//字段数据类型
		var _inputType = $(slectData).attr("inputtype");
		var _fieldType = $("#fieldType").val();
		resultObj.inputType = _inputType;
		
		//判断是否为组织控件
		var isOrgType = _inputType == 'member' || _inputType == 'multimember' || _inputType == 'account' || _inputType == 'multiaccount' 
			|| _inputType == 'department' || _inputType == 'multidepartment';
		
		var defaultVal = "";
		var isSettingDefaultVal = true;
		if(_inputType == 'checkbox'){
			//复选框时，判断数据规则
			//判断前置标签
			var frontVal = $("#default_checkbox_front").val();
			if (isMark(frontVal) == true) {
				return "${ctp:i18n('form.forminputchoose.front.label')}:" + "${ctp:i18n('form.forminputchoose.inputerror')}" + " \:,|<>\/|\'\"?#$%&\^\*";
			}
			//判断是否为第一个选择的复选框，如果为第一个则必须添加前置标签
			var checkboxObj = new Array();
			$(queryDataArea).find("option").each(function(){
				if($(this).attr("inputType") == 'checkbox'){
					checkboxObj.push($(this));
				}
			});
			/*if(frontVal == ""){
				if(checkboxObj.length == 1){
					return "${ctp:i18n_1('form.forminputchoose.checkbox.first.label','"+labelObj.innerText+"')}";
				}
				if(checkboxObj[0].attr("value") == $("#fieldName").val()){
					return "${ctp:i18n_1('form.forminputchoose.checkbox.first.label','"+labelObj.innerText+"')}";
				}
			}*/
			resultObj.frontlabelVal = $.trim(frontVal);
			//缺省设置值
			defaultVal = $("#default_checkbox_select").find("option:selected").val();
			if($.trim(defaultVal) == ""){
				isSettingDefaultVal = false;
			}
		} else if(_inputType == 'select' || _inputType == 'radio'){
			//下拉枚举
			defaultVal = $('#treeCheckRadio input[name="treeDefaultValue"]:checked ').val();
			if(defaultVal == 1){
				//labelObj
				treeYesObje.item.push(labelObj.textContent);
			}
			resultObj.treeShow = defaultVal;
		}else if(isOrgType == true){
			//组织模型控件
			var checkedDefaultType = $('#defaultSetId input[name="defaultvalue"]:checked ').val();
			if ("text" == checkedDefaultType) {
				defaultVal = $("#handValue").val();
				if ($.i18n('form.select.handwork.default.label') == defaultVal || defaultVal == "" ) {
					isSettingDefaultVal = false;
					defaultVal = "";
				}
				//获取选择的人员ID
				resultObj.handOrgIds = $("#handOrgIds").val();
				//将是否包含子部门置为不包含
				resultObj.isIncludeSubDept  = "0";
			} else if ("extend" == checkedDefaultType) {
				defaultVal = $("#systemValue").find("option:selected").val();
				if (defaultVal == "") {
					isSettingDefaultVal = false;
				}
			}
			if(_inputType == 'department' || _inputType == 'multidepartment'){
				resultObj.treeShow = $('#treeCheckRadio input[name="treeDefaultValue"]:checked ').val();
				resultObj.isIncludeSubDept = $.trim($("#isIncludeSubDept").val());
				if(resultObj.treeShow == 1){
					treeYesObje.item.push(labelObj.textContent);

				}
			}
			resultObj.defaultType = checkedDefaultType;
		}else if(_inputType == 'date' || _inputType == 'datetime'){
			//日期时间控件
			//预制选项
			var dateTimeYzxxValue = $.trim($("#dateTimeYzxxValue").val());
			if(dateTimeYzxxValue == ""){
				isSettingDefaultVal = false;
			}else{
				resultObj.dateTimeYzxxValue = $.parseJSON(dateTimeYzxxValue);
				resultObj.dateTimeYzxxName = $("#dateTimeYzxxName").val();
			}
			//缺省选中第一项
			var defaultCheckFirst = "";
			if($("#defaultCheckFirst").attr("checked") == "checked"){
				defaultCheckFirst = "1";
			}
			if(dateTimeYzxxValue == "" && defaultCheckFirst != ""){
				//设置了缺省选中第一项，请选择预制选项！
				return "${ctp:i18n('form.forminputchoose.default.setting.first.label')}";
			}
			resultObj.defaultCheckFirst = defaultCheckFirst;
			
		}else{
			//文本类型时 判断缺省值选择
			var checkedDefaultType = $('#defaultSetId input[name="defaultvalue"]:checked ').val();
			if ("text" == checkedDefaultType) {
				defaultVal = $("#handValue").val();
				if("DECIMAL" == _fieldType){
					if(isNumber(defaultVal) == false){
						return "${ctp:i18n('form.query.defaultvalue.label')}:" + "${ctp:i18n('plan.alert.plansummary.enternumber')}";
					}
				}
				if (isMark(defaultVal) == true) {
					return "${ctp:i18n('form.query.defaultvalue.label')}:" + "${ctp:i18n('form.forminputchoose.inputerror')}" + " \:,|<>\/|\'\"?#$%&\^\*";
				}
				if ($.i18n('form.select.handwork.default.label') == defaultVal || defaultVal == "" ) {
					/* $.alert($.i18n('form.select.handwork.default.label'));
					return 'false'; */
					isSettingDefaultVal = false;
					defaultVal = "";
				}
			} else if ("extend" == checkedDefaultType) {
				defaultVal = $("#systemValue").find("option:selected").val();
				if (isMark(defaultVal) == true) {
					return "${ctp:i18n('form.query.defaultvalue.label')}:" + "${ctp:i18n('form.forminputchoose.inputerror')}" + " \:,|<>\/|\'\"?#$%&\^\*";
				}
				if (defaultVal == "") {
					//$.alert($.i18n('form.select.system.choose.label'));
					//return 'false';
					isSettingDefaultVal = false;
				}
			}

			resultObj.defaultType = checkedDefaultType;
		}
		
		if (labelObj.innerText.Trim() != titleObj.value.Trim()) {
			slectData.text = labelObj.innerText + "("+ titleObj.value.Trim() + ")";
		}else{
			slectData.text = labelObj.innerText;
		}
		
		//resultObj.title = slectData.text;
		resultObj.isSettingDefaultVal = isSettingDefaultVal;
		resultObj.defaultVal = defaultVal;
		//RightData.put(slectData.value, titleObj.value.Trim());
		//rightData.put(slectData.value, resultObj);
		$(slectData).attr("renameJSON",$.toJSON(resultObj));
		resFlag = 'true';
		return resFlag;
	}
	
	function isMark(str) {
		var myReg = /[\\:,()|<>\/|\'\"?#$%&\^\*]/;
		if (myReg.test(str)) {
			return true;
		}
		return false;
	}

	function isNumber(str){
		var myReg = /^(-?\d+)(\.\d+)?$/;
		if (myReg.test(str)) {
			return true;
		}
		return false;
	}

	//取得字符串长度,汉字占3个长度
	function len(str) {
		///<summary>获得字符串实际长度，中文2，英文1</summary>
		///<param name="str">要获得长度的字符串</param>
		var realLength = 0, len = str.length, charCode = -1;
		for (var i = 0; i < len; i++) {
			charCode = str.charCodeAt(i);
			if (charCode >= 0 && charCode <= 128)
				realLength += 1;
			else
				realLength += 3;
		}
		return realLength;
	}

	function isContainsValue(key, value) {
		//先把要排除的移除掉
		var temp = rightData.get(key);
		rightData.remove(key);
		var values = rightData.values();
		for (var i = 0; i < values.size(); i++) {
			if (values.get(i).title == value) {
				rightData.put(key, temp);//值补上
				return true;
			}
		}
		rightData.put(key, temp);//值补上
		return false;
	}
	
	function systemVarChange4Dept(){
		var selectedVal = $("#systemValue").find("option:selected").val();
		var confirm = $.confirm({
	        'msg': $.i18n("form.forminputchoose.include.subdept.label"),//是否包含子部门？
	        //绑定自定义事件
	        ok_fn: function () { 
	        	if(selectedVal == ""){
	        		$("#isIncludeSubDept").val("0");
	        	}else{
	        		$("#isIncludeSubDept").val("1");
	        	}
	        },
	        cancel_fn:function(){
	        	$("#isIncludeSubDept").val("0");
	        }
	    });
	}

	/**
	 * 表单字段类日期或者时间类型时，预置选项的事件
	 * @param obj
	 */
	function dateTimeYzxxFocus(obj){
		var yzxxNameVal = $(obj).val();
		var inputType = $("#inputType").val();
		var fieldType = $("#fieldType").val();
		if($.i18n("form.forminputchoose.default.choose.label") == yzxxNameVal){
			$(obj).val("");
		}
		var optionsJSON = $("#dateTimeYzxxValue").val();
		var options = "";
		if($.trim(optionsJSON) != ""){
			options = $.parseJSON(optionsJSON);
		}
		var url = _ctxPath + '/form/component.do?method=dateTimeFieldSetting&inputType=' + inputType + "&fieldType=" + fieldType;
		var dialog = $.dialog({
			id:"formFieldRename4Yzxx",
			url:url,
			title:$.i18n('form.extend.show.set.lable'),
			width:600,
			height:400,
			transParams : options,
			targetWindow : getCtpTop(),
			buttons:[{
				text : $.i18n("form.forminputchoose.enter"),
				id : "sure",
				isEmphasize: true,
				handler : function(){
					var result = dialog.getReturnValue();
					if(result.OK == "error"){
						$.alert($.i18n("form.forminputchoose.datetime.optionNaming.setting.label"));
						return;
					}
					var rightArray = result.rightArray;
					var showName = "";
					for(var i=0;i < rightArray.length;i++){
						var rObj = rightArray[i];
						if(i < rightArray.length - 1){
							showName += rObj.name + "、";
						}else{
							showName += rObj.name;
						}
					}
					$("#dateTimeYzxxName").val(showName);
					$("#dateTimeYzxxValue").val($.toJSON(result));
					dialog.close();
				}
			},{
				text : $.i18n('form.forminputchoose.cancel'),
				id : "exit",
				handler : function() {
					dialog.close();
				}
			}]
		});
	}
</script>