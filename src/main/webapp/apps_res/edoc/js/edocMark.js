// add by handy,2007-09-20 16:43

function addMarkDefPage() {
	parent.detailFrame.location.href = edocMarkURL + "?method=addMarkPage";
}


function checkMaxSize(element){
	var maxLength = detailForm.element.maxSize;
	var length = detailForm.element.value.length;
	if(maxLength && length > maxLength){
		writeValidateInfo(element, v3x.getMessage("V3XLang.formValidate_maxLength", inputName, maxLength, value.length));
		return false;
	}
}

// 检查输入格式长度方法，因formValidate的检查未生效，单独做此方法
function checkMaxLength(element){

	var value = element.value;
	if(!value){
		return true;
	}

	var inputName = element.getAttribute("inputName");
	
	var maxLength = element.getAttribute("maxSize");
	
	if(maxLength && value.length > maxLength){
		writeValidateInfo(element, v3x.getMessage("V3XLang.formValidate_maxLength", inputName, maxLength, value.length));
		return false;
	}
	
	return true;
}

function createMarkDef() {
	if(!checkMaxLength(detailForm.wordNo)){return;}
	if(!checkMaxLength(detailForm.format_a)){return;}
	if(!checkMaxLength(detailForm.format_b)){return;}
	if(!checkMaxLength(detailForm.format_c)){return;}
	
	//检查特殊字符 |
    if(!checkSpecialChar(detailForm.wordNo)){return;}
    if(!checkSpecialChar(detailForm.format_a)){return;}
    if(!checkSpecialChar(detailForm.format_b)){return;}
    if(!checkSpecialChar(detailForm.format_c)){return;}
	

	var _flowNoType = document.getElementsByName("flowNoType");
	var _categoryId = document.getElementById("categoryId");	
	if (detailForm.wordNo.value.indexOf('"') !=-1||detailForm.wordNo.value.indexOf('|') !=-1) {
		alert(v3x.getMessage("edocLang.mark_alter_word_no_not_include_quotes"));
		return ;
	}

	else if (_flowNoType[1].checked && _categoryId.options[_categoryId.options.selectedIndex].value == "0"){
		alert(v3x.getMessage("edocLang.big_stream_alter_not_select"));
		return;
	}
	else if (!checkDocNo(detailForm)){
		return;
	}
	else {
		if(detailForm.wordNo.value != "") {
			detailForm.wordNo.value = $.trim(detailForm.wordNo.value);
		}
		detailForm.target = "empty";
		detailForm.action = edocMarkURL + "?method=createMark";
		detailForm.submit();
	}
}

function editMarkDefPage(id, flag, accountIdValue) {
	var aUrl = edocMarkURL + "?method=editMarkPage&flag=" + flag;
	var checkid = id;
	if (checkid == "undefined") {
		checkid = document.getElementsByName('id');
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			if (!checkid.checked) {
				alert(v3x.getMessage("edocLang.doc_mark_alter_not_write"));
				return ;
			}	
			else {
				var aId = mainForm.id.value;
				aUrl += "&id=" + aId;
			}
		}
		else {
			var j = 0;
			for (i = 0; i <len; i++) {
				if (checkid[i].checked == true) {
				//G6 V1.0 SP1后续功能_自定义签收编号start
					//检查如果不是自己单位建的签收编号，如果不是的话是没有修改权限的
					var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "isEditEdocMark", false);
			  		requestCaller.addParameter(1,'String',checkid[i].value);
			  		requestCaller.addParameter(2,'String',checkid[i].getAttribute("accountId"));
			  		isCanBeRegisted = requestCaller.serviceRequest();
			  		if(isCanBeRegisted != "true"){
			  			alert(v3x.getMessage("edocLang.doc_mark_alter_not_edit"));
			  			return;
			  		}
			  		//G6 V1.0 SP1后续功能_自定义签收编号end
					aUrl += "&id=" + checkid[i].value;
					j++;
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("edocLang.doc_mark_alter_select_deleted"));
				return ;
			}
			else if (j > 1){
				alert(v3x.getMessage("edocLang.doc_mark_alter_select_one"));
				return ;
			}
		}
	}
	else {
		if(accountIdValue){
			var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "isEditEdocMark", false);
	  		requestCaller.addParameter(1,'String',id);
	  		requestCaller.addParameter(2,'String',accountIdValue);
	  		isCanBeRegisted = requestCaller.serviceRequest();
	  		if(isCanBeRegisted != "true"){
	  			alert(v3x.getMessage("edocLang.doc_mark_alter_not_edit"));
	  			return;
	  		}
		}
		aUrl += "&id=" + id;
	}
	parent.detailFrame.location = aUrl;
}

