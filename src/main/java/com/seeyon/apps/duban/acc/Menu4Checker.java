package com.seeyon.apps.duban.acc;
import com.seeyon.ctp.menu.check.MenuCheck;
/** * 简单的MenuCheck实现，永远返回true，用于所有普通用户都可以访问的菜单 */ 
public class Menu4Checker implements MenuCheck 
{
	public boolean check(long memberId,long loginAccountId)
	{
		return true;
	}
}
