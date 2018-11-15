//<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
//window.onerror = fnErrorTrap;
//function fnErrorTrap(sMsg,sUrl,sLine){
//  event.returnValue=true;
//}
//
//var _parent = window.opener;
//
//if(window.dialogArguments){
//    _parent = window.dialogArguments;
//}
//    
//window.onload = function(){ 
//    var policyArr;
//    var policyId = "";
//    var policyName = "";
//    try{
//        if(_parent.selectPolicyForm){
//            policyArr = _parent.selectPolicyForm.policy.options;
//        }else{
//            policyArr = _parent.insertPeopleForm.policy.options;
//        }
//    }catch(e){}
//    if(policyArr != null && policyArr != "undefined"){
//        for(var i=0; i<policyArr.length; i++){
//            if(policyArr[i].selected){
//                policyName = policyArr[i].text;
//                policyId = policyArr[i].value;
//                break;
//            }
//        }
//    }
//    var desArr = _parent.desArr;
//    var description = "";
//    for(var i=0; i<desArr.length; i++){
//        var desStr = desArr[i].split("split");
//        var _policyId = desStr[0];
//        var _description = desStr[1];
//        if(_policyId == policyId  && _description != 'null' && _description != null){
//            description = _description;
//        }
//    }
//    //document.getElementById("content").value = "<%--${des} --%>";
//    //document.getElementById("div1").innerHTML = document.getElementById("policyExplainHTML").innerHTML;
//}
//
//var policyArr;
//try{
//    if(_parent.selectPolicyForm){
//        policyArr = _parent.selectPolicyForm.policy.options;
//    }else{
//        policyArr = _parent.insertPeopleForm.policy.options;
//    }
//}catch(e){}
//var policyName = "";
//if(policyArr != null && policyArr != "undefined"){
//    for(var i=0; i<policyArr.length; i++){
//        if(policyArr[i].selected){
//            policyName = policyArr[i].text;
//        }
//    }
//}