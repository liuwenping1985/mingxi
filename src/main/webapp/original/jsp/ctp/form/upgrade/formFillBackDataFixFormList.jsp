<%--
  Created by IntelliJ IDEA.
  User: daiy
  Date: 2014-11-10
  Time: 11:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <title>无流程表单回写数据修复</title>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formListManager,formTriggerManager"></script>
    <script type="text/javascript">
        var unFlowTable;
        var isReady = false;
        $(document).ready(function(){
            var tableObj = {};
            tableObj.colModel=getTableColModel();
            tableObj.isToggleHideShow=false;
            tableObj.managerName="formListManager";
            tableObj.managerMethod="designFormshow";
            tableObj.usepager=true;
            tableObj.useRp=true;
            tableObj.customize=true;
            tableObj.resizable=true;
            tableObj.render=rend;
            tableObj.showToggleBtn=false;
            tableObj.vChange=true;
            tableObj.vChangeParam={overflow: "hidden",
                autoResize:true};
            tableObj.slideToggleBtn=true;

            tableObj.parentId='center2';
            unFlowTable = $("#mytable2").ajaxgrid(tableObj);

            var o = {};
            o.property="accountForm";
            o.formtype="${ctp:escapeJavascript(param.formtype)}";
            $("#mytable2").ajaxgridLoad(o);
            isReady = true;
        });

        function getTableColModel(){
            var o = [ {
                display : 'id',
                name : 'id',
                width : '25',
                sortable : false,
                align : 'center',
                isToggleHideShow:false,
                type : 'checkbox'
            }, {
                display : "${ctp:i18n('form.base.formname.label')}",
                name : 'name',
                width : '30%',
                sortable : true,
                align : 'left',
                isToggleHideShow:false
            }, {
                display : "${ctp:i18n('formsection.config.template.category')}",
                name : 'categoryId',
                width : '15%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
            }, {
                display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
                name : 'ownerId',
                width : '15%',
                sortable : true,
                isToggleHideShow:false,
                align : 'center'
            }, {
                display : "${ctp:i18n('form.base.formtype.label')}",
                name : 'formTypeName',
                width : '15%',
                sortable : true,
                isToggleHideShow:false,
                align : 'left'
            }, {
                display : "${ctp:i18n('form.base.maketime')}",
                name : 'createTime',
                isToggleHideShow:false,
                width : '18%',
                sortable : true,
                align : 'left'
            } ];
            return o;
        }

        //回调函数
        function rend(txt, data, r, c) {
            if(c == 1){
                if(data.isExistsDataset == true){
                    txt = txt + "<em class='ico16 form_16'/>";
                }
                return txt;
            }else{
                return txt;
            }
        }

        function getSelectedIds(){
            if (!isReady){
                return "";
            }
            var gridObjArray = unFlowTable.grid.getSelectRows();
            var id = "";
            if (gridObjArray && gridObjArray.length > 0){
                for(var i = 0; i < gridObjArray.length; i++){
                    id = id + gridObjArray[i].id + ",";
                }
                if (id){
                    id = id.substr(0,id.length-1);
                }
            }
            return id;
        }

    </script>
</head>
<body class="h100b over_hidden">
    <div id='layout2' class="comp" comp="type:'layout'">
        <div class="layout_center" id="center2" style="overflow:hidden;">
            <table class="flexme3" style="display: none" id="mytable2"></table>
            <div id='grid_detail2'>
                <iframe id="viewFrame2" frameborder="0" src=""  style="width: 100%;height:100%;"></iframe>
            </div>
        </div>
    </div>
</body>
</html>