function updateMarkDef() {	
	if(!checkMaxLength(detailForm.wordNo)){return;}
	if(!checkMaxLength(detailForm.format_a)){return;}
	if(!checkMaxLength(detailForm.format_b)){return;}
	if(!checkMaxLength(detailForm.format_c)){return;}

    //检查特殊字符 |
    if(!checkSpecialChar(detailForm.wordNo)){return;}
    if(!checkSpecialChar(detailForm.format_a)){return;}
    if(!checkSpecialChar(detailForm.format_b)){return;}
    if(!checkSpecialChar(detailForm.format_c)){return;}

    $("#updateMarkDefButton").attr("disabled", true); 
    
	var _flowNoType = document.getElementsByName("flowNoType");
	var _categoryId = document.getElementById("categoryId");	
	var docMarkId = document.getElementById("id");
	if (_flowNoType[1].checked && _categoryId.options[_categoryId.options.selectedIndex].value == "0"){
		$("#updateMarkDefButton").removeAttr("disabled"); 
		alert(v3x.getMessage("edocLang.big_stream_alter_not_select"));
		return;
	}
	if (!checkDocNo(detailForm)){
		$("#updateMarkDefButton").removeAttr("disabled"); 
		return;
	}
	else {
		var flowNoType2 = document.getElementById("flowNoType2").checked;//0-小流水；1-大流水	
		var oldCodeMode = document.getElementById("oldCodeMode").value;
		var delMarkReserve = false;
		//1.如果是小流水，修改为大流水的时候，判断一下，如果有预留文号相关的设置，给出提示“修改为大流水，将会清除预留文号，是否继续？”
		//2.如果选择是，就清除预留文号相关的设置。 
		if(oldCodeMode == "0" && flowNoType2 == true){
			var requestCaller = new XMLHttpRequestCaller(this, "edocMarkReserveManager", "hasMarkReserve", false);
			requestCaller.addParameter(1, "String", docMarkId.value);
			var rs = requestCaller.serviceRequest();
			if(rs=='true') {
				if(confirm("修改为大流水，将会清除预留文号，是否继续?")){
					delMarkReserve = true;
				}else{
					$("#updateMarkDefButton").removeAttr("disabled"); 
					return;
				}
		    }
		}
		if(detailForm.wordNo.value != "") {
			detailForm.wordNo.value = $.trim(detailForm.wordNo.value);
		}
		detailForm.target = "empty";
		detailForm.action = edocMarkURL + "?method=updateMark&delMarkReserve="+delMarkReserve;
		detailForm.submit();
	}
}

function deleteMarkDef() {
	var ids = document.getElementsByName("id");
	var _deleteInfo = document.getElementById("deleteInfo");
	_deleteInfo.innerHTML = "";
	var temp = 0;
	for (var i = 0; i < ids.length; i++) {
		if(ids[i].checked) {	
		//G6 V1.0 SP1后续功能_自定义签收编号start
			//检查如果不是自己单位建的签收编号，如果不是的话是没有修改权限的
			var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "isEditEdocMark", false);
	  		requestCaller.addParameter(1,'String',ids[i].value);
	  		requestCaller.addParameter(2,'String',ids[i].getAttribute("accountId"));
	  		isCanBeRegisted = requestCaller.serviceRequest();
	  		if(isCanBeRegisted != "true"){
	  			alert(v3x.getMessage("edocLang.doc_mark_alter_not_delete"));
	  			return;
	  		}
	  		//G6 V1.0 SP1后续功能_自定义签收编号end
			_deleteInfo.innerHTML += "<input type=hidden name=markDefId value=" + ids[i].value + ">";
			temp = temp + 1;
		}
	}
	if (temp == 0) {
		alert(v3x.getMessage("edocLang.doc_mark_alter_select_deleted"));
		return ;
	}
	if(window.confirm(v3x.getMessage("edocLang.doc_mark_alter_delete_confirm"))){
		mainForm.target = "empty";
		mainForm.action = edocMarkURL + "?method=deleteMark";
		mainForm.submit();
	}
}

function validate2Year(markTypeV){
	try{
		var value = markTypeV;
		if(markTypeV && typeof(markTypeV)!='undefined' ){
			value = markTypeV;
		}else if(document.getElementById("markType")){
			value = document.getElementById("markType").value;
		}else{
			value=curMarkType;
		}
		if(flag == "edit"){
			if(value && value == 2){
				document.getElementById("twoYear").disabled = true;
				document.getElementById("twoYear").checked = "";
			}else{
				var yearEnabled = document.getElementById("yearEnabled").checked;
				if(yearEnabled == false){
					document.getElementById("twoYear").disabled = true;
					document.getElementById("twoYear").checked = "";
				}else{
					document.getElementById("twoYear").disabled = false;
				}
			}
		}else{
			document.getElementById("twoYear").disabled = true;
		}
	}catch(e){}
}

