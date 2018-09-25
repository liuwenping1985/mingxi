var docMarkChooseUrl = "/edocMark.do?method=docMarkChoose4form&orgAccountId=form&edocType=0";
var serialNoChooseUrl = "/edocMark.do?method=docMarkChoose4form&orgAccountId=form&edocType=1";
var signMarkChooseUrl = "/edocMark.do?method=docMarkChoose4form&orgAccountId=form&edocType=2";
var formZwIframe;

var nullColor = "#FCDD8B";
var notNullColor = "#FFFFFF";

var docMarkDiv;
var serialNoDiv;
var signMarkDiv;

var docMarkFenduanKaiguan = false;
var docMarkShouxieKaiguan = false;

var serialNoFenduanKaiguan = false;
var serialNoShouxieKaiguan = false;
var serialNoJianbanKaiguan = false;

var signMarkShouxieKaiguan = false;

var docMarkFieldspan;
var docMarkField;
var docMarkFieldtxt;

var serialNoFieldspan;
var serialNoField;
var serialNoFieldtxt;

var signMarkFieldspan;
var signMarkField;
var signMarkFieldtxt;

var serialNoFieldspan;
var serialNoField;
var serialNoFieldtxt;

var wordNoSelect;
var yearNoSelect;
var markNoSuffix;
var markNumberInput;
var shouxieInput;

var serialNoWordNoSelect;
var serialNoYearNoSelect;
var serialNoMarkNoSuffix;
var serialNoMarkNumberInput;
var serialNoShouxieInput;

var isLoadDocMark = false;
var isLoadSerialNo = false;
var isLoadSignMark = false;
var isLoadForm = false;
var openFrom;
var markGovdocType = "";

/**
 * 表单加载后回调方法
 */
function formLoadCallback(from) {

	//加载表单容器
	initFormZwIframe();

	if(!formZwIframe) {
		return;
	}
	
	//加载文单中公文文号
	initFormDocMark();

	//加载文单中内部文号(包括分段的见办功能)
	initFormSerialNo();

	//加载文单中的签收编号
	initFormSignMark();
}

/**
 * 一段文号切换回调
 */
function selectChangeCallBack(obj, selectObj) {
	try {
		var objTxtId = obj.attr("id");
		if(objTxtId && objTxtId.indexOf("_txt")>0) {
			var objId = objTxtId.substring(0, objTxtId.length - 4);
			var spanId = objId + "_span";
			
			//因为在select添加txt时，页面还未加载，需要手动加载当前页面
			initFormZwIframe();
			if(!formZwIframe) {
				return;
			}
			
			//公文文号
			var markName = "edocDocMark";
			var tempDocMarkFieldspan = formZwIframe.find("span[fieldval*='edocDocMark']");
			if(tempDocMarkFieldspan && tempDocMarkFieldspan.size()>0 && tempDocMarkFieldspan.attr("id") == spanId) {
				//因为在select添加txt时，页面还未加载，需要手动初始化文号
				initFormDocMark();
				
				markType = "doc_mark";
				
				if(!docMarkFenduanKaiguan) {
					//设置文号必填项背景
					changeDocMarkBackgroundColor(markType);
				}
			}
			
			//内部文号
			var tempSerialNoFieldspan = formZwIframe.find("span[fieldval*='edocInnerMark']");
			if(tempSerialNoFieldspan && tempSerialNoFieldspan.size()>0 && tempSerialNoFieldspan.attr("id") == spanId) {
				//因为在select添加txt时，页面还未加载，需要手动初始化内部文号
				initFormSerialNo();
				
				markType = "serial_no";
				
				if(!serialNoFenduanKaiguan) {
					changeJianbanEventOne();
					
					//设置文号必填项背景
					changeDocMarkBackgroundColor(markType);
				}
			}
			
			//签收编号
			var tempSignMarkFieldspan = formZwIframe.find("span[fieldval*='edocSignMark']");
			if(tempSignMarkFieldspan && tempSignMarkFieldspan.size()>0 && tempSignMarkFieldspan.attr("id") == spanId) {
				//因为在select添加txt时，页面还未加载，需要手动初始化签收编号
				initFormSignMark();
				
				markType = "sign_mark";
			}
		}
	} catch(e) {}
}

/**
 * 公文文号机构字切换回调
 * @param obj
 */
function DocMarkWordNoChangeCallBackThree(obj, selectObj) {
	var markType = "doc_mark";
	if(!obj.attr("isLoad") || obj.attr("isLoad")=="") {
		obj.attr("isLoad", "true");

		//初始化时，机构代字切换
		if(getMarkNoType(markType).val() != "2") {
			changeWordNoEventThree(markType, "init");
		}
	} else {
		//机构代字切换
		if(getMarkNoType(markType).val() != "2") {
			changeWordNoEventThree(markType, "changeWordNo");
		}
		//设置文号必填项背景
		changeDocMarkBackgroundColor(markType);
	}
}

/**
 * 内部文号机构字切换回调
 */
function SerialNoWordNoChangeCallBackThree(obj, selectObj) {
	var markType = "serial_no";
	if(!obj.attr("isLoad") || obj.attr("isLoad")=="") {
		obj.attr("isLoad", "true");

		//设置机构字内容状态为实时更新
		getWordNoSelecttxt(markType).attr("realUpdate", true);
		//回填见办内容
		changeJianbanEventThree(markType, "init");
		//非手写文号时，切换机构代字
		if(getMarkNoType(markType).val() != "2") {
			changeWordNoEventThree(markType, "init");
		}
	} else {
		//见办切换
		changeJianbanEventThree(markType, "jianban");
		//非手写文号时，切换机构代字
		if(getMarkNoType(markType).val() != "2") {
			changeWordNoEventThree(markType, "changeWordNo");
		}
		//设置文号必填项背景
		changeDocMarkBackgroundColor(markType);
	}
}

/************** 文号页面加载 start ***********/
function initFormZwIframe(from) {
	if(isLoadForm) {
		return;
	}
	isLoadForm = true;
	
	openFrom = from;

	if($("#subApp") && $("#subApp").val()) {
		markGovdocType = $("#subApp").val();
	}

	if(openFrom && "extend"==openFrom) {
		formZwIframe = $(document);
	} else {
		try {
			formZwIframe = $(window.frames["zwIframe"].document);//拟文界面
		} catch(e) {
			try {
				formZwIframe = $(window.frames["componentDiv"].window.frames["zwIframe"].document);//处理界面	
			} catch(e2) {
				openFrom = "extend";
				formZwIframe = $(document);
			}
		}
	}
	
	//清空全局变量
	getCtpTopFromOpener(window).jianbanType = null;
}
/************** 文号页面加载 end *************/

/************** 公文文号加载 start ***********/
function initFormDocMark() {
	if(isLoadDocMark) {
		return;
	}
	isLoadDocMark = true;

	var markType = "doc_mark";
	var markName = "edocDocMark";

	//找到公文文中与映射控件
	docMarkField = formZwIframe.find("[mappingField=" + markType + "]");
	if(!docMarkField) {
		return;
	}

	docMarkFieldspan = null;
	if(docMarkField.size() == 0) {
		docMarkFieldspan = formZwIframe.find("span[fieldval*='" + markName + "']");
		if(!docMarkFieldspan || docMarkFieldspan.size()==0) {
			return;
		}
		if(docMarkFieldspan.find("select").size() > 0) {
			docMarkField = docMarkFieldspan.find("select").eq(0);
			if(!docMarkField || docMarkField.size()==0) {
				return;
			}
		}
	}

	var docMarkId = docMarkField.attr("id");
	if(!docMarkId || docMarkId=="") {
		formZwIframe.find("#docMarkDiv").hide();
		return;
	}

	if(!docMarkFieldspan) {
		docMarkFieldspan = formZwIframe.find("#" + docMarkId + "_span");
		if(!docMarkFieldspan || docMarkFieldspan.html()=="") {
			return;
		}
	}

	docMarkFieldtxt = docMarkFieldspan.find("#" + docMarkId + "_txt");
	if(!docMarkFieldtxt || !(docMarkFieldtxt.attr("id"))) {
		return;
	}

	//设置机构字内容状态为实时更新
	docMarkFieldtxt.attr("realUpdate", true);

	//启用公文文号(机构代字、年份、流水号)分段选择
	docMarkDiv = formZwIframe.find("div[id=docMarkDiv]");
	if(docMarkDiv && docMarkDiv.html()) {
		docMarkFenduanKaiguan = docMarkDiv.find("#docMarkFenduanKaiguan").val()=="true";
		docMarkShouxieKaiguan = docMarkDiv.find("#docMarkShouxieKaiguan").val()=="true";
	}

	//加载公文文号小图标
	initMarkIcon(markType);

	//初始化公文文号
	if(docMarkFenduanKaiguan) {
		//回填公文文号
		fillDocMarkData(markType);

		//屏蔽非分段-文号选择框
		getDocMarkField(markType).hide();
		getDocMarkFieldtxt(markType).hide();
		getDocMarkFieldspan(markType).hide();

		//机构代字显示模糊查询
		getWordNoSelect(markType).attr("class", "validate comp enumselect common_drop_down");
		getWordNoSelect(markType).attr("comp", "type:'autocomplete',valueChange:" + getWordNoCallback(markType) + ",autoSize:true");
		getWordNoSelect(markType).attr("_comp", "");
		getWordNoSelect(markType).attr("comptype", "autocomplete");
		getWordNoSelect(markType).compThis();
	} else {
		fillDocMarkDataOne(markType);
	}
	//加载文号样式
	loadDocMarkStyle(markType);
	//加载公文文号校验
	initDocMarkValidate(markType);
	//加载公文文号事件
	initMarkFieldEvent(markType);

}
/************** 公文文号加载 end *************/

