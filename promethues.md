## metric
- `<boolean>`: a boolean that can take the values true or false
- `<duration>`: a duration matching the regular expression ((([0-9]+)y)?(([0-9]+)w)?(([0-9]+)d)?(([0-9]+)h)?(([0-9]+)m)?(([0-9]+)s)?(([0-9]+)ms)?|0), e.g. 1d, 1h30m, 5m, 10s
- `<filename>`: a valid path in the current working directory
- `<float>`: a floating-point number
- `<host>`: a valid string consisting of a hostname or IP followed by an optional port number
- `<int>`: an integer value
- `<labelname>`: a string matching the regular expression [a-zA-Z_][a-zA-Z0-9_]*
- `<labelvalue>`: a string of unicode characters
- `<path>`: a valid URL path
- `<scheme>`: a string that can take the values http or https
- `<secret>`: a regular string that is a secret, such as a password
- `<string>`: a regular string
- `<size>`: a size in bytes, e.g. 512MB. A unit is required. Supported units: B, KB, MB, GB, TB, PB, EB.
- `<tmpl_string>`: a string which is template-expanded before usage
```yaml
global:
  # How frequently to scrape targets by default.
  [ scrape_interval: <duration> | default = 1m ]

  # How long until a scrape request times out.
  [ scrape_timeout: <duration> | default = 10s ]

  # How frequently to evaluate rules.
  [ evaluation_interval: <duration> | default = 1m ]

  # The labels to add to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
    [ <labelname>: <labelvalue> ... ]

  # File to which PromQL queries are logged.
  # Reloading the configuration will reopen the file.
  [ query_log_file: <string> ]

  # An uncompressed response body larger than this many bytes will cause the
  # scrape to fail. 0 means no limit. Example: 100MB.
  # This is an experimental feature, this behaviour could
  # change or be removed in the future.
  [ body_size_limit: <size> | default = 0 ]

  # Per-scrape limit on number of scraped samples that will be accepted.
  # If more than this number of samples are present after metric relabeling
  # the entire scrape will be treated as failed. 0 means no limit.
  [ sample_limit: <int> | default = 0 ]

  # Per-scrape limit on number of labels that will be accepted for a sample. If
  # more than this number of labels are present post metric-relabeling, the
  # entire scrape will be treated as failed. 0 means no limit.
  [ label_limit: <int> | default = 0 ]

  # Per-scrape limit on length of labels name that will be accepted for a sample.
  # If a label name is longer than this number post metric-relabeling, the entire
  # scrape will be treated as failed. 0 means no limit.
  [ label_name_length_limit: <int> | default = 0 ]

  # Per-scrape limit on length of labels value that will be accepted for a sample.
  # If a label value is longer than this number post metric-relabeling, the
  # entire scrape will be treated as failed. 0 means no limit.
  [ label_value_length_limit: <int> | default = 0 ]

  # Per-scrape config limit on number of unique targets that will be
  # accepted. If more than this number of targets are present after target
  # relabeling, Prometheus will mark the targets as failed without scraping them.
  # 0 means no limit. This is an experimental feature, this behaviour could
  # change in the future.
  [ target_limit: <int> | default = 0 ]

# Rule files specifies a list of globs. Rules and alerts are read from
# all matching files.
rule_files:
  [ - <filepath_glob> ... ]

# Scrape config files specifies a list of globs. Scrape configs are read from
# all matching files and appended to the list of scrape configs.
scrape_config_files:
  [ - <filepath_glob> ... ]

# A list of scrape configurations.
scrape_configs:
  [ - <scrape_config> ... ]

# Alerting specifies settings related to the Alertmanager.
alerting:
  alert_relabel_configs:
    [ - <relabel_config> ... ]
  alertmanagers:
    [ - <alertmanager_config> ... ]

# Settings related to the remote write feature.
remote_write:
  [ - <remote_write> ... ]

# Settings related to the remote read feature.
remote_read:
  [ - <remote_read> ... ]

# Storage related settings that are runtime reloadable.
storage:
  [ tsdb: <tsdb> ]
  [ exemplars: <exemplars> ]

# Configures exporting traces.
tracing:
  [ <tracing_config> ]
```

