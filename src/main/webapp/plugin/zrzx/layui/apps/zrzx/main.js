;
(function () {
    lx.use(["jquery", "carousel", "element", "portal","mTab"], function () {

        var Row = lx.row;
        var mTab = lx.mTab;
        var row7 = Row.create({
            parent_id: "root_body",
            "id": "row1119"
        });
        var row8 = Row.create({
            parent_id: "root_body",
            "id": "row1234"
        });

        var Col = lx.col;
        var col1 = Col.create({
            size: 4
        });
        var col2 = Col.create({
            size: 4
        });
        var col3 = Col.create({
            size: 4
        });
        var col4 = Col.create({
            size: 12
        });
        row7.append(col1);
        row7.append(col2);
        row7.append(col3);
        row8.append(col4);

        var Tab = lx["sTab"];
        var sTab1 = Tab.create({
            "title": "功能导航9111111"
        });
        var sTab2 = Tab.create({
            "title": "222"
        });
        var sTab3 = Tab.create({
            "title": "2244442"
        });
        col1.append(sTab1);
        col2.append(sTab2);
        col3.append(sTab3);
        sTab1.append("<p>1111111</p>");
        sTab2.append("<p>1111ssss111</p>");
        sTab3.append("<p style='color:black'>11sss11111</p>");
        // var Portal = lx.portal;
        // Portal.create({
        //     header: {


        //     },
        //     body: {



        //     }
        // });
       var maTab =  mTab.create({
           "id":"mTabDemo",
           tabs:[{
               name:"wahaha",
               content:"<pre>yes</pre>"
           }]
       });
        col4.append(maTab);
        maTab.addTab({
            name:"tab1",
            checked:true,
            style:"",
            content:"<p>wahaha</p>"
        })
        maTab.addTab({
            name:"tab2",
            style:"",
            content:"<p style='color:black'>wahaha2</p>"
        })


    });
}());