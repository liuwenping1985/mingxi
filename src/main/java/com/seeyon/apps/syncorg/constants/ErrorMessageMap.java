package com.seeyon.apps.syncorg.constants;

import java.util.HashMap;

public class ErrorMessageMap {

	private static HashMap<String, String> errorMessageMap = new HashMap();
	
	private static void init(){
		if(errorMessageMap!=null&&errorMessageMap.size()!=0){
			errorMessageMap = new HashMap();
		}
		errorMessageMap.put("100001", "无效的 token. ");
		errorMessageMap.put("200001", "对象名称不存在。");
		errorMessageMap.put("200002", "同步对象不存在。");
		
		errorMessageMap.put("300002", "同步操作不存在。");
		errorMessageMap.put("300003", "编码不能为空");
		
		errorMessageMap.put("400001", "传入的 XML 在转换成单位对象的时候出错。");
		errorMessageMap.put("400002", "传入的 XML 在转换成部门对象的时候出错。");
		errorMessageMap.put("400003", "传入的 XML 在转换成职务级别对象的时候出错。");
		errorMessageMap.put("400004", "传入的 XML 在转换成人员的时候出错。");
		errorMessageMap.put("400005", "传入的 XML 在转换成岗位对象的时候出错。");
		// 单位的相关错误信息
		errorMessageMap.put("500001", "单位编码不能为空");
		errorMessageMap.put("500002", "根据单位编码， 没有找到对应的单位");
		errorMessageMap.put("500003", "OA系统中内有找到任何的单位");
		errorMessageMap.put("500004", "OA系统中， 获取全部单位信息出错");
		errorMessageMap.put("500006", "单位的名称重复。");
		errorMessageMap.put("500007", "单位编码已经存在");
		errorMessageMap.put("500009", "处理单位的时候发生错误");
		
		errorMessageMap.put("500012", "根据第三方单位的ID， 没有找到对应的单位");
		errorMessageMap.put("500017", "根据第三方系统的Id查找单位的时候， OA 中已经存在");
		// 部门的相关错误信息
		
		errorMessageMap.put("600001", "部门编码不能为空");
		
		errorMessageMap.put("600002", "处理部门的时候发生错误");
		errorMessageMap.put("600003", "部门不存在");
		errorMessageMap.put("600005", "OA系统中， 获取全部部门信息出错");
		errorMessageMap.put("600006", "同一级别的部门名称重复。");
		
		errorMessageMap.put("600007", "部门编码已经存在");
		errorMessageMap.put("600008", "在获得父部门的时候， 程序出错");
		
		errorMessageMap.put("600013", "部门不存在, 请注意， 在推送子部门的时候， 一定要先推送父部门");
		errorMessageMap.put("600014", "部门的第三方系统ID 不能为空");
		// 人员的相关错误信息
		
		errorMessageMap.put("700001", "人员编码不能为空");
		errorMessageMap.put("700002", "处理人员的时候发生错误");
		errorMessageMap.put("700003", "根据人员编码， 没有找到对应的人员");
		errorMessageMap.put("700004", "OA系统中内有找到任何属于该单位的人员");
		errorMessageMap.put("700006", "人员的登录名重复");
		
		errorMessageMap.put("700007", "人员生日的格式不正确, 正确的格式是： yyyy-MM-dd ");
		errorMessageMap.put("700008", "人员的编码已经存在");
		// 岗位的行管错误信息
		errorMessageMap.put("800001", "岗位编码不能为空");
		errorMessageMap.put("800002", "处理岗位的时候发生错误");
		errorMessageMap.put("800003", "根据岗位编码， 没有找到对应的岗位");
		errorMessageMap.put("800004", "OA系统中内有找到岗位");
		errorMessageMap.put("800006", "岗位的名称重复。");
		errorMessageMap.put("800007", "岗位的编码已经存在。");
		
		errorMessageMap.put("800005", "OA系统中， 获取全部岗位信息出错");
		// 职务级别的相关错误信心
		errorMessageMap.put("900001", "职务级别编码不能为空");
		errorMessageMap.put("900002", "处理职务级别的时候发生错误");
		errorMessageMap.put("900003", "根据职务级别编码， 没有找到对应的职务级别");
		errorMessageMap.put("900004", "OA系统中内有找到职务级别");
		errorMessageMap.put("900005", "OA系统中， 获取全部职务级别信息出错");
		errorMessageMap.put("900006", "职务级别的名称重复。");
		errorMessageMap.put("900007", "职务级别编码已经存在。");
	}
	
	public static String getErrorMessage(String errorCode){
		if(errorMessageMap==null||errorMessageMap.size()==0){
			init();
		}
		return errorMessageMap.get(errorCode);
	}
	
}
