<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<script type="text/javascript"src="${path}/ajax.do?managerName=mLbsRecordManager"></script>
<script type="text/javascript">

var lbs = new m.cmp.lbs.gaode(1);
var size=0;
var cardlist;
var index=0;
$(function(){
		try{
			lbs.initMap({
				id:"iCenter",
				level:5
			})
		}catch(e){
			//断网情况下,给个提示
			$("#mapDiv").css({"text-align":"center","background-color":"#F4F4F4"});
			$("#errMsg").css("padding-top","${columnsHeight}"/2).show();
			return;
		}
		$("#iCenter").css({"height":"${columnsHeight}"});
		$("#info").css("left",($("#iCenter").width()/2)-125).show();
		var width="${width}";
		if(width<5){
			$("#mapDiv").css({"height":"${columnsHeight}","overflow-x":"scroll","overflow-y":"hidden"});
			$("#iCenter").width("900px");
			$("#card").css("top","-105px");
		}
		$("#card").css("left",($("#iCenter").width()/2)-200);
		//$("#card").css("top","${columnsHeight}"-90);
		var mlbs = new mLbsRecordManager();
		var param=new Array();
		param.push("from=1");
		param.push("onlyOne=1");
		var result=mlbs.getAttendanceInfoByIds(param.join(","));
		size=result.length;
		buildTBody(result);
		cardlist=$("#cardContent>div");
		//默认将第一个突出显示
		if(size>0){
			var lng=result[0].lbsLongitude;
			var lat=result[0].lbsLatitude;
			mapObj.setZoomAndCenter(6,new MMap.LngLat(lng,lat));
			$("#card").show();
			addTCardIndex(0);
		}
		//给左右按钮添加动态切换效果
		$("#next").bind("click",function(){
			if(index<size-1){
				removeTCardIndex();
				index++;
				addTCardIndex(index);
				return;
			}
			index=0;
			removeTCardIndex();
			addTCardIndex(index);
		});
		$("#prev").bind("click",function(){
			index--;
			if((index+result.length)>0&&index<size-1){
				removeTCardIndex();
				addTCardIndex(index);
				return;
			}
			index=0;
			removeTCardIndex();
			addTCardIndex(index);
		});
})

/**
*设置原来的标注zIndex为最底层,取消凸显样式,隐藏人员卡片
*/
function removeTCardIndex(){
	var mk=$("#cardContent>div:visible");
	marker_=mapObj.getOverlays(mk.attr("markerId"));
	var imgUrl=mk.attr("imgUrl");
	marker_.setContent('<div style="background:url(${path}/apps_res/m1/images/position.png) left top no-repeat; text-align:center;"><img style="border: none;  border-radius: 25px; " src='+imgUrl+' width="30" height="30" /></div>');
	marker_.setzIndex(0);
	$("#cardContent>div:visible").addClass("hidden");
}
/**
*设置当前的标注zIndex为最高层,添加凸显样式,显示人员卡片
*/
function addTCardIndex(index){
	var mk=cardlist.eq(index);
	mk.removeClass("hidden");
	marker_=mapObj.getOverlays(mk.attr("markerId"));
	var imgUrl=mk.attr("imgUrl");
	marker_.setContent('<div class="nowPosition"><img style="border: none;  border-radius: 25px; " src='+imgUrl+' width="30" height="30" /></div>');
	marker_.setzIndex(10);
}
/**
*生成人员卡片
*/
function buildTBody(result){
	var cardContent="";
	if(result){
		var j=result.length;
		for(var i=0;i<result.length;i++){
			result[i].canEdit=false;
			result[i].zIndex=j--; 
			lbs.loadingMarker(result[i]);
			cardContent+='<div class="hidden" imgUrl='+result[i].imgUrl+' markerId='+result[i].lbsId+'><div class="positionContent_avatar"><img width="40px" src="'+result[i].imgUrl+'"></div>';
			cardContent+='<div style="width:300px" class="positionContent_text"><p class="positionGray" align="center"><span></span>'+result[i].createDate+'</p>';
			cardContent+='<p align="center">'+result[i].lbsAddr+'</p>';
			cardContent+='<p class="positionGray" align="center">'+result[i].userName+'</p></div></div>';
		}
		$("#memberNum").html(result.length);
		$("#cardContent").html(cardContent);
	}
}
/**
*销毁地图对象
*/
function destoryMap(){
	if(mapObj){
		mapObj.destroy();
	}
}
</script>