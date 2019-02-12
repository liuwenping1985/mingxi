package com.seeyon.apps.kdXdtzXc.base.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by taoan on 2016-7-27.
 */
public class TableList {
    private static List<Table> list = new ArrayList<Table>();

    public static  void add(Table table) {
        list.add(table);
    }

}
