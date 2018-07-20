<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>

<html class="over_hidden" style="height:100%">
<head>
<%@ include file="/WEB-INF/jsp/common/common4coll.jsp"%>
<%
String path = request.getContextPath();//获取项目名
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; //获得项目url
String pathlocal = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/govdoc/js/govdocSignContent.js"></script>
<style>
body, td, th, input, textarea, div, select, p {
	font-family: "Microsoft YaHei",SimSun, Arial,Helvetica,sans-serif;
}
	.metadataItemDiv {
		font-size:12px;
	}
 .ui-menu *{font-size:12px;}
</style>
<script>
var signString = "";
var policyV = parent.document.getElementById("policy");
var policyValue=(policyV==null?"":policyV.value);

window.onload=init_pdf;
function init_pdf(){
	initObject();
}
var HWPostil1;
var iWebPDF2015;
var bAnnotControl = true;
var fromButton = "${fromButton}";
var isHandWrite = "${isHandWrite}";
</script>
<!-- 如果是pdf文件，打开文档时初始化 -->
<script language="javascript" for=iWebPDF2015 event="OnDocumentOpen(pDoc)">
    //导入批注
    
    if(signString!=""){
    	signString = "{\"annots\":"+signString+"}";
		var test = iGetInnerText(signString);
		var jsonranklist = JSON.parse(test);
		var addin = iWebPDF2015.COMAddins.Item("KingGrid.Handwritting").Object;
		for(var i=0;i<jsonranklist.annots.length;i++){
		//alert(jsonranklist.annots.length);
			var annot =jsonranklist.annots[i];
			var v1 = annot.pageNo;
			var v2 = annot.X;
			var v3 = annot.Y;
			var v4 = annot.width;
			var v5 = annot.height;
			var v6 = annot.createTime;
			var v7 = annot.curDateTime;
			var v8 = annot.authorId;
			var v9 = annot.authorName;
			var v10 = annot.annotContent;
			var v11 = annot.styleId;
			addin.ImportAnnot(v1,v11,v2,v3,v4,v5,v6,v7,v8,v9,v10);			
		}			
		iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();
	}
    
	iWebPDF2015.Options.UserName=parent._currentUserId.toString()+","+policyValue+","+parent.affairId;
	iWebPDF2015.Options.TabBarVisible = false;//隐藏tab
	iWebPDF2015.Documents.ActiveDocument.Window.DisplayLayout = false;//隐藏排版格式
	iWebPDF2015.Documents.ActiveDocument.Window.DisplayNavigation = false;//隐藏分页
					
	//隐藏 工具栏
	var nCount = iWebPDF2015.CommandBars.Count;  //所有工具栏层对象个数
	for ( var i = 0; i<nCount; i++ )
	{
		var control = iWebPDF2015.CommandBars(i).Controls;   //工具栏层对象
		//alert(iWebPDF2015.CommandBars(i).Name);           //获取工具栏层对象的名称
		var bComment = false;
		if (  "Comments" != iWebPDF2015.CommandBars(i).Name  )     //判断不是comments工具栏层则隐藏
		{
			iWebPDF2015.CommandBars(i).Visible = false;
			iWebPDF2015.CommandBars(i).Enabled = false;
			bComment = false;
		}else{
			bComment = true;
		}
		if(bComment){
			var controls = iWebPDF2015.CommandBars(i).Controls;
			iWebPDF2015.CommandBars(i).Enabled=false;
			iWebPDF2015.CommandBars(i).Visible=false;
			//controls.Enabled=false;
							
		}
	}
					
	var fielCount = iWebPDF2015.Documents.ActiveDocument.Fields.Count;
	for(var i = 0;i<fielCount;i++){
		iWebPDF2015.Documents.ActiveDocument.Fields(i).AllowInteraction = false;
	}
	if(fromButton=='signChange'){
		signChange();
	}
	if(isHandWrite=='handWrite'){
		handWrite();
	}
</script>
<!-- pdf控制拖动 -->
<script language="javascript" for=iWebPDF2015 event="OnAddinEventInvoke(EventName, Addin, wParam, lParam)">
	if( EventName=="iStylePDF.Annots:OnLButtonDown" || EventName=="iStylePDF.Annots:RButtonDown"|| EventName=="iStylePDF.Annots:OnDelKeyDown"|| EventName=="iStylePDF.Annots:LButtonDblClk" )
	{
		//通过当前视图获取批注
		//iWebPDF2015.Documents.ActiveDocument.Views.ActiveView
		var annot = Addin.Annotation;
		if(annot != null)
		{
			//可以禁用标准批注插件的操作。true 标准插件不执行任何操作。false 标准插件继续执行
			//判断是否用户可以操作批注
			var inf = annot.GetCustomEntry("AnnotInfo");
			
			if ( inf )
			{
				//查找对应字符串"如用户名为admin" 
				//var strSearch = new String("\"xx\":\"aaa\"");
				//var nLen = strSearch.length;
				//var res = inf.indexOf(strSearch);
				var res = "";
				var HandWrite = iWebPDF2015.COMAddins.Item("KingGrid.Handwritting").Object;
				//alert(res);
				
				if( res == 1)
				{
					HandWrite.MsgHandle = bAnnotControl;
					Addin.MsgHandle = bAnnotControl;
					//alert(1);
				}
				else
				{
					HandWrite.MsgHandle = bAnnotControl;
					Addin.MsgHandle = bAnnotControl;
					//alert(2);
				}
				
			}
			
		}
	}
