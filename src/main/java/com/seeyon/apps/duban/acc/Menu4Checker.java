package com.seeyon.apps.duban.acc;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.filemanager.manager.FileManager;
import com.seeyon.ctp.menu.check.MenuCheck;
import com.seeyon.ctp.util.JDBCAgent;
import org.springframework.util.CollectionUtils;

import java.io.File;
import java.util.List;
import java.util.Map;

/** * 简单的MenuCheck实现，永远返回true，用于所有普通用户都可以访问的菜单 */
public class Menu4Checker implements MenuCheck 
{
	public boolean check(long memberId,long loginAccountId)
	{
		if (loginAccountId ==-2976160429368457850l) {
			return true;//版本控制，黄河水电
		}
		return false;
	}

	public static void main(String[] args){



	}


	public static File getAttachmentFileBySubreference(Object subReferenceId){

		String sql = "select file_url from ctp_attachment where sub_reference="+String.valueOf(subReferenceId);
		JDBCAgent agent = new JDBCAgent();//如果要复用就当做成员变量

		try{
			agent.execute(sql);
			List<Map> mapList = agent.resultSetToList(true);
			if(CollectionUtils.isEmpty(mapList)){
				return null;
			}
			FileManager fileManager = (FileManager)AppContext.getBean("fileManager");
			Object fileUrl = mapList.get(0).get("file_url");
			if(fileUrl==null){
				return null;
			}
			return fileManager.getFile(Long.parseLong(String.valueOf(fileUrl)));


		}catch (Exception e){
			e.printStackTrace();
		}finally {
			agent.close();
		}
		return null;

	}
}