/************** 签收编号加载 start ***********/
function initFormSignMark() {
	if(isLoadSignMark) {
		return isLoadSignMark;
	}
	isLoadSignMark = true;
	
	var markType = "sign_mark";
	var markName = "edocSignMark";

	//找到公文文中与映射控件
	signMarkField = formZwIframe.find("[mappingField=" + markType + "]");
	if(!signMarkField) {
		return;
	}

	signMarkFieldspan = null;
	if(signMarkField.size() == 0) {
		signMarkFieldspan = formZwIframe.find("span[fieldval*='" + markName + "']");
		if(!signMarkFieldspan || signMarkFieldspan.size()==0) {
			return;
		}
		if(signMarkFieldspan.find("select").size() > 0) {
			signMarkField = signMarkFieldspan.find("select").eq(0);
			if(!signMarkField || signMarkField.size()==0) {
				return;
			}
		}
	}

	var docMarkId = signMarkField.attr("id");
	if(!docMarkId || docMarkId=="") {
		return;
	}

	if(!signMarkFieldspan) {
		signMarkFieldspan = formZwIframe.find("#" + docMarkId + "_span");
		if(!signMarkFieldspan || signMarkFieldspan.html()=="") {
			return;
		}
	}

	signMarkFieldtxt = signMarkFieldspan.find("#" + docMarkId + "_txt");
	if(!signMarkFieldtxt || !(signMarkFieldtxt.attr("id"))) {
		return;
	}

	//设置机构字内容状态为实时更新
	signMarkFieldtxt.attr("realUpdate", true);

	signMarkDiv = formZwIframe.find("div[id=signMarkDiv]");

	if(signMarkDiv && signMarkDiv.html()) {
		signMarkShouxieKaiguan = signMarkDiv.find("#signMarkShouxieKaiguan").val()=="true";
	}

	//加载内部文号小图标
	initMarkIcon(markType);
}
/************** 签收编号加载 end *************/

/************** 收文编号加载 start ***********/
function initFormSerialNo() {
	if(isLoadSerialNo) {
		return;
	}
	isLoadSerialNo = true;

	var markType = "serial_no";
	var markName = "edocInnerMark";

	//找到公文文中与映射控件
	serialNoField = formZwIframe.find("[mappingField=" + markType + "]");
	if(!serialNoField) {
		return;
	}

	serialNoFieldspan = null;
	if(serialNoField.size() == 0) {
		serialNoFieldspan = formZwIframe.find("span[fieldval*='" + markName + "']");
		if(!serialNoFieldspan || serialNoFieldspan.size()==0) {
			return;
		}
		if(serialNoFieldspan.find("select").size() > 0) {
			serialNoField = serialNoFieldspan.find("select").eq(0);
			if(!serialNoField || serialNoField.size()==0) {
				return;
			}
		}
	}

	var docMarkId = serialNoField.attr("id");
	if(!docMarkId || docMarkId=="") {
		formZwIframe.find("#serialNoDiv").hide();
		return;
	}

	if(!serialNoFieldspan) {
		serialNoFieldspan = formZwIframe.find("#" + docMarkId + "_span");
		if(!serialNoFieldspan || serialNoFieldspan.html()=="") {
			return;
		}
	}

	serialNoFieldtxt = serialNoFieldspan.find("#" + docMarkId + "_txt");
	if(!serialNoFieldtxt || !(serialNoFieldtxt.attr("id"))) {
		return;
	}

	serialNoFieldtxt.attr("realUpdate", true);

	//启用公文文号(机构代字、年份、流水号)分段选择
	serialNoDiv = formZwIframe.find("div[id=serialNoDiv]");
	if(serialNoDiv && serialNoDiv.html()) {
		serialNoFenduanKaiguan = serialNoDiv.find("#serialNoFenduanKaiguan").val()=="true";
		serialNoShouxieKaiguan = serialNoDiv.find("#serialNoShouxieKaiguan").val()=="true";
		serialNoJianbanKaiguan = serialNoDiv.find("#serialNoJianbanKaiguan").val()=="true";
	}

	//加载收文见办功能(只包括不分段的见办功能)
	initFormJianban();
	//加载收文编号小图标
	initMarkIcon(markType);

	//初始化公文文号
	if(serialNoFenduanKaiguan) {
		//屏蔽非分段-文号选择框
		getDocMarkField(markType).hide();
		getDocMarkFieldtxt(markType).hide();
		getDocMarkFieldspan(markType).hide();

		//回填公文文号
		fillDocMarkData(markType);

		//机构代字显示模糊查询
		getWordNoSelect(markType).attr("class", "validate comp enumselect common_drop_down");
		getWordNoSelect(markType).attr("comp", "type:'autocomplete',valueChange:" + getWordNoCallback(markType) + ",autoSize:true");
		getWordNoSelect(markType).attr("_comp", "");
		getWordNoSelect(markType).attr("comptype", "autocomplete");
		getWordNoSelect(markType).compThis();
	}

	//加载文号样式
	loadDocMarkStyle(markType);
	//加载收文编号校验
	initDocMarkValidate(markType);
	//加载收文编号事件
	initMarkFieldEvent(markType);
}
/************** 收文编号加载 end *************/


/************** 公共方法加载 start ***********/
/**
 * 公文文号/内部编号断号等小图标显示
 * @param markType
 */
function initMarkIcon(markType) {
	if(markType == "doc_mark") {
		if(docMarkFenduanKaiguan) {
			getDocMarkIconDiv(markType).append("<span id='zidongIcon' class='ico16'></span>");
			if(docMarkShouxieKaiguan) {
				getDocMarkIconDiv(markType).append("<span id='shouxieIcon' class='ico16 number_change_16'></span>");
			}
		} else {
			if(docMarkShouxieKaiguan) {
				getDocMarkFieldspan(markType).append("<span id='docMarkNumberChange' class='ico16 number_change_16'></span>");
			}
		}
	} else if(markType == "serial_no") {
		if(serialNoFenduanKaiguan) {
			if(serialNoShouxieKaiguan) {
				getDocMarkIconDiv(markType).append("<span id='serialNoShouxieIcon' class='ico16 number_change_16'></span>");
			}
			if(serialNoJianbanKaiguan) {
				getDocMarkIconDiv(markType).append("<span id='jianbanIcon' class='ico16 xl_icon_j'></span>");
			}
		} else {
			if(serialNoShouxieKaiguan) {
				getDocMarkFieldspan(markType).append("<span id='docMarkNumberChange' class='ico16 number_change_16'></span>");
			}
			if(serialNoJianbanKaiguan) {
				if(serialNoFenduanKaiguan) {
					getDocMarkIconDiv(markType).append("<span id='jianbanIcon' class='ico16 xl_icon_j'></span>");
				} else {
					getDocMarkFieldspan(markType).append("<span id='jianbanIcon' class='ico16 xl_icon_j'></span>");
				}
			}
		}
	} else {
		//不分段签收编号显示
		if(signMarkShouxieKaiguan) {
			if(openFrom=="extend" || markGovdocType=="2" || markGovdocType=="4") {
				getDocMarkFieldspan(markType).append("<span id='docMarkNumberChange' class='ico16 number_change_16'></span>");

				getDocMarkFieldspan(markType).find("#docMarkNumberChange").unbind("click").bind("click",function(){
			    	openDocMarkDialog(markType);
			    });
			}
		}
	}
}
/**
 * 初始化文号按钮事件
 * @param markType
 */
