<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
.categorySet-body-edocform{
	border-left: solid 1px #a0a0a0;
	border-right: solid 1px #a0a0a0;
	border-bottom: solid 1px #a0a0a0;
	border-top: solid 1px #a0a0a0;
	padding: 10px;
	margin: 0px;
	background-color: #FFFFFF;
	float: left;
	clear: left;
	width: 100%;
	overflow: auto;
}
.h100b{height:100%;}
</style>


<script type="text/javascript">
  formOperation = "aa";
  var logoURL = "${logoURL}";
  var formOpinionSetStr = ${formConfigJSON};
</script>
<title></title>
    <%@ include file="../edocHeader.jsp" %>
    <script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
    <script type="text/javascript" charset="UTF-8" src='<c:url value="/apps_res/edoc/js/edocCategory.js${v3x:resSuffix()}" />'></script>
        <script type="text/javascript">
        
        /**
         * 设置Radio 或 Checkbox选中
         * @param inputId : input的ID字符串
         **/
        function _checkInput(inputId){
        	var optionTypeRedio = document.getElementById(inputId);
        	if(optionTypeRedio){
                optionTypeRedio.checked = true;
            }
        }
        
        function scrollList_fn(){
	            var _scrollList_Obj = $("#edoc_scrolling");
	            _scrollList_Obj.hide();
	            _scrollList_Obj.css("overflow","auto");
	            _scrollList_Obj.height(_scrollList_Obj.parent().height());
	            _scrollList_Obj.show();
	        }
        
    	function edocFormDisplay(){
    		
    		_initOpinionSet();//初始化页面意见配置的意见框
			
            //上传发文单 
			if('${operType}' == 'add'){
				newcategory();
			}
    		var xml = document.getElementById("xml");
			var xsl = document.getElementById("xsl");
			buttondnois();
			document.getElementById("content").value = xsl.value;
			
			if(xml.value!="" && xsl.value!=""){
			try{
			var tempRegExp = /<style([\s\S]*?)>([\s\S]*?)<\/style>/ig;
            var tempXSLValue = xsl.value.replace(tempRegExp, "");
            
          //设置修复字段宽度的传参
            window.fixFormParam = {"isPrint" : false, "reLoadSpans" : true};
    		initSeeyonForm(xml.value,tempXSLValue);
    		
    		/**xiangfan 添加修复GOV-3811 Start*/
			if(document.getElementById("my:send_department") != null){
				document.getElementById("my:send_department").value = "";
			}
			if(document.getElementById("my:send_department2") != null){
				document.getElementById("my:send_department2").value = "";
			}
			/**xiangfan 添加修复GOV-3811 End */
    			}catch(e){
					alert(_("edocLang.edoc_form_xml_error") +e);
					return false;
				}
    			substituteLogo(logoURL);
    			return false;
    		}
    		scrollList_fn();
    	}
   
   	/**
    *初始化页面选中设置
    */
    //此JSP引用了2个JQUERY导致初始化方法需要通过onload才能执行，避免每次都加载resize事件，增加此变量
    var setWindowResize = '0';
    function _initOpinionSet(){
    	/***设置文单配置项选中  start ***/
        if(window.formOpinionSetStr){
            //设置意见显示方式
            var optionTypeValue = formOpinionSetStr["opinionType"];
            _checkInput("optionType" + optionTypeValue);
            
            //系统落款
            if(formOpinionSetStr["showUnit"]){//单位名称
                _checkInput("radio3");
            }
            
            if(formOpinionSetStr["showDept"]){//部门名称
                _checkInput("radio4");
            }
            
            if(formOpinionSetStr["showName"]){//人员名称
                _checkInput("radio5");
            }
            
            var showNameType = formOpinionSetStr["showNameType"];
            _checkInput("nameShowTypeItem" + showNameType);//名称显示方式
            
            if(formOpinionSetStr["hideInscriber"]){//落款选项
                _checkInput("radio6");
            }
            
            if(formOpinionSetStr["inscriberNewLine"]){//落款换行显示
                _checkInput("inscribedNewLineSet");
            }
            
            //处理时间显示格式
            var nameAndDateObj = $("#nameAndDateNotInline");
            var showNameType = formOpinionSetStr["showDateType"];
            if(showNameType == "0" || showNameType == "1"){
                _checkInput("showDealDateCheckbox");//名称显示方式
                var editAble = "${param.flag == 'readonly'}";
                if(editAble && editAble == "false"){
                    nameAndDateObj.removeAttr("disabled");
                }
            }
            _checkInput("showDealDateItem" + showNameType);//名称显示方式
        }
    	
    	
        $("#showDealDateCheckbox").change(function(){
            var checkVal = $(this).attr("checked");
            if(!checkVal){
                //日期显示方式取消选中
                $("input:radio[name='dealTimeFormt']").attr("checked",false);
                //处理人姓名与处理时间换行取消选中，并置为不可用
            }else{
                $("#showDealDateItem0").attr("checked","checked");
            }
        });
        $("input:radio[name='dealTimeFormt']").change(function(){
            var val = $(this).attr("checked");
            if(val){
                $("#showDealDateCheckbox").attr("checked","checked");
            }
        });
    	
        $("#inscribedNewLineSet").change(function(){
            var checkVal = $(this).attr("checked");
            if(!checkVal){
                $("#nameAndDateNotInline").removeAttr("checked");
            }
        });
        
        $("#nameAndDateNotInline").change(function(){
            var checkVal = $(this).attr("checked");
            if(checkVal){
                $("#inscribedNewLineSet").attr("checked","checked");
            }
        });
    	
        /***设置文单配置项选中  end ***/
        if(setWindowResize == '0'){
            scrollList_fn();
            $(window).resize(scrollList_fn);
            setWindowResize == '1';
        }
    }
    	
    /**
     * 选择节点权限
     */
    var tempBoundName = null;
    var tempPermItem = null;
    var tempArray = [];
    function chooseFlowPerm(boundName, permItem) {
    
        var opt = null;
    
        var type = document.getElementById("type");
    
        // 根据boundName(shenpi,niwen,...)动态拼接成元素的Id
        opt = document.getElementById("choosedOperation_" + permItem);
    
        // 首先取出该处理意见所绑定的权限名称
        tempArray = new Array();
    
        if (opt != null && opt.options != null && opt.options.length != 0) {
            for (var x = 0; x < opt.options.length; x++) {
                var tempValue = "(" + opt.options[x].value + ")";
                tempArray[x] = tempValue;
            }
        }
    
        tempBoundName = boundName;
        tempPermItem = permItem;

        window.chooseFlowPermWin = getA8Top().$.dialog({
            title:'<fmt:message key="edoc.form.flowperm.bound.name" />',
            transParams:{'parentWin':window},
            url: "${edocForm}?method=operationChooseEntry&type=" + type.value
		            + "&boundName=" + encodeURI(boundName) + "&permItem="
		            + encodeURI(permItem),
            targetWindow:getA8Top(),
            width:"350",
            height:"435"
        });
    }
    
    /**
     * 绑定节点回调函数
     * @param receivedObj
     */
    function chooseFlowPermCallback(receivedObj) {
    
        // 根据boundName(shenpi,niwen,...)动态拼接成元素的Id
        var opt = document.getElementById("choosedOperation_" + tempPermItem);
    
        if (receivedObj != null && opt != null) {
    
            var oper_str = "";
            var ele = null;
            var value = "";
            var returnOptValue = "";
            var operation_str = document.getElementById("operation_str");
    
            ele = document.getElementById(tempPermItem);
    
            opt.length = 0;
    
            var option = null;
    
            for (var i = 0; i < receivedObj.length; i++) {
                option = document.createElement("OPTION");
                opt.options.add(option);
                option.value = receivedObj[i][0];
                option.text = receivedObj[i][1];
                value += receivedObj[i][1];
                value += ",";
                returnOptValue += receivedObj[i][0];
                returnOptValue += ",";
                oper_str += "(" + receivedObj[i][0] + ")";
            }
    
            if (ele != null) {
                ele.value = value.substring(0, value.length - 1);
                ;
            }
    
            returnOptValue = returnOptValue.substring(0, returnOptValue.length - 1);
    
            document.getElementById("returnOperation_" + tempPermItem).value = returnOptValue;
    
            // 把返回的结果与选择之前的结果相比，如果之前含有的权限没有了，即撤销了选择，存入一个新的newArray中
            var newArray = new Array();
    
            for (var i = 0; i < tempArray.length; i++) {
    
                var m = oper_str.search(tempArray[i]);
                if (m == -1) {
                    newArray[i] = tempArray[i];
                }
            }
    
            operation_str.value += oper_str;
    
            var final = operation_str.value;
    
            // 在节点权限已选择池中依次相比，如果发现有newArray(撤销的权限)，从选择池中删除，下次再次点击选择权限就不会判断撤销的权限
            for (var i = 0; i < newArray.length; i++) {
                final = final.replace(newArray[i], "");
            }
    
            // 已选择池赋值
            operation_str.value = final;
        }
    }	
    	
    	
    function newcategory(){
	    
		insertAttachment(null, null, "newcategory_Callback", "false");
	}
    
    /**
     * 上传文单回调
     */
    function newcategory_Callback(){
        var atts = fileUploadAttachments.values();
        if(atts == "")
        return false;
        saveAttachment();
        var form=document.getElementById("loadForm");
        //因为需要提交页面，所以要将附件信息传递到后续页面，直接将saveAttachment产生的串传递
        var attachmentStr = document.getElementById("attachmentStr");
        var attachmentInputs = document.getElementById("attachmentInputs");
        if(attachmentInputs && attachmentStr){
            attachmentStr.value = attachmentInputs.innerHTML;
        }
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
            
            var field0 = document.createElement('INPUT');
            field0.setAttribute('type','hidden');
            field0.setAttribute('name','fileUrl');
            field0.setAttribute('value',att.fileUrl);
            
            var field1 = document.createElement('INPUT');
            field1.setAttribute('type','hidden');
            field1.setAttribute('name','fileCreateDate');
            field1.setAttribute('value',att.createDate);
            
            var field2 = document.createElement('INPUT');
            field2.setAttribute('type','hidden');
            field2.setAttribute('name','fileMimeType');
            field2.setAttribute('value',att.mimeType);
            
            var field3 = document.createElement('INPUT');
            field3.setAttribute('type','hidden');
            field3.setAttribute('name','filename');
            field3.setAttribute('value',att.filename);
            
            form.appendChild(field0);
            form.appendChild(field1);
            form.appendChild(field2);
            form.appendChild(field3);
        //--
        //不清楚这个变量做什么用，暂时保留 yuhj 2010.4.29
        document.getElementById("file_name").value = att.filename;
        
        /*var file_n = att.filename;
        var suffix = file_n.substring(file_n.indexOf(".")+1,file_n.length);*/
        
        /*
        if(suffix!="xsn"){
            alert(_("edocLang.edoc_alertMustBeXsnFormat"));
            window.location.reload();
            return false;
        }*/
        
        
        //--
        }
        form.target="detailFrame";
        form.action = "${edocForm}?method=uploadForm";
        form.submit();
    }

	function fieldChoose(){
		var obj1 = document.getElementById("tag0-left");
		obj1.className = "tab-tag-left-sel";
		var obj2 = document.getElementById("tag0-middel");
		obj2.className = "tab-tag-middel-sel";
		var obj3 = document.getElementById("tag0-right");
		obj3.className = "tab-tag-right-sel";
		var obj4 = document.getElementById("tag1-left");
		obj4.className = "tab-tag-left";
		var obj5 = document.getElementById("tag1-middel");
		obj5.className = "tab-tag-middel";
		var obj6 = document.getElementById("tag1-right");
		obj6.className = "tab-tag-right";
		
		var obj_a = document.getElementById("fieldOne");
		obj_a.style.display = "";
		var obj_b = document.getElementById("fieldTwo");
		obj_b.style.display = "none";
		
		var tab = document.getElementById("mainTable");
		tab.className = "categorySet";
		tab.width = "100%";
	}
	function chooseReverse(){
		var obj1 = document.getElementById("tag0-left");
		obj1.className = "tab-tag-left";
		var obj2 = document.getElementById("tag0-middel");
		obj2.className = "tab-tag-middel";
		var obj3 = document.getElementById("tag0-right");
		obj3.className = "tab-tag-right";
		var obj4 = document.getElementById("tag1-left");
		obj4.className = "tab-tag-left-sel";
		var obj5 = document.getElementById("tag1-middel");
		obj5.className = "tab-tag-middel-sel";
		var obj6 = document.getElementById("tag1-right");
		obj6.className = "tab-tag-right-sel";
		
		var obj_a = document.getElementById("fieldOne");
		obj_a.style.display = "none";
		var obj_b = document.getElementById("fieldTwo");
		obj_b.style.display = "";
		
		var tab = document.getElementById("mainTable");
		tab.className = "categorySet";
		tab.width = "100%";
	}

