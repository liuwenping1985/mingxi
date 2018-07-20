<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body scroll="no">
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%" class="font_size12 margin_t_10">
        <tr>
            <td>
                <table cellspacing="2" cellpadding="2" width="95%" border="0">
                    <tr height="30">
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="50" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="100" class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.parent.folder.label')}：</td>
                        <td width="250" class="padding_t_10">
                            <div class="common_txtbox_wrap">
                                <input type="text" id="parentFolder" name="parentFolder" class="hand" value="" readonly="readonly" />
                                <input type="hidden" id="parentFolderId" name="parentFolderId" value="" />
                            </div>
                        </td>
                        <td width="50" class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="50" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="100" class="padding_t_10">${ctp:i18n('form.bind.set.pigeonhole.folder.label')}：</td>
                        <td width="250" class="padding_t_10">
                            <div class="common_selectbox_wrap" style="line-height: 26px;">
                                <select id="folder" name="folder" style="margin: 0px; height: 24px;">
                                    <option value=""></option>
                                    <c:forEach var="field" items="${fieldList}">
                                        <option id="${field['id']}" value="${field['name']}" display="{${field['display']}}">
                                            ${field['display']}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </td>
                        <td width="50" class="padding_t_10">&nbsp;</td>
                    </tr>
                    <tr height="80">
                        <td width="50" class="padding_t_10">&nbsp;</td>
                        <td align="right" width="100" class="padding_t_10">&nbsp;</td>
                        <td width="250" class="padding_t_10">
                            <label for="isCreate" class="hand">
                                <input type="checkbox" id="isCreate" name="isCreate" checked="checked" />
                                <span class="margin_l_5">${ctp:i18n('form.bind.set.pigeonhole.folder.create.label')}</span>
                            </label>
                        </td>
                        <td width="50" class="padding_t_10">&nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
<script type="text/javascript">
  var transParams = window.dialogArguments;
  $().ready(function() {
    $("#parentFolderId").val(transParams.parentFolderId);
    
    if (transParams.parentFolderName == "") {
      $("#parentFolder").val("${ctp:i18n('form.timeData.none.lable')}");
    } else {
      $("#parentFolder").val(transParams.parentFolderName);
    }
    
    $("#folder").val(transParams.fieldName);
    
    if (transParams.isCreate == "true") {
      $("#isCreate").attr("checked", true);
    } else {
      $("#isCreate").attr("checked", false);
    }
    
    $("#parentFolder").click(function(){
      pigeonhole(2, null, false, false, "${pigeonholeType }", "pigeonholeCallback");
    });
  });
  
  function pigeonholeCallback(re){
    if ("cancel" != re && "" != re) {
      var r = re.split(",");
      $("#parentFolder").val(r[1]);
      $("#parentFolderId").val(r[0]);
    }
  }
  
  function OK(){
    var parentFolderId = $("#parentFolderId").val();
    var folder = $("#folder").find("option:selected");
    var folderValue = $("#folder").val();
    if (parentFolderId == "" && folderValue != "") {
      $.alert("${ctp:i18n('form.bind.set.pigeonhole.parent.folder.error.label')}");
      return false;
    }
    var obj={};
    obj.parentFolderId = parentFolderId;
    obj.parentFolderName = $("#parentFolder").val();
    obj.fieldName = folderValue;
    obj.fieldDisplay = folder.attr("display");
    if ($("#isCreate").attr("checked")) {
      obj.isCreate = "true";
    } else {
      obj.isCreate = "false";
    }
    return obj;
  }
</script>
</html>