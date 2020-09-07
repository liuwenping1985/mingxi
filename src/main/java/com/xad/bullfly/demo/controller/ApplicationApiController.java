package com.xad.bullfly.demo.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liuwenping on 2020/8/12.
 */
@RestController
@RequestMapping("/app/api/v0.1")
public class ApplicationApiController {


    @RequestMapping("/say")
    public String sayHi() {

        return "hi  young blood!";

    }

    @RequestMapping("/test/stream")
    public String index() throws Exception {
        return "guanggun";

    }






}