//clickFlag， 特殊标识，用作判断
function previewMark(clickFlag) {
	validate2Year();
	var yearEnabled = document.getElementById("yearEnabled").checked;
	var object1 = document.getElementById("wordNo").value;
	var object2 = document.getElementById("yearNo").value;
	
	var sNo = document.getElementById("minNo").value;
	var mNo = document.getElementById("maxNo").value;
	var cNo = document.getElementById("currentNo").value;
	
	var form_a = document.getElementById("format_a").value;
	var form_b = document.getElementById("format_b").value;
	var form_c = document.getElementById("format_c").value;
	
	var object3 = cNo;
	
	var ofl = document.getElementById("fixedLength");
	var zero = "";
	if(ofl.checked){
		if(mNo.length>cNo.length){
			var len = mNo.length-cNo.length;
			for(var i=0;i<len;i++){
				zero += "0";
			}
		}
		object3 = zero+cNo;
	}
	
	document.getElementById("wordNo_a").innerHTML = '<font color="red">'+ escapeHTMLToString(object1) + '</font>';
	document.getElementById("yearNo_a").innerHTML = '<font color="red">'+ escapeHTMLToString(object2) + '</font>';
	document.getElementById("flowNo_a").innerHTML = '<font color="red">'+ escapeHTMLToString(object3) + '</font>';

	if (yearEnabled){
		document.getElementById("format_a").style.display = "";
		document.getElementById("yearNo_a").style.display = "";	
		//GOV-3685 文号管理中，取消按年度编号，留了半个括号 changyi add
		document.getElementById("format_b").style.display = "";
		//lijl添加--------------Start
		if("yearEnabled" == clickFlag){
		    if(form_a == "" && form_b == ""){//表示
		        document.getElementById("format_a").value="〔";
		        document.getElementById("format_b").value="〕";
	        }
		}
		document.getElementById("wordNoPreview").innerHTML = '<font color="red">'+escapeHTMLToString(object1) + escapeHTMLToString(document.getElementById("format_a").value) + escapeHTMLToString(object2) + escapeHTMLToString(document.getElementById("format_b").value) + escapeHTMLToString(object3) + escapeHTMLToString(form_c) + '</font>';
		document.getElementById("markNo").value = "$WORD" + (document.getElementById("format_a").value) + "$YEAR" + (document.getElementById("format_b").value) + "$NO" + (form_c);
//		lijl添加--------------End
	}
	else {
		document.getElementById("format_a").style.display = "none";
		document.getElementById("yearNo_a").style.display = "none";
		
		//GOV-3685 文号管理中，取消按年度编号，留了半个括号 changyi add
		document.getElementById("format_b").style.display = "none";
		//document.getElementById("wordNoPreview").innerHTML = '<font color="red">'+escapeHTMLToString(object1) + escapeHTMLToString(form_b) + escapeHTMLToString(object3) + escapeHTMLToString(form_c) + '</font>';
		document.getElementById("wordNoPreview").innerHTML = '<font color="red">'+escapeHTMLToString(object1)  + escapeHTMLToString(object3) + escapeHTMLToString(form_c) + '</font>';
		//lijl注销
		//document.getElementById("markNo").value = "$WORD" + escapeHTMLToString(form_b) + "$NO" + escapeHTMLToString(form_c);
		//lijl添加----------------------Start
		var str="$WORD";
		str+="$NO" + (form_c);
		document.getElementById("markNo").value = str;
		//lijl添加----------------------End
	}	
	document.getElementById("length").value = mNo.length;
}


function setFixedLength() {
	var c_no = document.getElementById("currentNo").value;
	var length = document.getElementById("maxNo").value.length;
	var c_length = document.getElementById("currentNo").value.length;
	var str = "";
	if(c_length<length){
	  var len = length - c_length;	
		for(var i=0;i<len;i++){
			str += "0";
		}
		str += c_no;
	}
	else{
		str = c_no;
	}
	
	var fixedLength = document.getElementById("fixedLength");
	if(fixedLength.checked){
		document.getElementById("flowNo_a").innerHTML = '<font color="red">'+ str + '</font>';
	}
	else{
		document.getElementById("flowNo_a").innerHTML = '<font color="red">'+ c_no + '</font>';	    
	}	
	
	previewMark();
		
}


function streamChoose_small(flag){
	try{
	$("#hiddentr1").show();
	$("#hiddentr2").show();
	$("#hiddentr3").show();
	//$("#bigStream").show();
	//document.getElementById("hiddentr1").style.display = "block";
	//document.getElementById("hiddentr2").style.display = "block";
	//document.getElementById("hiddentr3").style.display = "block";
	//document.getElementById("bigStream").style.display = "none";
	}catch(e){}

	var minNoObj = document.getElementById("minNo");
	var bigStream = document.getElementById("bigStream");
	var maxNoObj = document.getElementById("maxNo");
	var curNoObj = document.getElementById("currentNo");
	var yearEnabledObj = document.getElementById("yearEnabled");

	if (flag == 1) {
		minNoObj.value = "1";
		maxNoObj.value = "1000";
		curNoObj.value = "1";
		yearEnabledObj.checked = true;
	}	
	
	minNoObj.disabled = false;
	maxNoObj.disabled = false;
	curNoObj.disabled = false;
	bigStream.style.display="none";
	yearEnabledObj.disabled = false;

	previewMark();
	
}

	
function streamChoose_big(){

	document.getElementById("bigStream").style.display = "";

	var minNoObj = document.getElementById("minNo");
	var maxNoObj = document.getElementById("maxNo");
	var curNoObj = document.getElementById("currentNo");
	var yearEnabledObj = document.getElementById("yearEnabled");

	var categoryId = document.getElementById("categoryId").options[document.getElementById("categoryId").selectedIndex].value;
	if (categoryId != 0) {
		var temp = document.getElementById("categoryId").options[document.getElementById("categoryId").selectedIndex];
		minNoObj.value = temp.getAttribute("temp_minNo");
		maxNoObj.value = temp.getAttribute("temp_maxNo");
		curNoObj.value = temp.getAttribute("temp_curNo");
		if (temp.getAttribute("temp_yearEnabled")=="false") {
			yearEnabledObj.checked = false;
		}
		else {
			yearEnabledObj.checked = true;
		}
		//yearEnabledObj.checked = temp.getAttribute("temp_yearEnabled");
	try{
		$("#hiddentr1").show();
		$("#hiddentr2").show();
		$("#hiddentr3").show();
	//document.getElementById("hiddentr1").style.display = "block";
	//document.getElementById("hiddentr2").style.display = "block";
	//document.getElementById("hiddentr3").style.display = "block";
	}catch(e){}
	}
	else {
		minNoObj.value = "";
		maxNoObj.value = "";
		curNoObj.value = "";
		yearEnabledObj.checked = false;
	try{
		$("#hiddentr1").hide();
		$("#hiddentr2").hide();
		$("#hiddentr3").hide();
	//document.getElementById("hiddentr1").style.display = "none";
	//document.getElementById("hiddentr2").style.display = "none";
	//document.getElementById("hiddentr3").style.display = "none";
	}catch(e){}
	}
	minNoObj.disabled = true;
	maxNoObj.disabled = true;
	curNoObj.disabled = true;
	yearEnabledObj.disabled = true;
	
	
	previewMark();
}


