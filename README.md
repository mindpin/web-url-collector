# README

## 增加配置文件

### config/initializers/r.rb
> 复制 config/initializers/r.rb.development <br/>
  到 config/initializers/r.rb

配置项：
```yaml
WRITE_TAGS_URL: tag 云服务读地址（内部服务，一般不改）
READ_TAGS_URL: tag 云服务写地址（内部服务，一般不改）
SHORT_URL_URL: 短网址服务（内部服务，一般不改）
COOKIE_KEY: 登录验证 cookie key，自行修改
TAG_SCOPE: tag 云服务的 scope. 自行修改
```

### config/initializers/weibo_oauth2.rb
> 复制 config/initializers/weibo_oauth2.rb.development <br/>
  到 config/initializers/weibo_oauth2.rb

配置项：
```yaml
KEY: 微博 app 的 key
SECRET: 微博 app 的 secret
CALLBACK_URL: 本地调试的 callback 地址
AUTHORIZE_URL: 不改
ACCESS_TOKEN_URL: 不改
```