</script>
<script type="text/javascript">

	//AIP可拖动签批
	function signChange(){
		if(parent._fileType=='aip'){
			HWPostil1.CurrAction =1;
			HWPostil1.SetValue("SET_TEMPFLAG_MODE_ADD", "4194304");
		}
		if(parent._fileType=='pdf'){
			bAnnotControl = false;
		}
	}
	//PDF将json批注信息中得回车去掉
	function iGetInnerText(testStr) {
	    var resultStr; 
	    //resultStr= testStr.replace(/\ +/g, ""); //去掉空格
	    //resultStr = testStr.replace(/[ ]/g, "");    //去掉空格
	    resultStr = testStr.replace(/[\r\n]/g, " "); //去掉回车换行
	    return resultStr;
	}
	var j = 0;
// 	function HWPostil1_NotifyCtrlReady(){
// 		if(j!=0){
// 			initObject();
// 		}
// 		j++;
// 	}
	function initObject(){
		var ii = 0;
		var interv = setInterval(function(){
			if(ii>=5){
				if(parent._fileType=='aip'){
					if(typeof(HWPostil1)=='undefined'||typeof(HWPostil1.lVersion)=='undefined'){
						$.alert("请确认已安装全文签批AIP控件");
					}
				}
				if(parent._fileType=='pdf'){
					if(typeof(iWebPDF2015)=='undefined'||typeof(iWebPDF2015.Version)=='undefined'){
						$.alert("请确认已安装全文签批iWebPDF控件");
					}
				}
				clearInterval(interv);
			}
			if(document.readyState=='complete'){
				if(parent.PDFId!=''){
					if(parent._fileType=='aip'){
						HWPostil1 =document.getElementById("HWPostil1"); 
						if(HWPostil1&&HWPostil1.lVersion){
							aip_init();
							clearInterval(interv);
						}
					}
					if(parent._fileType=='pdf'){
						iWebPDF2015 = document.getElementById("iWebPDF2015");
						if(iWebPDF2015&&iWebPDF2015.Version){
							pdf_init();
							clearInterval(interv);
						}
					}
				}
					
			}
			ii++;
		},100);
		
		
	}
	//pdf控件时需要用到的保存签批
	function savePDFSign(summaryId){
		var signStr = "";
		var addin = iWebPDF2015.COMAddins.Item("KingGrid.Handwritting").Object;
		signStr = addin.GetAnnotString(12);
		pdfForm.action = "/seeyon/edocController.do?method=savePDFSign&summaryId="+summaryId;
		document.getElementById("signStr").value=signStr;
		pdfForm.submit();
	}
	//pdf控件时需要用到的先写值
	function mappdf(){
    	var valueObject = parent.componentDiv.zwIframe.document.querySelectorAll("span[id^='field'][id$='_span']");
    	var opinions =  parent.myopinions;
    	var rv = "";
		$(valueObject).each(function(){
			var fieldVal = $.parseJSON($(this).attr("fieldVal"));
			var key = fieldVal.displayName;
			var value = $(this).text();
			if($(this).attr("class")=="edit_class"){
				var $a = $(this);
				$(this).children().each(function(){
					if(this.nodeName !="undefined" && (this.nodeName == "SELECT" || this.nodeName == "select")){
						var index = this.selectedIndex;
						value = this.options[index].text;
					}
					if(typeof($(this).attr("mappingField"))!="undefined"&&this.nodeName !="undefined" && (this.nodeName == "INPUT" || this.nodeName == "input")){
						value = this.getAttribute("value");
					}
					if(fieldVal.inputType=='member'||fieldVal.inputType=='account'||fieldVal.inputType=='department'||fieldVal.inputType=='post'||fieldVal.inputType=='accountAndDepartment'){
						value = $a.children()[0].getAttribute("title");
					}
					if(typeof(value)=='object'){
						value="";
					}
				});
			}
			rv += key +"="+value+",";
		});
		if(opinions){
			rv+=opinions;
		}
		return rv;
    }
	function aip_init(){
		HWPostil1.ShowDefMenu=0;//隐藏菜单
		HWPostil1.ShowToolBar=0;//隐藏工具栏
		HWPostil1.ShowScrollBarButton=1;//隐藏滚动条的工具栏
		HWPostil1.CurrPenColor=0;//设置笔迹颜色，0是黑色，255是红色
		HWPostil1.CurrPenWidth=6;//设置笔迹宽度。1-28，-1是弹出框用户选择
		HWPostil1.SilentMode=1;
		//显示比例为90
		HWPostil1.SetPageMode(1,90);
		var a = HWPostil1.LoadFile(parent.url2+"?fileId="+parent.PDFId+"&summaryFile=1");
		var b = HWPostil1.Login(parent._currentUserName.toString(), 3, 65535, "", "<%=pathlocal%>/Seal/general/interface/");//用户名，测试用户，全部权限，密码，远程登陆地址
		if(b=='0'){
		}else if(b=='-102'){
			alert("服务器用户数已满，请联系管理员");
		}else if(b=='-71'){
			alert("链接服务器失败，请联系管理员");
		}else{
			alert("服务器链接失败");
		}
		//HWPostil1.Login("", 1, 65535, "", "");
		HWPostil1.SetValue("SET_TEMPFLAG_MODE_DEL", "4194304");
		//设置所有节点只读
		var User="";
		while(User=HWPostil1.JSGetNextUser(User)){//循环用户
			var NoteInfo="";
			while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点
				HWPostil1.SetValue(NoteInfo, ":PROP::LABEL:3");//设置节点为只读
			}
		}
		if(parent.componentDiv!=null){
			setEdocSummaryData(HWPostil1,parent.componentDiv.zwIframe);
		}
		
		if(fromButton=='signChange'){
			signChange();
		}
		if(isHandWrite=='handWrite'){
			handWrite();
		}
	}
	function pdf_init(){
		
		iWebPDF2015.Options.TabCommandBarVisible = false;
		//打开pdf
		//如果有summaryID   是公文中签批显示  如果没有，是表单中预览
		if(parent.summaryId){
			var chuanzhi = mappdf();
			$.ajax({
				type: "post",
				data: {"summaryId":parent.summaryId,"mydata":chuanzhi},
				url:"/seeyon/edocController.do?method=setForm&dd="+new Date().getTime(),
				success:function(data){
					signString = data;
					iWebPDF2015.Documents.OpenFromURL(parent.url1+"?method=loadSummary&summaryId="+parent.summaryId+"&fileId="+parent.PDFId);
				}
			});
		}else{
			iWebPDF2015.Documents.OpenFromURL(parent.url1+"?method=loadForm&fileId="+parent.PDFId);
		}
	}
	//全文签批
	function handWrite(){
		if(iWebPDF2015&&iWebPDF2015.Version){
			var addin = iWebPDF2015.COMAddins.Item("KingGrid.Handwritting");
			if (addin)
			{
				addin.Object.SetOption(1,1);
				addin.Object.SetOption(4,500);
				//如果存在这个对象，创建手写
				var res = addin.Object.CreateHandWrite();
				//iWebPDF2015.COMAddins.("KingGrid.HandWritting").Object.SetOption(4,5000);
				document.getElementById("chexiao").style.visibility="visible";
			}
		}
		if(HWPostil1&&HWPostil1.lVersion){
			
			HWPostil1.CurrAction =264;//手写状态
			HWPostil1.CurrPenColor = 0;
			HWPostil1.SetValue("PREDEF_NOTE_NAME",parent.affairId.toString()+","+policyValue);
			document.getElementById("chexiao").style.visibility = "visible";
		}
	}
	//撤销签批
	
	/*
	function revokeOld(userId,policy){
		if(HWPostil1&&HWPostil1.lVersion){
			var User = "";
			
			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
				var NoteInfo="";
				if(User==userId.toString()){
					while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点，印章类型为251
					
						if(NoteInfo.indexOf(parent.affair_id.toString())=="-1"){
							HWPostil1.DeleteNote(NoteInfo);
						}
					}
				}	
			}
		}
	}*/
	function revokeOld(userId,policy){
		if(HWPostil1&&HWPostil1.lVersion){
			var User = "";
			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
				var NoteInfo="";
				if(User==userId.toString()){
					var flag = false;
					while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点，印章类型为251
						if(NoteInfo.indexOf(parent.affairId.toString())!="-1"&&NoteInfo.indexOf(policy)!="-1"){//如果当前节点没签字
							flag = true;
						}
					}
					NoteInfo = "";
					while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点，印章类型为251
						if(NoteInfo.indexOf(parent.affairId.toString())=="-1"&&NoteInfo.indexOf(policy)!="-1"&&flag){
							HWPostil1.DeleteNote(NoteInfo);
							revokeOld(userId,policy);
						}
					}
				}	
			}
