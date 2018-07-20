<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<title>
<c:if test="${empty param.bid}">
<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" />
</c:if>
<c:if test="${not empty param.bid}">
<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" /><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" />
</c:if>
</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/common/css/default.css${v3x:resSuffix()}">
<link rel="stylesheet" type="text/css"
    href="apps_res/collaboration/css/collaboration.css${v3x:resSuffix()}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/skin/default/skin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/common/all-min.css">
<link rel="stylesheet" type="text/css" href="/common/all-min.css${v3x:resSuffix()}">
<link rel="stylesheet" type="text/css" href="/skin/default/skin.css${v3x:resSuffix()}">
<script type="text/javascript" src="<c:url value="/apps_res/inquiry/js/inquiry.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="<c:url value="/common/js/jquery-ui.custom.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--
    <c:if test="${group!=null&&group!=''}">
        <%-- getA8Top().showLocation(7022,"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");--%> 
        //getA8Top().contentFrame.leftFrame.showSpaceMenuLocation(23,"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />"); 
    </c:if>
    
    //不进行职务级别的筛选(工作范围限制)
    isNeedCheckLevelScope_back = false;
    <c:if test="${custom == 'true' || customSpace == 'true'}">
        var onlyLoginAccount_back = false;
    </c:if>
    <c:if test="${group == 'account'}">
        //单位空间下的发布范围不可以选择外单位
        var onlyLoginAccount_back = true;
        var onlyLoginAccount_per = true;
        hiddenOtherMemberOfTeam_back = true;
        var paramSpaceId = ${param.spaceId != null && param.spaceId != ''};
        if(paramSpaceId){
            //ignore
        }
        else if("${v3x:getSysFlagByName('sys_isGroupVer')}"=="true"){
            //TODO wanguangdong 2012-10-30
            <%-- getA8Top().showLocation(7021,"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");--%>
        }
        else{
            //TODO wanguangdong 2012-10-30
            <%--getA8Top().showLocation(712,"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />");--%>
        }
    </c:if>
var hiddenPostOfDepartment_back = true;
var nameProperties = new Properties();//全局
var CacheString=null;
var clickFlag = true;
function recordCache(){
    document.getElementById("memo").style.display="";
    document.getElementById("addProjectBox").style.display="";
    CacheString=document.getElementById("addProjectBox").innerHTML;
}
    
function addProject(){
    showProjectInfo();
    //右边的问题项信息在关闭添加问题窗口时再出现
    //document.getElementById("addProjectBox").style.display="";
}
function deleteProject(){
    var obj = document.getElementById("projectBox");
    var tmpindex=obj.selectedIndex;
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
        //如果增加的每一行都没有输入任何内容时，a为0，此时需要通过当前的行数来为增加的项添加位标 added by Meng Yang at 2009-09-09
        if(a==0) {
            a = pBox.firstChild.childNodes.length;          
        }      
        var title = document.getElementById("title").value;//获取此题目名称
        var nameList = nameProperties.get(title);
        if(nameList){
          for(var i = 0; i < nameList.size(); i ++) {
              var item1 = nameList.get(i);
              var maxA =parseInt(item1.id.split("_")[1])+1;
              if(maxA>a){  
                 a=maxA;
              }
          }
        }   
        var tr, td;
        tr = pBox.insertRow(-1); 
        tr.setAttribute('id','tr'+a);
        td = document.createElement("TD"); 
        td.setAttribute("class","padding_t_5");
        var sInputName = "<fmt:message key='inquiry.question.item.label' />";
        td.innerHTML="<input type='text' name='itemarr' value='' id='itemarr_"+a+"' inputName='"+sInputName+"' validate='notNull' onchange='oneQuestion()' onblur='checkSubjectIsNull(this)' maxlength='80'><input type=button value='<fmt:message key="common.toolbar.delete.label" bundle="${v3xCommonI18N}"/>' onclick='deleteSubject(this, "+a+")' >"; 
        tr.appendChild(td);
        document.getElementById(td.firstChild.id).focus();
   }catch(e){
        alert("Exception"+e);
   }
}

function checkSubjectIsNull(obj){
    if(obj){
        var objValue = obj.value;
        if(objValue.trim() != ""){
        	checkName(obj.id);
            /*alert(v3x.getMessage("InquiryLang.inquiry_question_is_not_null"));
            if (!v3x.isSafari && !v3x.isFirefox) {
            	obj.focus();
            }else{
            	//兼容safari解决方案
            	setTimeout(function (){obj.focus();}, 1);
            }*/
        }
    }
}

function proItem(id, title){
    this.id = id;
    this.title = title;
}

function delListValue(index){
   var title = document.getElementById("title").value;//获取此题目名称
   var items = nameProperties.get(title);//得到key值对应的value值
   if(items){
     for(var i = 0; i < items.size(); i ++) {
         var item1 = items.get(i);
         if(item1.id==("itemarr_"+index)){  
           items.removeElementAt(i);
         }
     }
   }
}
function deleteNull(){
  var items=document.getElementsByName("itemarr");
  for(var k = 0 ; k < items.length ; k ++){
       var obj=items[k];
       if(obj.value==''){
         delListValue(k);
       }
  }
  var arrapBox=document.getElementById("projectBox");
  for(var i=0;i<arrapBox.length;i ++){
    var vquestion = questions.get(i);
    if(vquestion){
      vquestion.items.remove("");
    }
  }
}

