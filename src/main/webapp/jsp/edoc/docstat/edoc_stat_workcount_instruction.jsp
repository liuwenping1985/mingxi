<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<style type="text/css">
/*初始化样式*/
body,div,p,table,ul{
    padding:0;
    margin:0;
    font-family:"宋体";
    font-size: 16px;
    list-style: none;
}
.xl_block{
   	width:100%;
    margin:0 auto;
    border-collapse: collapse;
}
.xl_block_head>td{
    padding:5px 10px;
}
.xl_block_content>td{
   padding:20px;
}
.xl_block_input{
	margin-top:30px;
    padding-bottom:10px;
    line-height: 30px;
}
input[type="text"]{
    width:200px;
    padding:2px 3px;
}
.xl_table{
    margin:10px 0;
    width:100%;
    border-collapse: collapse;
}
.xl_table td{
    text-align: center;
    padding:5px 0;
}
.xl_table thead{
    background: #eaeaea;
}

</style>
</head>
<body scroll="">
    	<table class="xl_block">
        <tbody>      
        <tr class="xl_block_content">
            <td>
                <!--统计说明具体内容部分-->
               <!--发文权限--><!--收文权限-->
                <ul class="xl_block_input">
                    <li><font color="#FFFFFF">*&nbsp;</font>
                        <input type="checkbox" checked="checked" disabled="disabled"/>
                        <label>发文权限</label>
                        <input type="text" value="复核" readonly="readonly"/>
                    </li>
                    <li><font color="red">*&nbsp;</font>
                        <input type="checkbox" checked="checked" disabled="disabled"/>
                        <label>收文权限</label>
                        <input type="text" value="承办" readonly="readonly"/>
                    </li>
                </ul>
                <p>
                    例：管理员配置统计时，统计条件发文选择节点复核。收文选择节点承办。
                </p>
                <table border="1" class="xl_table">
                    <thead>
                        <tr>
                            <td colspan="2" rowspan="2">部门</td>
                            <td colspan="2">发文</td>
                            <td colspan="3">收文</td>
                        </tr>
                        <tr>
                            <td>发文数</td>
                            <td>字数</td>
                            <td>收文数</td>
                            <td>超期件数</td>
                            <td>超期率</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="2">秘书一处</td>
                            <td>3</td>
                            <td>1513</td>
                            <td>9</td>
                            <td>0</td>
                            <td>0%</td>
                        </tr>
                        <tr>
                            <td colspan="2">秘书二处</td>
                            <td>1</td>
                            <td>23566</td>
                            <td>10</td>
                            <td>2</td>
                            <td>20%</td>
                        </tr>
                    </tbody>
                </table>
                <p>上图中，统计结果中：</p>
                <p>发文统计结果为：秘书一处所有人员拟文，并通过复核节点的文。</p>
                <p>收文统计结果为：任意人分办，经过秘书一处所有人承办节点的文。</p>
            </td>
        </tr>
        </tbody>
    </table>
</body>
</html>