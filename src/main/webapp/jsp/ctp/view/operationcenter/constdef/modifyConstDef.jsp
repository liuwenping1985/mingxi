<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/view/operationcenter/constdef/modifyConstDef_js.jsp"%>
<html>
<head>
<title></title>
<style>
textarea{
    height: 100%;
    width: 100%;
   -webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */
    -moz-box-sizing: border-box;    /* Firefox, other Gecko */
    box-sizing: border-box;         /* Opera/IE 8+ */
}
</style>
</head>
<body>
	<div>
		<div>
			<form id="myfrm" name="myfrm" method="post">
				<div class="form_area" id='form_area'>

					<input type="hidden" id="constId" name="constId" /> 

					<table border="0" cellspacing="0" cellpadding="0"
						class="margin_lr_10 margin_t_10" align="center" width="330">

						<tr>
							<th><font color="red">*</font><label class="margin_r_10"
								for="text">常量名:</label></th>
							<td>
								<div class="common_txtbox_wrap">
									<input type="text" id="constKey" class="validate"
										validate="type:'string',name:'constKey',notNull:true" readonly style="color: darkgray"/>
								</div>
							</td>
						</tr>
						<tr>
							<th><font color="red">*</font><label class="margin_r_10"
								for="text">常量定义:</label></th>
							<td>
								<div class="common_txtbox_wrap">
									<input type="text" id="constDefine" class="validate"
										validate="type:'string',name:'constDefine',notNull:true" />
								</div>
							</td>
						</tr>
						<tr>
							<th><font color="red">*</font><label class="margin_r_10"
								for="text">常量类型:</label></th>
							<td>
								<input type="radio" id="constType" class="constType1" name="constType" value="1"/>数值
								<input type="radio" id="constType" class="constType2" name="constType" value="2"/>字符
								<input type="radio" id="constType" class="constType3" name="constType" value="3"/>表达式
								<input type="radio" id="constType" class="constType4" name="constType" value="4"/>宏替换
							</td>
						</tr>

						<tr>
							<th><label class="margin_r_10" for="text">常量描述:</label></th>
							<td>
								<textarea name="constDescription" id="constDescription"
									rows="4" cols="33" inputName="constDescription"
									style="font-size: 12px;padding-left: 5px;">${constDescription}</textarea>

							</td>
						</tr>
					</table>
				</div>
			</form>
		</div>
	</div>
</body>
</html>