window.onbeforeunload = function() {
    try {
        removeCtpWindow(null,2);
    } catch (e) {
    }
    
    if(clickFlag) {
        return "";
    }
}

function checkName(itemarrid){
    var title = document.getElementById("title").value;//获取调查题目名称
    var itemarr = document.getElementById(itemarrid).value;//添加调查选项input框的值
    var itemarrr = itemarr.trim();
    if(itemarrr.length == 0){
        //alert(v3x.getMessage("InquiryLang.inquiry_question_is_not_null"));
        //document.getElementById(itemarrid).focus();
        return ;
   }else{
    //itemarrid 添加调查选项input框的id名称
    var item = new proItem(itemarrid, itemarrr);
    var nameList = nameProperties.get(title);
    if(nameList){
        var result = true;
        for(var i = 0; i < nameList.size(); i ++) {
            var item1 = nameList.get(i);
            if(item1.id != itemarrid){  //判断是否为当前input框
                if(item1.title == itemarrr){
                    alert(v3x.getMessage("InquiryLang.inquiry_enter_options_alert"));
                    if (!v3x.isSafari  && !v3x.isFirefox) {
                    	document.getElementById(itemarrid).focus();
                    }else{
                    	//兼容safari临时解决方案
                    	setTimeout(function (){document.getElementById(itemarrid).focus();}, 1);
                    }
                    result = false;
                    break;
                }
            }else{
              nameList.removeElementAt(i);
              nameList.add(item);
              result = false;
            }
        }
        
        if(result){
 		   var items = nameProperties.get(title);//得到key值对应的value值
 		   if(items){
 		     for(var i = 0; i < items.size(); i ++) {
 		         var item1 = items.get(i);
 		         if(item1.id==item.id){  
 		           items.removeElementAt(i);
 		         }
 		     }
 		   }
            nameList.add(item);
            nameProperties.put(title, nameList);
        }
    }else{
        nameList = new ArrayList();
        nameList.add(item);
        nameProperties.put(title, nameList);
  };
    };
}

