/**
 * 
 * $Author: muyx $ $Rev: 1 $ $Date:: 2013-06-20 下午2:08:33#$:
 * 
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved. This software is the proprietary information of Seeyon, Inc. Use
 * is subject to license terms.
 */
/**
 * 输入提示事件
 */
(function(cm) {
    // 输入框提示
    jQuery.fn.prompt = function(options) {
        var defaults = {
            prefix : "<",
            title : $.i18n('office.asset.assetPrompt.djcctx.js'),
            field : null,// 指定熟悉名称即可，自动拼写 prefix+title+field+suffix
            content : null,// 只是拼写 prefix+content+suffix
            ownContent : null,// 直接返回ownContent
            suffix : ">",
            sClass : "color_gray"
        };
        var _this = this;
        var opt = cm.extend(true,{}, defaults, options);
        var content = initPrompt(opt);
        this.prompt = fillPrompt;
        this.content = setContent;
        this.clearPrompt = clearPrompt;
        
        this.val(content).addClass(opt.sClass);

        this.live("focus", clearPrompt);

        this.live("change blur", fillPrompt);
        
        function clearPrompt(){
            var value = _this.val();
            if (value === content) {
                _this.val("");
                _this.removeClass(opt.sClass);
            }
        }
        
        function  fillPrompt() {// 完全清除时，回填提示消息
            var value = _this.val();
            if (value === "") {
                _this.val(content);
                _this.addClass(opt.sClass);
            }
            return _this;
        }
        
        function initPrompt(opt) {
            var content = "";
            if (opt.ownContent != null) {
                content = opt.ownContent;
            } else if (opt.content != null) {
                content = opt.prefix + opt.content + opt.suffix;
            } else if (opt.field != null) {
                content = opt.prefix + opt.title + opt.field + opt.suffix;
            } else {
                content = opt.prefix + opt.title + opt.suffix;
            }
            return content;
        }
        
        function setContent(_content){
            if(_content){
                content=_content;
                return _this;
            }else{
                return content;
            }
        }
        
        return this;
    }
})(jQuery);