function create_submit(listStr){

	var form = document.getElementById("loadForm");
	if(!checkForm(form))
	return;//验证form
	var name = document.getElementById("name");
	if(name.value==""){
		alert(_("edocLang.edoc_inputSubject"));
		return false;
	}
	
	var xml = document.getElementById("xml");
	var xsl = document.getElementById("xsl");
	if(xml ==null || xsl==null || xml.value=="" || xsl.value ==""){
		alert(_("edocLang.edoc_alertUploadOneEdocForm"));
		return false;
	}
	
		var type = document.getElementById("type");
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxCheckDuplicatedName",false);
		requestCaller.addParameter(1, "String", name.value);
		requestCaller.addParameter(2, "String", type.value);
	    requestCaller.addParameter(3, "String", "");
		var ds = requestCaller.serviceRequest();
		if(ds == "true"){
			alert(_("edocLang.edoc_form_duplicated_name"));
			return;
		}
	}catch(ex1){
	
	}
		//默认公文单步允许禁止。
		var isDefault=document.getElementsByName("isDefault");
		var status=document.getElementsByName("status");
		if(isDefault[0].checked&& status[1].checked){
			alert(_("edocLang.edoc_alertDefaultForm_Not_Forbidden"));
			return;
		}
		buttondis();
		form.target = "detailFrame";
		form.action = "${edocForm}?method=create&listStr="+encodeURI(listStr);
	
	/*
	if(listStr!="" && listStr!=null){
	var tempS = listStr.split(",");
	for(var i=0;i<tempS.length;i++){
		var value = document.getElementById(tempS[i]).value;
		
		if(value == ""){
			alert(_('edocLang.edoc_form_flowperm_bound_alert'));
			return false;
		}
	}	
	
	}*/
	
	//return false;
	
	//saveAttachment();		
	
	//处理人姓名默认选中不可操作，在提交前需要移除disable属性，才能把值传到后台
    var showNameRadio = document.getElementById("radio5");
    if(showNameRadio){
        showNameRadio.disabled = false;
    }

	form.submit();
}