### scrape_config
- 指定一组目标和描述如何抓取他们的参数，一般一个抓取配置指定一个作业
  - 目标可以使用`static_config`参数静态配置，也可以使用动态发现
  - relabel_configs允许在抓取前对任何目标及其标签进行高级修改
``` yaml
# The job name assigned to scraped metrics by default.
job_name: <job_name>

# 频率
[ scrape_interval: <duration> | default = <global_config.scrape_interval> ]

# 超时时间
[ scrape_timeout: <duration> | default = <global_config.scrape_timeout> ]

# 是否绘制直方图
[ scrape_classic_histograms: <boolean> | default = false ]

# 目标获取指标的http 路劲
[ metrics_path: <path> | default = /metrics ]

# honor_labels 控制prometheus处理已存在于收集数据中的标签与prometheus将附加在服务器端的标签("作业"和"实例"标签、手动配置的目标标签和由服务发现实现生成的标签)之间的冲突
# 如果 honor_labels 设置为 "true"，则通过保持从拉取数据获得的标签值并忽略冲突的服务器端标签来解决标签冲突
# 如果 honor_labels 设置为 "false"，则通过将拉取数据中冲突的标签重命名为"exported_<original-label>"来解决标签冲突(例如"exported_instance"、"exported_job")，然后附加服务器端标签
# 注意，任何全局配置的 "external_labels"都不受此设置的影响。在与外部系统的通信中，只有当时间序列还没有给定的标签时，它们才被应用，否则就会被忽略
[ honor_labels: <boolean> | default = false ]

# honor_timestamps 控制prometheus是否遵守拉取数据中的时间戳
# 如果 honor_timestamps 设置为 "true"，将使用目标公开的metrics的时间戳
# 如果 honor_timestamps 设置为 "false"，目标公开的metrics的时间戳将被忽略
[ honor_timestamps: <boolean> | default = true ]

# 配置请求协议
[ scheme: <scheme> | default = http ]

# 可选的http url参数
params:
  [ <string>: [<string>, ...] ]

# 在每个拉取请求上配置 username 和 password 来设置 Authorization 头部，password 和 password_file 二选一
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# 使用配置证书在每个抓取请求上设置 授权 标头
authorization:
  # Sets the authentication type of the request.
  [ type: <string> | default: Bearer ]
  # Sets the credentials of the request. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials of the request with the credentials read from the
  # configured file. It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# 不能与basic_auth和authorization同时使用
oauth2:
  [ <oauth2> ]

# 配置抓取请求是否遵循3xx 重定向
[ follow_redirects: <boolean> | default = true ]

# 是否支持http2
[ enable_http2: <boolean> | default: true ]

# 配置抓取请求的TLS请求
tls_config:
  [ <tls_config> ]

# 可选的代理URL
[ proxy_url: <string> ]
# 以逗号分隔的字符串，可以包含从代理中排除的IP、CIDR表示法、域名，IP和域名可以包含端口号。
[ no_proxy: <string> ]
# 使用环境变量指示的代理URL(HTTP_PROXY, https_proxy, HTTPs_proxy, https_proxy, no_proxy)
[ proxy_from_environment: <boolean> | default: false ]
# 指定在connect请求期间发送到代理的标头
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]


# Azure服务发现配置列表
azure_sd_configs:
  [ - <azure_sd_config> ... ]

# Consul服务发现配置列表
consul_sd_configs:
  [ - <consul_sd_config> ... ]

# DigitalOcean 服务发现配置列表
digitalocean_sd_configs:
  [ - <digitalocean_sd_config> ... ]

# Docker 服务发现配置列表
docker_sd_configs:
  [ - <docker_sd_config> ... ]

# Docker Swarm 服务发现配置列表
dockerswarm_sd_configs:
  [ - <dockerswarm_sd_config> ... ]

# DNS服务发现配置列表
dns_sd_configs:
  [ - <dns_sd_config> ... ]

# EC2服务发现配置列表
ec2_sd_configs:
  [ - <ec2_sd_config> ... ]

# Eureka 服务发现配置列表
eureka_sd_configs:
  [ - <eureka_sd_config> ... ]

# file服务发现配置列表
file_sd_configs:
  [ - <file_sd_config> ... ]

# GCE服务发现配置列表
gce_sd_configs:
  [ - <gce_sd_config> ... ]

# Hetzner 服务发现配置列表
hetzner_sd_configs:
  [ - <hetzner_sd_config> ... ]

# Http 服务发现配置列表
http_sd_configs:
  [ - <http_sd_config> ... ]


# Ionos 服务发现配置列表
ionos_sd_configs:
  [ - <ionos_sd_config> ... ]

# Kubernetes服务发现配置列表
kubernetes_sd_configs:
  [ - <kubernetes_sd_config> ... ]

# Kuma 服务发现配置列表
kuma_sd_configs:
  [ - <kuma_sd_config> ... ]

# Lightsail 服务发现配置列表
lightsail_sd_configs:
  [ - <lightsail_sd_config> ... ]

# Linode 服务发现配置列表
linode_sd_configs:
  [ - <linode_sd_config> ... ]

# Marathon服务发现配置列表
marathon_sd_configs:
  [ - <marathon_sd_config> ... ]

# AirBnB's Nerve服务发现配置列表
nerve_sd_configs:
  [ - <nerve_sd_config> ... ]

# Nomad 服务发现配置列表
nomad_sd_configs:
  [ - <nomad_sd_config> ... ]

# OpenStack服务发现配置列表
openstack_sd_configs:
  [ - <openstack_sd_config> ... ]

# OVHcloud 服务发现配置列表
ovhcloud_sd_configs:
  [ - <ovhcloud_sd_config> ... ]

# PuppetDB 服务发现配置列表
puppetdb_sd_configs:
  [ - <puppetdb_sd_config> ... ]

# Scaleway 服务发现配置列表
scaleway_sd_configs:
  [ - <scaleway_sd_config> ... ]

# Zookeeper Serverset服务发现配置列表
serverset_sd_configs:
  [ - <serverset_sd_config> ... ]

# Triton服务发现配置列表
triton_sd_configs:
  [ - <triton_sd_config> ... ]

# Uyuni 服务发现配置列表
uyuni_sd_configs:
  [ - <uyuni_sd_config> ... ]

# 静态配置目标列表
static_configs:
  [ - <static_config> ... ]

# 目标relabel配置列表
relabel_configs:
  [ - <relabel_config> ... ]

# metric relabel配置列表
metric_relabel_configs:
  [ - <relabel_config> ... ]

# 大于指定值的未压缩响应体将导致抓取失败，0表示没有限制
# 示例： 100MB 
[ body_size_limit: <size> | default = 0 ]

# 每次拉取样例的数量限制
# 如果有超过这个数量的样例，整个拉取将被视为失效。0表示没有限制
[ sample_limit: <int> | default = 0 ]

# 每次拉取样例的标签数量限制
# 如果超过了这个限额，就会将抓取过程视为失败，0表示没有限制
[ label_limit: <int> | default = 0 ]

# 每次拉取样例的标签名称长度限制
# 如果超过了这个限额，就会将抓取过程视为失败，0表示没有限制
[ label_name_length_limit: <int> | default = 0 ]

# 每次拉取样例的标签内容长度限制
# 如果超过了这个限额，就会将抓取过程视为失败，0表示没有限制
[ label_value_length_limit: <int> | default = 0 ]

# 每次拉取时唯一的target数量限制
# 如果超过了这个限额，就会将抓取过程视为失败，0表示没有限制
# 未来存在变更性
[ target_limit: <int> | default = 0 ]

# 一个直方图中 直方体的限制数量
# 0表示没有限制
[ native_histogram_bucket_limit: <int> | default = 0 ]
```

