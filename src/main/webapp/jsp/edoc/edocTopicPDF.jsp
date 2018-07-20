<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<html class="over_hidden">
<head>
<%
String path = request.getContextPath();//获取项目名
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"; //获得项目url
String pathlocal = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp"%>
<v3x:showHtmlSignetOcx/> 
<fmt:message key="common.opinion.been.hidden.label" bundle="${v3xCommonI18N}" var="opinionHidden" />
<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" var="attachmentLabel" />
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css${v3x:resSuffix()}"/>" rel="stylesheet" type="text/css">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/form/css/SeeyonForm.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edocDisplay.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/office/js/hw.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/phrase.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery-ui.custom.min.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-ui.custom.js${v3x:resSuffix()}" />"></script>

<c:set value="${v3x:currentUser().id == summary.startUserId}" var="currentUserIsSender"/>
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
var _fileUrlStr = "${fileUrlStr}";
var logoURL = "${logoURL}";
var phraseURL = '<html:link renderURL="/edocController.do?method=listPhrase" />';
var attachmentLabel = "${v3x:escapeJavascript(attachmentLabel)}";
var theToShowAttachments = parent.theToShowAttachments || null;
var opn = "${opn}";
var bodyType="${formModel.edocBody.contentType}";
var canTransformToPdf="${canConvert}";
var onlySeeContent ='${onlySeeContent}';
${docMarkByTemplateJs}
formOperation = "aa";
${opinionsJs}
var isFromTrace = openFrom == "repealRecord" || openFrom == 'stepBackRecord';
var officecanPrint = isFromTrace ? 'false' : '${officecanPrint}';
var officecanSaveLocal =  isFromTrace ? 'false' : '${officecanSaveLocal}';
parent.officecanPrint = officecanPrint;
parent.officecanSaveLocal = officecanSaveLocal;
var onlySeeContent="${onlySeeContent}";
//设置打开的印章变灰
parent.setSignatureBlack = "${isDeptPigeonhole}";  
var isBoundSerialNo = "${isBoundSerialNo}";
var openFrom="${v3x:escapeJavascript(openFrom)}";
var docId="${docId}";
var docSubject="${v3x:escapeJavascript(formModel.edocSummary.subject)}";
var summaryId="${formModel.edocSummary.id}";
var isAllowContainsChildDept_ExchangeUnit = true;
var edocResourseNotExist = "<fmt:message key='edoc.resourse.notExist'/>";
var subState = "${subState}";
var recEdocId = "${recEdocId}";
var paramRecType = "${v3x:escapeJavascript(param.recType)}";
var paramForwardType = "${v3x:escapeJavascript(param.forwardType)}";
var paramRecEdocId = "${v3x:escapeJavascript(param.recEdocId)}";
var relationUrl = "${relationUrl}";
var paramRelSends = "${v3x:escapeJavascript(param.relSends)}";
var paramRelRecs = "${v3x:escapeJavascript(param.relRecs)}";
var policyV = parent.document.getElementById("policy");
var policyValue=(policyV==null?"":policyV.value);

