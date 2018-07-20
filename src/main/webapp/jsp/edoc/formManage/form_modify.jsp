<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String path = request.getContextPath();//获取项目名
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; //获得项目url
%>
<%@ include file="../edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocCategory.js${v3x:resSuffix()}" />"></script>
<script>
  formOperation = "aa";
  var logoURL = "${logoURL}";
  var formOpinionSetStr = ${formConfigJSON};
  var isDoubleForm = "${isDoubleForm}";
  var hasPdfOrAip = "${hasPdfOrAip}";
  var url1 = "<%=basePath%>PDFServlet.jsp";
  var url2 = "<%=basePath%>AipServlet.jsp";
</script>
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
<title></title>
        <script type="text/javascript">
		var changeFlag = false;
		var HWPostil1;
		var iWebPDF2015;
		function aip_init(fileId){
			HWPostil1.ShowDefMenu=0;//隐藏菜单
			HWPostil1.ShowToolBar=0;//隐藏工具栏
			HWPostil1.ShowScrollBarButton=1;//隐藏滚动条的工具栏
			HWPostil1.CurrPenColor=0;//设置笔迹颜色，0是黑色，255是红色
			HWPostil1.CurrPenWidth=6;//设置笔迹宽度。1-28，-1是弹出框用户选择
			HWPostil1.LoadFile(url2+"?fileId="+fileId);
			
			//设置所有节点只读
			var User="";
			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
				var NoteInfo="";
				while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点
					HWPostil1.SetValue(NoteInfo, ":PROP::LABEL:3");//设置节点为只读
				}
			}
		}
		function pdf_init(fileId){
			iWebPDF2015.Options.TabCommandBarVisible = false;
				openWebPDF(iWebPDF2015,fileId,url1);
				 iWebPDF2015.Options.TabBarVisible = false;//隐藏tab
				iWebPDF2015.Documents.ActiveDocument.Window.DisplayLayout = false;//隐藏排版格式
				iWebPDF2015.Documents.ActiveDocument.Window.DisplayNavigation = false;//隐藏分页
				//隐藏 工具栏
				var nCount = iWebPDF2015.CommandBars.Count;  //所有工具栏层对象个数
				for ( var i = 0; i<nCount; i++ )
				{
					iWebPDF2015.CommandBars(i).Visible = false;
					iWebPDF2015.CommandBars(i).Enabled = false;
				}
				//field只读
				
				var fielCount = iWebPDF2015.Documents.ActiveDocument.Fields.Count;
				for(var i = 0;i<fielCount;i++){
					iWebPDF2015.Documents.ActiveDocument.Fields(i).AllowInteraction = false;
				}  
		}
		
		//陈枭
		function changeWD(att){ //切换到全文签批
			if(!changeFlag){
				HWPostil1 = document.getElementById("HWPostil1");	
				iWebPDF2015 = document.getElementById("iWebPDF2015");
				var fileId = $("#cyf_att_fileid").val();
				if(HWPostil1&&HWPostil1.lVersion){
					aip_init(fileId);
				}
				if(iWebPDF2015&&iWebPDF2015.Version){
					pdf_init(fileId);
					iWebPDF2015.style.width="80%";
					iWebPDF2015.style.height=400;
				}
				$("#WD").hide();
				$("#QW").show();
			}
			changeFlag=true;
		}
		
		function changeQW(att){
			if(changeFlag){
				$("#WD").show();
				$("#QW").hide();
				if(HWPostil1&&HWPostil1.lVersion){
					HWPostil1.CloseDoc(0);
				}
				if(iWebPDF2015&&iWebPDF2015.Version){
					iWebPDF2015.style.width="0";
					iWebPDF2015.style.height=0;
				}
				
			}
			changeFlag=false;
		} 
		//
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
        
    	function edocFormDisplay(fileId,fileName,createDate){
    		
    		_initOpinionSet();//初始化页面意见配置的意见框
    		
    		//var str="<A HREF=\"/seeyon/fileUpload.do?method=download&fileId="+detail[0]+"&createDate="+detail[1].substring(0,10)+"&filename="+encodeURI(detail[2])+"&deleteFile=\"false\""+" target=\"_blank\" \><fmt:message key="edoc.form.downloadform" /></A>";
			var isSystemForm='${bean.isSystem}'; //系统预置公文单
			var formType = "${bean.type }";
			//lijl注销,OA-42477.开发---server安全
			//var str="<A HREF=\"/seeyon/fileUpload.do?method=download&isSystemForm="+isSystemForm+"&formType="+formType+"&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURI(fileName)+"\" target=\"temp_iframe\" \><fmt:message key="edoc.form.downloadform" /></A>";
			
			//原来FileUploadController中将下载预置文单，formType为1时所下载的文单写死了，这里加一个类型
			if(fileName == '收文单（转收文）.xsn'){
				formType = 10;
			}
			var str="<A HREF=\"/seeyon/fileDownload.do?method=download&v=${ctp:digest_1(fileId)}&isSystemForm="+isSystemForm+"&formType="+formType+"&fileId="+fileId+"&createDate="+createDate+"&filename="+encodeURI(fileName)+"\" target=\"temp_iframe\" \><fmt:message key="edoc.form.downloadform" /></A>";
			var obj = document.getElementById("download");
			if(obj!=null){
				obj.innerHTML = str; 
			}
    		var xml = document.getElementById("xml");
			var xsl = document.getElementById("xsl");
            buttondnois();
			document.getElementById("content").value = xsl.value;
			
			if(xml!=null && xml!="" && xsl!=null && xsl!=""){
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
					var eDiv = document.getElementById("divA");
					if(eDiv){
						eDiv.style.display = "";
					}
					return false;
				}
				substituteLogo(logoURL);
    			return false;
    		}
    		

    	}
    
    /**
     *初始化页面选中设置
     */
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
            var showNameType = formOpinionSetStr["showDateType"];
            _checkInput("radio" + showNameType);//名称显示方式
            
            //处理时间样式 dy 2015-08-19
            var showNameType = formOpinionSetStr["showDateModel"];
            if (showNameType){
          	_checkInput("dealTimeModel" + showNameType);}
           	else{
           	var showNameType = "1";
           	_checkInput("dealTimeModel" + showNameType);}//名称显示样式, 判断是否录入 否则默认为简写
            	
        }
        /***设置文单配置项选中  end ***/
    }
    	
    function newcategory(){
		insertAttachment(null, null, "newcategory_Callback", "false");
	}
    function newcategoryPDF(){
		var fileType = "${fileType}";
		insertAttachmentByType(null, null, "callbackInsertAttachment4pdf", "false",fileType.toString());
	}
	function insertAttachmentByType(){
		var url = downloadURL + "&quantity=" + fileUploadQuantity;
		if(arguments && arguments[0]){
			url += "&selectRepeatSkipOrCover=" + arguments[0];
			//从第二个参数开始，先简单的按照类似"&selectRepeatSkip=fileupload.page.add"格式传值,用于个性国际化配置
	//      for(i=1;i<arguments.length;i++){
	//          var arrayParams = arguments[i].split("|");
	//          url +=arrayParams[0]+arrayParams[1];
	//      }
			if(arguments[1]){
				url += arguments[1];
			}
		}
		if(arguments && arguments[2]){
			url +="&callMethod="+ arguments[2];
		}
		
		if(arguments && arguments[3]){
			url +="&takeOver="+ arguments[3];
		}
		if(arguments && arguments[4]){//如果有数据  赋值到extensions
			var hou = url.substring(url.indexOf("extensions"),url.length);
			var hou1  = hou.substring(hou.indexOf("&"),hou.length);
			var qian = url.substring(0,url.indexOf("extensions"));
			var zhi = "extensions="+arguments[4];
			url = qian + zhi +hou1;
		}
		
		getA8Top().addattachDialog =null;
		
		if(getA8Top().isCtpTop || getA8Top()._ctxPath){
			getA8Top().addattachDialog = getA8Top().$.dialog({
			title: v3x.getMessage("V3XLang.attachent_title"),
			transParams:{'parentWin':window},
			url     : url,
			width   : 400,
			height  : 300,
			resizable   : "yes"
			});
			
		}else{
			getA8Top().addattachDialog = getA8Top().v3x.openDialog({
			title: v3x.getMessage("V3XLang.attachent_title"),
			transParams:{'parentWin':window},
						url     : url,
			width   : 400,
			height  : 300,
			resizable   : "yes"
		});
		}
		resizeFckeditor();
	}
	function  callbackInsertAttachment4pdf(){
    	var atts = fileUploadAttachments.values();
		if(atts == "")
			return false;
		saveAttachment();
		var form=document.getElementById("pdfForm");
		for(var i = 0; i< atts.size(); i++){
			var att = atts.get(i);
			document.getElementById("pdfId").value = att.fileUrl;
			document.getElementById("pdfName").value = att.filename;
			document.getElementById("cyf_att_size").value = att.size;
			document.getElementById("cyf_att_fileid").value = att.fileUrl;
			document.getElementById("cyf_att_filename").value = att.filename;
		}
		$("#fullSign").html("| <a onclick='changeWD(this)'><fmt:message key='edoc.fileType'/><fmt:message key='common.lable.preview.prefix' /></a>");
    }
	function tReflesh(){
    	window.location.href = window.location.href + "&d=" + (new Date().getTime());
    }
    function newcategory_Callback(){
        var atts = fileUploadAttachments.values();
        if(atts == "")
            return false;

        //向后续页面传递附件字符串。
        saveAttachment();
        var attachmentStr = document.getElementById("attachmentStr");
        var attachmentInputs = document.getElementById("attachmentInputs");
        if(attachmentInputs && attachmentStr){
            attachmentStr.value = attachmentInputs.innerHTML;
        }
        
        var form=document.getElementById("modifyForm");
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
        document.getElementById("file_name").value = att.filename;
        
        var file_n = att.filename;
        var suffix = file_n.substring(file_n.indexOf(".")+1,file_n.length);
        
        /*
        if(suffix!="xsn"){
            alert(_("edocLang.edoc_alertMustBeXsnFormat"));
            window.location.reload();
            return false;
        }
        */
        //--
        }
        form.target="detailFrame";
        form.action = "${edocForm}?method=uploadForm&";
        form.method = "POST";
        form.submit();
    }

	function modify_submit(listStr, content){

	//如果有上级意见汇报 意见排序元素，则在提交前需要将它的排序从disabled变为可编辑，不然上级意见排序的数据会丢失
	var report = document.getElementById("sortType_report");
	if(report){
		report.disabled = false;
	}
		
	var form = document.getElementById("modifyForm");
	var type = document.getElementById("type");
	var id = document.getElementById("id");
	//if(form.isSystem && (form.isSystem.value == 'true' || form.isSystem.value == true) && content != 'empty'){
	//	alert(_("edocLang.edoc_form_system_change_forbidden"));
	//	return;
	//}
	
	/*
		check whether the EdocForm is exist or not.
	 */
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxCheckIsExistInUnit",false);
		requestCaller.addParameter(1, "String", id.value);
		var ds = requestCaller.serviceRequest();
		if(ds == "false"){
			alert(_("edocLang.edoc_form_not_exist"));
			parent.window.location.reload();
			return;
		}
	}catch(ex1){}
	
	if(!checkForm(form))
	return;//验证form
	var name = document.getElementById("name");
	if(name.value == ""){
		alert(_("edocLang.edoc_inputSubject"));
		return false;
	}
	
	/*
	if(listStr!=null && listStr != ""){
	var tempS = listStr.split(",");
	for(var i=0;i<tempS.length;i++){
		var value = document.getElementById(tempS[i]).value;
		
		if(value == ""){
			alert(_('edocLang.edoc_form_flowperm_bound_alert'));
			return false;
		}
	}
	}
	*/
	
	/*
		check whether the name is duplicated or not.
	 */
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxCheckDuplicatedName",false);
		requestCaller.addParameter(1, "String", name.value);
		requestCaller.addParameter(2, "String", type.value);
		requestCaller.addParameter(3, "String", id.value);
		var ds = requestCaller.serviceRequest();
		if(ds == "true"){
			alert(_("edocLang.edoc_form_duplicated_name"));
			return;
		}
	}catch(ex1){
	
	}
		try{
    		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocFormManager", "ajaxCheckFormIsIdealy", false);
    		requestCaller.addParameter(1, "String", id.value);
    		requestCaller.addParameter(2, "String", "param1");
    		requestCaller.addParameter(3, "String", "");    		    		
    		var ds = requestCaller.serviceRequest();
    		var stats = document.getElementsByName("status");
    		var status = "1";
    		for(var i=0;i<stats.length;i++){
    			if(stats[i].checked){
    				status = stats[i].value;
    			}
    		}
    		if(ds == "true" && status == "0"){
    			alert(_("edocLang.edoc_alertDefaultForm_NotForbidden"));
    			return;
    		}
    		//默认公文单步允许禁止。
    		var isDefault=document.getElementsByName("isDefault");
    		if(isDefault[0].checked&& status == "0"){
    			alert(_("edocLang.edoc_alertDefaultForm_Not_Forbidden"));
    			return;
    		}
    	}catch(e){
    	}
	
	form.target = "detailFrame";
	buttondis();
	form.action="${edocForm}?method=change&listStr="+encodeURI(listStr);
	form.method = "POST";
	var xml = document.getElementById("xml").value;
	var xsl = document.getElementById("xsl").value;
	var spanObjs=document.getElementsByTagName("span");
	var str = "";
	var key;
	for(i=0;i<spanObjs.length;i++)
	{		
		key=spanObjs[i].getAttribute("xd:binding");	
		if(key!=null)
		{
			str += key;
			str += "|";
		}
	}
	saveAttachment();
	
	var html = document.getElementById("html");

	if(html ==null || html.value=="" ){
		alert(_("edocLang.edoc_alertUploadOneEdocForm"));
		buttondnois();
		return false;
	}
	
	//处理人姓名默认选中不可操作，在提交前需要移除disable属性，才能把值传到后台
    var showNameRadio = document.getElementById("radio5");
    if(showNameRadio){
    	showNameRadio.disabled = false;
    }
	
	document.getElementById("mx").value = str.substring(0,str.length-1);
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
	
	//定义全局变量，用于回调函数调用
	var tempBoundName = "";
	var tempPermItem = "";
	var tempArray = [];
	function chooseFlowPerm(boundName,permItem){
	        
        var opt = null;
        var type = document.getElementById("type");
        
        //根据boundName(shenpi,niwen,...)动态拼接成元素的Id
        opt = document.getElementById("choosedOperation_"+permItem);

        //首先取出该处理意见所绑定的权限名称
        tempArray = new Array();
        
        if(opt.options.length!=0){
         for(var x=0;x<opt.options.length;x++){
             
             if(opt.options[x].getAttribute("itemList")){
             var temp_str = opt.options[x].getAttribute("itemList").split(",");
             if(temp_str.length>=1){
                 for(var i=0;i<temp_str.length;i++){
                	 tempArray[x] = temp_str[i];
                     x++;
                 }
             }
             }else{
                var tempValue = "("+opt.options[x].value+")";
                tempArray[x] = tempValue;                  
             }
             }
        }
        
        tempBoundName = boundName;
        tempPermItem = permItem;
        
        window.chooseFlowPermWin = getA8Top().$.dialog({
            title:'<fmt:message key="edoc.serial.no.input" />',
            transParams:{'parentWin':window},
            url: "${edocForm}?method=operationChoose&type="+type.value+"&boundName="+encodeURI(boundName)+"&permItem="+permItem,
            targetWindow:getA8Top(),
            width:"350",
            height:"435"
        });
    }

    /**
     *绑定流程节点回调函数
     */
    function chooseFlowPermCallback(receivedObj){
    	
    	//根据boundName(shenpi,niwen,...)动态拼接成元素的Id
        var opt = document.getElementById("choosedOperation_"+tempPermItem);
        if(receivedObj !=null && opt!=null){

            var ele = document.getElementById(tempBoundName);
            var operation_str = document.getElementById("operation_str");
            opt.length = 0;
            var option = null;
            var returnOptValue = "";
            var value = "";
            var oper_str = "";
            
            for(var i=0;i<receivedObj.length;i++){
                option=document.createElement("OPTION");
                opt.options.add(option);
                option.value=receivedObj[i][0];
                option.text=receivedObj[i][1];
                value += receivedObj[i][1];
                value += ",";
                returnOptValue += receivedObj[i][0];
                returnOptValue += ",";
                oper_str += "("+receivedObj[i][0]+")";
            }
            ele.value = value.substring(0, value.length-1);;
                
            returnOptValue =  returnOptValue.substring(0,returnOptValue.length-1);
               
            //OA-19073  liud单位管理员修改文单，修改处理意见绑定后，点击确定，报js  
            document.getElementById("returnOperation_"+tempBoundName).value = returnOptValue;
                 
            //把返回的结果与选择之前的结果相比，如果之前含有的权限没有了，即撤销了选择，存入一个新的newArray中
            var newArray = new Array();
            for(var i=0;i<tempArray.length;i++){
                var m = oper_str.search('('+tempArray[i]+')');
                if(m == -1){
                    newArray[i] = tempArray[i];
                }
            }
               
            operation_str.value += oper_str;
             
            var finalValue = operation_str.value;
                
            //在节点权限已选择池中依次相比，如果发现有newArray(撤销的权限)，从选择池中删除，下次再次点击选择权限就不会判断撤销的权限

            for(var i=0;i<newArray.length;i++){
                finalValue = finalValue.replace(new RegExp(newArray[i], 'g'), "");
            }
           
            //已选择池赋值
            operation_str.value = finalValue;
        }
    }
	
	function buttondis(){
		var saveFormTemp = document.all("modifysubmit");
		if(saveFormTemp != null){
			saveFormTemp.disabled="true";
		}
	}
	function buttondnois(){
	 var saveFormTemp = document.all("modifysubmit");
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
	
	/**
	 *计算高度
	 */
	function scrollList_fn(){
        var _scrollList_Obj = $("#scrollList");
        _scrollList_Obj.hide();
        _scrollList_Obj.css("overflow","auto");
        _scrollList_Obj.height(_scrollList_Obj.parent().height());
        _scrollList_Obj.show();
    }
	
	/**
	 *页面加载完成后执行
	 */
	function 	_initPage(){
	    
	    edocFormDisplay("${fileId}","${v3x:escapeJavascript(fileName)}","${createDate}");
	    
	    //页面调整代码一定要放在文单显示后面，否则IE11有问题
	    scrollList_fn();
        $(window).resize(scrollList_fn);
	}

</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edocDisplay.css${v3x:resSuffix()}" />">
</head>
<c:set value="${v3x:showOrgEntitiesOfIds(aclIds, 'Account',  pageContext)}" var="authStr"/>
<c:set value="${v3x:parseElementsOfIds(aclIds, 'Account')}" var="authIds"/>
<v3x:selectPeople id="grantedDomainId" panels="Account" selectType="Account" jsFunction="setPeopleFields(elements)" originalElements="${authIds}" minSize="0"/>
<body onload='_initPage()' class="h100b" >

<script type="text/javascript">showOriginalElement_grantedDomainId = true;</script>
<div class="newDiv h100b" style="overflow:auto;">
<form id="modifyForm" class="h100b" name="modifyForm" method="POST">

<input type="hidden" name="cyf_att_fileid" id="cyf_att_fileid" value="${cyf_att_fileid}">
<input type="hidden" name="cyf_att_filename" id="cyf_att_filename" value="">
<input type="hidden" name="cyf_att_size" id="cyf_att_size" value="">

<input type="hidden" name="operationStr" id="operationStr" value="${operation_str}"> 
<input type="hidden" name="method_type" id="method_type" value="${method_type}" />
<input type="hidden" name="att_fileUrl" id="att_fileUrl" value="${v3x:toHTML(att_fileUrl)}">
<input type="hidden" name="att_createDate" id="att_createDate" value="${v3x:toHTML(att_createDate)}">
<input type="hidden" name="att_mimeType" id="att_mimeType" value="${v3x:toHTML(att_mimeType)}">
<input type="hidden" name="att_filename" id="att_filename" value="${v3x:toHTML(att_filename)}">
<input type="hidden" name="att_needClone" id="att_needClone" value="${v3x:toHTML(att_needClone)}">
<input type="hidden" name="att_description" id="att_description" value="${v3x:toHTML(att_description)}">
<input type="hidden" name="att_type" id="att_type" value="${v3x:toHTML(att_type)}">
<input type="hidden" name="att_size" id="att_size" value="${v3x:toHTML(att_size)}">
<input type="hidden" name="id" id="id" value="${bean.id}">
<input type="hidden" name="isSystem" id="isSystem" value="${bean.isSystem}">
<input type="hidden" id="file_name" name="file_name" value="">
<input type="hidden" id="content" name="content" value="" >
<input type="hidden" id="element_id_list" name="element_id_list" value="<c:out value='${element_id_list}' escapeXml='true'/>" >
<input type="hidden" id="mx" name="mx">
<input type="hidden" id="appName" name="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" id ="orgAccountId" name="orgAccountId" value="${v3x:currentUser().loginAccount}">

<input type="hidden" id="original_xml" name="original_xml" value="${original_xml}" >
<input type="hidden" id="attachmentStr" name="attachmentStr" value="">
<input type="hidden" name="edocFormStatusId" id="edocFormStatusId" value="${edocFormStatusId}">
<input type="hidden" name="elementNames" id="elementNames" value="${elementNames }">
<c:choose>
	<c:when test="${bean.content ==''}">
		<c:set value="empty" var="content" />
	</c:when>
	<c:otherwise>
		<c:set value="existed" var="content" />
	</c:otherwise>
</c:choose>
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
		<div class="scrollList" id="scrollList"  style="overflow:auto;">
			<table cellpadding="0" cellspacing="0" width="100%" height="100%" border="0">
			    <tr>
				  	<td width="15%" valign="top" id="leftTable">
				 		<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
				 			<tr><td class="label" align="left"><fmt:message key="edoc.form.name" />&nbsp;:&nbsp;</td></tr>
				 			<tr>	
				 				<td class="new-column" nowrap="nowrap">
									<input name="name" type="text" id="name" deaultValue="${v3x:toHTML(bean.name)}" maxSize="125" 
									inputName="<fmt:message key="edoc.form.name" />"
	
									validate="notNull,maxLength" <c:if test="${param.flag == 'readonly' or bean.isSystem or isOuterAccountAcl}"> disabled </c:if> 
	
									value="${v3x:toHTML(bean.name)}" style="width:150px;" /> <%--向凡 修改，修复GOV-4371 --%>
									  <c:if test="${param.flag == 'readonly' or bean.isSystem or isOuterAccountAcl}">
									  	<input name="name" type="hidden" value="${v3x:toHTML(bean.name)}"/>
									  </c:if>
								</td>	
							</tr>
				 			<tr><td class="label" align="left"><fmt:message key="edoc.form.sort" />&nbsp;:&nbsp;</td></tr>
				 			<tr>	
				 				<td class="new-column" nowrap="nowrap">	
								<input type="hidden" id="type" name="type" value="${type}">
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
							<div class="hidden">
								<v3x:fileUpload     attachments="${attachments}"  canDeleteOriginalAtts="true"  extensions="xsn"   encrypt="false"  popupTitleKey="${popTitle}"/>
						  		<script>
									var fileUploadQuantity = 1;
								</script>
								</div>
				 			<tr><td class="label" align="left"><fmt:message key="edoc.form.defaultform" />&nbsp;:&nbsp;</td></tr>
				 			<tr>	
				 				<td class="new-column" nowrap="nowrap">
				 				<c:choose>
				 				<c:when test='${bean.isDefault==true}'>
				 				<label for="isDefault1">
				 				<input type="radio" name="isDefault" id="isDefault1" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
				 				</label>
				 				<label for="isDefault2">
				 				<input type="radio" name="isDefault" id="isDefault2" value="0" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>  /> <fmt:message key="edoc.form.no" />
				 				</label>
				 				</c:when>
				  				<c:when test='${bean.isDefault==false}'>
				  				<label for="isDefault1">
				 				<input type="radio" name="isDefault" id="isDefault1" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
				 				</label>
				 				<label for="isDefault2">
				 				<input type="radio" name="isDefault" id="isDefault2" value="0" checked <c:if test="${param.flag == 'readonly' }"> disabled </c:if> /> <fmt:message key="edoc.form.no" />
				 				</label>
				 				</c:when>
				   				<c:otherwise>
				   				<label for="isDefault1">
				 				<input type="radio" name="isDefault" id="isDefault1" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
				 				</label>
				 				<label for="isDefault2">
				 				<input type="radio" name="isDefault" id="isDefault2" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />
				 				</label>
				 				</c:otherwise>
				 				</c:choose>
								</td>	
							</tr>
				 			<tr><td class="label" align="left"><fmt:message key="edoc.form.currentstatus" />&nbsp;:&nbsp;</td></tr>
				 			<tr>		
								<td class="new-column" nowrap="nowrap">
				 				<c:choose>
				 				<c:when test="${bean.status == 0}">
				 				<label for="status1">
				 				<input type="radio" id="status1" name="status" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
				 				</label>
				 				<label for="status2">
				 				<input type="radio" id="status2" name="status" value="0" checked <c:if test="${param.flag == 'readonly' }"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
				 				</label>
								</c:when>
								<c:when test="${(bean.status == 1)||(status==1)}">
								<label for="status1">
				 					<input type="radio" id="status1" name="status" value="1" checked <c:if test="${param.flag == 'readonly' }"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
				 				</label>
				 				<label for="status2">
				 					<input type="radio" id="status2" name="status" value="0" <c:if test="${param.flag == 'readonly' }"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
				 				</label>
								</c:when>
								<c:otherwise>
								<label for="status1">
								<input type="radio" id="status1" name="status" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
								</label>
								<label for="status2">
				 				<input type="radio" id="status2" name="status" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
				 				</label>
								</c:otherwise>
								</c:choose>
								</td>	
							</tr>
							<!-- 陈枭   9-7     如果存在pdf文件  显示-->
							<c:if test="${hasPdfOrAip=='true'}">
							<tr><td class="label" align="left"><fmt:message key="edoc.form.doubleFormState"/>&nbsp;:&nbsp;</td></tr>
				 			<tr>	
								<c:choose>
								<c:when test="${isDoubleForm=='true'}">
								<td class="new-column" nowrap="nowrap">
								<label for="PDFstatus1">
				 					<input type="radio" id="PDFstatus1" name="PDFstatus" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if>  /> <fmt:message key="edoc.element.enabled" />	
				 				</label>
				 				<label for="PDFstatus2">
				 					<input type="radio" id="PDFstatus2" name="PDFstatus" value="0"  <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />	
				 				</label>
								</td>	
								</c:when>
								<c:otherwise>
								<td class="new-column" nowrap="nowrap">
								<label for="PDFstatus1">
				 					<input type="radio" id="PDFstatus1" name="PDFstatus" value="1"  <c:if test="${param.flag == 'readonly'}"> disabled </c:if>  /> <fmt:message key="edoc.element.enabled" />	
				 				</label>
				 				<label for="PDFstatus2">
				 					<input type="radio" id="PDFstatus2" name="PDFstatus" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />	
				 				</label>
								</td>	
								</c:otherwise>
								</c:choose>
							</tr>
							</c:if>
							<%--目前只有发文支持自定义分类 --%>
							<c:if test="${bean.type==0 && v3x:getSystemProperty('edoc.hasEdocCategory')}">
							<tr><td class="label" align="left"><fmt:message key='edoc.category.send'/>&nbsp;:&nbsp;</td></tr>
				 			<tr> 
				 				<td class="new-column" nowrap="nowrap">
				 				<select name="edocCategory" id="edocCategory" style="width:150px;font-size:12px" ${(param.flag=="" || param.flag==null) && !isOuterAccountAcl ?"":"disabled"}>
				 					<option value="" ${bean.subType==null?"selected":""}><fmt:message key='common.pleaseSelect.label'/></option>
									<c:forEach items="${categories }" var="c">
				 						<option value="${c.id }" ${bean.subType==c.id?"selected":""}>${v3x:toHTML(c.name) }</option>
				 					</c:forEach>
				 				</select>
								</td>	
							</tr>
							</c:if>
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
					                                            <c:when test="${!formElement.access || 'edoc.element.attachments' == formElement.elementName}">
					                                               	<input type='checkbox' name ="${formElement.elementId}" disabled="disabled">
					                                           	</c:when>
					                                           	<c:otherwise>
					                                           		<c:choose>
					                                           			<c:when test="${formElement.elementId==1}">
					                                                 			<input type='checkbox' <c:if test="${(param.flag == 'readonly') || (formElement.elementId==1)}"> disabled </c:if> name ="${formElement.elementId}" <c:if test="${(formElement.required) || (formElement.elementId==1)}">checked="checked"</c:if>>
					                                           			</c:when>
					                                           			<c:otherwise>
					                                                 			<input type='checkbox' <c:if test="${param.flag == 'readonly' or isOuterAccountAcl}"> disabled </c:if> name ="${formElement.elementId}" <c:if test="${formElement.required}">checked="checked"</c:if>>
					                                           			        <%--OA-25288 gw4单位将一条公文单授权给gwg单位，gw4自己单位将公文单设置了一些必填项，gwg到文单定义查看时，这些必填项也自动带过来了，但是还能自己修改 --%>
                                                                                <c:if test="${param.flag == 'readonly' or isOuterAccountAcl}">
                                                                                <input name="${formElement.elementId}" type="hidden" <c:if test="${formElement.required}"> value="on" </c:if>/>
                                                                              </c:if> 
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
	
									<!-- 如果是政务版以及是多组织版才允许修改授权 -->
                           <c:choose>
							<c:when test="${ctp:getSystemProperty('system.ProductId')==3||ctp:getSystemProperty('system.ProductId')==4}">
								<!-- 如果是政务版以及是多组织版才允许修改授权 -->
								<c:if test ="${ctp:getSystemProperty('system.ProductId')==4}">
									<tr>
										<td class="label" align="left"><fmt:message key="edoc.doctemplate.grant" />&nbsp;:&nbsp;</td>
									</tr>
									<tr> 
										<td class="new-column" width="75%" nowrap="nowrap">
											<textarea id="domain" name="depart" value="" <c:if test="${param.flag != 'readonly' and  !bean.isSystem and !isOuterAccountAcl}">class="cursor-hand" onclick ="selectPeopleFun_grantedDomainId();"</c:if>  rows="4"
											inputName="<fmt:message key="edoc.doctemplate.grant" />" validate=""
											readonly = "true" style="width:150px" >${authStr}</textarea>
										</td>
										<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${grantedDepartId==null?authIds:grantedDepartId}" />
									</tr>
								</c:if>
								<c:if test ="${ctp:getSystemProperty('system.ProductId')==3}">
									<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
								</c:if>
							</c:when>
                            <c:when test="${ctp:getSystemProperty('system.ProductId')==0 || ctp:getSystemProperty('system.ProductId')==1}">
                                <input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${authIds}" />
                            </c:when>
							<c:otherwise>
								<c:if test ="${ctp:getSystemProperty('system.ProductId')!=0 &&ctp:getSystemProperty('system.ProductId')!=1 && ctp:getSystemProperty('system.ProductId')!=7}">
									<tr>
										<td class="label" align="left"><fmt:message key="edoc.doctemplate.grant" />&nbsp;:&nbsp;</td>
									</tr>
									<tr>
										<td class="new-column" width="75%" nowrap="nowrap">
											<textarea id="domain" name="depart" value="" <c:if test="${param.flag != 'readonly' and  !bean.isSystem and !isOuterAccountAcl}">class="cursor-hand" onclick ="selectPeopleFun_grantedDomainId();"</c:if>  rows="4"
											inputName="<fmt:message key="edoc.doctemplate.grant" />" validate=""
											readonly = "true" style="width:100%"
											>${authStr}</textarea>
										</td>
										<input type="hidden" id="grantedDomainId" name="grantedDomainId" value="${grantedDepartId==null?authIds:grantedDepartId}" />
									</tr>
								</c:if>
							</c:otherwise>
						</c:choose>
	
							<tr><td class="label" align="left"><fmt:message key="edoc.form.description" />&nbsp;:&nbsp;</td></tr>
				 			<tr>	
	
									<td class="new-column" width="100%" nowrap="nowrap"><div width="100%"><textarea <c:if test="${param.flag == 'readonly' or bean.isSystem or isOuterAccountAcl}"> readonly = "true"</c:if>
									id="description" name="description" rows="4" maxSize="80" validate="maxLength"
									inputName="<fmt:message key="edoc.form.description" />"
									cols="37" value="<c:out value="${v3x:toHTML(bean.description)}" escapeXml="true" default='${v3x:toHTML(bean.description)}' />" style="width:150px;">${v3x:toHTML(bean.description)}</textarea></div></td>
							</tr>
				 		</table>
				  	</td>
			  		<td width="85%" valign="top" id="rightTable">
						<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="categorySet-bg">
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
								<td id="categorySetTd" class="categorySet-head" style="height:300px;" >
									<div class="categorySet-body" id="fieldOne" name="fieldOne" style="overflow: visible;height:100%;width:100%;padding:0;border:1px solid #ccc;" >
						    			<div style="padding:5px;">
						    			<span id="download" name="download"></span><span style="padding:5px;">|</span><span name="divA" id="divA" style="display:none;">
										<A href="javascript:;" id="upload" name="upload" onclick="newcategory();" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');"><fmt:message key="common.lable.upload.prefix" /><fmt:message key="${msgType}" /></A>
										</span>
										<c:if test="${param.flag != 'readonly'}">
										<span style="padding: 5px;">|</span>
																<span name="divA2" id="divA2">
																	<A href="javascript:;" id="upload" name="upload" onClick="newcategoryPDF();">
																	<!--上传全文签批单 -->
																		<fmt:message key="common.lable.upload.prefix" /><fmt:message key="edoc.fileType"/>
																	</A>
																</span>
										</c:if>
										</div>
										
										<DIV id="attention" style="padding-left:5px;BORDER:#CCCCCC 1px solid;background-color:#97E4FE;display:none;POSITION:absolute;LINE-HEIGHT:20px;filter:alpha(opacity=70);">
											<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" align="left">
													<tr>
														<td>*
														<fmt:message key="common.label.attention.typeconfirm" />&nbsp;[&nbsp;<fmt:message key="${msgType}" />&nbsp;]
														</td>
													</tr>
											</table>
										</DIV>
								    	<fieldset id="formField" style="width:100%;" align="left">
									    	<div id="content">
												
									    		<legend><a href="###" onclick="changeQW(this)"><fmt:message key="${msgType}" /><fmt:message key="common.lable.preview.prefix" />
													</a>
													<span id="fullSign">
													<c:if test="${hasPdfOrAip=='true'}"><!-- 全文签批单预览 -->
														
														| <a href="###" onclick="changeWD(this)"><fmt:message key="edoc.fileType"/><fmt:message key="common.lable.preview.prefix" /></a>
														
													</c:if>
													</span>
												</legend>	
												
												 <div class="hidden">
													<textarea id="xml" cols="40" rows="10">${xml}</textarea>
												 </div>
												 <div class="hidden">
												   	<textarea id="xsl" cols="40" rows="10">${xsl}</textarea>
												 </div>
												
												<div style="margin:10px">
													<c:if test="${fileType=='pdf'}">
														<object classid="clsid:7017318C-BC50-4DAF-9E4A-10AC8364C315" codebase="iWebPDF2015.cab#version=1,0,3,1080" id=iWebPDF2015 height=1  width=1></object>
													</c:if>
												 </div>
												<div id="QW" style="display:none;margin:10px"><!-- 全文签批单-->
													
													<c:if test="${fileType=='aip'}">
													<object id=HWPostil1 height='400' width='90%' style='LEFT: 0px; TOP: 0px'  classid='clsid:FF1FE7A0-0578-4FEE-A34E-FB21B277D561'></object>
													</c:if>
													
												</div>
												<div id ="WD"><!-- 文单-->
												<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
												<tr ><td >
													<div id="html" name="html"></div>
													<div id="img" name="img"></div>	 
													<div style="display:none">
														<textarea  style="display:hidden"  name="submitstr" id="submitstr" cols="80" rows="20"></textarea><br/>
													</div>
												</td>
												</tr>
												</table>
												</div>
											</div>		
										</fieldset>
									</div>	
						<div id="fieldTwo" name="fieldTwo" style="display:none;" >
							<table>
								<tr>
									<td>
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
				                                                         <input type="checkbox" id="radio5" disabled name="showOrgnDept" value="2" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
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
				                            <tr>
				                                <td>
				                                    <table>
				                                        <tr>
				                                            <td valign="top" style="vertical-align: top;">
				                                                <fmt:message key="edoc.form.flowperm.showDateTimeFormat" />
				                                            </td>
				                                            <td>
				                                             <div class="common_radio_box clearfix">
				                                            
				                                                <!-- 日期时间 -->
				                                                <label class="hand display_block" for="radio0">
				                                                    <input type="radio" id="radio0" name="dealTimeFormt" value="0" onclick="getRadioValue()" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                    <fmt:message key="edoc.form.flowperm.dealDateTimeFormt" />
				                                                </label>
				                                                
				                                                <!-- 日期 -->
				                                                <label class="margin_t_5 hand display_block" for="radio1">
				                                                    <input type="radio" id="radio1" name="dealTimeFormt" value="1" onclick="getRadioValue()" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                    <fmt:message key="edoc.form.flowperm.dealDateFormt" />
				                                                </label>
				                                                
				                                                <!-- 无 -->
				                                                <LABEL class="margin_t_5 hand display_block" for="radio2">
				                                                    <input type="radio" id="radio2" name="dealTimeFormt" value="2" onclick="getRadioValue()" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                    <fmt:message key="edoc.form.flowperm.dealNullFormt" />
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
				                                                <fmt:message key="edoc.form.flowperm.showDateTimeModel" />
				                                                
				                                                <!-- dy添加(处理时间显示样式 ) -->
				                                            </td>
				                        											<td>
				                        											<div class="common_radio_box clearfix">
				                        											   
				                        											   <!-- 全称 -->
				                        											    <label class="hand display_block" for="dealTimeModel0">
				                                                    <input type="radio" id="dealTimeModel0" name="dealTimeModel"  value="0" onclick="getRadioValue()" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                    <fmt:message key="edoc.form.flowperm.dealFullModel" />
				                                                	</label>		
				                                                	
 
				                        											   <!-- 简称 -->
				                        											 	  <label class="margin_t_5 hand display_block" for="dealTimeModel1">
				                                                 	   <input type="radio" id="dealTimeModel1" name="dealTimeModel" value="1" onclick="getRadioValue()" <c:if test="${param.flag == 'readonly'}"> disabled="disabled"</c:if>/>
				                                                 	   <fmt:message key="edoc.form.flowperm.dealEasyModel" />
				                                                 	   
				                                            	   </label>
				                                            	  
				                                            	    <!-- dy添加(处理时间举例 ) -->
				                                            	  <label id="TimeExample"></label>


<shijian>  
<SCRIPT LANGUAGE="JavaScript">  
function getRadioValue(){
	Date.prototype.format = function (format){  
 if (format == null) format = "yyyy/MM/dd HH:mm:ss.SSS";  
 var year = this.getFullYear();  
 var month = this.getMonth();  
 var sMonth = ["January","February","March","April","May","June","July","August","September","October","November","December"][month];  
 var date = this.getDate();  
 var day = this.getDay();  
 var hr = this.getHours();  
 var min = this.getMinutes();  
 var sec = this.getSeconds();  
 var daysInYear = Math.ceil((this-new Date(year,0,0))/86400000);  
 var weekInYear = Math.ceil((daysInYear+new Date(year,0,1).getDay())/7);  
 var weekInMonth = Math.ceil((date+new Date(year,month,1).getDay())/7);  
 return format.replace("yyyy",year).replace("yy",year.toString().substr(2)).replace("dd",(date<10?"0":"")+date).replace("HH",(hr<10?"0":"")+hr).replace("KK",(hr%12<10?"0":"")+hr%12).replace("kk",(hr>0&&hr<10?"0":"")+(((hr+23)%24)+1)).replace("hh",(hr>0&&hr<10||hr>12&&hr<22?"0":"")+(((hr+11)%12)+1)).replace("mm",(min<10?"0":"")+min).replace("ss",(sec<10?"0":"")+sec).replace("SSS",this%1000).replace("a",(hr<12?"AM":"PM")).replace("W",weekInMonth).replace("F",Math.ceil(date/7)).replace(/E/g,["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][day]).replace("D",daysInYear).replace("w",weekInYear).replace(/MMMM+/,sMonth).replace("MMM",sMonth.substring(0,3)).replace("MM",(month<9?"0":"")+(month+1));  
}  
var d = new Date();  
var aa = document.getElementsByName("dealTimeFormt");
var a="";   
    for(var i=0;i<aa.length;i++){    
      var aaa=aa[i];    
      if(aaa.checked){    
     a=aaa.value;  }
   }
var bb = document.getElementsByName("dealTimeModel");
var b="";   
    for(var i=0;i<bb.length;i++){    
      var bbb=bb[i];    
      if(bbb.checked){    
     b=bbb.value;  }
   }
if ( a== "0" )
{  
	if (b=="1")
		{  
			 document.getElementById("TimeExample").innerHTML=d.format("示例：yyyy-MM-dd HH:mm");  
    }
    else {    
        document.getElementById("TimeExample").innerHTML=d.format("示例：yyyy年MM月dd日 HH时mm分");
    	}
    }
    else if (a=="1"){
    		if (b=="1")
		{   
        document.getElementById("TimeExample").innerHTML=d.format("示例：yyyy-MM-dd")  ;
    }
    else {    
        document.getElementById("TimeExample").innerHTML=d.format("示例：yyyy年MM月dd日"); 
    	}

    }
  
    else
				{ 
					 document.getElementById("TimeExample").innerHTML=d.format("无时间显示");
					};
};

</SCRIPT>  
</shijian>  
																												
				                                              </div>
				                                            </td>
				                                        </tr>
				                                    </table>
				                                </td>
				                            </tr>
				                        </table>
				                        </fieldset>
									</td>
								</tr>
								<tr>
									<td>
										<div class="categorySet-body-edocform"  >
											<table width="70%" border="1" cellspacing="0" cellpadding="5" align="center">
											<tr style="background-color:#D3D3D3"><th align="left"><fmt:message key="edoc.form.flowperm.process.label" /></th><th align="left"><fmt:message key="edoc.form.flowperm.name.label" /></th><th><fmt:message key="edoc.form.flowperm.operation.label" /></th><th align="left"><fmt:message key="edoc.form.flowperm.process.sortType" /></th></tr>
											<c:forEach items="${processList}" var="bean">
												<tr>
													<td width="30%">${bean.permName}</td>
													<td width="50%"><input readonly="readonly" type="text" style="width:100%;height:100%;" name="${bean.permItem}" id="${bean.permItem}" value="${ empty bean.permItemName || bean.permItemName eq 'null' ? '':bean.permItemName}"></td>
													<td width="20%" align="center"><input type="button" value="<fmt:message key='edoc.button.editoperate.label' />" <c:if test="${param.flag == 'readonly' || param.isSystem == 'true' || bean.permItem == 'otherOpinion' || bean.permItem == 'feedback'}"> disabled </c:if> onclick="chooseFlowPerm('${bean.permItem}','${bean.permItem}');" />
													<div style="display:none">
													<select id="choosedOperation_${bean.permItem}" name="choosedOperation_${bean.permItem}"
														multiple="multiple"  size="4"  class="input-100per">
														<option value="${bean.permItem}" itemList="${bean.permItemList}">${bean.permItemName}</option>
													</select>
														<input id="returnOperation_${bean.permItem}" name="returnOperation_${bean.permItem}" value="${bean.permItemList}" type="hidden">
													</div>
													</td>
													<td>
														<select id="sortType_${bean.permItem}" name="sortType_${bean.permItem}" <c:if test="${param.flag == 'readonly' || bean.permItem == 'feedback'|| bean.permItem == 'report'}"> disabled="disabled"</c:if>>
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
														
														
														<%--puyc --%>
														<c:choose>
															<c:when test="${bean.sortType == '4'}">
																<option value="4" selected="selected"><fmt:message key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
															</c:when>
															<c:otherwise>
																<option value="4"><fmt:message key="edoc.form.flowperm.process.sortTypeAsc.orgLevel" /></option>
															</c:otherwise>
														</c:choose>
														
														<%--//puyc --%>
														
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
												<tr><td colspan="3"><font color="green">*<fmt:message key="edoc.form.otheropinion.notice" /></font><BR>
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

<c:if test="${param.flag != 'readonly'}"> 
<tr>
	<td height="42" align="center" class="bg-advance-bottom" colspan="2">
		<div align="center">
			<input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"	class="button-default_emphasize" id= "modifysubmit" onclick="modify_submit('${listStr}','${content}');">
			<input type="button" onclick="parent.document.location.reload();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
		</div>
	</td>
</tr>	
</c:if>
</table>

<div style="display:none">
	<select id="operation" name="operation" multiple="multiple"  size="4"  class="input-100per">
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

<div class="hidden">
<iframe id="temp_iframe" name="temp_iframe">&nbsp;</iframe>
</div>
<script>


    if(${param.flag != 'readonly' || bean.content == '' }){
		if(${!bean.isSystem and !isOuterAccountAcl}){
			var divA = document.getElementById("divA");
			if(divA){
				divA.style.display = "";
			}
		}
    }
	
	//提交后保存公文单信息
	var attachmentInputs = document.getElementById("attachmentInputs");
	if(attachmentInputs) 
		attachmentInputs.innerHTML = "${v3x:escapeJavascript(param.attachmentStr)}";

	$(function() {
		/*document.getElementById("scrollList").style.height=document.body.offsetHeight-10+"px";  		
        window.onresize=function(){
       		document.getElementById("scrollList").style.height=document.body.offsetHeight-10+"px";
        }*/
		//$("#formField").height($("#categorySetTd").height()-30);
	})
</script>
<div style="height: 0px;width: 0px;display: none">
	<form action="" target="pdfFrame" name="pdfForm" id="pdfForm">
	<input type="hidden" name="pdfId" id="pdfId"/>
	<input type="hidden" name="pdfName" id="pdfName"/>
	<input type="hidden" name="pdfFormId" id="pdfFormId" value="${bean.id}"/>
	<input type="hidden" name="pdfSize" id="pdfSize"/>
	</form>
</div>
<iframe style="height: 0px;width: 0px;display: none" name="pdfFrame" id="pdfFrame"></iframe>
</body>
</html> 