<%--
 $Author: wuym $
 $Rev: 261 $
 $Date:: 2012-07-20 23:59:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>layout</title>
<script>
  $(document).ready(
      function() {
        new MxtLayout({
          'id' : 'layout',
          'northArea' : {
            'id' : 'north',
            'height' : 57,
            'sprit' : false
          },
          'westArea' : {
            'id' : 'west',
            'width' : 200,
            'sprit' : true
          },
          'centerArea' : {
            'id' : 'center',
            'border' : false
          },
          'successFn' : function() {
            $("table.flexme3").ajaxgrid({
              datas : testData,
              colModel : [ {
                display : 'id',
                name : 'idString',
                width : '40',
                sortable : false,
                align : 'center',
                type : 'checkbox'
              }, {
                display : 'username',
                name : 'username',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : 'truename',
                name : 'truename',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : 'handphone',
                name : 'handphone',
                width : '100',
                sortable : true,
                align : 'center'
              }, {
                display : 'officephone',
                name : 'officephone',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : 'email',
                name : 'email',
                width : '100',
                sortable : true,
                align : 'left'
              }, {
                display : 'birthday',
                name : 'birthday',
                width : '100',
                sortable : true,
                align : 'center'
              }, {
                display : 'jiaqi',
                name : 'jiaqi',
                width : '100',
                sortable : true,
                align : 'left'
              } ],
              searchitems : [ {
                display : 'username',
                name : 'username'
              }, {
                display : 'truename',
                name : 'truename',
                isdefault : true
              } ],
              usepager : true,
              useRp : true,
              rp : 15,
              showTableToggleBtn : true,
              resizable : true,
              height : 200,
              vChange : {
                'parentId' : 'center',
                'changeTar' : 'form_area',
                'subHeight' : 90
              }
            });
          }
        });

        var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

        var transmit = new WebFXMenu;
        transmit.add(new WebFXMenuItem("", "协同", "forwardItem()"));
        transmit.add(new WebFXMenuItem("", "邮件", "forwardMail()"));

        myBar.add(new WebFXMenuButton("transmit", "转发", null, [ 1, 7 ], "",
            transmit));
        myBar.add(new WebFXMenuButton("delete", "删除",
            "javascript:deleteItems('pending')", [ 1, 3 ], "", null));
        myBar.add(new WebFXMenuButton("refresh", "刷新",
            "javascript:refreshIt()", [ 1, 10 ], "", null));
        $("#toolbar").append(myBar+"");
      });
</script>
</head>
<body id='layout'>
    <div class="layout_north" id="north">
        <div class="common_tabs clearfix">
            <ul class="left">
                <li class="current"><a href="javascript:void(0)">正文</a></li>
                <li><a href="javascript:void(0)" class='no_b_border'>流程</a></li>
                <li><a href="javascript:void(0)" class='no_b_border'>编辑</a></li>
                <li><a href="javascript:void(0)" class="last_tab no_b_border">表单</a></li>
            </ul>
        </div>
        <div id="toolbar"></div>
    </div>
    <div class="layout_west" id="west"></div>
    <div class="layout_center" id="center">
        <table class="flexme3" style="display: none"></table>
        <div class="form_area" id='form_area'>
            <div class="one_row">
                <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <th><label class="margin_r_10" for="text">标题:</label></th>
                        <td><div class="common_txtbox_wrap">
                                <input type="text" id="text" />
                            </div></td>
                    </tr>
                    <tr>
                        <th><label class="margin_r_10" for="text">人员编号:</label></th>
                        <td><div class="common_txtbox_wrap">
                                <input type="text" id="text" />
                            </div></td>
                    </tr>
                    <tr>
                        <th><label class="margin_r_10" for="text">备注:</label></th>
                        <td><div class="common_txtbox  clearfix">
                                <textarea cols="30" rows="7" class="w100b "></textarea>
                            </div></td>
                    </tr>
                </table>
            </div>
            <div class="align_center">
                <a href="javascript:void(0)" class="common_button common_button_gray">确定</a> <a
                    href="javascript:void(0)" class="common_button common_button_gray">取消</a>
            </div>
        </div>
    </div>
