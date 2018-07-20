<%--
 $Author: muyx $
 $Rev: 1 $
 $Date:: 2012-11-20 下午2:08:33#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script type="text/javascript">
/**
 * 知识中心，条件查询使用方法，仅仅适合doc_resource表的查询
 * 1.调用全局方法var oQueryBar= getDocQueryBar()返回查询控件对象
 * 2.oQueryBar.init("id");传入控件div的id
 * 3.注册回调函数oQueryBar.queryFunc=function(){};
 * 4.回调函数会传回查询参数
 */
var _CTP_QUERY_BAR_OBJECT_DOC={"init":_CTP_QUERY_INIT};
function _CTP_QUERY_INIT(id){
    //**********搜索************
    _CTP_QUERY_BAR_OBJECT_DOC.queryBar = $('#'+id).searchCondition({
        searchHandler:_CTP_fnSearchHandler,
        conditions: [{
            id: 'frName',
            name: 'frName',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.name'),
            value: 'frName'
        }, {
            id: 'frType',
            name: 'frType',
            type: 'select',
            text: $.i18n('doc.jsp.knowledge.query.contentType'),
            value: 'frType',
            codecfg: "codeType:'java',codeId:'com.seeyon.apps.doc.enums.ContentTypeEnums'"
        }, {
            id: 'keyWords',
            name: 'keyWords',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.key'),
            value: 'keyWords'
        }, {
            id: 'createTime',
            name: 'createTime',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.createTime'),
            value: 'createTime',
            ifFormat:'%Y-%m-%d'
        }, {
            id: 'createUser',
            name: 'createUser',
            type: 'input',
            text: $.i18n('doc.jsp.knowledge.query.createUser'),
            value: 'createUser'
        }/*, {
            id: 'sponsor',
            name: 'sponsor',
            type: 'selectPeople',
            text: $.i18n('doc.jsp.knowledge.query.launched'),
            value: 'sponsor',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'startDate',
            name: 'startDate',
            type: 'datemulti',
            text: $.i18n('doc.jsp.knowledge.query.launchedTime'),
            value: 'startDate',
            ifFormat:'%Y-%m-%d'
        }*/]
    });  
}
function _CTP_fnSearchHandler(){
        var jsonParam = _CTP_QUERY_BAR_OBJECT_DOC.queryBar.g.getReturnValue();
        if (jsonParam == null) {
            return;
        }
        
        var paramValue = jsonParam.value;
        var condition = jsonParam.condition;
        
        if(typeof(_CTP_QUERY_BAR_OBJECT_DOC.queryFunc) != "undefined"){
            _CTP_QUERY_BAR_OBJECT_DOC.queryFunc({"condition":condition,"value":paramValue});
        }
}

function getDocQueryBar(){
    return _CTP_QUERY_BAR_OBJECT_DOC;
}
</script>