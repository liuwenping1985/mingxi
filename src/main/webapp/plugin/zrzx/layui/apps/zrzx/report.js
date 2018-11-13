;
(function () {
    lx.use(["jquery", "carousel", "element", "row","col","sTab"], function () {
       
        var Row = lx.row;
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1119"
        });

        var Col = lx.col;
        var col1 = Col.create({
            size: 8,
            style:"height:500px"
        });
        var col2 = Col.create({
            size: 4
        });
      
        row7.append(col1);
        row7.append(col2);
       

        var Tab = lx["sTab"];
        var sTab1 = Tab.create({
            "title": "功能导航9111111"
        });
        var sTab2 = Tab.create({
            "title": "222"
        });
      
        col1.append(sTab1);
        col2.append(sTab2);
      
        sTab1.append("<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.241.10.23:6868/demo/reportJsp/matchReport.jsp?rpx=%2F%E4%B8%AD%E6%97%A5%2F%E6%8A%A5%E8%A1%A8%E4%B8%AD%E5%BF%83-%E4%BA%BA%E4%BA%8B-%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab2.append("<p>1111ssss111</p>");
        


    });
}());