function changeBigStream() {
	try{
		$("#hiddentr1").show();
		$("#hiddentr2").show();
		$("#hiddentr3").show();
	//document.getElementById("hiddentr1").style.display = "block";
	//document.getElementById("hiddentr2").style.display = "block";
	//document.getElementById("hiddentr3").style.display = "block";
	}catch(e){}
	
	var minNoObj = document.getElementById("minNo");
	var maxNoObj = document.getElementById("maxNo");
	var curNoObj = document.getElementById("currentNo");
	var yearEnabledObj = document.getElementById("yearEnabled");

	var categoryId = document.getElementById("categoryId").options[document.getElementById("categoryId").selectedIndex].value;
	if (categoryId != 0) {
		var temp = document.getElementById("categoryId").options[document.getElementById("categoryId").selectedIndex];
		minNoObj.value = temp.getAttribute("temp_minNo");
		maxNoObj.value = temp.getAttribute("temp_maxNo");
		curNoObj.value = temp.getAttribute("temp_curNo");
		if (temp.getAttribute("temp_yearEnabled") == "true") {
			yearEnabledObj.checked = true;
		}
		else {
			yearEnabledObj.checked = false;
		}
		try{
			$("#hiddentr1").show();
			$("#hiddentr2").show();
			$("#hiddentr3").show();
		//document.getElementById("hiddentr1").style.display = "block";
		//document.getElementById("hiddentr2").style.display = "block";
		//document.getElementById("hiddentr3").style.display = "block";	
		}catch(e){}			
	}
	else {
		minNoObj.value = "";
		maxNoObj.value = "";
		curNoObj.value = "";
		yearEnabledObj.checked = false;
		try{
			$("#hiddentr1").hide();
			$("#hiddentr2").hide();
			$("#hiddentr3").hide();
		//document.getElementById("hiddentr1").style.display = "none";
		//document.getElementById("hiddentr2").style.display = "none";
		//document.getElementById("hiddentr3").style.display = "none";
		}catch(e){}
	}
	minNoObj.disabled = true;
	maxNoObj.disabled = true;
	curNoObj.disabled = true;
	yearEnabledObj.disabled = true;
	
	previewMark();
}

/**
 * 新建大流水
 */
function addBigStreamPage() {
    
    window.addBigStreamPageWin = getA8Top().$.dialog({
        title : v3x.getMessage("edocLang.edoc_mark_big_stream_label"),//
        transParams : {
            'parentWin' : window
        },
        url : edocMarkURL + "?method=addBigStreamPage",
        width : "420",
        height : "300"
    });
}

/**
 * 新建大流水回调函数
 */
function addBigStreamPageCallback(result){
    if (result == "true"){  
        window.location.href = window.location.href;
    }
}

function createBigStream() {

	if (myform.name.value == "") {
		alert(v3x.getMessage("edocLang.big_stream_alter_name_null"));
		myform.name.focus();
		return ;
	}
	if (myform.name.value.length > 30) {
		alert("大流水号名称不能超过30字!");
		myform.name.focus();
		return ;
	}
	
	
	//xiangfan 特殊字符校验
	if(!checkSpecialChar(myform.name)){return;}
	else if (!checkDocNo(myform)) {
		return ;
	}
	else {
		myform.action = edocMarkURL + "?method=createBigStream";
		myform.target = "empty";
		myform.submit();
	}	
}


function editBigStreamPage(id) {
	var aId = 0;
	if (id == "undefined") {
		var checkid = document.getElementsByName('id');
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			if (!checkid.checked) {
				alert(v3x.getMessage("edocLang.big_stream_alter_not_select"));
				return ;
			}	
			else {
				var aId = mainForm.id.value;
			}
		}
		else {
			var j = 0;
			for (var i = 0; i <len; i++) {
				if (checkid[i].checked == true) {
					aId = checkid[i].value;
					j++;
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("edocLang.big_stream_alter_not_select"));
				return ;
			}
			else if (j > 1){
				alert(v3x.getMessage("edocLang.big_stream_alter_select_one"));
				return ;
			}
		}
	}
	else {
		aId = id;
	}

	window.editBigStreamPageWin = getA8Top().$.dialog({
        title : '大流水号',//
        transParams : {
            'parentWin' : window
        },
        url : edocMarkURL + "?method=editBigStreamPage&id=" + aId,
        width : "420",
        height : "300"
    });
	
}

/**
 * 修改大流水回调函数
 */
function editBigStreamPageCallback(result){
    if (result == "true"){
        window.location.href = window.location.href;
    }
}

