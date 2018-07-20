﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>S2S同步</title>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet"href="<c:url value='/apps_res/uc/chat/css/uc.css${ctp:resSuffix()}' />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/V3X.js${ctp:resSuffix()}" />"></script>
<html:link renderURL='/uc/s2s.do' var="s2sUrl" />
<script type="text/javascript">
var id;
var isGo=false;
 //执行方法
 function go(){
   id=setInterval("pollServer()",1000);
 }
//刷新，重新发送
 function pollServer(){
   var url = "${s2sUrl}"+"?method=getStatus";
   var datas = {
       
   };
   $.post(url, datas, function(jsonObj) {
     var map = $.parseJSON(jsonObj);
     //完成百分比
     var percent_complete = map.synStatus;
     var synLog= map.synLog;
     var synAllLog=map.synAllLog;
     var synConn=map.synConn;
     progressBar.setProgress(percent_complete);
     if(-1 == synConn){
       progressBar.setTitle($.i18n('uc.syn.1.js'));
       clearInterval(id);
       isGo=false;
       $("#btn2").hide();
       $("#btn3").hide();
       $("#btn1").show();
     }else{
       if(1<percent_complete&&percent_complete< 5){
         progressBar.setTitle($.i18n('uc.syn.2.js'));
       }else if(5<=percent_complete&&percent_complete < 15){
         progressBar.setTitle($.i18n('uc.syn.3.js'));
       }else if (percent_complete == 16) {
    	 progressBar.setTitle($.i18n('uc.syn.216.js',synLog));
       }else if(percent_complete == 17){
         progressBar.setTitle($.i18n('uc.syn.4.js',synLog));
       }else if(25<=percent_complete&&percent_complete < 35){
         progressBar.setTitle($.i18n('uc.syn.5.js',synLog));
       }else if(35<=percent_complete&&percent_complete < 45){
         progressBar.setTitle($.i18n('uc.syn.6.js',synLog));
       }else if(45<=percent_complete&&percent_complete < 55){
         progressBar.setTitle($.i18n('uc.syn.7.js',synLog));
       }else if(55<=percent_complete&&percent_complete < 65){
         progressBar.setTitle($.i18n('uc.syn.8.js',synLog));
       }else if(65<=percent_complete&&percent_complete < 75){
         progressBar.setTitle($.i18n('uc.syn.9.js',synLog));
       }else if(75<=percent_complete&&percent_complete < 85){
         progressBar.setTitle($.i18n('uc.syn.10.js',synLog));
       }else if(85<=percent_complete&&percent_complete < 90){
         progressBar.setTitle($.i18n('uc.syn.11.js',synLog));
       }else if(90<=percent_complete&&percent_complete < 95){
         progressBar.setTitle($.i18n('uc.syn.12.js'));
       }else if(95<=percent_complete&&percent_complete < 100){
         progressBar.setTitle($.i18n('uc.syn.13.js'));
       }else if(100 == percent_complete){
         clearInterval(id);
         progressBar.setTitle($.i18n('uc.syn.14.js',synAllLog));
         isGo=false;
         $("#btn2").hide();
         $("#btn1").hide();
         $("#btn3").show();
       }
     } 
   });
 }
  
  $(document).ready(function() {
    progressBar = new MxtProgressBar({
      id: "s2sBar",
      text: $.i18n('uc.syn.15.js'),
      progress: 1,
      buttons: [{
        text: $.i18n('uc.syn.16.js'),
        id:"btn1",
        handler: function () {
          startSyn();
        }
      },{
	        text: $.i18n('uc.syn.17.js'),
	        id:"btn2",
	        handler: function () {
	          stopSyn();
	        }
	    },{
          text: $.i18n('uc.syn.18.js'),
          id:"btn3",
          handler: function () {
        	window.parentDialogObj['sysDile'].closeParam.handler();
          }
      }]
    });
    $("#btn2").hide();
    $("#btn3").hide();
    progressBar.setProgress(0);
    if("${s2sOpen}"==0){
      isGo=false;
    }else{
      isGo=true;
      go();
    }
    startSyn();
  });

  function startSyn(){
    $("#btn1").hide();
    $("#btn2").show();
    $("#btn3").hide();
     if(!isGo){
        go();
        progressBar.setTitle($.i18n('uc.syn.16.js')+"...");
        progressBar.setProgress(0);
        var url = "${s2sUrl}"+"?method=ajaxSyn";
        var datas = {
            
        };
        $.post(url, datas, function(data) {

        });
        isGo=true;
     }else{
        alert($.i18n('uc.syn.19.js'));
     }
  }
  
  function CLOSE (json) {
	  stopSyn();
	  return "";
  }
  
  function stopSyn(){
    if(isGo){
	    var url = "${s2sUrl}"+"?method=stopSyn";
	    var datas = {
	        
	    };
	    $.post(url, datas, function(data) {
	         if(data=='1'){
	           clearInterval(id);
	           progressBar.setTitle($.i18n('uc.syn.20.js'));
	           isGo=false;
               $("#btn3").hide();
	           $("#btn2").hide();
	           $("#btn1").show();
	         }
	    });
    }
  }
</script>
</head>
<body>
</body>
</html>