function buttondis(){
 var saveFormTemp = document.all("createsubmit");
 if(saveFormTemp != null){
		saveFormTemp.disabled="true";
	}
}

function buttondnois(){
 var saveFormTemp = document.all("createsubmit");
 if(saveFormTemp != null){
		saveFormTemp.disabled=false;
	}
}

function setPeopleFields(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);
		document.getElementById("domain").value = getNamesString(elements);
		document.getElementById("grantedDomainId").value = getIdsString(elements,true);
	}
}

/* $(function() {
	$("#categorySetTd").height($("#leftTable").height());
	$("#formField").height($("#categorySetTd").height()-30);
}) */

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edocDisplay.css${v3x:resSuffix()}" />">
</head>

<c:set value="${v3x:currentUser().loginAccount}" var ="loginAccountId"/>
<c:set value="${v3x:parseElements(elements, 'domainId', 'entityType')}" var="authIds"/>
<v3x:selectPeople id="grantedDomainId" panels="Account" selectType="Account" jsFunction="setPeopleFields(elements)" originalElements="${authIds}" minSize="0"/>
<body onload="edocFormDisplay();" class="h100b">
<div class="newDiv h100b">
<form id="loadForm" name="loadForm" class="h100b" method="post" action="${edocForm}?method=create">
<input type="hidden" name="att_fileUrl" id="att_fileUrl" value="${att_fileUrl}">
<input type="hidden" name="att_createDate" id="att_createDate" value="${att_createDate}">
<input type="hidden" name="att_mimeType" id="att_mimeType" value="${att_mimeType}">
<input type="hidden" name="att_filename" id="att_filename" value="${att_filename}">
<input type="hidden" name="att_needClone" id="att_needClone" value="${att_needClone}">
<input type="hidden" name="att_description" id="att_description" value="${att_description}">
<input type="hidden" name="att_type" id="att_type" value="${att_type}">
<input type="hidden" name="att_size" id="att_size" value="${att_size}">
<input type="hidden" id="appName" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">
<!-- 以上hidden对象后续需要去掉，不用这些对象传递附件信息 -->
<input type="hidden" id="element_id_list" name="element_id_list" value="${element_id_list}">
<input type="hidden" id="file_name" name="file_name" value="">
<input type="hidden" id="content" name="content" value="" >
<input type="hidden" id="attachmentStr" name="attachmentStr" value="">

		<c:choose>
				<c:when test="${type == 0}">
						<c:set value="edoc.formstyle.dispatch" var="msgType" />
						<c:set value="fileupload.edocform.send" var="popTitle" />
				</c:when>
				<c:when test="${type == 1}">
						<c:set value="edoc.formstyle.receipt" var="msgType" />	
						<c:set value="fileupload.edocform.rec" var="popTitle" />
				</c:when>
				<c:when test="${type == 2}">
						<c:set value="edoc.formstyle.qianbao" var="msgType" />	
						<c:set value="fileupload.edocform.sign" var="popTitle" />
				</c:when>
		</c:choose>
		
