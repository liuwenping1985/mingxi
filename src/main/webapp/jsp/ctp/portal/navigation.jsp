<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<head>
<title>layout</title>
<script>
function mainClick(url,id,step){
  if(url!=null && url!=undefined && url!='null'){
     parent.showMenu(_ctxPath+url,id,step);
  }
}
$(document).ready(function(){
  var _ctxPath = '${path}';
  var notShowM1 = "${v3x:getSysFlagByName('m1_notShow')}";
  $.ctx = {};
  $.ctx.menu = <c:out value="${CurrentUser.menuJsonStr}" default="null" escapeXml="false"/>;
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
          //判断不显示移动管理
          if (notShowM1 == "true" && _menu.id == "-1743222263548526089") {
        	  continue;
          }
          $('#head_tr').append($("<th class='' onclick=\"mainClick('"+_menu.url+"','"+_menu.id+"',1)\"><div style='width:150px;' class='text_overflow hand'>"+_menu.name+"<div></th>"));
          var _items = _menu.items;
          
          //console.log(_items.length);
          if(_items && _items.length>0){
              var bodyStr = "<td class='td'>"
                  <%--bodyStr+="<ul class='navigation_content' style='height:"+(_bodyh-50)+"px;overflow:auto'>";--%>
                bodyStr+="<ul class='navigation_content'>";
                  for (var g=0; g<_items.length; g++) {
                      
                      var _item = _items[g];
                      bodyStr+="<li class='margin_t_5 margin_b_5'>";
                          bodyStr+="<div style='width:150px;' class='text_overflow'><a href=\"javascript:mainClick('"+_item.url+"','"+_item.id+"',2)\" class='navigation_item'><span class='ico16 arrow_2_r margin_r_5'></span><span style='"+_verticalStr+"' >"+_item.name+"</span></a></div>";
                      
                          var _items2 = _item.items;
                          //_items2 = [{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'},{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'},{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'},{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'},{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'},{url:'http://www.baidu.com',id:'1111',name:'eeeeeeeeeeeeee'}];
                          if(_items2 && _items2.length>0){
                              bodyStr+="<ul class='margin_l_10'>";
                                  for (var t=0; t<_items2.length; t++) {
                                      var _item2 = _items2[t];
                                      bodyStr+="<li>";
                                          bodyStr+="<div style='width:130px;' class='text_overflow'><a href=\"javascript:mainClick('"+_item2.url+"','"+_item2.id+"',3)\" class='navigation_item'><span class='ico16  arrow_gray_r margin_r_5'></span>"+_item2.name+"</a></div>";
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
    //yinr添加
    for(var h = 0;h < $(".navigation_content").length;h++){
        _itemArray.push($(".navigation_content").eq(h).height());
    }
    _itemArray.sort(function(a,b){
        return b-a;
    });
    for(var i = 0;i < $(".navigation_content").length;i++){
        $(".navigation_content").eq(i).css({"height":(_bodyh-27) < (_itemArray[0] + 5) ? (_itemArray[0] + 5) : (_bodyh-27) +"px"});
    }
    //////////
      $('#qwqwqw').css({
        'width':_bodyw,
        'height':$('body').height()-25,
        'overflow-x':'auto'
      });
  }
  //getCtpTop().hideLocation();
  //getCtpTop().$('#content_layout_body_left_content').addClass('border_all');
  getCtpTop().$('#shortcut').show();
  $(window).resize(function() { 
      $('#qwqwqw').width($('body').width()); 
  }); 
});

</script>

</head>
<body class="h100b page_color over_hidden padding_10  ">
<div id="qwqwqw" class="border_l border_r border_b">
        <table id="_table" width="100%" class="only_table common_center margin_t_20 bg_color_white" border="0" cellspacing="0" cellpadding="0">
            <thead>
                <tr id="head_tr">
                    <!--<th>基础设置</th>-->
                </tr>
            </thead>
            <tbody>
                <tr id="body_tr">
                    <!--
                    <td>
                        <ul class="navigation_content">
                            <li>
                                <a href="#" class="item"><span class="ico16 arrow_2_r"></span>基础设置</a>
                                <ul class="margin_l_10">
                                    <li>
                                        <a href="#" class="item"><span class="ico16 arrow_2_r"></span>基础设置</a>
                                    </li>
                                    <li><a href="#" class="item"><span class="ico16 arrow_2_r"></span>基础设置</a></li>
                                </ul>
                            </li>
                            <li><a href="#" class="item"><span class="ico16 arrow_2_r"></span>基础设置</a></li>
                        </ul>
                    </td>
                    -->
                </tr>
            </tbody>
        </table>
<div>
</body>
</html>