function initMarkFieldEvent(markType) {

	//文号断号选择
	var zidongIcon = getZidongIcon(markType);
	if(zidongIcon) {
		zidongIcon.click(function() {
			openDocMarkDialog(markType);
		});
	}

	//手工文号切换
	var shouxieIcon = getShouxieIcon(markType);
	if(shouxieIcon) {
		shouxieIcon.click(function() {
			if(getMarkNoType(markType).val() == "1") {
				getMarkNoType(markType).val("2");
			} else {
				getMarkNoType(markType).val("1");
			}
			changeMarkNoTypeEvent(markType);
			//设置文号必填项背景
			changeDocMarkBackgroundColor(markType);
		});
	}

	//公文年号下拉切换
	getYearNoSelect(markType).change(function() {
		changeMarkNumber(markType);
	});

	//文号编号输入
	getMarkNumberInput(markType).keyup(function() {
		this.value = this.value.replace(/[^\d]/g,'');
		changeMarkNumber(markType);
		//设置文号必填项背景
		changeDocMarkBackgroundColor(markType);
	});

	//手工文号输入
	getShouxieInput(markType).keyup(function() {
		var fieldValue = "0|" + this.value + "||3";
		resetDocMarkFieldValue(markType, this.value, fieldValue);
		//设置文号必填项背景
		changeDocMarkBackgroundColor(markType);
	});

	//断号选择-不分段显示
	getDocMarkFieldspan(markType).find("#docMarkNumberChange").unbind("click").bind("click", function() {
    	openDocMarkDialog(markType);
    });

	//见办点击事件
	if(markType=="serial_no" && serialNoJianbanKaiguan) {
		formZwIframe.find("#jianbanIcon").click(function() {
			if($("#jianbanType").val() == "2") {
				$("#jianbanType").val("1");
			} else {
				$("#jianbanType").val("2");
			}
			
			if(serialNoFenduanKaiguan) {
				changeJianbanEventThree(markType);
			} else {
				changeJianbanEventOne();
			}

			//将缓存中的 Autocomplete UI的值进行修改
			var serialnoId = getDocMarkFieldtxt(markType).attr("id")
			getCtpTopFromOpener(window).jianbanType = serialnoId + $("#jianbanType").val();
			
		});
	}
}
/**
 * 回填公文文号/内部文号控件值
 * @param markType
 */
function fillDocMarkData(markType) {
	var selectedOption = getDocMarkField(markType).find("option:selected");
	var docMark = selectedOption.val();
	//文号有值
	if(docMark && docMark!="" && docMark!="-1") {
		var markArr = docMark.split("|");
		var markNoType = markArr[3];
		var markNumber = markArr[2];
		var markstr = markArr[1];
		//自动/预留/断号
		if(markNoType == "1" || markNoType == "4" || markNoType == "2") {
			var definitionId = markArr[0];
			if(markNoType == "2" && selectedOption.attr("markDefinitionId")!="-1") {//断号
				//definitionId = $("#markDefinitionId").val();
				definitionId = selectedOption.attr("markDefinitionId");
			}
			if(definitionId && definitionId!="" && definitionId!="null") {
				getWordNoSelect(markType).attr("selected", "true");
				getWordNoSelect(markType).val(definitionId);

				var selectedObj = getWordNoSelect(markType).find("option:selected");
				if(selectedObj) {
					//调用模板，则不设置序号，取文号当前序号
					if(markNumber) {
						selectedObj.attr("currentMarkNumber", markNumber);
					}
					if(markstr && markstr!="") {
						var currentYearNo = getMarkYearNo(markstr, selectedObj.attr("left"), selectedObj.attr("right"), selectedObj.attr("suffix"));
						if(currentYearNo && currentYearNo!="") {
							selectedObj.attr("currentYearNo", currentYearNo);
						}
					}
					getWordNoSelecttxt(markType).val(selectedObj.html());
				}
			}
		}
		//手写文号
		else if(markNoType == "3") {
			getZidongDiv(markType).hide();
			getShouxieDiv(markType).show();
			getMarkNoType(markType).val("2");
			getShouxieInput(markType).val(markstr);

			resetDocMarkFieldValue(markType, markstr, docMark);
		}
	}
	//文号无值
	else {
		changeWordNoEventThree(markType, "init", null);
	}
}

/**
 * 回填公文文号/内部文号控件值
 * @param markType
 */
function fillDocMarkDataOne(markType) {
	//这段代码暂时无用
	if(getDocMarkField(markType).find("option[isFromTemplate='true']").size() > 0) {
		var selectedOption = getDocMarkField(markType).find("option:selected");
		var docMark = selectedOption.val();
		//文号有值
		if(docMark && docMark!="" && docMark!="-1") {
			var markArr = docMark.split("|");
			var markNoType = markArr[3];
			var markNumber = markArr[2];
			var markstr = markArr[1];
			//自动/预留/断号
			if(markNoType == "1" || markNoType == "4" || markNoType == "2") {
				var definitionId = markArr[0];
				if(markNoType == "2" && selectedOption.attr("markDefinitionId")!="-1") {//断号
					//definitionId = $("#markDefinitionId").val();
					definitionId = selectedOption.attr("markDefinitionId");
				}
				if(definitionId && definitionId!="" && definitionId!="null") {
					getDocMarkField(markType).find("option").each(function() {
						$(this).attr("selected", false);
						if(!$(this).attr("defaultHtml") || $(this).attr("defaultHtml")=="") {
							var optionVal = $(this).val();
							if(optionVal != "" && optionVal.split("|")[0]==definitionId) {
								$(this).attr("selected", true);
								getDocMarkFieldtxt(markType).val(optionVal.split("|")[1]);
							}	
						}
					});
				}
			}
		}
	}
}

/**
 * 自动/手写切换
 */
function changeMarkNoTypeEvent(markType) {
	if(getMarkNoType(markType).val() == "2") {//手工输入
		getZidongDiv(markType).hide();
		getShouxieDiv(markType).show();

		resetDocMarkFieldValue(markType, getShouxieInput(markType).val(), "0|"+getShouxieInput(markType).val()+"||3");
	} else {//自动文号
		getZidongDiv(markType).show();
		getShouxieDiv(markType).hide();
		
		//手写切换回自动文号，保证文号序号正确
		if(getMarkNumberInput(markType)) {
			var currentMarkNumber = getMarkNumberInput(markType).val();
			var selectedObj = getWordNoSelect(markType).find("option:selected");
			if(selectedObj && currentMarkNumber) {
				selectedObj.attr("currentMarkNumber", currentMarkNumber);
			}
		}
		changeWordNoEventThree(markType, "shouxieChange");
	}
}
/**
 * 机构字号切换事件
 * @param markType
 * @param action
 * @param markstr
 */
