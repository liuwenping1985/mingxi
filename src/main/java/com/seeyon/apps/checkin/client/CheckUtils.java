package com.seeyon.apps.checkin.client;

import java.util.Calendar;
import java.util.Date;

public class CheckUtils {
	
	public static void main(String[] args){
		System.out.println(getWeekNameOfWeekCode("6"));
	}
	
	/**
	 * 根据日期Code获得日期
	 * @param weekCode
	 * @return
	 */
	public static String getWeekNameOfWeekCode(String weekCode){
		int weekindex = Integer.parseInt(weekCode);
		String[] weekDaysName = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五",	"星期六" };
		return weekDaysName[weekindex];
	}
	
	/**
	 * 根据日期获得星期(星期日，星期一，星期二，星期三，星期四，星期五，星期六)
	 * 
	 * @param date
	 * @return
	 */
	public static String getWeekNameOfDate(Date date) {
		String[] weekDaysName = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五",	"星期六" };
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int intWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1;
		return weekDaysName[intWeek];
	}

	/**
	 * 根据日期获得星期(0,1,2,3,4,5,6)
	 * @param date
	 * @return
	 */
	public static String getWeekCodeOfDate(Date date) {
		String[] weekDaysCode = { "0", "1", "2", "3", "4", "5", "6" };
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		int intWeek = calendar.get(Calendar.DAY_OF_WEEK) - 1;
		return weekDaysCode[intWeek];
	}
}
