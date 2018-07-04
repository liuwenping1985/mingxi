<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="bulHeader.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${path}/skin/default/bulletin.css${ctp:resSuffix()}" />
<script type="text/javascript">

window.onload= function(){
  if(!${bean.printFlag}){
    $('#printDefault').attr("disabled","disabled");
  }
  if(!${bean.auditFlag}){
    $('#finalPublishFi').css("display","none");
  }
  //打印选项checkBox点击事件
  $("#printFlag").click(function (){
    if(this.checked){
      $("#printFlagHid").val(true);
      $('#printDefault').removeAttr("disabled");
    } else {
      $('#printDefault').attr("disabled","disabled");
      $("#printFlagHid").val(false);
    }
  });
  $("#printDefault").click(function (){
    if(this.checked){
      $("#printDefaultHid").val(true);
    } else {
      $("#printDefaultHid").val(false);
    }
  });
  $("#defaultPublish").click(function (){
    if(this.checked){
      $("#defaultPublishHid").val(true);
    } else {
      $("#defaultPublishHid").val(false);
    }
  });
  $("#writePermit").click(function (){
    if(this.checked){
      $("#writePermitHid").val(true);
    } else {
      $("#writePermitHid").val(false);
    }
  });

  $("#write_help").mouseover(function(e){
    //判断弹出框的位置
    // var em_title=$(this).parent().children(".em_title");
    // var heightWin=$(window).height();
    // var widthWin=$(window).width();
    // var height =$(this).offset().top;
    // var left =$(this).offset().left;
    // $(this).parent().children(".em_title,.em_title_bg").offset({top:height+20,left:left-200});
    $("#write_help_text").show();
  }).mouseout(function(){
    $("#write_help_text").hide();
  });

}

  if ('${bean.spaceType}' == '2') {
    onlyLoginAccount_authType = true;
    hiddenOtherMemberOfTeam_authType = true;
  }
  if ('${bean.spaceType}' == '17' || '${bean.spaceType}' == '18') {
    includeElements_authType = "${v3x:parseElementsOfTypeAndId(entity)}";
  }
  showRecent_authType = false;
  isNeedCheckLevelScope_authType = false;
  var hiddenPostOfDepartment_authType = true;//岗位去掉
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
    theForm.action = "${detailURL}?method=modifyTypeBul&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
    theForm.submit();
  }