<table border="0" id="mainTable" name="mainTable" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
<tr align="center">
	<td height="8" class="detail-top" colspan="2">
		<script type="text/javascript">
			getDetailPageBreak(); 
		</script>
	</td>
</tr> 

<tr>
	<td colspan="2">
		<div id="edoc_scrolling" style="overflow:auto;">
			<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">
			    <tr>
			    
					<td width="15%"  valign="top" id="leftTable">
						<div >
							<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
					 			<tr><td class="label" align="left"><fmt:message key="edoc.form.name" />&nbsp;:&nbsp;</td></tr>
					 			<tr>	
					 				<td class="new-column" nowrap="nowrap">
										<input name="name" type="text" id="name" deaultValue="${ctp:toHTML(name)}"
											maxSize="125"
											validate="notNull,maxLength"
											inputName="<fmt:message key="edoc.form.name" />"
										    value="<c:out value="${ctp:toHTML(name)}" escapeXml="true" default='${ctp:toHTML(name)}' />"
										    style="width:150px;" />
									</td>	
								</tr>
								<tr><td class="label" align="left"><fmt:message key="edoc.form.sort" />&nbsp;:&nbsp;</td></tr>
								<tr>	
									<td class="new-column" nowrap="nowrap">	
										<input type="hidden" id="type" name="type" value="${v3x:toHTML(type)}">
										<input type="hidden" id="sort" value="${msgType }" >
										<c:choose>
											<c:when test="${type == 0}">
												<input type="text" id="sort" name="sort" value="<fmt:message key='${msgType}' />" readonly disabled="disabled" style="width:150px;">
											</c:when>
											<c:when test="${type == 1}">
												<input type="text" id="sort" name="sort" value="<fmt:message key='${msgType}' />" readonly  disabled="disabled" style="width:150px;">						
											</c:when>
											<c:when test="${type == 2}">
												<input type="text" id="sort" name="sort" value="<fmt:message key='${msgType}' />" readonly  disabled="disabled" style="width:150px;">
											</c:when>
										</c:choose>
									</td>
								</tr>
							
								<div class="hidden"><v3x:fileUpload attachments="${attachments}"  canDeleteOriginalAtts="true" extensions="xsn"  encrypt="false" popupTitleKey="${popTitle}" />
									<script>
										var fileUploadQuantity = 1;
									</script>
								</div>
							
								<tr><td class="label" align="left"><fmt:message key="edoc.form.defaultform" />&nbsp;:&nbsp;</td></tr>
								<tr>
					 				<td class="new-column" nowrap="nowrap">
						 				<c:choose>
						 					<c:when test="${isDefault==1}">
						 					<label for="isDefault1">
							 					<input type="radio" name="isDefault" id="isDefault1" value="1"  checked/><fmt:message key="edoc.form.yes" />	
											</label>
											<label for="isDefault2">
						 						<input type="radio" name="isDefault" id="isDefault2" value="0" /> <fmt:message key="edoc.form.no" />	
											</label>				
						 					</c:when>
						 					<c:when test="${isDefault==0}">
						 					<label for="isDefault1">
						 						<input type="radio" name="isDefault" id="isDefault1" value="1" /> <fmt:message key="edoc.form.yes" />	
											</label>
											<label for="isDefault2">
						 						<input type="radio" name="isDefault" id="isDefault2" value="0"  checked/> <fmt:message key="edoc.form.no" />
											</label>
						 					</c:when>
						 					<c:otherwise>
						 					<label for="isDefault1">
						 						<input type="radio" name="isDefault" id="isDefault1" value="1" /> <fmt:message key="edoc.form.yes" />	
						 					</label>
						 					<label for="isDefault2">
						 						<input type="radio" name="isDefault" id="isDefault2" value="0" checked/> <fmt:message key="edoc.form.no" />
											</label>
						 					</c:otherwise>
						 				</c:choose>
									</td>	
								</tr>
					 			<tr><td class="label" align="left"><fmt:message key="edoc.form.currentstatus" />&nbsp;:&nbsp;</td></tr>
					 			<tr>		
									<td class="new-column" nowrap="nowrap">
						 				<c:choose>
							 				<c:when test="${status == 1}">
							 				<label for="status1">
							 					<input type="radio" id="status1" name="status" value="1" checked/> <fmt:message key="edoc.element.enabled" />	
											</label>
											<label for="status2">
							 					<input type="radio" id="status2" name="status" value="0" /> <fmt:message key="edoc.element.disabled" />
											</label>
											</c:when>
											<c:when test="${status == 0}">
											<label for="status1">
							 					<input type="radio" id="status1" name="status" value="1"/> <fmt:message key="edoc.element.enabled" />	
							 				</label>	
							 				<label for="status2">
								 				<input type="radio" id="status2" name="status" value="0" checked /> <fmt:message key="edoc.element.disabled" />
											</label>
											</c:when>
											<c:otherwise>
											<label for="status1">
											<input type="radio" id="status1" name="status" value="1" checked /> <fmt:message key="edoc.element.enabled" />	
											</label>
											<label for="status2">
							 				<input type="radio" id="status2" name="status" value="0"/> <fmt:message key="edoc.element.disabled" />
							 				</label>
											</c:otherwise>
										</c:choose>
									</td>	
								</tr>
								
								<%--目前只有发文支持自定义分类 --%>
								<c:set var="hasEdocCategory" value="${type==0 && v3x:getSystemProperty('edoc.hasEdocCategory') }"/>
								<tr <c:if test="${not hasEdocCategory }">style="display:none"</c:if>><td class="label" align="left"><fmt:message key='edoc.category.send'/>&nbsp;:&nbsp;</td></tr>
								<tr <c:if test="${not hasEdocCategory }">style="display:none"</c:if>> 
									<td class="new-column" nowrap="nowrap">
										<select name="edocCategory" id="edocCategory" style="width:150px;font-size:12px">
											<option value=""><fmt:message key='common.pleaseSelect.label'/></option>
											<c:forEach items="${categories }" var="c">
							 					<option value="${c.id }" <c:if test="${not hasEdocCategory }">selected="selected"</c:if>>${v3x:toHTML(c.name) }</option>
							 				</c:forEach>
							 			</select>
									</td>	
								</tr>
							
								<c:if test="${type==0 || type==1 || type==2}">
					            <tr><td class="label" align="left"><fmt:message key="edoc.form.required" />&nbsp;:&nbsp;</td></tr>
								<tr>
					                 <td>
					                     <div style="background-color:#FFFFFF; border: 1 solid #E3E9EF; border-top-color:#ABADB3; width:150px; height:150px; OVERFLOW-Y:scroll; OVERFLOW-X:hidden;" >
					                         <table>
					                             <c:forEach items="${formElements}" var="formElement">
					                                 <tr>    
					                                     <td>
					                                        <c:choose> 
					                                            <c:when test="${!formElement.access|| 'edoc.element.attachments' == formElement.elementName}">
					                                               	<input type='checkbox' name ="${formElement.elementId}" disabled="disabled">
					                                           	</c:when>
					                                           	<c:otherwise>
					                                           		<c:choose>
					                                           			<c:when test="${formElement.elementId==1}">
					                                                 			<input type='checkbox' <c:if test="${(param.flag == 'readonly') || (formElement.elementId==1)}"> disabled </c:if> name ="${formElement.elementId}" <c:if test="${(formElement.required) || (formElement.elementId==1)}">checked="checked"</c:if>>
					                                           			</c:when>
					                                           			<c:otherwise>
					                                                 			<input type='checkbox' <c:if test="${param.flag == 'readonly'}"> disabled </c:if> name ="${formElement.elementId}" <c:if test="${formElement.required}">checked="checked"</c:if>>
					                                           			</c:otherwise>
					                                           		</c:choose>
					                                           	</c:otherwise>
					                                        </c:choose> 
					                                        <label>
					                                            	<c:if test="${formElement.systemType}">
					                                                <fmt:message key="${formElement.elementName}"/>
					                                            	</c:if>
					                                            	<c:if test="${!formElement.systemType}">
					                                                ${v3x:getLimitLengthString(formElement.elementName,12,'...')}
					                                            	</c:if>
					                                        	</label>
					                                     </td>
					                                 </tr>
					                             </c:forEach>
					                         </table>
					                     </div>
					                </td>
					           	</tr>
								</c:if>
						<!-- lijl添加choose判断是否是政务版本 --> 
			<c:choose>
				<c:when test="${ctp:getSystemProperty('system.ProductId')==3||ctp:getSystemProperty('system.ProductId')==4}">
					<!-- 如果是政务版以及是多组织版才允许修改授权 -->
					<c:if test ="${ctp:getSystemProperty('system.ProductId')==4}">
								<tr>
									<td class="label" align="left"><fmt:message key="edoc.doctemplate.grant" />&nbsp;:&nbsp;</td>
								</tr>
								<tr> 
									<c:set value="${v3x:showOrgEntitiesOfIds(loginAccountId, 'Account',  pageContext)}" var="authStr"/>
									<c:set value="${v3x:parseElementsOfIds(loginAccountId, 'Account')}" var="authIds"/>
									<td class="new-column" width="75%" nowrap="nowrap">
										<textarea id="domain" name="depart" value="" <c:if test="${param.flag != 'readonly'}">class="cursor-hand"</c:if>  rows="4"
										inputName="<fmt:message key="edoc.doctemplate.grant" />" validate=""
										readonly = "true" style="width:150px;" onclick ="selectPeopleFun_grantedDomainId();">${authStr}</textarea>
									</td>
									<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
								</tr>
					</c:if>
					<c:if test ="${ctp:getSystemProperty('system.ProductId')==3}">
						<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
					</c:if>
				</c:when>
                <c:when test="${ctp:getSystemProperty('system.ProductId')==0  || ctp:getSystemProperty('system.ProductId')==1}">
                    <input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
                </c:when>
				<c:otherwise>
					<%--不是企业版本才显示授权菜单 --%>
					<c:if test ="${ctp:getSystemProperty('system.ProductId')!=0 &&ctp:getSystemProperty('system.ProductId')!=1 && ctp:getSystemProperty('system.ProductId')!=7&&ctp:getSystemProperty('system.ProductId')!=12}">
						<tr>
							<td class="label" align="left"><fmt:message key="edoc.doctemplate.grant" />&nbsp;:&nbsp;</td>
						</tr>
						<tr>
							<c:set value="${v3x:showOrgEntitiesOfIds(loginAccountId, 'Account',  pageContext)}" var="authStr"/>
							<c:set value="${v3x:parseElementsOfIds(loginAccountId, 'Account')}" var="authIds"/>
							<td class="new-column" width="75%" nowrap="nowrap">
								<textarea id="domain" name="depart" value="" <c:if test="${param.flag != 'readonly'}">class="cursor-hand"</c:if>  rows="4"
								inputName="<fmt:message key="edoc.doctemplate.grant" />" validate=""
								readonly = "true" style="width:100%"
								onclick ="selectPeopleFun_grantedDomainId();">${authStr}</textarea>
							</td>
							<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
						</tr>
					</c:if>
				</c:otherwise>
			</c:choose>
			
			
								<tr><td class="label" align="left"><fmt:message key="edoc.form.description" />&nbsp;:&nbsp;</td></tr>
					 			<tr>	
									<td class="new-column" width="75%" nowrap="nowrap">
										<textarea
										class="input-100per" id="description" name="description" rows="4"
										inputName="<fmt:message key="edoc.form.description" />"
										validate="maxLength" maxSize="80" style="width:150px;">${description}</textarea>
									</td>
								</tr>
					 		</table>
						</div>
					</td>
					<td width="85%" valign='top' id="rightTable">
		<table border="0" cellpadding="0" cellspacing="0" width="100%"align="center" class="categorySet-bg">
			<tr>
				<td class="categorySet-head tab-tag" height="25" style="overflow:hidden;zoom:1;">
			
					<div class="div-float">
						
						<div class="tab-separator"></div>
						<div id="tag0-left"   class="tab-tag-left-sel"></div>
						<div id="tag0-middel" class="tab-tag-middel-sel" style="max-width: 200px" onclick="fieldChoose();"><fmt:message key='edoc.form.formpreview' /></div>
						<div id="tag0-right"  class="tab-tag-right-sel"></div>
						
						<div class="tab-separator"></div>
					
						<div id="tag1-left" class="tab-tag-left"></div>
						<div id="tag1-middel" class="tab-tag-middel" onclick="chooseReverse();"><fmt:message key='edoc.form.flowperm.bound' /></div>
						<div id="tag1-right" class="tab-tag-right"></div>
						<div class="tab-separator"></div>
					</div>
				</td>
			</tr>
  			<tr>
				<td id="categorySetTd" class="categorySet-head" style="height:100%;" valign="top">
					<div class="categorySet-body" id="fieldOne" name="fieldOne"  style="overflow: visible;height:100%;padding:10px 0; margin-bottom:10px;border:1px solid #ccc;" >
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  							<tr>
    							<td width="90%" height="100%" align="left" valign="top"><A HREF="###" onClick="newcategory();" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');"><fmt:message key="common.lable.upload.prefix" /><fmt:message key="${msgType}" /></A>
						    	<p>
								<DIV id="attention"  style="display:none;">
									<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
											<tr>
												<td style="color: red">*
												<fmt:message key="common.label.attention.typeconfirm" />&nbsp;[&nbsp;<fmt:message key="${msgType}" />&nbsp;]
												</td>
											</tr>
									</table>
								</DIV>
								</p>
    							<fieldset id="formField" style="width:95%;" align="center"><legend><strong><fmt:message key="${msgType}" /><fmt:message key="common.lable.preview.prefix" /></strong></legend>

									 <div class="hidden">
										<textarea id="xml" cols="40" rows="10">${xml}</textarea>
									 </div>
									 <div class="hidden">
								   	<textarea id="xsl" cols="40" rows="10">${xsl}</textarea>
									 </div>

									<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
										<tr>	
											<td>
												<div id="html" name="html"></div>
												<div id="img" name="img" ></div>	 
												<div style="display:none">
												<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea><br/>
												</div>
											</td>
										</tr>
									</table>		
								</fieldset>
							</td>
   						</tr>	
					</table>
				</div>
				<div class="categorySet-body-edocform" id="fieldTwo" name="fieldTwo" style="padding:10px 0; margin-bottom:10px;display:none;" >
					<fieldset style="padding: 20px;"><legend> <b><fmt:message key="edoc.form.flowperm.process.sortType.set" /></b></legend> <br>
						<table>
							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;">
												<!-- lijl添加(意见保留设置 ) -->
												<fmt:message key="edoc.form.flowperm.setup" />:
											</td>
											<td>
											<div class="common_radio_box clearfix">
                                                <!-- lijl添加(全流程保留所有意见) -->
                                                <!-- OA-34152 应用检查：文单定义---意见元素设置，默认的处理意见保留设置应该是全程保留所有意见 -->
                                                <LABEL for="optionType2" class="hand display_block">
                                                    <input type="radio" id="optionType2" name="optionType" value="2" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                    <fmt:message key="edoc.form.flowperm.all" />
                                                </LABEL>
                                                
                                                <!-- lijl添加(全流程保留最后一次意见 )-->
                                                <LABEL for="optionType1" class="margin_t_5 hand display_block">
                                                    <input type="radio" id="optionType1" name="optionType" value="1" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                    <fmt:message key="edoc.form.flowperm.showLastOptionOnly" />
                                                </LABEL>
                                                
                                                <%-- 
                                                <!--  工作项暂时屏蔽：退回时办理人选择覆盖方式，其他情况保留最后意见-->
                                                <LABEL for="optionType3" class="margin_t_5 hand display_block">
                                                    <input type="radio" id="optionType3" name="optionType" value="3" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                    <fmt:message key="edoc.form.flowperm.client" />
                                                </LABEL> 
                                                --%>
                                                
                                                <!-- lijl添加(退回时办理人选择覆盖方式，其他情况保留所有意见) -->
                                                <LABEL for="optionType4" class="margin_t_5 hand display_block">
                                                    <input type="radio" id="optionType4" name="optionType" value="4" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                    <fmt:message key="edoc.form.flowperm.client1" />
                                                </LABEL>
                                            </div>
                                            </td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table>
										<tr>
											<td valign="top" style="vertical-align: top;">
											    <fmt:message key="edoc.form.flowperm.showOpinionSignDploy" />
											</td>
											<td>
											<fieldset style="border: 2px solid #aaa">
											 <legend class="margin_l_5"><b><fmt:message key="edoc.label.form.set.inscribedContent" /><%-- 落款内容 --%></b></legend>
											     <div class="margin_l_10">
											         <!-- 处理人姓名 -->
                                                     <LABEL class="display_block margin_t_5" for="radio5">
                                                         <input type="checkbox" id="radio5" disabled="disabled" name="showOrgnDept" value="2"/>
                                                         <fmt:message key="edoc.form.flowperm.showPerson" />
                                                     </LABEL>
                                                     <%-- 处理人姓名选项 --%>
                                                     <label class="margin_l_5 display_block">
                                                             <input type="radio" value="0" id="nameShowTypeItem0" name="nameShowTypeItem" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                             <fmt:message key="edoc.label.form.set.name.showtype.common" />
                                                     </label>
                                                     <label class="margin_l_5 display_block margin_t_5">
                                                             <input type="radio" value="1" id="nameShowTypeItem1" name="nameShowTypeItem" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                             <fmt:message key="edoc.label.form.set.name.showtype.sign" />
                                                     </label>
										             <LABEL for="radio4" class="margin_t_5 display_block">
                                                       <!-- 处理人所属部门 -->
                                                       <input type="checkbox" id="radio4" name="showOrgnDept" value="1" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                       <fmt:message key="edoc.form.flowperm.showDept" />
                                                    </LABEL>
                                                    <LABEL class="margin_t_5 display_block" for="radio3">
                                                         <!-- 处理人所在单位 -->
                                                         <input type="checkbox" id="radio3" name="showOrgnDept" value="0" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                         <fmt:message key="edoc.form.flowperm.showOrgan" />
                                                     </LABEL>
                                                     <!-- 处理时间 -->
													<LABEL class="margin_t_5 display_block" for="showDealDateCheckbox">
                                                         <input type="checkbox" id="showDealDateCheckbox" name="showDealDateCheckbox" value="0" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                         <fmt:message key="edoc.form.flowperm.dealDate" />
                                                     </LABEL>
                                                     <!-- 日期时间 -->
                                                     <label class="margin_l_5 display_block">
                                                              <input type="radio" value="0" id="showDealDateItem0" name="dealTimeFormt" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                              <fmt:message key="edoc.form.flowperm.dealDateTimeFormt" />
                                                     </label>
                                                     <!-- 日期 -->
                                                     <label class="margin_l_5 display_block margin_t_5">
                                                              <input type="radio" value="1" id="showDealDateItem1" name="dealTimeFormt" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                              <fmt:message key="edoc.form.flowperm.dealDateFormt" />
                                                     </label>
											     </div>
											</fieldset>
											</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td>
                                                <LABEL class="margin_t_5 display_block" for="inscribedNewLineSet">
	                                                <%-- 意见与落款换行显示  --%>
	                                                <input type="checkbox" id="inscribedNewLineSet" name="showOrgnDept" value="4" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
	                                                <fmt:message key="edoc.label.form.set.inscribedShowType" />
	                                            </LABEL>
	                                            <%-- 处理人姓名与处理时间换行显示  --%>
                                                <LABEL class="margin_t_5 display_block" for="nameAndDateNotInline">
                                                    <input type="checkbox" id="nameAndDateNotInline" name="nameAndDateNotInline" value="1" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
                                                    <fmt:message key="edoc.form.flowperm.nameAndDateNotInline" />
                                                </LABEL>
	                                            <LABEL class="margin_t_5 display_block" for="radio6">
	                                                <!-- 文单签批后不显示系统落款 -->
                                                    <input type="checkbox" id="radio6" name="showOrgnDept" value="3" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
	                                                <fmt:message key="edoc.form.flowperm.isNotShowSignInfo" />
	                                             </LABEL>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						</fieldset>

			<table>
				<tr>
					<td>	
						<div class="categorySet-body-edocform" >
							<table width="70%" border="1" cellspacing="0" cellpadding="5" align="center">
							<tr style="background-color:#D3D3D3"><th align="left"><fmt:message key="edoc.form.flowperm.process.label" /></th><th align="left"><fmt:message key="edoc.form.flowperm.name.label" /></th><th><fmt:message key="edoc.form.flowperm.operation.label" /></th><th align="left"><fmt:message key="edoc.form.flowperm.process.sortType" /></th></tr>
							<c:forEach items="${processList}" var="bean">
								<tr>
									<td width="30%">${bean.permName}</td>
									<td width="50%"><input readonly="readonly" type="text" style="width:100%;height:100%;" name="${bean.permItem}" id="${bean.permItem}" value="${bean.processName}"></td>
									<td width="20%" align="center"><input type="button" value="<fmt:message key='edoc.button.editoperate.label' />" <c:if test="${bean.permItem == 'otherOpinion' || bean.permItem == 'feedback'}"> disabled </c:if> onclick="chooseFlowPerm('${bean.processItemName}','${bean.permItem}');" />
									<div style="display:none">
									<select id="choosedOperation_${bean.permItem}" name="choosedOperation_${bean.permItem}"
										multiple="multiple"  size="4"  class="input-100per">
										<option value="${bean.permItem}">${bean.processName}</option>
									</select>
									<input id="returnOperation_${bean.permItem}" name="returnOperation_${bean.permItem}" value="${bean.permItemName}" type="hidden">
									</div>
									</td>
									<td>
										<select id="sortType_${bean.permItem}" name="sortType_${bean.permItem}" <c:if test="${bean.permItem == 'feedback'|| bean.permItem == 'report'}"> disabled="disabled"</c:if>>
										<c:choose>
											<c:when test="${bean.sortType == '0'}">
															<option value="0" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortType.dealtime.asc" /></option>
														</c:when>
											<c:otherwise>
															<option value="0"><fmt:message key="edoc.form.flowperm.process.sortType.dealtime.asc" /></option>
														</c:otherwise>
										</c:choose>
										<c:choose>
														<c:when test="${bean.sortType == '1'}">
															<option value="1" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortType.dealtime.desc" /></option>
														</c:when>
											<c:otherwise>
															<option value="1"><fmt:message key="edoc.form.flowperm.process.sortType.dealtime.desc" /></option>
														</c:otherwise>
										</c:choose>
										
										<c:choose>
														<c:when test="${bean.sortType == '4'}">
															<option value="4" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
														</c:when>
														<c:otherwise>
															<option value="4"><fmt:message key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
														</c:otherwise>
													</c:choose>
										
										<c:choose>
														<c:when test="${bean.sortType == '2'}">
															<option value="2" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortTypeDesc.orgLevel" /></option>
											</c:when>
														<c:otherwise>
															<option value="2"><fmt:message key="edoc.form.flowperm.process.sortTypeDesc.orgLevel" /></option>
														</c:otherwise>
										</c:choose>
										<c:choose>
														<c:when test="${bean.sortType == '3'}">
															<option value="3" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortType.deptSortId" /></option>
														</c:when>
														<c:otherwise>
															<option value="3"><fmt:message key="edoc.form.flowperm.process.sortType.deptSortId" /></option>
														</c:otherwise>
										</c:choose>
										<%--wangw 增加按人员排序号排序,默认显示最后一位 START --%>
											<c:choose>
												<c:when test="${bean.sortType == '5'}">
													<option value="5" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortType.memberSortId" /></option>
												</c:when>
												<c:otherwise>
													<option value="5"><fmt:message key="edoc.form.flowperm.process.sortType.memberSortId" /></option>
											    </c:otherwise>
											</c:choose>
										<%--wangw 增加按人员排序号排序 End --%>
										</select>
									</td>
								</tr>
							</c:forEach>
							</table>
							<table width="70%" border="0" cellspacing="0" cellpadding="5" align="center">
								<tr><td colspan="3"><font color="green">*<fmt:message key="edoc.form.otheropinion.notice" /><BR>
												<font color="green">*<fmt:message key="edoc.form.otheropinion.sortAsc" /></font></td></tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
			</div>
		</td>
	</tr>
   </table>
	</td>
	
				</tr>
			</table>
		</div>
	</td>
