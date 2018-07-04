<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="bbsHeader.jsp"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="${path}/skin/default/bbs.css${v3x:resSuffix()}" />
<script src="${path}/apps_res/bbs/js/bbsCommon.js${v3x:resSuffix()}"></script>
<script type="text/javascript">
  <c:if test="${bbsBoard.affiliateroomFlag=='2'}">
  var onlyLoginAccount_authIssue = true;
  var onlyLoginAccount_authReply = true;
  //不选择个人组外单位人员
  hiddenOtherMemberOfTeam_authIssue = true;
  hiddenOtherMemberOfTeam_authReply = true;
  </c:if>
  <c:if test="${bbsBoard.affiliateroomFlag =='18'}">
  var onlyLoginAccount_authIssue = false;
  var onlyLoginAccount_authReply = false;
  </c:if>
  if ('${bbsBoard.affiliateroomFlag}' == '17' || '${bbsBoard.affiliateroomFlag}' == '18') {
    var includeElements_authIssue = "${v3x:parseElementsOfTypeAndId(entity)}";
    var includeElements_authReply = "${v3x:parseElementsOfTypeAndId(entity)}";
  }

  //授权：板块权限选择
  function boradAuthIssue(){
    var authIssue_input = $("#authIssueInput");
    $("#authType_radio0").click(function(){
      authIssue_input.addClass("authIssue_input");
    });
    $("#authType_radio1").click(function(){
      authIssue_input.removeClass("authIssue_input");
      authIssueOrReply("1");
    });
  }

  //授权   改为直接弹出选人界面   type 1代表授权发帖   2代表授权禁止回复
  function authIssueOrReply(type) {
    if (type == '1') {
      selectPeopleFun_authIssue();
    } else {
      selectPeopleFun_authReply();
    }
  }

  //不受职务级别限制
  showRecent_authIssue = false;
  showRecent_authReply = false;
  isNeedCheckLevelScope_authIssue = false;
  isNeedCheckLevelScope_authReply = false;
  var hiddenPostOfDepartment_authIssue = true;
  var hiddenPostOfDepartment_authReply = true;

  function setPeopleFields(elements, type) {
    if (elements == null) {
        $("#authType_radio0").prop("checked",true);
        return;
    }else{
        $("#authType_radio1").prop("checked",true);
    }

    if (type == '1') {
      $("#authPostUser").val(getNamesString(elements));
      $("#authIssueIds").val(getIdsString(elements,true));
    } else {
      $("#banReplyUser").val(getNamesString(elements));
      $("#authReplyIds").val(getIdsString(elements,true));
    }
  }

  /*
   * 上传图片
   */
  function doUploadImage() {
    try {
      getA8Top().headImgCuttingWin = getA8Top().$.dialog({
        id : "headImgCutDialog",
        title : '${ctp:i18n('bbs.board.cover')}',
        transParams : {
          'parentWin' : window
        },
        url : "${pageContext.request.contextPath}/portal/portalController.do?method=headImgCutting&cutWidth=216&cutHeight=165&cutImg=/apps_res/bbs/css/images/cover_1.jpg",
        width : 750,
        height : 400,
        isDrag : false
      });
    } catch (e) {
    }
  }

  function headImgCuttingCallBack(retValue) {
    var value_id = retValue.toString().substr(0, retValue.indexOf("&"));
    getA8Top().headImgCuttingWin.close();
    if (retValue != undefined) {
      document.getElementById("boardCoverImg").setAttribute("src", "${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=" + retValue + "&type=image");
      document.getElementById("imageId").value = value_id;
    }
  }
  
  function submitForm(){
    var theForm = document.getElementById("boardForm");
    if (!theForm) {
        return;
    }
    theForm.action = "${detailURL}?method=modifyBoardNew&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
    theForm.submit();
  }
  $(function() {
    var _height = $(window).height();
    $(".dialog_body_info").height(_height+10);
    boradAuthIssue();
  });
