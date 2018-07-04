// 定义全局变量,保存搜索的相关参数
var mySearchObj = new Object();
// 排序方式（默认降序）
mySearchObj.sortOrder = "desc";

$(function(){
    //=====排序=========
    $("#span_icon_order").click(function(){
        if(mySearchObj.sortOrder === 'desc'){
            mySearchObj.sortOrder = 'asc';
        } else {
            mySearchObj.sortOrder = 'desc';
        }
        $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
    });
    
    //=====搜索=========
    var searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            var ssss = searchobj.g.getReturnValue();
            mySearchObj.condition = ssss.condition;
            mySearchObj.value = ssss.value;
            $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
        },
        conditions: [{
            id: 'docName',
            name: 'docName',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.name')}",
            value: 'frName'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: "${ctp:i18n('doc.jsp.knowledge.query.contentType')}",
            value: 'frType',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeEnumImpl'"
        }, {
            id: 'keyword',
            name: 'keyword',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.key')}",
            value: 'keyWords'
            
        }, {
            id : 'alterUser',
            name : 'alterUser',
            type : 'selectPeople',
            text : "${ctp:i18n('doc.metadata.def.lastuser')}",
            value : 'lastUserId',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'alterDate',
            name: 'alterDate',
            type: 'datemulti',
            text: "${ctp:i18n('doc.metadata.def.lastupdate')}",
            value: 'statusDate',
            ifFormat:'%Y-%m-%d'
        }]
    });
});