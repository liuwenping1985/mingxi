<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<script type="text/javascript" src="<c:url value='/apps_res/isearch/js/isearch.js${v3x:resSuffix()}' />"></script>
<html>
<head>
<meta HTTP-EQUIV="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<c:set var="current_user_id" value="${v3x:currentUser().id}"/>
<script type="text/javascript">
showCtpLocation("F12_isearch");
<!--
    window.onload = function(){
        makeDataDumpOption();
        onChangeAppType(document.getElementById("condition"));
        <%--
        //var conditionObj = document.getElementById("condition");
        //selectUtil(conditionObj, "${cm.appKey}");     
        
        //  document.getElementById("title").value = '${cm.title}';
        //  document.getElementById("keywords").value = '${cm.keywords}';
        
        //  document.getElementById("beginDate").value = '${beginDateValue}';
        //  document.getElementById("endDate").value = '${endDateValue}';
            
        //  var typeObj = document.getElementById("docLibSelect");
        //  selectUtil(typeObj, '${cm.docLibId}');

        --%>
    }

<%-- TODO
    if(!isLeftClose())
        getA8Top().contentFrame.leftFrame.closeLeft();
    if(${search==false}){
        getA8Top().hiddenNavigationFrameset();
    }else{
        getA8Top().showLocation(1008);
    }   
--%>    
    
    var currentUserId ="${current_user_id}";
    var hasDoc = "${v3x:hasPlugin('doc')}";

//-->
function isdefault()
{
        document.getElementById("resultTr").style.display = "none";
        document.getElementById("dataIFrame").style.display = "";
    
        if((document.getElementById("fromUserId").value==''||document.getElementById("fromUserId").value==null||document.getElementById("fromUserId").value==undefined)&&(document.getElementById("toUserId").value==''||document.getElementById("toUserId").value==null||document.getElementById("toUserId").value==undefined))
        {
              document.getElementById("fromUserId").value="${current_user_id}";
        }
}
</script>
</head>
<body scroll="no">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="">

<c:if test="${search==false}">
    <%-- TR 标题  --%>
<TR class=page2-header-line><TD width="100%" height=38 class="page-list-border-LRD  " vAlign=top>
<TABLE width="100%" height="100%" border=0 cellSpacing=0 cellPadding=0>
<TBODY>
<TR class=page2-header-line>
<TD width=45 class=page2-header-img>
<DIV class=morePending></DIV></TD>
<TD class=page2-header-bg><fmt:message key="menu.tools.isearch" bundle="${v3xMainI18N}"/></TD>
<TD align=right class="page2-header-line padding-right">&nbsp;</TD></TR></TBODY></TABLE></TD></TR>
</c:if>

