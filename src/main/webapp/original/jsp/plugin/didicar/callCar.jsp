<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script src="${path}/apps_res/didicar/js/selectBox.js"></script>
<script src="${path}/apps_res/didicar/js/timeBox.js"></script>
<script src="${path}/apps_res/didicar/js/city.js"></script>
<link rel="stylesheet" type="text/css" href="apps_res/didicar/css/callCar.css">
<script type="text/javascript"
    src="${path}/ajax.do?managerName=didicarManager"></script>
    <script type="text/javascript">
var placeSearchtype = 0;
var showCityCar = [];
var cityId;
var dManager;
var departureTime;
var carLevelName={
    100: "${ctp:i18n('didicar.plugin.information.models.100')}",
    400: "${ctp:i18n('didicar.plugin.information.models.400')}",
    200: "${ctp:i18n('didicar.plugin.information.models.200')}",
    500: "${ctp:i18n('didicar.plugin.information.models.500')}"
}
$().ready(function() {
  
$("input:radio[name='carReason']").css("cursor", "pointer");
$("input").css("height", "30px");
$("img").css("cursor", "pointer");  
  
    dManager=new didicarManager();
 
     var carcity=  eval(${cartype});//城市车型
    filterCityCar(carcity);
    
   
    //车类型选择
    $(".car_select_con").on("click", 'li', function () {
       
        if ($(this).attr("id")=='quitcar') {
        
                $(this).removeClass("specialcar").addClass("quitcar");
                $("#specialcar").removeClass("quitcar").addClass("specialcar");
            $("#carLevelView").hide();
            //$(".call_to_car").html("叫快车");
                $("#special_car_type").height(0);
        } else {
               $(this).removeClass("specialcar").addClass("quitcar");
            $("#quitcar").removeClass("quitcar").addClass("specialcar");
    
            $("#carLevelView").show();
            //$(".call_to_car").html("叫专车");
                $("#special_car_type").height(80);
        }
        calculatePrice(); //预估价格
    });
   $(".special_car_type").on("mouseover", 'li', function () {
   
                $(this).find("div").removeClass("carLevel").addClass("carOverLevel");
              
    });
      $(".special_car_type").on("mouseleave", 'li', function () {
                if($(this).hasClass("active")){
                 
                }else{
                $(this).find("div").removeClass("carOverLevel").addClass("carLevel");
                }

    });
    
      $(".special_car_type").on("mousedown", 'li', function () {
              var active=$("#carLevelView").find(".active");
               active.removeClass("active");
               active.find("div").removeClass("carOverLevel");
               active.find("div").addClass("carLevel");
              $(this).find("div").removeClass("carLevel").addClass("carOverLevel");
              $(this).addClass("active");
               calculatePrice(); //预估价格
    });
    //车型选择
   // $("#carLevelView").on("click", ".select1", function () {
       // $(".select1").removeClass("active");
       // $(this).addClass("active");
       // calculatePrice();
   // });

    $("#startAddr").on("input focus propertychange", function () {
        var startAddr = $(this).val();
        if(startAddr=="${ctp:i18n('didicar.callcar.usecar.add')}"){
           $("#startAddr").val("");
           $("#startLocation").val("");
           return;
        }
        if (startAddr.length > 0) {
            placeSearchtype = 0;
            var city=$("#cityName").html();
            placeSearch(startAddr,city);
        }
        return false;
    });

    $("#toAddr").on("input focus propertychange", function () {
        if ($("#startAddr").val() <= 0 && $("#startLocation").val().length <= 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.startAdd')}");
            $(this).blur();
            return;
        }
        var endAddr = $(this).val();
            if(endAddr=="${ctp:i18n('didicar.callcar.usecar.add')}"){
              $("#toAddr").val("");
              return;
        }
        if (endAddr.length > 0) {
            placeSearchtype = 1;
            var city=$("#cityName").html();
            placeSearch(endAddr,city);
        }
        return false;
    });
    $("#submitcall").on("click",function(){

        //叫车
        var startAddr = $("#startAddr").val();
        var toAddr = $("#toAddr").val();
        var startLocation = $("#startLocation").val();
        var toLocation = $("#toLocation").val();
        var phone =$("#phone").val();
        if (startAddr.length <= 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.startAdd.coordinate')}");
            return;
        }
        if (startLocation.length <= 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.startAdd')}");
            return;
        }
        if (toAddr.length <= 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.DestinationAdd')}");
            return;
        }
        if (toLocation.length <= 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.DestinationAdd.coordinate')}");
            return;
        }

        if (startAddr == toAddr) {
            $.alert("${ctp:i18n('didicar.callcar.tip.equal.Add')}");
            return;
        }
      var chars="|,'&\"";
      var value = $("#name").val();
     
     var namer=false;
     for(var i=0,len=chars.length; i<len; i++){
            
           if (value.indexOf(chars.charAt(i)) > -1) {
            namer=true;
           break;
           }
     }
        if(namer){
          $.alert("${ctp:i18n('didicar.callcar.username.char')}"+chars);
            return;
        }
        var tel = $("#phone").val();
        if(tel==""){
          $.alert("${ctp:i18n('didicar.callcar.phone')}");
          return;
        }
        var telReg = !!tel.match(/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/);
    
        if(telReg == false){
            $.alert("${ctp:i18n('didicar.plugin.account.phone.error')}");
            return;
        }
           var currentSelCarLevel = getCurrentCarLevel();
        if (currentSelCarLevel == 0) {
            $.alert("${ctp:i18n('didicar.callcar.tip.carType')}");
            return;
        }
        callCar(currentSelCarLevel);
        
    });
    var searchListContentView = $(".search_list_content");
    searchListContentView.on("click", "li", function () {
        var liData = $(this).attr("dd-data");
        if (liData && liData.length > 0) {
            if (placeSearchtype == 0) {
                $("#startLocation").val(liData).change();
                liData = JSON.parse(liData);
                $("#startAddr").val(liData.displayName);

            } else {
                $("#toLocation").val(liData).change();
                liData = JSON.parse(liData);
                $("#toAddr").val(liData.displayName);
            }
        } else {
            if ($("#toAddr").val().length > 0) {
                var toLocation = $("#toLocation").val();
                if (toLocation.length > 0) {
                    toLocation = JSON.parse(toLocation);
                    if (toLocation["displayName"] != $("#toAddr").val()) {
                        $("#toLocation").val("");
                    }
                }
            } else {
                $("#toLocation").val("");
            }
        }
        searchListContentView.css({"display": "none"});
        calculatePrice();
        window.scrollTo(0, 0);
    });
         var timeBox = new $.TimeBox({
                "timeElement": 'selectTimeBtn',
                "boxElement": 'timesGroups',
                "url":"gettime"
              }, function(flag) {
                if (flag) {
                  $('#submitcall').html("${ctp:i18n('didicar.callcar.tip.carcall')}");
                  $('#submitcall').attr('init_value', '开始叫车');
                } else {
                  $('#submitcall').html("${ctp:i18n('didicar.callcar.tip.carcall.appointment')}");
                  $('#submitcall').attr('init_value', '预约叫车');
                }
              });
            
        var quitCarCity=eval(${quitCarCity});//有快车的城市
        var specialCarCity=eval(${specialCarCity});//有专车的城市
        // 设置用户所选城市
        window.cityapi = $("#city").city({
            quitdata:quitCarCity,
            specialdata:specialCarCity,
            onshow: function(elem,$root){
                var $navs = elem.find("div._city_nav > span");
                $navs.on("click",function(){
                    var self = $(this),
                        index = self.index(),
                        $box = elem.find("div._city_content").eq(index);

                    $navs.removeClass("current").eq(index).addClass("current");
                    elem.find("div._city_content").hide();
                    $box.show();
                });

                var $citys = elem.find("span[data-city-id]");
                $citys.on("click",function(){
                    var $current = $(this);
                    window.cityapi.change($current.data("city-id"),function(re){
                        $root.find("span.text").text(re.cityName);
                        $("#cityName").html(re.cityName);
                        $("#toCity").html(re.cityName+"&nbsp;<span class=\"arrow-bottom1\"></span>");
                        $("#district").val(re.cityCode);
                        $("#cityId").val(re.area);
                        
                         if($("#startAddr").val()!="${ctp:i18n('didicar.callcar.usecar.add')}"){
                           $("#startAddr").val("");
                           $("#startLocation").val("");
                          
                        }
                         if($("#toAddr").val()!="${ctp:i18n('didicar.callcar.usecar.add')}"){
                          
                           $("#toAddr").val("");
                           $("#toLocation").val("");
                        }
                        cityId= re.area;
                        //城市切换重现获取城市车型
                        getCityCarType(re.cityCode);
                    })
                    $root.cityhide();
                })
            }
        });
      
        cityId="1";
        

});