### static_config
- `static_config` 允许指定目标列表以及为它们设置的通用标签。这是在抓取配置中指定静态目标的规范方法。
```yaml
# 静态配置指定的目标
targets:
  [ - '<host>' ]

# 分配给从目标中抓取的所有指标的标签
labels:
  [ <labelname>: <labelvalue> ... ]
```

### relabel_connfig
- Relabeling 是一个强大的工具，可以在目标被抓取之前动态重写目标的标签集。每个抓取配置可以配置多个重新标记步骤。它们按照在配置文件中出现的顺序应用于每个目标的标签集。
- 最初，除了配置的每个目标标签之外，目标的 `job` 标签还设置为相应抓取配置的 `job_name` 值。
- `__address__` 标签设置为目标的 `<host>:<port>` 地址。重新标记后，如果在重新标记期间未设置实例标签，则默认情况下会将实例标签设置为 `__address__` 的值。 `__scheme__` 和 `__metrics_path__` 标签分别设置为目标的方案和指标路径。 `__param_<name>` 标签设置为第一个传递的名为 `<name>` 的 URL 参数的值。
- `__scrape_interval__` 和 `__scrape_timeout__` 标签设置为目标的间隔和超时。将来可能会改变。
- 在重新标记阶段可能会提供带有 `__meta_` 前缀的其他标签。它们由提供目标的服务发现机制设置，并且在机制之间有所不同。
- 目标重新标记完成后，以 `__` 开头的标签将从标签集中删除。
- 如果重新标记步骤仅需要临时存储标签值（作为后续重新标记步骤的输入），请使用 `__tmp` 标签名称前缀。 `Prometheus` 本身保证永远不会使用此前缀。

