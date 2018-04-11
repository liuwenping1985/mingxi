<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("common.my.template")}</title>
<style type="text/css">

.div-float a{
    color: #1039B2;
    text-decoration:none;
    cursor: pointer;
}
.sorts {
    border-bottom:dotted 1px #ccc;
    font-size: 22px;
    PADDING-LEFT: 30px;
    PADDING-TOP: 10px;
    PADDING-BOTTOM: 10px;
}
a {
    font-size: 12px;
    cursor: pointer;
    color: #000;
    text-decoration: none;
}
body{
    margin-left: 0px;
    margin-top: 12px;
}
.companyCheck{
		width:194px;
		height:23px;
		border:1px solid #dae3ea;
		border-radius:3px;
		line-height: 23px;
		color: #999;
		padding-left:10px;
		font-size: 12px;
		position: relative;
	}
	.changeBtn{
		border:1px solid #dae3ea;
		height: 23px;
		line-height: 23px;
		list-style: none;
		width:69px;
		border-radius: 5px;
		display: inline-block;
		margin-left: 26px;
		z-index: 4;
		position: relative;
		background: #fff;
	}
	.treeBtn{
		width:34px;
		line-height: 23px;
		height:23px;
		position: relative;
		cursor: pointer;
		border-right: 1px solid #dae3ea;
		border-radius: 4px 0 0 5px;
	}
	.leftBtn {
		width:34px;
		line-height: 23px;
		height:23px;
		position: relative;
		cursor: pointer;
		border-radius: 0 4px   4px 0;
	}
	.selectBtn {
		background: #8d929b;
	}
	.emBtn {
		position:relative;
		bottom:2px;
		left:8px;
	}
  .set_form_fixed_top{
    position:fixed;top:0;left:0;width:100%;
  }
</style>
<script type="text/javascript">

var category = "${category}";

$(document).ready(function () {
    $("#searchValue").keydown(function(event){
      if(event.keyCode === 13){
        search();
      }
    });
    getCtpTop().hideLocation();
});

