<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<title>promulgation</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/common/css/default.css${v3x:resSuffix()}">
<link rel="stylesheet" type="text/css"
	href="/apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}">
<script type="text/javascript"
	src="<c:url value="/apps_res/inquiry/js/inquiry.js${v3x:resSuffix()}" />"></script>
<script>
getA8Top().showLocation(702,"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");
var CacheString=null;
function recordCache(){
	document.getElementById("memo").style.display="";
	document.getElementById("addProjectBox").style.display="";
    CacheString=document.getElementById("addProjectBox").innerHTML;
}
	
function addProject(){
	document.getElementById("addProjectBox").style.display="";
	//document.getElementById("memo").style.display="none";
	//document.getElementById("addProjectBox").innerHTML=CacheString;
	showProjectInfo();
}
function deleteProject(){
    var obj = document.getElementById("projectBox");
	var tmpindex=obj.selectedIndex;
    //if(tmpindex == 0){
    //     mainForm.title.value = "";
    //     mainForm.desc.value = "";
    //     var single = document.getElementById("single");
    //     single.checked = true;
    //     var selectMaxTag = document.getElementById("selectMaxTag");
    //     selectMaxTag.style.display = 'none';    
    //     mainForm.otherItem.checked = false;
    //     mainForm.discuss.checked = false;
     //    var subjectBox = document.getElementById("subjectBox");
      //   var childList = subjectBox.childNodes;
      //   if(childList){
	//		         for(var s = 1;s< childList.length ; s++){
	//		             subjectBox.removeChild(childList[s]);
	//		         }
     //    }
    //}
	if(tmpindex!=-1){
		questions.remove(tmpindex);
		obj.remove(tmpindex);
		var keys = questions.keys();
		var lastKey = null;
		for(var i = 0; i < keys.size(); i++){
			var key = keys.get(i);
			var value = questions.get(key);
		
	
			if(key > tmpindex){
				questions.put(parseInt(key) - 1, value);
				lastKey = key;
			}
		}	
		if(lastKey){
			questions.remove(lastKey);
		}
	}
	document.getElementById("memo").style.display="";
	document.getElementById("addProjectBox").style.display="none";
}
function upProject(){
     var sort = mainForm.projectBox.options.selectedIndex;
     if(sort == -1){
   		alert(v3x.getMessage("InquiryLang.inquiry_before_up_down_alert"));
   		return false;
    }
    var tempString;
    var obj = document.getElementById("projectBox");
	if(obj.selectedIndex>0){
	 tempString=obj.options[obj.selectedIndex].text;
	 obj.options[obj.selectedIndex].text=obj.options[obj.selectedIndex-1].text;
	 obj.options[obj.selectedIndex-1].text=tempString;
	 obj.selectedIndex--;
	 moveObj(obj.selectedIndex,0);
	}
	document.getElementById("memo").style.display="";
	document.getElementById("addProjectBox").style.display="";
}
function downProject(){
    var sort = mainForm.projectBox.options.selectedIndex;
     if(sort == -1){
   		alert(v3x.getMessage("InquiryLang.inquiry_before_up_down_alert"));
   		return false;
    }
    var tempString;
    var obj = document.getElementById("projectBox");

	if(obj.selectedIndex<obj.length-1&&obj.selectedIndex!=-1){
	 tempString=obj.options[obj.selectedIndex].text;
	 obj.options[obj.selectedIndex].text=obj.options[obj.selectedIndex+1].text;
	 obj.options[obj.selectedIndex+1].text=tempString;
	 obj.selectedIndex++;
	 moveObj(obj.selectedIndex,1);	 
	}
	document.getElementById("memo").style.display="";
	document.getElementById("addProjectBox").style.display="";
}
/*
function sortFun(){
    var pElementObj = document.getElementsByName("pElement");
    var pElementLength = document.getElementsByName("pElement").length;
	var pBox=document.getElementById("projectBox");

	if(pElementLength!=0){  
		  for(i=0;i<pElementLength;i++){
		     pElementObj[i].parentNode.parentNode.firstChild.innerHTML=i+1;
		  }
	}
}
*/
function addSubject(){
  try{
	    var sort = mainForm.projectBox.options.selectedIndex;
	    if(sort == -1){
	   		alert(v3x.getMessage("InquiryLang.inquiry_question_null_alert"));
	   		return;
	    }
	    var hiddenquestion = questions.get(sort);
	    var a = hiddenquestion.items.size();
	    var pBox=document.getElementById("subjectBox");
	    var tr, td;
		tr = document.createElement("TR");
		td = document.createElement("TD"); 
		td.innerHTML="<input type=text name='itemarr' value='' id='itemarr_"+a+"' onchange='oneQuestion()' maxlength='100'><input type=button value='<fmt:message key="common.toolbar.delete.label" bundle="${v3xCommonI18N}"/>' onclick='deleteSubject(this, "+a+")'>"; 
		tr.appendChild(td);
	    pBox.firstChild.appendChild(tr);
   }catch(e){}
}
/**
 *加载已有的调查项目
 */
 
