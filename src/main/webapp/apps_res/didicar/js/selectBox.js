

(function($) {
    function hasClass(ele,cls) {
      return ele.className.match(new RegExp('(\\s|^)'+cls+'(\\s|$)'));
    }
     
    function addClass(ele,cls) {
      if (!hasClass(ele,cls)) ele.className += " "+cls;
    }
     
    function removeClass(ele,cls) {
      if (hasClass(ele,cls)) {
          var reg = new RegExp('(\\s|^)'+cls+'(\\s|$)');
        ele.className=ele.className.replace(reg,' ');
      }
    }

    /**
     * 通用的选择框
     */
    $.SelectBox = function(){ this.initialize.apply(this, arguments);};
    $.SelectBox.prototype = {
      initialize: function(options, onchange){
        this.onchange = onchange || null;
        this.setOptions(options);
        this.binding();
      },
      setOptions: function(options){
        this.tabElement = options.tabElement || null;
        this.currentClass = options.currentClass || null;
        this.eventType = options.eventType || 'onclick';
        this.defaultIndex = options.defaultIndex;
        this.excludeAttr = options.excludeAttr || 'activeEvent';   // 事件触发时排除属性元素
        this.targetCache = null;
        this.currentIndex = null;   // 当前的索引值
      },
      /**
       * 设置选中项
       * @param {Number} index 索引值
       */
      setSelected: function(index){
        var childs = this.tabElement.children;
        if(!childs){return};
        var count=childs.length;
        if(index!=undefined && index > -1 && index < count){
            // 如果用户设置了当前Class
            if(this.currentClass){
              addClass(childs[index], this.currentClass);
            }
            
            this.currentIndex = index;

            // 如果有默认选中的项，则触发onchange事件
            if(this.onchange && this.currentIndex!=null){
              this.onchange(childs[index], this.targetCache, this.currentIndex);
            }

            this.targetCache = childs[index];
        }else if(index == -1){
          if(this.currentClass){
              // 判断上一次是否已经选择了选项，如果选择了则取消已经选择项
              if(this.targetCache){
                removeClass(this.targetCache, this.currentClass);
              }
          }
        }
      },
      /**
       * 初始态，且绑定事件
       */
      binding: function(){
        var that = this;
        // 执行初始态
        this.setSelected(this.defaultIndex);

        // 绑定事件
        this.tabElement[this.eventType] = function(e){
          e = e||window.event;
          var target = e.target||e.srcElement;

          if(that.tabElement == target){
              return false;
          }

          // 确定当前用户所点击的元素必须是Box是一级子元素
          while(that.tabElement != target.parentNode){
            target = target.parentNode;
          }
          
          // 过滤需要排除的元素，
          if( target.getAttribute(that.excludeAttr) ){
              return false;
          }

          // 判断是否需要改变其样式
          if(that.currentClass){
              // 判断上一次是否已经选择了选项，如果选择了则取消已经选择项
              if(that.targetCache){
                removeClass(that.targetCache, that.currentClass);
              }
              addClass(target, that.currentClass);
          }

          if(that.onchange){
            // 获取索引值
            var childs = that.tabElement.children;
            for(var i=0, len=childs.length; i<len; i++){
              if(childs[i] == target){
                that.currentIndex = i;
                break;
              }
            }

            that.onchange(target, that.targetCache, that.currentIndex);
          }

          that.targetCache = target;

          return false;
        };
      }
    }
})(jQuery);


