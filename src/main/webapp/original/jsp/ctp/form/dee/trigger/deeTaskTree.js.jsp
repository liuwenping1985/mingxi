<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script type="text/javascript">
    var gridObj;

    $(document).ready(function () {
        initTree();
        initSearchObj();
        initTable();
    });

    /**
     * 初始化任务分类树
     */
    function initTree() {
        var $deeTree = $("#deeTree");
        $deeTree.tree({
            idKey: "id",
            pIdKey: "parentId",
            nameKey: "name",
            managerName: "deeTriggerDesignManager",
            managerMethod: "getFlowListTree",
            onClick: nodeClk,
            nodeHandler: function (n) {
                n.open = true;
            }
        });
        $deeTree.empty();
        $deeTree.treeObj().reAsyncChildNodes(null, "refresh");
    }

    function nodeClk(e, treeId, node) {
        var o = {};
        o.flowType = node.id;
        $("#deeTable").ajaxgridLoad(o);
    }

    /**
     * 初始化搜索框
     */
    function initSearchObj() {
        var topSearchSize = 2;
        if ($.browser.msie && $.browser.version == '6.0') {
            topSearchSize = 5;
        }
        var searchObj = $.searchCondition({
            top: topSearchSize,
            right: 10,
            searchHandler: function () {
                var o = {};
                var choose = $('#' + searchObj.p.id).find("option:selected").val();
                if (choose === 'flowName') {
                    o.flowName = $('#flowName').val();
                }
                var val = searchObj.g.getReturnValue();
                if (val !== null) {
                    $("#deeTable").ajaxgridLoad(o);
                }
            },
            conditions: [{
                id: 'flowName',
                name: 'flowName',
                type: 'input',
                text: '${ctp:i18n('form.trigger.triggerSet.taskName.label')}',
                value: 'flowName'
            }]
        });
    }

    /**
     * 初始化任务表格
     */
    function initTable() {
        var $deeTable = $("#deeTable");
        gridObj = $deeTable.ajaxgrid({
            colModel: [
                {
                    display: '${ctp:i18n("form.trigger.triggerSet.select.label")}',
                    name: 'fLOW_ID',
                    width: '7%',
                    sortable: false,
                    align: 'center',
                    type: 'radio',
                    isToggleHideShow: false
                },
                {
                    display: "${ctp:i18n("form.trigger.triggerSet.collectionDataName.label")}",
                    name: 'dIS_NAME',
                    width: '30%'
                },
                {
                    display: "${ctp:i18n("form.trigger.triggerSet.taskClassification.label")}",
                    name: 'fLOW_TYPE_NAME',
                    width: '30%'
                },
                {
                    display: "${ctp:i18n("form.base.modifytime")}",
                    name: 'cREATE_TIME',
                    width: '30%'
                }
            ],
            managerName: "deeTriggerDesignManager",
            managerMethod: "getFlowList",
            parentId: $('.layout_east').eq(0).attr('id'),
            usepager: true,
            height: $(document).height() - 70,
            isHaveIframe: false,
            slideToggleBtn: false,
            vChange: false,
            vChangeParam: {
                overflow: "hidden",
                autoResize: false
            }
        });
        $deeTable.ajaxgridLoad({});

        $(".vGrip").hide();
        $(".flexigrid").css("margin-top", "30px");
    }

    /**
     * 返回方法
     * @returns {*}
     * @constructor
     */
    function OK() {
        var rows = gridObj.grid.getSelectRows();
        if (rows.length < 1) {
            $.alert("${ctp:i18n('form.base.relationProject.chooseItem')}");
            return;
        }

        var returnVal = {};
        returnVal.taskId = rows[0].fLOW_ID;
        returnVal.taskName = rows[0].dIS_NAME;

        return returnVal;
    }
</script>