function arraddSubject(arr){
    var arrapBox=document.getElementById("subjectBox");
    var rows = arrapBox.rows;
    //动态添加问题选项
    if(rows){
        var len = rows.length;
        for(var i=0; i<len; i++){
            rows[len-i-1].parentNode.removeChild(rows[len-i-1]);
        }
    }
    
    for(var a = 0 ; a < arr.size(); a++){
        var arrtr, arrtd;
        //arrtr = document.createElement("TR"); 
        arrtr = arrapBox.insertRow(-1);//兼容多浏览器
        arrtd = document.createElement("TD");
        var sInputName = "<fmt:message key='inquiry.question.item.label' />";
        arrtd.innerHTML="<input type=text name='itemarr' id='itemarr_"+a+"' inputName='"+sInputName+"' value='" + arr.get(a).escapeHTML() + "' onchange='oneQuestion()' onblur='checkSubjectIsNull(this)'  validate='notNull' maxlength='80'><input type=button value='<fmt:message key="common.toolbar.delete.label" bundle="${v3xCommonI18N}"/>' onclick='deleteSubject(this, "+a+")'>"; 
        arrtr.appendChild( arrtd );
        //arrapBox.firstChild.appendChild(arrtr);获取光标
    }
}
function deleteSubject(obj, index){
   delListValue(index);
   var item = document.getElementById("itemarr_" + index).value;
   var tr = obj.parentNode.parentNode;
   var tbody=tr.parentNode;
   tbody.removeChild(tr);
   var sort = mainForm.projectBox.options.selectedIndex;
   var hiddenquestion = questions.get(sort);
   hiddenquestion.items.remove(item);
}
function showProjectInfo(){
    //支持ipad
    getA8Top().showProjectInfoWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${genericController}?ViewPage=inquiry/add",
        width: 450,
        height: 200,
        isDrag:false
    });
}
function showTemplate(){
	clickFlag = false;
    //支持ipad
    if(v3x.getBrowserFlag('openWindow') == false){
        var winShowTemplate=v3x.openDialog({
                id:"showTemplate",
                title:"",
                url : "${basicURL}?method=get_templateList&id=tem&typeName=${typeName}&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}",
                width: 500,
                height: 380,
                model: true,
                buttons:[{
                    id:'btn1',
                    text: v3x.getMessage("InquiryLang.inquiry_submit"),
                    handler: function(){
                          var returnValues = winShowTemplate.getReturnValue();
                          if(returnValues){
                              var data = returnValues.split(",");
                              var temid = data[0];
                              location.href="${basicURL}?method=get_template&bid="+temid+"&surveytypeid="+'${v3x:escapeJavascript(param.surveytypeid)}&typeName=${typeName}&temp=temp&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&delete=${v3x:escapeJavascript(param.delete)}&deleteId=${param.bid}';
                              winShowTemplate.close();
                          }
                    }
                                
                    }, {
                    id:'btn2',
                    text: v3x.getMessage("InquiryLang.inquiry_cancel"),
                    handler: function(){
                       winShowTemplate.close();
                    }
                }]
            });
    } else {
    v3x.openWindow({
            url : "${basicURL}?method=templateIframe&id=tem&typeName=${typeName}&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}",
            width : "500",
            height : "380",
            resizable : "true",
            scrollbars : "true"
        });
    var temid = document.getElementById("tem").value;
    if(temid!=""){
       location.href="${basicURL}?method=get_template&bid="+temid+"&surveytypeid="+'${v3x:escapeJavascript(param.surveytypeid)}&typeName=${typeName}&temp=temp&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&delete=${v3x:escapeJavascript(param.delete)}&deleteId=${param.bid}';
    }
    }
}
function addOption( who, oCaption, oValue ){
    mainForm.hsom.value=0;
    document.getElementById("single").checked=true;
    document.getElementById("setOtherAndDiscuss").style.display = "";
    document.getElementById("subjectZoom").style.display = "";
    who = who || document.getElementById("projectBox");
    optionElement = new Option(oCaption,oValue);
    optionElement.setAttribute("title", oCaption);
    who.options.add(optionElement);
    optionElement.selected = true;
    objQuestion(who.options.selectedIndex);
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
            var singleOrMany = mainForm.hsom.value; 
            var discuss = mainForm.discuss.value;
            var otherItem = mainForm.otherItem.value;
            
            <%-- 单选 --%>
            if(mainForm.singleOrMany[0].checked) {
                mainForm.discuss.value = '1';
                mainForm.otherItem.value = "1";
                mainForm.discuss.checked = false;
                mainForm.otherItem.checked = false;
                mainForm.hsom.value=0;
                selectMax(2);
            }
            <%-- 多选 --%>
            if(mainForm.singleOrMany[1].checked){
                mainForm.discuss.value = '1';
                mainForm.otherItem.value = "1";
                mainForm.discuss.checked = false;
                mainForm.otherItem.checked = false;
                mainForm.hsom.value=1;
                selectMax(1);
            }
            <%-- 问答式 --%>
            if(mainForm.singleOrMany[2].checked){
                var itemNum = $("input[id^=itemarr_]").size();
                for(var i = 0;i<itemNum;i++){
                  var item = document.getElementById("itemarr_" + i);
                  deleteSubject(item,i);
                }
                
                mainForm.discuss.value = '0';
                mainForm.hsom.value=2;
                mainForm.discuss.checked = false;
                mainForm.otherItem.checked = false;
                mainForm.otherItem.value = "1";
                selectMax(0);
            }
    
            //alert("title=" + title + "\n" + "desc=" + desc + "\n" +  "singleOrMany=" + singleOrMany + "\n" + "otherItem=" + otherItem + "\n" + "discuss=" + discuss + "\n" + "maxSelect=" + maxSelect + "\n");
            oneQuestion();
        }
        
        if(flag ==  2){
            if(mainForm.otherItem.checked) {
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
            if(mainForm.discuss.checked) {
                mainForm.discuss.value = "0";
            }else{
                mainForm.discuss.value = "1";
            }
            //alert(mainForm.discuss.value);
            var singleOrMany = mainForm.hsom.value; 
            var otherItem = mainForm.otherItem.value;
            var discuss = mainForm.discuss.value;
            //alert(discuss+'----------单选时的验证');
            //alert("title=" + title + "\n" + "desc=" + desc + "\n" +  "singleOrMany=" + singleOrMany + "\n" + "otherItem=" + otherItem + "\n" + "discuss=" + discuss + "\n" + "maxSelect=" + maxSelect + "\n");
            oneQuestion();
        }
    }catch(e){
    }
}
<%-- 选中单选、多选或问答式时，将下方对应的区域显示或隐藏 --%>
function selectMax(obj){
    if(obj==1){  <%-- 多选 --%>
        document.getElementById("selectMaxTag").style.display = "";
        document.getElementById("setOtherAndDiscuss").style.display = "";
        document.getElementById("subjectZoom").style.display = "";
    } else if(obj==2){    <%-- 单选 --%>
        document.getElementById("selectMaxTag").style.display="none";
        document.getElementById("setOtherAndDiscuss").style.display = "";
        document.getElementById("subjectZoom").style.display = "";
        document.getElementById("maxselectnum").value="0";
    } else if(obj==0) {   <%-- 问答式 --%>
        document.getElementById("selectMaxTag").style.display="none";
        document.getElementById("setOtherAndDiscuss").style.display = "none";
        document.getElementById("subjectZoom").style.display = "none";
    }
}
function setPeopleFields(elements) {
    if(!elements){
        return;
    }
    document.getElementById("deptname").value=getNamesString(elements);
    document.getElementById("department_id").value=getIdsString(elements,false);
    //alert(document.getElementById("department_id").value);
}
function setPeopleFieldsBack(elements) {
    if(!elements){
        return;
    }
    document.getElementById("obj").value=getNamesString(elements);
    document.getElementById("scope_id").value=getIdsString(elements,true);
}
function viewPage(flag){
    clickFlag = false;
    //deleteNull();
    var ids = document.getElementById("surveytype_id").value;
    var bsids = document.getElementById("bsid").value;
    var oldId = document.getElementById("oldId").value;
    document.all.surveyname.value = document.all.surveyname.value.trim();
    
    if(!checkForm(document.mainForm)){
        return false;
    }
    //对问题的选项进行检查
    if(!questionCheck()) {
        return false;
    }
    
    clearDefaultValueWhenSubmit(mainForm.close_date);
    var nowDate = new Date();
    var nowTime = nowDate.format("yyyy-MM-dd HH:mm").toString();
    if(mainForm.close_date.value != "" && nowTime >= mainForm.close_date.value){
        alert(v3x.getMessage("InquiryLang.enddate_should_late_than_now"));
        return false;
    }
    
    //判断该名称调查是否存在
    var typeId = document.all.surveytype_id.value;
    var inquirySubject = document.all.surveyname.value;
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "isInquiryExist", false);
        requestCaller.addParameter(1, "String", inquirySubject);
        requestCaller.addParameter(2, "Long", typeId);
        var ds = requestCaller.serviceRequest();
    }catch (ex1) {
        alert("Exception : " + ex1);
    }
    if(flag == 1){
        //检查此类型审核员是否可用
        try {
            var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "isInquiryCheckerEnabled", false);
            requestCaller1.addParameter(1, "Long", typeId);
            var result = requestCaller1.serviceRequest();
        }catch (ex2) {
            alert("Exception : " + ex2);
        }
        
        if(result=='false'){
            alert(v3x.getMessage("InquiryLang.inquiry_checker_enabled_please_reset"));
            return ;
        }
        
        mainForm.action="${basicURL}?method=user_create&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&bid=${bid}";
        mainForm.target = "_self";
        if(ds == 'false'){
            if(confirm(v3x.getMessage("InquiryLang.inquiry_exist"))){
                questions2Input();
            }else{
                document.all.surveyname.focus();
                return;
            }
        }else{
            questions2Input();
        }
    }
    //调查预览
    if(flag == 0){
        v3x.openWindow({
            url :"${genericController}?ViewPage=inquiry/preview",
            workSpaceRight : "yes",
            scrollbars: false,
            resizable : "false",
            dialogType : "open"
        });
    }
    if(flag == 2){
        mainForm.action="${basicURL}?method=user_create&censor=censor&oldId="+oldId+"&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&bid=${bid}";
        mainForm.target = "_self";
        if(ds == 'false'){
            if(confirm(v3x.getMessage("InquiryLang.inquiry_exist"))){
                questions2Input();
            }else{
                document.all.surveyname.focus();
                return;
            }
        }else{
            questions2Input();
        }
    }
    if(flag == 3){
        mainForm.action="${basicURL}?method=user_create&temp=temp&oldId="+oldId+"&nosave=nosave&group=${group}&custom=${custom}&spaceType=${v3x:escapeJavascript(param.spaceType)}&spaceId=${param.spaceId}&bid=${bid}";
        mainForm.target = "submitIframe";
        questions2Input();
    }
}
function initTemplete(){
  var nameList = new ArrayList();
<c:if test="${group == 'account'}">
    var onlyLoginAccount_back = true;
    var onlyLoginAccount_per = true;
</c:if>
    <c:set var="sort" value="0" />
    <c:forEach items="${tem.subsurveyAndICompose}" var="question">
    	var nameList = new ArrayList();
        var items_${sort} = new ArrayList();
        <c:set var="childsort" value="0" />
        <c:forEach items="${question.items}" var="item">
            <c:if test="${item.content ne '' && item.otherOption eq 0 }">
                items_${sort}.add("${v3x:escapeJavascript(item.content)}");
                var item = new proItem("itemarr_"+"${childsort}", "${v3x:escapeJavascript(item.content)}");
                nameList.add(item);
                <c:set var="childsort" value="${childsort + 1}" />
            </c:if>
        </c:forEach>
        <c:set var="q" value="${question.inquirySubsurvey}"/>   
        var question_${sort} = new Question("${v3x:escapeJavascript(q.title)}", "${v3x:escapeJavascript(q.subsurveyDesc)}", "${q.singleMany}", "${q.otheritem}", "${q.discuss}", "${q.maxSelect}", items_${sort});
        questions.put("${sort}", question_${sort});
        addOption(null, question_${sort}.title, "");
        nameProperties.put(question_${sort}.title, nameList);
        <c:set var="sort" value="${sort + 1}" />
    </c:forEach>
    //alert(mainForm.surveytypeid.value);
}

