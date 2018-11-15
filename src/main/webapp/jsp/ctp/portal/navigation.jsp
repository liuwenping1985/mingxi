<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script>
function mainClick(url,target,id,step,pass){
  if(url!=null && url!=undefined && url!='null'){

   // 公文应用设置在非IE下不允许进入
      if (!$.browser.msie
              && url.indexOf("edocController.do?method=sysCompanyMain") != -1 ) {
          $.alert("公文应用设置页面不支持此浏览器！");
          return;
      }

	  if(pass){
		  getA8Top()._pwdModify("${ctp:i18n('menu.login.pwd.modify')}");
	    }else{
	 	 if (target == 'newWindow') {
			openCtpWindow({'url':_ctxPath+url,'id':id});
		  } else {
	     	parent.showMenu(_ctxPath+url,id,step);
		  }
	    }
  }
}
$(document).ready(function(){
  var _ctxPath = '${path}';
  $.ctx = {};
  $.ctx.menu = <c:out value="${ctp:getMenuJsonStr()}" default="null" escapeXml="false"/>;
  var mainMenuObj =  $.ctx.menu;
  var _verticalStr = "vertical-align:-2px;";
	if ($.browser.msie) {
      if ($.browser.version == '6.0' || $.browser.version == '7.0') {
      	_verticalStr = "";
      }
  }
  if(mainMenuObj){
    //yinr添加
    var _itemArray = [];
    //////////
      var _bodyh = $('body').height()-30;
      var _bodyw = $('body').width();
      for (var i=0; i<mainMenuObj.length; i++) {
          var _menu = mainMenuObj[i];
          if(_menu.url){
        	  if(_menu.url.indexOf("?")>0){
        		  _menu.url = _menu.url+"&_resourceCode="+_menu.resourceCode;
        	  }else{
        		  _menu.url = _menu.url+"?_resourceCode="+_menu.resourceCode;
        	  }
              $('#head_tr').append($("<th class='' onclick=\"mainClick('"+_menu.url+"','"+_menu.target+"','"+_menu.id+"',1)\"><div style='width:150px;' class='text_overflow hand'>"+_menu.name+"<div></th>"));
          }else{
              $('#head_tr').append($("<th class=''><div style='width:150px;' class='text_overflow hand'>"+_menu.name+"<div></th>"));
          }
          var _items = _menu.items;

          //console.log(_items.length);
          if(_items && _items.length>0){
              var bodyStr = "<td class='td' style='vertical-align:top'>"
                  <%--bodyStr+="<ul class='navigation_content' style='min-height:300px'>";--%>
                bodyStr+="<ul class='navigation_content' style='min-height:300px'>";
                  for (var g=0; g<_items.length; g++) {

                      var _item = _items[g];
					  if(_item.url){
						  if(_item.url.indexOf("?")>0){
							  _item.url = _item.url+"&_resourceCode="+_item.resourceCode;
						  }else{
							  _item.url = _item.url+"?_resourceCode="+_item.resourceCode;
						  }
					  }
                      bodyStr+="<li class='margin_t_5 margin_b_5'>";
                      if("F13_account"==_item.resourceCode||"F13_group"==_item.resourceCode||"F13_systemPassword"==_item.resourceCode||"F13_audit"==_item.resourceCode){
                    	  bodyStr+="<div style='width:150px;' class='text_overflow'><a href=\"javascript:mainClick('"+_item.url+"','"+_item.target+"','"+_item.id+"',2,true)\" class='navigation_item'><span class='ico16 arrow_2_r margin_r_5'></span><span style='"+_verticalStr+"' >"+_item.name+"</span></a></div>";
                      }else{
                    	  bodyStr+="<div style='width:150px;' class='text_overflow'><a href=\"javascript:mainClick('"+_item.url+"','"+_item.target+"','"+_item.id+"',2)\" class='navigation_item'><span class='ico16 arrow_2_r margin_r_5'></span><span style='"+_verticalStr+"' >"+_item.name+"</span></a></div>";
                      }


                          var _items2 = _item.items;
                          if(_items2 && _items2.length>0){
                              bodyStr+="<ul class='margin_l_10'>";
                                  for (var t=0; t<_items2.length; t++) {
                                      var _item2 = _items2[t];
									  if(_item2.url){
										  if(_item2.url.indexOf("?")>0){
											  _item2.url = _item2.url+"&_resourceCode="+_item2.resourceCode;
										  }else{
											  _item2.url = _item2.url+"?_resourceCode="+_item2.resourceCode;
										  }
									  }
                                      bodyStr+="<li>";
                                          bodyStr+="<div style='width:130px;' class='text_overflow'><a href=\"javascript:mainClick('"+_item2.url+"','"+_item2.target+"','"+_item2.id+"',3)\" class='navigation_item'><span class='ico16  arrow_gray_r margin_r_5'></span>"+_item2.name+"</a></div>";
                                      bodyStr+="</li>";
                                  }
                              bodyStr+="</ul>";
                          }
                      bodyStr+="</li>";
                  }
                  bodyStr+="</ul>";
                  bodyStr+="</td>";
                  $('#body_tr').append(bodyStr);
          }
      }
  }
  getCtpTop().$('#shortcut').show();
});

</script>

</head>
<body class="page_color padding_10">
<div id="qwqwqw" class="border_l border_r" style="position: absolute;top:10px;left: 10px;right: 10px;bottom:10px;">
        <table id="_table" width="100%" height="100%" class="only_table common_center margin_t_20 bg_color_white" border="0" cellspacing="0" cellpadding="0">
            <thead>
                <tr id="head_tr">
                </tr>
            </thead>
            <tbody>
                <tr id="body_tr">
                </tr>
            </tbody>
        </table>
</div>
</body>
</html>