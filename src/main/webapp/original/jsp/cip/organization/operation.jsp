<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipSynOperationManager"></script>
<script type="text/javascript" language="javascript">
var timeT;
$().ready(function(){
	var operationManager = new cipSynOperationManager();
	$(".dataTd").click(function(){
		$(".dataTr").removeAttr("bgcolor");
		$(this).parent("tr").attr("bgColor","#D3E0EC");
		$("input[type='checkbox']").removeAttr("checked");
		$(this).parent("tr").find("td input[name='initId']").attr("checked","checked");
	});
	$("input[name='initId']").click(function(){
		if($(this).attr("checked")=='checked'){
			$(".dataTr").removeAttr("bgcolor");
			$(this).parent("td").parent("tr").attr("bgColor","#D3E0EC");
		}else{
			$(this).parent("td").parent("tr").removeAttr("bgcolor");
		}
	});
	$("#checkbox").click(function(){
		if($(this).attr("checked")=='checked'){
			$("input[type='checkbox']").attr("checked","checked");
		}else{
			$("input[type='checkbox']").removeAttr("checked");
		}
	});
	var syncType = $("#syncType").val() ;
	if(syncType == "hand"){
		$("#hand").attr("checked","checked");
	}else{
		$("#auto").attr("checked","checked");
		$("#handForm").attr("class","hidden");
		$("#autoForm").removeClass("hidden");
	}
	
	$("#hand").click(function(){
		$("#handForm").show();
		$("#autoForm").hide();
		$("#syncType").val("hand");
	});
	$("#auto").click(function(){
		$("#handForm").hide();
		$("#autoForm").show();
		$("#syncType").val("auto");
	});
	$("#btncancel").click(function() {
        //location.reload(true);
		location.replace(location) ;
    });
    $("#btnok").click(function() {
    	if($("#hand").attr("checked")=="checked"){
    		var v = $("input[name='initId']:checked");
            if (v.length < 1) {
                $.alert("${ctp:i18n('cip.org.sync.config.choose')}");
            }else{
            	checkSynchState();
            	var arr = new Array();
            	for(var i=0; i<v.length; i++){
            		arr[i] = $(v[i]).val()
            	}
            	var start = $("#startTime").val();
            	var object = new Object();
            	object.schemeInits = arr;
            	object.startTime = start;
            	if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
                operationManager.handOperation(object, {
                    success: function(rel) {
                        try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                        location.reload(); //刷新效果               
                    }
                }); 
            }
    	}else{
    		if($("#isStart1").attr("checked") == "checked"){
				if($("#setTimeRadio").attr("checked") == "checked"){
				}else if($("#intervalTimeRadio").attr("checked") == "checked"){
					if(document.all.intervalDay.value=='0' && document.all.intervalHour.value=='0' && document.all.intervalMin.value=='0'){
						$.alert("${ctp:i18n('cip.org.sync.config.hint')}");
						return false;
					}else{
					}
					//$("#syncType").val("auto");//设置同步标识
				}
				$("#addAutoForm").submit();	
				if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
			}else{
				$("#addAutoForm").submit();	
				if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
			}
    	}
    });
	checkSynchState();
	intervalometer();
    function checkSynchState(){
		var synchHandState = ${isHandSynching};
		if(synchHandState){
			$("#synchState").html("${ctp:i18n('cip.org.sync.config.wait')}");
			if($("#hand").attr("checked")=='checked'){
				$("#btnok").attr("disabled","disabled");
			}
			timeT = window.setInterval("intervalometer()",5000);
		}else{
			$("#synchState").html("");
			$("#btnok").removeAttr("disabled");
		}
	}
});
//定时调用
function intervalometer(){
	var operationManager = new cipSynOperationManager();
	var currentLi = $(window.parent.document).find(".current");
	if(currentLi.find("a").attr("id")=='operation'){
		var resultMap = operationManager.getHandOperationResult();
		var isSyning = resultMap.isSyningHand;
		if(!isSyning){
			if(resultMap.isSucessHand!=undefined){
				if(resultMap.isSucessHand){
					var random = $.messageBox({
					    'type': 100,
					    'msg': "<span class='margin_l_25'>${ctp:i18n('cip.org.sync.config.success')}</span>",
					    buttons: [{
					    id:'btn1',
					        text: "${ctp:i18n('cip.org.sync.log.view')}",
					        handler: function () { 
					        	window.open("${path}/cip/org/synOrgController.do?method=record&time="+Math.random());
					        	//window.open("${path}/cip/org/syLog.do");
					        }
					    }, {
					    id:'btn2',
					        text: "${ctp:i18n('cip.org.sync.log.close')}",
					        handler: function () { random.close(); }
					    }]
					});

				}else{
					var random = $.messageBox({
					    'type': 100,
					    'msg': "<span class='margin_l_25'>${ctp:i18n('cip.org.sync.config.fail')}</span>",
					    buttons: [{
					    id:'btn1',
					        text: "${ctp:i18n('cip.org.sync.log.view')}",
					        handler: function () { window.open("${path}/cip/org/syLog.do"); }
					    }, {
					    id:'btn2',
					        text: "${ctp:i18n('cip.org.sync.log.close')}",
					        handler: function () { random.close(); }
					    }]
					});
				}
			}
			$("#synchState").html("");
			$("#btnok").removeAttr("disabled");
			window.clearInterval(timeT);
		}
	}
}
</script>
<style>
	#handtable td{
		text-align: left;
		padding: 6pt;
		border-bottom: 1px solid #E1E1E1;
		 white-space:nowrap;overflow:hidden;text-overflow: ellipsis;
	}
	#autotable td{
		text-align: left;
		padding: 6pt;
	}
    .stadic_head_height{
        height:40px;
    }
    .stadic_body_top_bottom{
        top: 85px;
        bottom: 20px;
    }
    .stadic_footer_height{
        height:37px;
    }
    .calendar_iframe{
    	width: 350px;
    	height: 350px;
    }
</style>
</head>
<body class="h100b over_hidden">
        <div class="stadic_layout">
                <form name="addForm1" id="addForm1" method="post" target="">
					<div class="form_area">
						<div class="one_row" style="width:70%;">
							<br>
							<table border="0" cellspacing="0" cellpadding="0">
								<tbody>
									<tr>
										<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('cip.org.sync.config.type')} :</label></th>
										<td width="100%" style="border-bottom:0px;">
											<div class="common_radio_box clearfix">
											    <label for="hand" class="margin_r_10 margin_l_10 hand">
											        <input type="radio" value="1" id="hand" name="option" class="radio_com" >${ctp:i18n('cip.org.sync.config.hand')}</label>
											    <label for="auto" class="margin_r_10 margin_l_10 hand">
											        <input type="radio" value="2" id="auto" name="option" class="radio_com">${ctp:i18n('cip.org.sync.config.auto')}</label>
											</div>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="border-bottom:0px;">
											<font color="red"><p id="synchState"> </p></font>
										</td>
									</tr>
								</tbody>
							</table>
							<br>
						</div>
					</div>
				</form>
            <div class="stadic_layout_body stadic_body_top_bottom">
            	<div id="handForm" class="form_area" style="overflow-y:hidden">
                        <%@include file="hand.jsp"%></div>
                <div id="autoForm" class="form_area hidden" style="overflow-y:hidden">
                        <%@include file="auto.jsp"%></div>
            </div>
            <div class="stadic_layout_footer stadic_footer_height">
                <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_8 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
            </div>
        </div>
    </body>

</html>