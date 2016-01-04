
# JDBC 驱动



## 安装

### 使用独立的 JAR 包

从 [Github Release 页面](https://github.com/aliyun/aliyun-odps-jdbc/releases) 下载最新版的 `odps-jdbc-x.y-jar-with-dependencies.jar` 将其添加到你的项目中。

### 通过 Maven 主仓管理依赖 

```
<dependency>
  <groupId>com.aliyun.odps</groupId>
  <artifactId>odps-jdbc</artifactId>
  <version>x.y</version>
</dependency>
```


## 配置和使用


1\. 显式调用 `Class.forName()` 加载 JDBC 驱动:

    Class.forName("com.aliyun.odps.jdbc.OdpsDriver");


2\. 创建 `Connection` 对象连接 ODPS:


    Connection conn = DriverManager.getConnection(url, accessId, accessKey);

ODPS 服务使用了 HTTP 的协议连接，所以一个有效的 JDBC 连接串看起来像这样:

    String url = "jdbc:odps:ENDPOINT?project=PROJECT_NAME&charset=UTF-8"

连接信息还可以通过传递 `Properties` 参数来完成，例如：

    Properties config = new Properties();
    config.put("access_id", "...");
    config.put("access_key", "...");
    config.put("project_name", "...");
    config.put("charset", "...");
    Connection conn = DriverManager.getConnection("jdbc:odps:<endpoint>", config);


3\. 通过创建 `Statement` 对象来提交 SQL，使用 `executeQuery()` 方法:

    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT foo FROM bar");

4\. 开始处理 JDBC 结果集。例如：

    while (rs.next()) {
        ...
    }


### 连接字符串

|  URL 参数名  | Prop 参数名 |                         描述                         |
|:---------:|:------------:|:-----------------------------------------------------------|
|  `endpoint` |   `end_point`  | ODPS endpoint                            |
|  `project`  | `project_name` | 使用 ODPS 项目                                    |
|  `accessId` |   `access_id`  | 访问 id                          |
| `accessKey` |  `access_key`  | 认证秘钥                                      |
|  `logview`  | `logview_host` | logview 的域名 |
| `lifecycle` |   `lifecycle`  | 临时表的生命周期              |
|  `charset`  |    `charset`   | 字符串的字符集                                  |
|  `loglevel` |   `log_level`  | JDBC 驱动的调试级别 debug/info/fatal             |

## 程序示例

### JDBC 客户端代码

    import java.sql.SQLException;
    import java.sql.Connection;
    import java.sql.ResultSet;
    import java.sql.Statement;
    import java.sql.DriverManager;

    public class OdpsJdbcClient {
      private static String driverName = "com.aliyun.odps.jdbc.OdpsDriver";

      /**
       * @param args
       * @throws SQLException
       */
      public static void main(String[] args) throws SQLException {
        try {
          Class.forName(driverName);
        } catch (ClassNotFoundException e) {
          e.printStackTrace();
          System.exit(1);
        }

        // fill in the information here
        String accessId = "your_access_id";
        String accessKey = "your_access_key";
        Connection conn = DriverManager.getConnection("jdbc:odps:https://service.odps.aliyun.com/api?project=<your_project_name>", accessId, accessKey);
        Statement stmt = conn.createStatement();
        String tableName = "testOdpsDriverTable";
        stmt.execute("drop table if exists " + tableName);
        stmt.execute("create table " + tableName + " (key int, value string)");

        String sql;
        ResultSet rs;

        // insert a record
        sql = String.format("insert into table %s select 24 key, 'hours' value from (select count(1) from %s) a", tableName, tableName);
        System.out.println("Running: " + sql);
        int count = stmt.executeUpdate(sql);
        System.out.println("updated records: " + count);

        // select * query
        sql = "select * from " + tableName;
        System.out.println("Running: " + sql);
        rs = stmt.executeQuery(sql);
        while (rs.next()) {
          System.out.println(String.valueOf(rs.getInt(1)) + "\t" + rs.getString(2));
        }

        // regular query
        sql = "select count(1) from " + tableName;
        System.out.println("Running: " + sql);
        rs = stmt.executeQuery(sql);
        while (rs.next()) {
          System.out.println(rs.getString(1));
        }

        // do not forget to close
        stmt.close();
        conn.close();
      }
    }

### 编译运行客户端

    # compile the client code
    javac OdpsJdbcClient.java

    # run the program with specifying the class path
    java -cp odps-jdbc-*-with-dependencies.jar:. OdpsJdbcClient



## Github

该项目已开源，更多信息请访问  [Github](https://github.com/aliyun/aliyun-odps-jdbc).


