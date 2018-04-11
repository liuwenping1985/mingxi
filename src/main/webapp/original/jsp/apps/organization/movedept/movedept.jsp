<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../../common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=moveDeptManager"></script>
<script type="text/javascript">
$().ready(function() {
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#btnok").click(function() {
    if (! ($("#addForm").validate())) {
      return;
    }
    $.progressBar();
    $("#addForm").jsonSubmit({debug:false});
  });

});
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
        <div class="comp" comp="type:'breadcrumb',code:'T02_showMoveDeptframe'">
        </div>
        <div class="layout_center over_hidden" layout="border:false" id="center">
        	<div id="gridDiv">
        		<table id="resultLogs" class="flexme3" style="display: none"></table>
        	</div>
            <div id="postform" class="form_area">
                <br>
                <br>
                <br>
                <br>
                <br>
                <form name="addForm" id="addForm" method="post" target="addDeptFrame" action="moveDeptController.do?method=moveDepts">
                    <div class="one_row">
                        <fieldset>
                            <legend>
                                ${ctp:i18n('org.dept.ajust')}
                            </legend>
                            <table border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                    <input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
                                    <input type="hidden" name="id" id="id" value="" />
                                    <tr>
                                        <th nowrap="nowrap">
                                            <label class="margin_r_10" for="text">
                                                ${ctp:i18n('org.dept.ajust')}:
                                            </label>
                                        </th>
                                        <td width="100%">
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="deptIds" class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Department',selectType:'Department'"
                                                validate="type:'string',name:'${ctp:i18n('org.dept.ajust')}',notNull:true,minLength:1,maxLength:500">
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th nowrap="nowrap">
                                            <label class="margin_r_10" for="text">
                                                ${ctp:i18n('org.dept.call')}
                                            </label>
                                        </th>
                                        <td>
                                            <div class="common_txtbox_wrap">
                                                <input type="text" id="accountId" class="comp validate" comp="type:'selectPeople',mode:'open',panels:'Account',selectType:'Account',maxSize:'1',isCanSelectGroupAccount:false"
                                                validate="type:'string',name:'${ctp:i18n('org.dept.call')}',notNull:true,minLength:1,maxLength:100">
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </fieldset>
                    </div>
                </form>
            </div>
            <div id="button" align="center" class="stadic_layout_footer stadic_footer_height page_color_bottom">
                <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">
                    ${ctp:i18n('common.button.ok.label')}
                </a>
                <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">
                    ${ctp:i18n('common.button.cancel.label')}
                </a>
            </div>
        </div>
    </div>
</body>

</html>