```yaml
# 源标签从现有标签中选择值。它们的内容使用配置的分隔符连接，并与配置的正则表达式匹配以进行替换、保留和删除操作。
[ source_labels: '[' <labelname> [, ...] ']' ]

# 放置在串联源标签值之间的分隔符。 默认为 ";"
[ separator: <string> | default = ; ]

# 在替换操作中将结果值写入的标签。对于替换操作来说这是强制性的。正则表达式捕获组可用。
[ target_label: <labelname> ]

# 与提取的值相匹配的正则表达式，默认为.* 全匹配
[ regex: <regex> | default = (.*) ]

# 源标签值的哈希值的模数
[ modulus: <int> ]

# 如果正则表达式匹配，则执行正则表达式替换的替换值。正则表达式捕获组可用，默认为$1
[ replacement: <string> | default = $1 ]

# 基于正则表达式匹配执行的操作，默认为替换
[ action: <relabel_action> | default = replace ]
```
`<relabel_action>` 定义的操作:

`replace`: 将正则表达式与串联的 `source_labels` 进行匹配。然后，将 `target_label` 设置为 `replacement`，并用其值替换 `replacement` 中的匹配组引用`（${1}、${2}、...）`。如果正则表达式不匹配，则不会进行替换
`lowercase`: 将连接的 `source_labels` 映射为其小写字母
`uppercase`: 将连接的 `source_labels` 映射为其大写字母
`keep`: 删除正则表达式与串联的 `source_labels` 不匹配的目标
`drop`: 删除正则表达式与串联的 `source_labels` 匹配的目标
`keepequal`: 删除串联的 `source_labels` 与 `target_label` 不匹配的目标
`dropequal`: 删除串联的 `source_labels` 与 `target_label` 匹配的目标
`hashmod`: 将 `target_label` 设置为连接的 `source_labels` 的哈希值的模
`labelmap`: 将正则表达式与所有源标签名称匹配，而不仅仅是 `source_labels` 中指定的名称。然后将匹配标签的值复制到通过替换给出的标签名称，并用匹配组引用`（${1}，${2}，...）`替换它们的值
`labeldrop`: 将正则表达式与所有标签名称进行匹配。任何匹配的标签都将从标签集中删除
`labelkeep`: 将正则表达式与所有标签名称进行匹配。任何不匹配的标签都将从标签集中删除

### tracing_config
- `tracing_config` 配置通过 OTLP 协议将跟踪从 Prometheus 导出到跟踪后端。跟踪目前是一项实验性功能，将来可能会发生变化
  
