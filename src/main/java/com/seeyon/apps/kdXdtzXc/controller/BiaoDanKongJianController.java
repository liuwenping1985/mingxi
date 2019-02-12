package com.seeyon.apps.kdXdtzXc.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.seeyon.apps.kdXdtzXc.manager.GeRenZhiFuXinXi;
import com.seeyon.apps.kdXdtzXc.po.CarAndShip;
import com.seeyon.apps.kdXdtzXc.po.JiuDianFaPiao;
import com.seeyon.apps.kdXdtzXc.po.TrafficFeiXieCheng;
import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.util.JSONUtils;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import com.seeyon.ctp.common.AppContext;
import com.seeyon.ctp.common.controller.BaseController;
import com.seeyon.ctp.common.taglibs.functions.Functions;
import com.seeyon.ctp.util.UUIDLong;
import com.seeyon.ctp.util.annotation.NeedlessCheckLogin;

public class BiaoDanKongJianController extends BaseController{
	private GeRenZhiFuXinXi geRenZhiFuXinXi;
	
	public GeRenZhiFuXinXi getGeRenZhiFuXinXi() {
		return geRenZhiFuXinXi;
	}

	public void setGeRenZhiFuXinXi(GeRenZhiFuXinXi geRenZhiFuXinXi) {
		this.geRenZhiFuXinXi = geRenZhiFuXinXi;
	}

	JdbcTemplate jdbcTemplate = (JdbcTemplate) AppContext.getBean("kimdeJdbcTemplate");
	@NeedlessCheckLogin
    public ModelAndView getXianMu(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sql="SELECT * FROM formmain_3603";
		List<Map<String, Object>> queryForList = jdbcTemplate.queryForList(sql);
    	ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/xianMuMinCheng");
    	mav.addObject("queryForList",queryForList);
        return mav;
    }
	
