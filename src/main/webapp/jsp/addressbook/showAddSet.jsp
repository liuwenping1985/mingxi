<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle basename="com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources"/>
<fmt:message key='addressbook.set.15.label' var='clickLable' />
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='addressbook.set.0.label' /></title>
<style>
.stadic_head_height {
  height: 40px;
}

.stadic_body_top_bottom {
  top: 40px;
  bottom: 20px;
}

.stadic_footer_height {
  height: 20px;
}
</style>

<script type="text/javascript">
    $(document).ready(function() {
        if ("${bean.viewScope}" == "1") {
            $("#followingViewS_txt").disable();
            $("#followingHideS").comp({
                value : "${bean.viewScopeIds}",
                text : "${bean.viewScopeNames}"
            });
        } else if ("${bean.viewScope}" == "2") {
            $("#followingHideS_txt").disable();
            $("#followingViewS").comp({
                value : "${bean.viewScopeIds}",
                text : "${bean.viewScopeNames}"
            });
        }
        
        if ("${bean.keyInfo}" == "2") {
            $("#followingOpenK_txt").disable();
            $("#followingNotOpenK").comp({
                value : "${bean.keyInfoIds}",
                text : "${bean.keyInfoNames}"
            });
        } else if ("${bean.keyInfo}" == "3") {
            $("#followingNotOpenK_txt").disable();
            $("#followingOpenK").comp({
                value : "${bean.keyInfoIds}",
                text : "${bean.keyInfoNames}"
            });
        } else {
            $("#followingOpenK_txt").disable();
            $("#followingNotOpenK_txt").disable();
        }
        
        if ("${bean.exportPrint}" == "2") {
            $("#followingCanEp").comp({
                value : "${bean.exportPrintIds}",
                text : "${bean.exportPrintNames}"
            });
        } else {
            $("#followingCanEp_txt").disable();
        }
        
        $("#btnok").unbind("click").click(function(){
            $("#form").submit();
        });
        
        $("#btncancel").unbind("click").click(function(){
            getCtpTop().backToHome();
        });
    });
    
    function onRadioClick(enable_e, disable_e1, disable_e2) {
        $("#" + enable_e + "_txt").enable();
        $("#" + disable_e1 + "_txt").disable();
        $("#" + disable_e1).comp({
            value : "",
            text : "${clickLable}"
        });
        $("#" + disable_e2 + "_txt").disable();
        $("#" + disable_e2).comp({
            value : "",
            text : "${clickLable}"
        });
    }
