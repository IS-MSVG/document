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
|key|value|description|
|-|-|-|
|apiVersion|networking.istio.io/v1alpha3|api version|
|kind|Gateway or VirtualService||
|metatdatda|{name: ...}|json|
|spec|{selector: ...}|json|

## 参考
https://istio.io/latest/zh/docs/reference/config/networking/virtual-service/