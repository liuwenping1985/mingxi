<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">

<head>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<style type="text/css">
input{
	background:expression((this.disabled && this.disabled==true)?"black":"");
}
</style>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8" src="${path}/apps_res/office/js/book/bookDoLib.js"></script>
<style type="text/css">
</style>
</head>
<body class="h100b over_hidden">
	<div id='layout' class="comp page_color" comp="type:'layout'">
		<div class="layout_north" layout="height:30,sprit:false,border:false">
			<div id="toolbar">
				<div class="common_toolbar_box clearfix"
					style="border: 0px solid rgb(182, 182, 182); _display: inline;">
					<div align="right">
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td><input name="_officeSBar_input" class="search_input color_gray"
									id="_officeSBar_input" type="text"  value="${ctp:i18n('office.book.bookLib.smzz.js') }" ></td>
								<td width="28px"><a
									class="common_button common_button_grayDark search_buttonHand"
									href="javascript:void(0)" onclick="javascript:searchByCondition();"><em class="ico16 search_16"></em></a></td>
							</tr>
						</table>
					</div>
				</div>
			</div>
		</div>
		<!-- 这是是tree -->
		<div
			class="layout_west bg_color_white stadic_layout_body stadic_body_top_bottom"
			id="west" layout="width:200">
			<div id="bookTree"></div>
		</div>
		<div class="layout_center bg_color_white over_hidden"
			style="color: white;" layout="border:false" align="center" id="bookLibDiv">
			<form action="">
				<div id="bookLib" class="" style="overflow-y: auto; overflow-x:hidden;height: 393px; width: 100%"></div>
			</form>
		</div>
		<div id="dyncid"></div>
		<input type="hidden" id="_afpPage">
		<input type="hidden" id="_afpPages">
		<input type="hidden" id="_afpSize">
		<input type="hidden" id="_afpTotal">
	</div>
</body>
<script type="text/javascript">
$('#bookLib').height(document.documentElement.clientHeight -45);
</script>
</html>