//获取城市车型
function getCityCarType(district){
    dManager.getCityCar(district, {
        success: function(result) {
            filterCityCar(result);      
        }});
}
function addDate(a,dadd){
    a = a.valueOf();
    a = a + dadd * 24 * 60 * 60 * 1000;
    a = new Date(a);
    return a;
}
//获取当前选中的车型
var getCurrentCarLevel = function () {
    if (showCityCar.length <= 0) {
        return 0;
    }

var selectValue=$("#quitcar").attr("class");
        if(selectValue==="quitcar"){
         return {
            rule: 301,
            level: 600
        };
        }else{
         var carLevel = $("#carLevelView").find(".active").find("div").attr("dd-data");
         return {
            rule: 201,
            level: parseInt(carLevel)
        };
        }
  
};
function filterCityCar(carcity){
    var ddCityCar=[];
    showCityCar=[];
    var rules=carcity.rule.split(",");
    for(var i=0;i<rules.length;i++){
         var rule = rules[i];
         ddCityCar[rule] = carcity["require_level_" + rule];
         showCityCar.push({"rule": rule, "name": C_CarRule[rule]});
    }
    var html=refreshCarRule(showCityCar);
    $(".car_select_con").html(html);

    if (ddCityCar[201] && ddCityCar[201].length > 0) {
        var html=refreshCarLevel(ddCityCar);
    
        $("#carLevelView").html(html);
        
        
    }
        //默认叫快车
        //$(".call_to_car").html("叫快车");
    if(ddCityCar[301].length>0){
     $("#special_car_type").height(0);
        $("#carLevelView").hide();
    }
       
        calculatePrice();
}