function arraddSubject(arr){
		var arrapBox=document.getElementById("subjectBox");
		var rows = arrapBox.rows;
		//删除已有的项
		if(rows){
			var len = rows.length;
			for(var i=0; i<len; i++){
				rows.item(0).removeNode(true);
			}
		}
		
		for(var a = 0 ; a < arr.size(); a++){
			var arrtr, arrtd;
			arrtr = document.createElement("TR");
			arrtd = document.createElement("TD");
			arrtd.innerHTML="<input type=text name='itemarr' id='itemarr_"+a+"' value='" + arr.get(a) + "' onchange='oneQuestion()'><input type=button value='删除' onclick='deleteSubject(this, "+a+")'>"; 
			arrtr.appendChild( arrtd );
			arrapBox.firstChild.appendChild(arrtr);
		}
}

function deleteSubject(obj, index){
   var item = document.getElementById("itemarr_" + index).value;
   obj.parentNode.parentNode.removeNode(true);
   var sort = mainForm.projectBox.options.selectedIndex;
   var hiddenquestion = questions.get(sort);
   hiddenquestion.items.remove(item);
}




function showProjectInfo(){
	v3x.openWindow({
			url :"${addURL}",
			width : "450",
			height : "130",
			resizable : "false"
			
		});
	//window.showModalDialog("/apps_res/inquiry/add.html",self,"dialogHeight: 150px; dialogWidth: 350px;center: yes; status=no");
}


 function showTemplate(){
    v3x.openWindow({
			url : "${basicURL}?method=templateIframe&id=tem&typeName=${typeName}",
			width : "600",
			height : "300",
			resizable : "true",
			scrollbars : "true"
		});
		if(document.all.tem.value!=""){
		   var temid = document.all.tem.value;
		   location.href="${basicURL}?method=get_template&bid="+temid+"&surveytypeid="+'${param.surveytypeid}&typeName=${typeName}';
		}
}


function addOption( who, oCaption, oValue ){
	who = who || document.getElementById("projectBox");
	
	optionElement = new Option(oCaption,oValue);
	who.add(optionElement);
	optionElement.selected = true;
	objQuestion(who.options.selectedIndex);
}

function checkProjectNameIsExist(o){
   var obj = document.getElementById("projectBox");
   var flag = true;
   for(i=0;i<obj.length;i++){
      if(obj.options[i].text==o){
	     flag=false;
		 break;
	  }
   }
   return flag;
}

