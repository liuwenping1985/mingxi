<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html style="height:100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${v3x:toHTML(sbcompose.inquirySurveybasic.surveyName)}</title>
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/skin/default/skin.css${v3x:resSuffix()}" />">
<style>
<!--
#discussul{
    list-style: none;
    margin:0 0 0 18px;
    font-weight:bold;
}
#discussul li{
    margin:5px 0 5px 20px;
    font-weight:normal;
    color:#000000;
    list-style:none;
}
// -->
</style>
<script type="text/javascript">
<!--
var acount = new ArrayList();
//parent.document.title = "${v3x:toHTML(sbcompose.inquirySurveybasic.surveyName)}";
function clickCount(chl,name,maxCount,id){
   var names= name +"items";
   var count =validateCheckbox(names);
   if(maxCount!=0 && count>maxCount){
     chl.checked =  false;
     alert(v3x.getMessage("InquiryLang.inquiry_out_most_alert"));
     return false;
   }
}

function otherClickCount(chl,name,maxCount,id){
    var names = name + "items";
    var count =validateCheckbox(names);
    if(maxCount!=0 && count>maxCount){
     chl.checked =  false;
     alert(v3x.getMessage("InquiryLang.inquiry_out_most_alert"));
     return false;
    }
    var otherItem = document.getElementById(name+"content");
    if(chl.checked){
        otherItem.disabled = false;
    }else{
        otherItem.value = "";
        otherItem.disabled = true;
    }
}

function voteSubmit(count){
    if(!checkForm(mainForm)){
        return false;
    }            
    if(count ==0){
        return false;
    }
    var votecount = 0;     
    for(var c =0;c<count;c++) {           
           var items = document.getElementsByName(c+'items');
           //判断用户是否处理了当前问题项 modified by Meng Yang at 2009-06-12
           //选中某一项、未选中某一项但有评论、选中某一项兼评论、选中其他项且有内容4种情况表明用户处理了
           var isHandledByUser = false;
           for(var icount = 0; icount<items.length; icount++) {
                 if(items[icount].checked) {
                    isHandledByUser = true;
                 }
           }
           try {
                var otherItems  = document.getElementById("other"+c+"items");
                if(otherItems.checked){
                      var othercontent = document.getElementsByName(c+"content");
                      if(othercontent[0].value.trim() ==""){
                           alert(v3x.getMessage("InquiryLang.inquiry_enter_something_alert")+(c+1)+v3x.getMessage("InquiryLang.inquiry_enter_question_other_alert"));
                           othercontent[0].value = "";
                           othercontent[0].focus();
                           return false;
                      }     
                      isHandledByUser = true; 
                }
            }catch(e){
                    
            }
            var diss  = document.getElementById(c+"disscus");
            if(diss!=null&&diss.value!="") {
                isHandledByUser = true;
            }
         
            if(isHandledByUser) {
                votecount++;
            }
     }
     if(votecount<count){
            alert("共有" + count + "项问题,您只处理了" + votecount + "项\n\n" + "请处理完问题,谢谢配合\n");
     } else{
            document.getElementById("submitButton").disabled=true;
            mainForm.submit();
            var result = document.getElementById("B1")
            var allowViewResult = document.getElementById("allowViewResult").value
            //工作桌面快速处理刷新 这个方法不管是首页消息还是工作桌面点击打开都能调用？
            try{
                if (window.top.opener.getCtpTop && window.top.opener.getCtpTop().refreshDeskTopPendingList) {
                    window.top.opener.getCtpTop().refreshDeskTopPendingList();
                 }
            }catch(e){
            	
            }
            if (!result && allowViewResult != "true") {
            //如果返回为空的时候刷新代办栏目
               try{
                   if(getA8Top().dialogArguments){
                       getA8Top().dialogArguments.main.sectionHandler.reload("pendingSection",true);
                   }else{
                       getA8Top().opener.main.sectionHandler.reload("pendingSection",true);
                   }
               }catch(e){
               }
            } else {
            	//因为调查处理完之后不会直接关闭页面，所以在处理完的时候就刷新下代办
            	try{
                    if(getA8Top().dialogArguments){
                        getA8Top().dialogArguments.main.sectionHandler.reload("pendingSection",true);
                    }else{
                        getA8Top().opener.main.sectionHandler.reload("pendingSection",true);
                    }
                }catch(e){
                }
            }
     }
}

