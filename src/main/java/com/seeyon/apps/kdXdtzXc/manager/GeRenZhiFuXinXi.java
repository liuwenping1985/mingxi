package com.seeyon.apps.kdXdtzXc.manager;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.seeyon.apps.kdXdtzXc.po.CarAndShip;
import com.seeyon.apps.kdXdtzXc.po.JiuDianFaPiao;
import com.seeyon.apps.kdXdtzXc.po.TrafficFeiXieCheng;
import com.seeyon.apps.kdXdtzXc.po.XieChengVipJiuDianPo;
import com.seeyon.apps.kdXdtzXc.po.XieChengXieYiJiuDiangPo;

public interface GeRenZhiFuXinXi {
	//总公司添加车船机票
	public int addcarAndship(CarAndShip carAndShip);
	//总公司添加酒店
	public int addzhusu(JiuDianFaPiao jiuDianFaPiao);
	//总公司添加总价
	public int addtongji(String pjnumber,BigDecimal zheji,String formid);
    //添加信息确认
    public void insertXinXiQR(Long id,Long formmain_id,Integer sort,Integer xuhao,Long chuchairen,String url);
    //总公司获取非携程的数据
    public List<Map<String, Object>> getFeiXcXmlTou();
    //总公司 车船
    public String getCheChuan(String biaodanhao);
    //总公司住宿
    public String getZhusu(String biaodanhao);
  //总公司车船机票
    public List<Map<String, Object>> queryCarAndShip(String danhaoid);
  //总公司酒店
    public List<Map<String, Object>> queryZhuSu(String danhaoid);
  //总公司总价
    public List<Map<String, Object>> queryTongJi(String danhaoid);
    //分公司添加市内交通费信息
    public int addTraffic(TrafficFeiXieCheng tar);
    //分公司市内交通费信息
    public String getShiNeiJiaoTong(String daohao);
    
  //分公司市内交通
    public List<Map<String, Object>> queryShiNeiJiaoTong(String danhaoid);
    
	//分公司 住宿
  	public List<Map<String, Object>> getFenGongSiZhusuDh(String biaodanhao);
  	//分公司 车船
  	public List<Map<String, Object>> getFenGonSiCheChuanDh(String biaodanhao);
    
  //分公司市内交通更新
    public void updateNeiJiaoTong(TrafficFeiXieCheng traffic);
    
    //分公司添加车船机票
  	public int addFenGonSiCarAndship(CarAndShip carAndShip);
  	//分公司添加酒店
  	public int addFenGonSiZhusu(JiuDianFaPiao jiuDianFaPiao);
  	//分公司添加总价
  	public int addFenGonSiTongji(String pjnumber,BigDecimal zheji,String formid);
  	//分公司 住宿
  	public String getFenGongSiZhusuXml(String biaodanhao);
  	//分公司 车船
  	public String getFenGonSiCheChuan(String biaodanhao);
  	//分公司xml头部
  	public List<Map<String, Object>> getFenGonSiFeiXcXmlTou();
  	//更新车船数据
  	public void updateCarAndShip(CarAndShip carAndShip);
  	//更新酒店
  	public void updateZhuSu(JiuDianFaPiao jiuDianFaPiao);
  	//更新总计
  	public void updateTongJi(String id,String pjnumber,BigDecimal zheji,String formid);
  	//分公司 数据合计 单号
  	public List<Map<String, Object>> getFenGonSiShuHuHj(String biaodanhao);

  	public List<Map<String, Object>> getShouYiBuMen();
  	//更新总计分公司
  	public void updateFgsTongJi(String id,String pjnumber, BigDecimal zheji, String formid);
  	//更新住宿分公司
  	public void updateFgsZhuSu(JiuDianFaPiao jiuDianFaPiao);
  	//更新车船机票
  	public void updateFgsCarAndShip(CarAndShip carAndShip);
  	
  	public int deleteZBcarAndship(String id);
  	public int deleteZBzhusu(String id);
  	
  	public int deleteFgsCarAndship(String id);
  	public int deleteFgsZhusu(String id);
  	public int deleteFgsTraffic(String id);
}