</script>
</head>
<body>
  <form id="boardForm" action="" method="post">
    <div id="boardSet" class="cover_dialog">
      <c:set value="${v3x:parseElements(bbsBoard.issuerList, 'id', 'entityType')}" var="authIssueId" />
      <c:set value="${v3x:parseElements(bbsBoard.canNotReplyList, 'id', 'entityType')}" var="authReplyId" />
      <input type="hidden" id="authIssueIds" name="authIssueIds" value="${authPost}"> 
      <input type="hidden" id="authReplyIds" name="authReplyIds" value="${forbiddenReply}">
      <input type="hidden" id="imageId" name="imageId" value="${bbsBoard.imageId}">
      <input type="hidden" id="boardId" name="id" value="${bbsBoard.id}">
      <c:choose>
        <c:when test="${bbsBoard.affiliateroomFlag == 17 || bbsBoard.affiliateroomFlag == 18 }">
          <v3x:selectPeople id="authIssue" panels="Account,Department,Post,Level,Team" 
                selectType="Member,Account,Department,Post,Level,Team" 
                minSize="0" departmentId="${v3x:currentUser().departmentId}" 
                jsFunction="setPeopleFields(elements,1)" originalElements="${authIssueId}" />
          <v3x:selectPeople id="authReply" panels="Account,Department,Post,Level,Team" 
                selectType="Member,Account,Department,Post,Team,Level" 
                minSize="0" departmentId="${v3x:currentUser().departmentId}" 
                jsFunction="setPeopleFields(elements,2)" originalElements="${authReplyId}" />
        </c:when>
        <c:otherwise>
          <v3x:selectPeople id="authIssue" 
                panels="${bbsBoard.affiliateroomFlag == 3 ?  'Account,' : ''}Department,Post,Level,Team${bbsBoard.affiliateroomFlag == 3 ?  '' : ',Outworker'}" 
                selectType="Member,Account,Department,Level,Team,Post" 
                departmentId="${v3x:currentUser().departmentId}" 
                showMe="false" jsFunction="setPeopleFields(elements,1)" 
                minSize="0" originalElements="${authIssueId}" />
          <v3x:selectPeople id="authReply" panels="Department,Post,Level,Team,Outworker" 
                selectType="Member,Account,Department,Level,Team,Post" 
                departmentId="${v3x:currentUser().departmentId}" 
                showMe="false" jsFunction="setPeopleFields(elements,2)" 
                minSize="0" originalElements="${authReplyId}" />
        </c:otherwise>
      </c:choose>
      <div class="dialog_bg"></div>
      <div class="dialog_body_info">
      <div class="dialog_body">
        <div class="dialog_header" style="background: #fff;border-bottom: 1px solid #efefef;">
          <span class="header_title">${ctp:i18n('bbs.board.setting')}</span>
          <span class="header_icon" style="margin-top: -2px;margin-right: 28px;">
            <em class="icon24 talk_close_24" onclick="parent.boardSettingDialog.close();"></em>
          </span>
        </div>
        <div class="dialog_content" style="height:438px;">
          <ul class="cover_set_ul">
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('bbs.allow.post')}</span>
              <span class="span_input">
                <span class="radio_span" style="width:70px">
                  <label>
                    <input type="radio"id="authType_radio0" value="0" name="authType" <c:if test="${bbsBoard.authType==0}">checked</c:if> />${ctp:i18n('bbs.all.post')}
                  </label>
                </span>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">&nbsp;</span>
              <span class="span_input">
                <span class="select_person_span">
                  <label>
                    <input type="radio" id="authType_radio1" value="1" name="authType" <c:if test="${bbsBoard.authType==1}">checked</c:if> />${ctp:i18n('logon.search.selectPeople')}
                  </label>
                </span>
                <span class="span_input board_span <c:if test='${bbsBoard.authType==0}'>authIssue_input</c:if>" onclick="authIssueOrReply('1')" style="width: 279px;" id="authIssueInput">
                  <input id="authPostUser" type="text" value="${v3x:showOrgEntities(bbsBoard.issuerList, 'id', 'entityType' ,pageContext)}" class="choose_input" style="width: 255px;">
                  <em class="icon16 people_choose_16"></em>
                </span>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('blog.auth.reply.label')}</span>
              <span class="span_input board_span" onclick="authIssueOrReply('2')">
                <input id="banReplyUser" type="text" value="${v3x:showOrgEntities(bbsBoard.canNotReplyList, 'id', 'entityType' ,pageContext)}" class="choose_input">
                <em class="icon16 people_choose_16"></em>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('bbs.reply.sort')}</span>
              <span class="span_input">
                <span class="radio_span">
                  <label>
                    <input type="radio" value="0" name="orderFlag" <c:if test="${bbsBoard.orderFlag!=1}">checked</c:if> />${ctp:i18n('bbs.sort.asc')}
                  </label>
                </span>
                <span class="radio_span">
                  <label>
                    <input type="radio" value="1" name="orderFlag" <c:if test="${bbsBoard.orderFlag==1}">checked</c:if> />${ctp:i18n('bbs.sort.desc')}
                  </label>
                </span>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('bbs.allow.anonymous.post')}</span>
              <span class="span_input">
                <span class="radio_span">
                  <label>
                    <input type="radio" value="0" name="anonymousFlag" <c:if test="${bbsBoard.anonymousFlag==0}">checked</c:if> />${ctp:i18n('bbs.box.yes')}
                  </label>
                </span>
                <span class="radio_span">
                  <label>
                    <input type="radio" value="1" name="anonymousFlag" <c:if test="${bbsBoard.anonymousFlag==1}">checked</c:if> />${ctp:i18n('bbs.box.no')}
                  </label>  
                </span>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('bbs.allow.anonymous.reply')}</span>
              <span class="span_input">
                <span class="radio_span">
                  <label>
                    <input type="radio" value="0" name="anonymousReplyFlag" <c:if test="${bbsBoard.anonymousReplyFlag==0}">checked</c:if> />${ctp:i18n('bbs.box.yes')}
                  </label>
                </span>
                <span class="radio_span">
                  <label>
                    <input type="radio" value="1" name="anonymousReplyFlag" <c:if test="${bbsBoard.anonymousReplyFlag==1}">checked</c:if> />${ctp:i18n('bbs.box.no')}
                  </label>
                </span>
              </span>
            </li>
            <li class="cover_set_li">
              <span class="span_name">${ctp:i18n('bbs.topnumber.label')}</span>
              <span class="span_input">
                <select name="topNumber" class="top_num">
                  <option value="0" <c:if test="${bbsBoard.topNumber==0}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.zero')}</option>
                  <option value="1" <c:if test="${bbsBoard.topNumber==1}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.one')}</option>
                  <option value="2" <c:if test="${bbsBoard.topNumber==2}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.two')}</option>
                  <option value="3" <c:if test="${bbsBoard.topNumber==3}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.three')}</option>
                  <option value="4" <c:if test="${bbsBoard.topNumber==4}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.four')}</option>
                  <option value="5" <c:if test="${bbsBoard.topNumber==5}">selected</c:if>>${ctp:i18n('blog.createfamily.common.name.five')}</option>
                </select>
              </span>
            </li>
            <li class="cover_set_li" style="height:auto;">
              <span class="span_name left">${ctp:i18n('bbs.board.cover')}</span>
              <span class="cover_img">
                <c:if test="${bbsBoard.imageId==null}">
                  <img id="boardCoverImg" src="${path}/apps_res/bbs/css/images/${bbs:getBoardImage(bbsBoard.id)}" width="210" height="160" class="left">
                </c:if>
                <c:if test="${bbsBoard.imageId!=null}">
                  <img id="boardCoverImg" width="210" height="160" class="left" name="coverImge" src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&fileId=${bbsBoard.imageId}&type=image" />
                </c:if>
                <a href="javascript:;" class="file_up left" onclick="doUploadImage();">${ctp:i18n('bbs.upload.cover')}</a>
              </span>
            </li>
          </ul>
        </div>
        <div class="dialog_footer" style="margin-top:0px;">
          <a href="javascript:;" class="button margin_r_10" onclick="submitForm()">${ctp:i18n('bbs.ok.js')}</a>
          <a href="javascript:;" class="button gray_button" onclick="parent.boardSettingDialog.close();">${ctp:i18n('bbs.cancel.js')}</a>
        </div>
      </div>
     </div>
    </div>
  </form>
</body>
</html>
