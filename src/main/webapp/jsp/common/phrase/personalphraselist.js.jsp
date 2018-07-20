<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
<script type="text/javascript">
$(function () {
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 36,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }

    });
   //讲数据加载进table
   var pManagerp = new phraseManager();
   var personalPhrase = pManagerp.findPersonalPhraseById();
   inittable(personalPhrase);
});
//填充表格数据
function inittable(personalPhrase){
	var tbodystr ="";
    for(var count = 0 ; count < personalPhrase.length ; count ++ ){
 	   if(count%2 == 0 ){
 		   tbodystr +="<tr class=\"erow\"><td style=\"word-break:break-all\">"+tranCharacter(personalPhrase[count].content)+"</td><td><em id="+personalPhrase[count].id+" name="+tranCharacter(personalPhrase[count].content)+" class=\"ico16 editor_16\" onclick=\"updateOradd(this);\"></em></td><td>"+
 		         "<em id="+personalPhrase[count].id+" class=\"ico16 del_16\" onclick=\"deleteCurPhrase(this.id);\"></em></td></tr>";
 	   }else{
 		   tbodystr +="<tr><td style=\"word-break:break-all\">"+tranCharacter(personalPhrase[count].content)+"</td><td><em id="+personalPhrase[count].id+" name="+tranCharacter(personalPhrase[count].content)+" class=\"ico16 editor_16\" onclick=\"updateOradd(this);\"></em></td>"+
 		   "<td><em id="+personalPhrase[count].id+" class=\"ico16 del_16\" onclick=\"deleteCurPhrase(this.id);\"></em></td></tr>";
 	   }
    }
    $("#personaltable tbody").html(tbodystr);
}


//转换特殊字符
 function tranCharacter(str){
	 return str;
//	if(!str){
//		return "";
//	}
//	if(str.indexOf('"') >-1){
//		str = str.replace(/"/g,'&quot;');
//	}
//	if(str.indexOf('<') >-1){
//		str= str.replace(/</g,'&lt;');
//	}
//	if(str.indexOf('>') >-1){
//		str= str.replace(/>/g,'&gt;');
//	}
//	return str;
}

//删除事件
function  deleteCurPhrase(str){
	 var confirm = "";
     confirm = $.confirm({
         'msg': "${ctp:i18n('collaboration.common.peronal.sureDeletePhrasebook')}",
         ok_fn: function () {
             //实例化Spring BS对象
             var callerResponder = new CallerResponder();
             var pManager = new phraseManager();
             var phraseid =str;
                pManager.deletePersonPhrase(phraseid,{
                success : function(phraseBean){
                    inittable(phraseBean);
                }, 
                error : function(request, settings, e){
                    $.alert(e);
                }
            });
         }
     });
}
//
function updateOradd(obj){
	//var dialog = new MxtDialog({
	 //    id:"personal_phrase_nau",
	//	 title: "${ctp:i18n('phrase.sys.js.neworupdate')}",
     //    width: 300,
     //    height: 170,
     //    htmlId: 'searchId',
     //    targetWindow:getCtpTop(),
     //    buttons: [{
     //        text: "${ctp:i18n('phrase.sys.makesure')}",
    //         handler: function () {
     //       	 if(doOper()){
     //       		 dialog.close();
     //       	 }
     //        }
     //    }, {
      //       text: "${ctp:i18n('phrase.sys.makecancle')}",
     //        handler: function () {
      //           dialog.close();
     //        }
     //    }]
	// });
	var objId = "";
	var objContent ="";
	if(obj){
		objId = obj.id;
	}
	var dialog = $.dialog({
		 targetWindow:getCtpTop(),
	     id: 'personal_phrase_nau',
	     url: _ctxPath+'/phrase/phrase.do?method=openPersonalPhraseDetail&objId='+objId,
	     width: 300,
	     height: 170,
	     checkMax:false,
	     title: "${ctp:i18n('phrase.sys.js.neworupdate')}",
	     htmlId: 'searchId',
	     buttons: [{
	         text: "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}", //确定
	         handler: function () {
               var returnValue = dialog.getReturnValue();
           	if( returnValue && returnValue != null){//返回值到父页面
           		inittable(returnValue);
           		dialog.close();
               }
	         }
	     }, {
	         text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}", //取消
	         handler: function () {
	             dialog.close();
	         }
	     }]
	 });


	 
	//if(obj){
		//$("#perphraseId").val(obj.id);
	//	$("#perphraseId",getA8Top().document).val(obj.id);
    //	//$("#phraseDes").val($(obj).attr("name"));
    //	$("#phraseDes",getA8Top().document).val($(obj.outerHTML).attr("name"));
	//}else{
		//$("#perphraseId").val("");
	//	$("#perphraseId",getA8Top().document).val("");
    	//$("#phraseDes").val("");
   // 	$("#phraseDes",getA8Top().document).val("");
	//}
}
	
//ajax执行修改或者新增
function doOper(){
	//if(!valibeforesubmit()){
	//	return false;
	//}
	//实例化Spring BS对象
	
}

//对输入的常用语做校验
function valibeforesubmit(){
	var xx = $("#phraseDes",getA8Top().document).val();
	if($.trim(xx) ==""){
		$.alert("${ctp:i18n('phrase.sys.js.cantbenull')}");
		return false;
	}
	if(xx.length>80){
		$.alert("${ctp:i18n_1('phrase.sys.js.cyycd','"+xx.length+"')}");
		return false;
	}
	return true;
}
    
</script>