package com.seeyon.apps.scheduletask.constant;



public interface STConstants {
	public static final String DEFAULTTIME = "2000-01-01 00:00:00";
    static final String Configuration = "com.seeyon.apps.scheduletask.ScheduleTask";   //AD配置类别
    //同步时间的类型 mazc
    public static enum Timer_Type{
        setTime, //指定时间
        intervalTime; //间隔时间
        public static Timer_Type valueOf(int value){
        	Timer_Type[] arr = Timer_Type.values();
        	for (Timer_Type type : arr) {
				if(type.ordinal()==value){
					return type;
				}
			}
			return null;
        }
    }
    public static enum OrgTriggerDate
    {
    	everyday(0),	//每天
    	sunday(1),	    //每周日
    	monday(2),		//每周一
    	tuesday(3), 	//每周二
    	wednesday(4),	//每周三
    	thursday(5),	//每周四
    	friday(6),		//每周五
    	saturday(7);	//每周六
    	

    	// 标识 用于数据库存储
    	private int key;

    	OrgTriggerDate(int key) {
    		this.key = key;
    	}

    	public int getKey() {
    		return this.key;
    	}

    	public int key() {
    		return this.key;
    	}
    }
}