function updateBigStream() {
	if (myform.name.value == "") {
		alert(v3x.getMessage("edocLang.big_stream_alter_name_null"));
		myform.name.focus();
		return ;
	}
	else if (!checkDocNo(myform)) {
		return ;
	}
	else {
		myform.action = edocMarkURL + "?method=updateBigStream";
		myform.target = "empty";
		myform.submit();
	}
}


function deleteBigStream() {
	var ids = document.getElementsByName("id");
	var _deleteInfo = document.getElementById("deleteInfo");
	_deleteInfo.innerHTML = "";
	var temp = 0;
	for (var i = 0; i < ids.length; i++) {
		if(ids[i].checked) {
			/*if (ids[i].isReadonly == "true") {
				alert(v3x.getMessage("edocLang.big_stream_alter_used"));
				return ;
			}*/
			_deleteInfo.innerHTML += "<input type=hidden name=categoryId value=" + ids[i].value + ">";
			temp = temp + 1;
		}
	}
	if (temp == 0) {
		alert(v3x.getMessage("edocLang.big_stream_alter_select_deleted"));
		return ;
	}
	if(window.confirm(v3x.getMessage("edocLang.big_stream_alter_delete_confirm"))){
		mainForm.target = "empty";
		mainForm.action = edocMarkURL + "?method=deleteBigStream";
		mainForm.submit();
	}
}


function checkDocNo(myform) {
	if (myform.minNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_min_no_null"));
		myform.minNo.focus();
		return ;
	}
	else if (myform.maxNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_max_no_null"));
		myform.maxNo.focus();
		return ;
	}
	else if (myform.currentNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_current_no_null"));
		myform.currentNo.focus();
		return ;
	}
	else if (new Number(myform.minNo.value) > new Number(myform.maxNo.value)){
		alert(v3x.getMessage("edocLang.mark_alter_max_no_less_than_min_no"));
		myform.minNo.focus();
      	return ;
    }
	else if (new Number(myform.minNo.value) > new Number(myform.currentNo.value)){
		alert(v3x.getMessage("edocLang.mark_alter_current_no_less_than_min_no"));
		myform.minNo.focus();
      	return ;
    }
	else if (new Number(myform.currentNo.value) > new Number(myform.maxNo.value)){
		alert(v3x.getMessage("edocLang.mark_alter_max_no_less_than_current_no"));
		if(!myform.currentNo.disabled){
			myform.currentNo.focus();
		}
      	return ;
    }
	else {
		return true;
	}
}


function returnFromBigStreamListPage(a) {
	var flag = false;
	for (var i=0; i<detailForm.categoryId.options.length; i++){
		if (detailForm.categoryId.options[i].value == a){
			detailForm.categoryId.selectedIndex = i;
			flag = true;
			break;
		}
	}
	if (!flag) {
		detailForm.categoryId.selectedIndex = 0;
	}
	changeBigStream();
}


function configInnerMark() {
	parent.detailFrame.location.href = edocMarkURL + "?method=setInnerMarkDefPage";
}


function previewInnerMark(a) {
	var yearEnabled = document.getElementById(a+"yearEnabled").checked;
	
	var object1 = document.getElementById(a+"wordNo").value;
	var object2 = document.getElementById("yearNo").value;
	
	var sNo = document.getElementById(a+"minNo").value;
	var mNo = document.getElementById(a+"maxNo").value;
	var cNo = document.getElementById(a+"currentNo").value;
	
	var form_a = document.getElementById(a+"format_a").value;
	var form_b = document.getElementById(a+"format_b").value;
	var form_c = document.getElementById(a+"format_c").value;
	
	var object3 = cNo;
	
	var ofl = document.getElementById(a+"fixedLength");
	var zero = "";
	if(ofl.checked){
		if(mNo.length>cNo.length){
			var len = mNo.length-cNo.length;
			for(var i=0;i<len;i++){
				zero += "0";
			}
		}
		object3 = zero+cNo;
	}
	
	document.getElementById(a+"wordNo_a").innerHTML = '<font color="red">'+ object1 + '</font>';
	document.getElementById(a+"yearNo_a").innerHTML = '<font color="red">'+ object2 + '</font>';
	document.getElementById(a+"flowNo_a").innerHTML = '<font color="red">'+ object3 + '</font>';

	if (yearEnabled){
		document.getElementById(a+"format_a").style.display = "";
		document.getElementById(a+"yearNo_a").style.display = "";	
		document.getElementById(a+"wordNoPreview").innerHTML = '<font color="red">'+object1 + form_a + object2 + form_b + object3 + form_c + '</font>';
		document.getElementById(a+"markNo").value = "$WORD" + form_a + "$YEAR" + form_b + "$NO" + form_c;		
	}
	else {
		document.getElementById(a+"format_a").style.display = "none";
		document.getElementById(a+"yearNo_a").style.display = "none";
		document.getElementById(a+"wordNoPreview").innerHTML = '<font color="red">'+object1 + form_b + object3 + form_c + '</font>';
		document.getElementById(a+"markNo").value = "$WORD" + form_b + "$NO" + form_c;		
	}	
	document.getElementById(a+"length").value = mNo.length;
}

function changeInnerMarkType(hasPlugin) {
	var type = document.getElementsByName("type");
	setDefaultValues();
	if (type[1].checked) {
		document.all.unification_div.style.display = "";
		document.all.separate_div.style.display = "none";
		previewInnerMark("");
	}
	else {
		document.all.unification_div.style.display = "none";
		document.all.separate_div.style.display = "";
		if(hasPlugin == "true"){
			previewInnerMark("send_");
			previewInnerMark("receive_");
		}
		previewInnerMark("sign_report_");
	}	
}