// 			var User = "";
// 			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
// 				var NoteInfo="";
// 				if(User==userId.toString()){
// 					while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点，印章类型为251
// 						if(NoteInfo.indexOf(parent.affair_id.toString())=="-1"&&NoteInfo.indexOf(policy)!="-1"){
// 							HWPostil1.DeleteNote(NoteInfo);
// 						}
// 					}
// 				}	
// 			}
			
		}
		if(iWebPDF2015&&iWebPDF2015.Version){
			var nCount = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Count;//获取所有签名数量
			for (var i = nCount-1; i>=0; i--)
			{
				var inf = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).GetCustomEntry("AnnotInfo");
				if (inf)
				{
					//查找对应字符串"如用户名为admin" 
					var strSearch = new String(userId.toString()+","+policy+","+parent.affairId.toString());
					var userStr = new String(userId.toString()+","+policy);
					if(inf.indexOf(userStr)!=-1){
						var res = inf.indexOf(strSearch);
						if( res == -1){
							if( iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).Subtype=="Stamp"){	 //手写批注类型
								iWebPDF2015.Documents.Item(0).Pages(0).Annots.Item(i).Delete();
							}
						}
					}
					
				}
			}
			iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();
			
		}
	}
	function revokeNowWrite(userId){
		userId = parent._currentUserName.toString();
		if(iWebPDF2015&&iWebPDF2015.Version){
			var nCount = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Count;//获取所有签名数量
			for (var i = nCount-1; i>=0; i--)
			{
				var inf = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).GetCustomEntry("AnnotInfo");
				var authorname = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).GetCustomEntry("author");
				if (inf)
				{
					//查找对应字符串"如用户名为admin" 
					var strSearch = new String(userId);
					var nLen = strSearch.length;
					var res = inf.indexOf(strSearch);
					if( res != -1){
						if( iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).Subtype=="Stamp"){	 //手写批注类型
							iWebPDF2015.Documents.Item(0).Pages(0).Annots.Item(i).Delete();
						}
					}
				}
			}
			iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();//刷新   不刷新看不到动态删除的效果
		}
		if(HWPostil1&&HWPostil1.lVersion){
			var User = "";
			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
				var NoteInfo="";
				if(User==userId.toString()){
					var oldnote="";
					var oldtime="";
					NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo);
					while(NoteInfo!=""){
						if(NoteInfo.indexOf(policyValue)!=-1){
							oldnote=NoteInfo;
							var newtime=HWPostil1.GetValueEx(NoteInfo,27,"",0,"");//获得新的时间
							if(newtime<oldtime){//如果新节点时间小于老时间就  
								oldtime=newtime;
								oldnote=NoteInfo;
							}
						}
						NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo);
					}
					HWPostil1.DeleteNote(oldnote);//删除节点
				}
			}
			/*
			var SerialNumber = HWPostil1.GetSerialNumber();   //获取当前UK里证书序列号
			var NoteInfo=HWPostil1.GetNextNote(SerialNumber,0,"");
			var oldnote="";
			var oldtime="";
			while(NoteInfo != ""){
				var newtime=HWPostil1.GetValueEx(NoteInfo,27,"",0,"");
				if(newtime>oldtime){
					oldtime=newtime;
					oldnote=NoteInfo;
				}
				NoteInfo=HWPostil1.GetNextNote(SerialNumber,0,NoteInfo);
			}
			HWPostil1.DeleteNote(oldnote);//删除节点
			*/
		}
	}
