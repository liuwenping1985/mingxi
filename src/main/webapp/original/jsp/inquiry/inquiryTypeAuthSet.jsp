<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<html>

<head>
<link rel="stylesheet" type="text/css" href="${path}/skin/default/inquiry.css${v3x:resSuffix()}" />
  <script type="text/javascript">
    var _path = '${path}';
    var _spaceType = '${spaceType}';
    var ajax_inquiryManager = new inquiryManager();
    showRecent_per = false;
    var authPost = "${v3x:parseElementsOfTypeAndId(entity)}";
    var _typeId = '${typeId}';
    var _orgType = '${orgType}';
    window.onload = function() {
      boradAuthIssue();
      getTypeAuthArea(_typeId);
    }

    //授权：板块权限选择
    function boradAuthIssue(){
      var authIssue_input = $("#authIssueInput");
      $("#authType_radio0").click(function(){
        authIssue_input.addClass("authIssue_input");
      });
      $("#authType_radio1").click(function(){
        authIssue_input.removeClass("authIssue_input");
        setAuthSelect(_typeId,_orgType);
      });
    }

    /**
     * 选定人授权
     * @param typeId
     * @param orgType
     */
    function setAuthSelect(typeId,orgType){
        $("#areaBoardId").val(typeId);
        isNeedCheckLevelScope_per = false;
        hiddenPostOfDepartment_per = true;
        if(_spaceType == '18' || _spaceType == '17'){
          includeElements_per = authPost;
        }
        if(orgType == "account" && _spaceType != "17"){
          onlyLoginAccount_per = true;
          hiddenOtherMemberOfTeam_per = true;
        }
        selectPeopleFun_per();
    }

    /**
     * 获取版块对应的授权人员
     * @param typeId
     */
    function getTypeAuthArea(typeId){
        var data = {
            typeId: typeId
        };
        ajax_inquiryManager.findTypeAuthList(data, {
            success : function(rv) {
                elements_per = parseElements(rv);
            },
            error : function(rv) {
                $.error($.i18n("inquiry.typeAuth.error"));
                return "";
            }
        });
        var a = elements_per;
    }

    /**
     * 授权选人后调用
     * @param elements
     */
    function setAuthCallback(elements){
      if (elements == null) {
        $("#authType_radio0").prop("checked",true);
        elements_per = parseElements("");
        $("#authList").val("");
        $("#authListIds").val("");
        return;
      }
      $("#authList").val(getNamesString(elements));
      $("#authListIds").val(getIdsString(elements,true));
      elements_per = getIdsString(elements,true);
      $("#authType_radio1").prop("checked",true)
    }
    
    function submitForm() {
        var authType_new = $("input[name='authType']:checked").val();
        var modifyFlag = true;
        var anonymousFlag_new = $("input[name='anonymousFlag']:checked").val();
        var anonymousFlag_old = $("#anonymousFlag_old").val();
        if(authType_new == $("#authType_old").val() && authType_new == 0){
          modifyFlag = false;
        } else if( authType_new == 1 && authType_new == $("#authType_old").val() && $("#authListIds_old").val() == $("#authListIds").val()){
          modifyFlag = false;
        }
        if(modifyFlag || anonymousFlag_new != anonymousFlag_old){
          var theForm = document.getElementById("typeSttingForm");
          if (!theForm) {
              return;
          }
          theForm.action = "${detailURL}?method=modifyTypeAauth";
          theForm.submit();
        } else {
          parent.inqTypeSettingDialog.close();
        }

    }
  </script>
</head>

<body>
  <c:choose>
    <c:when test="${spaceType == 17 || spaceType == 18 }">
      <v3x:selectPeople id="per" panels="Account,Department,Post,Level,Team" 
            selectType="Member,Account,Department,Post,Level,Team" 
            minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" 
            jsFunction="setAuthCallback(elements)" originalElements="" />
    </c:when>
    <c:otherwise>
      <v3x:selectPeople id="per" panels="Department,Post,Level,Team" minSize="0"
            selectType="Member,Account,Department,Level,Team,Post"
            departmentId="${sessionScope['com.seeyon.current_user'].departmentId}"
            originalElements="" jsFunction="setAuthCallback(elements)" />
    </c:otherwise>
  </c:choose>
  <form id="typeSttingForm" action="" method="post">
      <div class="dialog cover_dialog">
      <div class="dialog_body_info">
        <div class="dialog_body">
          <input type="hidden" name="typeId" value="${typeId}">      
          <div class="dialog_header">
            <span class="header_title">${ctp:i18n('bbs.board.setting')}</span><!-- 版块设置 -->
            <span class="header_icon">
              <em class="icon24 talk_close_24" onclick="parent.inqTypeSettingDialog.close();"></em>
            </span>
          </div>
          <div class="dialog_content">
            <ul class="cover_set_ul">
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('bbs.allow.typePost')}</span><!-- 版块授权 -->
                <input type="hidden" id="authType_old" value="${authType}">
                <span class="span_input">
                  <span class="radio_span">
                    <label>
                      <input type="radio" id="authType_radio0" name="authType" value="0" <c:if test='${authType==0}'>checked</c:if> />${ctp:i18n('bbs.all.post')}
                    </label>
                  </span>
                </span><br/>
                <span class="span_input" style="width:515px;">
                  <span class="radio_span" style="margin-left: 104px;margin-top:7px;">
                    <label>
                      <input type="radio" id="authType_radio1" name="authType" value="1" <c:if test='${authType==1}'>checked</c:if>  />${ctp:i18n('com.seeyon.v3x.mobile.xzry')}
                    </label>
                  </span>
                  <span class="span_input <c:if test='${authType==0}'>authIssue_input</c:if> " id="authIssueInput" style="width:305px;" onclick="setAuthSelect('${typeId}','${orgType}')">
                    <input type="hidden" id="authListIds_old" value="${auList}">
                    <input type="hidden" id="authListIds" name="authListIds" value="${auList}">
                    <input type="text" value="${v3x:showOrgEntities(auListEntity, 'id', 'entityType' ,pageContext)}" class="choose_input" id="authList" style="width:300px;"/>
                    <em class="icon16 people_choose_16"></em>
                  </span>
                </span>
              </li>
              <li class="cover_set_li">
                <span class="span_name">${ctp:i18n('inquiry.allow.anonymous.vote')}</span><!--是否允许匿名-->
                <input type="hidden" id="anonymousFlag_old" value="${anonymousFlag}">
                <span class="span_input">
                  <span class="radio_span">
                    <label>
                      <input type="radio" id="anonymousFlag0" name="anonymousFlag" value="0" <c:if test="${anonymousFlag == 0 || empty anonymousFlag}">checked</c:if> />${ctp:i18n('common.true')}
                    </label>
                  </span>
                  <span class="radio_span">
                    <label>
                      <input type="radio" id="anonymousFlag1" name="anonymousFlag" value="1" <c:if test="${anonymousFlag == 1}">checked</c:if> />${ctp:i18n('common.false')}
                    </label>
                  </span>
                </span>
              </li>
            </ul>
          </div>
          <div class="dialog_footer">
            <a href="javascript:;" class="button button_style" onclick="submitForm()">${ctp:i18n('bbs.ok.js')}</a>
            <a href="javascript:;" class="button button_style gray_button" onclick="parent.inqTypeSettingDialog.close();">${ctp:i18n('bbs.cancel.js')}</a>
          </div>
        </div>
      </div>

    </div>
  </form>
</body>

</html>