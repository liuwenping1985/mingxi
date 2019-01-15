package com.seeyon.apps.menhu.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by liuwenping on 2019/1/15.
 */
public class ProjectDataVo {

    private String name="";

    private String id;

    private String code="";

    private List<ProjectUserDataVo> userList = new ArrayList<ProjectUserDataVo>();


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public List<ProjectUserDataVo> getUserList() {
        return userList;
    }

    public void setUserList(List<ProjectUserDataVo> userList) {
        this.userList = userList;
    }
}