function changeWordNoEventThree(markType, action, docMark) {
	//获取文号的相关数据
	var selectedObj = getWordNoSelect(markType).find("option:selected");
	if(!selectedObj) {
		return;
	}

	var selectedDefId = selectedObj.val();
	var wordNo = selectedObj.html();
	var left = selectedObj.attr("left");
	var right = selectedObj.attr("right");
	var suffix = selectedObj.attr("suffix");
	var yearEnabled = selectedObj.attr("yearEnabled");
	var twoYear = selectedObj.attr("twoYear");
	var markLength = selectedObj.attr("markLength");
	var currentNo = selectedObj.attr("currentNo");
	var currentMarkNumber = selectedObj.attr("currentMarkNumber");
	var chooseMarkNumber = selectedObj.attr("chooseMarkNumber");
	var currentYearNo = selectedObj.attr("currentYearNo");
	var chooseYearNo = selectedObj.attr("chooseYearNo");

	//机构字切换后，重置年号控件
	getYearNoSelect(markType).html("");
	if(yearEnabled == "false") {
		getYearNoSelect(markType).hide();
	} else {
		getYearNoSelect(markType).show();

		var selectedYearNo = chooseYearNo;
		if(!selectedYearNo) {
			selectedYearNo = currentYearNo;
		}
		setYearNoParameter(markType, twoYear, selectedYearNo);
	}
	//机构字切换后，重置文号后缀
	if(!suffix) {
		suffix = "号";
	}
	getMarkNoSuffix(markType).html(suffix);

	//机构字切换后，获取公文编号
	var markFullNumber;
	if(action == "duanhaoCallback") {
		markFullNumber = chooseMarkNumber;
		if(!markFullNumber) {
			markFullNumber = currentMarkNumber;
		}
	} else if(action == "init" || action == "shouxieChange" || action == "changeWordNo") {
		markFullNumber = currentMarkNumber;
	}
	if(!markFullNumber) {
		markFullNumber = currentNo;
	}
	markFullNumber = getFullMarkNumber(markFullNumber, markLength);

	//机构字切换后，重置公文编号
	if(action != "jianban") {//见办切换不影响年号，编号及后缀
		getMarkNumberInput(markType).val(markFullNumber);
	} else {
		//初始化内容为手工输入时，各框内容没有初始化，点见办初始化框里内容，其它情况点击见，不改变年号，编号
		if(getMarkNumberInput(markType).val() == "") {
			getMarkNumberInput(markType).val(markFullNumber);
		}
	}

	//机构字切换、年号切换、编号改变后，重置公文文号映射字段doc_mark
	changeMarkNumber(markType, docMark);
}

/**
 * 获取机构字控件select及input中值内容，拼装新的文号
 * @param markType
 * @param docMark
 */
function changeMarkNumber(markType, docMark) {
	var newMarkstr;
	var newDocMark;

	//获取文号的相关数据
	var selectedObj = getWordNoSelect(markType).find("option:selected");
	var selectedDefId = selectedObj.val();
	if(selectedDefId == "") {//选择为空
		newMarkstr = "";
		newDocMark = "0|||1";
	} else {
		var wordNo = selectedObj.html();
		var left = selectedObj.attr("left");
		var right = selectedObj.attr("right");
		var suffix = selectedObj.attr("suffix");
		var yearEnabled = selectedObj.attr("yearEnabled");
		var twoYear = selectedObj.attr("twoYear");
		var markLength = selectedObj.attr("markLength");
		var currentNo = selectedObj.attr("currentNo");
		var currentMarkNumber = selectedObj.attr("currentMarkNumber");

		var yearNo = getYearNoSelect(markType).val();
		var markFullNumber = getFullMarkNumber(getMarkNumberInput(markType).val(), markLength);

		var markstr = wordNo + left + yearNo + right + markFullNumber + suffix;
		if(yearEnabled == "false") {
			markstr = wordNo + markFullNumber + suffix;
		}

		//将拼装好的公文文号值放入非分段-文号选择框
		var fieldValue = selectedDefId + "|" + markstr + "|" + markFullNumber + "|1";
		if(docMark) {
			fieldValue = docMark;
		}

		newMarkstr = markstr;
		newDocMark = fieldValue;
	}
	resetDocMarkFieldValue(markType, newMarkstr, newDocMark, selectedDefId);
}
/**
 * 将拼装好的文号值放入隐藏的文号选择框
 * @param markType
 * @param markstr
 * @param fieldValue
 * @param selectedDefId
 */
function resetDocMarkFieldValue(markType, markstr, fieldValue) {
	getDocMarkField(markType).find("option").each(function() {
		if($(this).attr("isAdd") == "true") {
			$(this).remove();
		}
	});
	getDocMarkField(markType).append("<option value=\""+ fieldValue +"\" isAdd=\"true\" oldHtml=\""+markstr+"\">"+markstr+"</option>");
	getDocMarkField(markType).find("option").last().attr("selected", true);

	getDocMarkFieldtxt(markType).val(markstr);
}

/**
 * 设置年号下拉列值
 * @param markType
 * @param twoYear
 * @param selectedYearNo
 */
function setYearNoParameter(markType, twoYear, selectedYearNo) {
	//获取当前年
	var thisYear = new Date().getFullYear();
	//开启可跨前后两年
	var distance = 0;
	if(twoYear == "true") {
		distance = 1;
	}
	for(var i=0-distance; i<=distance; i++) {
		getYearNoSelect(markType).append("<option value='"+(thisYear+i)+"'>"+(thisYear+i)+"</option>");
	}
	if(selectedYearNo) {
		getYearNoSelect(markType).val(selectedYearNo);
	} else {
		getYearNoSelect(markType).val(thisYear);
	}
}
/**
 * 打开断号选择框
 */
function openDocMarkDialog(markType) {
	var width = 450;
	var height = 480;
	if(markType == "serial_no") {
		height = 100;
	} else if(markType == "doc_mark") {
		if(serialNoFenduanKaiguan) {
			height = 420;
		}
	} else if(markType == "sign_mark") {
		height = 100;
	}

	var url = getDocMarkChooseUrl(markType);
	if($("#isSystemTemplete") && $("#isSystemTemplete").val()=="true") {
		//分段断号选择
		if(docMarkFenduanKaiguan || serialNoFenduanKaiguan) {
			if(getWordNoSelect(markType).find("option[tbindMark='true']").size() > 0) {
				var selectedObj = getWordNoSelect(markType).find("option").eq(1);
				if(selectedObj && selectedObj.val() && selectedObj.val()!="") {
					url += "&mark4FromId=" + selectedObj.val();
				}
			}
		} else {
			if(getDocMarkField(markType).find("option[tbindMark='true']").size() > 0) {
				var selectedObj = getDocMarkField(markType).find("option").eq(1);
				if(selectedObj && selectedObj.val() && selectedObj.val()!="") {
					var arr = selectedObj.val().split("|");
					if(arr.length>0 && arr[0]!="0") {
						url += "&mark4FromId=" + arr[0];
					}
				}
			}
		}
	}
	var title = "公文文号选择";
	if(markType == "sign_mark") {
		title = "签收编号输入";
	} else if(markType == "serial_no") {
		title = "内部文号输入";
	}
	$.fn.openMarkDialog(url, title, width, height, {}, function(objs) {
		var markArr = objs[0].split("|");
		if(markType == "serial_no") {
			if(markArr[3] == "3") {//手写输入
				if(serialNoJianbanKaiguan) {
					if($("#jianbanType").val() == 2) {
						if(markArr[1].indexOf("见") != 0) {
							objs[0] = objs[0].replace(markArr[1], "见" + markArr[1]);
						}
					} else {
						if(markArr[1].indexOf("见") == 0) {
							objs[0] = objs[0].replace(markArr[1], markArr[1].substring(1));
						}
					}
					markArr = objs[0].split("|");
				}
			}
		}
		var markNumber = markArr[2];
		var definitionId = objs[4];
		var markstr = markArr[1];
		var markId;
		var yearNo = objs[5];
		if(objs[3] == "2") {
			markId = markArr[0];
		}
		
		getDocMarkField(markType).find("option").each(function() {
			if($(this).attr("isAdd") == "true") {
				$(this).remove();
			}
		});
		getDocMarkField(markType).append("<option selected isAdd='true' title='"+markstr+"' oldHtml='"+markstr+"' id='"+definitionId+"' value='"+objs[0]+"'>"+markstr+"</option>");
		getDocMarkField(markType).val(objs[0]);

		getDocMarkFieldtxt(markType).attr("data", select2DataStr(getDocMarkField(markType)));
		getDocMarkFieldtxt(markType).val(markstr);

		//分段
		if((markType=="doc_mark"&&docMarkFenduanKaiguan)
				|| (markType=="serial_no"&&serialNoFenduanKaiguan)) {
			getWordNoSelect(markType).val(definitionId);

			var selectedObj = getWordNoSelect(markType).find("option:selected");
			getWordNoSelecttxt(markType).val(selectedObj.html());

			var chooseYearNo = getMarkYearNo(markstr, selectedObj.attr("left"), selectedObj.attr("right"), selectedObj.attr("suffix"));
			selectedObj.attr("chooseYearNo", chooseYearNo);
			selectedObj.attr("chooseMarkNumber", markNumber);

			changeWordNoEventThree(markType, "duanhaoCallback", objs[0]);

			getZidongDiv(markType).show();
			getShouxieDiv(markType).hide();
			getMarkNoType(markType).show();
		}
		//切换到自动文号
		getMarkNoType(markType).val("1");
	});
}
/************** 公共方法加载 end *************/