function showResult(){
    location.replace("${basicURL}?method=survey_result&tid=${tid}&bid=${bid}&manager_ID=${manager_ID}&listFlag=${listShow}&fromPigeonhole=${param.fromPigeonhole}&fromReminded=${fromReminded}&userId=${userId}&openFrom=${param.openFrom}");
}

//加上一个标志.判断是从消息框架传进来的
function sendInquriy(){
	if(getA8Top() && getA8Top().startProc) getA8Top().startProc();
	var id= '${sbcompose.inquirySurveybasic.id}';
     var requestCaller = new XMLHttpRequestCaller(this, "ajaxInquiryManager", "validateInquiryExist", false);
	  requestCaller.addParameter(1, "Long", id);
	  var ds = requestCaller.serviceRequest();

 	if(ds==8){
 	 	alert(_("InquiryLang.inquiry_has_send"));
 	 	getA8Top().reFlesh();
	 	return false;
	}
 	
    if('${param.alauditFlag}'=='0')
    {
        window.location.href = '${basicURL}?method=creator_public&surveytypeid=${tid}&id=${sbcompose.inquirySurveybasic.id}&group=${group}';
        window.close();
    }else
    {
        parent.parent.listFrame.location.href = '${basicURL}?method=creator_public&surveytypeid=${tid}&id=${sbcompose.inquirySurveybasic.id}&group=${group}';
        var parentObj = top.window.dialogArguments;
        if(parentObj){
            window.close();
        }
    }
}

function openInquiry() {
	getA8Top().openInquiryWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${basicURL}?method=openInquriy&bid=${param.bid}&id=${tid}",
        width: 380,
        height: 200,
        isDrag:false
    });
}

function openInquiryCollBack (returnValue) {
	getA8Top().openInquiryWin.close();
	 if(returnValue){
	       try{
	           var op = parent.opener;
	           if(typeof(op) != "undefined" && op != null){
	               op.location.href=op.location;
	           } else if (typeof(parent.parent.listFrame.location.href) != "undefined") {
	               parent.parent.listFrame.location.href = parent.parent.listFrame.location.href;
	           }
	       }catch(e){window.location.reload();}
	       parent.window.close();
	}
}
/**
 * 投票数字的穿透弹出页面方法
 */
function openWindowForVoteData(flag){
	//半匿名的判断
	var semiAnonymous = ${sbcompose.inquirySurveybasic.cryptonym == 1 && sbcompose.inquirySurveybasic.showVoters == true};
	getA8Top().openWindowForVoteDataWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${basicURL}?method=survey_listVoteDataFrame&bid=${param.bid}&flag="+flag+"&semiAnonymous="+semiAnonymous,
        width: 680,
        height: 380,
        isDrag:false
    });
}