//对所有的问题选项进行检查
function questionCheck() {
    var projectQues = document.getElementById('projectBox');
    var surveydesc = document.getElementById('surveydesc');
    if(surveydesc.value.length>800){
      alert("调查描述不能超过800字.");
      return false;
    }
    //拿到问题描述文本域的最大值
    var maxSize = document.getElementById('desc').maxSize;
    //因为取到的最大值是字符串,需要转换成整形
    var maxLength = parseInt(maxSize,10);
    //拿到问题的最大项数
    for(i=0;i<projectQues.length;i++) {
        var vquestion = questions.get(i);
        //window.alert(vquestion.items+"=========");
        if(vquestion.desc.length > maxLength){
            alert(v3x.getMessage("V3XLang.formValidate_maxLength", vquestion.title, maxLength, vquestion.desc.length));
            return false;
        }
        //多选时,问题的最多选项数不能大于实际问题数.
        if(vquestion.singleOrMany=="1" && vquestion.maxSelect>vquestion.items.size()) {
            alert(v3x.getMessage("V3XLang.inquiry_question_max_size", vquestion.title));
            return false;
        }
        //alert(vquestion.discuss+'============提交时的验证');
        //对问题选项的个数进行验证
        //window.alert(vquestion.title+"最大选项数为:--"+vquestion.maxSelect+"======"+vquestion.singleOrMany);
        if(vquestion.items.size()<2 && vquestion.discuss == "1") {
            alert(v3x.getMessage("V3XLang.inquiry_question_key_size", vquestion.title));
            return false;
        }
    }
    return true;
}
//先进解锁
function unlock(id) {
    //进行解锁
    try {
        var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "unlock", false);
        requestCaller.addParameter(1, "Long", id);
        <%-- 如果用户直接点击退出或关闭IE，此时解锁无法进行，形成死锁 --%>
        requestCaller.needCheckLogin = false;
        var ds = requestCaller.serviceRequest();
    }
    catch (ex1) {
        alert("Exception : " + ex1);
    }
}
function onChangeName(obj){
       var box = document.getElementById("projectBox");
       var sort = mainForm.projectBox.options.selectedIndex;
       var old = questions.get(sort);
       for(i=0;i<box.length;i++){
          if(!box.options[i].selected && box.options[i].text==obj.value){
             alert(v3x.getMessage("InquiryLang.inquiry_tautonymy_alert"));
             document.getElementById("title").value=old.title;
             return false;
          }
       }
        oneQuestion();
}
//-->
</script>
<c:if test="${tem.deparmentName != null}">
    <c:set var="dep_id" value="${v3x:parseElementsOfIds(tem.deparmentName.id, 'Department')}"></c:set>
    <c:set value="${v3x:currentUser().departmentId}" var="currentDepartmentId"/>
    <c:set value="${v3x:parseElementsOfIds(currentDepartmentId, 'Department')}" var="defauDepar"/>
