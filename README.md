# nezha-dashboard-nf

> 在northflank上部署哪吒v1面板

### 部署

1. 注册，创建项目，创建服务，输入本仓库地址
2. 备份配置，设置环境变量，参考 https://github.com/laboratorys/backup2gh

```
BAK_APP_NAME=nezha
BAK_DATA_DIR=/app/data
BAK_GITHUB_TOKEN=xxxxxxxx
BAK_MAX_COUNT=2
BAK_REPO=backup-repo
BAK_REPO_OWNER=xxx
```

3. Northflank添加端口映射

![PixPin_2024-12-21_21-01-19.png](https://fs.noki.eu.org/f/vYVFFnuuqY32)

4. 我们分别为这两个端口分配不同的域名，分别为`web.example.com`,`data.example.com`
    - `data.example.com`负责agent和面板通信，CF中关闭CDN
    - `web.example.com`负责页面访问，cf中可以开启或关闭CDN，northflank如果被Q，那就需要开启
5. 面板系统设置
    - Agent对接地址【域名/IP:端口】
      `data.example.com:443`
    - Agent 使用 TLS 连接 **勾选**
    - 使用直连 IP **勾选**
6. 复制安装命令，直接在监控端VPS安装即可