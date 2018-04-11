<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/6/23
  Time: 12:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<style type="text/css">
</style>
<head>
    <title></title>
</head>
<body id='layout' class="comp" comp="type:'layout'">
<div class="layout_center" id="center" style="overflow:hidden;">
  <table class="flexme3" style="display: none" id="mytable"></table>
  </div>
<script type="text/javascript" src="${path}/ajax.do?managerName=formListManager"></script>
</body>
<script type="text/javascript">
    var totalNum = ${totalCount};
  $(document).ready(
          function() {
            table = $("#mytable").ajaxgrid({
              colModel : [
//                  {
//                display : 'id',
//                name : 'id',
//                width : '25',
//                sortable : false,
//                align : 'center',
//                isToggleHideShow:false,
//                type : 'checkbox'
//              },
                  {
                display : "${ctp:i18n('form.base.formname.label')}",
                name : 'name',
                width : '24%',
                sortable : true,
                align : 'left',
                isToggleHideShow:false
              }, {
                display : "${ctp:i18n('formsection.config.template.category')}",
                name : 'categoryId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
                name : 'ownerId',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
              }, {
                  display : "${ctp:i18n('common.accout.name.lable')}",
                  name : 'orgId',
                  width : '8%',
                  sortable : true,
                  isToggleHideShow:false,
                  align : 'center'
              }, {
                display : "${ctp:i18n('form.base.formtype.label')}",
                name : 'formTypeName',
                width : '10%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
              }, {
                display : "${ctp:i18n('form.base.maketime')}",
                name : 'createTime',
                isToggleHideShow:false,
                width : '12%',
                sortable : true,
                align : 'left'
              }
                , {
                  display : "${ctp:i18n('form.base.modifytime')}",
                  name : 'modifyTime',
                  width : '12%',
                  isToggleHideShow:false,
                  sortable : true,
                  align : 'left'
                } ],
              isToggleHideShow:false,
              managerName : "formListManager",
              managerMethod : "getUnflowList",
              callBackTotle : changeTitle,
              usepager : false,
              useRp :true,
              customize:false,
              resizable : true,
              showToggleBtn: false,
              parentId: $('.layout_center').eq(0).attr('id'),
              slideToggleBtn: true
            });
            //初始化
            var o = new Object();
            $("#mytable").ajaxgridLoad(o);
          });

    function changeTitle(cnt) {
        window.parentDialogObj['unflowFormList'].setTitle("占用产能表单列表(可用总数"+totalNum  + ",已用总数" + cnt + ")");
    }
</script>
</html>