function initInnerMark(hasPlugin) {	
	setInitDatas();
	changeInnerMarkType();
	if (_status <= 0) {
		setDefaultValues();
	}
	if (_status == 2) {
		if(hasPlugin == "true"){
			previewInnerMark("send_");
			previewInnerMark("receive_");
		}
		previewInnerMark("sign_report_");
	}
	else {
		previewInnerMark("");
	}
}

function setInitDatas() {
	var index_a;
	var index_b;
	var index_c;
	var obj_a = "";
	var obj_b = "";
	var obj_c = "";
	if (_status == "1") {
		if (_yearEnabled == "true") {
			document.getElementById("yearEnabled").checked = true;
		}
		else {
			document.getElementById("yearEnabled").checked = false;
		}	
		index_a = _expression.indexOf("$WORD");		
		index_c = _expression.indexOf("$NO");
		if (_yearEnabled == "true") {
			index_b = _expression.indexOf("$YEAR");
			obj_a = _expression.substring(index_a + 5, index_b);
			obj_b = _expression.substring(index_b + 5, index_c);
		}
		else {
			obj_b = _expression.substring(index_a + 5, index_c);
		}						
		obj_c = _expression.substring(index_c + 3);
		document.getElementById("format_a").value = unescapeHTMLToString(obj_a);
		document.getElementById("format_b").value = unescapeHTMLToString(obj_b);
		document.getElementById("format_c").value = unescapeHTMLToString(obj_c);


		if (_length == "0") {
			document.getElementById("fixedLength").checked = false;		
		}
		else {
			document.getElementById("fixedLength").checked = true;
		}
	}
	else if (_status == 2) {

		if (document.getElementById("send_yearEnabled") != undefined && _yearEnabled1 == "true") {
			document.getElementById("send_yearEnabled").checked = true;
		}
		else {
			if(document.getElementById("send_yearEnabled") != undefined)
			document.getElementById("send_yearEnabled").checked = false;
		}

		if (document.getElementById("receive_yearEnabled") != undefined && _yearEnabled2 == "true") {
			document.getElementById("receive_yearEnabled").checked = true;
		}
		else {
			if(document.getElementById("receive_yearEnabled") != undefined)
			document.getElementById("receive_yearEnabled").checked = false;
		}	

		if (document.getElementById("sign_report_yearEnabled") != undefined && _yearEnabled3 == "true") {
			document.getElementById("sign_report_yearEnabled").checked = true;
		}
		else {
			if(document.getElementById("sign_report_yearEnabled") != undefined)
			document.getElementById("sign_report_yearEnabled").checked = false;
		}

		index_a = _expression1.indexOf("$WORD");		
		index_c = _expression1.indexOf("$NO");
		if (_yearEnabled1 == "true") {
			index_b = _expression1.indexOf("$YEAR");
			obj_a = _expression1.substring(index_a + 5, index_b);
			obj_b = _expression1.substring(index_b + 5, index_c);
		}
		else {
			obj_b = _expression1.substring(index_a + 5, index_c);
		}						
		obj_c = _expression1.substring(index_c + 3);
		if(document.getElementById("send_format_a") != undefined){
		document.getElementById("send_format_a").value = unescapeHTMLToString(obj_a);}
		if(document.getElementById("send_format_b") != undefined){
		document.getElementById("send_format_b").value = unescapeHTMLToString(obj_b);}
		if(document.getElementById("send_format_c") != undefined){
		document.getElementById("send_format_c").value = unescapeHTMLToString(obj_c);}

		index_a = _expression2.indexOf("$WORD");		
		index_c = _expression2.indexOf("$NO");
		if (_yearEnabled2 == "true") {
			index_b = _expression2.indexOf("$YEAR");
			obj_a = _expression2.substring(index_a + 5, index_b);
			obj_b = _expression2.substring(index_b + 5, index_c);
		}
		else {
			obj_b = _expression2.substring(index_a + 5, index_c);
		}						
		obj_c = _expression2.substring(index_c + 3);
		if(document.getElementById("receive_format_a") != undefined){
		document.getElementById("receive_format_a").value = unescapeHTMLToString(obj_a);}
		if(document.getElementById("receive_format_b") != undefined){
		document.getElementById("receive_format_b").value = unescapeHTMLToString(obj_b);}
		if(document.getElementById("receive_format_c") != undefined){
		document.getElementById("receive_format_c").value = unescapeHTMLToString(obj_c);}

		index_a = _expression3.indexOf("$WORD");		
		index_c = _expression3.indexOf("$NO");
		if (_yearEnabled3 == "true") {
			index_b = _expression3.indexOf("$YEAR");
			obj_a = _expression3.substring(index_a + 5, index_b);
			obj_b = _expression3.substring(index_b + 5, index_c);
		}
		else {
			obj_b = _expression3.substring(index_a + 5, index_c);
		}						
		obj_c = _expression3.substring(index_c + 3);
		if(document.getElementById("sign_report_format_a") != undefined){
		document.getElementById("sign_report_format_a").value = unescapeHTMLToString(obj_a);}
		if(document.getElementById("sign_report_format_b") != undefined){
		document.getElementById("sign_report_format_b").value = unescapeHTMLToString(obj_b);}
		if(document.getElementById("sign_report_format_c") != undefined){
		document.getElementById("sign_report_format_c").value = unescapeHTMLToString(obj_c);}

		if (document.getElementById("send_fixedLength") != undefined && _length1 == "0") {
			document.getElementById("send_fixedLength").checked = false;		
		}
		else {
			if(document.getElementById("send_fixedLength") != undefined)
			document.getElementById("send_fixedLength").checked = true;
		}

		if (document.getElementById("receive_fixedLength") != undefined && _length2 == "0") {
			document.getElementById("receive_fixedLength").checked = false;		
		}
		else {
			if(document.getElementById("receive_fixedLength") != undefined)
			document.getElementById("receive_fixedLength").checked = true;
		}

		if (document.getElementById("sign_report_fixedLength") != undefined && _length3  == "0") {
			document.getElementById("sign_report_fixedLength").checked = false;		
		}
		else {
			if(document.getElementById("sign_report_fixedLength") != undefined)
			document.getElementById("sign_report_fixedLength").checked = true;
		}
	}
}

