<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript"src="${path}/ajax.do?managerName=lbsManager"></script>
<script type="text/javascript">

var lbs = new m.cmp.lbs.gaode(1);
var value ;
var miniType;
var  checkOk = false;
var referenceFormMasterDataId;
var paramsFromParent;
$().ready(function(){
	var params = {};
	params.id="iCenter";
	params.level=13;
	
	var browser=navigator.appName;
	params1 = window.parentDialogObj["markerProduction"].getTransParams();
	if(params1){
	value = params1.value;
	miniType = params1.miniType;
	if(!miniType) {
		miniType = 1;
		
	}
	var canEdit = params1.canEdit;
	if(canEdit == true || canEdit=='true'){
		canEdit = true;
	} else {
		canEdit = false;
	}
	paramsFromParent =params1;
	/**
	* 1:地图标注
	* 2:签到记录
	* 3:位置定位
	* 4:拍照定位
	*/
	if(miniType == 1 || miniType =='1' ) {
		if(!canEdit){
			$("#northDiv").remove();
			$("#iCenter").attr("style","");
			modifyStyle(1);
		} else {
			modifyStyle(2);		
		}
	} else if (miniType == 2 || miniType =='2') {
		
	} else if (miniType == 3 || miniType =='3') {
			$("#northDiv").remove();
			$("#iCenter").attr("style","");
			modifyStyle(1);
		
	}  else if (miniType == 4 || miniType =='4') {
		
		
	}
	var mlbs = new lbsManager();
	if(value && value !='' && value !='-1' && value !=-1) {
		mlbs.getAttendanceInfoById(value,{
			success:function(result){
				if(result && result != null) {
			 		result.canEdit =canEdit;
					lbs.loadingMarker(result);
				} else {
					$.alert("${ctp:i18n('cmp.lbs.warn.message.loadingFailed')}");
				}
				//$("#removeMarker").unbind("click");
			}
		});
	}
	}
	function modifyStyle(type){
		if(type == 1) {
			if(browser=="Microsoft Internet Explorer"){
				$("#iCenter").attr("style","width:695px;height:496px;");
			} else {
				$("#iCenter").attr("style","width:100%;height:513px;");
			}
		} else {
			if(browser=="Microsoft Internet Explorer"){
				$("#iCenter").attr("style","width:695px;height:465px;");
			} else {
				
			}
			
		}
		
		
	}
	$("#fixedPosition").bind("click",function(){
		params.address= $("#searchText").val();
		if(params.address) {
			lbs.geocoderByAddr(params);
			checkOk =true;
		} else {
			$.alert("${ctp:i18n('cmp.lbs.warn.message.notNull')}");
		};
	
	});
	//去掉keydown事件
	
	$("#searchText").unbind("keydown");
	//.keydown(function(event){
    //	if (event.keyCode==13) {
    //		$("#fixedPosition").click();
	//	}
    //});
	$("#removeMarker").bind("click",function () {
		lbs.removeMarker(params);
	});
 lbs.initMap(params);
});

function OK(){
	var mlbs = new lbsManager();
	var params = lbs.returnValue();
	params.checkOk = checkOk;
	params.referenceRecordId=paramsFromParent.referenceRecordId;
	params.referenceFormId = paramsFromParent.referenceFormId;
	params.referenceFormMasterDataId = paramsFromParent.referenceFormMasterDataId;
	params.referenceFieldName = paramsFromParent.fieldName;
	var v = {};
	if(!checkOk &&(!value || value == -1 )){
		$.alert("${ctp:i18n('cmp.lbs.warn.message.paramsNull')}");
		return -1;
	}
	if(params && !params.removeMarker) {
		 
		if(!params.lbsLatitude){
			$.alert("${ctp:i18n('cmp.lbs.warn.message.paramsNull')}");
			return -1;
		}
		v = mlbs.transSaveAttendanceInfo(params);
	}  else {
		v.id = -1;
	}
	return v;
}
</script>
