<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title></title>
<script type="text/javascript"  src="${path}/ajax.do?managerName=didicarManager"></script>
<link rel="stylesheet" type="text/css" href="apps_res/didicar/css/carOrder.css">
<c:set var="car1" value="didicar.plugin.information.models.${detail.carLevel}">
</c:set>
<%
String carType=(String)pageContext.getAttribute("car1");
String carTypeI18n=com.seeyon.ctp.common.i18n.ResourceUtil.getString(carType);
%>
<script type="text/javascript">
var str="00";
var minStr = "00";
var  dManager = new didicarManager();
var orderid = ${detail.orderid};
var timeShow;
var timeDetail;
var force=false;
var timeTitle= "${ctp:i18n('didicar.callcar.has')}";
var driverNotify = "${ctp:i18n('didicar.callcar.has.special.notify')}";
var carLevel="<%=carTypeI18n%>";
var single = "${ctp:i18n('didicar.callcar.single')}";
function tPlus(s) {
    var rs = parseInt(s) + 1;
    if (rs < 10) {
        return '0' + rs;
    }
    if (rs == 60) {
        minStr = parseInt(minStr) + 1;
        if (minStr < 10) {
            minStr = '0' + minStr;
        }
        rs = "00";
    }
    return rs;
}
 function tick(first) 
   { 
   var layOut=document.getElementById("centerLayOut");
   layOut.className ="addCenterLayOut";
   layOut.innerHTML=showLocale(first); 

}
function showLocale(first) 
{ 
  if(!first){
    str=tPlus(str); 
  }

return("<p>"+minStr+":"+str+"</P>"+"<p style='font-size: 10px;'>"+timeTitle+"</p>"); 
}

function showDriverNumber(driverNum){
  
  var imgS=document.getElementById("imgS");
  imgS.className="addCenterLayOut";
  imgS.innerHTML="<p>"+driverNum+"</P>"+"<p style='font-size: 10px;'>"+driverNotify+"</p>";
}

function showPicture(result){
  var imgS=document.getElementById("imgS");
  imgS.innerHTML="<img src=\""+result.driverPicture+"\" />";
}

function showDriver(result){

}
function showDriverPhone(result){
 
}
function showStatus(result){
  var imgS=document.getElementById("padding_l_10");
  imgS.className="padding_l_10";
  imgS.innerHTML=result.status;
  if(result.driverName!=""){
    
    
  var layOut=document.getElementById("centerLayOut");
  layOut.className="layout_left_center";
  layOut.innerHTML="<ul id=\"driverInfo\"><li class=\"li\"><strong>"+result.driverName+"</strong></li><li>"
  +result.driverCard+"&nbsp;"+result.driverCarType+"&nbsp;"+carLevel+"</li><li><img src=\""+
  "apps_res/didicar/images/star.png\" class=\"smallicon\"/>"+"&nbsp;"+result.driverLevel
  +"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+result.driverOrderCount+single+"</li></ul>";
  
  var driverPhone=document.getElementById("layout_left_right");
  driverPhone.className="layout_left_right";
  driverPhone.innerHTML="<p><img src=\"apps_res/didicar/images/dphone.png\" class=\"smallicon\"/>&nbsp;<span class=\"driverphone\">"+result.driverPhone+"</span></p>"
  }
}
function getDetail(first) 
   {
    var params = {
        "orderid": "${param.orderId}"
    };
  dManager.requestOrder(params, {
        success: function(result) {
            if (result && result.errmsg == "SUCCESS") {
                if(result.statusCode == '300'){
                  if(first){
                    tick(first);
                    timeShow=window.setInterval("tick()",1000);
                  }
                  showDriverNumber(result.driverNum);
                }else{
                  force=true;
                clearInterval(timeShow);
                showStatus(result)
                showPicture(result);
                if(result.statusCode=="311"){
                  clearInterval(timeDetail);
                }
                if(result.statusCode=="500"||result.statusCode=="000"){
                  $("#cancelbtn").hide();
                }
                if(result.statusCode=="700"){
                  clearInterval(timeDetail);
                  var bottomePrice = $("#bottom");
                   var priceC="";
                  for (var i=0;i<result.price.length;i++)
                    {
                     priceC=priceC+result.price[i].name+":"+result.price[i].amount+"&nbsp;&nbsp;";
                    }
                    var priceH="<p>"+"${ctp:i18n('didicar.callcar.total.price')}"+":"+result.totalPrice+"&nbsp;&nbsp;"+priceC+"</p>";
                    
                    bottomePrice.html(priceH);
                    bottomePrice.show();
                }
                }
              // if(result.statusCode !== '300'){
              // clearInterval(timeShow);
               //clearInterval(timeDetail);
                  //location.reload();
              // }
            }           
        }});
   
}
$().ready(function() {


  if(${detail.statusCode==700}){
    $("#bottom").show();
     $("#cancelbtn").hide();
  }else if(${detail.statusCode==000||detail.statusCode==610||detail.statusCode==600||detail.statusCode==311}){
   $("#cancelbtn").hide();
  $("#bottom").hide();
  }else if(${detail.statusCode==300||detail.statusCode==400||detail.statusCode==410||detail.statusCode==500}){
    $("#bottom").hide();
    var ss = 1000*3;
    if(${detail.statusCode==300}){
      getDetail(true);
    }else{
       ss=1000*10
    }
      if(${detail.statusCode==500}){
       $("#cancelbtn").hide();
      }
      
    timeDetail=window.setInterval("getDetail()",ss); 
  }else{
     $("#bottom").hide();
  }
   $("#cancelbtn").click(function() {
        var params = {
        "orderid": "${param.orderId}",
         "force": force
    }

     dManager.cancelOrder(params, {
        success: function(result) {
            if (result && result.errmsg == "SUCCESS") {
              var status=document.getElementById("padding_l_10");
              status.className="padding_l_10";
              status.innerHTML="${ctp:i18n('didicar.callcar.cancel')}";
              clearInterval(timeShow);
              clearInterval(timeDetail);
              $.messageBox({
                'type':0,
                'imgType':0,
                'msg':"${ctp:i18n('didicar.callcar.cancel.success')}",
                ok_fn:function() {
                  parent.location.href = "didicarOrderController.do?method=record&from="+"${param.from}";
                }
              });
            }else{
                $.alert(result.errmsg);
            }           
        }});
   
   });

});


