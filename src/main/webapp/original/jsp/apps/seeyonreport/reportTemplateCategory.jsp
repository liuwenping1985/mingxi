<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/common/seeyonreport/reporttemplatemanager_ajax.js${ctp:resSuffix()}"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script>
  $(function() {
    var parentId = "${parentId}";
    var level = "${level}";
    //是否单位管理员
    var isAdmin = "${isAdmin}"
    
    //定义模板分类相关动作
    //点击此处填写名称
    var info = "<" + $.i18n('seeyonreport.report.template.newcategory.fillname.label')+">";
    var nameObj = $("#name");
    if (nameObj.val() === "") {
    	nameObj.val(info);
    }
    nameObj.focus(function() {
      if(nameObj.val() === info) {
    	  nameObj.val("");
      }
    });
    nameObj.blur(function() {
      if(nameObj.val() === "") {
    	  nameObj.val(info);
      }
    });
    //初始化人员信息
    if ($("#auth").val() === "") {
        $("#auth").comp({
          value : "",
          text : "<"+$.i18n('seeyonreport.report.template.newcategory.selectmember.label')+">"
        });
    }
    
    //将下来列表职位选中状态
    if(parentId != ""){
    	$("#parentId option[value='"+parentId+"']").attr("selected", true);
    }
  	//如果是编辑模板分类
	if("${editFlag}" == "true"){
		//初始化人员信息
	    $("#auth").comp({
	        value : "${authvalue}",
	        text : "${authtxt}"
	    });
	    
		if(level > 1){
			$("#authTd").hide();
		}
	}else{
		//当如果不是在顶级分类下建模板时，不能授权,如果不是单位管理员时不能授权
	    if(level > 0 || isAdmin == "false"){
	    	//隐藏授权
	    	$("#authTd").hide();
	    }
	}
    
    //模板分类 chang事件
    $("#parentId").change(function(){
    	var cm = new seeyonReportTemplateManager();
    	var obj = new Object();
    	obj.id = $("#parentId").val();
    	cm.getReportTemplateCategoryForAjax(obj,{
            success : function(returnVal){
            	//更改当前分类的级别
            	$("#level").val(returnVal.level + 1);
                if(returnVal.level == 0){
                    $("#authTd").show();
                }else{
                    $("#authTd").hide();
                }
            }, 
            error : function(request, settings, e){
                    $.alert(e);
            }
         });
    	//授权提示
        $("#auth").comp({
          value : "",
          text : "<${ctp:i18n('seeyonreport.report.template.newcategory.selectmember.label')}>"
        });
      });
  });
  // 确定提交
  function OK() {
    var frmobj = $("#categoryForm").formobj();
    var valid = $("#categoryForm").validate();
    // 检查描述
    var checkLength = $("#description").val().length - 60;
    if(checkLength > 0){
        //描述不能多于60个字，当前共有"+$("#description").val().length+"个字
        $("#descriptionDiv").attr("title","${ctp:i18n_1('seeyonreport.report.template.systemCategory.descriptionMore60','"+$("#description").val().length+"')}");
        $("#descriptionTd span").attr("title","${ctp:i18n_1('seeyonreport.report.template.systemCategory.descriptionMore60','"+$("#description").val().length+"')}");
    }
    var selectText = $("#parentId").find("option:selected").text();
    if(selectText == ""){
    	$.alert($.i18n('seeyonreport.report.template.category.choosecategory'));
    	return;
    }
    frmobj.valid = valid;
    return frmobj;
  }
</script>
</head>

<body scroll="no">
  <form id="categoryForm" name="categoryForm" >
  	<input type="hidden" id="level" name="level" value="${level}"> 
  	<!-- 用于编辑分类时判断是否重复 -->
  	<input type="hidden" id="id" name="id"> 
    <div class="form_area" id="formArea">
      <div class="one_row">
        <table border="0" cellSpacing="0" cellPadding="0">
          <tbody>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<!-- 上级分类 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.parentcategory.label')}:
              	</label>
              </th>
              <td width="87%">
                  <select name="parentId" id="parentId" class="input-100per cursor-hand w100b">${categoryHTML}</select>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<!-- 名称 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.name.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="name" type="text" class="validate" maxlength="30"
                    validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.name.label')}',maxLength:30,isDeaultValue:true,notNull:true,deaultValue:'\<${ctp:i18n('seeyonreport.report.template.newcategory.fillname.label')}\>'">
                </div>
              </td>
            </tr>
            <tr id="authTd">
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<!-- 授权 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.authorization.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap" id="canauth">
                  <input type="text" id="auth" name="auth" class="comp"
                    comp="type:'selectPeople',panels:'Department',minSize:'0',selectType:'Member',mode:'open',onlyLoginAccount:true,value:'',text:''" />
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap">
              	<label class="margin_r_10" for="text">
              		<!-- 排序号 -->
              		${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}:
              	</label>
              </th>
              <td>
                <div class="common_txtbox_wrap">
                  <input id="sort" type="text" class="validate"
                    validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.sortnumber.label')}',isInteger:true,notNull:true,max:9999,min:-9999">
                </div>
              </td>
            </tr>
            <tr>
              <th noWrap="nowrap" valign="top">
              	<label class="margin_r_10" for="text">
              		${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}:
              	</label>
              </th>
              <td id="descriptionTd">
                <div id="descriptionDiv" class="common_txtbox clearfix">
                  <textarea id="description" class="w100b validate" cols="30" style="height:145px;" validate="name:'${ctp:i18n('seeyonreport.report.template.newcategory.describe.label')}',maxLength:60"></textarea>
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