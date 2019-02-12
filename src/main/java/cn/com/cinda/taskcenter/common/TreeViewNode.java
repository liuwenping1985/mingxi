package cn.com.cinda.taskcenter.common;

/**
 * 菜单树显示
 * 
 * @author
 */

public class TreeViewNode {

	/**
	 * 构造函数
	 * 
	 * @param id
	 *            节点id
	 * @param type
	 *            节点类型编码，用3位数字，决定显示的图标类型
	 * @param name
	 *            节点名称
	 * @param desc
	 *            节点描述
	 * @param link
	 *            节点链接
	 * @param treeCode
	 *            节点编码
	 * @param target
	 *            显示目标窗体 //0=basefrm 1=_blank
	 */

	// private String name;
	// private String desc;
	// private String id;
	// private String link;
	private String target; // 0=basefrm 1=_blank

	private String treeCode;

	private String type;

	private String area;// 适用范围

	private String menuName;// 菜单名称

	private String linkPath;// 连接地址

	private String status1;// 状态1

	private String status2;// 状态2

	private String remark;// 备注

	public String getArea() {
		return area;
	}

	public String getLinkPath() {
		return linkPath;
	}

	public String getMenuName() {
		return menuName;
	}

	public String getRemark() {
		return remark;
	}

	public String getStatus1() {
		return status1;
	}

	public String getStatus2() {
		return status2;
	}

	public String getTreeCode() {
		return treeCode;
	}

	public String getType() {
		return type;
	}

	public String getTarget() {
		return target;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public void setLinkPath(String linkPath) {
		this.linkPath = linkPath;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public void setStatus1(String status1) {
		this.status1 = status1;
	}

	public void setStatus2(String status2) {
		this.status2 = status2;
	}

	public void setTreeCode(String treeCode) {
		this.treeCode = treeCode;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setTarget(String target) {
		this.target = target;
	}

}
