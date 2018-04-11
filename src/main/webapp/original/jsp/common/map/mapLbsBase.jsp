<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="https://webapi.amap.com/maps?v=1.3&key=089d59f15ad6506f4b0de55285f70222"></script>

<script type="text/javascript">
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
	var mapObj,toolbar,overview,scale,marker,poiSearch,geocoder,infoWindow ;
	var mapType =mapType_Gaode;
	//保存地图上的所有标注
	var markers = new Array();
	var infoWindows = new Array();
	//百度地图
	var mapType_Baidu = 1;
	//高德地图
	var mapType_Gaode = 2;
	//谷歌地图
	var mapType_Google = 3;
	
	namespace("m.cmp.lbs.baidu");
	namespace("m.cmp.lbs.gaode");
	namespace("m.cmp.lbs.google");
	m.cmp.lbs.gaode = function(params){
		mapType = mapType_Gaode;
	}
	m.cmp.lbs.gaode.prototype.loadingMarker = function(params){
		if(params){
			
			var lng = params.lbsLongitude;
			var lat = params.lbsLatitude;
			gaoderemoveMarker();
			var canEdit = params.canEdit;
			if(canEdit) {
				var  data = {};
				var  dataList={};
				data.info='OK';
				var location = {};
				dataList.location = location;
				location.lng =  params.lbsLongitude;
				location.lat=params.lbsLatitude;
				location.formattedAddress = params.lbsAddr;
				var addressComponent={};
				addressComponent.province=params.lbsProvince;
				addressComponent.city=params.lbsCity;
				addressComponent.district=params.lbsTown;
				dataList.addressComponent={};
				var list = new Array();
				list.push(dataList);
				data.geocodes = list;
				data.first=true;
				mConvertGeocode(data);
				result = params;
			} else {
				loadingMMarker(params.lbsLongitude,params.lbsLatitude,false,params.lbsAddr);
			};
		}
	}
	m.cmp.lbs.gaode.prototype.initMap=function(params){
		if(!params) {
				mapObj = new AMap.Map(params.id);
				return;
			}
			 var opts = {};
			 var currentCity  = params.city;
			 opts["level"]=params.level;
			// opts["zoomEnable"] = params.zoomable;
			 opts[" resizeEnable"]=true;
			// opts["zoom"] = 12;
			mapObj = new AMap.Map(params.id,opts);
			//如果城市设置不为空  则设置城市地址
			if(currentCity){
				mapObj.setCity(currentCity);
			}
			mapObj.plugin(["AMap.ToolBar"], function () {
			  toolBar = new AMap.ToolBar();
			  mapObj.addControl(toolBar);
			});
			 // 加载比例尺插件
			mapObj.plugin(["AMap.Scale"], function () {
			  scale = new AMap.Scale();
			  mapObj.addControl(scale);
			});
			mapObj.plugin(["AMap.OverView"], function () {
			  overView = new AMap.OverView({
				visible: false
			  });
			  mapObj.addControl(overView);
			});
	}
	var  temp = false;
	m.cmp.lbs.gaode.prototype.geocoderByAddr = function(params) {
		if(temp){
			return ;
		}
		temp = true;
		var address= params.address;
		var MGeocoder;
		//加载地理编码插件
		AMap.service(["AMap.Geocoder"], function() {
			MGeocoder = new AMap.Geocoder({

				radius: 1000 //范围，默认：500
			});
			//返回地理编码结果
			//地理编码
			MGeocoder.getLocation(address, function(status, result) {
				if (status === 'complete' && result.info === 'OK') {
					mConvertGeocode(result);
				} else {
					$.alert("${ctp:i18n('cmp.lbs.warn.message.noInfo')}");
				}
				setTimeout(function(){
					temp= false;
				},200);
				
			});
		});
	}
	
	m.cmp.lbs.gaode.prototype.removeMarker =function(params) {
		gaoderemoveMarker(params);
	}
	m.cmp.lbs.gaode.prototype.returnValue = function(params){
		return result;
	}
	function gaoderemoveMarker (obj){
		if( infoWindow ||infoWindow != null) { //关闭提示窗口
			infoWindow.close();
		}
		result.removeMarker=true;
		if(marker != null){
			mapObj.remove(marker);//删除覆盖物
		}
	}
	function mConvertGeocode(data){
			if(data.info =="OK"){
				var data1 = data.geocodes[0];
				var lng = data1.location.lng;
				var lat = data1.location.lat;
				var info =data1.formattedAddress;
				var province=data1.addressComponent.province;
				var regeocodeCity=data1.addressComponent.city;
				var district=data1.addressComponent.district;
				var  road="";
				loadingMMarker(lng,lat,true,info);
				
				var first = data.first;
				if(first && first == true) {
					first= true;
				} else {
				first = false;
				}
				result = new resultParams(-1,lng,lat,info,"亚洲","中国",province,regeocodeCity,district,road);
				result.first = first;
			} else {
				$.alert("${ctp:i18n('cmp.lbs.warn.message.noInfo')}");
			} 

		}
	//高德地图添加一个标记
		function loadingMMarker(lng,lat,draggable,info){
			gaoderemoveMarker();
			var markerOption   = {
				map: mapObj,
				icon:"https://webapi.amap.com/theme/v1.3/markers/n/mark_b"+1+".png",
				draggable:draggable,
				position: [lng, lat]
			};
			 marker = new AMap.Marker(markerOption);
			marker.setMap(mapObj);
			var lnglat=new  AMap.LngLat(lng,lat);
			mapObj.panTo(lnglat);
			initInfoWindow(info);
			if(draggable == true){
				//移动之前 ，移动过程中先将提示框关掉
				marker.on("dragstart",function(e){
					if( infoWindow ||infoWindow != null) { //关闭提示窗口
						infoWindow.close();
					}
				});
				marker.on("dragging",function(e){
					if( infoWindow ||infoWindow != null) { //关闭提示窗口
						infoWindow.close();
					}
				});
				marker.on("dragend",function(e){
					fixedPosition(e.lnglat.lng,e.lnglat.lat)
				});
			}
		}
	function initInfoWindow(info){
		if(infoWindow != null){
				infoWindow.close();
			}
			infoWindow = new AMap.InfoWindow({
				content: info,
				autoMove: true,
				size: new AMap.Size(150, 0),
				offset: {x: 0, y: -30}
			});
			var mouseover = function(e) {
				infoWindow.open(mapObj, marker.getPosition());
			};
			var mouseout = function(e){
				infoWindow.close();
			}
			if(marker != null){
				marker.on( "mouseover", mouseover);
				marker.on( "mouseout", mouseout);
			}
	}
	//根据经纬度定位位置
	function fixedPosition(lng ,lat){
		 var MGeocoder;
		 var lnglatXY = [lng,lat];
        //加载地理编码插件
        AMap.service(["AMap.Geocoder"], function() {
            MGeocoder = new AMap.Geocoder({
                radius: 1000,
                extensions: "all"
            });
            //逆地理编码
            MGeocoder.getAddress(lnglatXY, function(status, result) {
                if (status === 'complete' && result.info === 'OK') {
                    gaodeRegeocode(lng ,lat,result);
                }
            });
        });

	}
	
	// 高德转换成标注移动后的经纬度反向地理编码返回数据
	function gaodeRegeocode(lng,lat,data,callback){
		var info = "";
		if(data.info=='OK'){
			var  regeocode = data.regeocode;
			var district = regeocode.addressComponent.district;
			var regeocodeCity = regeocode.addressComponent.city;
			var province = regeocode.addressComponent.province;
			var road = regeocode.addressComponent.street;
			info = regeocode.formattedAddress;

			result = new resultParams(-1,lng,lat,info,"亚洲","中国",province,regeocodeCity,district,road,regeocodeCity,"");
			
		} else if (data.status=='E1') {
			info = "${ctp:i18n('cmp.lbs.warn.message.noInfo')}";
		}
		initInfoWindow(info);
	}
	/**
	*标注点制作功能返回对象。
	*/
	resultParams = function (id,lbsLongitude,lbsLatitude,lbsAddr,lbsContinent,lbsCountry,lbsProvince,lbsCity,lbsTown,lbsStreet,cityCode){
		this.id = id;
		this.lbsLongitude  =lbsLongitude;
		this.lbsLatitude=lbsLatitude;
		this.lbsAddr=lbsAddr;
		this.lbsContinent =lbsContinent;
		this.lbsCountry=lbsCountry;
		this.lbsProvince=lbsProvince;
		this.lbsCity=lbsCity;
		this.lbsTown=lbsTown;
		this.lbsStreet=lbsStreet;
		this.cityCode=cityCode;
	
	
	};
})();
</script>
