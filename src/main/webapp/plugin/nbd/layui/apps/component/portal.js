;
(function () {
    /**
     * 做到尽量简单
     */
    lx.mdefine("portal", ["jquery","mixed", "col", "sTab", "panel", "row", "list", "datepicker","mTab", "lunbo"], function (exports) {
        var apiSet = {};
        var $ = lx.jquery || lx.jQuery;
        var LxCmp = lx.LxComponent;
        var Klass = lx.getLxClass();
        var Portal = new Klass();
        var Row = lx.row;
        var Panel = lx.panel;
        var List = lx.list;
        var sTab = lx.sTab;
        var DatePicker = lx.datepicker;
        var Col = lx.col;
        var Lunbo = lx.lunbo;
        var MTab = lx.mTab;
        Portal.include(LxCmp);
        Portal.include({
            init: function (options) {
                this.op = options;
                this.rows = [];
                this.root = $("#" + this.op.root_id);
                var root_id = this.op.root_id;
                var rows = this.op.rows;
                for (var p = 0; p < rows.length; p++) {
                    var row = rows[p];
                    var p_row = Row.create({
                        "parent_id": root_id,
                         style:row.style
                    });
                    this.rows.push(p_row);
                    var cols = row.cols;
                    for (var k = 0; k < cols.length; k++) {
                        var col = cols[k];

                        var p_col = Col.create({
                            size: col.size,
                            id: col.id,
                            style:col.style
                        });
                        
                        p_row.append(p_col);
                        var ppp = p_col;
                        if(!col.children){
                            col.children="1";
                        }
                        var col_children_size = 12 / col.children.length;
                        var w_class = "layui-col-md" + col_children_size;
                        if (col.type == "common") {
                            ppp = $("<div id='" + col.id + "'></div>");
                            p_col.append(ppp);
                        }
                        if (col.type == "sTab") {
                            var sT = sTab.create({
                                "title": col.name,
                                id: col.id
                            });
                            p_col.append(sT);
                            ppp = sT;
                        }
                        if(col.style){
                            if(ppp.isLxCmp){
                                ppp.getBody().attr("style",col.style);
                            }else{
                                ppp.attr("style",col.style);
                            }
                        }
                        if(col.type=="custom"){
                            if(col.render){
                                col.render(ppp,col,lx);
                            }
                            
                            continue;
                        }
                        var col_children = col.children;

                        for (var m = 0; m < col_children.length; m++) {
                            var child = col_children[m];


                            //end of wrapper
                            if (child.cmp == "list") {
                                var ll = List.create({
                                    id: child.id,
                                    data_prop: child.data_prop,
                                    data: child.data,
                                    data_url: child.data_url,
                                    className: w_class
                                });
                                ppp.append(ll);
                            }
                            if (child.cmp == "datepicker") {
                                var ll = DatePicker.create({
                                    id: child.id,
                                    data: child.data,
                                    className: w_class,
                                    parent:ppp
                                });

                            }
                            if (child.cmp == "lunbo") {
                                child.cmp_options.parent_id = ppp.attr("id");
                                child.cmp_options.data = child.data;
                                child.cmp_options.data_url = child.data_url;
                                child.cmp_options.width = p_col.root.width();
                                child.cmp_options.height = 305;
                                child.cmp_options.className = w_class;

                                var lb = Lunbo.create(child.cmp_options);
                                ppp.append(lb);
                            }
                        }
                       
                    }
                }
                if(this.op.callback){
                    this.op.callback();
                }
            },
            getRows: function () {
                return this.rows;
            }
        });
        apiSet.create = function (options) {
            var portal = new Portal(options);
            portal.$ = $;
            return portal;
        }

        exports("portal", apiSet);


    });
})();