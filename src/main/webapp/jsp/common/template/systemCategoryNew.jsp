<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="templete.toolbar.category" /> - <fmt:message
    key="common.toolbar.${act}.label" bundle="${v3xCommonI18N}" /></title>
<script>
  $(function() {
    var parentId = "${parentId}";
    var categoryType = "${categoryType}";
    var canAdmin = "${canAdmin}";
    if(categoryType === "2"){
      $("#authTd").hide();
    }
    $("#auth").comp({
      value : "${authvalue}",
      text : "${authtxt}"
    });
    if (parentId === "1" && canAdmin == "true") {
      $("#cannotauth").hide();
    } else {
      $("#canauth").hide();
    }
    if (parentId) {
      $("#parentId").val(parentId);
      if($("#parentId").val() == null && $("#parentId option").length > 0){
        $("#parentId").val($($("#parentId option")[0]).val());
      }
    }
    var info = "<${ctp:i18n('template.newcategory.fillname.label')}>";
    if ($("#name").val() === "") {
      $("#name").val(info);
    }
    $("#name").focus(function() {
      if ($("#name").val() === info) {
        $("#name").val("");
      }
    });
    $("#name").blur(function() {
      if ($("#name").val() === "") {
        $("#name").val(info);
      }
    });
    if ($("#auth").val() === "") {
      $("#auth").comp({
        value : "",
        text : "<${ctp:i18n('template.newcategory.selectmember.label')}>"
      });
    }
    if ($("#sort").val() === "") {
      $("#sort").val("1");
    }
    $("#parentId").change(function(){
      if($("#parentId").val() === "1"){
        $("#cannotauth").hide();
        $("#canauth").show();
      }else{
        $("#cannotauth").show();
        $("#canauth").hide();
      }
      $("#auth").comp({
        value : "",
        text : "<${ctp:i18n('template.newcategory.selectmember.label')}>"
      });
    });
  });
  // 确定提交
  function OK() {
	$("#type").val($("#parentId").val());
    var frmobj = $("#categoryForm").formobj();
    var valid = $._isInValid(frmobj);
    // 检查描述
    var checkLength = $("#description").val().length - 60;
    if(checkLength > 0){
        //描述不能多于60个字，当前共有"+$("#description").val().length+"个字
        $("#descriptionDiv").attr("title","${ctp:i18n_1('template.systemCategory.descriptionMore60','"+$("#description").val().length+"')}");
        $("#descriptionTd span").attr("title","${ctp:i18n_1('template.systemCategory.descriptionMore60','"+$("#description").val().length+"')}");
    }
    if($("#parentId").val() == null || $("#parentId option").length == 0){
      valid = true;
    }
    frmobj.valid = valid;
    return frmobj;
  }
</script>
</head>

<body scroll="no" onkeydown="listenerKeyESC()">
  <form id="categoryForm" name="categoryForm" method="post" action="${path}/template/template.do?method=saveCategory">
    <input type="hidden" id="id" name="id"> 
    <input type="hidden" id="type" name="type" value="1"> 
    <input type="hidden" name="orgAccountId" value="${CurrentUser.loginAccount}"> 
    <input type="hidden" name="createMember" value="${CurrentUser.id}"> 
    <input type="hidden" name="modifyMember" value="${CurrentUser.id}">
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.parentcategory.label')}:</label></th>
              <td width="87%">
                  <select name="parentId" id="parentId" class="input-100per cursor-hand w100b" disabled="disabled">${categoryHTML}</select>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.name.label')}:</label></th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="name" type="text" class="validate" maxlength="30"
                    validate="name:'${ctp:i18n('template.newcategory.name.label')}',maxLength:30,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('template.newcategory.fillname.label')}\>'">
                </div>
              </td>
            </tr>
            <tr id="authTd" style="display:none">
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.authorization.label')}:</label></th>
              <td>
                <div class="common_txtbox_wrap" id="cannotauth">
                  <input type="text" disabled="disabled" value="${ctp:i18n('template.newcategory.cannotauthorized.label')}">
                </div>
                <div class="common_txtbox_wrap" id="canauth">
                  <input type="text" id="auth" name="auth" class="comp"
                    comp="type:'selectPeople',panels:'Department',minSize:'0',selectType:'Member',mode:'open',onlyLoginAccount:true,value:'',text:''" />
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.sortnumber.label')}:</label></th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" class="validate"
                    validate="name:'${ctp:i18n('template.newcategory.sortnumber.label')}',isInteger:true,notNull:true,max:9999,min:-9999">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.describe.label')}:</label></th>
              <td id="descriptionTd">
                <div id="descriptionDiv" class="common_txtbox clearfix">
                  <textarea id="description" class="w100b validate" cols="30" style="height:145px;" validate="name:'${ctp:i18n('template.newcategory.describe.label')}',maxLength:60"></textarea>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </form>
</body>
</html>