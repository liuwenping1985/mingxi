/**
*根据协同类型跳转到当前登陆人协同待办,已办等页面
*/
function displayCollaboration(state){
	var url="";
	if(state=="2"){
		//已发协同
		url=window._ctxServer+"/collaboration/collaboration.do?method=listSent";
	}else if(state=="4"){
		//已办协同
		url=window._ctxServer+"/collaboration/collaboration.do?method=listDone";
	}else{
		//待办协同
		url=window._ctxServer+"/collaboration/collaboration.do?method=listPending";
	}
	window.parent.top.$("#main").attr("src",url);
}
/**
*弹出人员卡片
*/
function displayMemberInfo(obj){
	$.PeopleCard({memberId:$(obj).attr("value")});
}
/**
*新建协同(关联项目)
*/
function openCollaboration(obj){
	var projectId=$(obj).attr("value");
	var url=window._ctxServer+"/collaboration/collaboration.do?method=newColl&from=relateProject&&projectId="+projectId;
	window.open(url);
}

 function transmitColById(obj){
      var dataStr=$(obj).attr("value");
      var cm = new colManager();
      var r = cm.checkForwardPermission(dataStr);
      if(r && (r instanceof Array) && r.length > 0){
          //以下协同不能转发，请重新选择
          $.alert($.i18n('collaboration.grid.alert.thisSelectNotForward')+"<br><br>" + r.join("<br>"));
          return;
      }
      getA8Top().up = window;
      var dialog = $.dialog({
          id : "showForwardDialog",
          height:"415",
          url : _ctxPath+"/collaboration/collaboration.do?method=showForward&data=" + dataStr,
          title : $.i18n('collaboration.transmit.col.label'),
          targetWindow:getCtpTop(),
          isClear:false,
          transParams:{
              commentContent : ""
          },
          buttons: [{
              id : "okButton",
              text: $.i18n("collaboration.button.ok.label"),
              btnType:1,
              handler: function () {
                  var rv = dialog.getReturnValue();
              },
              OKFN : function(){
                  dialog.close();
                  try{
                      $("#"+grid.id).ajaxgridLoad();
                  }
                  catch(e){
                  }
              }
          }, {
              id:"cancelButton",
              text: $.i18n("collaboration.button.cancel.label"),
              handler: function () {
                  dialog.close();
              }
          }]
      });
   }
   
   function refreshSection(){
   		window.location.reload(true);
   }
