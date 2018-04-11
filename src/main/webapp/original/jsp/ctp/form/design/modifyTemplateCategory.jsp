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
    var categoryType = "${ctp:escapeJavascript(categoryType)}";
    if (parentId) {
    	//如果是根节点。协同那边获取的根节点是1,而表单这边的根节点是2
    	if(parentId == 1){
    		$("#parentId").val(2);
    	}else{
      		$("#parentId").val(parentId);
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
    if ($("#sort").val() === "") {
      $("#sort").val("1");
    }
  });
  // 确定提交
  function OK() {
	if($("#parentId").val() == "" || $("#parentId").val() == null){
		$.alert("上级分类不能为空！");
		return false;
	}
	if($("#parentId").val() == $("#id").val()){
		$.alert("分类的上级不能是该分类本身！");
		return false;
	}
    var frmobj = $("#categoryForm").formobj();
    var valid = $._isInValid(frmobj);
    // 检查描述
    var checkLength = $("#description").val().length - 60;
    if(checkLength > 0){
      $("#descriptionDiv").attr("title",$.i18n('my.resource.js',$("#description").val().length));
      $("#descriptionTd span").attr("title",$.i18n('my.resource.js',$("#description").val().length));
    }
    frmobj.valid = valid;
    //如果原本是协同的。这里的parentId还是原来的吧。
    if("${parentId}" == "1"){
    	//如果是根目录就改成协同根目录吧，其他就不用
    	if($("#parentId").val() == "2"){
	    	frmobj.parentId = "${parentId}";
    	}
		frmobj.type = "${categoryType}";
    }
    return frmobj;
  }
</script>
</head>

<body scroll="no" onkeydown="listenerKeyESC()">
  <form id="categoryForm" name="categoryForm" method="post" action="${path}/template/template.do?method=saveCategory">
    <input type="hidden" id="id" name="id" value="${id}"> 
    <input type="hidden" name="type" value="${categoryType}"> 
    <input type="hidden" name="orgAccountId" value="${CurrentUser.loginAccount}"> 
    <input type="hidden" name="createMember" value="${CurrentUser.id}"> 
    <input type="hidden" name="modifyMember" value="${CurrentUser.id}">
    <input type="hidden" name="auth" value="${categoryAuth}">
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.parentcategory.label')}:</label></th>
              <td width="87%">
                  <select name="parentId" id="parentId" class="common_drop_down w100b">
                   ${formTemplateCategorys}
                  </select>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.name.label')}:</label></th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="name" type="text" value="${name }" class="validate" maxlength="30"
                    validate="name:'${ctp:i18n('template.newcategory.name.label')}',maxLength:30,isDeaultValue:true,notNullWithoutTrim:true,notNull:true,deaultValue:'\<${ctp:i18n('template.newcategory.fillname.label')}\>'">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('template.newcategory.sortnumber.label')}:</label></th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" value="${sort }" class="validate"
                    validate="name:'${ctp:i18n('template.newcategory.sortnumber.label')}',isInteger:true,notNull:true,max:9999,min:-9999">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('form.trigger.triggerSet.description.label')}:</label></th>
              <td id="descriptionTd">
                <div id="descriptionDiv" class="common_txtbox clearfix">
                  <textarea id="description" class="w100b validate" cols="30" rows="7" validate="name:'${ctp:i18n('form.trigger.triggerSet.description.label')}',maxLength:60">${description}</textarea>
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