</c:if>

<v3x:selectPeople id="per" panels="Department" maxSize="1" selectType="Department" originalElements="${dep_id}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />

<c:set value="${v3x:parseElements(tem.entity,'id','entityType')}" var="managers" />
<c:set value="${v3x:showOrgEntitiesOfTypeAndId(scope_range, pageContext)}" var="default_scope_names" />
<c:set value="${v3x:parseElementsOfTypeAndId(scope_range)}" var="scope_Names" />
    <c:if test="${custom == 'true'}">
        <script type="text/javascript">
                <!--
                var includeElements_back = "${v3x:parseElementsOfTypeAndId(scope_range)}";
                //-->
        </script>
    </c:if>
     <c:if test="${spaceType=='17'}">
        <script type="text/javascript">
                <!--
                var includeElements_back = "${v3x:parseElementsOfTypeAndId(scope_range)}";
                //-->
            </script>
    </c:if>
    <c:choose>
        <c:when test="${(group==null||group==''||group=='account')&&spaceType!='18'&&spaceType!='17'&&custom!=true}">
             <script type="text/javascript">
		        <!--
		        var includeElements_back = "${v3x:parseElementsOfTypeAndId(entity)}";
		        //-->
		    </script>
            <v3x:selectPeople id="back" panels="Department,Post,Level,Team,Outworker" selectType="Member,Department,Team,Post,Level,Account" originalElements="${scope_Names}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsBack(elements)" />
        </c:when>
        <c:otherwise>
           <v3x:selectPeople id="back" showAllAccount="true" panels="Account,Department,Post,Level,Team,Outworker" selectType="Member,Department,Team,Post,Level,Account" originalElements="${scope_Names}" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsBack(elements)" /> 
           </c:otherwise>
    </c:choose>
<script type="text/javascript">
<!--
	if('18'=='${v3x:escapeJavascript(spaceType)}'||'17'=='${v3x:escapeJavascript(spaceType)}'||'4'=='${v3x:escapeJavascript(spaceType)}'||'${custom}' == 'true')
    	showAllOuterDepartment_back = false;
	else
		showAllOuterDepartment_back = true;
//-->
</script>
</head>

