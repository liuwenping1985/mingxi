package cn.com.cinda.taskcenter.common;

import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.remoting.caucho.HessianProxyFactoryBean;

/*import cn.com.hkgt.bean.OptionVO;
import cn.com.hkgt.um.interfaces.exports.ExportService;
import cn.com.hkgt.util.UmServiceUrlUtil;

import com.caucho.hessian.client.HessianProxyFactory;*/

public class DeptBean {

	private Logger log = Logger.getLogger(this.getClass());

	private static final SimpleDateFormat FORMAT = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");

	private static String configPath = TaskInfor.CONFIG_FILE_PATH;

	// Hessian服务的url
	public static String userManagerServiceUrl = null;

/*	private ExportService exportService;*/

	public DeptBean() {/*
		try {
			// Hessian服务的url
			if (userManagerServiceUrl == null) {
				Properties initVars = new Properties();
				FileInputStream fis = new FileInputStream(configPath);
				initVars.load(fis);
//				userManagerServiceUrl = initVars
//						.getProperty("usermanager.provider.url");
				userManagerServiceUrl = UmServiceUrlUtil.getUmServiceUrl("usermanager.provider.url.3");
			}

			// 创建HessianProxyFactory实例
			HessianProxyFactoryBean factory = new HessianProxyFactoryBean();

			// 获得Hessian服务的远程引用
			exportService = (HessianProxyFactoryBean) factory.create(HessianProxyFactoryBean.class,
					userManagerServiceUrl);

			// System.out.println("init usermanager interface successful.");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	*/}

/*	public ExportService getUserInterface() {
		return exportService;
	}*/

	/**
	 * 通过用户管理接口，获得机构列表
	 * 
	 * @return
	 */
	public List getOrganizationList() {
		return null;/*
		List ret = new ArrayList();
		List list = exportService.getOrganizationList();
		for (Iterator iter = list.iterator(); iter.hasNext();) {
			OptionVO element = (OptionVO) iter.next();
			ret.add(element.getKey() + "=" + element.getValue());
		}
		return ret;
	*/}

	/**
	 * 根据部门编码获得部门中所有用户id和名称
	 * 
	 * @param deptCode
	 *            部门编码
	 * @return
	 */
	public List getUserListByOrganCode(String deptCode) {
		return null;/*
		List ret = new ArrayList();
		List list = exportService.getUserListByOrganCode(deptCode);
		for (Iterator iter = list.iterator(); iter.hasNext();) {
			OptionVO element = (OptionVO) iter.next();
			ret.add(element.getKey() + "=" + element.getValue());
		}
		return ret;
	*/}
}