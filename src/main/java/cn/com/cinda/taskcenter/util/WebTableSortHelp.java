package cn.com.cinda.taskcenter.util;

public class WebTableSortHelp {
    public WebTableSortHelp() {
    }



    /**
     *
     * @param orderStr String
     * @param req_orderField String  定义排序的字段
     * @param orderField String  页面上点击的字段
     * @return String
     */
    public static String getTaskSortOrderStr(String old_orderStr,String orderField,String otherStr) {
             String orderStr=old_orderStr;
              if(orderStr.indexOf(orderField)==-1){
                  orderStr = "  "+orderField+otherStr;
              }else{
                if(orderStr.indexOf("desc")==-1){
                   orderStr = "  "+orderField+" desc"+otherStr;
                }else{
                   orderStr = "  "+orderField+otherStr;
                }
              }

              return orderStr;



   }

}
