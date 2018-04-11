<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<script type="text/javascript">
	$().ready(function(){
		//$("#startTime").attr("dateString",new Date().print("%Y-%m-%d %H:%M"));
	});
</script>
<body>

	<form name="addForm" id="addForm" method="post" target="_add">
					<div class="form_area">
						<div class="one_row" style="width:70%;">
							<fieldset id="form_head" style=" width: 100%;border: 1; height: 280px; ">
								<legend>
									&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('cip.org.sync.config.org')}</b></font>&nbsp;&nbsp;
								</legend>
								<div  style="width: 100%;border: 0px; height: 270px;overflow:auto;" align="left">
							        <table id="handtable" class="flexme3" border="0" cellspacing="0"  cellpadding="0" width="100%" style="table-layout: fixed;margin-top: 5px;">
							        <tbody class="hand">
							        	<tr bgcolor="#80aad4" style="font-size: 12px;font-family: Microsoft YaHei; white-space: nowrap;">
							        		<td width="6%" align="center"><input type="checkbox" id="checkbox"></td>
							        		<td width="20%">${ctp:i18n('cip.scheme.param.init.sync')}</td>
							        		<td width="20%">${ctp:i18n('cip.scheme.param.init.third')}</td>
							        		<td width="17%">${ctp:i18n('cip.org.sync.config.org2')}</td>
							        		<td width="17%">${ctp:i18n('cip.org.sync.config.org3')}</td>
							        		<td width="20%">${ctp:i18n('cip.scheme.param.init.range')}</td>
							        	</tr>
							        	<c:forEach	items="${initList}" var="init">
							        		<tr class="dataTr">
								        		<td align="center" width="6%">
								        			<input type="checkbox" name="initId" value="${init.id}">
								        		</td>
								        		<td width="20%" class="dataTd" nowrap="nowrap">
								        			<lable title="${ctp:toHTML(init.schemeName)}">
								        				${ctp:toHTML(init.schemeName)}
													</lable>
								        		</td>
								        		<td width="20%" class="dataTd" nowrap="nowrap">
								        			<lable title="${ctp:toHTML(init.thirdSystem)}">
								        				${ctp:toHTML(init.thirdSystem)}
													</lable>
								        		</td>
								        		<td width="17%" class="dataTd" nowrap="nowrap">
								        			<lable title="${ctp:toHTML(init.thirdOrgname)}">
								        				${ctp:toHTML(init.thirdOrgname)}
													</lable>
								        		</td>
								        		<td width="17%" class="dataTd" nowrap="nowrap">
								        			<lable title="${ctp:toHTML(init.entityName)}">
								        				${ctp:toHTML(init.entityName)}
													</lable>
								        		</td>
								        		<td width="20%" class="dataTd" nowrap="nowrap">
								        			<lable title="${ctp:toHTML(init.scopeString)}">	
								        				${ctp:toHTML(init.scopeString)}
													</lable>
								        		</td>	
							        		</tr>
							        	</c:forEach>
							        	</tbody>
							        </table>
							    </div>
							</fieldset>
							 <table  class="flexme3" border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top: 5px;">
								<tbody>
									<tr align="left">
										<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.org.sync.config.time')}:</label></th>
										<td width="30%" style="border-bottom:0px;">
												<input id="startTime" type="text"  class="comp validate" readonly="readonly" value="2000-01-01 00:01" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"/>
										</td>
										<td width="70%" style="border-bottom:0px;"></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</form>
</body>
</html>