</script>
</head>
<body class="h100b over_hidden">
  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F13_addressbookSet'"></div>
  <div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height bg_color_gray">
      <div class="font_bold padding_l_10 padding_t_5" style="font-size: 20px; color: #919191;"><fmt:message key='addressbook.set.0.label' /></div>
    </div>

    <div class="stadic_layout_body stadic_body_top_bottom">
      <form id="form" name="form" method="post" action="addressbook.do?method=updateAddSet">
        <div class="margin_t_10">
          <div><span class="font_bold"><fmt:message key='addressbook.set.1.label' /></span></div>
          <div class="margin_t_10 margin_l_20">
            <label for="viewScope1" class="valign_m hand" onclick="onRadioClick('followingHideS','followingViewS','')">
              <input id="viewScope1" name="viewScope" type="radio" value="1" ${bean.viewScope != '2' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.2.label' />：</span>
            </label>
            <input id="followingHideS" name="followingHideS" class="comp font_size12" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',onlyLoginAccount:true,minSize:'0',text:'${clickLable}'" />
          </div>
          <div class="margin_t_10 margin_l_20">
            <label for="viewScope2" class="hand" onclick="onRadioClick('followingViewS','followingHideS','')">
              <input id="viewScope2" name="viewScope" type="radio" value="2" ${bean.viewScope == '2' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.3.label' />：</span>
            </label>
            <input id="followingViewS" name="followingViewS" class="comp font_size12" comp="type:'selectPeople',panels:'Account,Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',minSize:'0',text:'${clickLable}'" />
          </div>
        </div>

        <div class="margin_t_10">
          <div>
            <span class="font_bold"><fmt:message key='addressbook.set.4.label' />：
              <select id="keyInfoType" name="keyInfoType">
                <option value="1" ${bean.keyInfoType == '1' ? 'selected' : ''}><fmt:message key='addressbook.set.5.label' /></option>
                <option value="2" ${bean.keyInfoType == '2' ? 'selected' : ''}><fmt:message key='addressbook.set.6.label' /></option>
                <option value="3" ${bean.keyInfoType == '3' ? 'selected' : ''}><fmt:message key='addressbook.set.7.label' /></option>
              </select>
            </span>
          </div>
          <div class="margin_t_10 margin_l_20">
            <label for="keyInfo1" class="hand" onclick="onRadioClick('','followingNotOpenK','followingOpenK')">
              <input id="keyInfo1" name="keyInfo" type="radio" value="1" ${bean.keyInfo != '2' && bean.keyInfo != '3' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.8.label' /></span>
            </label>
          </div>
          <div class="margin_t_10 margin_l_20" onclick="onRadioClick('followingNotOpenK','followingOpenK','')">
            <label for="keyInfo2" class="hand">
              <input id="keyInfo2" name="keyInfo" type="radio" value="2" ${bean.keyInfo == '2' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.9.label' />：</span>
              <input id="followingNotOpenK" name="followingNotOpenK" class="comp font_size12" comp="type:'selectPeople',panels:'Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',onlyLoginAccount:true,minSize:'0',text:'${clickLable}'" />
            </label>
          </div>
          <div class="margin_t_10 margin_l_20" onclick="onRadioClick('followingOpenK','followingNotOpenK','')">
            <label for="keyInfo3" class="hand">
              <input id="keyInfo3" name="keyInfo" type="radio" value="3" ${bean.keyInfo == '3' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.10.label' />：</span>
              <input id="followingOpenK" name="followingOpenK" class="comp font_size12" comp="type:'selectPeople',panels:'Account,Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',minSize:'0',text:'${clickLable}'" />
            </label>
          </div>
        </div>

        <div class="margin_t_10">
          <div><span class="font_bold"><fmt:message key='addressbook.set.11.label' /></span></div>
          <div class="margin_t_10 margin_l_20">
            <label for="exportPrint1" class="hand" onclick="onRadioClick('','followingCanEp','')">
              <input id="exportPrint1" name="exportPrint" type="radio" value="1" ${bean.exportPrint != '2' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.12.label' /></span>
            </label>
          </div>
          <div class="margin_t_10 margin_l_20">
            <label for="exportPrint2" class="hand" onclick="onRadioClick('followingCanEp','','')">
              <input id="exportPrint2" name="exportPrint" type="radio" value="2" ${bean.exportPrint == '2' ? 'checked' :''} />
              <span class="valign_m"><fmt:message key='addressbook.set.13.label' />：</span>
              <input id="followingCanEp" name="followingCanEp" class="comp font_size12" comp="type:'selectPeople',panels:'Account,Department,Team,Post,Level',selectType:'Account,Department,Team,Post,Level,Member',minSize:'0',text:'${clickLable}'" />
            </label>
          </div>
        </div>

        <div class="margin_t_10">
          <div><span class="font_bold"><fmt:message key='addressbook.set.14.label' /></span></div>
          <div class="margin_t_10 margin_l_20">
            <label for="memberName" class="hand">
              <input id="memberName" name="displayColumn" type="checkbox" value="memberName" ${bean.memberName ? 'checked' :''} disabled /><span class="valign_m margin_l_5"><fmt:message key='addressbook.username.label' />　　 </span>
            </label>
            <label for="memberDept" class="hand margin_l_20">
              <input id="memberDept" name="displayColumn" type="checkbox" value="memberDept" ${bean.memberDept ? 'checked' :''} disabled /><span class="valign_m margin_l_5"><fmt:message key='addressbook.company.department.label' /></span>
            </label>
            <label for="memberPost" class="hand margin_l_20">
              <input id="memberPost" name="displayColumn" type="checkbox" value="memberPost" ${bean.memberPost ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.company.post.label' /></span>
            </label>
            <label for="memberLevel" class="hand margin_l_20">
              <input id="memberLevel" name="displayColumn" type="checkbox" value="memberLevel" ${bean.memberLevel ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.company.level.label' /></span>
            </label>
            <label for="memberPhone" class="hand margin_l_20">
              <input id="memberPhone" name="displayColumn" type="checkbox" value="memberPhone" ${bean.memberPhone ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.company.telephone.label' /></span>
            </label>
            <label for="memberMobile" class="hand margin_l_20">
              <input id="memberMobile" name="displayColumn" type="checkbox" value="memberMobile" ${bean.memberMobile ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.mobilephone.label' /></span>
            </label>
          </div>
          <div class="margin_t_10 margin_l_20">
            <label for="memberEmail" class="hand">
              <input id="memberEmail" name="displayColumn" type="checkbox" value="memberEmail" ${bean.memberEmail ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.company.email.label' /></span>
            </label>
            <label for="memberWX" class="hand margin_l_20">
              <input id="memberWX" name="displayColumn" type="checkbox" value="memberWX" ${bean.memberWX ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.weixin.label' /></span>
            </label>
            <label for="memberWB" class="hand margin_l_20">
              <input id="memberWB" name="displayColumn" type="checkbox" value="memberWB" ${bean.memberWB ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.weibo.label' /></span>
            </label>
            <label for="memberHome" class="hand margin_l_20">
              <input id="memberHome" name="displayColumn" type="checkbox" value="memberHome" ${bean.memberHome ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.account_form.address.label' /></span>
            </label>
            <label for="memberCode" class="hand margin_l_20">
              <input id="memberCode" name="displayColumn" type="checkbox" value="memberCode" ${bean.memberCode ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.account_form.postcode.label' /></span>
            </label>
            <label for="memberAddress" class="hand margin_l_20">
              <input id="memberAddress" name="displayColumn" type="checkbox" value="memberAddress" ${bean.memberAddress ? 'checked' :''} /><span class="valign_m margin_l_5"><fmt:message key='addressbook.postAddress.label' /></span>
            </label>
          </div>
        </div>
      </form>
    </div>

    <div class="stadic_layout_footer stadic_footer_height border_t padding_t_5 padding_b_10 align_center bg_color_gray">
      <input type="button" class="common_button common_button_gray" id="btnok" name="btnok" value="${ctp:i18n('common.button.ok.label')}" />
      <input type="button" class="common_button common_button_gray margin_l_10" id="btncancel" name="btncancel" value="${ctp:i18n('common.button.cancel.label')}" />
    </div>
  </div>
</body>
</html>