``` yaml
# 客户端用于导出痕迹。选项为“http”或“grpc”
[ client_type: <string> | default = grpc ]

# 将跟踪发送到的端点。应以 <host>:<port> 的格式提供
[ endpoint: <string> ]

# 设置对给定迹线进行采样的概率。必须是从 0 到 1 的浮点数
[ sampling_fraction: <float> | default = 0 ]

# 如果禁用，客户端将使用安全连接
[ insecure: <boolean> | default = false ]

# 用作与 gRPC 或 HTTP 请求关联的标头的键值对
headers:
  [ <string>: <string> ... ]

# 支持的压缩类型的压缩密钥。支持的压缩：gzip
[ compression: <string> ]

# 导出器每次批量导出等待的最长时间
[ timeout: <duration> | default = 10s ]

# TLS配置
tls_config:
  [ <tls_config> ]
```
### remote_write
- `write_relabel_configs` 在将样本发送到远程端点之前对其进行重新标记。写重新标签在外部标签之后应用。这可用于限制发送哪些样本。
``` yaml
# 要将样本发送到的端点的 URL
url: <string>

# 对远程写入端点的请求超时时间
[ remote_timeout: <duration> | default = 30s ]

# 与每个远程写入请求一起发送的自定义 HTTP 标头
# 请注意，Prometheus 本身设置的标头无法被覆盖
headers:
  [ <string>: <string> ... ]

# 远程写入重新标记配置列表
write_relabel_configs:
  [ - <relabel_config> ... ]

# 远程写入配置的名称，如果指定，则该名称必须在远程写入配置中唯一
# 该名称将在指标和日志记录中代替生成的值使用，以帮助用户区分远程写入配置
[ name: <string> ]

# 允许通过远程写入发送示例。请注意，必须首先启用示例存储本身才能抓取示例
[ send_exemplars: <boolean> | default = false ]

# 允许通过远程写入发送本机直方图（也称为稀疏直方图）
[ send_native_histograms: <boolean> | default = false ]

# 使用配置的用户名和密码在每个远程写入请求上设置“授权”标头
# password 和 password_file 是互斥的
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# 可选的“Authorization”标头配置
authorization:
  # 设置身份验证类型
  [ type: <string> | default: Bearer ]
  # 设置凭据。它与“credentials_file”互斥
  [ credentials: <secret> ]
  # 将凭据设置为从配置文件中读取的凭据。它与“credentials”是互斥的
  [ credentials_file: <filename> ]

# 可选配置 AWS 的 Signature Verification 4 签名流程来签署请求。不能与 basic_auth、authorization、oauth2 或 azuread 同时设置。要使用 AWS 开发工具包中的默认凭证，请使用“sigv4: {}”
sigv4:
  # AWS 区域。如果为空，则使用默认凭据链中的区域
  [ region: <string> ]

  # AWS API 密钥。如果为空，则使用环境变量“AWS_ACCESS_KEY_ID”和“AWS_SECRET_ACCESS_KEY”
  [ access_key: <string> ]
  [ secret_key: <secret> ]

  # 用于身份验证的命名 AWS 配置文件
  [ profile: <string> ]

  # AWS Role ARN，使用 AWS API 密钥的替代方案
  [ role_arn: <string> ]

# 可选的 OAuth 2.0 配置
# 不能与 basic_auth、authorization、sigv4 或 azuread 同时使用
oauth2:
  [ <oauth2> ]

# 可选的 AzureAD 配置
# 不能与 basic_auth、authorization、oauth2 或 sigv4 同时使用
azuread:
  # The Azure Cloud. 选项包括“AzurePublic”、“AzureChina”、“AzureGovernment”
  [ cloud: <string> | default = AzurePublic ]

  # Azure 用户分配的托管标识
  [ managed_identity:
      [ client_id: <string> ]  

# 配置远程写入请求的 TLS 设置
tls_config:
  [ <tls_config> ]

# 可选的代理 URL
[ proxy_url: <string> ]
# 以逗号分隔的字符串，可以包含应从代理中排除的 IP、CIDR 表示法、域名。 IP 和域名可以包含端口号
[ no_proxy: <string> ]
# 使用环境变量指示的代理 URL（HTTP_PROXY、https_proxy、HTTPs_PROXY、https_proxy 和 no_proxy）
[ proxy_from_environment: <boolean> | default: false ]
# 指定在 CONNECT 请求期间发送到代理的标头
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# 配置 HTTP 请求是否遵循 HTTP 3xx 重定向
[ follow_redirects: <boolean> | default = true ]

# 是否启用HTTP2
[ enable_http2: <boolean> | default: true ]

# 配置用于写入远程存储的队列
queue_config:
  # Number of samples to buffer per shard before we block reading of more
  # samples from the WAL. It is recommended to have enough capacity in each
  # shard to buffer several requests to keep throughput up while processing
  # occasional slow remote requests.
  # 在我们阻止从 WAL 读取更多样本之前，每个分片要缓冲的样本数。建议每个分片有足够的容量来缓冲多个请求，以在处理偶尔缓慢的远程请求时保持吞吐量
  [ capacity: <int> | default = 2500 ]
  # 最大分片数，即并发量
  [ max_shards: <int> | default = 200 ]
  # 最小分片数，即并发量
  [ min_shards: <int> | default = 1 ]
  # 每次发送的最大样本数
  [ max_samples_per_send: <int> | default = 500]
  # 样本在缓冲区中等待的最长时间
  [ batch_send_deadline: <duration> | default = 5s ]
  # 初始重试延迟。每次重试都会加倍
  [ min_backoff: <duration> | default = 30ms ]
  # 最大重试延迟
  [ max_backoff: <duration> | default = 5s ]
  # 从远程写入存储接收到 429 状态代码后重试
  # This is experimental and might change in the future.
  [ retry_on_http_429: <boolean> | default = false ]

# 配置将系列元数据发送到远程存储
# 元数据配置可能随时更改或在未来版本中删除
metadata_config:
  # 指标元数据是否发送到远程存储
  [ send: <boolean> | default = true ]
  # 指标元数据发送到远程存储的频率
  [ send_interval: <duration> | default = 1m ]
  # 每次发送的最大样本数
  [ max_samples_per_send: <int> | default = 500]
```

