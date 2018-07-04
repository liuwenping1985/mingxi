<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/office/officeHeader.jsp"%>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${ctp:i18n('office.book.bookStcInfoShow.tsk.js')}</title>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/pub/bookPub.js${ctp:resSuffix()}"></script>
<script type="text/javascript" charset="UTF-8"
	src="${path}/apps_res/office/js/book/bookInfoDetail4Remand.js"></script>
</head>
<body class="h100b over_hidden">
	<div class="stadic_layout h100b font_size12">
		<div class="stadic_layout_head stadic_head_height"></div>
		<div id="tableDiv"
			class="stadic_layout_body stadic_body_top_bottom margin_b_10">
			<!--中间区域-->
			<div id="bookInfoDiv" class="form_area set_search align_center">
				<div id="mainbookInfo">
					<input id="id" name="id" type="hidden" value="${bookApplyVO.bookApplyPO.id}" />
					<table border="0" cellSpacing="0" cellPadding="0" align="center"
						 style="table-layout:fixed; width:95%;">
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.num.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.bookInfoVO.bookNum }"
										disabled="disabled" type="text" />
								</div>
							</td>
							<td colspan="3" rowspan="6" align="right"><input
								type="hidden" id="bookImage" name="bookImage" value="${bookApplyVO.bookInfoVO.bookImage }" /> 
																<div id="imageDiv" style="text-align: center;"></div>
																<div id="dyncid"></div></td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.asset.apply.assetName.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookName" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.bookInfoVO.bookName }"
										disabled="disabled" type="text" />
								</div>
							</td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.type.js') }:</th>
							<td colspan="2">
								<div class="common_selectbox_wrap">
                                    <input type="hidden"  value="${bookApplyVO.bookInfoVO.bookType}" id="bookType"/>
	                				<select disabled="disabled"  id="" name="" class="font_size12" >
	                					<option>${bookApplyVO.bookInfoVO.bookType_txt }</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookName" class="validate font_size12" -->
<%-- 										maxlength="15" value="${bookApplyVO.bookInfoVO.bookType_txt }" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div> -->
							</td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.author.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookAuthor" name="bookAuthor" maxlength="15"
										class=" font_size12"
										value="${bookApplyVO.bookInfoVO.bookAuthor}" type="text"
										disabled="disabled" />
								</div>
							</td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.publisher.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookPublisher" name="bookPublisher" maxlength="15"
										class=" font_size12"
										value="${bookApplyVO.bookInfoVO.bookPublisher}"
										disabled="disabled" type="text" />
								</div>
							</td>
						</tr>

						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookhouse.js') }:</th>
							<td>
								<div class="common_selectbox_wrap">
	                				<select disabled="disabled"  id="" name="" class="font_size12" >
	                					<option>${bookApplyVO.bookInfoVO.houseName}</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookPublisher" name="bookPublisher" maxlength="15" -->
<!-- 										class=" font_size12" -->
<%-- 										value="${bookApplyVO.bookInfoVO.houseName}" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div> -->
							</td>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.bookinfo.category.js') }:</th>
							<td colspan="2">
								<div class="common_selectbox_wrap">
	                				<select disabled="disabled"  id="bookPublisher" name="" class="font_size12" >
	                					<option>${bookApplyVO.bookInfoVO.bookCategoryStr }</option>
	                				</select>
	                			</div>
