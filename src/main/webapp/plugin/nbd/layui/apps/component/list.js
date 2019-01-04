;
(function () {

    lx.mdefine("list", ['jquery'], function (exports) {

        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;

        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var List = new Klass();
        List.include(LxCmp);
        List.include({
            init:function (options) {
                this.jq = $;
                this.data_prop=options.data_prop;
                this.root = $("<div class='" + options.className + "'></div>");
                this.options = options;
                if(options.parent_id){
                    this.parent = $("#" + this.op_.parent_id);
                    this.parent.append(this.root);
                }
                if(options.parentCmp){
                    this.parent = options.parentCmp;
                    this.parent.append(this.root);
                }
                if(options.mode){
                    this.mode = options.mode;

                }else{
                    this.mode="normal";
                }
                if(options.max){
                    this.max=options.max;
                }else{
                    this.max=-1;
                }
                if(options.link_prop){
                    this.link_prop=options.link_prop;
                }else{
                    this.link_prop=false;
                }
                if (options.data_url) {
                    var me = this;
                    $.ajax({
                        url: options.data_url,
                        async: true, //同步方式发送请求，true为异步发送
                        type: "GET",
                        dataType: "json",
                        success: function (data) {
                            if(data.items){
                                me.render(data.items,data.count);
                            }
                        },
                        error: function (res) {

                        }
                    })
                }else{
                    if(options.data){
                        this.render(options.data,options.data?options.data.length:-1);
                    }
                }

            },
            refresh:function(url){
                var me = this;
                if(!url){
                    url = this.options.data_url;
                }
                if(!url){
                    return ;
                }
                $.ajax({
                    url: url,
                    async: true, //同步方式发送请求，true为异步发送
                    type: "GET",
                    dataType: "json",
                    success: function (data) {
                        if(data.items){
                            me.render(data.items,data.count);
                        }
                    },
                    error: function (res) {

                    }
                })

            },
            render:function(data,count__){
                var key = [];
                if(typeof (data)=="string"){
                    return ;
                }
                if(data.length<0){
                    return ;
                }
                if (!this.data_prop){
                    this.data_prop=[];
                    for (var p in data[0]) {
                        this.data_prop.push({"name":p});
                    }
                }
                var htmls = [''];

                if(this.mode=="normal"){
                    for(var p=0;p<data.length;p++){
                        var p_data = data[p];
                        if(!this.link_prop){
                            htmls.push("<div style='height:35px;cursor:pointer;font-size:18px;color:#524849' class='layui-row'>");
                        }else{
                            var link_url= p_data[this.link_prop];
                            if(link_url){

                                htmls.push("<div onclick='window.open(\""+link_url+"\")' style='height:35px;cursor:pointer;font-size:18px;color:#524849' class='layui-row'>");
                            }else{

                                htmls.push("<div style='height:35px;cursor:pointer;font-size:18px;color:#524849' class='layui-row'>");
                            }
                        }


                        if(this.max&&this.max>0){
                            if(p+1>this.max){

                                break;
                            }
                        }
                        for (var k = 0; k < this.data_prop.length;k++){
                            var cell = this.data_prop[k];
                            if(!cell.size){
                                cell.size=4;
                            }
                            if(cell&&cell.render){
                                htmls.push("<div class='lx-eps layui-col-md" + cell.size + "'>" + cell.render(cell.name, p_data[cell.name],p_data,count__) + "</div>");
                            }else{
                                htmls.push("<div class='lx-eps layui-col-md" + cell.size + "'>" + p_data[cell.name] + "</div>");
                            }
                        }
                        htmls.push("</div>");

                    }
                }else{
                    htmls.push('<table class="layui-table layui-col-xs12"  lay-skin="'+this.mode+'">');
                    htmls.push('<tbody class="layui-col-xs12">');
                    for(var p=0;p<data.length;p++){
                        var p_data = data[p];
                        htmls.push("<tr class='layui-col-xs12' style='cursor:pointer;font-size:18px;color:#524849'>");
                        for (var k = 0; k < this.data_prop.length;k++){
                            var cell = this.data_prop[k];
                            if(!cell.size){
                                cell.size=4;
                            }
                            if(cell&&cell.render){
                                htmls.push("<td class='lx-eps layui-col-md" + cell.size + "'>" + cell.render(cell.name, p_data[cell.name],p_data) + "</td>");
                            }else{
                                htmls.push("<td class='lx-eps layui-col-md" + cell.size + "'>" + p_data[cell.name] + "</td>");
                            }
                        }
                        htmls.push("</tr>");

                    }

                    htmls.push('</tbody>');
                    htmls.push('</table>')

                }


                this.root.html(htmls.join(''));
            }
        });

        apiSet.create = function (options) {

            return new List(options);
        }

        apiSet.hello = function () {
            alert("hello");
        }



        exports("list", apiSet);
    })



}());