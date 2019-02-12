package cn.com.cinda.taskcenter.common;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

/**
 * 菜单树显示
 */
public class MenuBean {
	//
	private Logger log = Logger.getLogger(this.getClass());

	private static String sysName = "任务中心";

	public MenuBean() {
	}

	/**
	 * 根据链接路径获得菜单树
	 * 
	 * @param linkPath
	 * @return
	 */
	public TreeView getMenu(String linkPath) {
		ArrayList treeNodes = new ArrayList();

		TreeViewNode tvn = new TreeViewNode();
		// 一级菜单
		tvn.setTreeCode("0001");
		tvn.setMenuName("总公司");
		tvn.setLinkPath(null);
		treeNodes.add(tvn);

		// 获得部门列表
		DeptBean bean = new DeptBean();
		List list = bean.getOrganizationList();

		// 总公司部门
		for (Iterator iter = list.iterator(); iter.hasNext();) {
			String element = (String) iter.next();

			// 二级菜单
			tvn = new TreeViewNode();
			String deptCode = element.split("=")[0];
			String menuName = element.split("=")[1];

			if (!deptCode.startsWith("01")) { // 过虑掉办事处的
				continue;
			}

			// 设置节点和名称
			tvn.setTreeCode("00010001");
			tvn.setMenuName(menuName);
			tvn.setLinkPath(linkPath + "&deptCode=" + deptCode);
			treeNodes.add(tvn);
		}

		// 一级菜单
		tvn.setTreeCode("0002");
		tvn.setMenuName("办事处");
		tvn.setLinkPath(null);
		treeNodes.add(tvn);

		// 办事处部门
		for (Iterator iter = list.iterator(); iter.hasNext();) {
			String element = (String) iter.next();

			// 二级菜单
			tvn = new TreeViewNode();
			String deptCode = element.split("=")[0];
			String menuName = element.split("=")[1];

			if (deptCode.startsWith("01")) { // 过虑掉总公司的
				continue;
			}

			// 设置节点和名称
			tvn.setTreeCode("00020001");
			tvn.setMenuName(menuName);
			tvn.setLinkPath(linkPath + "&deptCode=" + deptCode);
			treeNodes.add(tvn);
		}

		// 让父节点的连接为null
//		int len = treeNodes.size();
//		String lastpath = "first";
//		for (int i = len - 1; i >= 0; i--) {
//			TreeViewNode el = (TreeViewNode) treeNodes.get(i);
//			String temp = el.getTreeCode();
//			if (lastpath.startsWith(temp)) {
//				el.setLinkPath(null);
//			}
//
//			lastpath = temp;
//		}

		TreeView tv = new TreeView();
		tv.setTreeNodes(treeNodes);
		tv.setMid("2");
		tv.setRootName(sysName);
		tv.setRootLink("");
		tv.setDataSource("");

		return tv;
	}

	// 反向排序
	private static LinkedHashSet reverse(LinkedHashSet restartList) {
		ArrayList reverseRestartList = new ArrayList(restartList);
		Collections.reverse(reverseRestartList);
		restartList = new LinkedHashSet(reverseRestartList);
		return restartList;
	}

	// 反向排序
	private static LinkedHashMap reverse(LinkedHashMap map) {
		ArrayList reverseEntrySet = new ArrayList(map.entrySet());
		Collections.reverse(reverseEntrySet);

		map = new LinkedHashMap(reverseEntrySet.size());
		for (Iterator iterator = reverseEntrySet.iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			Object key = entry.getKey();
			Object value = entry.getValue();
			map.put(key, value);
		}
		return map;
	}

}