function setDefaultValues() {
	var type = document.getElementsByName("type");
	if (type[0].checked) {
		if (myform.minNo.value == "") {		
			myform.minNo.value = "1";
		}
		if (myform.maxNo.value == "") {
			myform.maxNo.value = "10000";
		}
		if (myform.currentNo.value == "") {
			myform.currentNo.value = "1";
		}		
	}
	else {
		if (myform.send_minNo != undefined && myform.send_minNo.value == "") {
			myform.send_minNo.value = "1";
		}
		if (myform.send_maxNo != undefined && myform.send_maxNo.value == "") {
			myform.send_maxNo.value = "10000";
		}
		if (myform.send_currentNo !=undefined && myform.send_currentNo.value == "") {
			myform.send_currentNo.value = "1";
		}
		if (myform.receive_minNo !=undefined && myform.receive_minNo.value == "") {
			myform.receive_minNo.value = "1";
		}
		if (myform.receive_maxNo != undefined && myform.receive_maxNo.value == "") {
			myform.receive_maxNo.value = "10000";
		}
		if (myform.receive_currentNo != undefined && myform.receive_currentNo.value == "") {
			myform.receive_currentNo.value = "1";
		}
		if (myform.sign_report_minNo != undefined && myform.sign_report_minNo.value == "") {
			myform.sign_report_minNo.value = "1";
		}
		if (myform.sign_report_maxNo != undefined && myform.sign_report_maxNo.value == "") {
			myform.sign_report_maxNo.value = "10000";
		}
		if (myform.sign_report_currentNo !=undefined && myform.sign_report_currentNo.value == "") {
			myform.sign_report_currentNo.value = "1";
		}
	}
}


function setFixedLength2(a) {
	var c_no = document.getElementById(a+"currentNo").value;
	var length = document.getElementById(a+"maxNo").value.length;
	var c_length = document.getElementById(a+"currentNo").value.length;
	var str = "";
	if(c_length<length){
	  var len = length - c_length;	
		for(var i=0;i<len;i++){
			str += "0";
		}
		str += c_no;
	}
	else{
		str = c_no;
	}
	
	var fixedLength = document.getElementById(a+"fixedLength");
	if(fixedLength.checked){
		document.getElementById(a+"flowNo_a").innerHTML = '<font color="red">'+ str + '</font>';
	}
	else{
		document.getElementById(a+"flowNo_a").innerHTML = '<font color="red">'+ c_no + '</font>';	    
	}	
	
	previewInnerMark(a);
}

function checkDocNo2(a) {
	var minNo = document.getElementById(a+"minNo");
	var maxNo = document.getElementById(a+"maxNo");
	var currentNo = document.getElementById(a+"currentNo");
	if (minNo != undefined && minNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_min_no_null"));
		minNo.focus();
		return ;
	}
	else if (maxNo != undefined && maxNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_max_no_null"));
		maxNo.focus();
		return ;
	}
	else if (currentNo != undefined && currentNo.value == "") {
		alert(v3x.getMessage("edocLang.mark_alter_current_no_null"));
		currentNo.focus();
		return ;
	}
	else if (minNo != undefined && ( new Number(minNo.value) > new Number(maxNo.value))){
		alert(v3x.getMessage("edocLang.mark_alter_max_no_less_than_min_no"));
		minNo.focus();
      	return ;
    }
	else if (minNo != undefined && (new Number(minNo.value) > new Number(currentNo.value))){
		alert(v3x.getMessage("edocLang.mark_alter_current_no_less_than_min_no"));
		minNo.focus();
      	return ;
    }
	else if (currentNo != undefined && (new Number(currentNo.value) > new Number(maxNo.value))){
		alert(v3x.getMessage("edocLang.mark_alter_max_no_less_than_current_no"));
		currentNo.focus();
      	return ;
    }
	else {
		return true;
	}
}


