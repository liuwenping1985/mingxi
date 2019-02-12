package com.seeyon.apps.kdXdtzXc.base.util;



import com.seeyon.apps.kdXdtzXc.base.fifo.FIFO;
import com.seeyon.apps.kdXdtzXc.base.fifo.FIFOImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


/**
 * Created by taoanping on 15/5/24.
 */
public class RandUtil {
    private static Long feed = System.currentTimeMillis();
    private static Long feed1 = System.currentTimeMillis();
    private static FIFO<Integer> fifo = new FIFOImpl<Integer>(200);
    private static FIFO<Integer> fifo1 = new FIFOImpl<Integer>(200);

    public synchronized static Long getFeed() {
        return feed++;
    }

    public synchronized static Long getFeed1() {
        return feed1 = feed1 + 2;
    }

    /**
     * 保障200个队列内的数字不重复
     *
     * @return
     */
    public synchronized static Integer getGroupId() {
        Long l = System.currentTimeMillis();
        Integer groupid = new Random(getFeed()).nextInt(100000);
        if (fifo.contains(groupid)) {
            return getGroupId();
        } else {
            fifo.addLastSafe(groupid);
            return groupid;
        }
    }


    /**
     * 保障200个队列内的数字不重复
     *
     * @return
     */
    public synchronized static Integer getInterfaceRunId() {
        Long l = System.currentTimeMillis();
        Integer interfaceRunId = new Random(getFeed1()).nextInt(100000);
        if (fifo1.contains(interfaceRunId)) {
            return getInterfaceRunId();
        } else {
            fifo1.addLastSafe(interfaceRunId);
            return interfaceRunId;
        }
    }


    public static void main(String[] args) {
        List<Integer> list1 = new ArrayList<Integer>();
        List<Integer> list2 = new ArrayList<Integer>();
        for (int i = 0; i < 200; i++) {
            Integer l1 = RandUtil.getGroupId();
            Integer l2 = RandUtil.getInterfaceRunId();
            if (list1.contains(l1)) {
                System.out.println(i + "=l1=" + l1);
            }
            if (list2.contains(l2)) {
                System.out.println(i + "=l2=" + l2);
            }
            list1.add(l1);
            list2.add(l2);

        }
    }
}
