<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%@ page import="java.util.List" %> 
<script type="text/javascript" src="${pageContext.request.contextPath}/ajax.do?managerName=scheduleSectionManager"></script>
<script type="text/javascript">
var appletList=new  ArrayList();
var reloadPro =new Properties();
var isChangeSpace = false;
var count=1000;
var manager = new scheduleSectionManager();
function openNCPending(ncMark,id, userCode, unitCode){
  var nf = document.getElementById("frameid_"+ncMark);
  if(nf==null||nf==''||nf=='undefined'){
	  createNCAppletIframe(ncMark);
	  alert("${ctp:i18n('nc.section.message.alert')}");
	  return;
  }
  nf.contentWindow.openNCPending(ncMark,id, userCode, unitCode);
}
function openHistoryNCMessage(ncMark,id, userCode, unitCode){
	var params = new Object();
	params['providerId'] = ncMark;
	var returnString = manager.checkHistoryNCMessage(params);
	if(returnString===false || returnString==='false'){
		alert("${ctp:i18n('nc.section.provider.isnull')}");
		return;
	}
	openNCPending(ncMark,id, userCode, unitCode);
}
function loadNCApplet(ncSectionId){
  try{
  var id=ncSectionId.replace('NCPendingSection_','');
  // setTimeout("createNCAppletIframe()", 7000);
  var nf = document.getElementById("frameid_"+id);
  if(nf==null||nf==''||nf=='undefined'){
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
   return nf.contentWindow.relPage(providerId);
  }catch(e){}
   return null;
}
</script>
