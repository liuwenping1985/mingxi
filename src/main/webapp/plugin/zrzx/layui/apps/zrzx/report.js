;
(function () {
    lx.use(["jquery", "carousel", "element", "row","col","sTab"], function () {
       
        var Row = lx.row;
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1119"
        });
        var row8 = Row.create({
            parent_id: "root_body",
            "id": "row1129"
        });

        var Col = lx.col;
        var col1 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col2 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col3 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col4 = Col.create({
            size: 6,
            style:"height:520px"
        });
      
        row7.append(col1);
        row7.append(col2);

        row8.append(col3);
        row8.append(col4);

        var Tab = lx["sTab"];
        var sTab1 = Tab.create({
            "title": "报表一",
            "style":"height:500px"

        });
        var sTab2 = Tab.create({
            "title": "报表二",
            "style":"height:500px"
        });
        var sTab3 = Tab.create({
            "title": "报表三",
            "style":"height:500px"
        });
        var sTab4 = Tab.create({
            "title": "报表四",
            "style":"height:500px"
        });
      
        col1.append(sTab1);

        col2.append(sTab2);
        col3.append(sTab3);

        col4.append(sTab4);
      
        sTab1.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.241.10.23:6868/demo/reportJsp/showReport1.jsp?rpx=/%E4%B8%AD%E6%97%A5/%E6%8A%A5%E8%A1%A8%E4%B8%AD%E5%BF%83-%E4%BA%BA%E4%BA%8B-%E6%94%BF%E6%B2%BB%E9%9D%A2%E8%B2%8C%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab2.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.241.10.23:6868/demo/reportJsp/showReport1.jsp?rpx=/%E4%B8%AD%E6%97%A5/%E6%8A%A5%E8%A1%A8%E4%B8%AD%E5%BF%83-%E4%BA%BA%E4%BA%8B-%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab3.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.241.10.23:6868/demo/reportJsp/showReport1.jsp?rpx=/%E4%B8%AD%E6%97%A5/%E6%8A%A5%E8%A1%A8%E4%B8%AD%E5%BF%83-%E4%BA%BA%E4%BA%8B-%E5%B9%B4%E9%BE%84%E6%AE%B5%E7%BB%9F%E8%AE%A1%E5%A0%86%E7%A7%AF%E5%9B%BE%E6%B5%8B%E8%AF%95.rpx'></iframe>");
        sTab4.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.241.10.23:6868/demo/reportJsp/showReport1.jsp?rpx=/%E4%B8%AD%E6%97%A5/%E6%8A%A5%E8%A1%A8%E4%B8%AD%E5%BF%83-%E4%BA%BA%E4%BA%8B-%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>");

        


    });
}());