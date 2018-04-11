<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript">

	function setOptionEnable(flag){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		if(flag){
			if(radio1Obj.checked == true){
				clickSetTimeRadio();
			}
			if(radio2Obj.checked == true){
				clickIntervalTimeRadio();
			}	
		}
		else{
			radio1Obj.disabled = true;
			radio2Obj.disabled = true;
			typeObj.disabled = true;
			hourObj.disabled = true;
			minObj.disabled = true;
			intervalDayObj.disabled = true;
			intervalHourObj.disabled = true;
			intervalMinObj.disabled = true;
		}
	}
	
	function clickSetTimeRadio(){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		radio1Obj.disabled = false;
		radio2Obj.disabled = false;
		typeObj.disabled = false;
		hourObj.disabled = false;
		minObj.disabled =  false;
		intervalDayObj.disabled = true;
		intervalHourObj.disabled = true;
		intervalMinObj.disabled = true;
	}
	function clickIntervalTimeRadio(){
		var radio1Obj = document.all.setTimeRadio;
		var radio2Obj = document.all.intervalTimeRadio;
		var typeObj = document.getElementById("typeSel");
		var hourObj = document.all.hour;
		var minObj = document.all.min;
		var intervalDayObj = document.all.intervalDay;
		var intervalHourObj = document.all.intervalHour;
		var intervalMinObj = document.all.intervalMin;
	
		radio1Obj.disabled = false;
		radio2Obj.disabled = false;
		typeObj.disabled = true;
		hourObj.disabled = true;
		minObj.disabled =  true;
		intervalDayObj.disabled = false;
		intervalHourObj.disabled = false;
		intervalMinObj.disabled = false;
	}