</body>
</html>
<script>
  var testData = {
    "size" : 20,
    "total" : 349,
    "rows" : [ {
      "id" : 10001,
      "username" : "zhujl",
      "truename" : "朱家玲",
      "handphone" : "13808000661",
      "officephone" : "028-85243926",
      "email" : "",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10001\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10002,
      "username" : "yuq",
      "truename" : "余强",
      "handphone" : "13901206080",
      "officephone" : "",
      "email" : "yuqiang@seeyon.com",
      "birthday" : "1965-03-21",
      "idString" : "<input type=\"checkbox\" vlaue=\"10002\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10003,
      "username" : "lq",
      "truename" : "刘清",
      "handphone" : "13910976992",
      "officephone" : "108",
      "email" : "liuq@seeyon.com",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10003\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10004,
      "username" : "xus",
      "truename" : "徐石",
      "handphone" : "13911116021",
      "officephone" : "101",
      "email" : "Rock_xu@seeyon.com",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10004\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10005,
      "username" : "张宇红",
      "truename" : "张宇红",
      "handphone" : "13301009835",
      "officephone" : "010-82602233-130",
      "email" : "zhangyh@seeyon.com",
      "birthday" : "1976-12-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10005\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10006,
      "username" : "zhangy",
      "truename" : "张屹",
      "handphone" : "13701136073",
      "officephone" : "102",
      "email" : "zhangy@seeyon.com",
      "birthday" : "1968-06-25",
      "idString" : "<input type=\"checkbox\" vlaue=\"10006\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10007,
      "username" : "qiuwj",
      "truename" : "邱文娟",
      "handphone" : "13426220457",
      "officephone" : "125",
      "email" : "",
      "birthday" : "1970-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10007\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10008,
      "username" : "lind",
      "truename" : "林丹",
      "handphone" : "13908001627",
      "officephone" : "010-82602233-165",
      "email" : "lind@seeyon.com",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10008\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10009,
      "username" : "hul",
      "truename" : "胡丽",
      "handphone" : "13146164157",
      "officephone" : "800801",
      "email" : "hul@seeyon.com",
      "birthday" : "1983-10-18",
      "idString" : "<input type=\"checkbox\" vlaue=\"10009\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10010,
      "username" : "husy",
      "truename" : "胡守云",
      "handphone" : "13908057455",
      "officephone" : "010-82602233-103",
      "email" : "husy@seeyon.com",
      "birthday" : "1967-11-13",
      "idString" : "<input type=\"checkbox\" vlaue=\"10010\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10011,
      "username" : "huac",
      "truename" : "华程",
      "handphone" : "13910338526",
      "officephone" : "146",
      "email" : "",
      "birthday" : "1970-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10011\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10012,
      "username" : "taowh",
      "truename" : "陶维浩",
      "handphone" : "13308172151",
      "officephone" : "028-85240311",
      "email" : "",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10012\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10013,
      "username" : "luojc",
      "truename" : "罗继承",
      "handphone" : "13701124108",
      "officephone" : "62715542",
      "email" : "luojc@seeyon.com",
      "birthday" : "1975-07-07",
      "idString" : "<input type=\"checkbox\" vlaue=\"10013\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10014,
      "username" : "caozm",
      "truename" : "曹中敏",
      "handphone" : "",
      "officephone" : "",
      "email" : "",
      "birthday" : "1970-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10014\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10015,
      "username" : "liurh",
      "truename" : "刘瑞华",
      "handphone" : "13910519458",
      "officephone" : "107",
      "email" : "",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10015\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10016,
      "username" : "xuey",
      "truename" : "薛瑶",
      "handphone" : "13910928111",
      "officephone" : "106",
      "email" : "xuey@seeyon.com",
      "birthday" : "1981-11-11",
      "idString" : "<input type=\"checkbox\" vlaue=\"10016\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10017,
      "username" : "lijh",
      "truename" : "李继红",
      "handphone" : "13709044732",
      "officephone" : "44455555",
      "email" : "lijh@seeyon.com",
      "birthday" : "1910-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10017\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10018,
      "username" : "xiaoxs",
      "truename" : "肖雪松",
      "handphone" : "13981811797",
      "officephone" : "028-85248800",
      "email" : "wuming999@163.com",
      "birthday" : "1975-08-04",
      "idString" : "<input type=\"checkbox\" vlaue=\"10018\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10019,
      "username" : "wangy",
      "truename" : "王宇",
      "handphone" : "",
      "officephone" : "",
      "email" : "",
      "birthday" : "1970-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10019\"/>",
      "jiaqi" : 2
    }, {
      "id" : 10020,
      "username" : "yuhj",
      "truename" : "于荒津",
      "handphone" : "13910621929",
      "officephone" : "141",
      "email" : "",
      "birthday" : "1970-01-01",
      "idString" : "<input type=\"checkbox\" vlaue=\"10020\"/>",
      "jiaqi" : 2
    } ],
    "page" : 1,
    "pages" : 18,
    "startAt" : 0,
    "dataCount" : 20,
    "sortField" : null,
    "sortOrder" : null
  };
</script>