function search(){
	var selectAccountId =  $("#selectAccountId option:selected").val();
	$("#orgAccountId").val(selectAccountId);
    $("#searchForm").jsonSubmit();
}
function openNewWindow(templateId) {
    url =  _ctxPath + "/collaboration/collaboration.do?method=newColl&from&templateId="+templateId;
    openCtpWindow({'url':url});
}
function treeMoreTemplate() {
	var url = _ctxPath+"/template/template.do?method=moreTreeTemplate&category="+category;
	window.location.href=url;
}
</script>
</head>
<body style="margin-top:0px">
	<c:set value="${CurrentUser.loginAccount}" var="loginAccountId" />
    <div id='layout' class="comp f0f0f0" comp="type:'layout'">
        <div class="layout_north f0f0f0" layout="height:38,sprit:false,border:false">
    <form id="searchForm" method="post" action="${path}/collTemplate/collTemplate.do?method=moreTemplate&columnsName=${ctp:encodeURI(columnsName)}" class="set_form_fixed_top">
	    <div style="width: 100%;height:38px;background: #EDEDED" class="overflow" >
			<div class="left padding_5">
				<div>
					<select class="companyCheck" id="selectAccountId" onchange="search()">
						<option value="1">${ctp:i18n("template.moreTemplate.allAccount")}</option>
						<c:forEach items="${accounts }" var="accounts" >
							<option value="${accounts.key}"
									<c:if test="${orgAccountId == accounts.key && isShowOuter=='false'}">selected="selected"</c:if> >
									${accounts.value}
								 </option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="right padding_5">
                <ul class="changeBtn right">
                    <li class="left treeBtn">
                        <em title="${ctp:i18n('template.moreTemplate.tree')}" onclick="treeMoreTemplate()" class="ico16 emBtn viewStyle_tree"></em>
                    </li>
                    <li onclick="search()" class="left leftBtn selectBtn">
                        <em title="${ctp:i18n('template.moreTemplate.flat')}" class="ico16 emBtn viewStyle_list_checked"></em>
                    </li>
                </ul>
				<span class="search">
					<input id="searchValue" name="searchValue" value="${searchValue}"/>
                    <input type="hidden" id="category" name="category" value="${category}">
                    <input type="hidden" id="orgAccountId" name="orgAccountId">
					<span onclick="search()" class="ico16 search_16"></span>
				</span>
				<span>
					<a class="button" href="${path }/collTemplate/collTemplate.do?method=showTemplateConfig">${ctp:i18n('template.templatePub.configurationTemplates')}</a><!-- 配置模板 -->
				</span>  	
			</div>
		</div>
	</form>
		</div>
		<div class="layout_center" style="overflow: auto;background: #fff;" layout="border:false">
			<div id="scrollListDiv">
    <c:if test="${v3x:hasPlugin('edoc') && v3x:isEnableEdoc()}">
        <c:if test="${fn:length(faTemplete) != 0}">
            <table  border="0" cellpadding="0" cellspacing="0" align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                      <div class="div-float no-wrap">
                          <!-- 发文模板 -->
                          <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.postingTemplate")}
                          </span>
                      </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${faTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                          <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                          </c:choose>
                          <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&edocType=0&templeteId=${templete.id}">
                               <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                      <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                          <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                      </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(shouTemplete) != 0}">
            <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                        <div class="div-float no-wrap">
                            <!-- 收文模板 -->
                            <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.receiptTemplate")}
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${shouTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts"  style="padding-top:0;padding-bottom:5px;" width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&listType=newEdoc&edocType=1&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
        <c:if test="${fn:length(qianTemplete) != 0}">
            <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10">
                        <div class="div-float no-wrap">
                          <!-- 签报模板 -->
                            <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:i18n("template.templatePub.theyReportTemplate")}
                            </span>
                        </div>
                    </td>
                </tr>
                <tr>
                    <c:forEach items="${qianTemplete }" var="templete" varStatus="ordinal">
                        <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&edocType=2&templeteId=${templete.id}">
                             <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
            </table>
        </c:if>
    </c:if>
    <c:if test="${fn:length(categoryNames) != 0}">
        <c:forEach items="${categoryNames }" var="categoryName">
            <c:set var="templetes" value="${collTempleteCategory[categoryName] }"/>
            <c:if test="${fn:length(templetes) != 0}">
              <table border="0" cellpadding="0" cellspacing="0"  align="center" class="w100b  padding_l_5  padding_t_10" style="table-layout:fixed">
                <tr>
                    <td colspan="4" class="sortsHead border_b padding_l_10" >
                      <div class="div-float no-wrap">
                          <span class="ico16 folder_16"></span><span class="font_size12 font_bold padding_l_5">${ctp:toHTML(categoryName)}
                          </span>
                      </div>
                    </td>
                </tr>
                <tr> 
                    <c:forEach items="${templetes }" var="templete" varStatus="ordinal">
                      <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%">
                            <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                            </c:choose>
                            <c:set var="createTitle" value="${ctp:toHTMLWithoutSpace(templeteName) }"/>
                            <a title="${createTitle}&#13${templeteCreatorAlt[templete.id] }" class="defaultlinkcss text_overflow" href="javascript:openNewWindow('${templete.id}');"><span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                        </td>
                        ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                        <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                    </c:forEach>
                    <c:if test="${i !=0}">                  
                        <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                            <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                        </c:forTokens>
                    </c:if>
                </tr>
              </table>
            </c:if>
        </c:forEach>
	</c:if>
	<%--信息报送开始--%>
	<c:if test="${fn:length(infoTemplete) != 0}">
        <table border="0" cellpadding="0" cellspacing="0"  align="center" style="table-layout:fixed" class="w100b  padding_l_5  padding_t_10">
            <tr>
                <td colspan="4" class="sortsHead border_b padding_l_10">
                    <div class="div-float no-wrap">
                        <span class="ico16 folder_16"></span>
                        <span class="font_size12 font_bold">
                            	${ctp:i18n('collaboration.info.template.label')}
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <c:forEach items="${infoTemplete }" var="templete" varStatus="ordinal">
                  <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                      <%--开始 --%>
                      <c:choose>
                              <c:when test="${templete.orgAccountId != loginAccountId }">
                                  <c:set var="theAccount" value="${v3x:getAccount(templete.orgAccountId)}"/>
                                  <c:set var="esName" value="${templete.subject}"/>
                                  <c:set var="templeteName" value="${esName}(${theAccount.shortName})"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:when> 
                              <c:otherwise>
                                  <c:set var="templeteName" value="${templete.subject}"/>
                                  <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                              </c:otherwise>
                       </c:choose>
                      <%--结束--%>
                        <c:if test="${templete.moduleType eq 32}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/info/infomain.do?method=infoReport&listType=listCreateInfo&templateId=${templete.id}">
                        </c:if>
                      <span class="ico16 infoTemplate_16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                  </td>
                  ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                  <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                </c:forEach>
                <c:if test="${i !=0}">
                    <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                        <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                    </c:forTokens>
                </c:if>
            </tr>
        </table>
    </c:if>
    <%--信息报送结束--%>
    <c:if test="${fn:length(personalTempletes) != 0}">
        <table border="0" cellpadding="0" cellspacing="0"  align="center" style="table-layout:fixed" class="w100b  padding_l_5  padding_t_10">
            <tr>
                <td colspan="4" class="sortsHead border_b padding_l_10">
                    <div class="div-float no-wrap">
                        <span class="ico16 folder_16"></span>
                        <span class="font_size12 font_bold">
                            <!-- 个人模板 -->
                            ${ctp:i18n("template.templatePub.personalTemplates")}
                        </span>
                    </div>
                </td>
            </tr>
            <tr>
                <c:forEach items="${personalTempletes }" var="templete" varStatus="ordinal">
                  <td class="text-indent-1em sorts" style="padding-top:0;padding-bottom:5px;" width="25%"> 
                      <c:set var="templeteName" value="${templete.subject }"/>
                        <c:if test="${templete.moduleType eq 19}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=sendManager&toFrom=newEdoc&edocType=0&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 20}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=recManager&toFrom=newEdoc&listType==newEdoc&edocType=1&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 21}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/edocController.do?method=entryManager&entry=signReport&toFrom=newEdoc&edocType=2&templeteId=${templete.id}">
                        </c:if>
                        <c:if test="${templete.moduleType eq 32}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="${path}/info/infocreate.do?method=createInfo&templateId=${templete.id}&action=template">
                        </c:if>
                        <c:if test="${templete.moduleType ne 19 && templete.moduleType ne 20 && templete.moduleType ne 21 && templete.moduleType ne 32}">
                            <a title="${ctp:toHTMLWithoutSpace(templeteName)}&#13${templeteCreatorAlt[templete.id] }" class='defaultlinkcss text_overflow' href="javascript:openNewWindow('${templete.id}');">
                        </c:if>
                      <c:set var="templeteShowName" value="${v3x:getLimitLengthString(templeteName,38,'...')}"/>
                      <span class="ico16 ${templeteIcon[templete.id]}"></span>&nbsp;${ctp:toHTMLWithoutSpace(templeteShowName)}</a>
                  </td>
                  ${(ordinal.index + 1) % 4 == 0 && !ordinal.last ? "</tr><tr>" : ""}
                  <c:set value="${(ordinal.index + 1) % 4}" var="i" />
                </c:forEach>
                <c:if test="${i !=0}">
                    <c:forTokens items="1,1,1,1" delims="," end="${4 - i - 1}">
                        <td  width="25%" class="sorts" style="padding-top:0;padding-bottom:5px;">&nbsp;</td>
                    </c:forTokens>
                </c:if>
            </tr>
        </table>
    </c:if>
    </div>
	    </div>
    </div>
</body>
</html>