</script>
</head>
<body style="height:100%;" >

<input type="hidden" name="appName"   id="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" name="affairId"  id="affairId" value="${affairId}">
<div style="display:none" id="edocSignOpinionModel"></div>
<div style="padding-left:10px;float:left" >
<div class=" advanceICON">
		<a  id="chexiao" style="visibility:hidden" onclick = "revokeNowWrite()"><img src="${pageContext.request.contextPath }/apps_res/edoc/images/che.png" style="width:25px;"/>
			</a></div></div>
<div style="margin-top:10px;margin-left:50px;width:100%;height:100%" id="pdfOrAip">
	<!--   PDF   AIP    控件   -->
	<c:if test="${fileType=='pdf'}">
		<object classid='clsid:7017318C-BC50-4DAF-9E4A-10AC8364C315' codebase='iWebPDF2015.cab#version=1,0,3,1080' id=iWebPDF2015 height=100%  width=80%></object>
	</c:if>
	<c:if test="${fileType=='aip'}">
		<script>
			browserPanduan(89,100);
		</script>
	</c:if>

</div>
<div style="height: 0px;width: 0px;display: none">
	<form action="" target="pdfFrame" name="pdfForm" id="pdfForm" method="post">
	<input type="hidden" name="signStr" id="signStr"/>
	</form>
</div>
<iframe style="height: 0px;width: 0px;display: none" name="pdfFrame" id="pdfFrame"></iframe>
</body>
</html>