	@NeedlessCheckLogin
	/**
	 * 这个没用了 获取原单号的功能
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    public ModelAndView getYuanDanHao(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String sql="SELECT * FROM formmain_0108";
		List<Map<String, Object>> yuanDanHao = jdbcTemplate.queryForList(sql);
		List<Map<String, Object>>list =new ArrayList<Map<String,Object>>();
		for (Map<String, Object> map : yuanDanHao) {
			String biaodan=(String)map.get("field0002")== null ?"" :(String)map.get("field0002");
			String memberid=(String)map.get("field0003")== null ?"" :(String)map.get("field0003");
			String memberName = Functions.showMemberName(Long.valueOf(memberid));//人员id
			map.put("field0002", biaodan);
			map.put("field0003", memberName);
			list.add(map);
		}
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/yuandanhao");
    	mav.addObject("yuanDanHao",list);
        return mav;
    }
	
	@NeedlessCheckLogin
	/**
	 * 非携程页面获取主表单上的订单号 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
    public ModelAndView getGeRenZhiFu(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String formrecid=request.getParameter("formrecid");
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/gerenzhifu"); 
    	mav.addObject("formrecid", formrecid);
        return mav;
    }
	/**
	 * 获取主表单上的订单号 分公司的
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@NeedlessCheckLogin
	public ModelAndView getFengSiGeRenZhiFu(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String formrecid=request.getParameter("formrecid");
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/fengonsiFeiXiecheng"); 
		mav.addObject("formrecid", formrecid);
		return mav;
	}
	@NeedlessCheckLogin
	/**
	 * 非携程数据的添加
	 */
	public void getAll(HttpServletRequest request, HttpServletResponse response){
		try {
			String[] jttype = request.getParameterValues("jttype");//交通工具类型
			String[] chechuangfei = request.getParameterValues("chechuangfei");//车船机票费
			String[] qitachaiLF = request.getParameterValues("qitachaiLF");//其他差旅费
			String[] feiyongleixing = request.getParameterValues("feiyongleixing");//费用类型
			String[] beizhu = request.getParameterValues("beizhu");//备注
			String chechuangzong=request.getParameter("chechuangzong") =="" ? "0"  :request.getParameter("chechuangzong");
			String qitachaizong=request.getParameter("qitachaizong") =="" ? "0" : request.getParameter("qitachaizong");
			String formrecid=request.getParameter("formrecid");
			
			String[] shifouzhuanpiao = request.getParameterValues("shifouzhuanpiao");//是否专票
			String[]  jiudianjiashui= request.getParameterValues("jiudianjiashui");//价税合计
			String[]  jiudianjine= request.getParameterValues("jiudianjine");//金额
			String[]  jiudianshuie= request.getParameterValues("jiudianshuie");//税额
			String[]  jiudianshuiL= request.getParameterValues("jiudianshuiL");//税率
			String[]  jiudianfapiaohao= request.getParameterValues("jiudianfapiaohao");//发票编号
			String heji=request.getParameter("xcxiaoji") =="" ? "0" :request.getParameter("xcxiaoji");//合计
			
			String pjnumber=request.getParameter("pjnumber") == "" ? "0" :request.getParameter("pjnumber"); //票据张数
			String zheji=request.getParameter("xcheji") == "" ? "0" :request.getParameter("xcheji");//总合计
			
			String[] hiddcar = request.getParameterValues("hidd");
			String[] hiddzu = request.getParameterValues("hiddzu");
			String zonghidd = request.getParameter("zonghidd");
			if(StringUtils.isEmpty(zonghidd)){
			BigDecimal zheji1 =new BigDecimal(zheji);
			int addtongji=0;
			List<Map<String, Object>> queryTongJi = geRenZhiFuXinXi.queryTongJi(formrecid);
			if(queryTongJi.isEmpty()){
			addtongji = geRenZhiFuXinXi.addtongji(pjnumber,zheji1,formrecid);
			}
			int addcarAndship=0; //添加车船返回的状态
			int addzhusu=0;     // 添加住宿返回状态
			if(jttype.length>0){
				List<Map<String, Object>> queryCarAndShip = geRenZhiFuXinXi.queryCarAndShip(formrecid);
				if(queryCarAndShip.isEmpty()){
			//CarAndShip carAndShip=null;
			for (int i = 0; i < jttype.length; i++) {
				String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
				BigDecimal big =new BigDecimal(qtFei);
				String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
				BigDecimal bigxf =new BigDecimal(chuangfei);
				BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
				BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
				String xcJtType=jttype[i] == null ? "" :jttype[i];
				String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
				String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
				CarAndShip carAndShip = new CarAndShip(String.valueOf(UUIDLong.longUUID()),String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
				addcarAndship = geRenZhiFuXinXi.addcarAndship(carAndShip);
				}
			}
			}
			if(shifouzhuanpiao.length>0 ){
				List<Map<String, Object>> queryZhuSu = geRenZhiFuXinXi.queryZhuSu(formrecid);
				if(queryZhuSu.isEmpty()){
			for (int j = 0; j < shifouzhuanpiao.length; j++) {
				String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
				BigDecimal jiashui =new BigDecimal(jsJinE);
				
				String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
				
				BigDecimal jine =new BigDecimal(jdJine);
				String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
				BigDecimal shuie =new BigDecimal(shuiE);
				BigDecimal heji1 =new BigDecimal(heji);
				
				String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
				
				String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
						
				String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
				
				JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(String.valueOf(UUIDLong.longUUID()),String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
				addzhusu = geRenZhiFuXinXi.addzhusu(jiuDianFaPiao);
						}
					}
				}
			}else{
			System.out.println(jttype);
			
			if(hiddcar.length >0 && hiddcar != null){
				for (int i = 0; i < hiddcar.length; i++) {
					String id=hiddcar[i];
					if("addJT".equals(id)){
						String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
						BigDecimal big =new BigDecimal(qtFei);
						String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
						BigDecimal bigxf =new BigDecimal(chuangfei);
						BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
						BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
						String xcJtType=jttype[i] == null ? "" :jttype[i];
						String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
						String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
						CarAndShip carAndShip = new CarAndShip(String.valueOf(UUIDLong.longUUID()),String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
						geRenZhiFuXinXi.addcarAndship(carAndShip);	
					}else{
					String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
					BigDecimal big =new BigDecimal(qtFei);
					String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
					BigDecimal bigxf =new BigDecimal(chuangfei);
					BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
					BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
					String xcJtType=jttype[i] == null ? "" :jttype[i];
					String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
					String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
					CarAndShip carAndShip = new CarAndShip(hiddcar[i],String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
					geRenZhiFuXinXi.updateCarAndShip(carAndShip);
				}
					}
			}
			
			if(hiddzu.length >0 && hiddzu != null){
				for (int j = 0; j < hiddzu.length; j++) {
					String ids=hiddzu[j];
					if("addZS".equals(ids)){
						String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
						BigDecimal jiashui =new BigDecimal(jsJinE);
						
						String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
						
						BigDecimal jine =new BigDecimal(jdJine);
						String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
						BigDecimal shuie =new BigDecimal(shuiE);
						BigDecimal heji1 =new BigDecimal(heji);
						
						String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
						
						String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
								
						String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
						
						JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(String.valueOf(UUIDLong.longUUID()),String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
						geRenZhiFuXinXi.addzhusu(jiuDianFaPiao);
					}else{
					String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
					BigDecimal jiashui =new BigDecimal(jsJinE);
					
					String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
					
					BigDecimal jine =new BigDecimal(jdJine);
					String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
					BigDecimal shuie =new BigDecimal(shuiE);
					BigDecimal heji1 =new BigDecimal(heji);
					
					String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
					
					String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
							
					String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
					
					JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(hiddzu[j],String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
					geRenZhiFuXinXi.updateZhuSu(jiuDianFaPiao);
						}
					}	
			}
			if(!StringUtils.isEmpty(zonghidd)){
				BigDecimal zheji1 =new BigDecimal(zheji);
				geRenZhiFuXinXi.updateTongJi(zonghidd, pjnumber, zheji1, formrecid);
			}
			}
		    //String info = JSONUtils.objects2json("success", true,"addtongji",addtongji,"addcarAndship",addcarAndship,"addzhusu",addzhusu, "message", "数据获取成功!");
            //this.write(info, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
	}
	@NeedlessCheckLogin
	/**
	 * 分公司 非携程添加
	 * @param request
	 * @param response
	 */
	public void getFeiXieCheng(HttpServletRequest request, HttpServletResponse response){
		try {
			String[] jttype = request.getParameterValues("jttype");//交通工具类型
			String[] chechuangfei = request.getParameterValues("chechuangfei");//车船机票费
			String[] qitachaiLF = request.getParameterValues("qitachaiLF");//其他差旅费
			String[] feiyongleixing = request.getParameterValues("feiyongleixing");//费用类型
			String[] beizhu = request.getParameterValues("beizhu");//备注
			String chechuangzong=request.getParameter("chechuangzong") =="" ? "0"  :request.getParameter("chechuangzong");
			String qitachaizong=request.getParameter("qitachaizong") =="" ? "0" : request.getParameter("qitachaizong");
			String formrecid=request.getParameter("formrecid");
			
			String[] shifouzhuanpiao = request.getParameterValues("shifouzhuanpiao");//是否专票
			String[]  jiudianjiashui= request.getParameterValues("jiudianjiashui");//价税合计
			String[]  jiudianjine= request.getParameterValues("jiudianjine");//金额
			String[]  jiudianshuie= request.getParameterValues("jiudianshuie");//税额
			String[]  jiudianshuiL= request.getParameterValues("jiudianshuiL");//税率
			String[]  jiudianfapiaohao= request.getParameterValues("jiudianfapiaohao");//发票编号
			String heji=request.getParameter("xcxiaoji") =="" ? "0" :request.getParameter("xcxiaoji");//合计
			
			String pjnumber=request.getParameter("pjnumber") == "" ? "0" :request.getParameter("pjnumber"); //票据张数
			String zheji=request.getParameter("xcheji") == "" ? "0" :request.getParameter("xcheji");//总合计
			
			String[] snxuhao = request.getParameterValues("shiNeixuhao");
			String[] snBxtype = request.getParameterValues("shiNeiBaoXiao"); //报销方式
			String[] shifoupaiche = request.getParameterValues("shifouPaiChe1");//是否派车
			String[] snjine = request.getParameterValues("shiNeijine"); //室内金额
			String[] snbeizhu = request.getParameterValues("snbeizhu");//备注
			String snzong = request.getParameter("shineiheji");//总计
			
			String[] hiddcar = request.getParameterValues("hidd");
			String[] hiddzu = request.getParameterValues("hiddzu");
			String zonghidd = request.getParameter("zonghidd");
			String[] shiNeiJiaoTong = request.getParameterValues("snJtiD");//市内交通
			if(StringUtils.isEmpty(zonghidd)){
			BigDecimal zheji1 =new BigDecimal(zheji);
			int addtongji = geRenZhiFuXinXi.addFenGonSiTongji(pjnumber,zheji1,formrecid);
			int addcarAndship=0; //添加车船返回的状态
			int addzhusu=0;     // 添加住宿返回状态
			int tar=0;
			if(snBxtype.length > 0){
				for (int i = 0; i < snBxtype.length; i++) {//TrafficFeiXieCheng
					String snxuhaod= snxuhao[i] == "" ? "" : snxuhao[i];
					String snBxtyped=snBxtype[i]=="" ? "" : snBxtype[i];
					String shifoupaiched ="";
					if(shifoupaiche != null && shifoupaiche.length > 0){
						shifoupaiched = shifoupaiche[i].equals("null") ? "" :shifoupaiche[i];
					}
					
					String snjined =snjine[i]=="" ? "" : snjine[i];
					String snbeizhud=snbeizhu[i]=="" ? "" : snbeizhu[i];
					if(StringUtils.isEmpty(snzong)){
						snzong="0";
					}
					BigDecimal snzongj =new BigDecimal(snzong);
					TrafficFeiXieCheng tra = new TrafficFeiXieCheng(String.valueOf(UUIDLong.longUUID()),String.valueOf(i+1),snBxtyped,shifoupaiched,snjined,snbeizhud,formrecid,snzongj);
					tar=geRenZhiFuXinXi.addTraffic(tra);
				}
			}
			if(jttype.length>0){
			//CarAndShip carAndShip=null;
			for (int i = 0; i < jttype.length; i++) {
				String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
				BigDecimal big =new BigDecimal(qtFei);
				String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
				BigDecimal bigxf =new BigDecimal(chuangfei);
				BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
				BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
				String xcJtType=jttype[i] == null ? "" :jttype[i];
				String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
				String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
				CarAndShip carAndShip = new CarAndShip(String.valueOf(UUIDLong.longUUID()),String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
				addcarAndship = geRenZhiFuXinXi.addFenGonSiCarAndship(carAndShip);
				}
			}
			if(shifouzhuanpiao.length>0 ){
			for (int j = 0; j < shifouzhuanpiao.length; j++) {
				String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
				BigDecimal jiashui =new BigDecimal(jsJinE);
				
				String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
				
				BigDecimal jine =new BigDecimal(jdJine);
				String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
				BigDecimal shuie =new BigDecimal(shuiE);
				BigDecimal heji1 =new BigDecimal(heji);
				
				String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
				
				String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
						
				String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
				
				JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(String.valueOf(UUIDLong.longUUID()),String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
				addzhusu = geRenZhiFuXinXi.addFenGonSiZhusu(jiuDianFaPiao);
				}
			}
			System.out.println(jttype);
			}else{
			if(hiddcar != null && hiddcar.length >0){
				for (int i = 0; i < hiddcar.length; i++) {
					String id=hiddcar[i];
					if("addJT".equals(id)){
						String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
						BigDecimal big =new BigDecimal(qtFei);
						String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
						BigDecimal bigxf =new BigDecimal(chuangfei);
						BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
						BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
						String xcJtType=jttype[i] == null ? "" :jttype[i];
						String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
						String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
						CarAndShip carAndShip = new CarAndShip(String.valueOf(UUIDLong.longUUID()),String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
						geRenZhiFuXinXi.addFenGonSiCarAndship(carAndShip);	
					} else {
					String qtFei = qitachaiLF[i] =="" ? "0": qitachaiLF[i];
					BigDecimal big =new BigDecimal(qtFei);
					String chuangfei=chechuangfei[i] =="" ? "0" : chechuangfei[i];
					BigDecimal bigxf =new BigDecimal(chuangfei);
					BigDecimal chechuangzong1 =new BigDecimal(chechuangzong);
					BigDecimal qitachaizong1 =new BigDecimal(qitachaizong);
					String xcJtType=jttype[i] == null ? "" :jttype[i];
					String fyType=feiyongleixing[i] == "" ? "" :feiyongleixing[i];
					String xcBeiZhu=beizhu[i]=="" ? "" :beizhu[i];
					CarAndShip carAndShip = new CarAndShip(hiddcar[i],String.valueOf(i+1),xcJtType,bigxf,big,fyType,xcBeiZhu,chechuangzong1,qitachaizong1,formrecid);
					geRenZhiFuXinXi.updateFgsCarAndShip(carAndShip);
				}
					}
			}
			
			if(hiddzu != null && hiddzu.length >0){
				for (int j = 0; j < hiddzu.length; j++) {
					String zsid=hiddzu[j];
					if("addZS".equals(zsid)){
						String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
						BigDecimal jiashui =new BigDecimal(jsJinE);
						
						String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
						
						BigDecimal jine =new BigDecimal(jdJine);
						String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
						BigDecimal shuie =new BigDecimal(shuiE);
						BigDecimal heji1 =new BigDecimal(heji);
						
						String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
						
						String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
								
						String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
						
						JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(String.valueOf(UUIDLong.longUUID()),String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
						geRenZhiFuXinXi.addFenGonSiZhusu(jiuDianFaPiao);
					}else {
					String jsJinE=jiudianjiashui[j]=="" ? "0" :jiudianjiashui[j];
					BigDecimal jiashui =new BigDecimal(jsJinE);
					
					String jdJine=jiudianjine[j] =="" ? "0" :jiudianjine[j];
					
					BigDecimal jine =new BigDecimal(jdJine);
					String shuiE=jiudianshuie[j] =="" ? "0" :jiudianshuie[j];
					BigDecimal shuie =new BigDecimal(shuiE);
					BigDecimal heji1 =new BigDecimal(heji);
					
					String sfZhuanPiao=shifouzhuanpiao[j]=="" ? "" :shifouzhuanpiao[j];
					
					String jdShuiL=jiudianshuiL[j]== "" ? "" :jiudianshuiL[j];
							
					String jdFaPiaoHao=jiudianfapiaohao[j] =="" ? "" : jiudianfapiaohao[j];
					
					JiuDianFaPiao jiuDianFaPiao =new JiuDianFaPiao(hiddzu[j],String.valueOf(j+1),sfZhuanPiao,jiashui,jine,shuie,jdShuiL,jdFaPiaoHao,heji1,formrecid);
					geRenZhiFuXinXi.updateFgsZhuSu(jiuDianFaPiao);
					}
				}	
			}
			if(!StringUtils.isEmpty(zonghidd)){
				BigDecimal zheji2 =new BigDecimal(zheji);
				geRenZhiFuXinXi.updateFgsTongJi(zonghidd, pjnumber, zheji2, formrecid);
			}
			//updateNeiJiaoTong
			
			if(shiNeiJiaoTong != null && shiNeiJiaoTong.length > 0){
				for (int j = 0; j < shiNeiJiaoTong.length; j++) {
					String tarId = shiNeiJiaoTong[j];
					if("addTAR".equals(tarId)){
						String snxuhaod= snxuhao[j] == "" ? "" : snxuhao[j];
						String snBxtyped=snBxtype[j]=="" ? "" : snBxtype[j];
						String shifoupaiched ="";
						if(shifoupaiche != null && shifoupaiche.length > 0){
							shifoupaiched = shifoupaiche[j].equals("null") ? "" :shifoupaiche[j];
							
						}
						String snjined =snjine[j]=="" ? "" : snjine[j];
						String snbeizhud=snbeizhu[j]=="" ? "" : snbeizhu[j];
						if(StringUtils.isEmpty(snzong)){
							snzong="0";
						}
						BigDecimal snzongj =new BigDecimal(snzong);
						TrafficFeiXieCheng tra = new TrafficFeiXieCheng(String.valueOf(UUIDLong.longUUID()),String.valueOf(j+1),snBxtyped,shifoupaiched,snjined,snbeizhud,formrecid,snzongj);
						geRenZhiFuXinXi.addTraffic(tra);
					}else{
					BigDecimal snzongj =new BigDecimal(snzong);
					String shifoupaiched ="";
					if(shifoupaiche != null && shifoupaiche.length > 0){
						shifoupaiched = shifoupaiche[j].equals("null") ? "" :shifoupaiche[j];
						
					}
					TrafficFeiXieCheng tra =new TrafficFeiXieCheng(shiNeiJiaoTong[j],String.valueOf(j+1),snBxtype[j],shifoupaiched,snjine[j],snbeizhu[j],formrecid,snzongj);
					geRenZhiFuXinXi.updateNeiJiaoTong(tra);
					}
				}
			}
			}
			
		   // String info = JSONUtils.objects2json("success", true,"addtongji",addtongji,"addcarAndship",addcarAndship,"addzhusu",addzhusu, "message", "数据获取成功!");
           // this.write(info, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
		
	}
	public ModelAndView getShouyiBuMen(HttpServletRequest request, HttpServletResponse response){
		ModelAndView mav = new ModelAndView("kdXdtzXc/xiecheng/shouYiBuMen");
		List<Map<String, Object>> shouYiBuMen = geRenZhiFuXinXi.getShouYiBuMen();
		mav.addObject("shouYiBuMen", shouYiBuMen);
		return mav;
	}
	
	public void deletezbCheChuan(HttpServletRequest request, HttpServletResponse response){
		try {
			String id = request.getParameter("cheDeleteId");
			int deleteZBcarAndship = geRenZhiFuXinXi.deleteZBcarAndship(id);
			String info = JSONUtils.objects2json("success", true,"deleteZBcarAndship",deleteZBcarAndship,"message", "删除成功!");
	         this.write(info, response);
		} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
			e.printStackTrace();
		}
	}
	
	public void deleteZbZhuSu(HttpServletRequest request, HttpServletResponse response){
		try {
			String id = request.getParameter("zsdeleteId");
			int deleteZBzhusu = geRenZhiFuXinXi.deleteZBzhusu(id);
			String info = JSONUtils.objects2json("success", true,"deleteZBzhusu",deleteZBzhusu,"message", "删除成功!");
	         this.write(info, response);
		} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
			e.printStackTrace();
		}
	}
	
	
	public void deleteFgsCheChuan(HttpServletRequest request, HttpServletResponse response){
		try {
			String id = request.getParameter("cheDeleteId");
			int deleteFgsCarAndship = geRenZhiFuXinXi.deleteFgsCarAndship(id);
			String info = JSONUtils.objects2json("success", true,"deleteFgsCarAndship",deleteFgsCarAndship,"message", "删除成功!");
	         this.write(info, response);
		} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
			e.printStackTrace();
		}
	}
	
	public void deleteFgszhusu(HttpServletRequest request, HttpServletResponse response){
		try {
			String id = request.getParameter("zsdeleteId");
			int deleteFgsZhusu = geRenZhiFuXinXi.deleteFgsZhusu(id);
			String info = JSONUtils.objects2json("success", true,"deleteFgsZhusu",deleteFgsZhusu,"message", "删除成功!");
	         this.write(info, response);
		} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
			e.printStackTrace();
		}
	}
	
	public void deleteFgsShiNei(HttpServletRequest request, HttpServletResponse response){
		try {
			String id = request.getParameter("sndeleteId");
			int deleteFgsTraffic = geRenZhiFuXinXi.deleteFgsTraffic(id);
			String info = JSONUtils.objects2json("success", true,"deleteFgsTraffic",deleteFgsTraffic,"message", "删除成功!");
	         this.write(info, response);
		} catch (Exception e) {
				this.write(JSONUtilsExt.objects2json("success", false, "message1", "失败"), response);
			e.printStackTrace();
		}
	}
	protected void write(String str, HttpServletResponse response){
	        try {
				response.setContentType("text/html;charset=UTF-8");
				response.getWriter().write(str);
				response.getWriter().flush();
				response.getWriter().close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	    }
}