/************** 文号样式加载 start ***********/
/**
 * 加载分段文号控件显示样式
 */
function loadDocMarkStyle(markType) {
	if(openFrom == "extend") {
		getDocMarkDiv(markType).css({"width": "220px", "margin-top": "0px", "margin-left":"0px", "margin-right":"0px"});
		getZidongDiv(markType).css({"width": "220px", "margin-top": "2px", "margin-left":"0px", "margin-right":"0px"});
		getDocMarkIconDiv(markType).css({"width": "50px", "margin-top": "2px", "margin-left":"0px", "margin-right":"0px"});

		getMarkNumberInput(markType).css({"width": "40px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"2px", "font-size":"12px", "border":"1"});
		getWordNoSelecttxt(markType).css({"width": "80px", "margin-top":"2px", "margin-left":"0px", "margin-right":"0px"});
		getYearNoSelect(markType).css({"width":"50px","height":"22px", "margin-left":"0px", "margin-right":"5px", "margin-top":"2px", "font-size":"12px", "vertical-align":"middle"});
		getShouxieInput(markType).css({"width": "200px","height":"18px", "margin-left":"0px", "margin-right":"0px", "font-size":"12px"});
	} else {
		var fontSize = getDocMarkFieldtxt(markType).css("font-size");
		var fontFamily = getDocMarkFieldtxt(markType).css("font-family");
		var fieldWidth = getDocMarkFieldtxt(markType).width();
		if(fieldWidth < 230) {
			var zidongWidth = fieldWidth - 40;
			var shouxieWidth = fieldWidth;
			var numberWidth = zidongWidth - 65 - 10 - 20;

			getDocMarkDiv(markType).css({"margin-top": "2px", "margin-left":"0px", "margin-right":"0px"});

			getWordNoSelecttxt(markType).css({"width":zidongWidth + "px", "margin-top":"0px", "margin-left":"0px", "margin-right":"0px", "font-size":fontSize, "font-family":fontFamily});
			getYearNoSelect(markType).css({"width":"65px","height":"22px", "margin-left":"0px", "margin-right":"0px", "margin-top":"2px", "font-size":fontSize, "font-family":fontFamily, "vertical-align":"middle"});
			getMarkNumberInput(markType).css({"width": numberWidth + "px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"2px", "font-size":fontSize, "font-family":fontFamily});
			getMarkNoSuffix(markType).css({"width":"10px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"2px", "font-size":fontSize, "font-family":fontFamily});

			getShouxieInput(markType).css({"width": fieldWidth + "px","height":"18px", "margin-left":"0px", "margin-right":"0px", "font-size":fontSize, "font-family":fontFamily});
		} else {
			//-年号-流水号-后缀-下拉图标
			var zidongWidth = fieldWidth - 65 - 40 - 10 - 13 - 40;
			var shouxieWidth = fieldWidth - 13;
			getDocMarkDiv(markType).css({"margin-top": "2px", "margin-left":"0px", "margin-right":"0px"});
			
			getWordNoSelecttxt(markType).css({"width":zidongWidth + "px", "margin-top":"0px", "margin-left":"0px", "margin-right":"0px", "font-size":fontSize, "font-family":fontFamily});
			getYearNoSelect(markType).css({"width":"65px","height":"22px", "margin-left":"0px", "margin-right":"0px", "margin-top":"0px", "font-size":fontSize, "font-family":fontFamily, "vertical-align":"middle"});
			getMarkNumberInput(markType).css({"width":"40px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"0px", "font-size":fontSize, "font-family":fontFamily});
			getMarkNoSuffix(markType).css({"width":"10px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"0px", "font-size":fontSize, "font-family":fontFamily});

			getShouxieInput(markType).css({"width":shouxieWidth + "px","height":"18px", "margin-left":"0px", "margin-right":"0px", "margin-top":"0px", "font-size":fontSize, "font-family":fontFamily});
		}
	}
}
/**
 * 文号必填时设置控制背景颜色
 * @param markType
 */
function changeDocMarkBackgroundColor(markType) {
	//文号分三段显示
	if(docMarkFenduanKaiguan || serialNoFenduanKaiguan) {
		if(getMarkNoType(markType).val() != "2") {//自动文号
			if(getWordNoSelecttxt(markType).attr("changeBackgroundColor") == "true") {
				if(isMarkNull(getWordNoSelecttxt(markType).val())) {
					getWordNoSelecttxt(markType).css("background-color", nullColor);
				} else {
					getWordNoSelecttxt(markType).css("background-color", notNullColor);
				}
			}
			if(getMarkNumberInput(markType).attr("changeBackgroundColor") == "true") {
				if(isMarkNull(getMarkNumberInput(markType).val())) {
					getMarkNumberInput(markType).css("background-color", nullColor);
				} else {
					getMarkNumberInput(markType).css("background-color", notNullColor);
				}
			}
		} else {//手写文号
			if(getShouxieInput(markType).attr("changeBackgroundColor") == "true") {
				if(isMarkNull(getShouxieInput(markType).val())) {
					getShouxieInput(markType).css("background-color", nullColor);
				} else {
					getShouxieInput(markType).css("background-color", notNullColor);
				}
			}
		}
	} else {
		if(getDocMarkFieldtxt(markType).attr("changeBackgroundColor") == "true") {
			if(isMarkNull(getDocMarkFieldtxt(markType).val())) {
				getDocMarkFieldtxt(markType).css("background-color", nullColor);
			} else {
				getDocMarkFieldtxt(markType).css("background-color", notNullColor);
			}
		}
	}
}
/************** 文号样式加载 end *************/

/************** 收文见办加载 start ***********/
function initFormJianban() {
	var markType = "serial_no";

	//公文单文号校验界面，没有jianbanType参数，这里加上
	if(openFrom == "extend") {
		if(serialNoFenduanKaiguan) {
			getDocMarkDiv(markType).append("<input type='hidden' id='jianbanType' name='jianbanType' value='1'/>")
		} else {
			getDocMarkFieldspan(markType).append("<input type='hidden' id='jianbanType' name='jianbanType' value='1'/>")
		}
	}
	//若见办开关关了，则手动改成非见
	if(!serialNoJianbanKaiguan) {
		if($("#jianbanType").val() == "2") {
			$("#jianbanType").val("1");
		}
	}
	//未开启时，将全局设为办件，一下代码处理该问题： GFEZ-1641 公文开关关闭见后，已经有见的公文在待登记下编辑，文号没有显示见，但是下拉框点击一次后就又有见了
	var serialnoId = getDocMarkFieldtxt(markType).attr("id");
	getCtpTopFromOpener(window).jianbanType = serialnoId + $("#jianbanType").val();
}

function changeJianbanEventOne(selectedObj) {
	var markType = "serial_no";
	if($("#jianbanType").val() == "2") {//见办
		//循环设置机构代字+见
		getDocMarkField(markType).find("option").each(function() {
			var html = $(this).html(); 
			var optionVal = $(this).val();
			if(html != "请选择内部文号" && optionVal != "") {
				var defaultHtml = $(this).attr("defaultHtml");
				if(defaultHtml && $("#oldJianbanType").val() == "2") {
					newHtml = defaultHtml;
				} else {
					var oldHtml = $(this).attr("oldHtml");
					var newHtml = html;
					if(oldHtml) {
						if(html == oldHtml) {
							newHtml = "见" + oldHtml;
						}
					}
					
					$(this).val(optionVal.replace("|"+html+"|", "|"+newHtml+"|"));
					$(this).html(newHtml);
					$(this).attr("title", newHtml);
				}
			}
		});
	} else {//办
		//循环设置机构代字-见
		getDocMarkField(markType).find("option").each(function() {
			var html = $(this).html();
			var optionVal = $(this).val();
			if(html != "请选择内部文号" && optionVal != "") {
				var newHtml = html;
				var defaultHtml = $(this).attr("defaultHtml");
				if(defaultHtml && $("#oldJianbanType").val() == "2") {
					newHtml = defaultHtml.substring(1);
				} else {
					if(html.indexOf("见")==0) {
						var oldHtml = $(this).attr("oldHtml");
						if(oldHtml) {
							if(html.indexOf(oldHtml) == 1) {
								newHtml = oldHtml;
							}
						}
					}
				}
				$(this).val(optionVal.replace("|"+html+"|", "|"+newHtml+"|"));
				$(this).html(newHtml);
			}
		});
	}

	changeJianbanClass();
	
	var selectedOption = getDocMarkField(markType).find("option:selected");
	if(selectedOption.html() != "") {
		getDocMarkFieldtxt(markType).val(selectedOption.html());
	}
	getDocMarkFieldtxt(markType).attr("data", select2DataStr(getDocMarkField(markType)));
}

/**
 * 设置见办参数
 * @param action
 */
function changeJianbanEventThree(markType, action) {
	var markType = "serial_no";
	if($("#jianbanType").val() == "2") {//见办
		//循环设置机构代字+见
		getWordNoSelect(markType).find("option").each(function() {
			var html = $(this).html();
			if(html != "请选择机构代字" && $(this).val() != "") {
				var oldHtml = $(this).attr("oldHtml");
				var newHtml = html;
				if(oldHtml) {
					if(html == oldHtml) {
						newHtml = "见" + oldHtml;
					}
				}
				
				$(this).html(newHtml);
			}
		});
		
		//手写输入框+见
		var shouxieVal = getShouxieInput(markType).val();
		if(shouxieVal.indexOf("见") != 0) {
			shouxieVal = "见" + shouxieVal;
			getShouxieInput(markType).val(shouxieVal);
		}
		
	} else {//取消见
		//循环设置机构代字-见
		getWordNoSelect(markType).find("option").each(function() {
			var html = $(this).html();
			if(html != "请选择机构代字" && $(this).val() != "") {
				if(html.indexOf("见") == 0) {
					var oldHtml = $(this).attr("oldHtml");
					var newHtml = html;
					if(oldHtml) {
						if(html.indexOf(oldHtml)==1) {
							newHtml = oldHtml;
						}
					}
					$(this).html(newHtml);
				}
			}
		});
		
		//手写输入框-见
		var shouxieVal = getShouxieInput(markType).val();
		if(shouxieVal.indexOf("见") == 0) {
			shouxieVal = shouxieVal.substring(1);
			getShouxieInput(markType).val(shouxieVal);
		}
	}
	
	changeJianbanClass();
	
	//设置txt控件的值
	if(getWordNoSelecttxt(markType)) {
		getWordNoSelecttxt(markType).val(getWordNoSelect(markType).find("option:selected").html());
	}
	//设置txt控件的data属性
	getWordNoSelecttxt(markType).attr("data", select2DataStr(getWordNoSelect(markType)));

	//分三段需要维护一段的数据
	changeJianbanEventOne();
}

function changeJianbanClass() {
	if($("#jianbanType").val() == "2") {//见办
		//见办按钮图标切换
		if(formZwIframe.find("#jianbanIcon").hasClass("xl_icon_j")) {
			formZwIframe.find("#jianbanIcon").removeClass("xl_icon_j");
		}
		if(!formZwIframe.find("#jianbanIcon").hasClass("xl_icon_j_cal")) {
			formZwIframe.find("#jianbanIcon").addClass("xl_icon_j_cal");
		}
	} else {
		//见办按钮图标切换
		if(formZwIframe.find("#jianbanIcon").hasClass("xl_icon_j_cal")) {
			formZwIframe.find("#jianbanIcon").removeClass("xl_icon_j_cal");
		}
		if(!formZwIframe.find("#jianbanIcon").hasClass("xl_icon_j")) {
			formZwIframe.find("#jianbanIcon").addClass("xl_icon_j");
		}
	}	
}
/************** 收文编号加载 end *************/


/************** 对象获取方法 start ***********/
function getDocMarkDiv(markType) {
	if(markType == "serial_no") {
		return serialNoDiv;
	} else {
		return docMarkDiv;
	}
}
function getDocMarkFieldspan(markType) {
	if(markType == "serial_no") {
		return serialNoFieldspan;
	} else if(markType == "doc_mark") {
		return docMarkFieldspan;
	} else {
		return signMarkFieldspan;
	}
}
function getDocMarkField(markType) {
	if(markType == "serial_no") {
		return serialNoField;
	} else if(markType == "doc_mark") {
		return docMarkField;
	} else {
		return signMarkField;
	}
}
function getDocMarkFieldtxt(markType) {
	if(markType == "serial_no") {
		return serialNoFieldtxt;
	} else if(markType == "doc_mark") {
		return docMarkFieldtxt;
	} else {
		return signMarkFieldtxt;
	}
}
function getWordNoSelect(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoWordNoSelect");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoWordNoSelect");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#wordNoSelect");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#wordNoSelect");
			}
		}
	}
	return null;
}
function getYearNoSelect(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoYearNoSelect");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoYearNoSelect");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#yearNoSelect");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#yearNoSelect");
			}
		}
	}
	return null;
}
function getMarkNoSuffix(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoMarkNoSuffix");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoMarkNoSuffix");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#markNoSuffix");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#markNoSuffix");
			}
		}
	}
	return null;
}
function getMarkNumberInput(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoMarkNumberInput");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoMarkNumberInput");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#markNumberInput");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#markNumberInput");
			}
		}
	}
	return null;
}
function getShouxieInput(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoShouxieInput");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoShouxieInput");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#shouxieInput");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#shouxieInput");
			}
		}
	}
	return null;
}
function getZidongDiv(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoZidongDiv");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoZidongDiv");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#zidongDiv");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#zidongDiv");
			}
		}
	}
	return null;
}
function getShouxieDiv(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoShouxieDiv");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoShouxieDiv");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#shouxieDiv");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#shouxieDiv");
			}
		}
	}
	return null;
}
function getMarkNoType(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			try {
				return serialNoDiv.find("#serialNoMarkNoType");
			} catch(e) {
				return formZwIframe.find("#serialNoDiv").find("#serialNoMarkNoType");
			}
		}
	} else if(markType == "sign_mark") {
		if(signMarkDiv) {
			try {
				return signMarkDiv.find("#signMarkNoType");
			} catch(e) {
				return formZwIframe.find("#signMarkDiv").find("#signMarkNoType");
			}
		}
	} else {
		if(docMarkDiv) {
			try {
				return docMarkDiv.find("#markNoType");
			} catch(e) {
				return formZwIframe.find("#docMarkDiv").find("#markNoType");
			}
		}
	}
	return null;
}
function getDocMarkIconDiv(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			return serialNoDiv.find("#serialNoIconDiv");
		}
	} else if(markType == "sign_mark") {
		if(signMarkDiv) {
			return signMarkDiv.find("#signMarkIconDiv");
		}
	} else {
		if(docMarkDiv) {
			return docMarkDiv.find("#iconDiv");
		}
	}
	return null;
}
function getWordNoSelecttxt(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			return serialNoDiv.find("#serialNoWordNoSelect_txt");
		}
	} else {
		if(docMarkDiv) {
			return docMarkDiv.find("#wordNoSelect_txt");
		}
	}
	return null;
}
function getZidongIcon(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			return serialNoDiv.find("#serialNoZidongIcon");
		}
	} else {
		if(docMarkDiv) {
			return docMarkDiv.find("#zidongIcon");
		}
	}
	return null;
}
function getShouxieIcon(markType) {
	if(markType == "serial_no") {
		if(serialNoDiv) {
			return serialNoDiv.find("#serialNoShouxieIcon");
		}
	} else {
		if(docMarkDiv) {
			return docMarkDiv.find("#shouxieIcon");
		}
	}
	return null;
}
function getWordNoCallback(markType) {
	if(markType == "serial_no") {
		return "SerialNoWordNoChangeCallBackThree";
	} else {
		return "DocMarkWordNoChangeCallBackThree";
	}
}
function getDocMarkChooseUrl(markType) {
	if(markType == "serial_no") {
		return serialNoChooseUrl + "&selDocmark=my:" + markType;
	} else if(markType == "doc_mark") {
		return docMarkChooseUrl + "&selDocmark=my:" + markType;
	} else {
		return signMarkChooseUrl + "&selDocmark=my:" + markType;
	}
}
function getDocMarkValidate(markType) {
	if(markType == "serial_no") {
		return 'name:"内部文号",fieldType:"VARCHAR",errorMsg:"内部文号不允许为空",errorAlert:true,notNull:true,checkNull:true,errorIcon:false,func:validateBaseMark';
	} else {
		return 'name:"公文文号",fieldType:"VARCHAR",errorMsg:"公文文号不允许为空",errorAlert:true,notNull:true,checkNull:true,errorIcon:false,func:validateBaseMark';
	}
}
/************** 对象获取方法 end *************/


