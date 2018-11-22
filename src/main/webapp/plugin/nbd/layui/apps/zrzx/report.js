;
(function () {

    lx.use(["jquery", "carousel", "element", "row","col","sTab","mTab","mixed"], function () {


        var Row = lx.row;
        var Col = lx.col;
        var MTab = lx.mTab;
        var Mixed = lx.mixed;
        var mixRoot = Mixed.create({
            id:"mixed1",
            mode:"row",
            size:12
        });

        var mix1 = Mixed.create({
            id:"mixed2",
            mode:"col",
            size:12
        });
        mix1.append("<p style='color:black'>mixed1</p>");
        var mix2 = Mixed.create({
            id:"mixed3",
            mode:"col",
            size:12
        });
        mix2.append("<p style='color:black'>mixed2</p>");
        mixRoot.addCmp({
            size:6,
            style:"height:45px",
            content:mix1
        });
        mixRoot.addCmp({
            size:12,
            style:"height:45px",
            content:mix2
        })


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


        var col1 = Col.create({
            size: 12,
            style:"height:520px;margin:30px 0px 30px 0px"
        });
        var col2 = Col.create({
            size: 12,
            style:"height:520px;margin:30px 0px 30px 0px"
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

        row7.append(mixRoot);
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
            "title": "<span style='font-size:40px'>人事报表&nbsp&nbsp</span><span style='color:gray'>HR Report</span>",
            "style":"height:600px;"

        });
        /*    var mixed1=Mixed.create({
         id:"mixed1",
         mode:"col",
         cmps:[{
         contentType:"html",
         content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E5%9C%A8%E7%BC%96%E4%BA%BA%E5%91%98%E5%AD%A6%E5%8E%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>",
         style:"height:240px;position:right",
         size:6
         }]

         });
         sTab1.append(mixed1);*/

        var mTab1 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>部门统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1%E4%B8%8B%E9%92%BB%E5%9B%BE.rpx'></iframe>"
            },{
                name:"<span style='color:black'>性别统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>学历统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E5%AD%A6%E5%8E%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>年龄段统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E5%B9%B4%E9%BE%84%E6%AE%B5%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>政治面貌统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E6%94%BF%E6%B2%BB%E9%9D%A2%E8%B2%8C%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>编制统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:500px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E4%BA%BA%E5%91%98%E7%BB%93%E6%9E%84%E5%88%86%E5%B8%83.rpx'></iframe>"
            }
            ]
        });

        sTab1.append(mTab1);
        var sTab2 = Tab.create({
            "title": "<span style='font-size:40px'>财务报表&nbsp&nbsp</span><span style='color:gray'>Financial Report</span>",
            "style":"height:500px"
        });
        sTab2.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B4%A2%E5%8A%A1/%E4%B8%AD%E5%BF%83%E6%89%A7%E8%A1%8C%E7%8E%87.rpx'></iframe>");
        var sTab3 = Tab.create({
            "title": "<span style='font-size:40px'>任务报表&nbsp&nbsp</span><span style='color:gray'>Task Report</span>",
            "style":"height:500px"
        });
        sTab3.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8/%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8.rpx'></iframe>");

        var sTab4 = Tab.create({
            "title": "<span style='font-size:40px'>会议报表&nbsp&nbsp</span><span style='color:gray'>Conference Report</span>",
            "style":"height:500px;margin:30px 30px 30px 0px"
        });
        sTab4.append("<iframe  style='height:600px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BC%9A%E8%AE%AE/%E4%BC%9A%E8%AE%AE%E6%AC%A1%E6%95%B0%E5%A0%86%E7%A7%AF%E5%9B%BE.rpx'></iframe>");


        var sTab5 = Tab.create({
            "title": "<span style='font-size:40px'>巡查督察报表&nbsp&nbsp</span><span style='color:gray'>Supervision Report</span>",
            "style":"height:500px;margin:30px 0px 30px 30px"
        });
        var mTab5 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>类别统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E7%B1%BB%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>职位报送统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E7%BA%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>部门统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab5.append(mTab5);
        var sTab6 = Tab.create({
            "title": "<span style='font-size:40px'>政务报表&nbsp&nbsp</span><span style='color:gray'>Government Report</span>",
            "style":"height:500px;margin:30px 30px 30px 0px"
        });
        var mTab6 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>政务报送统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E6%94%BF%E5%8A%A1/%E6%94%BF%E5%8A%A1%E6%8A%A5%E9%80%81%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab6.append(mTab6);
        var sTab7 = Tab.create({
            "title": "<span style='font-size:40px'>信息专报报表&nbsp&nbsp</span><span style='color:gray'>Information Report</span>",
            "style":"height:500px;margin:30px 0px 30px 30px"
        });
        var mTab7 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>按供稿单位统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E6%8C%89%E4%BE%9B%E7%A8%BF%E5%8D%95%E4%BD%8D%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>按年份统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E6%8C%89%E5%B9%B4%E4%BB%BD%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>按批示统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E6%8C%89%E6%89%B9%E7%A4%BA%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab7.append(mTab7);
        var sTab8 = Tab.create({
            "title": "<span style='font-size:40px'>公文报表&nbsp&nbsp</span><span style='color:gray'>Official Document Report</span>",
            "style":"height:500px;margin:30px 30px 30px 0px"
        });

        var mTab8 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>公文时效统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E5%A4%84%E7%90%86%E6%97%B6%E6%95%88.rpx'></iframe>"
            },{
                name:"<span style='color:black'>收文办理统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E5%8A%9E%E7%90%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>公文批阅统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E6%89%B9%E9%98%85%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });

        sTab8.append(mTab8);

        var sTab9 = Tab.create({
            "title": "<span style='font-size:40px'>用章报表&nbsp&nbsp</span><span style='color:gray'>The Seal Report</span>",
            "style":"height:500px;margin:30px 0px 30px 30px"
        });
        var mTab9 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>各处室用章情况</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E7%94%A8%E7%AB%A0/%E5%90%84%E5%A4%84%E5%AE%A4%E7%94%A8%E7%AB%A0%E6%83%85%E5%86%B5.rpx'></iframe>"
            },{
                name:"<span style='color:black'>每月用章情况</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E7%94%A8%E7%AB%A0/%E6%AF%8F%E6%9C%88%E7%94%A8%E7%AB%A0%E6%83%85%E5%86%B5.rpx'></iframe>"
            },{
                name:"<span style='color:black'>用章次数情况</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E7%94%A8%E7%AB%A0/%E7%94%A8%E7%AB%A0%E6%AC%A1%E6%95%B0%E6%83%85%E5%86%B5.rpx'></iframe>"
            }
            ]
        });
        sTab9.append(mTab9);
        var sTab10 = Tab.create({
            "title": "<span style='font-size:40px'>资产报表&nbsp&nbsp</span><span style='color:gray'>Resourve Report</span>",
            "style":"height:500px;margin:30px 30px 30px 0px"
        });
        var mTab10 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>部门数量分布</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B5%84%E4%BA%A7/%E9%83%A8%E9%97%A8%E6%95%B0%E9%87%8F%E5%88%86%E5%B8%83.rpx'></iframe>"
            },{
                name:"<span style='color:black'>部门金额统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B5%84%E4%BA%A7/%E9%83%A8%E9%97%A8%E9%87%91%E9%A2%9D%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>类型数量分布</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B5%84%E4%BA%A7'></iframe>"
            },{
                name:"<span style='color:black'>类型金额统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E8%B5%84%E4%BA%A7/%E7%B1%BB%E5%9E%8B%E9%87%91%E9%A2%9D%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab10.append(mTab10);

        var sTab11 = Tab.create({
            "title": "<span style='font-size:40px'>合同报表&nbsp&nbsp</span><span style='color:gray'>Contract Report</span>",
            "style":"height:500px;margin:30px 0px 30px 30px"
        });
        var mTab11 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>外协合同部门统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%90%88%E5%90%8C/%E5%A4%96%E5%8D%8F%E5%90%88%E5%90%8C%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab11.append(mTab11);
        var sTab12 = Tab.create({
            "title": "<span style='font-size:40px'>党建报表&nbsp&nbsp</span><span style='color:gray'>The party building  Report</span>",
            "style":"height:500px;margin:30px 30px 30px 0px"
        });
        var mTab12 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>性别统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-%E5%85%9A%E5%BB%BA-%E6%80%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>年龄统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-%E5%85%9A%E5%BB%BA-%E5%B9%B4%E9%BE%84%E6%AE%B5%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>支部统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-%E5%85%9A%E5%BB%BA-%E6%89%80%E5%B1%9E%E6%94%AF%E9%83%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>职称统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E8%81%8C%E7%A7%B0%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black'>年龄统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%9A%E5%BB%BA/%E5%AD%A6%E5%8E%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab12.append(mTab12);

        var sTab13 = Tab.create({
            "title": "<span style='font-size:40px'>OA运行服报表&nbsp&nbsp</span><span style='color:gray'>Operation Report</span>",
            "style":"height:500px;margin:30px 0px 30px 30px"

        });
        var mTab13 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'>登陆人数统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8OA%E8%BF%90%E8%90%A5/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-OA%E8%BF%90%E8%90%A5-%E7%99%BB%E5%BD%95%E4%BA%BA%E6%95%B0%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab13.append(mTab13);



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
        //sTab13.append("<iframe  style='height:400px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8OA%E8%BF%90%E8%90%A5/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-OA%E8%BF%90%E8%90%A5-%E7%99%BB%E5%BD%95%E4%BA%BA%E6%95%B0%E7%BB%9F%E8%AE%A1.rpx'></iframe>");




    });
}());