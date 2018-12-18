;
(function () {

    lx.use(["jquery", "carousel", "element", "row","col","sTab","mTab","mixed"], function () {


        var Row = lx.row;
        var Col = lx.col;
        var MTab = lx.mTab;
        var Mixed = lx.mixed;
        var mixRoot = Mixed.create({
            id:"mixed1",
            mode:"col",
            size:12
        });
        var mix1 = Mixed.create({
            id:"mixed2",
            mode:"col",
            size:12
        });
        var mix2 = Mixed.create({
            id:"mixed3",
            mode:"col",
            size:12
        });
         mixRoot.addCmp({
            size:6,
            contentType:"cmp",
            content:mix1
        });
        mixRoot.addCmp({
            size:6,
            contentType:"cmp",
            content:mix2
        });
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1119",

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
            style:"height:560px"
        });
        var col2 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col3 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col4 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col5 = Col.create({
            size: 6,
            style:"height:760px"
        });
        var col6 = Col.create({
            size: 6,
            style:"height:560px;"
        });
        var col7 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col8 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col9 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col10 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col11 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col12 = Col.create({
            size: 6,
            style:"height:560px"
        });
        var col13 = Col.create({
            size: 6,
            style:"height:560px"
        });




        var Tab = lx["sTab"];

        var sTab1 = Tab.create({
            "title": "<span style='font-size:30px'>人事报表&nbsp&nbsp</span><span style='color:gray'>HR Report</span>",
            "style":"height:540px;background-color:white"

        });
        var mTabguding = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>人员结构统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/ryjgfb.rpx'></iframe>"
            }]
        });
        var mTab1 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>部门统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/bmtjxzt.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>性别统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/xbtj.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>学历统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px;font-size:12px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/xltj.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>年龄统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/nldtj.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>政治面貌统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/zzmmtj.rpx'></iframe>"
            }, {
                name:"<span style='color:black;font-size:12px'>职称统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwrenshi/zctj.rpx'></iframe>"
            },
            ]
        });
        mix1.append(mTab1);
        mix2.append(mTabguding);

       // mix2.append("<p style='color:black'><iframe  style='height:620px;margin-bottom: 0px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:6868/demo/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BA%BA%E4%BA%8B%E6%8A%A5%E8%A1%A8/%E5%9C%A8%E7%BC%96%E4%BA%BA%E5%91%98%E5%AD%A6%E5%8E%86%E7%BB%9F%E8%AE%A1.rpx'></iframe></p>");
        /*mTabguding.head.append("<li style='float:right;height:30px;width: 50px'><select>" +
            "  <option value='2018'>2018</option>" +
            "  <option value='2017'>2017</option>" +
            "  <option value='2016'>2016</option>" +
            "  <option value='2015'>2015</option>" +
            "</select><span class='layui-icon' style='color: black'>&nbsp;&#xe669;</span></li><li style='float:right;color:black '>选择部门：</li>");*/
        sTab1.append(mixRoot);

        var sTab2 = Tab.create({
            "title": "<span style='font-size:30px'>党员统计&nbsp&nbsp</span><span style='color:gray'>Communist Party members</span>",
            "style":"height:540px;margin:15px 10px 15px 0px;background-color:white"
        });
        var mTab2 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[
                {
                    name:"<span style='color:black;font-size:12px'>支部统计</span>",
                    checked:true,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' height='420' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/sszbtj.rpx'></iframe>"
                }, {
                    name:"<span style='color:black;font-size:12px'>性别统计</span>",
                    checked:false,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/xbtj.rpx'></iframe>"
                },{
                    name:"<span style='color:black;font-size:12px'>年龄统计</span>",
                    checked:false,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/nldtj.rpx'></iframe>"
                },{
                    name:"<span style='color:black;font-size:12px'>职称统计</span>",
                    checked:false,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/zctj.rpx'></iframe>"
                },{
                    name:"<span style='color:black;font-size:12px'>学历统计</span>",
                    checked:false,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/xltj.rpx'></iframe>"
                },{
                    name:"<span style='color:black;font-size:12px'>入党时间</span>",
                    checked:false,
                    contentType:"html",
                    content:"<iframe  style='height:420px;overflow-x: hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwdangjian/rdsjtj.rpx'></iframe>"
                }
            ]
        });
        sTab2.append(mTab2);
        var sTab3 = Tab.create({
            "title": "<span  style='font-size:30px'>巡查督查&nbsp&nbsp</span><span style='color:gray'>Partrol inspection</span>",
            "style":"height:540px;margin:15px 0px 15px 10px;background-color:white"
        });
        var mTab3 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>累计派出</span>",
                checked:true,
                root_style:"",
                contentType:"html",
                content:"<iframe  style='height:420px;overflow:hidden' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E7%B1%BB%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>人员职级</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px;font-size:12px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E7%BA%A7%E5%88%AB%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>部门统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%B7%A1%E6%9F%A5%E7%9D%A3%E6%9F%A5/%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab3.append(mTab3);

        var sTab4 = Tab.create({
            "title": "<span style='font-size:30px'>年度工作&nbsp&nbsp</span><span style='color:gray'>Task Report</span>",
            "style":"height:740px;margin:15px 10px 15px 0px;background-color:white"
        });
        var mTab4 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'></span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:620px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8/%E4%BB%BB%E5%8A%A1%E6%8A%A5%E8%A1%A8.rpx'></iframe>"
            }]
        });
        sTab4.append(mTab4);
        var sTab5 = Tab.create({
            "title": "<span style='font-size:30px'>财务报表&nbsp&nbsp</span><span style='color:gray'>Financial Report</span>",
            "style":"height:740px;margin:15px 0px 15px 10px;background-color:white"
        });
        var mTab5 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black'></span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:620px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwcaiwu/%E4%B8%AD%E5%BF%83%E6%89%A7%E8%A1%8C%E7%8E%87.rpx'></iframe>"
            }]
        });
        sTab5.append(mTab5);
        var sTab6 = Tab.create({
            "title": "<span style='font-size:30px'>工作动态&nbsp&nbsp</span><span style='color:gray'>Government Report</span>",
            "style":"height:540px;margin:15px 10px 15px 0px;background-color:white"
        });
        var mTab6 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[
                {
                    name:"<span style='color:black;font-size:12px'>全年累计</span>",
                    checked:true,
                    contentType:"html",
                    content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E6%94%BF%E5%8A%A1/%E6%94%BF%E5%8A%A1%E6%8A%A5%E9%80%81%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
                },{
                name:"<span style='color:black;font-size:12px'>部门统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E6%94%BF%E5%8A%A1/%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
            name:"<span style='color:black;font-size:12px'>年度统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E6%94%BF%E5%8A%A1/%E5%B9%B4%E5%BA%A6%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
        }
            ]
        });
        sTab6.append(mTab6);
        var sTab7 = Tab.create({
            "title": "<span style='font-size:30px'>信息专报&nbsp&nbsp</span><span style='color:gray'>Information Report</span>",
            "style":"height:540px;margin:15px 0px 15px 10px;background-color:white"
        });
        var mTab7 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>批示率</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E6%8C%89%E6%89%B9%E7%A4%BA%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>刊发采用</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E5%88%8A%E5%8F%91%E9%87%87%E7%94%A8.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>计划完成</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E8%AE%A1%E5%88%92%E5%AE%8C%E6%88%90.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>年度统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E4%BF%A1%E6%81%AF%E4%B8%93%E6%8A%A5/%E5%B9%B4%E5%BA%A6%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }]
        });
        sTab7.append(mTab7);
        var sTab8 = Tab.create({
            "title": "<span style='font-size:30px'>公文报表&nbsp&nbsp</span><span style='color:gray'>Official Document Report</span>",
            "style":"height:540px;margin:15px 10px 15px 0px;background-color:white"
        });

        var mTab8 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>时效统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E5%A4%84%E7%90%86%E6%97%B6%E6%95%88.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>全年累计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E5%8A%9E%E7%90%86%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>批阅统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%85%AC%E6%96%87/%E5%85%AC%E6%96%87%E6%89%B9%E9%98%85%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab8.append(mTab8);
        var sTab9 = Tab.create({
            "title": "<span style='font-size:30px'>用章报表&nbsp&nbsp</span><span style='color:gray'>The Seal Report</span>",
            "style":"height:540px;margin:15px 0px 15px 10px;background-color:white"
        });
        var mTab9 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>部门统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwyongzhang/bmtj.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>全年累计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwyongzhang/qnlj.rpx'></iframe>"
            }
            ]
        });
        sTab9.append(mTab9);
        var sTab10 = Tab.create({
            "title": "<span style='font-size:40px;font-size:30px'>资产报表&nbsp&nbsp</span><span style='color:gray'>Resourve Report</span>",
            "style":"height:540px;margin:15px 10px 15px 0px;background-color:white"
        });
        var mTab10 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>数量统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwzichan/bmslfb.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>金额统计</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwzichan/bmjetj.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>类型数量</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwzichan/lxslfb.rpx'></iframe>"
            },{
                name:"<span style='color:black;font-size:12px'>类型金额</span>",
                checked:false,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwzichan/lxjetj.rpx'></iframe>"}
            ]
        });
        sTab10.append(mTab10);
        var sTab11 = Tab.create({
            "title": "<span style='font-size:30px'>会议报表&nbsp&nbsp</span><span style='color:gray'>Conference Report</span>",
            "style":"height:540px;margin:15px 0px 15px 10px;background-color:white"
        });
        var mTab11 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>全年累计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/dwhuiyi/%E4%BC%9A%E8%AE%AE%E6%AC%A1%E6%95%B0%E5%A0%86%E7%A7%AF%E5%9B%BE.rpx&rpxHome=%2Fusr%2Fbi%2Freport%2Fweb%2Fwebapps%2Fdemo%2FWEB-INF%2FreportFiles&dfxHome=&arg=%2Fusr%2Fbi%2Freport%2Fweb%2Fwebapps%2Fdemo%2FWEB-INF%2FreportFiles%2Fdwhuiyi%2F%E4%BC%9A%E8%AE%AE%E6%AC%A1%E6%95%B0%E5%A0%86%E7%A7%AF%E5%9B%BE_arg.rpx'></iframe>"
            }]
        });

        sTab11.append(mTab11);
        var sTab12 = Tab.create({
            "title": "<div style='width: 100%'><span style='font-size:30px'>系统数据&nbsp&nbsp</span><span style='color:gray'>System Data</span> </div>",
            "style":"height:540px;margin:20px 10px 15px 0px;background-color:white"
        });
        var mTab12 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>使用情况</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8OA%E8%BF%90%E8%90%A5/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8-OA%E8%BF%90%E8%90%A5-%E7%99%BB%E5%BD%95%E4%BA%BA%E6%95%B0%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });


        sTab12.append(mTab12);
        var sTab13 = Tab.create({
            "title": "<span style='font-size:30px'>合同报表&nbsp&nbsp</span><span style='color:gray'>Message Board</span>",
            "style":"height:540px;margin:20px 0px 15px 10px;background-color:white"
        });
        var mTab13 = MTab.create({
            root_class:"layui-tab layui-tab-brief",
            tabs:[{
                name:"<span style='color:black;font-size:12px'>合同统计</span>",
                checked:true,
                contentType:"html",
                content:"<iframe  style='height:420px' class='layui-col-md12' frameborder=0 src='http://10.10.204.107:8080/v2018bi/reportJsp/showReport1.jsp?rpx=/%E5%8D%95%E4%BD%8D%E6%8A%A5%E8%A1%A8%E5%90%88%E5%90%8C/%E5%A4%96%E5%8D%8F%E5%90%88%E5%90%8C%E9%83%A8%E9%97%A8%E7%BB%9F%E8%AE%A1.rpx'></iframe>"
            }
            ]
        });
        sTab13.append(mTab13);






        row7.append(col1);
        row8.append(col2);
        row8.append(col3);
        row9.append(col4);
        row9.append(col5);
        row10.append(col6);
        row10.append(col7);
        row11.append(col8);
        row11.append(col9);
        row12.append(col10);
        row12.append(col11);
        row13.append(col13);
        row13.append(col12);
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







    });
}());