function setRadioValue(flag){
try{
var index = mainForm.projectBox.options.selectedIndex;

var title = mainForm.title.value;
var desc = mainForm.desc.value;


var maxSelect = mainForm.smaxselectnum.value;
if(flag == 1){
	
	if(mainForm.singleOrMany[0].checked)
	{
		mainForm.hsom.value=0;
		selectMax(2);
	}
	if(mainForm.singleOrMany[1].checked){
		mainForm.hsom.value=1;
		selectMax(1);
	}
	
var singleOrMany = mainForm.hsom.value;	
var discuss = mainForm.discuss.value;
var otherItem = mainForm.otherItem.value;

//alert("title=" + title + "\n" + "desc=" + desc + "\n" +  "singleOrMany=" + singleOrMany + "\n" + "otherItem=" + otherItem + "\n" + "discuss=" + discuss + "\n" + "maxSelect=" + maxSelect + "\n");

	oneQuestion();
}
if(flag ==  2){

	if(mainForm.otherItem.checked)
	{
		mainForm.otherItem.value="0";
	}else{
		mainForm.otherItem.value="1";
	}
	var singleOrMany = mainForm.hsom.value;	
	var discuss = mainForm.discuss.value;
	var otherItem = mainForm.otherItem.value;


	//alert("title=" + title + "\n" + "desc=" + desc + "\n" +  "singleOrMany=" + singleOrMany + "\n" + "otherItem=" + otherItem + "\n" + "discuss=" + discuss + "\n" + "maxSelect=" + maxSelect + "\n");
	
	oneQuestion();
}
if(flag == 3){

	if(mainForm.discuss.checked)
	{
		mainForm.discuss.value="0";
	}else{
		mainForm.discuss.value="1";
	}
	var singleOrMany = mainForm.hsom.value;	
	var otherItem = mainForm.otherItem.value;
	var discuss = mainForm.discuss.value;

	//alert("title=" + title + "\n" + "desc=" + desc + "\n" +  "singleOrMany=" + singleOrMany + "\n" + "otherItem=" + otherItem + "\n" + "discuss=" + discuss + "\n" + "maxSelect=" + maxSelect + "\n");
	
	oneQuestion();
}
}catch(e){}
}

function selectMax(obj){

  if(obj==1){
    document.getElementById("selectMaxTag").style.display="";
   }else if(obj==2){
    document.getElementById("selectMaxTag").style.display="none";
   	document.getElementById("maxselectnum").value="0";
   }
}

function setPeopleFields(elements)
{
	if(!elements){
		return;
	}

	document.getElementById("deptname").value=getNamesString(elements);
	
	document.getElementById("department_id").value=getIdsString(elements,false);
	
	//alert(document.getElementById("department_id").value);
}

function setPeopleFieldsBack(elements)
{
	if(!elements){
		return;
	}

	document.getElementById("obj").value=getNamesString(elements);
	
	document.getElementById("scope_id").value=getIdsString(elements,true);

}
function viewPage(flag){
   if(checkForm(document.mainForm)){
   clearDefaultValueWhenSubmit(mainForm.send_date);
   clearDefaultValueWhenSubmit(mainForm.close_date);
   if(mainForm.send_date.value>=mainForm.close_date.value && mainForm.send_date.value !="" && mainForm.close_date.value !=""){
		    alert(v3x.getMessage("InquiryLang.inquiry_time_equal_alert"));
			return false;
   }
    var nowDate = new Date();
    var nowTime = nowDate.format("yyyy-MM-dd HH:mm").toString();
     //if(nowTime >= mainForm.send_date.value){
     //  alert('开始时间应该晚于当前时间');
     //  return false;
     //}
    if(nowTime >= mainForm.close_date.value && mainForm.close_date.value!=""){
       alert('结束时间应该晚于当前时间');
       return false;
     }
   
	if(flag == 1){	
		 mainForm.action="${basicURL}?method=user_create";
		 mainForm.target = "_self";
		 questions2Input();
	}
	if(flag == 0){
		mainForm.cname.value = mainForm.surveytype_id.options[mainForm.surveytype_id.selectedIndex].text;
		mainForm.action="${basicURL}?method=viewIPage";
		mainForm.target = "_blank";
        questions2Input();
	}
	if(flag == 2){
		mainForm.action="${basicURL}?method=user_create&censor=censor";
		mainForm.target = "_self";
		questions2Input();
	}
	if(flag == 3){
		mainForm.action="${basicURL}?method=user_create&temp=temp";
		mainForm.target = "submitIframe";
		questions2Input();
	}
   }
}

