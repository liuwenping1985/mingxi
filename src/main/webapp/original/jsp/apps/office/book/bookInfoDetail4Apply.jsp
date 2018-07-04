<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/book/bookInfoDetail4Apply.js"></script>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout h100b font_size12">
		<div class="stadic_layout_head stadic_head_height"></div>
		<div id="tableDiv"
			class="stadic_layout_body stadic_body_top_bottom margin_b_10">
			<!--中间区域-->
			<div id="bookInfoDiv" class="form_area set_search align_center">
				<div id="mainbookInfo">
					<input id="id" name="id" type="hidden" />
					<table border="0" cellSpacing="0" cellPadding="0" align="center"
						class="w80b" style="table-layout:fixed;">
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.num.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookInfoVO.bookNum }"
										disabled="disabled" type="text" />
								</div></td>
							<td colspan="3" rowspan="6" align="right"><input
								type="hidden" id="bookImage" name="bookImage" value="${bookInfoVO.bookImage}" />
								<div id="imageDiv"></div>
								<div id="dyncid"></div>
							</td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.asset.apply.assetName.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookName" class="validate font_size12"
										maxlength="15" value="${bookInfoVO.bookName }"
										disabled="disabled" type="text" />
								</div></td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.type.js') }:</th>
							<td colspan="2">
								<div class="common_selectbox_wrap">
                                    <input type="hidden" id="bookType" value="${bookInfoVO.bookType}"/>
	                				<select disabled="disabled"  id="" name="" class="font_size12" >
	                					<option>${bookInfoVO.bookType_txt }</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookName" class="validate font_size12" -->
<%-- 										maxlength="15" value="${bookInfoVO.bookType_txt }" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div></td> -->
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.author.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookAuthor" name="bookAuthor" maxlength="15"
										class=" font_size12"
										value="${bookInfoVO.bookAuthor}" type="text"
										disabled="disabled" />
								</div></td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.publisher.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookPublisher" name="bookPublisher" maxlength="15"
										class=" font_size12"
										value="${bookInfoVO.bookPublisher}"
										disabled="disabled" type="text" />
								</div></td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.publishdate.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookPublishTime" disabled="disabled"
										value="${bookInfoVO.bookPublishTime}" name="bookPublishTime"
										type="text" 
										readonly="readonly" validate="name:'出版日期'" />
								</div></td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.price.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookPrice" name="bookPrice" maxlength="15"
										class="font_size12" value="${bookInfoVO.bookPrice}"
										type="text" readonly="readonly" disabled="disabled" />
								</div></td>
							<th noWrap="nowrap" align="right"></th>
							<td colspan="2" align="right"></td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right" valign="top">${ctp:i18n('office.bookinfo.summary.js') }:</th>
							<td colspan="5" align="left">
								<div>
									<textarea id="bookSummary" disabled="disabled" name="bookMemo"
										maxlength="1000" style="width: 102%; height: 60px;">${bookInfoVO.bookSummary}</textarea>
								</div></td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.stock.countsum.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookCount" name="bookCount" class="validate font_size12"
										maxlength="15" value="${bookInfoVO.bookCount}"
										disabled="disabled" type="text" />
								</div></td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.stock.unit.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookUnit" name="bookUnit" class="validate font_size12"
										maxlength="15" value="${bookInfoVO.bookUnit}"
										disabled="disabled" type="text" />
								</div>
							</td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right"><label for="text">${ctp:i18n('office.bookhouse.js') }:
							</th>
							<td colspan="2">
								<div class="common_selectbox_wrap">
	                				<select disabled="disabled"  id="" name="" class="font_size12" >
	                					<option>${bookInfoVO.houseName}</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookUnit" name="bookUnit" class="validate font_size12" -->
<%-- 										maxlength="15" value="${bookInfoVO.houseName}" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div> -->
							</td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.category.js') }:</th>
							<td>
								<div class="common_selectbox_wrap">
	                				<select disabled="disabled"  id="bookUnit" name="" class="font_size12" >
	                					<option>${bookInfoVO.bookCategoryStr }</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookUnit" name="bookUnit" class="validate font_size12" -->
<%-- 										maxlength="15" value="${bookInfoVO.bookCategoryStr}" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div> -->
							</td>
								
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.asset.selectAsset.gly.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookUnit" name="bookUnit" class="validate font_size12"
										maxlength="15" value="${bookInfoVO.admins}"
										disabled="disabled" type="text" />
								</div></td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>