<body onload="initTemplete()" onunload="unlock('${tem.inquirySurveybasic.id}')" class="bg-summary">

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-right: 1px #a4a4a4 solid;">
    <tr>
        <td valign="top" height="100%">

            <table width="100%" border="0" cellspacing="0" cellpadding="0" >
                <tr>
                    <td height="25" class="webfx-menu-bar page2-list-header padding_tb_5">
                        <script>
                        <!--
                            var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
                            //进行判断,如果是修改,将保存按钮置灰
                            if('${requestScope.editFlag}'!='true')
                            {
                                myBar.add(new WebFXMenuButton("save", "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", "viewPage(2)", [1,5], "<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}' />", null));
                            }
                            myBar.add(new WebFXMenuButton("saveAsTemp", "<fmt:message key='inquiry.save.template.label'/>", "viewPage(3)", [3,5],"<fmt:message key='inquiry.save.template.label'/>", null));
                            myBar.add(new WebFXMenuButton("<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}'/>", "<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}'/>", "showTemplate()", [3,7],"<fmt:message key='common.toolbar.templete.label' bundle='${v3xCommonI18N}'/>", null));
                            if(v3x.getBrowserFlag("hideMenu") == true){
                            var insert = new WebFXMenu;
                            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
                            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "insertCorrelationFile()"));//关联文档的入口
                            myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
                            }
                            myBar.add(new WebFXMenuButton("<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", "viewPage(0)", [7,3],"<fmt:message key='common.toolbar.preview.label' bundle='${v3xCommonI18N}'/>", null));
                            document.write(myBar);
                            //-->
                        </script>
                    </td>
                </tr>
        
        <tr>
            <td>
                <div class="hr_heng"></div>
        <!-- Edit By Lif Start -->
            <div class="scrollList">
                <form id="mainForm" name="mainForm" method="post" action="" onsubmit="return checkForm(this)">
                <input name="group" type="hidden" value="${group}">
                <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <!-- Edit End -->
                    <fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" var="subject" />
                    <fmt:message key="common.default.subject.value" bundle="${v3xCommonI18N}" var="dfSubject" />
                    <fmt:message key="common.default.selectPeople.value" var="defaultSP" bundle="${v3xCommonI18N}" />
                    <fmt:formatDate value='${tem.inquirySurveybasic.sendDate}' pattern='yyyy-MM-dd HH:mm' var="sendtime" />
                    <fmt:message key="inquiry.select.sendDate.label" var="dfsendtime" />
                    <tr class="bg-summary">
                    <fmt:message key="oper.send" var="oper_send" bundle="${bulI18N }"/>
                    <fmt:message key="oper.publish" var="oper_publish" bundle="${bulI18N }"/>
                    <td rowspan="3" width="1%" nowrap="nowrap" valign="top"><a onclick="javaScript:viewPage(1);" id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${isAduit?oper_send:oper_publish}</a></td>
                        <fmt:message key="common.issueDate.label" var="senddate"
                            bundle="${v3xCommonI18N}" />
                        <td width="1%" class="bg-gray" noWrap="noWrap">${subject}:</td>
                        <td width="25%"><input name="surveyname" type="text" maxlength="85" id="surveyname" class="input-100per"
                            deaultValue="${dfSubject}" inputName="${subject}"
                            validate="isDeaultValue,notNull,isWord"
                            value="<c:out value='${tem.inquirySurveybasic.surveyName}' default='${dfSubject}' escapeXml='true' />"
                            onfocus='checkDefSubject(this, true)'
                            onblur="checkDefSubject(this, false)"></td>
                        <td width="10%" nowrap="nowrap" height="24" class="bg-gray"><fmt:message
                            key="inquiry.category.label" />:</td>
                        <td width="10%" nowrap="nowrap">
                            <input type="hidden" name="cname">
                            <c:choose>
                                <c:when test="${custom}">
                                    <input type="hidden" id="surveytypeId" name="surveytypeId" value="${typeId}"/>
                                    <select name="surveytype_id" id="surveytype_id" class="input-100per" disabled >
                                        <option value="${typeId}" selected>${spaceName}</option>
                                    </select>
                                </c:when>
                                <c:otherwise>
                                    <input type="hidden" id="surveytypeId" name="surveytypeId" value="${v3x:toHTML(param.surveytypeid)}">
                                    <select class="input-100per" id="surveytype_id" name="surveytype_id">
                                        <c:forEach items="${surveytype}" var="cat">
                                            <option value="${cat.id}"
                                                <c:if test="${typeId == cat.id}">selected</c:if>>${v3x:toHTML(cat.typeName)}</option>
                                        </c:forEach>
                                    </select> 
                                </c:otherwise>
                            </c:choose> 
                            <input type="hidden" name="update" value="${param.update}"> <input type="hidden" name="typeName" value="${typeName}">
                        </td>
                        <!-- 
                        <td width="8%" nowrap="nowrap" class="bg-gray">${senddate}:</td>
                        <td width="16%"><input class="input-100per" type="text"
                            name="send_date"
                            value="<c:out value='${sendtime}' default='${dfsendtime}'/>"
                            deaultValue="${dfsendtime}"
                            validate="isDeaultValue,notNull"
                            inputName="${senddate}"
                            onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');"
                            readonly /></td>
                         -->
                        <td width="10%" class="bg-gray">
                            <fmt:formatDate value='${tem.inquirySurveybasic.closeDate}' pattern='yyyy-MM-dd HH:mm' var="closetime" />
                            <fmt:message key="inquiry.select.closeDate.label" var="dfclosetime" />
                            <fmt:message key="inquiry.close.time.label" />:
                        </td>
                        <td>
                            <c:if test="${tem.inquirySurveybasic.closeDate > '3000-01-01 00:00:00'}">
                                <fmt:message key="inquiry.select.closeDate.label" var="closetime" />
                            </c:if>
                            <input class="input-40per cursor-hand" type="text" name="close_date" value="<c:out value='${closetime}' default='${dfclosetime}'/>"
                                deaultValue="${dfclosetime}"
                                inputName="<fmt:message key='inquiry.close.time.label' />"
                                onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'datetime');" readonly />
                        </td>
                    </tr>
                    <tr class="bg-summary">
                        <td width="1%" class="bg-gray" noWrap="noWrap">
                            <fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:
                        </td>
                        <td>
                            <input class="input-100per cursor-hand" type="text" name="obj" id="obj" value="<c:out value='${default_scope_names}' default='${defaultSP}'/>" onclick="selectPeopleFun_back()" readonly
                                deaultValue='${defaultSP}' inputName="<fmt:message key='common.issueScope.label' bundle='${v3xCommonI18N}'/>"
                                validate="isDeaultValue,notNull" onfocus='checkDefSubject(this, true)' onblur="checkDefSubject(this, false)" /> 
                            <input type="hidden" id="scope_id" name="scope_id" value="${scope_range}" />
                        </td>
                        <td class="bg-gray">
                            <fmt:message key="inquiry.send.department.label" />:</td>
                        <td>
                            <c:set var="department_name" value="${department.name}"></c:set>
                            <c:if test="${tem.deparmentName.id!=null}">
                                <c:set var="department_name" value="${tem.deparmentName.name}"></c:set>
                            </c:if>
                            <input class="input-100per cursor-hand" type="text" id="deptname" name="deptname" value="${department_name}" onclick="selectPeopleFun_per()" readonly />
                            <input type="hidden" id="department_id" name="department_id" value="${tem.deparmentName.id}">
                        </td>
                        
                        <td class="bg-gray"><fmt:message key="inquiry.send.mode.label" />:</td>
                        <td>
                            <label for="cryptonym1">
                                <input id="cryptonym1" type="radio" name="cryptonym" onclick="javascript:showOrHideAheadSet('hidden');" value="0" ${tem.inquirySurveybasic.cryptonym == '0' ? 'checked' : ''} />
                                <fmt:message key="inquiry.real.name.label" />
                            </label>
                            <label for="cryptonym2">
                                <input id="cryptonym2" type="radio" name="cryptonym" onclick="javascript:showOrHideAheadSet('show');" value="1" ${tem.inquirySurveybasic.cryptonym == null || tem.inquirySurveybasic.cryptonym == '1' ? 'checked' : ''} />
                                <fmt:message key="inquiry.anonymity.label" />
                            </label>
                            <label id="allowAdminViewResultLabel" for="allowAdminViewResult" class="${tem.inquirySurveybasic.cryptonym == '0' ? 'hidden' : ''}">
                                <input id="allowAdminViewResult" name="allowAdminViewResult" type="checkbox" ${tem.inquirySurveybasic.showVoters ? 'checked' : ''} />
                                <fmt:message key="inquiry.allowviewresult.foradmin" />
                            </label>
                        </td>
                    </tr>
                    
                    <tr class="bg-summary">
                        <td width="1%" class="bg-gray" nowrap="nowrap"></td>
                        <td colspan="8" class="padding_b_5">
                            <div id="allow1" style="float:left;">
                                <label for="allowUserViewResult">
                                    <input id="allowUserViewResult" name="allowViewResult" type="checkbox" onclick="" <c:if test="${tem.inquirySurveybasic.allowViewResult || tem==null}">checked</c:if> />
                                    <fmt:message key="inquiry.allowviewresult.label" />
                                </label>
                            </div>
                            <div id="allow2">
                                <label for="allowUserViewResultAhead">
                                    <input id="allowUserViewResultAhead" name="allowViewResultAhead" type="checkbox" <c:if test="${tem.inquirySurveybasic.allowViewResultAhead || tem==null}">checked</c:if> />
                                    <fmt:message key="inquiry.allowviewresultahead.label" />
                                </label>
                            </div>
                        </td>
                    </tr>
                    
                    <!-- 在此处添加关联文档 -->
                        <tr id="attachment2TR"  style="display:none;">
                            <td colspan="2" valign="top"></td>
                            <td colspan="7" valign="top">
                            <div style="float: left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</div>
                            <div>
                            <div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
                            <div></div><div id="attachment2Area" style="overflow: auto;"></div></div>
                         </tr>
                    <tr id="attachmentTR" class="bg-summary" style="display:none;">
                        <td colspan="2" valign="top"></td>
                        <td colspan="7" height="18" valign="top">
                            <div style="float: left"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:&nbsp;</div>
                            <div>
                            <v3x:attachmentDefine attachments="${attachments}" />
                            <div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
                            <v3x:fileUpload attachments="${attachments}" originalAttsNeedClone="true" />
                            </div>
                        </td>
                    </tr>
                    <input type="hidden" name="loadFile" value="${attachments}">
                    <tr height="1%" class="bg-summary">
                        <td colspan="9">
                        <hr width="98%">
                        </td>
                    </tr>
                    <tr valign="top" class="bg-summary">
                        <td colspan="8" class="padding_t_5">
                        <table style="word-break:break-all;word-wrap:break-word" width="100%" border="0" cellspacing="0" cellpadding="5">
                            <tr>
                                <fmt:message key="inquiry.add.desc.label" var="descLable"/>
                                <td valign="top" width="10%" align="right">${descLable}:</td>
                                <td colspan="2" align="left"><textarea style="width: 100%" name="surveydesc" id="surveydesc" inputName="${descLable}" validate="maxLength" maxlength="800"  rows="6">${tem.inquirySurveybasic.surveydesc}</textarea>&nbsp;
                                <font color="red">
                                    (
                                        <fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
                                            <fmt:param value="800"></fmt:param>
                                        </fmt:message>
                                    )
                                </font>
                                </td>
                                <td width="2%"></td>
                            </tr>
                            <tr>
                                <td  class="padding_t_10" valign="top" width="10%" align="right">
                                    <fmt:message key="inquiry.question.name.label" />:
                                </td>
                                <td>
                                    <table width="100%" height="20%" border="0" cellpadding="0" cellspacing="0" class="bg-summary">
                                        <tr>
                                            <td  class="padding_t_5" align="left" valign="top" width="50%">
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
                                                        <td class="padding_t_5" colspan="6" align="center">
                                                            <select id="projectBox" name="projectBox" size="7" style="width:100%" onclick="objQuestion(this.selectedIndex)">
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="6" align="left" id="memo" valign="top">&nbsp;
                                                            <div class="color_gray margin_l_20">
                                                                <div class="line_height160 font_size14">
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.desca.label' /></font></p>
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.descb.label' /></font></p>
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.descc.label' /></font></p>
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.descd.label' /></font></p>
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.desce.label' /></font></p>
                                                                    <p><span class="font_size12">●</span><font color="#969696"><fmt:message key='inquiry.option.descf.label' /></font></p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
        
                                            <td align="left" valign="top" rowspan="10">
                                                <table width="100%" border="0" cellspacing="2" id="addProjectBox" cellpadding="0" style="display:none;">
                                                    <tr>
                                                        <td width="30%" align="right">
                                                            <fmt:message key='inquiry.question.name.label' />:&nbsp;&nbsp;
                                                        </td>
                                                        <td style="overflow:hidden; width:390px;" >
                                                            <input class="input-100per" maxlength="85" style="overflow:hidden; width:390px;"  size="50" type="text" id="title" name="title" onblur="onChangeName(this)" inputName="<fmt:message key='inquiry.question.name.label' />" validate="notNull" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="padding_t_10" align="right" valign="top">
                                                            <fmt:message key='common.description.label' bundle='${v3xCommonI18N}' />:&nbsp;&nbsp;</td>
                                                        <td class="padding_t_5">
                                                            <textarea rows="5" cols="80" id="desc" name="desc" class="input-100per" onchange="oneQuestion()" inputName="<fmt:message key='common.description.label' bundle='${v3xCommonI18N}' />" validate="maxLength" maxlength="300" maxSize="300"></textarea>
                                                            <font color="red">
                                                                (
                                                                    <fmt:message key='common.charactor.limit.label' bundle="${v3xCommonI18N}">
                                                                        <fmt:param value="300"></fmt:param>
                                                                    </fmt:message>
                                                                )
                                                            </font>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <fmt:message key='inquiry.select.mode.label' />:&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <label for="single">
                                                            <input type="radio" name="singleOrMany" checked="checked" id="single" onclick="setRadioValue(1)" /> 
                                                            <fmt:message key='inquiry.select.single.label' /> </label>
                                                            <label for="many">
                                                            <input type="radio" name="singleOrMany" id="many" onclick="setRadioValue(1)" />
                                                            <fmt:message key='inquiry.select.many.label' /></label>
                                                            <label for="q_and_a">
                                                            <input type="radio" name="singleOrMany" id="q_and_a" onclick="setRadioValue(1)" />
                                                            <fmt:message key='inquiry.select.qa.label' /></label>
                                                            <input type="hidden" name="hsom" value="0">
                                                        </td>
                                                    </tr>
                                                    <tr id="selectMaxTag" style="display:none">
                                                        <td align="right">
                                                            <fmt:message key='inquiry.select.max.label' />:&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input id="maxselectnum" name='smaxselectnum' type='text' size='2' maxlength='4' value='0' onchange="oneQuestion()"  onblur="return is_ht_number(this);" /> 
                                                            <font color="red">(<fmt:message key='inquiry.notice.label' />)</font>
                                                        </td>
                                                    </tr>
                                                    <tr id="setOtherAndDiscuss">
                                                        <td align="right"><fmt:message key='inquiry.question.addItem.label' />:&nbsp;&nbsp;</td>
                                                        <td class="padding_t_5"><input type="button" class="button-default-2" value="<fmt:message key='inquiry.add.label' />" onclick="addSubject()" />
                                                            <input type="checkbox" name="otherItem" id="otherItem" value="1" onclick="setRadioValue(2)" /> <label for="otherItem"><fmt:message key='inquiry.question.otherItem.label' /></label> 
                                                            <input type="checkbox" name="discuss" id="discuss" value="1" onclick="setRadioValue(3)" /> <label for="discuss"><fmt:message key='inquiry.question.review.label' /></label>
                                                        </td>
                                                    </tr>
                                                    <tr id="subjectZoom">
                                                        <td align="right"></td>
                                                        <td colspan="1">
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
                <input type="hidden" id="tem" name="tem" value="">
                <input type="hidden" id="bsid" name="bsid" value="${v3x:toHTML(delete)}">
                <input type="hidden" id="oldId" name="oldId" value="${oldId}">
                </form>
            </div>
            </td>
        </tr>
    </table>
    </td>
    </tr>
    </table>

<iframe name="submitIframe" width="0" height="0"></iframe>
</body>
</html>