function initTemplete(){
	<c:set var="sort" value="0" />
	<c:forEach items="${tem.subsurveyAndICompose}" var="question">
		var items_${sort} = new ArrayList();
		<c:forEach items="${question.items}" var="item">
		items_${sort}.add("${v3x:escapeJavascript(item.content)}");
		</c:forEach>
		<c:set var="q" value="${question.inquirySubsurvey}"/>	
		var question_${sort} = new Question("${v3x:escapeJavascript(q.title)}", "${v3x:escapeJavascript(q.subsurveyDesc)}", "${q.singleMany}", "${q.otheritem}", "${q.discuss}", "${q.maxSelect}", items_${sort});
		questions.put("${sort}", question_${sort});
		addOption(null, question_${sort}.title, "");	
		<c:set var="sort" value="${sort + 1}" />
	</c:forEach>
    //alert(mainForm.surveytypeid.value);
 }
</script>
<c:if test="${tem.deparmentName != null}">
	<c:set var="dep_id" value="Department|${tem.deparmentName.id}"></c:set>
</c:if>
<v3x:selectPeople id="per" panels="Department,Team,Post,Level"
	maxSize="1" selectType="Department" originalElements="${dep_id}"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="setPeopleFields(elements)" />
<c:set value="${v3x:parseElements(tem.entity,'id','entityType')}"
	var="managers" />
<v3x:selectPeople id="back" panels="Department,Team,Post,Level"
	selectType="Member,Department,Team,Post,Level,Account" originalElements="${managers}"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
	jsFunction="setPeopleFieldsBack(elements)" />
</head>

