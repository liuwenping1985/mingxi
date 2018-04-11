<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<form name="addForm" id="addForm" method="post" target=""
		class="validate">
		<div class="form_area">
			<div class="one_row" style="width: 50%;">
				<input type="hidden" id="selectType" /> <input type="hidden"
					id="nodeChildrenIds" /> <input type="hidden" id="interfaceId" />
				<input type="hidden" id="masterId" />
				<table>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.product')}:</label></th>
						<td width="100%"><input type="text" id="productFlag"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.product')}'"
							disabled="disabled"></input></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.base.interface.detail.type')}:</label></th>
						<td width="100%"><input type="text" id="typeName"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.base.interface.detail.type')}'"
							disabled="disabled"></input></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.localAgent.lab.interfacename')}:</label></th>
						<td width="100%">
							<div id="d1">
								<input type="text" id="interfaceDetName" class="w70b validate"
									validate="type:'string',name:'${ctp:i18n('cip.localAgent.lab.interfacename')}'"
									onclick="showInterface()"> <a href="javascript:void(0)"
									onclick="detailInterface()"
									class="common_button common_button_gray">${ctp:i18n('cip.localAgent.but.search')}</a>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.localAgent.lab.adapterselect')}:</label></th>
						<td width="100%">
							<div class="common_selectbox_wrap">
								<select id="adaptorSelect" class="w50b validate"
									onchange="getAdaptor()"></select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.localAgent.lab.agentface')}:</label></th>
						<td width="100%"><input type="text" id="agentInterface"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.localAgent.lab.agentface')}'"
							disabled="disabled" /></td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.localAgent.lab.param')}:</label></th>
						<td width="100%">
							<table id="appTable" class="only_table" border="0" width="100%">
								<thead>
									<tr>
										<th width="10%">${ctp:i18n('cip.localAgent.lab.param1')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param2')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param3')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param4')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param5')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param6')}</th>
										<th width="15%">${ctp:i18n('cip.localAgent.lab.param7')}</th>
									</tr>
								</thead>
								<tbody id="mobody">
									<tr class="autorow" id="1">
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param1"
													class="validate word_break_all"
													validate="type:'string',name:'param1'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param2"
													class="validate word_break_all"
													validate="type:'string',name:'param2'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param3"
													class="validate word_break_all"
													validate="type:'string',name:'param3'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param4"
													class="validate word_break_all"
													validate="type:'string',name:'param4'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param5"
													class="validate word_break_all"
													validate="type:'string',name:'param5'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param6"
													class="validate word_break_all"
													validate="type:'string',name:'param6'">
											</div>
										</td>
										<td>
											<div class="common_txtbox_wrap">
												<input type="text" id="param7"
													class="validate word_break_all"
													validate="type:'string',name:'param7'">
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text"><font
								color="red">*</font>${ctp:i18n('cip.localAgent.lab.agentdes')}:</label></th>
						<td width="100%"><input type="text" id="agentSimDes"
							class="w100b validate"
							validate="type:'string',name:'${ctp:i18n('cip.localAgent.lab.agentdes')}',notNull:true,maxLength:80" />
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.localAgent.lab.agentdescription')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="agentDescription" cols='2' class="validate"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.localAgent.lab.agentdescription')}',notNull:false,maxLength:300"></textarea>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.localAgent.lab.agentintroduce')}:</label></th>
						<td width="100%">
							<div class="common_txtbox clearfix">
								<textarea id="agentIntroduce" cols='2' class="validate"
									style="width: 100%; height: 80px;"
									validate="type:'string',name:'${ctp:i18n('cip.localAgent.lab.agentintroduce')}',notNull:false,maxLength:300"></textarea>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</body>
</html>