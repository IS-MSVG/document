## Gateway
```yaml
apiVersion:
kind:
metadata:
  name:
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number:
      name:
      protocol:
    hosts:
    - ""
```

## VirtualService
```yaml
apiVersion:
kind:
metadata:
  name:
spec:
  hosts:
  - ""
  gateways:
  - 
  http:
  - match:
    - uri:
        prefix:
    - uri:
        prefix:
    route:
    - destination:
        port:
          number:
        hosts:
    rewrite:
        uri: 修改match内容
```

### spec
```yaml
hosts:
- ""
gateways:
-
http:
- match:
  - uri:
      prefix:
  rewrite:
      uri:
  route:
  - destination:
      hosts:

```

# database
## ingress
|key|value|description|
|-|-|-|
|id|int auto|primary key|
|api_version|networking.istio.io/v1alpha3|api version|
|kind|Gateway or VirtualService||
|metatdatda|{name: ...}|json|
|spec|{selector: ...}|json|

## spec
|key|value|description|
|-|-|-|
|id|int auto||
|ingress_id|int|foreign key|
|hosts|string|list host|
|gateways|string|list gateway|
|http|string|core|

## rule
|key|value|description|
|-|-|-|
|id|int auto|primary key|
|spec_id|int|foreign key|
|name|string|rule name|
|uriMatch|string|match out request uri|
|rewrite|string|rewrite uri of match, prefix rewrite prefix|
|route|string|instance route|
|redirect|string|redirect uri|

## 参考
https://istio.io/latest/zh/docs/reference/config/networking/virtual-service/