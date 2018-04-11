<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${path}/apps_res/weixin/css/common.css"/>
<link rel="stylesheet" href="${path}/apps_res/weixin/css/bootstrap.min.css"/>
<script type="text/javascript" src="${path}/apps_res/weixin/js/bootstrap.min.js"></script>
<script type="text/javascript">
var isGroupVer = ${ctp:isGroupVer()};
</script>

<script type="text/javascript" src="${path}/apps_res/weixin/js/synUtil.js"></script>
  
</head>
<body class="h100b over_hidden">
	<div class="crumbly">
	    <div class="before">${ctp:i18n('weixin.system.menu.orgSyn')}</div><span class="gap">/</span><span class="current">${ctp:i18n('weixin.system.menu.orgSynWechatEnterprise')}</span>
	</div>
	<div class="w-server-set">
	    <div class="setContent" style="font-size: 14px;color: #000;">
	        <span>${ctp:i18n('weixin.org.configurationDescription')}：</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>1、${ctp:i18n('weixin.org.configurationDescription1')}</span>
	    </div>
	    <div class="setContent" style="margin-top: 5px;">
	        <span>2、${ctp:i18n('weixin.org.configurationDescription2')}</span>
	    </div>
        <div class="setContent" style="margin-top: 5px;color: red;">
            <span>3、${ctp:i18n("weixin.org.synchronization.isAdd")}：${ctp:i18n("weixin.org.synchronization.isAdd.des")}</span>
        </div>
        <div class="setContent" style="margin-top: 5px;color: red;">
            <span>4、${ctp:i18n("weixin.org.synchronization.isFull")}：${ctp:i18n("weixin.org.synchronization.isFull.des")}</span>
        </div>
	</div>
	<div id="wechatDing">
	    <div class="block">
	        <div class="name">
	            <span>CorpID:</span>
	        </div>
	        <div class="wInput">
	            <input type="text" id="cropId" value="">
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	    
	   <div class="block">
	     <div class="name">
            <span>${ctp:i18n("weixin.org.synchronization.type")}:</span>
        </div>
        <div class="content">
            <div>
                <input name="isFull" type="radio" value="0" ><i>&#xe6bb;</i><span>${ctp:i18n('weixin.org.synchronization.isAdd')}</span>
	            <input name="isFull" type="radio" value="1" style="margin-left:30px;"><i>&#xe6bb;</i><span>${ctp:i18n('weixin.org.synchronization.isFull')}</span>
            </div>
         </div>
	    </div>
		
	    <div class="block1" id="selectAccountRadioDiv">
	        <div class="name">
	            <span>${ctp:i18n('weixin.org.synchronization.selectOneAccount')}:</span>
	        </div>
	        <div class="wInput">
	            <input name="selectAccount" type="radio" value="1" ><i>&#xe6bb;</i><span>${ctp:i18n('weixin.org.yes')}</span>
	            <input name="selectAccount" type="radio" value="0" style="margin-left:30px;"><i>&#xe6bb;</i><span>${ctp:i18n('weixin.org.no')}</span>
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	
	    <div class="block" id="selectAccountDiv">
	        <div class="name">
	            <span>${ctp:i18n('weixin.org.accountName')}:</span>
	        </div>
	        <div class="wInput">
	            <!-- <textarea rows="5" cols="50" id="accountNames"></textarea> -->
	            <input type="text" id="accountNames">
	            <input type="hidden" id="accountIds">
	        </div>
	        <div style="clear: both;"></div>
	    </div>
	    <div class="block" id="startDiv">
	        <div class="wBtn">
	            <span id="start">${ctp:i18n('weixin.org.synchronization.start')}</span>
	        </div>
	    </div>
	</div>
	
	<div style="height: 10px;">
	</div>
	
 	<div class="progress progress-striped active" id="progress" style="width: 60%;" align="center">
	   	<div class="progress-bar progress-bar-success" id="progressbar" align="center" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
	      <span class="sr-only"></span>
	    </div>
    </div>
   
</body>
</html>