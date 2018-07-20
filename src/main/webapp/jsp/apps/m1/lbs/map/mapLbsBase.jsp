<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript" src="http://app.mapabc.com/apis?t=javascriptmap&v=3&key=5f408e2de1e42ca41b5ea1d53e2831123105f22c6aa8ac1d3907762f2accc2215855ff42c865d18f"></script>

<script type="text/javascript">
var mapObj,marker,infoWindow ;
(function(){
    namespace = function(str){
		var att = str.split("."), o=window;
		for(var i =0;i < att.length;i ++){
		var t = o[att[i]] || {};
		o[att[i]] = t;
		o =o[att[i]];
		}
	}
	var result={};
	var mapType =mapType_Gaode;
	//高德地图
	var mapType_Gaode = 2;
	namespace("m.cmp.lbs.gaode");
	m.cmp.lbs.gaode = function(params){
		mapType = mapType_Gaode;
	}
	
	var markerList=new Array();
	m.cmp.lbs.gaode.prototype.loadingMarker = function(params){
		if(params){
			var lng = params.lbsLongitude;
			var lat = params.lbsLatitude;
			mapObj.removeOverlays("m");//删除覆盖物
			
			marker = new MMap.Marker({ 
			   id:params.lbsId, //Marker的id 
			   position:new MMap.LngLat(lng,lat), //经纬度位置 
			   offset:new MMap.Pixel(0,0), //相对于基点的偏移量 
			   draggable:false, //鼠标不可拖动 
			   zIndex:0,//Marker的叠加顺序 
			   cursor:"default",//鼠标悬停时显示的光标 
			   visible:true,//图标可见 
			   content:'<div style="background:url(${path}/apps_res/m1/images/position.png) left top no-repeat; text-align:center;"><img style="border: none;  border-radius: 25px; " src="'+params.imgUrl+'" width="30" height="30" /></div>'
			}); 
			marker.setDraggable(false);
			mapObj.addOverlays(marker);//添加Marker覆盖物
			mapObj.setCenter(marker.position);//根据Marker的位置设置地图中心点经纬度，即使Marker居中显示
			//给标注绑定单击事件
			mapObj.bind(marker,"click",function(e){
				var markerTd=$("#cardContent>div[markerId='"+params.lbsId+"']");
				index=$("#cardContent>div").index(markerTd);
				removeTCardIndex();
				addTCardIndex(index);
			});
		}
	}
	m.cmp.lbs.gaode.prototype.initMap=function(params){
			if(!params){
				mapObj = new MMap.Map(params.id);
				return;
			}
			checkIniteParams(params);
			 var opts = {};
			 var currentCity  = params.city;
			 opts["level"]=5;
			 opts["zoomEnable"] = params.zoomable;
			 opts["zooms"] = [params.minzoom,params.maxzoom];
			 //如果 经纬度合法，并且城市设置为空
			 if(!currentCity && !isNaN(centerX)&& !isNaN(centerY)){
				var centerX = params.lng;
				var centerY = params.lat;
				opts["center"] = new MMap.LngLat(centerX,centerY);
			 }
			mapObj = new MMap.Map(params.id,opts);
			//如果城市设置不为空  则设置城市地址
			if(currentCity){
				mapObj.setCity(currentCity);
				
			}
			mapObj.plugin(["MMap.ToolBar", "MMap.OverView", "MMap.Scale"],function() { 
			});
	}
	//检验初始化方法请求数据的合法性
	function checkIniteParams(params){
		if(!params){
			return false;
		}
		var minZoom = params.maxzoom;
		var maxZoom = params.minzoom;
		if(isNaN(minZoom)){
			params.minzoom = 3;
		}
		if(isNaN(maxZoom)){
			params.maxzoom = 18;
		}
		if (params.minzoom < params.maxzoom){
			params.minzoom = 3;
			params.maxzoom = 18;
		}
		var currentCity  =  params.city;
		var centerX = params.lng;
		var centerY = params.lat;
		var level = params.level;
		if(!level || isNaN(level)){
			params.level = 13;
		}
		var zoomable = params.zoomable;
		if(!zoomable){
			params.zoomable = true;
		} else if (zoomable==true ||zoomable=="true") {
			params.zoomable = true;
		} else {
			params.zoomable = false;
		}
		//如果城市为空时  ，再判断中心点的经纬度是否是数字
		if (!currentCity){
			if(isNaN(centerX)){
				params.lng =116.40632629394531 ;
			}
			if(isNaN(centerY)){
				params.lat=39.90394233735701;
			}
		}
		return true;
	}
})();
</script>