</script>
</head>
<body scroll='no' oncontextmenu="return false" onselectstart="return false">


    <div class="layout_center padding_l_10">

        <div class="layout_left">
            <p class="padding_l_10" id="padding_l_10">${detail.status}</P>
            <div class="layout_left_left">
            
               <span id="imgS">
               <c:if test="${!empty detail.driverPicture}">
                <img
                    src="${detail.driverPicture}" />
                    </c:if>
               </span>
               
            </div>
            <div class="layout_left_center" id="centerLayOut">
                <ul id="driverInfo">
                    <c:if test="${!empty detail.driverName}">
                    <li class="li"><strong>${detail.driverName }</strong></li>
                    <li>${detail.driverCard }&nbsp;${detail.driverCarType }&nbsp;<%=carTypeI18n%></li>
                    
                    <li><img src="${path}/apps_res/didicar/images/star.png" class="smallicon"/>&nbsp;${detail.driverLevel}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${detail.driverOrderCount }${ctp:i18n("didicar.callcar.single")}</li>
                    </c:if>
                </ul>
            </div>
            <div class="layout_left_right" id="layout_left_right">
                <p>
                <c:if test="${!empty detail.driverPhone}">
                <img src="${path}/apps_res/didicar/images/dphone.png" class="smallicon"/>&nbsp;
                </c:if>
                <span class="driverphone">${detail.driverPhone}</span>
                </p>
            </div>
            </br> </br>
            <div class="layout_left_left">
                
            </div>
        </div>
        <div class="layout_right">
            <div class="layout_right_top">
                <ul>
                    <li>${ctp:i18n("didicar.plugin.record.passenger")}:${detail.passengerPhone }</li>
                    <li>${ctp:i18n("didicar.callcar.usecar.time.title")}:<c:if test="${detail.type=='1'}">${detail.departureTime}</c:if><c:if test="${detail.type=='0'}">${detail.createTime}</c:if><c:if test="${(detail.type=='0') && (empty detail.createTime)}">${detail.departureTime}</c:if></li>
                </ul>
                <br> <br>
            </div>
            <div class="layout_right_top_right">${ctp:i18n("didicar.plugin.unit.createtime")}:<c:if test="${empty detail.createTime}">${detail.departureTime}</c:if>${detail.createTime }</div>
            <div class="layout_right_top">
                <ul>
                    <li><img src="${path}/apps_res/didicar/images/startd.png" class="smallicon"/>&nbsp;${ctp:i18n("didicar.callcar.usecar.star")}:${detail.startName}</li>
                    <li><img src="${path}/apps_res/didicar/images/end.png" class="smallicon"/>&nbsp;${ctp:i18n("didicar.callcar.usecar.end")}:${detail.endName}</li>
                </ul>
            </div>
            <div class="layout_right_top_right">
                 <input type="button" class="btn" value="${ctp:i18n('didicar.callcar.cancel')}" id="cancelbtn"/>
            </div>
        </div>

    <div class="layout_bottom" id="bottom">
        <p> 
        ${ctp:i18n('didicar.callcar.total.price')}:${detail.totalPrice}&nbsp;&nbsp;
        
         <c:forEach var="d" items="${detail.price}"> 
                     ${d.name}:${d.amount}&nbsp;&nbsp;
                    
                 </c:forEach>
        
        </p>
        <div class="layout_left_left">
                
                
       </div>
    </div>

    </div>
</body>
</html>
