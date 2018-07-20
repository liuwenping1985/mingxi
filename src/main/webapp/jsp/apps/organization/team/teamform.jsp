<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">
function selpeople1(ret) {
  $("#teamLeader").val(ret.value);
  $("#teamMember").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamSuperVisor").val() + "," + $("#teamRelative").val()+ "," + $("#teamLeader").val() 
  });
  $("#teamSuperVisor").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamMember").val() + "," + $("#teamRelative").val()+ "," + $("#teamLeader").val()
  });
  $("#teamRelative").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamMember").val() + "," + $("#teamSuperVisor").val() + "," + $("#teamLeader").val()
  });
}
function selpeople2(ret) {
  $("#teamMember").val(ret.value);
  $("#teamLeader").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamSuperVisor").val() + "," + $("#teamRelative").val()+ "," + $("#teamMember").val()
  });	
  $("#teamSuperVisor").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value +  "," + $("#teamRelative").val() + "," + $("#teamLeader").val()+ "," + $("#teamMember").val()
  });
  $("#teamRelative").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value +  "," + $("#teamSuperVisor").val() + "," + $("#teamLeader").val()+ "," + $("#teamMember").val()
  });
}
function selpeople3(ret) {
  $("#teamSuperVisor").val(ret.value);
  $("#teamLeader").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value +  "," + $("#teamRelative").val() + "," + $("#teamMember").val()+  "," + $("#teamSuperVisor").val()
  });
  $("#teamMember").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value +  "," + $("#teamRelative").val() + "," + $("#teamLeader").val()+  "," + $("#teamSuperVisor").val()
  });
  $("#teamRelative").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamMember").val() +  "," + $("#teamLeader").val()+  "," + $("#teamSuperVisor").val()
  });
}
function selpeople4(ret) {
  $("#teamRelative").val(ret.value);
  $("#teamLeader").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamSuperVisor").val()  + "," + $("#teamMember").val() +  "," + $("#teamRelative").val()
  });
  $("#teamMember").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamSuperVisor").val() + "," + $("#teamLeader").val() +  "," + $("#teamRelative").val()
  });
  $("#teamSuperVisor").comp({
  	isNeedCheckLevelScope:false,
    excludeElements: ret.value + "," + $("#teamMember").val() + "," + $("#teamLeader").val() +  "," + $("#teamRelative").val()
  });
}
</script>
</head>
<body>
<div class="form_area">
<form name="addForm" id="addForm" method="post" target="addDeptFrame">
	<input type="hidden" name="orgAccountId" id="orgAccountId" value="" />
	<input type="hidden" name="id" id="id" value="" />
		<div class="left margin_l_5" style="width:45%;">
			<p class="align_right">&nbsp;</p>
            <table width="90%" border="0" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								<strong>
									${ctp:i18n('team.basic.attribute')}
								</strong>
							</label>
						</th>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								<font color="red">*</font>
								${ctp:i18n('team.name')}:
							</label>
						</th>
						<td width="90%">
							<div class="common_txtbox_wrap">
								<input id="name" type="text" value="" class="validate word_break_all" validate="type:'string',name:'${ctp:i18n('team.name')}',notNull:true,minLength:1,maxLength:120,avoidChar:'\'\\/|><:*?&quot&%$'">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								<font color="red">*</font>
								${ctp:i18n('team.sort')}:
							</label>
						</th>
						<td>
							<div class="common_txtbox_wrap">
								<input id="sortId" type="text" value="" class="validate word_break_all" validate="type:'number',isInteger:true,name:'${ctp:i18n('team.sort')}',notNull:true,minValue:1,minLength:1,maxValue:99999">
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.repeat.number.processing')}
							</label>
						</th>
						<td>
							<div class="common_radio_box clearfix">
								<label class="margin_r_10 hand">
									<input type="radio" value="1" name="sortIdtype" id="sortIdtype" class="radio_com">
									${ctp:i18n('org.sort.insert')}
								</label>
								<label class="margin_r_10 hand">
									<input type="radio" value="0" name="sortIdtype" id="sortIdtype" class="radio_com">
									${ctp:i18n('org.sort.repeat')}
								</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('level.select.state')}:
							</label>
						</th>
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
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.type')}:
							</label>
						</th>
						<td>
							<div>
								<select id="type"  class="w100b codecfg" disabled="disabled">
								<option value="2">${ctp:i18n('org.team_form.systemteam')}</option>
                				</select>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.privilege')}:
							</label>
						</th>
						<td>
							<div class="common_radio_box clearfix" id="scope_radio">
							<label class="margin_r_10 hand"> <input
								type="radio"  value="1" name="scope" id="scope"
								class="radio_com">${ctp:i18n('team.public')}
							</label> <label class="margin_r_10 hand"> <input
								type="radio"  value="2" name="scope" id="scope"
								class="radio_com">${ctp:i18n('team.private')}
							</label>
							</div>
						</td>
					</tr>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.public.scope')}
							</label>
						</th>
						<td>
							<div class="common_txtbox_wrap" id="scopeout" >
							<input id="scopein_txt" type="text" value="" class="validate word_break_all">
							<input id="scopein" type="hidden" value="" class="validate word_break_all">
							</div>
						</td>
					</tr>
					<c:if test="${CurrentUser.groupAdmin==false}">
					<tr>
						
						<th nowrap="nowrap" id="showownerId">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.belong')}:
							</label>
						</th>
						<td>
							<div class="common_txtbox_wrap" >
							<input type="text" id="ownerId" class="comp"  comp="type:'selectPeople',panels:'Department',selectType:'Account,Department',maxSize:'1',minSize:'0',onlyLoginAccount:true,isNeedCheckLevelScope:false"/> 
							</div>
						</td>
						
					</tr>
					</c:if>
					<tr>
						<th nowrap="nowrap">
							<label class="margin_r_10" for="text">
								${ctp:i18n('team.info.descr')}
							</label>
						</th>
						<td>
							<div class="common_txtbox  clearfix word_break_all">
								<textarea id="description" rows="5" class="validate w100b" validate="type:'string', name:'${ctp:i18n('team.info.descr')}',maxLength:200"></textarea>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
        </div>
		<div class="right"  style="width:45%">
            <div class="">
            	<p class="align_right"><font color="red">*</font>${ctp:i18n('org.form.must')}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
				<table width="90%" border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									<strong>
										${ctp:i18n('team.member.info')}:
									</strong>
								</label>
							</th>
						</tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									${ctp:i18n('team.charge')}:
								</label>
							</th>
							<td width="90%">
								<div class="common_txtbox_wrap w100b">
								<script> 
								var oManager = new orgManager();
								var comptxt;
				    			if (oManager.isGroup()){
				    			//集团 
				    				document.write("<input id=\"teamLeader\"  type=\"text\"  class=\"comp\" comp=\"type:'selectPeople',callback:selpeople1,minSize:0,panels:'Department,Post',selectType:'Member',isNeedCheckLevelScope:false\">");
				    			}else{
				    			//单位
				    				document.write("<input id=\"teamLeader\"  type=\"text\"  class=\"comp\" comp=\"type:'selectPeople',callback:selpeople1,minSize:0,panels:'Department,Post,Outworker',selectType:'Member',isNeedCheckLevelScope:false\">");
				    			}
				    			</script> 
								</div>
							</td>
						</tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									<font color="red">*</font>
									${ctp:i18n('team.member')}:
								</label>
							</th>
							<td width="90%">
								<div class="common_txtbox clearfix">
								<script> 
								var oManager = new orgManager();
								var comptxt;
				    			if (oManager.isGroup()){
				    			//集团 
				    				document.write("<textarea id=\"teamMember\" rows=\"3\" validate=\"type:'string',name:'${ctp:i18n('team.member')}',notNull:true,minLength:1\"  class=\"comp padding_5 w100b validate\" comp=\"type:'selectPeople',callback:selpeople2,minSize:1,mode:'open',panels:'Department,Post',selectType:'Member',isNeedCheckLevelScope:false\">");
				    			}else{
				    			//单位
				    				document.write("<textarea id=\"teamMember\" rows=\"3\" validate=\"type:'string',name:'${ctp:i18n('team.member')}',notNull:true,minLength:1\"  class=\"comp padding_5 w100b validate\" comp=\"type:'selectPeople',callback:selpeople2,minSize:1,mode:'open',panels:'Department,Post,Outworker',selectType:'Member',isNeedCheckLevelScope:false\">");
				    			}
				    			</script>
								</textarea>
								</div>
							</td>
						</tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									${ctp:i18n('team.lead')}:
								</label>
							</th>
							<td width="90%">
								<div class="common_txtbox_wrap w100b">
									<script> 
									var oManager = new orgManager();
									var comptxt;
				    				if (oManager.isGroup()){
				    				//集团 
				    					document.write("<input id=\"teamSuperVisor\" type=\"text\"  class=\"comp\" comp=\"type:'selectPeople',callback:selpeople3,minSize:0,mode:'open',panels:'Department,Post',selectType:'Member',isNeedCheckLevelScope:false\">");
				    				}else{
				    				//单位
				    					document.write("<input id=\"teamSuperVisor\" type=\"text\"  class=\"comp\" comp=\"type:'selectPeople',callback:selpeople3,minSize:0,mode:'open',panels:'Department,Post,Outworker',selectType:'Member',isNeedCheckLevelScope:false\">");
				    				}
				    				</script> 
								</div>
							</td>
						</tr>
						<tr>
							<th nowrap="nowrap">
								<label class="margin_r_10" for="text">
									${ctp:i18n('team.related.member')}
								</label>
							</th>
							<td width="90%">
								<div class="common_txtbox clearfix">
									<script> 
									var oManager = new orgManager();
									var comptxt;
					    			if (oManager.isGroup()){
					    			//集团 
					    				document.write("<textarea id=\"teamRelative\" rows=\"3\"  class=\"comp padding_5 w100b\" comp=\"type:'selectPeople',callback:selpeople4,minSize:0,panels:'Department,Post',selectType:'Member',isNeedCheckLevelScope:false\">");
					    			}else{
					    			//单位
					    				document.write("<textarea id=\"teamRelative\" rows=\"3\"  class=\"comp padding_5 w100b\" comp=\"type:'selectPeople',callback:selpeople4,minSize:0,panels:'Department,Post,Outworker',selectType:'Member',isNeedCheckLevelScope:false\">");
					    			}
					    			</script>
									</textarea>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
            </div>
        </div>
</form>
</div>
</body>
</html>