</script>
</head>
<body>
  <form id="typeSttingForm" action="" method="post">
    <div class="dialog cover_dialog">
      <div class="dialog_body_info">
        <div class="dialog_body">
          <c:set value="${v3x:parseElements(managerId, 'id', 'entityType')}" var="ids" />
          <input type="hidden" value="${ids}" id="authIssue" name="authIssue" />
          <input type="hidden" name="typeId" value="${bean.id}"/>
          <c:choose>
            <c:when test="${bean.spaceType==17 || bean.spaceType==18 }">
              <v3x:selectPeople id="authType" panels="Account,Department,Post,Level,Team"
                    selectType="Account,Department,Post,Level,Team,Member"
                    minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
                    jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}" />
            </c:when>
            <c:otherwise>
              <v3x:selectPeople id="authType" panels="Department,Post,Level,Team" selectType="Member,Account,Department,Level,Team,Post" minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}" />
            </c:otherwise>
          </c:choose>
          <div class="dialog_header">
            <span class="header_title">${ctp:i18n('bulletin.sectionSet')}</span><!-- 版块设置 -->
            <span class="header_icon">
              <em class="icon24 talk_close_24" onclick="parent.bulTypeSettingDialog.close();"></em>
            </span>
          </div>
          <div class="dialog_content">
            <ul class="cover_set_ul">
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('bulletin.sectionAuthorize')}</span><!-- 版块授权 -->
                <span class="span_input" onclick="selectPeopleFun_authType();">
                  <input id="authType" type="text"  value="${v3x:showOrgEntities(managerId, 'id', 'entityType' ,pageContext)}" class="choose_input">
                  <em class="icon16 people_16"></em>
                </span>
              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('bulletin.typeSet.publishSet')}</span><!-- 发布人设置 -->
                <span class="span_input">
                  <span class="radio_span">
                    <label>
                      <input type="hidden"  id="defaultPublishHid" name="defaultPublish"  value="${bean.defaultPublish}"/>
                      <input type="checkbox" id="defaultPublish" <c:if test="${bean.defaultPublish}">checked</c:if> />${ctp:i18n('bulletin.typeSet.defaultPubAll')}
                    </label>
                  </span>
                </span>
                <span class="span_input span_input_margin span_input_bottom" id="finalPublishFi">
                  <span>${ctp:i18n('bulletin.typeSet.finalPublish')}：</span>
                  <select name="finalPublish">
                      <option  value="0"
                          <c:if test="${bean.finalPublish==0}">selected</c:if>>${ctp:i18n('bulletin.typeSet.realPublish')}</option>
                      <option  value="1"
                          <c:if test="${bean.finalPublish==1}">selected</c:if>>${ctp:i18n('bulletin.createMember')}</option>
                      <option  value="2"
                          <c:if test="${bean.finalPublish==2}">selected</c:if>>${ctp:i18n('bulletin.auditMember')}</option>
                  </select>
                </span>
                <span class="span_input span_input_margin">
                  <span class="radio_span">
                    <label>
                      <input type="hidden"  id="writePermitHid" name="writePermit"  value="${bean.writePermit}"/>
                      <input type="checkbox" id="writePermit" <c:if test="${bean.writePermit}">checked</c:if> />${ctp:i18n('bulletin.typeSet.writePermit')}
                    </label>
                    <em id="write_help" class="ico16 help_16" style="left: 140px;top: 0px;"></em>
                    <em class="em_title em_title_content em_write_text" style="display: none;" id="write_help_text">
                        ${ctp:i18n('bulletin.publishChoose.tips')}
                    </em>
                  </span>
                </span>
              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('bulletin.typeSet.printSet')}</span><!-- 打印设置 -->
                <span class="span_input">
                  <span class="radio_span">
                    <label>
                      <input type="hidden"  id="printFlagHid" name="printFlag"  value="${bean.printFlag}"/>
                      <input type="checkbox" id="printFlag" <c:if test="${bean.printFlag}">checked</c:if> />${ctp:i18n('bulletin.typeSet.allowPrint')}
                    </label>
                  </span>
                </span>
                <span class="span_input span_input_mar">
                  <span class="radio_span">
                    <label>
                      <input type="hidden"  id="printDefaultHid" name="printDefault"  value="${bean.printDefault}"/>
                      <input type="checkbox" id="printDefault" <c:if test="${bean.printDefault}">checked</c:if> />${ctp:i18n('bulletin.typeSet.defaultPrintAll')}
                    </label>
                  </span>
                </span>
              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('bulletin.topNum')}</span><!-- 置顶个数 -->
                <span class="span_input">
                  <input type="hidden" name="oldTopCount" value="${bean.topCount}" />
                    <td class="new-column" width="75%">
                        <select name="topCount" class="top_num">
                            <v3x:metadataItem metadata="${topCountMetaData}"
                                showType="option" name="topCount" selected="${bean.topCount}" switchType="input" />
                        </select>
                    </td>
                </span>
              </li>
            </ul>
          </div>
          <div class="dialog_footer">
            <a href="javascript:;" class="button button_style" onclick="submitForm()">${ctp:i18n('bulletin.ok')}</a>
            <a href="javascript:;" class="button button_style gray_button" onclick="parent.bulTypeSettingDialog.close();">${ctp:i18n('bulletin.cancle')}</a>
          </div>
        </div>
      </div>

    </div>
  </form>
</body>
</html>