</tr>
	
<tr>
   	<td height="42" align="center" class="bg-advance-bottom" colspan="2">
		<div align="center">
			<input id="createsubmit" type="button" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" onclick="create_submit('${listStr}');"/>
			<input type="button"
				onclick="parent.document.location.reload();"
				value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
				class="button-default-2">
		</div>
	</td>
</tr>
</table>

<div style="display:none">
	<select id="operation" name="operation"multiple="multiple"  size="4"  class="input-100per">
		<%-- 
        <c:forEach var="flowPerm" items="${flowPermList}">
            <option value="${flowPerm.label}">
                <c:if test="${flowPerm.type == 0}">
                    ${flowPerm.name}
                </c:if>
                <c:if test="${flowPerm.type == 1}">
                    ${flowPerm.name}
                </c:if>                             
            </option>
        </c:forEach>
        --%>
        <%--国际化的问题 --%>
        <c:forEach var="flowPerm" items="${flowPermList}">
            <option value="${flowPerm.name}">
                <c:if test="${flowPerm.type == 0}">
                    ${flowPerm.label}
                </c:if>
                <c:if test="${flowPerm.type == 1}">
                    ${flowPerm.label}
                </c:if>                             
            </option>
        </c:forEach>
	</select>
	
	<select id="hidden_operation" name="hidden_operation" multiple="multiple"  size="4"  class="input-100per">
		<c:forEach var="flowPerm" items="${flowPermList}">
			<option value="${flowPerm.label}">
			<c:if test="${flowPerm.type == 0}">
				${flowPerm.name}
			</c:if>
			<c:if test="${flowPerm.type == 1}">
					${flowPerm.name}
				</c:if>								
			</option>
		</c:forEach>
	</select>
</div>
<input type="hidden" name="operation_str" id="operation_str" value="${operation_str}"> 
</form>
</div>
<script>
	//提交后保存公文单信息
	var attachmentInputs = document.getElementById("attachmentInputs");
	if(attachmentInputs){
		attachmentInputs.innerHTML = "${v3x:escapeJavascript(param.attachmentStr)}";
	}
</script>

</body>
</html> 