package com.xad.bullfly.demo.controller;

import com.alibaba.fastjson.JSON;
import com.xad.bullfly.annotaion.AdminPermission;
import com.xad.bullfly.web.common.vo.WebJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/8/12.
 */
@RestController
@RequestMapping("/admin/api/v0.1")
public class AdminApiController {

    @Autowired
    @Qualifier("primaryJdbcTemplate")
    private JdbcTemplate primaryTemplate;

    @Autowired
    @Qualifier("secondaryJdbcTemplate")
    private JdbcTemplate secondaryTemplate;

    @RequestMapping("/say")
    public String sayHello() {


        return "hi young blood! I am admin";

    }

    @RequestMapping("/index")
    public WebJsonResponse index() throws Exception {

        List<Map<String, Object>> resultList = secondaryTemplate.queryForList("SELECT * FROM ORG_MEMBER");
        for(Map data:resultList){
            System.out.println(JSON.toJSONString(data));
        }


        return WebJsonResponse.successWithItems(resultList);

    }


}