function refreshCarRule(showRules){
    var html="<ul class='box'>";
    for(var i = 0;i < showRules.length;i++){
    
            var ruleObj = showRules[i];
            var licss="";
      
      var carId="";
            if(ruleObj.rule == 301){
                licss="quitcar";
        carId="quitcar";
            } else if(ruleObj.rule == 201){
                licss="specialcar";
        carId="specialcar";
            }

           if(showRules.length==1){
           licss="quitcar";
           }
           html+="<li class=\""+licss+"\" id=\""+carId+"\">"+ruleObj.name+"</li>";
    }
     html+="</ul><!--get_car  special_car  分别对应：快车 专车 的定位-->"
     return html;
}
function refreshCarLevel(ddCityCar){
    var html="";
      for(var i = 0; i < ddCityCar[201].length;i++){
        var carLevel = ddCityCar[201][i];
        var sclass="carLevel";
        var liClass="";
        if(i == 0){
        sclass="carOverLevel "+ " s"+carLevel.car_level;
        liClass=" active";
        }else{
        
        sclass =sclass+ " s"+carLevel.car_level;
        }   
     html+="<li class=\"carleverLi"+liClass+"\" id=\"s"+carLevel.car_level+"\"><h6 class=\"mui-h6\">"+carLevelName[carLevel.car_level]+"</h6><div  class=\""+sclass+"\" dd-data=\""+carLevel.car_level 
    +"\"></div></li>";
    }
    return html;
}
function refreshCarCity(CarCity,type){
    
    return h;
}
var placeSearch = function (keyword, cityName) {
    var obj={
        "city": cityName,
        "input": keyword
    }; 
       var bottomValue = "95px";
       var searchListContentView = $(".search_list_content");
       dManager.suggest(obj, {
           success: function(result) {
               var searchPoiList = [];
               if (result && result.errmsg == "SUCCESS") {
                   searchPoiList = result.placeData;
                   if (placeSearchtype === 1) {
                       bottomValue = "160px";
                   }
                   searchListContentView.css({
                       "top": bottomValue,
                       "display": "block"
                   });
               } else {
                   if (placeSearchtype === 1) {
                       bottomValue = "161px";
                   }
                   searchPoiList = [];
                   searchListContentView.css({
                       "top": bottomValue,
                       "display": "block"
                   });
               }

               var html = tplSearchList(searchPoiList);
               searchListContentView.find("ul").html(html);  
               $(document).one("click", function () 
                 {
                     $(searchListContentView).hide();
                 });
         
           },
           error : function(){
           }
       }); 
};
function tplSearchList(searchPoiList){
    var html="";    
    var cityName=$("#cityName").html();
    for(var i = 0; i < searchPoiList.length;i++ ){
        var poiObj = searchPoiList[i];
        html+="<li class=\"mui-ellipsis\" dd-data='"+JSON.stringify(poiObj) 
        +"'> <span class=\"text_aaa\">"+poiObj.displayName +"</span><small>"
        +cityName+poiObj.address +"</small></li>";
    } 
    html+="<li style=\"border-bottom: 1px #ccc solid;\">";
        if(searchPoiList.length <= 0){ 
        html+="<span class=\"text_aaa\">${ctp:i18n('didicar.callcar.tip.search')}</span>";
         }else{ 
        html+="<span class=\"text_aaa FF8\">${ctp:i18n('didicar.callcar.tip.hide')}</span>";
         } 
    html+="</li>";
    return html;
}
var calculatePrice = function () {
    var startLocation = $("#startLocation").val();
    if (startLocation && startLocation.length > 0) {
        startLocation = JSON.parse(startLocation);
    } else {
        $("#price").html("0");
        return;
    }
    var toLocation = $("#toLocation").val();
    if (toLocation && toLocation.length > 0) {
        toLocation = JSON.parse(toLocation);
    } else {
        var startAddr=$("#startAddr").val();
        var toAddr=$("#toAddr").val();
        if(startAddr!=""&&toAddr!=""){
           // alert("请选择正确地址");
           return;
        }else{
        $("#price").html("0");
        }
        
        return;
    }

    var currentSelCarLevel = getCurrentCarLevel();
    if (currentSelCarLevel == 0) {
        $("#price").html("0");
        return;
    }
    
    var type=0;//0实时，1预约
    if($("#submitcall").html()=="${ctp:i18n('didicar.callcar.tip.carcall.appointment')}"){
        type=1;    
    }

    var params = {
        "flat": startLocation.lat,
        "flng": startLocation.lng,
        "tlat": toLocation.lat,
        "tlng": toLocation.lng,
        "carLevel": currentSelCarLevel.level,
        "rule": currentSelCarLevel.rule,
        "city": cityId,
        "type": type
    };
    if(type==1){
        params.departureTime=(typeof(departureTime) == 'undefined'||departureTime==null)?"":ChangeTimeToString(departureTime);//departureTime 预约情况下打车时间
    }
    dManager.calculateprice(params, {
        success: function(result) {
            if (result && result.errmsg == "SUCCESS") {
                if(result.price && Number(result.price) >= 0){
                    calculatePriceShow = result.price;
                    $("#price").html(calculatePriceShow);
                }else{
                    $.alert("${ctp:i18n('didicar.callcar.tip.price.error')}");
                }
            }           
        }});
};
var callCar = function () {
    $("#submitcall").attr("disabled",true);  
    var startAddr = $("#startAddr").val();
    var toAddr = $("#toAddr").val();
    var startLocation = $("#startLocation").val();
    var toLocation = $("#toLocation").val();
    startLocation = JSON.parse(startLocation);
    toLocation = JSON.parse(toLocation);
    var currentSelCarLevel = getCurrentCarLevel();
    var phone=$("#phone").val();
    var time = ChangeTimeToString(new Date());
    var passengerName=$("#name").val();
    var type=0;//0实时，1预约
    if($("#submitcall").html()=="${ctp:i18n('didicar.callcar.tip.carcall.appointment')}"){
        type=1;    
    }
    var carReason=$("[name='carReason']").filter(":checked").val();
    var orderMemo=$("#remark").val();
    var role="${role}";
     var params = {
        "phone": phone,
        "flat": startLocation.lat,
        "flng": startLocation.lng,
        "tlat": toLocation.lat,
        "tlng": toLocation.lng,
        "carLevel": currentSelCarLevel.level,
        "rule": currentSelCarLevel.rule,
        "type": type,
        "passengerName" :passengerName,
        "startName": startAddr,
        "endName": toAddr,
        "endAddress": toAddr,
        "city": cityId,
        "clientDatetime": time,//apptime
        "orderMemo" :encodeURIComponent(orderMemo.replace(/[\r\n]/g,"")),
        "carReason" :carReason,
        "role":role,
        "orderFrom":"PC",
        "estimatePrice":$("#price").html()
    };
    if(type==1)
        params.departureTime=(typeof(departureTime) == 'undefined'||departureTime==null)?"":ChangeTimeToString(departureTime);//departureTime 预约情况下打车时间
     dManager.order(params, {
         success: function(result) {
            if (result && result.errmsg == "SUCCESS") {
                if (result.orderid) {
                    //叫车成功
                   $.confirm({
            'msg': "${ctp:i18n('didicar.callcar.tip.success')}",
            cancel_fn : function() {
              $("#name").val("");
              $("#phone").val("");
              $("#submitcall").attr("disabled",false);
            },
            ok_fn: function() {
              window.location.href = "didicarOrderController.do?method=record&from="+"${param.from}"+"&orderFrom=PC&orderidPC="+result.orderid; 
            }
          });
                }else {
                        $.alert("${ctp:i18n('didicar.callcar.tip.fail')}" + result.errmsg);
                }               
            }           
         },
         error: function(returnVal){
           var sVal=$.parseJSON(returnVal.responseText);
           $.alert(sVal.message);
         }
     });
};
var C_CarRule = {
        301: "${ctp:i18n('didicar.plugin.information.mode.301')}",
        201: "${ctp:i18n('didicar.plugin.information.mode.201')}"
    };