### remote_read

``` yaml
# 要查询的端点的 URL
url: <string>

# 远程读取配置的名称，如果指定，则该名称在远程读取配置中必须是唯一的
# 该名称将在指标和日志记录中代替生成的值使用，以帮助用户区分远程读取配置
[ name: <string> ]

# 相等匹配器的可选列表，必须出现在选择器中才能查询远程读取端点
required_matchers:
  [ <labelname>: <labelvalue> ... ]

# 对远程读取端点的请求超时
[ remote_timeout: <duration> | default = 1m ]

# 与每个远程读取请求一起发送的自定义 HTTP 标头
# 请注意，Prometheus 本身设置的标头无法被覆盖
headers:
  [ <string>: <string> ... ]

# 是否应对本地存储应具有完整数据的时间范围的查询进行读取
[ read_recent: <boolean> | default = false ]

# Sets the `Authorization` header on every remote read request with the
# configured username and password.
# password and password_file are mutually exclusive.
basic_auth:
  [ username: <string> ]
  [ password: <secret> ]
  [ password_file: <string> ]

# Optional `Authorization` header configuration.
authorization:
  # Sets the authentication type.
  [ type: <string> | default: Bearer ]
  # Sets the credentials. It is mutually exclusive with
  # `credentials_file`.
  [ credentials: <secret> ]
  # Sets the credentials to the credentials read from the configured file.
  # It is mutually exclusive with `credentials`.
  [ credentials_file: <filename> ]

# Optional OAuth 2.0 configuration.
# Cannot be used at the same time as basic_auth or authorization.
oauth2:
  [ <oauth2> ]

# Configures the remote read request's TLS settings.
tls_config:
  [ <tls_config> ]

# Optional proxy URL.
[ proxy_url: <string> ]
# Comma-separated string that can contain IPs, CIDR notation, domain names
# that should be excluded from proxying. IP and domain names can
# contain port numbers.
[ no_proxy: <string> ]
# Use proxy URL indicated by environment variables (HTTP_PROXY, https_proxy, HTTPs_PROXY, https_proxy, and no_proxy)
[ proxy_from_environment: <boolean> | default: false ]
# Specifies headers to send to proxies during CONNECT requests.
[ proxy_connect_header:
  [ <string>: [<secret>, ...] ] ]

# Configure whether HTTP requests follow HTTP 3xx redirects.
[ follow_redirects: <boolean> | default = true ]

# Whether to enable HTTP2.
[ enable_http2: <boolean> | default: true ]

# 是否使用外部标签作为远程读取端点的选择器
[ filter_external_labels: <boolean> | default = true ]
```