<%-- TR 条件 --%>
    <tr height="100">
        <td  width="100%" valign="top" height="60">
            <table width="100%" height="60" border="0" cellpadding="0" cellspacing="0" >
                <tr>
                    <td align="left" valign="top" style="padding: 5px 5px 0px 5px;">
                        <div class="portal-layout-cell border-tree" id="serachDiv" style="overflow: auto;">
                            <div class="portal-layout-cell_head">
                                <div class="portal-layout-cell_head_l"></div>
                                <div class="portal-layout-cell_head_r"></div>
                            </div>
                            <div class="portal-layout-cell-right">
                                <div class="sectionSingleTitleLine" style="background:#fafafa;">    
                                    <span class="searchSectionTitle "><fmt:message key='common.search.condition.label' bundle="${v3xCommonI18N}"/>:</span>
                                </div>
                                
                                <table border="0" cellSpacing="0" cellPadding="0" width="100%" class="portal-layout-cell-right">
    
                                    <tr>
                                        <td class="" align="center" style="padding: 5px">
                                            
                                            <form method="get" id="isearchCForm" name="isearchCForm" action="${detailURL}" target="dataIFrame" onsubmit="return dealOnSubmit(this)" style="margin: 0px">
                                            <input type="hidden" value="iSearch" name="method" />
                                            
                                            <table id="tab1" width="100%" height="100%" border="0" class="noWrap">
                                                <tr>
                                                    <td width="12%" align="right" nowrap="nowrap"><fmt:message key="common.type.label" bundle="${v3xCommonI18N}"/>:</td>
                                                    <td width="38%" nowrap="nowrap">
                                                        <input type="hidden" name="appKey" id="appKey" value="" />
                                                        <select onchange="onChangeAppType(this)" id="condition" name="condition" style="width:200px;height:24px;">
                                                            <c:forEach items="${appList}" var="appObj" varStatus="status">
                                                                <c:set value="${appObj.appEnumKey}" var="objValue" />
                                                                <c:if test="${appObj.appEnumKey == null}">
                                                                <c:set value="${appObj.appShowName}" var="objValue" />
                                                                </c:if>
                                                                
                                                                <c:set value="${appObj.appShowName}" var="objName" />
                                                                <c:if test="${appObj.appShowName == null}">
                                                                <c:set value="${v3x:getApplicationCategoryName(appObj.appEnumKey, pageContext)}" var="objName" />
                                                                </c:if>
                                                                <c:if test="${appObj.nameKey != null}">
                                                                <c:set value="${v3x:_(pageContext, appObj.nameKey)}" var="objName" />
                                                                </c:if>
                                                                
                                                                <c:if test="${status.index == 0}">
                                                                    <script type="text/javascript">
                                                                        document.getElementById("appKey").value = '${objValue}';
                                                                    </script>
                                                                </c:if>
                                                                <c:set value="${v3x:getLimitLengthString(objName, 20,'...')}" var="objNameshowName" />  
                                                                <option value="${v3x:toHTML(objValue)}" title="${v3x:toHTML(objName)}" docLibSelect='${appObj.needDocLibSelect}' hasPiged="${appObj.hasPigeonholed}"    > ${v3x:toHTML(objNameshowName)}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td width="12%" align="right" nowrap="nowrap"><fmt:message key="isearch.jsp.home.date" bundle="${isearchI18N}"/>:</td>
                                                    <td width="38%" nowrap="nowrap"><input type="text" name="beginDate" id="beginDate"  style="width:90px;float:left;"  class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
                                                       <!--  <fmt:message key="isearch.jsp.home.to" bundle="${isearchI18N}"/> -->
                                                        <span style="display:inline-block;width:20px;height:22px; line-height:22px;border-top:1px solid #d1d4db;border-bottom:1px solid #d1d4db;text-align:center;float:left;color:#333;"
                                                          readonly="readonly">-</span>
                                                        <input type="text" name="endDate" id="endDate" class="input-date" style="width:90px;float:left;"  onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly ></td>
                                                </tr>
                                                <tr>
                                                    <td align="right" nowrap="nowrap"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/>:</td>
                                                    <td nowrap="nowrap"><input type="text" name="title" id="title"  style="width:200px;height:24px;" 
                                                    validate="maxLength" maxSize="20" inputName="<fmt:message key='common.subject.label' bundle='${v3xCommonI18N}'/>" /></td>
                                                    <c:if test="${v3x:hasPlugin('doc') || v3x:hasPlugin('fk')}">
                                                    <td align="right" nowrap="nowrap"><fmt:message key="isearch.jsp.home.scope" bundle="${isearchI18N}"/>:</td>
                                                    <td nowrap="nowrap"><input type="hidden" name="docLibId" id="docLibId" value=""> 
                                                        <c:if test="${v3x:hasPlugin('doc')}">
                                                        <label for="auditOption4">
                                                            <input type="radio" id="auditOption4" value="0" checked name="pigeonholedFlag0" onclick="onChangePigFlag(this)"><fmt:message key="isearch.jsp.home.scope.pigeonholed.no" bundle="${isearchI18N}"/>
                                                        </label>
                                                        <label for="auditOption5">
                                                            <input type="radio" id="auditOption5" value="1" name="pigeonholedFlag0" onclick="onChangePigFlag(this)"><fmt:message key="isearch.jsp.home.scope.pigeonholed" bundle="${isearchI18N}"/>
                                                        </label>
                                                    
                                                        <c:set value="${v3x:currentUser().loginAccount}" var="loginAccountId" />
                                                    
                                                        <select onchange="onChangeDocLib(this)" id="docLibSelect" name="docLibSelect" disabled="disabled" >                     
                                                            <c:forEach items="${libs}" var="lib" varStatus="status">
                                                                <c:choose>
                                                                    <c:when test="${(lib.type==0 || lib.type==2) && lib.domainId!=loginAccountId }">  <!-- ${v3x:getOrgEntity('Account', vo.doclib.domainId)} -->
                                                                        <c:set value="(${v3x:getOrgEntity('Account', lib.domainId).shortName})" var="otherAccountShortName" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <c:set value="" var="otherAccountShortName" />
                                                                    </c:otherwise>
                                                                </c:choose>
                                                    
                                                                <option value="${lib.id}" title=" ${v3x:getLimitLengthString(v3x:_(pageContext, lib.name), 20,'...')}${otherAccountShortName}"  >
                                                                    ${v3x:getLimitLengthString(v3x:_(pageContext, lib.name), 20,'...')}${otherAccountShortName}
                                                                </option>
                                                        
                                                                <c:if test="${status.index == 0}">
                                                                    <script type="text/javascript">
                                                                        document.getElementById("docLibId").value = '${lib.id}';
                                                                    </script>
                                                                </c:if>
                                                                
                                                            </c:forEach>
                                                        </select>
                                                        </c:if>
                                                        <c:if test="${v3x:hasPlugin('fk')}">
                                                            <label for="auditOption6" id="dumpDataDiv">
                                                                <input type="radio" id="auditOption6" value="2" name="pigeonholedFlag0" onclick="onChangePigFlag(this)"><fmt:message key="isearch.jsp.home.scope.store" bundle="${isearchI18N}"/>
                                                            </label>
                                                        </c:if> 
                                                    </td>
                                                    </c:if>
                                                </tr>
                                                <tr>
                                                    <td align="right" nowrap="nowrap"><fmt:message key="isearch.jsp.home.sendtype" bundle="${isearchI18N}"/>:</td>
                                                    <td nowrap="nowrap">
                                                    
                                                        <v3x:selectPeople id="per" panels="Department,Team,Outworker"
                                                            selectType="Member"
                                                            departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                                                            jsFunction="otherSend(elements)"  maxSize="1" minSize="1"/>
                                                        <script type="text/javascript">
                                                            showOriginalElement_per = false;
                                                            isNeedCheckLevelScope_per = false;
                                                            var excludeElements_per =  parseElements4Exclude("${current_user_id}", "Member");
                                                            //onlyLoginAccount_per = true;
                                                            
                                                        </script>
                                            
                                                        <input type="hidden" name="currentSendType" id="currentSendType" value="send" />
                                                        
                                                        <input type="hidden" name="fromUserId" id="fromUserId" value=""/>
                                                        <input type="hidden" name="toUserId" id="toUserId" value="" />
                                           
                                                        <label for="auditOption1">
                                                            <input type="radio" id="auditOption1" value="send" name="sendType" checked onclick="onChangeSendType(this)"><fmt:message key="isearch.jsp.home.sendtype.isend" bundle="${isearchI18N}"/>
                                                        </label>
                                                        <label for="auditOption2">
                                                            <input type="radio" id="auditOption2" value="to" name="sendType" onclick="onChangeSendType(this)"><fmt:message key="isearch.jsp.home.sendtype.tome" bundle="${isearchI18N}"/>
                                                        </label>
                                                        <label for="auditOption3">
                                                            <input type="radio" id="auditOption3" value="other" name="sendType" onclick="onChangeSendType(this)">
                                                            [<span id="otherSendSpan" style="color: #1039b2;"><fmt:message key="isearch.jsp.home.sendtype.someone" bundle="${isearchI18N}"/></span>]                            
                                                            <fmt:message key="isearch.jsp.home.sendtype.tome" bundle="${isearchI18N}"/>
                                                        </label>
                                                    </td>
                                                    <c:if test="${v3x:hasPlugin('doc')}">
                                                    <td width="" align="right" id="key1"><fmt:message key="isearch.view.keywords"/>:</td>
                                                    <td width="" id="key2"><input type="text" name="keywords" id="keywords" validate="maxLength" inputName="<fmt:message key='isearch.view.keywords'/>" maxSize="60" style="width:200px;height:24px;" disabled="disabled" /></td>
                                                    </c:if>
                                                </tr>
                                                <tr>
                                                    <td align="center" colspan="4"><input style="background:#5191d1;border-radius:3px;color:#fff;border:none;"  type="submit" class="deal_btn" onmouseover="javascript:this.className='deal_btn_over'" onmouseout="javascript:this.className='deal_btn'" name="b1" id="b1" onClick="isdefault()" value="<fmt:message key="isearch.jsp.home.search" bundle="${isearchI18N}"/>"   class="button-default-2"></td>
                                                </tr>
                                            </table>
                                            </form>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                                
                            <div class="portal-layout-cell_footer">
                                <div class="portal-layout-cell_footer_l"></div>
                                <div class="portal-layout-cell_footer_r"></div>
                            </div>
                        </div>      
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
    <tr id="resultTr">
        <td height="9" style="padding: 0 5px;">
            <div class="portal-layout-cell ">   
                <div class="portal-layout-cell_head">
                    <div class="portal-layout-cell_head_l"></div>
                    <div class="portal-layout-cell_head_r"></div>
                </div>
                <div class="portal-layout-cell-right">
                    <div class="sectionSingleTitleLine border-tree" style="background:#fafafa;">    
                        <span class="searchSectionTitle "><fmt:message key="isearch.jsp.list.result" bundle="${isearchI18N}"/>:</span>
                    </div>  
                </div>
            </div>
        </td>
    </tr>
    
    <tr>
        <td style="padding:0 5px;overflow:hidden;"> 
            <iframe height="100%" name="dataIFrame" id="dataIFrame" width="100%" frameborder="0" style="display: none;"></iframe>
        </td>
    </tr>
    
</table>

<iframe height="0%" name="empty" id="empty" width="0%" frameborder="0"></iframe>

</body>
<script type="text/javascript">
var width = document.body.clientWidth-10;
document.getElementById('serachDiv').style.width = width +"px";
</script>
</html>