window.onload=init_pdf;
function init_pdf(){
	abx();
}
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/edocTopic.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var iWebPDF2015;
var HWPostil1;
var j = 0;
	function HWPostil1_NotifyCtrlReady(){
		if(j!=0){
			abx();
		}
		j++;
	}
	function abx(){
		var ii = 0;
		var interv = setInterval(function(){
			if(ii>=5){
				clearInterval(interv);
			}
			if(document.readyState=='complete'){
				clearInterval(interv);
				iWebPDF2015 = document.getElementById("iWebPDF2015");
				HWPostil1 =document.getElementById("HWPostil1"); 
				if(parent.PDFId!=''){
					if(parent._fileType=='pdf'){
						if(iWebPDF2015&&iWebPDF2015.Version){
							pdf_init();
						}else{
							//alert("<fmt:message key='edoc.noControl.prompt'/>");
						}
					}else if(parent._fileType=='aip'){
						if(HWPostil1&&HWPostil1.lVersion){
							aip_init();
						}else{
							
							//alert("<fmt:message key='edoc.noControl.prompt'/>");
						}
					}
					
				}
			}
			ii++;
		},100);
		
		
	}
	function aip_init(){
		HWPostil1.ShowDefMenu=0;//隐藏菜单
		HWPostil1.ShowToolBar=0;//隐藏工具栏
		HWPostil1.ShowScrollBarButton=1;//隐藏滚动条的工具栏
		HWPostil1.CurrPenColor=0;//设置笔迹颜色，0是黑色，255是红色
		HWPostil1.CurrPenWidth=6;//设置笔迹宽度。1-28，-1是弹出框用户选择
		HWPostil1.LoadFile(parent.url2+"?fileId="+parent.PDFId+"&summaryFile=1");
		HWPostil1.Login(parent.currentUserId.toString(), 3, 65535, "", "<%=pathlocal%>/Seal/general/interface/");//用户名，测试用户，全部权限，密码，远程登陆地址
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
	}
	function pdf_init(){
		iWebPDF2015.Options.TabCommandBarVisible = false;

			parent.openWebPDF(iWebPDF2015,parent.PDFId,parent.url1);
		
			var formId = $("#edoctable").val();
		
			iWebPDF2015.Options.TabBarVisible = false;//隐藏tab
			iWebPDF2015.Documents.ActiveDocument.Window.DisplayLayout = false;//隐藏排版格式
			iWebPDF2015.Documents.ActiveDocument.Window.DisplayNavigation = false;//隐藏分页
			iWebPDF2015.Options.UserName = parent.currentUserId; //当前登录人
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
				/*for ( var j=0; j < control.Count ; j++)
				{
					alert(control.Item(j).Caption);
					/*var UI = Controls.Item(j);
					alert(UI.Id);
					if ( Controls(j).Id == menuid )
					{
						UI.Visible = false;	
					}*/
				//}
				
			}
			
			//field只读
			
			var fielCount = iWebPDF2015.Documents.ActiveDocument.Fields.Count;
			for(var i = 0;i<fielCount;i++){
				iWebPDF2015.Documents.ActiveDocument.Fields(i).AllowInteraction = false;
			}
	}
	//全文签批
	function handWrite(){
		if(iWebPDF2015&&iWebPDF2015.Version){
			var addin = iWebPDF2015.COMAddins.Item("KingGrid.Handwritting");
			if (addin)
			{
				addin.Object.SetOption(4,5000);
				//如果存在这个对象，创建手写
				var res = addin.Object.CreateHandWrite();
				//iWebPDF2015.COMAddins.("KingGrid.HandWritting").Object.SetOption(4,5000);
				$("#chexiao").show();
			}
		}
		if(HWPostil1&&HWPostil1.lVersion){
			HWPostil1.CurrAction =264;//手写状态
			HWPostil1.CurrPenColor = 0;//红色
			HWPostil1.SetValue("PREDEF_NOTE_NAME",parent.activityId.toString()+","+policyValue);
			$("#chexiao").show();
		}
		if(iWebPDF2015&&iWebPDF2015.Version||HWPostil1&&HWPostil1.lVersion){
			
		}else{
			alert("<fmt:message key='edoc.noControl.prompt'/>");
		}
	}
	//撤销签批
	
	function revokeWrite(userId){
		var nCount = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Count;//获取所有签名数量
		for (var i = nCount-1; i>=0; i--)
		{
			var inf = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).GetCustomEntry("AnnotInfo");
			if (inf)
			{
				//查找对应字符串"如用户名为admin" 
				var strSearch = new String("\""+userId+"\"");
				var nLen = strSearch.length;
				var res = inf.indexOf(strSearch);
				if( res != -1){
					if( iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).Subtype=="UnKnown"){	 //手写批注类型
						iWebPDF2015.Documents.Item(0).Pages(0).Annots.Item(i).Delete();
					}
				}
			}
		}
		iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();//刷新   不刷新看不到动态删除的效果
	}
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
						if(NoteInfo.indexOf(parent.affair_id.toString())!="-1"&&NoteInfo.indexOf(policy)!="-1"){//如果当前节点没签字
							flag = true;
						}
					}
					NoteInfo = "";
					while(NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo)){//循环节点，印章类型为251
						if(NoteInfo.indexOf(parent.affair_id.toString())=="-1"&&NoteInfo.indexOf(policy)!="-1"&&flag){
							HWPostil1.DeleteNote(NoteInfo);
							revokeOld(userId,policy);
						}
					}
				}	
			}
		}
		if(iWebPDF2015&&iWebPDF2015.Version){
			var nCount = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Count;//获取所有签名数量
			for (var i = nCount-1; i>=0; i--)
			{
				var inf = iWebPDF2015.Documents.ActiveDocument.Pages(0).Annots.Item(i).GetCustomEntry("AnnotInfo");
				
				if (inf)
				{
					//查找对应字符串"如用户名为admin" 
					var strSearch = new String(userId.toString()+","+policy+","+parent.affair_id.toString());
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
		}
	}
	function revokeNowWrite(userId){
		if(userId){
			
		}else{
			userId = parent.currentUserId.toString();
		}
		if(iWebPDF2015){
			revokeWrite(userId);
		}
		if(HWPostil1&&HWPostil1.lVersion){
			var User = "";
			
			while(User=HWPostil1.JSGetNextUser(User)){//循环用户
				var NoteInfo="";
				if(User==userId.toString()){
					var oldnote="";
					NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo);
					while(NoteInfo!=""){
						if(NoteInfo.indexOf(parent.activityId)!=-1){
							oldnote=NoteInfo;
						}
						NoteInfo=HWPostil1.GetNextNote(User,0,NoteInfo);
					}	
					HWPostil1.DeleteNote(oldnote);//删除节点
				//if(User==userId.toString()){
					
					
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
${hwjs} 
</head>
<body  >
<%@include file="unitId.jsp" %>

<input type="hidden" name="appName"   id="appName" value="<%=ApplicationCategoryEnum.edoc.getKey()%>">
<input type="hidden" name="summaryId" id="summaryId" value="${formModel.edocSummary.id}">
<input type="hidden" name="edoctable" id="edoctable" value="${formModel.edocSummary.formId}">
<input type="hidden" name="edocType"  id="edocType"  value="${formModel.edocSummary.edocType}">
<input type="hidden" name="currContentNum" id="currContentNum" value="0">
<input type="hidden" name="affairId"  id="affairId" value="${affairId}">
<input type="hidden" name="isUniteSend" id="isUniteSend" value="${formModel.edocSummary.isunit}">
<input type="hidden" name="orgAccountId" id="orgAccountId" value="${formModel.edocSummary.orgAccountId}">
<%--记录日志的时候不能区别出是修改了文单还是仅仅修改了文号。加此变量就是为了区别这个 BUG30034--%>
<input type="hidden" name="isOnlyModifyWordNo" id="isOnlyModifyWordNo" value=true>
<input type="hidden" id="pushMessageMemberIds" name="pushMessageMemberIds" value="">
<input type="hidden" name="templeteId" id="templeteId" value="${formModel.edocSummary.templeteId}">

<input type="hidden" name="docMarkValue" id="docMarkValue" value ="${summary.docMark}">
<input type="hidden" name="docMark2Value" id="docMarkValue2" value ="${summary.docMark2}">
<input type="hidden" name="docInmarkValue" id="docInmarkValue" value ="${summary.serialNo}">
<input type="hidden" name="taohongriqiSwitch" id="taohongriqiSwitch" value ="${taohongriqiSwitch}">

<div style="margin-left:150px;float:left" >
<div class=" advanceICON">
		<a  id="chexiao" style="display:none" onclick = "revokeNowWrite()"><img src="${pageContext.request.contextPath }/apps_res/edoc/images/che.png" style="width:25px;"/>
			</a></div></div>
<div style="margin-top:10px;margin-left:150px;width:100%;height:100%" id="pdfOrAip">
	<!--   PDF   AIP    控件   -->
	<c:if test="${fileType=='pdf'}">
	<object classid='clsid:7017318C-BC50-4DAF-9E4A-10AC8364C315' codebase='iWebPDF2015.cab#version=1,0,3,1080' id=iWebPDF2015 height=100%  width=80%></object>
	</c:if>
	<c:if test="${fileType=='aip'}">
		<script>
			browserPanduan(85,100);
		</script>
	</c:if>
	<!-- -->

</div>

</body>
</html>