window.onbeforeunload = function() {
    try {
        removeCtpWindow("${bid}",2);
    } catch (e) {
    }
}
//-->
</script>
<script>showAttachment('<c:out value="${param.bid}" />', 0, '', '');</script>
</head>
<body style="height:100%;"  onLoad="reSizeLoad()" onResize="reSizeLoad()">
<form id="mainForm" name="mainForm" action="${basicURL}?method=user_vote&tid=${tid}&openFrom=${param.openFrom}" method="post">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
    <c:choose>
    <c:when test="${listShow==false}">
    <tr>
        <td width="100%" height="60" valign="top">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="page2-header-line-old" >
                <tr>
                    <td width="80" height="60"><span class="inquiry_img"></span></td>
                    <td class="page2-header-bg-old" width="380"><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></td>
                    <td>&nbsp;</td>
                    <td class="page2-header-line-old padding-right" align="right"></td>
                </tr>
            </table>
        </td>
    </tr>
    </c:when>
    <c:otherwise>
    <tr>
        <td>
            <script type="text/javascript">
            	var isDetailPageBreak = "${param.fromPigeonhole ne 'true'}";
            	if("true" == isDetailPageBreak){
            		getDetailPageBreak();
            	}
            </script>
        </td>
    </tr>
    </c:otherwise>
    </c:choose>
    <tr>
        <td height="100%" valign="top">
            <div class="scrollList" id="scrollListDiv" style="overflow-x:hidden;">
                <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td colspan="3" height="100%"  valign="top"><a name="top" id="top"></a>     
                            <table width="100%"  height="100%" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="25%" height="100%" class="tbCell6 , bbs-bg , left-con" valign="top">
                                        <table width="100%" border="0" align="left" valign="top">
                                            <tr>
                                                <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.subject.label" />:</td>
                                            </tr>
                                            <tr>
                                               <td  width="2%">&nbsp;</td>
                                               <td  width="98%"><c:out value="${sbcompose.inquirySurveybasic.surveyName}" /></td>
                                            </tr>
                                            <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr> 
                                            <tr>
                                                <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
                                            </tr>
                                            <tr>
                                               <td  width="2%">&nbsp;</td>
                                               <td  width="98%"><c:out value="${v3x:showOrgEntitiesOfIds(sbcompose.inquirySurveybasic.createrId, 'Member', pageContext)}" /></td>
                                            </tr>
                                               <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr>                         
                                            <tr>
                                                <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
                                            </tr>
                                            <tr>
                                               <td  width="2%">&nbsp;</td>
                                                <td  width="98%"><c:out value="${sbcompose.deparmentName.name}" /> </td>
                                            </tr>
                                            
                                            <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                            </tr>
                                            <tr>
                                                <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
                                            </tr>
                                            <tr>
                                               <td  width="2%">&nbsp;</td>
                                               <td  width="98%"><c:out value="${sbcompose.inquirySurveybasic.inquirySurveytype.typeName}" /></td>
                                            </tr>
                                            <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                            </tr>
                                            <tr>
                                                <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
                                            </tr>
                                            <tr>
                                              <td  width="2%">&nbsp;</td>
                                               <td  colspan="2"><fmt:formatDate value="${sbcompose.inquirySurveybasic.sendDate}" pattern="${datetimePattern}" /> &nbsp;&nbsp;<fmt:message key="inquiry.to.label" /> </td>   
                                            </tr>
                                            <tr>
                                               <td  width="2%">&nbsp;</td>
                                               <td  colspan="2">
                                                  <c:choose>
                                                       <c:when test="${sbcompose.inquirySurveybasic.closeDate eq null}">
                                                                 <fmt:message key="inquiry.no.limit" />
                                                       </c:when>
                                                      <c:otherwise>
                                                             <fmt:formatDate value="${sbcompose.inquirySurveybasic.closeDate}"  pattern="${datetimePattern}" />
                                                     </c:otherwise>
                                                   </c:choose>
                                                </td>   
                                            </tr>
                                            <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                            </tr>
                                            <c:if test="${sbcompose.inquirySurveybasic.censorId != null}">
                                               <tr>
                                                   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.auditor.label" />:</td>
                                               </tr>
                                               <tr>
                                                    <td  width="2%">&nbsp;</td>
                                                    <td colspan="2"><c:out value="${sbcompose.conser.name}" /></td>
                                               </tr>
                                               <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr>
                                            </c:if>
                                            <tr>
                                              <tr>
                                                   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
                                               </tr>
                                                 <tr>
                                                    <td  width="2%">&nbsp;</td>
                                                    <td colspan="2"><div  style=" width:180px;overflow:hidden; text-overflow:ellipsis;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" ><nobr>${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}</nobr></div></td>
                                               </tr>
                                               <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr> 
                                               <tr>
                                                   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2">投票方式:</td>
                                               </tr>
                                                 <tr>
                                                    <td  width="2%">&nbsp;</td>
                                                    <td colspan="2">
	                                                    <div style="width:280px;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" >
				                                				<c:choose>
																	<c:when test="${sbcompose.inquirySurveybasic.cryptonym == 0}">
																		<input disabled="disabled" id="cryptonym1" type="radio" name="cryptonym" value="0" checked="checked" />
				                                						<fmt:message key="inquiry.real.name.label" />
                                                                        <br/>
                                                                        <input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                                                        <fmt:message key="inquiry.allowviewresult.foradmin.2" />
																	</c:when>
																	<c:when test="${sbcompose.inquirySurveybasic.cryptonym == 1}">
																		<input id="cryptonym2" type="radio" name="cryptonym" disabled="disabled" checked="checked"/>
                                										<fmt:message key="inquiry.anonymity.label" />
                                									    <br/>
                                										<input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                										<c:if test="${sbcompose.inquirySurveybasic.showVoters == true}">
                                											<fmt:message key="inquiry.allowviewresult.foradmin" />
                                										</c:if>
                                                                        <c:if test="${sbcompose.inquirySurveybasic.showVoters == false}">
                                                                            <fmt:message key="inquiry.allowviewresult.foradmin.1" />
                                                                        </c:if>
																	</c:when>
																</c:choose>
			                                			</div>
		                                			</td>
                                               		
                                               </tr>
                                            
                                        </table>
                                    </td>
                                    
                                    <td width="78%" valign='top' class=" top-padding" style="padding: 10px;">
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="word-break:break-all;word-wrap:break-word;">
                                            <tr>
                                                <td>
                                                    &nbsp;<font style="font-size: 16px;">${v3x:toHTML(sbcompose.inquirySurveybasic.surveydesc)}</font>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="bbs-tb-padding2" valign="top" style="word-break:break-all;word-wrap:break-word">
                                                <c:set var="itemCount" value="0" />
                                                <c:forEach items="${sbcompose.subsurveyAndICompose}" var="tname" varStatus="status">
                                                    <ul id="discussul">
                                                        <c:out value="${tname.inquirySubsurvey.sort+1}" />
                                                        .
                                                        <c:out value="${tname.inquirySubsurvey.title}" /> 
                                                        <input type="hidden" value="${tname.inquirySubsurvey.id}" name="subid">
                                                        <c:if test="${tname.inquirySubsurvey.maxSelect>'0'}">
                                                           &nbsp;&nbsp;(<fmt:message key="inquiry.select.max.label" />:${tname.inquirySubsurvey.maxSelect})
                                                        </c:if>
                                                       <br>
                                                       <c:if test="${v3x:isNotBlank(tname.inquirySubsurvey.subsurveyDesc)}">
                                                            <li>
                                                                ${v3x:toHTML(tname.inquirySubsurvey.subsurveyDesc)}
                                                            </li>
                                                        </c:if> 
                                                        <c:set var="maxSort" value="0" />
                                                        <c:set var="sOm" value="0" />
                                                        <c:set var="sortvalue" value="${tname.inquirySubsurvey.sort}" />
                                                        <c:if test="${param.survey_check == 'true' || vote!='vote' || sbcompose.inquirySurveybasic.censor!='8' || scopeFlag!='true'}">
                                                            <c:set value="disabled" var="isDisabled" />
                                                        </c:if>
                                                        <c:forEach items="${tname.items}" var="sub" varStatus="stat">
                                                            <li>
                                                            <c:if test="${tname.inquirySubsurvey.singleMany==0  && sub.content ne ''}">
                                                                    <label for="${stat.index}${status.index}id">                                                                
                                                                    <input id="${stat.index}${status.index}id" type='radio'  ${isDisabled}
                                                                     name='${tname.inquirySubsurvey.sort}items' value='${sub.id}' <c:if test="${tname.inquirySubsurvey.otheritem==0}"> onclick="clearOtherItems('${tname.inquirySubsurvey.sort}')" </c:if> 
                                                                    ${sub.curUserFlag =='true' ? 'checked' : ''}>
                                                            </c:if>
                                                            
                                                            <c:if test="${tname.inquirySubsurvey.singleMany==1  && sub.content ne ''}">
                                                                    <label for="${stat.index}${status.index}box">                                                                   
                                                                    <input id="${stat.index}${status.index}box" type='checkbox'   ${isDisabled} name='${tname.inquirySubsurvey.sort}items' value='${sub.id}'
                                                                    onClick='clickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect})' 
                                                                    ${sub.curUserFlag =='true' ? 'checked' : ''} >
                                                            </c:if>
                                                            <c:if test="${tname.inquirySubsurvey.singleMany!=2}">                                                           
                                                                <c:out value="${sub.content}" />    
                                                            </c:if>                                                     
                                                            </label>
                                                            <c:set var="maxSort" value="${sub.sort}" />
                                                            <c:set var="sOm" value="${tname.inquirySubsurvey.singleMany}" />
                                                            <c:set var="itemCount" value="${itemCount+1}" />
                                                            </li>
                                                        </c:forEach>
                                                        <c:if test="${tname.inquirySubsurvey.otheritem==0}">
                                                            <c:set var="item" value="${itemMap[tname.inquirySubsurvey.id] != null ? itemMap[tname.inquirySubsurvey.id] : ''}" />
                                                            <li>
                                                                <label for="other${sortvalue}items">
                                                                    <c:if test="${sOm==0}">                                                                 
                                                                        <input type='radio' ${isDisabled} name='${sortvalue}items' value='' id="other${sortvalue}items" onclick="enabledOtherItems(${tname.inquirySubsurvey.sort})" ${item != '' ? 'checked' : ''}>             
                                                                    </c:if> 
                                                                    <c:if test="${sOm==1}">
                
                                                                        <input type='checkbox'  name='${sortvalue}items' value='' id="other${sortvalue}items" ${isDisabled}
                                                                            onClick='otherClickCount(this,${tname.inquirySubsurvey.sort},${tname.inquirySubsurvey.maxSelect},${tname.inquirySubsurvey.id})'>
                                                                    </c:if> 
                                                                    <fmt:message key="inquiry.question.otherItem.label" />&nbsp;&nbsp; 
                                                                </label>
                                                                
                                                                    <input type="text" name="${tname.inquirySubsurvey.sort}content" ${isDisabled} id='${tname.inquirySubsurvey.sort}content' value="${item != '' ? v3x:toHTML(item.content) : ''}"  maxlength='80' disabled>                                                                        
                                                                    <input type="hidden" name="${tname.inquirySubsurvey.sort}sort" value="${maxSort + 1}">
                                                                </li>
                                                            </c:if>
                                                        <c:if test="${tname.inquirySubsurvey.discuss==0}">
	                                                        <c:forEach var="isdss" items="${tname.inquirySubsurvey.isds}" varStatus="isdsStatus">
	                                                            <c:set var="discuss" value="${isdss.discussContent}"></c:set>
	                                                        </c:forEach>
                                                            <c:set value="${tname.inquirySubsurvey.singleMany!=2 ? 'inquiry.add.review.label' : 'inquiry.pls.anwer'}" var="key" />
                                                            <li><fmt:message key="${key}" />:</li>
                                                            <c:if test="${tname.inquirySubsurvey.singleMany != 2}">
                                                                <li><textarea cols="100" rows="5"  ${isDisabled}
                                                                name="${tname.inquirySubsurvey.sort}disscus" id="${tname.inquirySubsurvey.sort}disscus"
                                                                style="border:1px solid #d8d8d8" inputName="<fmt:message key='inquiry.add.review.label' />" validate="maxLength" maxSize="1200">${discuss != '' ? discuss : ''}</textarea></li>
                                                            </c:if>
                                                            <c:if test="${tname.inquirySubsurvey.singleMany == 2}">
                                                                <li><textarea cols="100" rows="5"  ${isDisabled}
                                                                name="${tname.inquirySubsurvey.sort}disscus" id="${tname.inquirySubsurvey.sort}disscus"
                                                                style="border:1px solid #d8d8d8" inputName="<fmt:message key='inquiry.answer.context.label' />" validate="maxLength" maxSize="1200">${discuss != '' ? discuss : ''}</textarea></li>
                                                            </c:if>
                                                        </c:if>
                                                    </ul>&nbsp;
                                                    <c:set var="discuss" value=""></c:set>
                                                </c:forEach>                                                    
                                                </td>
                                            </tr>
                                            <tr>
                                              <td class="bbs-tb-padding2" valign="top" style="word-break:break-all;word-wrap:break-word">
                                              <div class="div-float attsContent" style="display: none"
                                                        id="attsDiv2${param.bid}">
                                                    <div class="atts-label"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" /> ：</div>
                                                    <v3x:attachmentDefine attachments="${attachments}" /> <script
                                                        type="text/javascript">showAttachment('${param.bid}',2, 'attsDiv2${param.bid}');</script>
                                                    </div>
                                              </td>
                                            </tr>
                                            <tr>
                                              <td class="bbs-tb-padding2" valign="top" style="word-break:break-all;word-wrap:break-word">
                                              <div class="div-float attsContent" style="display: none"
                                                        id="attsDiv${param.bid}">
                                                    <div class="atts-label"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> ：</div>
                                                    <v3x:attachmentDefine attachments="${attachments}" /> <script
                                                        type="text/javascript">showAttachment('${param.bid}', 0, 'attsDiv${param.bid}');</script>
                                                    </div>
                                              </td>
                                            </tr>
                                            <!-- 发布者可以看到审核意见   并且是设置了需要审核的 并且不是发布状态的-->
                                            <c:if test="${param.survey_check == 'true' || (sbcompose.sender.id==sessionScope['com.seeyon.current_user'].id && sbcompose.conser!=null && sbcompose.inquirySurveybasic.censor!= 8 && sbcompose.inquirySurveybasic.censor!= 3 && sbcompose.inquirySurveybasic.censor!= 5 && sbcompose.inquirySurveybasic.censor!=4  && sbcompose.inquirySurveybasic.censor!=10)}">
                                            <tr>
                                                <td>
                                                    <table border="0" height="80" cellpadding="0" cellspacing="0" width="100%" align="center" style="padding: 6px;border: 1px #a4a4a4 solid;">
                                                        <tr>
                                                            <td height="20" class="passText" nowrap="nowrap" style="border:0px;">
                                                            <b><span class="div-float"><fmt:message  key="inquiry.check.mind" />:</span></b>
                                                            <!-- 审核通过后发布者接到消息可直接发布调查 -->
                                                            <c:if test="${param.survey_check != 'true'}">
                                                            <c:if test="${ sbcompose.sender.id == sessionScope['com.seeyon.current_user'].id && sbcompose.inquirySurveybasic.censor == 2 }">
                                                                <input type="button" class="button-default-2 div-float-right" onclick="sendInquriy()" value="<fmt:message key='inquiry.publish' />">
                                                            </c:if>
                                                            </c:if>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="passText passbg pass-border-top" height="20">
                                                            <b>
                                                                <c:if test="${sbcompose.inquirySurveybasic.censor == 2}">
                                                                    <fmt:message key='inquiry.audit.pass.label' />
                                                                </c:if>
                                                                <c:if test="${sbcompose.inquirySurveybasic.censor == 8}">
                                                                    <fmt:message key='inquiry.issue.straight' />
                                                                </c:if>
                                                                <c:if test="${sbcompose.inquirySurveybasic.censor == 1}">
                                                                    <fmt:message key='audit.back' bundle='${v3xCommonI18N}'/>
                                                                </c:if>
                                                            </b>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="padding-30">
                                                                ${v3x:toHTML(sbcompose.inquirySurveybasic.checkMind)}&nbsp;
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            </c:if>
                                            
                                        </table>
                                    
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
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">  
              <tr>
                <c:if test="${param.survey_check != 'true'}">
                <c:if test="${sbcompose.inquirySurveybasic.censor==8 || sbcompose.inquirySurveybasic.censor==5}">
	                <c:choose>
						<c:when test="${fromReminded != 'fromReminded' && isSenderOrAdmin && !(sbcompose.inquirySurveybasic.cryptonym == 1 && sbcompose.inquirySurveybasic.showVoters == false)}" >
							<td class="bg-advance-bottom">
			                   	<fmt:message key="survey.join.people.link" /> 
			                    <a style="color: blue;" onclick="javascript:openWindowForVoteData('allVote');">${sbcompose.inquirySurveybasic.totals}</a>，
			                    <fmt:message key="survey.now.votes.link1"/> 
			                    <c:choose>
				                    <c:when test="${sbcompose.inquirySurveybasic.voteCount !=0}">
					                    <a style="color: blue;" onclick="javascript:openWindowForVoteData('hadVote');">${sbcompose.inquirySurveybasic.voteCount}</a>
					                    <fmt:message key="survey.now.votes.link2"/>，
				                    </c:when>
				                    <c:otherwise>
					                    <fmt:message key="survey.now.votes">
				                            <fmt:param value="${sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
				                    	</fmt:message>，
				                    </c:otherwise>
			                    </c:choose>
			                     <c:choose>
				                    	<c:when test="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount !=0}">
			                    		<a style="color: blue;" onclick="javascript:openWindowForVoteData('noVote');">${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}</a> 
			                    		<fmt:message key="survey.now.votes.notvote.link" />
			                    </c:when>
				                    <c:otherwise>
					                    <fmt:message key="survey.now.votes.notvote">
				                            <fmt:param value="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
				                    	</fmt:message>
				                    </c:otherwise>
			                    </c:choose>
		                  	</td> 
						</c:when>
						<c:otherwise>
							<td class="bg-advance-bottom">
			                   	<fmt:message key="survey.join.people">
			                    	<fmt:param value="${sbcompose.inquirySurveybasic.totals}"></fmt:param>
			                    </fmt:message>，
			                    <fmt:message key="survey.now.votes">
			                            <fmt:param value="${sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
			                    </fmt:message>，
			                    <fmt:message key="survey.now.votes.notvote">
			                            <fmt:param value="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
			                    </fmt:message>
		                  	</td> 
						</c:otherwise>
					</c:choose>
               	  </c:if>
               	  </c:if>
                  <td class="bg-advance-bottom">
                  <c:if test="${param.survey_check != 'true'}">
                  <c:if test="${vote=='vote' || sbcompose.inquirySurveybasic.censor=='8'  || sbcompose.inquirySurveybasic.censor=='5' || sbcompose.inquirySurveybasic.censor=='10'}">
                        <div align="right" valign="middle">
                         <c:if test="${vote=='vote' && sbcompose.inquirySurveybasic.censor=='8' && scopeFlag=='true'}">
                            <input type="hidden" value="${param.bid}" name="bid">
                            <input type="button" id="submitButton" class="button-default-2" onclick="voteSubmit('${sbcompose.questionsize}')" value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>" name="B3">&nbsp;&nbsp;&nbsp;
                         </c:if> 
                                                                            
                         <c:set var="currentUserId" value="${v3x:currentUser().id }" />
                         <c:if test="${(sbcompose.inquirySurveybasic.censor=='8'
                                        ||sbcompose.inquirySurveybasic.censor=='5'
                                        ||sbcompose.inquirySurveybasic.censor=='10'
                                        ) 
                                        && 
                                        (inqusurextendFlag 
                                        || currentUserId==sbcompose.inquirySurveybasic.createrId 
                                        || ((sbcompose.inquirySurveybasic.allowViewResult && vote!='vote') || (sbcompose.inquirySurveybasic.allowViewResultAhead && vote=='vote'))
                                        )}">
                             <c:if test="${notShowButton != 'true' }">
                                <input type="button" class="button-default-2"  value="<fmt:message key='inquiry.view.result.label' /> " name="B1" id="B1" onclick="showResult();">&nbsp;&nbsp;&nbsp;
                            </c:if>
                         </c:if> 
                        
                         
                         <c:if test="${vote=='vote'&& sbcompose.inquirySurveybasic.censor=='8' && scopeFlag=='true'}">
                                <input type="reset" class="button-default-2"  value="<fmt:message key='inquiry.button.reset.lable'/> " name="B2" id="B2">&nbsp;&nbsp;&nbsp;
                         </c:if>
                         
                         
                         <c:if test="${!archive}">
                             <%-- 结束调查：自己是管理员或自己是调查发起人、调查已发布未结束(从管理界面进来的--取消此判断条件) --%>
                             <c:if test="${sbcompose.inquirySurveybasic.censor!='5' && (inqusurextendFlag || currentUserId==sbcompose.inquirySurveybasic.createrId)}">
                                   <c:if test="${notShowButton != 'true' }">
                                        <input type="button" class="button-default-2" onclick="closeInquiry('${sbcompose.inquirySurveybasic.id}', '${sbcompose.inquirySurveybasic.inquirySurveytype.id}')" value="<fmt:message key='inquiry.button.endinquiry.lable'/> " name="B3" id="B3">&nbsp;&nbsp;&nbsp;
                                    </c:if>
                             </c:if>
                         </c:if>
                         <%--开启调查： 自己是管理员或自己是调查发起人--%>
                         <c:if test="${sbcompose.inquirySurveybasic.censor=='5' && (inqusurextendFlag || currentUserId==sbcompose.inquirySurveybasic.createrId)}">
                               <c:if test="${pigeonhole != 'true'}">
                                  <c:if test="${notShowButton != 'true'}">
                                  <input type="button" class="button-default-2" value="<fmt:message key='inquiry.open' />" onclick="openInquiry();"/>&nbsp;&nbsp;&nbsp;   
                                  </c:if>
                               </c:if>
                         </c:if>
                     </c:if>
                     </c:if>
                 </td>
              </tr>
           </table>
        </td>
    </tr>
</table>   
<iframe name="closeThis" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<input type="hidden" name="itemCount" value="${itemCount+n}">
<input type="hidden" name="allowViewResult" id="allowViewResult" value="${allowViewResult}">
</form>
<script type="text/javascript">
function reSizeLoad(){
    var h=document.body.clientHeight;
    var w=document.body.clientWidth;
    var isAudit = "${waitForAudit}";
    var _height = 104;
    if (isAudit == "true") {
        _height = 50;
    }
    document.getElementById("scrollListDiv").style.height=h-_height;
    document.getElementById("scrollListDiv").style.width=w;
}
</script>
</body>
</html>