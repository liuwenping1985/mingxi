<%--
 $Author: wuym $
 $Rev: 250 $
 $Date:: 2012-07-18 15:09:19#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <title>AjaxPagingGrid测试</title>
        <link rel="stylesheet" type="text/css" href="${path }/common/css/common.css">
        <link rel="stylesheet" type="text/css" href="${path }/skin/default/skin.css">
        <script type="text/javascript" src="${path}/ajax.do?managerName=a6UserManager"></script>
        <script text="text/javascript" src="${path }/common/js/ui/seeyon.ui.grid-debug.js"></script>
        <script text="text/javascript">
            $(function(){
              $("table.flexme3").ajaxgrid({
                  searchHTML:'searchHTML',
                  colModel: [{
                          display: 'id',
                          name: 'idString',
                          width: '40',
                          sortable: false,
                          align: 'center',
                          type:'checkbox'
                      }, {
                          display: 'username',
                          name: 'username',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      }, {
                          display: 'truename',
                          name: 'truename',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      }, {
                          display: 'handphone',
                          name: 'handphone',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      }, {
                          display: 'officephone',
                          name: 'officephone',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      }, {
                          display: 'email',
                          name: 'email',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      }, {
                          display: 'birthday',
                          name: 'birthday',
                          width: '180',
                          sortable: true,
                          align: 'left'
                      },{
                          display: 'jiaqi',
                          name: 'jiaqi',
                          width: '180',
                          sortable: false,
                          align: 'left',
                          codecfg:'codeType:form,codeId:4171705351394184829'
                      }],
                  combobuttons: [{
                      name: 'Add',
                      bclass: 'add',
                      onpress: test
                  }, {
                      name: 'Delete',
                      bclass: 'delete',
                      onpress: test
                  }, {
                      separator: true
                  }], buttons: [{
                      name: 'Add',
                      bclass: 'add',
                      onpress: test
                  }, {
                      name: 'Delete',
                      bclass: 'delete',
                      onpress: test
                  }, {
                      separator: true
                  }],
                  searchitems: [{
                      display: 'username',
                      name: 'username'
                  }, {
                      display: 'truename',
                      name: 'truename',
                      isdefault: true
                  }],
                  sortname: "id",
                  sortorder: "asc",
                  usepager: true,
                  title: 'Countries',
                  useRp: true,
                  rp: 20,
                  showTableToggleBtn: true,
                  width: 1200,
                  height: 400,
                  autoLoadData:false,
                  managerName:"a6UserManager",
                  managerMethod:"selectPerson"
              });
              
              function test(com, grid){
                  if (com == 'Delete') {
                      confirm('Delete ' + $('.trSelected', grid).length + ' items?')
                  }
                  else 
                      if (com == 'Add') {
                          alert('Add New Item');
                      }
              }
              //window.setTimeout(function(){
                //var time1 = new Date().getTime()
                //$("[codecfg]");
                //var time2 = new Date().getTime();
                //alert(time2-time1);
              //},1000);
            });
        </script>
</head>
<body class="body-pading" leftmargin="0" topmargin="" marginwidth="0" marginheight="0">
    <div class="classification">
        <div class="title">
            grid示例
        </div>
        <div class="list">
            <div class="button_box clearfix">
                <table id="testList" class="flexme3" style="display: none"></table>
            </div>
        </div>
        <div id="searchHTML">name：<input name="username" type="text"/></div>
    </div>
</body>
</html>
