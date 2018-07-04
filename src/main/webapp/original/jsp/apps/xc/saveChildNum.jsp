<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=findChildNum"></script>
<!DOCTYPE html>
<html class="over_hidden">
<head>
<style>
.stadic_body_top_bottom{
    bottom: 30px;
    top: 0px;
}
.stadic_footer_height{
    height:30px;
}
</style>

<script type="text/javascript" src="${path}/ajax.do?managerName=orgManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=xcSynManager"></script>
<script type="text/javascript" language="javascript">
function OK() {
	var num=$("#num").val();
	var childnumdesc=$("#desc").val();
	return {"num":num,"childnumdesc":childnumdesc};
}	
</script>
</head>
<body>
<form name="addForm" id="addForm" method="post" target="" class="validate">
	<div class="form_area" id='form_area'>
		<form id="memberBatForm" name="memberBatForm" method="post" action="xcController.do?method=child_num">
			<div class="align_center clearfix">
				<table width="90%" border="0" cellspacing="0" cellpadding="0" class="margin_l_15">
	<input type="hidden" id="childnumIds" name="childnumIds" value=""/>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font color='red'>*</font>${ctp:i18n('xc.SubAccountName.add.list')}</label><!--授权人员-->
						</th>
						<td width="80%"><div class="common_txtbox_wrap">
								<input type="text" id="num" name="num" class="validate" validate="name:'子账户',maxLength:100" maxlength="100"/>
							</div>
						</td>
					<tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">${ctp:i18n('xc.SubAccountName.desc')}</label></th>
						<td>
							<div class="common_txtbox  clearfix">
								<textarea cols="30" rows="7" class="validate" validate="name:'描述信息',maxLength:100" id="desc" ></textarea>
							</div>
						</td>
					</tr>
					<!-- 批量人员修改 end -->
				</table>
			</div>
		   
		</form>
	</div>
</form>
</body>
</html>