/************** 工具方法加载 start ***********/
/**
 * 按文号长度填充文号，如文号"1"长度为4，则返回"0001"
 * @param markFullNumber
 * @param markLength
 * @returns {String}
 */
function getFullMarkNumber(markFullNumber, markLength) {
	var str = "";
	if(markFullNumber) {
		if(markFullNumber.length < markLength) {
			for(var i=0; i<markLength - markFullNumber.length; i++) {
				str += "0";
			}
		}
		str += markFullNumber;
	}
	return str;
}
/**
 * 通过文号格式，拆分文号，获取年份
 * @param markstr
 * @param left
 * @param right
 * @param suffix
 * @returns
 */
function getMarkYearNo(markstr, left, right, suffix) {
	if(markstr) {
		var rightIndex = markstr.lastIndexOf(right);
		if(rightIndex != -1) {
			var rightstr = markstr.substring(0, rightIndex);
			var leftIndex = rightstr.lastIndexOf(left);
			var yearNo = rightstr.substring(leftIndex + 1, rightIndex);
			return yearNo;
		}
	}
	return yearNo;
}
/**
 * 从select提取数据，拼装为字符串
 * @param select
 * @returns {String}
 */
function select2DataStr(select) {
	var datastr = "selectdata : [";
	var i = 0;
	var length = select.find('option').size();
	select.find('option').each(function() {
		var option = $(this);
		var label = option.text();
		var title = option.attr('title');
		if(title==undefined){
			title = label;
		}
		if(i != 0) {
			datastr += ",";
		}
		datastr += "{";
		datastr += "label:'" + label + "',";
		datastr += "title:'" + title + "',";
		datastr += "value:'" + option.val()+"'";
		datastr += "}";
		i++;
	});
	datastr += "]";
	return datastr;
}
/**
 * 从select提取数据，拼装为对象(暂无用)
 * @param select
 * @returns {Array}
 */