</script>
</head>
<body>
	<form name="addAutoForm" id="addAutoForm" method="post" action="${path}/cip/org/synOrgController.do?method=operation" target="">
		<input type="hidden" id="syncType" value="${syncType}" name= "syncType" />
		<div class="form_area">
			<div class="one_row" style="width:70%;">
				<fieldset id="form_head" style=" width: 100%;border: 1; height: 280px;">
					<legend>
						&nbsp;&nbsp;<font size="2"><b>${ctp:i18n('cip.org.sync.config.auto2')}</b></font>&nbsp;&nbsp;
					</legend>
					<div  style="width: 100%;border: 0px;" align="left">
					   <table id="autotable" class="flexme3" border="0" cellspacing="0" cellpadding="0" width="100%" style="margin-top: 5px;">
							<tr>
								<td width="100" height="50" nowrap="nowrap" align="right">*${ctp:i18n('cip.org.sync.config.istart')}</td>
								<td colspan="2">
									<label for="isStart1">
									<input id="isStart1" name="isStart" type="radio" value="1" onclick="setOptionEnable(true)" ${isStart?'checked':''}>${ctp:i18n('cip.org.sync.config.istart1')}
									</label>&nbsp;&nbsp;
									<label for="isStart2">
										<input id="isStart2" name="isStart" type="radio" value="0" onclick="setOptionEnable(false)" ${isStart?'':'checked'}>${ctp:i18n('cip.org.sync.config.istart2')}
									</label>
								</td>
							</tr>
							<tr id="syncTime">
								<td rowspan="2" nowrap="nowrap" align="right">
									*${ctp:i18n('cip.org.sync.config.synctime')}
								</td>
								<td width="80" nowrap="nowrap"><label for="setTimeRadio"><input id="setTimeRadio" type="radio" name="synchTimeType" value="setTime" ${synchTimeType==0?'checked':''} ${isStart?'':'disabled'} onclick="clickSetTimeRadio()">${ctp:i18n('cip.org.sync.config.asstime')}：</label></td>
								<td>
									<select id="typeSel" name="type" ${isStart?'':'disabled'} ${synchTimeType==0?'':'disabled'}>
									  <option value="0" ${type == '0'?'selected':''}>${ctp:i18n('cip.org.sync.config.eday')}</option>
									  <option value="1" ${type == '1'?'selected':''}>${ctp:i18n('cip.org.sync.config.sun')}</option>
									  <option value="7" ${type == '7'?'selected':''}>${ctp:i18n('cip.org.sync.config.sat')}</option>
									  <option value="6" ${type == '6'?'selected':''}>${ctp:i18n('cip.org.sync.config.fra')}</option>
									  <option value="5" ${type == '5'?'selected':''}>${ctp:i18n('cip.org.sync.config.thur')}</option>
									  <option value="4" ${type == '4'?'selected':''}>${ctp:i18n('cip.org.sync.config.wes')}</option>
									  <option value="3" ${type == '3'?'selected':''}>${ctp:i18n('cip.org.sync.config.tues')}</option>
									  <option value="2" ${type == '2'?'selected':''}>${ctp:i18n('cip.org.sync.config.mon')}</option>
									</select>&nbsp;&nbsp;
									<select id="hour" name="hour" ${isStart?'':'disabled'}  ${synchTimeType==0?'':'disabled'}>
										<option value="0" ${hour == '0'?'selected':''}>0</option>
										<option value="1" ${hour == '1'?'selected':''}>1</option>
										<option value="2" ${hour == '2'?'selected':''}>2</option>
										<option value="3" ${hour == '3'?'selected':''}>3</option>
										<option value="4" ${hour == '4'?'selected':''}>4</option>
										<option value="5" ${hour == '5'?'selected':''}>5</option>
										<option value="6" ${hour == '6'?'selected':''}>6</option>
										<option value="7" ${hour == '7'?'selected':''}>7</option>
										<option value="8" ${hour == '8'?'selected':''}>8</option>
										<option value="9" ${hour == '9'?'selected':''}>9</option>
										<option value="10" ${hour == '10'?'selected':''}>10</option>
										<option value="11" ${hour == '11'?'selected':''}>11</option>
										<option value="12" ${hour == '12'?'selected':''}>12</option>
										<option value="13" ${hour == '13'?'selected':''}>13</option>
										<option value="14" ${hour == '14'?'selected':''}>14</option>
										<option value="15" ${hour == '15'?'selected':''}>15</option>
										<option value="16" ${hour == '16'?'selected':''}>16</option>
										<option value="17" ${hour == '17'?'selected':''}>17</option>
										<option value="18" ${hour == '18'?'selected':''}>18</option>
										<option value="19" ${hour == '19'?'selected':''}>19</option>
										<option value="20" ${hour == '20'?'selected':''}>20</option>
										<option value="21" ${hour == '21'?'selected':''}>21</option>
										<option value="22" ${hour == '22'?'selected':''}>22</option>
										<option value="23" ${hour == '23'?'selected':''}>23</option>
									</select>
									${ctp:i18n('cip.org.sync.config.hour')}&nbsp;&nbsp;
									<select id="min" name="min" ${isStart?'':'disabled'}  ${synchTimeType==0?'':'disabled'}>
									  <option value="0" ${min == '0'?'selected':''}>0</option>
									  <option value="5" ${min == '5'?'selected':''}>5</option>
									  <option value="10" ${min == '10'?'selected':''}>10</option>
									  <option value="15" ${min == '15'?'selected':''}>15</option>
									  <option value="20" ${min == '20'?'selected':''}>20</option>
									  <option value="30" ${min == '30'?'selected':''}>30</option>
									  <option value="40" ${min == '40'?'selected':''}>40</option>
									  <option value="50" ${min == '50'?'selected':''}>50</option>
									</select>
									${ctp:i18n('cip.org.sync.config.min')}
								</td>
							</tr>
							<tr>
								<td nowrap="nowrap"><label for="intervalTimeRadio"><input id="intervalTimeRadio" type="radio" name="synchTimeType" value="intervalTime" ${synchTimeType!=0?'checked':''}  ${isStart?'':'disabled'} onclick="clickIntervalTimeRadio()">${ctp:i18n('cip.org.sync.config.inttime')}：</label></td>
								<td>
									<select id="intervalDay" name="intervalDay" ${isStart?'':'disabled'}  ${synchTimeType!=0?'':'disabled'}>
										<option value="0" ${intervalDay == '0'?'selected':''}>0</option>
										<option value="1" ${intervalDay == '1'?'selected':''}>1</option>
										<option value="2" ${intervalDay == '2'?'selected':''}>2</option>
										<option value="3" ${intervalDay == '3'?'selected':''}>3</option>
										<option value="4" ${intervalDay == '4'?'selected':''}>4</option>
										<option value="5" ${intervalDay == '5'?'selected':''}>5</option>
										<option value="6" ${intervalDay == '6'?'selected':''}>6</option>
									</select>
									&nbsp;&nbsp;${ctp:i18n('cip.org.sync.config.day')}&nbsp;&nbsp;&nbsp;&nbsp;
									<select id="intervalHour" name="intervalHour" ${isStart?'':'disabled'} ${synchTimeType!=0?'':'disabled'}>
										<option value="0" ${intervalHour == '0'?'selected':''}>0</option>
										<option value="1" ${intervalHour == '1'?'selected':''}>1</option>
										<option value="2" ${intervalHour == '2'?'selected':''}>2</option>
										<option value="3" ${intervalHour == '3'?'selected':''}>3</option>
										<option value="4" ${intervalHour == '4'?'selected':''}>4</option>
										<option value="5" ${intervalHour == '5'?'selected':''}>5</option>
										<option value="6" ${intervalHour == '6'?'selected':''}>6</option>
										<option value="8" ${intervalHour == '8'?'selected':''}>8</option>
										<option value="10" ${intervalHour == '10'?'selected':''}>10</option>
										<option value="12" ${intervalHour == '12'?'selected':''}>12</option>
										<option value="24" ${intervalHour == '24'?'selected':''}>24</option>
									</select>
									${ctp:i18n('cip.org.sync.config.hour')}&nbsp;&nbsp;
									<select id="intervalMin" name="intervalMin" ${isStart?'':'disabled'} ${synchTimeType!=0?'':'disabled'}>
									  <option value="0" ${intervalMin == '0'?'selected':''}>0</option>
									  <option value="5" ${intervalMin == '5'?'selected':''}>5</option>
									  <option value="10" ${intervalMin == '10'?'selected':''}>10</option>
									  <option value="15" ${intervalMin == '15'?'selected':''}>15</option>
									  <option value="20" ${intervalMin == '20'?'selected':''}>20</option>
									  <option value="30" ${intervalMin == '30'?'selected':''}>30</option>
									  <option value="40" ${intervalMin == '40'?'selected':''}>40</option>
									  <option value="50" ${intervalMin == '50'?'selected':''}>50</option>
									  <option value="60" ${intervalMin == '60'?'selected':''}>60</option>
									</select>
									${ctp:i18n('cip.org.sync.config.min')}
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
		</div>
	</form>
</body>
</html>