<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
$().ready(function() {
    $("#exportDptmember").click(function() {
        if(oManager.getOrgExportFlag() || oManager.getOrgExportFlag() == 'true') {
            $.alert("后台正在进行导入导出操作，请耐心等待！");
            return;
        } else {
            $.alert({
              'title': "${ctp:i18n('common.prompt')}",
              'msg': "${ctp:i18n('member.export.prompt.wait')}",
              ok_fn: function() {
                var downloadUrl_e ="${path}/organization/department.do?method=exportDepartmentMember&deptId="+$("#id").val();
                var eurl_e= "<c:url value='"+downloadUrl_e+"' />";
                exportIFrame.location.href = eurl_e;
              }
            });
        }
    });
    $("#detailDeptPosts").click(function() {
           var dialog = $.dialog({
            id: 'html',
            targetWindow:top,
            isDrag:false,
            url: '${path}/organization/department.do?method=editDeptPosts&id='+$("#id").val(),
            title: "${ctp:i18n('org.dept.members.info')}",
            buttons: [{
                id: 'ok',
                text: "${ctp:i18n('common.button.ok.label')}",
                handler: function () {
                    dialog.close();
                }
            }]
        });
    });
});
</script> 
</head>
<body>
    <form name="addForm" id="addForm" method="post" target="addDeptFrame"
        action="${path}/organization/department.do?method=createDept&islist=${islist}">
        <div class="form_area" >
		<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
		<div class="">
			<table width="60%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
					<input type="hidden" name="id" id="id" value="" />
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><strong>${ctp:i18n('org.dept_form.fieldset1Name.label')}</strong></label></th>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.dept_form.name.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="name" class="validate"
									validate="type:'string',name:'${ctp:i18n('org.dept_form.name.label')}', notNullWithoutTrim:true, minLength:1, maxLength:100,avoidChar:'\'&quot\%|,\/\\'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.dept_form.code.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="code" maxlength="20" class="validate"
									validate="type:'string',name:'${ctp:i18n('org.dept_form.code.label')}', notNull:false, minLength:1">
							</div>
						</td>
					</tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.dept_form.level.label')}:</label></th>
                        <td>
                            <div class="common_txtbox_wrap">
                                <input type="text" id="deptLevel" readonly="readonly">
                            </div>

                        </td>
                    </tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('common.sort.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="sortId" class="validate"
									validate="isInteger:true,minValue:1,maxValue:99999,name:'${ctp:i18n('common.sort.label')}',notNull:true">
							</div>

						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.sort.repeat.deal')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="1" name="sortIdtype" id="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.insert')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="0" name="sortIdtype" id="sortIdtype"
									class="radio_com">${ctp:i18n('org.sort.repeat')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.dept_form.superDepartment.label')}:</label></th>
						<td>
							<div class="common_txtbox_wrap">
								<input type="text" id="superDepartment" class="comp validate" validate="type:'string',name:'${ctp:i18n('org.dept_form.superDepartment.label')}',
								notNull:true,minLength:1,maxLength:500" comp="type:'selectPeople',panels:'Department',selectType:'Department,Account',maxSize:'1',onlyLoginAccount:true"/> 
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('common.state.label')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio"  value="true" name="enabled" id="enabled"
									class="radio_com">${ctp:i18n('common.state.normal.label')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio"  value="false" name="enabled" id="enabled"
									class="radio_com">${ctp:i18n('common.state.invalidation.label')}
								</label>
							</div>
						</td>
					</tr>
					<tr id="trDeptSpace">
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color="red">*</font>${ctp:i18n('org.dept_form.isCreateDeptSpace.label')}:</label></th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand"> <input
									type="radio" value="true" name="createDeptSpace" id="createDeptSpace"
									class="radio_com">${ctp:i18n('common.yes')}
								</label> <label class="margin_r_10 hand"> <input
									type="radio" value="false" name="createDeptSpace" id="createDeptSpace"
									class="radio_com">${ctp:i18n('common.no')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><strong>${ctp:i18n('org.dept.info.management')}</strong></label></th>
					</tr>
					<script> 
					var dManager = new departmentManager();
				    var rolelist = dManager.getDepRoles()["deproles"];
						for(i=0;i<rolelist.length;i++){
							document.write("<tr><th width='30%' style='padding:5px;line-height:120%;'><label id=\"role"+i+"\" class=\"margin_r_10\" for=\"text\"></label></th><td><div class=\"common_txtbox_wrap\">"+
									"<input type=\"text\" id=\"deptrole"+i+"\" class=\"comp\" comp=\"type:\'selectPeople\',minSize:0,onlyLoginAccount:true,isNeedCheckLevelScope:false,panels:\'Department\',selectType:\'Member\'\"></div></td></tr>");
							$("#role"+i).text(rolelist[i]['showName']+":");	
							  
						}
					</script> 
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('org.dept_form.post_fieldset.label')}:</label></th>
						<td>
							<div style="height: 20px" class="common_txtbox_wrap clearfix">
								<!-- <input type="text" id="post_fieldset"> -->
								<input type="text" id="deptpost" class="comp" comp="type:'selectPeople',panels:'Post',minSize:0,selectType:'Post',onlyLoginAccount:true"/>
							</div>
						</td>
					</tr>
					<tr >
					<td>
					</td>
					<td>
					<div id="viewbutton">
					<a id="detailDeptPosts" class="img-button margin_r_0">${ctp:i18n('org.dept.members.check')}</a>
					<a id="exportDptmember" class="img-button margin_r_0">${ctp:i18n('org.dept.members.export')}</a>				
					</div>
					</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('common.description.label')}:</label></th>
						<td>
							<div class="common_txtbox clearfix word_break_all"><textarea id="description" name="description" style="width:100%;height:50px;" class="validate" validate="type:'string',name:'${ctp:i18n('common.description.label')}',maxLength:200"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<td align="right"></td>
					</tr>
				</tbody>
			</table>
		</div>
		</div>
	</form>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>

</body>
</html>