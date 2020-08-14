package com.xad.weboffice.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liuwenping on 2020/8/12.
 */
@RestController
@RequestMapping("/main/rest")
public class MainController {


    @RequestMapping("/sayHi")
    public String sayHi() {

        return "hi young blood!";

    }

    @RequestMapping("/test/stream")
    public String index() throws Exception {
        return "guanggun";

    }


}
