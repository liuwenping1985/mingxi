<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<link rel="stylesheet" href="${path}/skin/default/news.css${ctp:resSuffix()}">
<script type="text/javascript">
  
  if ('${bean.spaceType}' == '2') {
    onlyLoginAccount_authType = true;
    hiddenOtherMemberOfTeam_authType = true;
  }

  showRecent_authType = false;//最近
  isNeedCheckLevelScope_authType = false;
  hiddenPostOfDepartment_authType = true;//岗位去掉
  function setPeopleFieldsW(elements, type) {
    if (elements == null) {
      return;
    }
    $("#authType").val(getNamesString(elements));
    $("#authIssue").val(getIdsString(elements, true));
  }

  function submitForm() {
    var theForm = document.getElementById("typeSttingForm");
    if (!theForm) {
      return;
    }
    theForm.action = "${detailURL}?method=modifyTypeNew&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
    theForm.submit();
  }
  if ('${bean.spaceType}' == '17' || '${bean.spaceType}' == '18') {
    includeElements_authType = "${v3x:parseElementsOfTypeAndId(entity)}";
  }
</script>
</head>
<body>
  <form id="typeSttingForm" action="" method="post">
    <div class="dialog cover_dialog">
      <div class="dialog_body_info">
        <div class="dialog_body">
          <c:set value="${v3x:parseElementsOfTypeAndId(managerId)}" var="ids" />
          <c:set var="managerName" value="${v3x:showOrgEntitiesOfTypeAndId(managerId, pageContext)}" />
          <input type="hidden" value="${ids}" id="authIssue" name="authIssue" /> 
          <input type="hidden" name="typeId" value="${bean.id}"/>
          <c:choose>
            <c:when test="${spaceType==17 || spaceType==18 }">
              <v3x:selectPeople id="authType" panels="Account,Department,Post,Level,Team" 
                    selectType="Account,Department,Post,Level,Team,Member"
                    minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
                    jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}" />
            </c:when>
            <c:otherwise>
              <v3x:selectPeople id="authType" panels="Department,Post,Level,Team" 
                    selectType="Member,Account,Department,Level,Team,Post" 
                    minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
                    jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}" />
            </c:otherwise>
          </c:choose>
          <div class="dialog_header">
            <span class="header_title">${ctp:i18n('news.typeSetting')}</span>
            <span class="header_icon">
              <em class="icon24 talk_close_24" onclick="parent.newsTypeSettingDialog.close();"></em>
            </span>
          </div>
          <div class="dialog_content">
            <ul class="cover_set_ul">
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('news.typeAuth')}</span>
                <span class="span_input" onclick="selectPeopleFun_authType();">
                  <input id="authType" type="text"  value="${managerName}" class="choose_input">
                  <em class="icon16 people_16"></em>
                </span>

              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('news.allowComments')}</span>
                <span class="span_input">
                  <span class="radio_span">
                    <label>
                      <input type="radio" id="commentFlag1" name="commentPermit" value="1" <c:if test="${bean.commentPermit}">checked</c:if> />${ctp:i18n('news.yes')}
                    </label>
                  </span>
                  <span class="radio_span">
                    <label>
                      <input type="radio" id="commentFlag0" name="commentPermit" value="0" <c:if test="${!bean.commentPermit}">checked</c:if> />${ctp:i18n('news.no')}
                    </label>
                  </span>
                </span>
              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('news.newDays')}</span>
                <span class="span_input">
                  <select name="newDays" class="top_num">
                  	<option value="1" <c:if test="${bean.topCount==1}">selected</c:if>>1</option>
                    <option value="3" <c:if test="${bean.topCount==3}">selected</c:if>>3</option>
                    <option value="5" <c:if test="${bean.topCount==5}">selected</c:if>>5</option>
                    <option value="7" <c:if test="${bean.topCount==7}">selected</c:if>>7</option>
                  </select>
                </span>
              </li>
              <%-- 置顶个数 --%>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('news.topNum')}</span>
                <span class="span_input">
                  <input type="hidden" name="oldTopNumber" value="${bean.topNumber}" />
                    <td class="new-column" width="75%">
                        <select name="topNumber" class="top_num">
                            <v3x:metadataItem metadata="${topNumberData}"
                                showType="option" name="topNumber" selected="${bean.topNumber}" switchType="input" />
                        </select>
                    </td>
                </span>
              </li>
            </ul>
          </div>
          <div class="dialog_footer">
            <a href="javascript:;" class="reply_button" onclick="submitForm()">${ctp:i18n('news.determine')}</a>
            <a href="javascript:;" class="reply_button gray_button" onclick="parent.newsTypeSettingDialog.close();">${ctp:i18n('news.cancel')}</a>
          </div>
        </div>
      </div>

    </div>
  </form>
</body>
</html>