<body scroll="yes" onload="initTemplete()">
<!--  table width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td valign="top" height="26" class="tab-tag">
		<div class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"><a
			href="${basicURL}?method=survey_index&surveytypeid=${param.surveytypeid}"
			class="non-a">查看列表</a></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left-sel"></div>
		<div class="tab-tag-middel-sel"><a
			href="${basicURL}?method=promulgation&surveytypeid=${param.surveytypeid}"
			class="non-a">新建</a></div>
		<div class="tab-tag-right-sel"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel"><a
			href="${basicURL}?method=basic_NO_send&surveytypeid=${param.surveytypeid}"
			class="non-a">未发布列表</a></div>
		<div class="tab-tag-right"></div>
		</div>
		</td>
	</tr>
	<tr>
		<td colspan="2" class="tab-body-bg-copy ">
		-->
		<script>		
            //first
            var myBar = new WebFXMenuBar;
            myBar.add(new WebFXMenuButton("send", "<fmt:message key='inquiry.publish' />", "viewPage(1)", "<c:url value='/common/images/toolbar/send.gif'/>", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", null));
            myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "viewPage(2)", "<c:url value='/common/images/toolbar/save.gif'/>", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", null));
            myBar.add(new WebFXMenuButton("<fmt:message key='inquiry.save.template.label'/>", "<fmt:message key='inquiry.save.template.label'/>", "viewPage(3)", "<c:url value='/common/images/toolbar/view.gif'/>","<fmt:message key='inquiry.save.template.label'/>", null));
            myBar.add(new WebFXMenuButton("<fmt:message key='inquiry.transfer.template.label'/>", "<fmt:message key='inquiry.transfer.template.label'/>", "showTemplate()", "<c:url value='/apps_res/inquiry/images/new.gif'/>","<fmt:message key='inquiry.transfer.template.label'/>", null));
            var insert = new WebFXMenu;
            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
            myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
            myBar.add(new WebFXMenuButton("<fmt:message key='inquiry.preview.label'/>", "<fmt:message key='inquiry.preview.label'/>", "viewPage(0)", "<c:url value='/apps_res/inquiry/images/new.gif'/>","<fmt:message key='inquiry.preview.label'/>", null));
            document.write(myBar);
          </script>
		<form id="mainForm" name="mainForm" method="post" action=""
			onsubmit="return checkForm(this)">
		<table width="100%" height="100%" border="0" cellpadding="0"
			cellspacing="0">
			<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"
				var="subject" />
			<fmt:message key="common.default.subject.value"
				bundle="${v3xCommonI18N}" var="dfSubject" />
			<fmt:message key="common.default.selectPeople.value" var="defaultSP"
				bundle="${v3xCommonI18N}" />
			<fmt:formatDate value='${tem.inquirySurveybasic.sendDate}'
				pattern='yyyy-MM-dd HH:mm' var="sendtime" />
			<fmt:message key="inquiry.select.sendDate.label" var="dfsendtime" />
			<tr class="bg-summary lest-shadow">
				<fmt:message key="common.issueDate.label" var="senddate"
					bundle="${v3xCommonI18N}" />
				<td width="8%" height="26" class="bg-gray">${subject}:</td>
				<td width="20%"><input name="surveyname" type="text"
					maxlength="50" id="surveyname" class="input-100per"
					deaultValue="${dfSubject}" inputName="${subject}"
					validate="isDeaultValue,notNull"
					value="<c:out value='${tem.inquirySurveybasic.surveyName}' default='${dfSubject}' escapeXml='true' />"
					onfocus='checkDefSubject(this, true)'
					onblur="checkDefSubject(this, false)"></td>
				<td width="8%" nowrap="nowrap" height="24" class="bg-gray"><fmt:message
					key="inquiry.category.label" />:</td>
				<td width="20%" nowrap="nowrap"><input type="hidden"
					name="cname"> <select class="input-100per"
					name="surveytype_id">
					<c:forEach items="${surveytype}" var="cat">
						<option value="${cat.id}"
							<c:if test="${typeId == cat.id}">selected</c:if>>${cat.typeName}</option>
					</c:forEach>
				</select> <input type="hidden" name="surveytypeid"
					value="${param.surveytypeid}"> <input type="hidden"
					name="update" value="${param.update}"> <input type="hidden"
					name="typeName" value="${typeName}"></td>
				<td width="8%" nowrap="nowrap" class="bg-gray">${senddate}:</td>
				<td width="20%"><input class="input-100per" type="text"
					name="send_date"
					value="<c:out value='${sendtime}' default='${dfsendtime}'/>"
					deaultValue="${dfsendtime}"
					inputName="${senddate}"
					onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"
					readonly /></td>
				<td width="8%" class="bg-gray"><fmt:message
					key="inquiry.send.mode.label" />:</td>
				<td><label for="censordesc"><input type="radio" id="censordesc" name="cryptonym" value="0"
					<c:if test="${tem.inquirySurveybasic.cryptonym =='0'|| tem.inquirySurveybasic.cryptonym == null}"> checked</c:if> />
				<fmt:message key="inquiry.real.name.label" /></label></td>
			</tr>
			<tr class="bg-summary">
				<td class="bg-gray"><fmt:message key="common.issueScope.label"
					bundle="${v3xCommonI18N}" />:</td>
				<td><input class="input-100per" type="text" name="obj" id="obj"
					value="<c:out value='${scope_name}' default='${defaultSP}'/>"
					onclick="selectPeopleFun_back()" readonly
					deaultValue='${defaultSP}'
					inputName="<fmt:message key='common.issueScope.label' bundle='${v3xCommonI18N}'/>"
					validate="isDeaultValue,notNull"
					onfocus='checkDefSubject(this, true)'
					onblur="checkDefSubject(this, false)" /> <input type="hidden"
					id="scope_id" name="scope_id" value="${scope_range}" /></td>
				<td class="bg-gray"><fmt:message
					key="inquiry.send.department.label" />:</td>
				<td><c:set var="department_name" value="${department.name}"></c:set>
				<c:if test="${tem.deparmentName.id!=null}">
					<c:set var="department_name" value="${tem.deparmentName.name}"></c:set>
				</c:if> <input class="input-100per" type="text" id="deptname"
					name="deptname" value="${department_name}"
					onclick="selectPeopleFun_per()" readonly /> <input type="hidden"
					name="department_id" value="${tem.deparmentName.id}"></td>
				<fmt:formatDate value='${tem.inquirySurveybasic.closeDate}'
					pattern='yyyy-MM-dd HH:mm' var="closetime" />
				<fmt:message key="inquiry.select.closeDate.label" var="dfclosetime" />
				<td nowrap="nowrap" class="bg-gray"><fmt:message
					key="inquiry.close.time.label" />:</td>
				<td>
				<c:if test="${con.inquirySurveybasic.closeDate > '3000-01-01 00:00:00'}">
				sssssssssssssssssssss
	                <c:set value="${dfclosetime}" var="closetime"></c:set>
			    </c:if>
				
				<input class="input-100per" type="text" name="close_date"
					value="<c:out value='${closetime}' default='${dfclosetime}'/>"
					deaultValue="${dfclosetime}" 
					inputName="<fmt:message key='inquiry.close.time.label' />"
					onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"
					readonly /></td>
				<td></td>
				<td><label for="cryptonym"><input type="radio" id="cryptonym" name="cryptonym" value="1"
					<c:if test="${tem.inquirySurveybasic.cryptonym =='1'}"> checked</c:if> />
				<fmt:message key="inquiry.anonymity.label" /></label></td>
			</tr>
			<tr id="attachmentTR" class="bg-summary" style="display:none;">
				<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message
					key="common.attachment.label" bundle="${v3xCommonI18N}" />:&nbsp;
				</td>
				<td colspan="8" valign="top">
				<div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
				<v3x:fileUpload attachments="${attachments}"
					originalAttsNeedClone="true" /></td>
			</tr>
			<tr height="1%" class="bg-summary">
				<td colspan="9">
				<hr width="98%">
				</td>
			</tr>
			<tr valign="top" class="bg-summary">
				<td colspan="8">
				<table width="100%" border="0" cellspacing="0" cellpadding="5">
					<tr>
						<td valign="top" width="8%" align="right"><fmt:message
							key="inquiry.add.desc.label" />:</td>
						<td colspan="2" align="center"><textarea name="surveydesc"
							class="input-100per" cols="130" rows="6">${tem.inquirySurveybasic.surveydesc}</textarea>
						</td>
						<td width="2%"></td>
					</tr>
					<tr>
						<td valign="top" width="9%" align="right"><fmt:message
							key="inquiry.add.question.label" />:</td>
						<td>
						<table width="100%" height="20%" border="0" cellpadding="0"
							cellspacing="0" class="bg-summary">
							<tr>
								<td align="left" valign="top" width="50%">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="17%" align="left"><input type="button"
											name="Submit34" class="button-default-2"
											value="<fmt:message key='inquiry.add.label' />"
											onclick="addProject()" /></td>
										<td align="left"><input type="button" name="Submit33"
											class="button-default-2"
											value="<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' /> "
											onclick="deleteProject()" /></td>
										<td align="left">&nbsp;</td>
										<td align="left">&nbsp;</td>
										<td width="5%" align="right"><img name="Submit32"
											src="<c:url value="/apps_res/inquiry/images/px1.gif"/>"
											onclick="upProject()"></td>
										<td width="5%" align="right"><img name="Submit3"
											src="<c:url value="/apps_res/inquiry/images/px2.gif"/>"
											onclick="downProject()"></td>
									</tr>
									<tr>
										<td colspan="6" align="center"><select name="projectBox"
											size="7" style="width:100%"
											onclick="objQuestion(this.selectedIndex)"></select></td>
									</tr>
									<tr>
										<td colspan="6" align="left" id="memo" valign="top">&nbsp;
										<li><fmt:message key='inquiry.option.desca.label' /></li>
										<li><fmt:message key='inquiry.option.descb.label' /></li>
										<li><fmt:message key='inquiry.option.descc.label' /></li>
										<li><fmt:message key='inquiry.option.descd.label' /></li>
										<li><fmt:message key='inquiry.option.desce.label' /></li>
										<li><fmt:message key='inquiry.option.descf.label' /></li>
										</td>
									</tr>
								</table>
								</td>

								<td align="left" valign="top" rowspan="10">
								<table width="100%" border="0" cellspacing="2"
									id="addProjectBox" cellpadding="0" style="display:none;">
									<tr>
										<td width="26%" align="right"><fmt:message
											key='inquiry.question.name.label' />:&nbsp;&nbsp;</td>
										<td><input class="input-300px" type="text" name="title"
											onchange="oneQuestion()" readonly="readonly" /></td>
									</tr>
									<tr>
										<td align="right"><fmt:message
											key='common.description.label' bundle='${v3xCommonI18N}' />:&nbsp;&nbsp;</td>
										<td><input class="input-300px" type="text" name="desc"
											onchange="oneQuestion()" maxlength="50" /></td>
									</tr>
									<tr>
										<td align="right"><fmt:message
											key='inquiry.select.mode.label' />:&nbsp;&nbsp;</td>
										<td><label for="single"><input type="radio" name="singleOrMany" checked
											id="single" onclick="setRadioValue(1)" /> <fmt:message
											key='inquiry.select.single.label' /></label><label for="many"> <input type="radio"
											name="singleOrMany" id="many" onclick="setRadioValue(1)" />
										<fmt:message key='inquiry.select.many.label' /></label> <input
											type="hidden" name="hsom" value="0"></td>
									</tr>
									<tr id="selectMaxTag" style="display:none">
										<td align="right"><fmt:message
											key='inquiry.select.max.label' />:&nbsp;&nbsp;</td>
										<td><input id="maxselectnum" name='smaxselectnum'
											type='text' size='2' maxlength='4' value='0'
											onchange="oneQuestion()" onfocus="this.value=''"
											onblur="if(this.value==''){this.value='0'}"
											onkeyup="return is_ht_number(this);" /> <font color="red">(<fmt:message
											key='inquiry.notice.label' />)</font></td>
									</tr>
									<tr>
										<td align="right"><fmt:message
											key='inquiry.question.addItem.label' />:&nbsp;&nbsp;</td>
										<td><input type="button" class="button-default-2"
											value="<fmt:message key='inquiry.add.label' />"
											onclick="addSubject()" />
											<label for="otherItem">
											<input type="checkbox" id="otherItem" name="otherItem" value="1"
											onclick="setRadioValue(2)" /> <fmt:message
											key='inquiry.question.otherItem.label' />
											</label>
										   <label for="discuss">
										  <input type="checkbox" id="discuss" name="discuss" value="1"
											onclick="setRadioValue(3)" /> <fmt:message
											key='inquiry.question.review.label' /></label></td>
									</tr>
									<tr>
										<td colspan="2" align="center">
										     <table id="subjectBox">
										
										     </table>
										</td>
										<td></td>
									</tr>
								</table>
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td id="tableForm"></td>
			</tr>
		</table>
<input type="hidden" name="tem" value="">
<input type="hidden" name="bsid" value="${delete}">
</form>
<iframe name="submitIframe" width="0" height="0"></iframe>
</body>
</html>
