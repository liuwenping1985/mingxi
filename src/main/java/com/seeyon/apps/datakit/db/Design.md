##1、base
#####1、JDBC基础功能
#####2、增删改查CRUD
#####3、后续跟hibernate或者mybatis集成
#####4、DB-CONSOLE



##2、基础工具
#####1、实现在线数据库查询
#####2、基本的增加删除和修改
#####3、多数据源问题


##3、插件基础框架v0.1( end of 9.25) 

####目标

* 1、spring boot include（platform,mvc(core)，security(core),data(core),batch,web flow,session(core)）

<pre>dao层能切换数据源 - covered分布式数据源,要orm还是重复轮子一波（参考源码，提升一些细节的思考）? 
      ORM效率 还是 native 方便？--or 框架？==》h和m 整合一波，摒弃一些用不到的</pre>

* 2、身份认证，请求拦截，预处理，异常处理，将文件预处理

<pre>摒弃一些用不到的,A8接口重构到 app层- 减少耦合</pre>

* 3、mvc restful（抽象好资源，不然就是zz，security继承好-include ldap）

* 4、前端呈现 react 基础模块加入 实现（DB-CONSOLE，form编辑，基本流转navigator）（移动端 react-native）

* 5、bpmn工作流集成 --using activity

* 6、vue study-- part3

* 7、ws和api提供，mid table方式先完成