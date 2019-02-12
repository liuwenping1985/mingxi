package cn.com.cinda.taskcenter.common;

import java.io.Serializable;

/**
 * 分页信息
 * 
 * @author
 * 
 */
public class CommonPara implements Serializable {
	public CommonPara() {
	}

	public int iPageCountUse; // 每页显示的条数

	public int iCurPageNo; // 当前页码

	public int iTotalRow; // 总条数

	public int iTotalPage; // 总页数

}
