# https://learn.hashicorp.com/tutorials/consul/load-balancing-nginx
# https://github.com/hashicorp/hcl
# https://www.convertsimple.com/convert-hcl-to-json/

nacos {
  clientConfig {
    NamespaceId = "f3c0ab89-31bb-4414-a495-146941316751"
    TimeoutMs = 5000
    NotLoadCacheAtStart = true
    LogDir = "/tmp/nacos/log"
    CacheDir = "/tmp/nacos/cache"
    RotateTime = "1h"
    MaxAge = 3
    LogLevel = "debug"
  }

  serverConfigs = [
    {
      Scheme = "http"
      IpAddr = "127.0.0.1"
      Port = 8848
      ContextPath = "/nacos"
    },
    {
      Scheme = "http"
      IpAddr = "127.0.0.1"
      Port = 8849
      ContextPath = "/nacos"
    }
  ]

  serviceParam {
    ServiceName = "demogo",
    Clusters = [
      "clustera"]
    // default value is DEFAULT
    GroupName = "groupa"
    // default value is DEFAULT_GROUP
  }
}

mysql {
  dataSourceName = "user:pass@tcp(127.0.0.1:3306)/db1?charset=utf8"
  dataKey = "upstreams"
  dataSql = "select name,keepalive,ip_hash ipHash,resolver,'{{servers}}' servers from t_upstreams where state='1'"
  sqls {
    servers = "select address,port,weight,max_conns maxConns,max_fails maxFails,fail_timeout failTimeout,backup,down,slow_start slowStart from t_servers where upstream_name='{{.name}}' and state='1'"
  }

  kvSql = "select value from t_config where key = '{{key}}'"
}

redis {
  addr = "localhost:6379"
  password = ""
  db = 0
  servicesKey = "services"
  # servicesKey = "__gateway_redis__ upstreams"
  # 如果是hash的，servicesKey = "hashKey field"
}

tpl {
  dataSource = "redis"
  interval = "10s"
  tplSource = "/etc/nginx/conf.d/load-balancer.conf.tpl"
  destination = "/etc/nginx/conf.d/load-balancer.conf"
  perms = 0600
  testCommand = "service nginx -t"
  testCommandCheck = "successful"
  command = "service nginx reload"
}