var ChangeTimeToString = function (DateIn) {
    //初始化时间
    var Year = DateIn.getFullYear() || 0;
    var Month = DateIn.getMonth() + 1 || 0;
    var Day = DateIn.getDate() || 0;
    var Hour = DateIn.getHours() || 0;
    var Minute = DateIn.getMinutes() || 0;
    var Seconds = DateIn.getSeconds() || 0;

    var currentDate = Year + "-";
    if (Month >= 10) {
        currentDate = currentDate + Month + "-";
    } else {
        currentDate = currentDate + "0" + Month + "-";
    }
    if (Day >= 10) {
        currentDate = currentDate + Day;
    } else {
        currentDate = currentDate + "0" + Day;
    }

    if (Hour >= 10) {
        currentDate = currentDate + " " + Hour;
    } else {
        currentDate = currentDate + " 0" + Hour;
    }

    if (Minute >= 10) {
        currentDate = currentDate + ":" + Minute;
    } else {
        currentDate = currentDate + ":0" + Minute;
    }

    if (Seconds >= 10) {
        currentDate = currentDate + ":" + Seconds;
    } else {
        currentDate = currentDate + ":0" + Seconds;
    }
    return currentDate;
};
</script>
    </script>
</head>

<body> 
<div id='layout' class="comp" style="overflow: auto">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F21_didi_callcar_${param.from}'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false"></div>
                         
    <div class="form_area">
        <div class="one_row" style="width:50%;">
         <br>
            <table border="0" cellspacing="0" cellpadding="0" align="center">
                <tbody>    
                     <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.callcar.usecar.time.title')}:</label></th>
                        <td width="100%" colspan="3">
                            
                            <div class="userdaytime" id="selectTimeBtn" style="margin-left:15px;display:inline-block; line-height: 26px;
                                border: 1px solid #ccc; width: 490px; text-align: left; cursor: pointer;border-radius: 3px;text-decoration:none;padding-left:12px">
                                    ${ctp:i18n('didicar.callcar.usecar.time.now')}<div style="float: right"><span class="arrow-bottom"></span></div>
                            </div>
                             <div class="timesGroups" id="timesGroups" style="margin-left:15px;top: 37px; left: 10px;">
                                <div class="dayGroup"></div>
                                <div class="hourGroup"></div>
                                <div class="minuteGroup"></div>
                            </div>
                            <input id="time" type="hidden">
                            
                        </td>
                    </tr>    
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text"> ${ctp:i18n('didicar.callcar.usecar.star')}:</label></th>
                        <td width="100%" colspan="3">
                            <div id="city" class="citySelect" style="margin-left:15px;padding-left:12px"><span id="cityName">${ctp:i18n('didicar.callcar.usecar.beijing')}</span>
                            <span  class="arrow-bottom1"></span>
                                <input type="hidden" id="district" value="1"/>
                                <input type="hidden" id="cityId" value=""/>
                            </div>
                            <div style="margin-top:10px;vertical-align:middle!important;">
                            <input type="text" style="border-radius:0px 3px 3px 0px;width: 420px;" id="startAddr" value="${ctp:i18n('didicar.callcar.usecar.add')}"/>
                            
                            </div>
                            <input id="startLocation" type="hidden"/>
                            <div class="search_list_content" >
                                <ul> </ul>
                            </div>
                        </td>
                    </tr> 
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.callcar.usecar.end')}:</label></th>
                        <td width="100%" colspan="3" style="margin-top: 10px;">
                            <div id="toCity" class="citySelect" style="margin-left:15px;padding-left:12px">
                              ${ctp:i18n('didicar.callcar.usecar.beijing')}&nbsp;<span class="arrow-bottom1"></span>
                            </div>
                            <div style="margin-top: 10px;">
                            <input type="text" style="vertical-align:middle!important;border-radius:0px 3px 3px 0px;width: 420px;" id="toAddr" value="${ctp:i18n('didicar.callcar.usecar.add')}"/>
                            
                            </div>
                            <input id="toLocation" type="hidden"/>
                        </td>
                    </tr>
                    <tr>
                       <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.callcar.usecar.carType')}:</label></th>
                       <td  width="100%" colspan="4">
                       <div style="margin-left:15px;margin-top:0px!important;">
                         <div id="car_select_con" class="car_select_con" style="width:490px;margin-bottom: 2px;height:60px;margin-top:0px!important;">
                        </div>
                             
                                 <div class="special_car_type">
                                   <ul id="carLevelView">
                
                                     </ul>
                                </div>
                          </div>
                       </td>
                    </tr>
                   
                    <tr >
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.information.name')}:</label></th>
                        <td width="100%" colspan="3">
                         <div style="margin-top: 10px;margin-left:15px;padding:0;">
                            <input type="text" id="name" style="width:490px;">
                            </div>
                        </td>
                        
                    </tr>
                        <tr >
                        
                        <th nowrap="nowrap">
                            <label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.record.mobile')}:</label>
                        </th>
                        <td width="100%" colspan="3">
                        <div style="margin-top: 10px;margin-left:15px;padding:0;">
                            <input type="text" id="phone" style="width:490px;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.callcar.usecar.reason')}:</label></th>
                        <td width="100%" colspan="3">
                        <div style="margin-left:15px;padding0;">
                            <label><input type="radio" checked="checked" name="carReason" value="0"/>${ctp:i18n('didicar.callcar.usecar.Businesstrip')}&nbsp;&nbsp;</label>
                            <label><input type="radio" name="carReason"  value="1" />${ctp:i18n('didicar.callcar.usecar.travel')}&nbsp;&nbsp;</label> 
                            <label><input type="radio" name="carReason" value="2" />${ctp:i18n('didicar.callcar.usecar.overtime')}&nbsp;&nbsp;</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('didicar.plugin.order.memo')}:</label></th>
                        <td width="100%" colspan="3">
                        <div style="margin-top: 10px;margin-left:15px;padding:0;width:490px!important;;">
                            <textarea rows="2" placeholder="${ctp:i18n('didicar.callcar.usereason')}" id="remark" style="padding-left:12px"></textarea>
                            </div>
                        </td>
                    </tr>
                
                    
                     </tbody>
            </table>
                   <hr style="height:1px;border-top:1px solid #444444;margin:15px 0px 0px 0px;" />
               <div  align="center">
                   <table border="0" cellspacing="0" cellpadding="0" align="center"> 
                     <tr> 
                        <td align="center"> 
                            <label  style="font-size:24px;">${ctp:i18n('didicar.callcar.usecar.cost')}&nbsp;&nbsp;<span id="price" style="font-size:30px;color:#3486b7;"></span>&nbsp;&nbsp;元</label>
                        </td>
                     </tr>
                     <tr>
                        <td align="center">
                             <button id="submitcall" style="margin:10px 0px 10px 0px;font-size:24px;width: 170px;color:#3486b7;" >
                                <span >叫车</span>
                            </button>
                        </td>
                     </tr>
                   
                   </table>
                </div>
                
                
        </div>
    </div>

</div>

</body>
</html>
