package com.seeyon.apps.cinda.authority.util;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import cn.com.hkgt.apps.util.IniReader;
import cn.com.hkgt.mywork.util.GetHtml;
import cn.com.hkgt.um.interfaces.exports.ExportService;
import cn.com.hkgt.um.vo.AuthorityVO;
import cn.com.hkgt.um.vo.UserVO;

import com.caucho.hessian.client.HessianProxyFactory;
import com.cindamc.loadProperty.GetResult;

public class CindaLinkUtils {
	private static final Log log  = LogFactory.getLog(CindaLinkUtils.class);
	/**
	 * 通过阅读代码找到/Users/mac/Downloads/cinda/cindaweb/portlet/newCinda/newCindaWdgz/column1.jsp、iframe1.jsp调用
	 * String leftCode=GetResult.getVal("MYWORK","LEFT");
	 * LinkedHashMap map=GetHtml.traverHashMapTree(leftCode,userId);
	 * 获得左右侧树的数据，traverHashMapTree方法获取了左侧或右侧全部数据该方法直接调用了export.getAuthListByIdAndLoginName(rootCode, loginName);
	 * 因此以后左右侧数据直接用该方法来获取即可
	 * @param rootCode
	 * @param loginName
	 * @return
	 */
	public static LinkedHashMap<String,AuthorityVO> getAuthListByRootAndLoginName(String rootCode, String loginName){
		try {
			HessianProxyFactory factory = new HessianProxyFactory();
			//http://portal.zc.cinda.ccb/um/usermanagerService // 赵辉 接口url修改
			ExportService export = (ExportService)factory.create(ExportService.class, "http://c1-osmapp.cinda.ccb:8071/gempMgrWeb/usermanagerService");
			return export.getAuthListByIdAndLoginName(rootCode, loginName);
		} catch (Exception e) {
			log.error("",e);
		}
		return null;
	}

	  public static void reloadUrls()
	  {
		  GetResult.iniReader = new IniReader();
	    try
	    {
	    	GetResult.iniReader.load("/Users/mac/Downloads/home/weblogic/portalconf/newCindaPortal.property");
	      return;
	    }
	    catch (Exception e)
	    {
	      e.printStackTrace();
	    }
	  }
	public static void main(String[] args) throws Exception {
		makeTreeMap();

	}
	public static void makeTreeMap(){
		//insert by fjh 20070417,修改使页面可以自动定高
		//获得左侧数据

		String userId="jsbzyp";
		String height="0";
		reloadUrls();
//		HashMap result=(HashMap)session.getAttribute(userId);
		//System.out.println(result);
//		if(result==null)
//		{

		String leftCode=GetResult.getVal("MYWORK","LEFT");
		LinkedHashMap map=GetHtml.traverHashMapTree(leftCode,userId);
		LinkedHashMap map_two=(LinkedHashMap)map.get("4");
		int size_left=0;
		if(map_two!=null)
		{
		   size_left=map_two.size();
		    }

		LinkedHashMap map_html=GetHtml.getThreeHtml(map,leftCode);
		//LinkedHashMap map_count=(LinkedHashMap)map_html.get("count");
		//String amount_left=(String)map_count.get("allCall");
		String htmlLeft=GetHtml.getAllHtmlForLeft(userId,leftCode,map,map_html);
		//System.out.println(htmlLeft);
		//htmlLeft=StringUtils.encrypt(htmlLeft);

		//初始化右侧数据
		String right_top=GetResult.getVal("MYWORK","RIGHTTOP");
		LinkedHashMap map_right=GetHtml.traverHashMapTree(right_top,userId);
		LinkedHashMap map_right_two=(LinkedHashMap)map_right.get("4");

		LinkedHashMap map_right_html=GetHtml.getFourHtml(map_right,right_top);
		String htmlRight=GetHtml.getAllHtmlForRight(userId,right_top,map_right,map_right_html);
		//htmlRight=StringUtils.encrypt(htmlRight);
		int size_right=0;
		if(map_right_two!=null)
		{
		   size_right=map_right_two.size();
		}
		//获取中间的的html.
		String htmlCenter=GetHtml.getAllHtmlForCenter(userId);

		//根据两侧的二级map来获得高度大小

		//获取高度
		height=GetHtml.getIframeHeight(size_left,size_right);
		//计算任务中心的iframe

		System.out.println(":::::::::::::::::::"+height);

		//changed by fjh 2008-9-22,为了从新代办和已办现实的条数，增加了computer类，调用该类下的getTaskCenterHeight方法
		//HashMap map_task=GetHtml.getTaskCenterHeight(height);
//		Computer comp=new Computer();
//		HashMap map_task=comp.getTaskCenterHeight(height);

		//end

		HashMap map_result=new HashMap();
		map_result.put("height",height);
		map_result.put("left",htmlLeft);
		map_result.put("right",htmlRight);
		map_result.put("center",htmlCenter);
//		map_result.put("taskcenter",map_task);
//
//		session.setAttribute(userId,map_result);
//
//
//		}else
//		{
//		    height=(String)result.get("height");
//		}
	}
}
