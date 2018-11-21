;
(function () {
    lx.use(["jquery", "carousel", "element", "row","col","sTab","mTab"], function () {

        var Row = lx.row;
        var MTab = lx.mTab;
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1119"

        });
        var row8 = Row.create({
            parent_id: "root_body",
            "id": "row1129"
        });
        var row9 = Row.create({
            parent_id: "root_body",
            "id": "row1139"
        });
        var row10 = Row.create({
            parent_id: "root_body",
            "id": "row1149"
        });
        var row11 = Row.create({
            parent_id: "root_body",
            "id": "row1159"
        });
        var row12 = Row.create({
            parent_id: "root_body",
            "id": "row1169"
        });
        var row13 = Row.create({
            parent_id: "root_body",
            "id": "row1179"
        });
        var row14 = Row.create({
            parent_id: "root_body",
            "id": "row1189"
        });

        var Col = lx.col;
        var col1 = Col.create({
            size: 12,
            style:"height:520px"
        });
        var col2 = Col.create({
            size: 12,
            style:"height:520px"
        });
        var col3 = Col.create({
            size: 12,
            style:"height:520px"
        });
        var col4 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col5 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col6 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col7 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col8 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col9 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col10 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col11 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col12 = Col.create({
            size: 6,
            style:"height:520px"
        });
        var col13 = Col.create({
            size: 6,
            style:"height:520px"
        });

        row7.append(col1);
        row8.append(col2);
        row9.append(col3);

        row10.append(col4);
        row10.append(col5);
        row11.append(col6);
        row11.append(col7);
        row12.append(col8);
        row12.append(col9);
        row13.append(col10);
        row13.append(col11);
        row14.append(col12);
        row14.append(col13);

        var Tab = lx["sTab"];

        var sTab1 = Tab.create({
            "title": "人事报表",
            "style":"height:500px"

        });
        var mTab1 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"人事1",
                checked:true,
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"人事2",
                checked:false,
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }]
        });

        sTab1.append(mTab1);
        var sTab2 = Tab.create({
            "title": "财务报表",
            "style":"height:500px"
        });
        var sTab3 = Tab.create({
            "title": "任务报表",
            "style":"height:500px"
        });
        var sTab4 = Tab.create({
            "title": "会议报表",
            "style":"height:500px"
        });
        var sTab5 = Tab.create({
            "title": "巡查督查报表",
            "style":"height:500px"
        });
        var sTab6 = Tab.create({
            "title": "政务报表",
            "style":"height:500px"
        });
        var sTab7 = Tab.create({
            "title": "信息专报报表",
            "style":"height:500px"
        });
        var sTab8 = Tab.create({
            "title": "公文报表",
            "style":"height:500px"
        });
        var sTab9 = Tab.create({
            "title": "用章报表",
            "style":"height:500px"
        });
        var sTab10 = Tab.create({
            "title": "资产报表",
            "style":"height:500px"
        });
        var sTab11 = Tab.create({
            "title": "合同报表",
            "style":"height:500px"
        });
        var sTab12 = Tab.create({
            "title": "党建报表",
            "style":"height:500px"
        });
        var sTab13 = Tab.create({
            "title": "OA运行服报表",
            "style":"height:500px"

        });



        col1.append(sTab1);

        col2.append(sTab2);
        col3.append(sTab3);

        col4.append(sTab4);
        col5.append(sTab5);
        col6.append(sTab6);
        col7.append(sTab7);
        col8.append(sTab8);
        col9.append(sTab9);
        col10.append(sTab10);
        col11.append(sTab11);
        col12.append(sTab12);
        col13.append(sTab13);

        //sTab1.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab2.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B4%A2%E5%8A%A1/%E4%B8%AD%E5%BF%83%E6%89%A7%E8%A1%8C%E7%8E%87.rpx'></iframe>");
        sTab3.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8/%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8.rpx'></iframe>");
        sTab4.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BC%9A%E8%AE%AE/%E4%BC%9A%E8%AE%AE%E6%AC%A1%E6%95%B0%E5%A0%86%E7%A7%AF%E5%9B%BE.rpx'></iframe>");
        sTab5.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E7%B1%BB%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab6.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E6%94%BF%E5%8A%A1/%E6%94%BF%E5%8A%A1%E6%8A%A5%E9%80%81%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab7.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E6%8C%89%E4%BE%9B%E7%A8%BF%E5%8D%95%E4%BD%8D%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab8.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E5%8A%9E%E7%90%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab9.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E7%94%A8%E7%AB%A0/%E5%90%84%E5%A4%84%E5%AE%A4%E7%94%A8%E7%AB%A0%E6%83%85%E5%86%B5.rpx'></iframe>");
        sTab10.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B5%84%E4%BA%A7/%E7%B1%BB%E5%9E%8B%E6%95%B0%E9%87%8F%E5%88%86%E5%B8%83.rpx'></iframe>");
        sTab11.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%90%88%E5%90%8C/%E5%A4%96%E5%8D%8F%E5%90%88%E5%90%8C%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab12.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-%E5%85%9A%E5%BB%BA-%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>");
        sTab13.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8OA%E8%BF%90%E8%90%A5/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-OA%E8%BF%90%E8%90%A5-%E7%99%BB%E5%BD%95%E4%BA%BA%E6%95%B0%E7%BB%9F%E8%AE%A1.rpx'></iframe>");



    });
}());