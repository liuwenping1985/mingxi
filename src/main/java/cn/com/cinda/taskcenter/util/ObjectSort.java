package cn.com.cinda.taskcenter.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import cn.com.cinda.taskcenter.model.Task;

public class ObjectSort implements Comparator {

	/**
	 * 对象比较方法，调用示例：Collections.sort(voList, new ObjectSort());
	 * 
	 * @param obj1
	 *            第一个用于比较的对象
	 * @param obj2
	 *            第二个用于比较的对象
	 * @return 比较结果 (1表示a > b; 0表示a = b; -1表示a < b)
	 */
	public int compare(Object obj1, Object obj2) {
		int iRet = 0;

		try {
			if ("cn.com.cinda.taskcenter.model.Task".equals(obj1.getClass()
					.getName())) {
				Task t1 = (Task) obj1;
				Task t2 = (Task) obj2;

				if (t1.getTask_assignee_time().compareTo(
						t2.getTask_assignee_time()) == 0) {
					// 二者相同的情况
					iRet = t1.getTask_subject().compareTo(t2.getTask_subject());
				} else {
					iRet = t2.getTask_assignee_time().compareTo(
							t1.getTask_assignee_time());
				}
			} else {
				iRet = -2; // 二者都不符合，异常情况
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return iRet;
	}

	public static void main(String[] args) {
		List allList = new ArrayList();

		Task task = new Task();
		task.setTask_assignee_time("2008-12-02 07:50:58");
		allList.add(task);
		task = new Task();
		task.setTask_assignee_time("2008-03-02 07:50:58");
		allList.add(task);
		task = new Task();
		task.setTask_assignee_time("2010-03-02 07:50:58");
		allList.add(task);

		Collections.sort(allList, new ObjectSort());

		for (Iterator iterator = allList.iterator(); iterator.hasNext();) {
			Task object = (Task) iterator.next();
			System.out.println(object.getTask_assignee_time());
		}

		System.out.println("ab".compareTo("cd"));
	}

}