function saveInnerMarkDef() {
	var type = document.getElementsByName("type");
	if (type[1].checked) {
		var wordNo = document.getElementById("wordNo");
		if (wordNo.value == "") {
			alert(v3x.getMessage("edocLang.mark_alter_word_no_prefix_not_null"));
			return ;
		}
		else if(wordNo.value.indexOf('"')!=-1){
			alert(v3x.getMessage("edocLang.mark_alter_word_no_not_include_quotes"));
			return ;
		}
		else if (!checkDocNo2("")) {
			return ;
		}
	}
	else {
		var wordNo1 = document.getElementById("send_wordNo");
		var wordNo2 = document.getElementById("receive_wordNo");
		var wordNo3 = document.getElementById("sign_report_wordNo");
		if ((wordNo1 != undefined && wordNo1.value == "") || (wordNo2 != undefined && wordNo2.value == "" ) || (wordNo3 != undefined && wordNo3.value == "")) {
			alert(v3x.getMessage("edocLang.mark_alter_word_no_prefix_not_null"));
			return ;
		}
		else if(wordNo1.value.indexOf('"')!=-1||wordNo2.value.indexOf('"')!=-1||wordNo3.value.indexOf('"')!=-1){
			alert(v3x.getMessage("edocLang.mark_alter_word_no_not_include_quotes"));
			return;
		}
		else if (!checkDocNo2("send_") || !checkDocNo2("receive_") || !checkDocNo2("sign_report_")) {
			return ;
		}
	}
	myform.action = edocMarkURL + "?method=saveInnerMarkDef";
	myform.target = "_self";
	myform.submit();
}
function unescapeHTMLToString(str){
	if(!str){
		return "";
	}
	
	str = str.replace("&amp;","&");
	str = str.replace("&lt;","<");
	str = str.replace("&gt;",">");
	str = str.replace("<br>","");
	str = str.replace("&#039;","\'");
	str = str.replace("&#034;","\"");
	
	return str;
}

function escapeHTMLToString(str){
	if(!str){
		return "";
	}
	
	//str = str.replace("&","&amp;");
	str = str.replace("<","&lt;");
	str = str.replace(">","&gt;");
	str = str.replace("<br>","");
	return str;
}

function controllerRed(){
	if(detailForm.markType.value==2){
		document.getElementById("redDisplay").style.display="none";
	}else{
		document.getElementById("redDisplay").style.display="block";
	}
}


//检查特殊字符 |
function checkSpecialChar(obj){
    if(obj){
        //if(/\|/.test(obj.value)) {
    	//if(/[/\\|'"@#￥%]/.test(obj.value)) {
        if(/[\\|'"@#￥%]/.test(obj.value)) {//不校验  /  字符
           alert(_("edocLang.edoc_mark_isnotwellformated"));
           return false;
        }
    }
    return true;
}


//预留文号
function reserveMark(type) {
	var markObjs = document.getElementsByName('id');
	if (markObjs && markObjs.length>0) {
		var j = 0;
		var markObj = null;
		for(var i=0; i<markObjs.length; i++) {
			if(markObjs[i].checked) {
				markObj = markObjs[i];
				j++;
			}
		}
		if (j == 0) {
			alert(v3x.getMessage("edocLang.doc_mark_alter_select_deleted"));
			return ;
		} else if (j > 1) {
			if(type == 1) {
				alert(v3x.getMessage("edocLang.doc_mark_alter_select_one_to_reserve_up"));//只能选择一个公文文号设置预留文号！
			} else {
				alert(v3x.getMessage("edocLang.doc_mark_alter_select_one_to_reserve_down"));//只能选择一个公文文号设置线下占用文号
			}
			return;
		} else if(markObj.getAttribute("markType") != '0') {//非公文文号
			if(type == 1) {
				alert(v3x.getMessage("edocLang.doc_mark_alter_reserve_up_not_support_type"));//对不起，暂不支持当前类型的预留文号设置！
			} else {
				alert(v3x.getMessage("edocLang.doc_mark_alter_reserve_down_not_support_type"));//对不起，暂不支持当前类型的线下占用文号设置！
			}
			return;
		} else if(markObj.getAttribute("codeMode") == '1') {//非小流水
			if(type == 1) {
				alert(v3x.getMessage("edocLang.doc_mark_alter_reserve_up_not_support_to_long"));//此公文文号使用的大流水进行编号，暂不支持设置预留文号！
			} else {
				alert(v3x.getMessage("edocLang.doc_mark_alter_reserve_down_not_support_to_long"));//此公文文号使用的大流水进行编号，暂不支持设置线下占用文号！
			}
			return;
		} else if(markObj.getAttribute("domainId") != $("#orgAccountId").val()) {
			if(type == 1) {
				alert(v3x.getMessage("edocLang.doc_mark_outer_reserved_up_not_set"));//此公文文号使用的大流水进行编号，暂不支持设置预留文号！
			} else {
				alert(v3x.getMessage("edocLang.doc_mark_outer_reserved_down_not_set"));//此公文文号使用的大流水进行编号，暂不支持设置线下占用文号！
			}
			return;
		}
		
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocMarkDefinitionManager", "checkExistEdocMarkDefinition", false);
		requestCaller.addParameter(1, "String", markObj.value);
		var rs = requestCaller.serviceRequest();
		if(rs=='false') {
			alert(v3x.getMessage("edocLang.doc_mark_definition_alter_deleted"));//公文文号已被删除
			window.location.reload();
	    	return false;
	    }
		var dialogTitle = dialogTitleUp;
		if(type == 2) {
			dialogTitle = dialogTitleDown;
		}
		getA8Top().win123 = getA8Top().$.dialog({
			title: dialogTitle,
			targetWindow : getA8Top(),
			transParams: { 'parentWin':window },
	        url: jsContextPath + "/edocMark.do?method=openEdocMarkReserveDialog&markDefineId="+markObj.value+"&type="+type,
	        width: 450,
	        height: 350,
	        resizable: true
	    });
	}
}
