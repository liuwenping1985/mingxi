package cn.com.cinda.taskcenter.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;

import cn.com.cinda.taskcenter.common.ConnectionPool;

public class LinkHelper {

	private static HashMap linkMap = null;

	public static HashMap getLinkTypeMap() {
		if (linkMap == null) {
			System.out.println("开始初始化任务中心链接配置...");
			init();
			System.out.println("初始化任务中心链接ok.");
			System.out.println("linkMap.size()=" + linkMap.size());
		}
		return linkMap;
	}

	private static void init() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			con = ConnectionPool.getConnection();
			pstmt = con.prepareStatement("select * from cinda_task.TASK_LINK_TYPE");
			rs = pstmt.executeQuery();

			linkMap = new HashMap();
			while (rs.next()) {
				String appSrc = rs.getString("task_linkType_code");
				String state = rs.getString("TASK_LINK_STATUS");
				String link = rs.getString("task_link_format");

				linkMap.put(appSrc + "," + state, link);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			ConnectionPool.release(rs, null, pstmt, con);
		}
	}

}
