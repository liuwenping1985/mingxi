package com.seeyon.apps.ztask.service;

import com.seeyon.apps.ztask.po.Task;

import java.util.List;

/**
 * Created by liuwenping on 2019/1/18.
 */
public interface TaskService {

    Task getUserTaskList(Long memberId);

    List<Task> createUserTask(Long memberId);
}
