<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/main/common/frame_header.jsp"%>
<html>
<head>
<title>首页</title>
<script type="text/javascript">
  $().ready(
      function() {
        var menus = $.ctx
            .handleMenu(function(m) {
              if (m.url)
                m.action = 'javascript: window.location="' + _ctxPath + m.url
                    + '"';
            });
        var menusStr = '';
        createNav(menus);
        function createNav(mns, p) {
          for ( var i = 0; i < mns.length; i++) {
            var m = mns[i];
            var ms = p ? p : '';
            ms += '-->' + m.name;
            if (m.items) {
              createNav(m.items, ms);
            } else if (m.url) {
              ms += '<a href="' + _ctxPath + m.url + '">进入</a>';
              menusStr += ms + '<br/>';
            }
          }
        }

        var shortcut = $.ctx.customize.shortcut;
        if (shortcut) {
          var shortcutArray = $.parseJSON(shortcut);
          for ( var i = 0; i < shortcutArray.length; i++) {
            $("#shortcut").append(
                "<a href=\""+_ctxPath+shortcutArray[i].url+"\">"
                    + shortcutArray[i].name + "</a>----");
          }
        }

        var space = $.ctx.space;
        for ( var i = 0; i < space.length; i++) {
          $("#space").append(
              "<a href=\""+_ctxPath+space[i][0]+"\">" + space[i][1]
                  + "</a>----");
        }

        var template = $.ctx.template;
        for ( var i = 0; i < template.length; i++) {
          $("#template").append(
              "<a href=\"main.do?method=changeTemplate&id=" + template[i].id
                  + "\">" + template[i].name + "</a>----");
        }

        $("#menuDiv").html(menusStr);
      });
</script>
</head>
<body>
    <div id="menuDiv"></div>
    <br/>
    <div id="shortcut"></div>
    <div id="space"></div>
    <div id="template"></div>
</body>
</html>