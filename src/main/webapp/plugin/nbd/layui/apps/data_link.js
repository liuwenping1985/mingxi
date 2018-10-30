;
(function (exportObject) {
    var $ = exportObject.$;
    var data_link={};
    data_link.renderList=function(ret){

        var tb = $("#data_link_list_body");
        tb.html("");
        var items = ret.items;
        if(items&&items.length>0){
            /**
             * <th>连接名称</th>
             <th>地址</th>
             <th>数据类型</th>
             <th>用户名</th>
             <th>数据库名</th>
             */
            var htmls=[];
            $(items).each(function(index,item){
                htmls.push("<tr>");
                htmls.push("<td>"+item.extString1+"</td>");
                htmls.push("<td>"+item.host+"</td>");
                htmls.push("<td>"+item.dbType+"</td>");
                htmls.push("<td>"+item.user+"</td>");
                htmls.push("<td>"+item.dataBaseName+"</td>");
                htmls.push("</tr>");

            });
            tb.append(htmls.join(""));

        }

    }

    exportObject.DataLink = data_link;
})(window);