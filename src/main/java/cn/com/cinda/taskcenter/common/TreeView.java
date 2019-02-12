package cn.com.cinda.taskcenter.common;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Properties;

public class TreeView implements Serializable {
	private String mid;

	private String rootName;

	private String rootLink = "";

	private String htmlStr;

	private ArrayList treeNodes;

	private String htmlStrNode;

	private String clickNode = "";

	private String dataSource;

	private Properties whereStr;

	private String type = "";

	private String htmlStrClickNode;

	public TreeView() {
		treeNodes = new ArrayList();
	}

	/**
	 * 将信息写入htmlstr
	 * 
	 * @return
	 */
	private void writeHtmlStr() {
		try {
			htmlStr = "";
			htmlStr += "foldersTree = gFld(\"0\",\"" + rootName + "\", \""
					+ rootLink + "\");\n";

			TreeViewNode node = null;
			String treeCode = "", fCode = "";
			int rCodeLen = 0;
			int target = 3;
			for (int i = 0; i < treeNodes.size(); i++) {
				node = (TreeViewNode) treeNodes.get(i);
				treeCode = node.getTreeCode();
				if (treeCode == null)
					treeCode = "";

				if (i == 0) {

					rCodeLen = treeCode.length();
				}

				if (treeCode.length() == rCodeLen) {
					fCode = "foldersTree";
				} else {
					fCode = "A" + treeCode.substring(0, treeCode.length() - 4);
				}

				// if (node.getLink().equals("")) {

				if (node.getLinkPath() == null
						|| "".equals(node.getLinkPath().trim())) {
					node.setLinkPath("");
				}

				htmlStr += "A" + node.getTreeCode() + "=insFld(" + fCode
						+ ", gFld(\"" + target + "\",\"" + node.getMenuName()
						+ "\", \"" + node.getLinkPath() + "\"));\n";
				// System.out.println("target="+target);
				// System.out.println("menuName="+node.getMenuName());
				// System.out.println("linkPath="+node.getLinkPath());
				// if (!node.getType().equals("000")) {
				// htmlStr += "A" + node.getTreeCode() +
				// ".iconSrc = \"../image/tn" + node.getType() +
				// ".gif\";\n";
				// htmlStr += "A" + node.getTreeCode() +
				// ".iconSrcClosed = \"../image/tnc" +
				// node.getType() +
				// ".gif\";\n";
				// }

			}

			htmlStrNode = "";
			for (int i = rCodeLen; i <= clickNode.length() && i != 0; i = i + 4) {
				htmlStrNode += "clickOnNode(A" + clickNode.substring(0, i)
						+ ".id);\n";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {

	}

	/**
	 * 得到HTML
	 * 
	 * @return
	 */
	public String getHtmlStr() {
		writeHtmlStr();
		return htmlStr;
	}

	/**
	 * 得到点击事件的HTML
	 * 
	 * @return
	 */
	public String getHtmlStrClickNode() {
		return htmlStrNode;
	}

	public String getClickNode() {
		return clickNode;
	}

	public void setClickNode(String clickNode) {
		this.clickNode = clickNode;
	}

	public String getHtmlStrNode() {
		return htmlStrNode;
	}

	public String getRootLink() {
		return rootLink;
	}

	public String getRootName() {
		return rootName;
	}

	public ArrayList getTreeNodes() {
		return treeNodes;
	}

	public void setTreeNodes(ArrayList treeNodes) {
		this.treeNodes = treeNodes;
	}

	public void setRootName(String rootName) {
		this.rootName = rootName;
	}

	public void setRootLink(String rootLink) {
		this.rootLink = rootLink;
	}

	public void setHtmlStrNode(String htmlStrNode) {
		this.htmlStrNode = htmlStrNode;
	}

	public void setHtmlStr(String htmlStr) {
		this.htmlStr = htmlStr;
	}

	public String getMid() {
		return mid;
	}

	public void setMid(String mid) {
		this.mid = mid;
	}

	public String getDataSource() {
		return dataSource;
	}

	public void setDataSource(String dataSource) {
		this.dataSource = dataSource;
	}

	public Properties getWhereStr() {
		return whereStr;
	}

	public void setWhereStr(Properties whereStr) {
		this.whereStr = whereStr;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public void setHtmlStrClickNode(String htmlStrClickNode) {
		this.htmlStrClickNode = htmlStrClickNode;
	}

}