function select2Data(select) {
	var data = [];
    select.find('option').each(function() {
        var option = $(this);
        var label = option.text();
        var title = option.attr('title');
        if(title==undefined){
            title = label;
        }
        data.push({value:option.val(),
            label:label,
            title:title
        });
    });
    return data;
}

function isMarkNull(value) {
	return (value===null || value==""||$.trim(value)==""||value==="0"
		||(value!=null && (value.split("|").length>1 && (value.split("|")[1]=="" || $.trim(value.split("|")[1])=="")))
		||value=="请选择机构字号"||value==="请选择公文文号"||value==="请选择内部文号"||value==="请选择签收编号");
}
function isMarkValueNull(value) {
	return (value===null||value===""||value==="请选择机构字号"||value==="请选择公文文号"||value==="请选择内部文号"||value==="请选择签收编号");
}
function isMarkNumberNull(value) {
	return (value===""||$.trim(value)=="");
}

function reloadGovdocForm() {
	isLoadDocMark = false;
	isLoadSerialNo = false;
	isLoadSignMark = false;
	isLoadForm = false;
	
	if($("#jianbanType").val() == "2") {
		$("#oldJianbanType").val($("#jianbanType").val());
	}
}
/************** 工具方法加载 end *************/


/**
 *
 * @param markType
 */
function initDocMarkValidate(markType) {
	//文号分3段显示
	if(docMarkFenduanKaiguan || serialNoFenduanKaiguan) {
		var validate = getWordNoSelecttxt(markType).attr("validate");
		if(!validate || validate=="") {
			var visible = getWordNoSelecttxt(markType).is(":visible");
			if(visible) {
				getWordNoSelecttxt(markType).attr("validate", getDocMarkValidate(markType));
			} else {
				getShouxieInput(markType).attr("validate", getDocMarkValidate(markType));
			}
			getMarkNumberInput(markType).attr("validate", "");
		}
	} else {
		var validate = getDocMarkFieldtxt(markType).attr("validate");
		if(!validate || validate=="") {
			getDocMarkFieldtxt(markType).attr("class", "validate");
			getDocMarkFieldtxt(markType).attr("validate", getDocMarkField(markType).attr("validate"));
			if(getDocMarkField(markType).hasClass("validate")) {
				getDocMarkField(markType).removeClass("validate");
			}
		}
	}
}

function validateBaseMark(obj, param) {
	try {
		var isValidate = false;
		var checkObj;
		var markType;
		var markType;
		//文号分段
		if(obj.attr("validate").indexOf("内部文号") != -1) {
			markType = "serial_no";
		} else {
			markType = "doc_mark";
		}

		if((markType == "doc_mark" && docMarkFenduanKaiguan) || (markType == "serial_no" && serialNoFenduanKaiguan)) {
			checkObj = getDocMarkField(markType);
		} else {
			checkObj = getDocMarkFieldtxt(markType);
		}

		if(checkObj && checkObj.attr("validate") && checkObj.attr("validate")!="") {
			var validateObj = $.parseJSON("{"+checkObj.attr("validate")+"}");
			if(validateObj.notNull && param.checkNull) {
				isValidate = true;
			}
		}
		if(!isValidate) {
			if(markType=="doc_mark" && markGovdocType == "1") {
				if($("#isQuickSend").val()=="true" || $("#policy").val()=="faxing"||$("#fenfadanwei").is(":visible")) {
					isValidate = true;
				}
			}
		}
		
		if(isValidate) {
			var markstr = getMarkstr(markType);
		    if(isMarkNull(markstr)) {
		    	//文号分段显示
		    	if(docMarkFenduanKaiguan || serialNoFenduanKaiguan) {
	    			getWordNoSelecttxt(markType).attr("changeBackgroundColor", "true");
		    		getShouxieInput(markType).attr("changeBackgroundColor", "true");
		    		getMarkNumberInput(markType).attr("changeBackgroundColor", "true");

	    			if(getMarkNoType(markType).val() != "2") {//自动文号
	    				getWordNoSelecttxt(markType).css("background-color", nullColor);
			    		var visible = getMarkNumberInput(markType).is(":visible");
				    	if(visible) {
				    		var value = getMarkNumberInput(markType).val();
							if(isMarkNumberNull(value)) {
								getMarkNumberInput(markType).css("background-color", nullColor);
							}
				    	}
	    			} else {//手写文号
	    				getShouxieInput(markType).css("background-color", nullColor);
	    			}
		    	} else {
	    			getDocMarkFieldtxt(markType).attr("changeBackgroundColor", "true");
	    			getDocMarkFieldtxt(markType).css("background-color", nullColor);
		    	}
		        return false;
		    }
		    if(docMarkFenduanKaiguan || serialNoFenduanKaiguan) {
	    		getWordNoSelecttxt(markType).attr("changeBackgroundColor", "true");
	    		getShouxieInput(markType).attr("changeBackgroundColor", "true");
	    		getMarkNumberInput(markType).attr("changeBackgroundColor", "true");

	    		if(getMarkNoType(markType).val() != "2") {//自动文号
		    		var visible = getMarkNumberInput(markType).is(":visible");
			    	if(visible) {
			    		value = getMarkNumberInput(markType).val();
						if(isMarkNumberNull(value)) {
							getMarkNumberInput(markType).css("background-color", nullColor);
							return false;
						}
			    	}
	    		} else {//手写文号
	    			getShouxieInput(markType).attr("changeBackgroundColor", "true");
	    			var visible = getShouxieInput(markType).is(":visible");
			    	if(visible) {
			    		value = getShouxieInput(markType).val();
			    		if(value == "") {
			    			getShouxieInput(markType).css("background-color", nullColor);
			    			return false;
			    		}
			    	}
	    		}
		    }
		}
	} catch(e) {}

	return true;
}

