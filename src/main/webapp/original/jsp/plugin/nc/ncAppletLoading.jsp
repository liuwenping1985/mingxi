<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ page import="java.util.List" %>
<%@ page import="com.seeyon.apps.nc.multi.NCMultiManager" %>
<%@ page import="com.seeyon.apps.nc.multi.NCMultiManager.Provider" %>
<%@ page import="com.seeyon.ctp.common.AppContext" %>
<%@ page import="com.seeyon.apps.nc.constants.NCConstants" %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<script type="text/javascript">
var scheduleSectionManager=RemoteJsonService.extend({
  jsonGateway:"/seeyon/ajax.do?method=ajaxAction&managerName=scheduleSectionManager",
       checkHistoryNCMessage: function(){
                    return this.ajaxCall(arguments,"checkHistoryNCMessage");
  },
       getNCPending: function(){
                    return this.ajaxCall(arguments,"getNCPending");
  },
       getNCUserPK: function(){
                    return this.ajaxCall(arguments,"getNCUserPK");
  },
       getPendingTotal: function(){
                    return this.ajaxCall(arguments,"getPendingTotal");
  },
       getTargetClass: function(){
                    return this.ajaxCall(arguments,"getTargetClass");
  },
       init: function(){
                    return this.ajaxCall(arguments,"init");
  },
       isPreFiltered: function(){
                    return this.ajaxCall(arguments,"isPreFiltered");
  },
       queryNCMessage: function(){
                    return this.ajaxCall(arguments,"queryNCMessage");
  },
       setPreFiltered: function(){
                    return this.ajaxCall(arguments,"setPreFiltered");
  }
  });
var reloadPro =new Properties();
var isChangeSpace = false;
var count=1000;
var manager = new scheduleSectionManager();
var contant5Version = "<%=NCConstants.NC5VERSION%>";
var version = "${ctp:getSystemProperty('ntp.aancversion')}";
function openNCPending(ncMark,id, userCode, unitCode){
  var nf = document.getElementById("frameid_"+ncMark);
  if(nf==null||nf==''||nf=='undefined'){
	  createNCAppletIframe(ncMark);
	  $.alert("${ctp:i18n('nc.section.message.alert')}");
	  return;
  }
  nf.contentWindow.openNCPending(ncMark,id, userCode, unitCode);
}
function openHistoryNCMessage(ncMark,id, userCode, unitCode){
 try{
	var params = new Object();
	if( unitCode=='undefined' || unitCode=='{3}'){
		unitCode = userCode;
		userCode = id;
		id = ncMark;
		ncMark = '<%=NCConstants.DEFAULT_EHR%>';
	}
	params['providerId'] = ncMark;
	params['memberId'] ="${ctp:currentUser().id}";
	params['userCode'] = userCode;
	params['id'] = id;
	var returnString = manager.checkHistoryNCMessage(params);
	if(returnString !==null && returnString!=='null'){
		$.alert(returnString);
		return;
	}
	openNCPending(ncMark,id, userCode, unitCode);
 }catch(e){}
	
}
function loadNCApplet(ncSectionId){
  try{
  var id=ncSectionId.replace('NCPendingSection_','');
  // setTimeout("createNCAppletIframe()", 7000);
  var nf = document.getElementById("frameid_"+id);
  if(nf===null||nf===''||nf==='undefined'||nf==="null"){
      setTimeout("createNCAppletIframe('"+id+"')", count);
      count+=1000;
  }else{
  if(isChangeSpace&&reloadPro.get(id)==null){
         reloadPro.put(id,id);
         var frameurl="/seeyon/genericController.do?ViewPage=plugin/nc/ncAppletIframe&fromNC="+id;
         nf.src = frameurl;
      }
  }}catch(e){}}
function createNCAppletIframe(id){
  try{
  var frameurl="/seeyon/genericController.do?ViewPage=plugin/nc/ncAppletIframe&fromNC="+id;
  var frame = document.createElement("iframe");
  frame.id = "frameid_"+id;
  frame.style.position = "relative";
  frame.style.left = 0;
  frame.style.top = 0;
  frame.style.width = 0;
  frame.style.height = 0;
  frame.frameBorder = 0;
  frame.width = 0;
  frame.height = 0;
  frame.desingMode="off";
  frame.src = frameurl;
  document.body.appendChild(frame);
  reloadPro.put(id,id);
  }catch(e){
      alert(e.message);
  }
  }
  
function destroy(ncMark)
{
    try{
      var providerId=ncMark.substring(3);
        isChangeSpace=true;
        reloadPro.clear();
        count=1000;
        var nf = document.getElementById("frameid_"+providerId);
        nf.contentWindow.destroy(providerId);
    }catch(e){}
}
function relPage(ncMark){
  try{
    var providerId=ncMark.substring(3);
   var nf = document.getElementById("frameid_"+providerId);


  if (contant5Version === version) {
        if (nf === "" || nf === null || nf === "null") {
          alert("${ctp:i18n('nc.space.cache.tip')}");
          return "";
        }
      }
      return nf.contentWindow.relPage(providerId);
    } catch (e) {
    }
    return "";
  }
</script>