<!-- 								<div class="common_txtbox_wrap"> -->
<!-- 									<input id="bookPublisher" name="bookPublisher" maxlength="15" -->
<!-- 										class=" font_size12" -->
<%-- 										value="${bookApplyVO.bookInfoVO.bookCategoryStr}" --%>
<!-- 										disabled="disabled" type="text" /> -->
<!-- 								</div> -->
							</td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.psqr.js') }:</th>
							<td colspan="2"><div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.applyUser}"
										disabled="disabled" type="text" />
								</div></td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.pkcsl.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.bookInfoVO.bookCount}"
										disabled="disabled" type="text" />
								</div></td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.psqbm.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.applyDept}"
										disabled="disabled" type="text" />
								</div>
							</td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.pjysl.js') }:</th>
							<td colspan="2">
								<div class="common_txtbox_wrap">
									<input id="bookNum" name="bookNum" class="validate font_size12"
										maxlength="15" value="${bookApplyVO.bookApplyPO.applyTotal }"
										disabled="disabled" type="text" />
								</div></td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.pjyqj.js') }:</th>
							<td align="left" colspan="2">
                                <table border="0"  style="width: 100%;table-layout:fixed;" >
                                    <tr>
                                        <td align="left"  nowrap="nowrap">
                                            <div class="clearfix">
                                                <div id="recordDate0Div" name="recordDate0Div" class="common_txtbox_wrap">
                                                    <input id="recordDate0" disabled="disabled"
                                                        comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"
                                                        comptype="calendar" readonly="readonly"
                                                        class="comp font_size12" style="width: 98%" type="text" readonly value="${bookApplyVO.startDate}">
                                                </div>
                                            </div>
                                        </td>
                                        <td align="left" width="20"><span class="margin_lr_5 margin_t_5 left">${ctp:i18n('office.book.bookInfoDetail4Audit.pz.js') }</span></td>
                                       <td align="left">
                                            <div id="recordDate1Div" name="recordDate1Div" class="common_txtbox_wrap">
                                                <input id="recordDate1" disabled="disabled"
                                                    comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"
                                                    comptype="calendar" readonly="readonly"
                                                    class="comp font_size12" style="width: 98%" type="text" readonly value="${bookApplyVO.endDate}">
                                            </div>
                                       </td>
                                     </tr>
                                 </table>
                            </td>
						</tr>




						<tr>
							<th noWrap="nowrap" align="right" valign="top">${ctp:i18n('office.book.bookInfoDetail4Audit.pbz.js') }:</th>
							<td colspan="5" align="left">
								<div>
									<textarea id="bookSummary" disabled="disabled" name="bookMemo"
										maxlength="1000" style="width: 102%; height: 40px;">${bookApplyVO.bookApplyPO.applyDesc}</textarea>
								</div></td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right" valign="top"></th>
							<td colspan="5" align="left">&nbsp;</td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right" valign="top">${ctp:i18n('office.book.bookInfoDetail4Audit.pspyj.js') }:</th>
							<td colspan="5" align="left">
								<div>
									<textarea id="bookSummary" disabled="disabled" name="bookMemo"
										maxlength="1000" style="width: 102%; height: 40px;">${bookApplyVO.auditOpinion}</textarea>
								</div></td>
						</tr>
						<tr>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Audit.ptgbjc.js') }:</th>
							<td colspan="2">
								<div id="lendedDateDiv" class="common_txtbox_wrap">
									<input id="lendedDate" name="lendedDate" class="comp validate font_size12"
										comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"
										comptype="calendar" readonly="readonly"
										maxlength="15" value="${bookApplyVO.lendedDate }"
										disabled="disabled" style="width: 98%" type="text" />
								</div></td>
							<th noWrap="nowrap" align="right">${ctp:i18n('office.book.bookInfoDetail4Remand.pghsj.js') }:</th>
							<td  align="right" colspan="2">
								<input type="hidden" id="bookApplyStateFlag" name="bookApplyStateFlag"  value="${bookApplyVO.bookApplyPO.bookApplystate}" >
								<div id="rebackDateDiv" class="common_txtbox_wrap">
									<input id="rebackDate" name="rebackDate" type="text" class="comp validate"
										comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"
										validate="name:'归还时间',notNull:true"
										comptype="calendar" readonly="readonly" style="width: 98%" value="${bookApplyVO.rebackDate}" />
								</div>
							</td>
						</tr>
						<tr>
					</table>
				</div>
			</div>
		</div>
		<c:if test="${bookApplyVO.bookApplyPO.bookApplystate != '30'}">
			<div id="btnDiv" class="stadic_layout_footer stadic_footer_height padding_tb_5 align_right bg_color_black">
			 <a id="btnok" class="common_button common_button_emphasize" href="javascript:void(0)" onclick="javascript:fnOK('remand')">${ctp:i18n('office.book.bookInfoDetail4Remand.pgh.js') }</a> 
				&nbsp;
			</div>
		</c:if>
	</div>
</body>
</html>