function getMarkstr(markType) {
	var isQuickSend = $("#isQuickSend").val();
	var summaryId = $("#summaryId").val();
	var orgAccountId = $("#orgAccountId").val();
	var nodePolicy = $("#policy").val();
	var jianbanType = $("#jianbanType").val();

	var markstr = "";
	var markSelect = getDocMarkField(markType);
	if(markSelect && markSelect.size()>0) {
		var tagName = markSelect[0].tagName;
		//公文文号或内部文号开启了三段文号显示，则取field的select中的值
		if((markType == "doc_mark" && docMarkFenduanKaiguan) || (markType == "serial_no" && serialNoFenduanKaiguan)) {
			var docMarktxt = getDocMarkFieldtxt(markType);
			if(docMarktxt && docMarktxt.attr("id")) {
				markstr = docMarktxt.val();
			} else {
				markstr = markSelect.html();
			}
		}
		//若没有开启三段，则按控件是input或select框来取值
		else {
			if(tagName.toLowerCase() == "input") {//来文文号
				markstr = getDocMarkField(markType).val();
			} else {
				var docMarktxt = getDocMarkFieldtxt(markType);
				if(docMarktxt && docMarktxt.attr("id")) {
					markstr = docMarktxt.val();
				} else {
					markstr = markSelect.html();
				}
			}
		}
	}
	
	//给收文编号去掉见
	if(serialNoJianbanKaiguan && markType=="serial_no") {
		if(markGovdocType=="2" && jianbanType == "2") {
			if(markstr.indexOf("见") == 0) {
				markstr = markstr.substring(1);
			}
		}
	}
	
	if(isMarkValueNull(markstr)) {
		markstr = "";
	}
	
	if(markstr && markstr != "") {
		if(markstr.indexOf(" ") == 0 || markstr.indexOf(" ") == markstr.length-1) {
			markstr = markstr.trim();
		}
	}
	
	return markstr;
}

/**
 * 检查公文文号重复
 * @param markstr
 * @param markType
 * @param callback
 * @returns {Boolean}
 */
function checkGovdocMarkUsed(markstr, markType, callback) {
	var isQuickSend = $("#isQuickSend").val();
	var summaryId = $("#summaryId").val();
	var orgAccountId = $("#orgAccountId").val();
	var nodePolicy = $("#policy").val();
	var jianbanType = $("#jianbanType").val();
	var markTypeTitle;

	var docMark = getDocMarkField(markType);
	if(!docMark || !docMark.attr("id")) {
		return false;
	}

	if(markType=="doc_mark") {
		if(markGovdocType=="1"||markGovdocType=="3") {
			markTypeTitle = "公文文号";
		} else {
			markTypeTitle = "来文文号";
		}
	} else if(markType=="serial_no") {
		if(markGovdocType=="1"||markGovdocType=="3") {
			markTypeTitle = "内部文号";
		} else if(markGovdocType=="4") {
			markTypeTitle = "签收编号";
		} else {
			markTypeTitle = "收文编号";
		}
	} else {
		markTypeTitle = "签收编号";
	}

	markstr = getMarkstr(markType);
	
	//交换时才需要校验文号是否为空
	if(isMarkNull(markstr)) {
		if(markType == "doc_mark") {
			if((markGovdocType == "1" && (isQuickSend=="true"||nodePolicy=="faxing"||$("#fenfadanwei").is(":visible")))) {
				alert(markTypeTitle + "不允许为空");
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	if(getMarkNumberInput(markType)) {
		var visible = getMarkNumberInput(markType).is(":visible");
		if(visible) {
			try {
				if(isMarkNumberNull(getMarkNumberInput(markType).val())) {
					alert(markTypeTitle + "流水号不能为空！");
					return true;
				}
				if(Number(getMarkNumberInput(markType).val()) == 0) {
					alert(markTypeTitle + "流水号不能为0！");
					return true;
				}
			} catch(e) {}
		}
	}
	
	//收文、签报、签收编号、快速发文需要校验
	if(markGovdocType == "2" || markGovdocType == "3"
		|| (markGovdocType=="4"&&(markType=="serial_no" || markType=="sign_mark"))
		|| (markGovdocType == "1" && (isQuickSend=="true"||nodePolicy=="faxing"||$("#fenfadanwei").is(":visible")))) {

		//收文与签报时，无文号编辑权限，来文文号重复、收文编号重复、无见办文件均不提示
		if(markGovdocType=="2" || markGovdocType=="4") {
			if(getDocMarkField(markType) && getDocMarkField(markType)[0].tagName.toLowerCase()=="span") {
				return false;
			}
		}

		var eManager = new edocManager();
		var isUsed = eManager.isGovdocMarkUsed(markstr, markGovdocType, jianbanType, markType, summaryId, orgAccountId);
		if(isUsed==true) {//被占用
			if(jianbanType == "2") {
				return false;
			}
			if(markGovdocType=="2" && markType=="doc_mark") {//新公文收文的文号重复，可以询问是否继续
				var confirmMsg = "来文文号在收文中已存在，是否继续？";
				if(callback) {
					var confirm = $.confirm({
						'msg': confirmMsg,
						ok_fn: function () {
							callback();
							return false;
						},
						cancel_fn:function() {
							confirm.close();
							return true;
						}
					});
				} else {
					if(window.confirm(confirmMsg)) {
						return false;
					} else {
						return true;
					}
				}
			} else {
				alert(markTypeTitle + "重复,请重新选择!");
				return true;
			}
		} else {
			if(markGovdocType=="2" && jianbanType == "2") {//见办文
				if(markType == "serial_no") {
					var confirmMsg = "未登记过相同办件号文件，确认是否仍需进行？";
					if(callback) {
						var confirm = $.confirm({
							'msg': confirmMsg,
							ok_fn: function () {
								callback();
								return false;
							},
							cancel_fn:function() {
								confirm.close();
								return true;
							}
						});
					} else {
						if(window.confirm(confirmMsg)) {
							return false;
						} else {
							return true;
						}
					}
				}
			}
		}
	}
	return false;
}

/**
 * 
 * @param markType
 * @param markstr
 * @returns
 */
function resetMarkValueByMarkType(markType, markstr) {
	//若公文文号为空，则去空格
	if(markstr && markstr != "") {
		if(markstr.indexOf(" ") == 0 || markstr.indexOf(" ") == markstr.length-1) {
			markstr = markstr.trim();
	
			if(markType=="doc_mark") {
				if(docMarkFenduanKaiguan) {
					var visible = getShouxieInput(markType).is(":visible");
					if(visible) {
						getShouxieInput(markType).val(markstr);
						var fieldValue = "0|" + markstr + "||3";
						resetDocMarkFieldValue(markType, markstr, fieldValue);
					}
				}
			} else if(markType=="serial_no") {
				if(serialNoFenduanKaiguan) {
					//手写文号去办
					var visible = getShouxieInput(markType).is(":visible");
					if(visible) {
						getShouxieInput(markType).val(markstr);
						var fieldValue = "0|" + markstr + "||3";
						resetDocMarkFieldValue(markType, markstr, fieldValue);
					} else {
						var selectedVal = getDocMarkField(markType).val();
						selectedVal = selectedVal.replace("|"+selectedVal.split("|")[1]+"|", "|"+markstr+"|");
						resetDocMarkFieldValue(markType, markstr, selectedVal);
					}
				}
			}
		}
	}
	
	if(markType=="serial_no") {
		//见办内容为空，置为非见办
		if(serialNoJianbanKaiguan) {
			if(markstr=="" || $.trim(markstr)=="") {
				if($("#jianbanType").val() == "2") {
					$("#jianbanType").val("1");
				}
			}
		} else {//见办开关停用，置为非见办
			if($("#jianbanType").val() == "2") {
				$("#jianbanType").val("1");
			}
		}
	}
	
	return markstr;
}

/**
 * 提交前重置公文文号参数
 */
function resetMarkParamBeforeSubmit(markType, markstr) {
	if(!markType && !markstr) {
		markType = "doc_mark";
		markstr = getMarkstr(markType);
		resetMarkValueByMarkType(markType, markstr);
		
		markType = "serial_no";
		markstr = getMarkstr(markType);
		resetMarkValueByMarkType(markType, markstr);
		
		markType = "sign_mark";
		markstr = getMarkstr(markType);
		resetMarkValueByMarkType(markType, markstr);
	} else {
		markstr = resetMarkValueByMarkType(markType);
	}
	return markstr;
}
