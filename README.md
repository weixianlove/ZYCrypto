# ZYCrypto
Swift 桥接 &lt;CommonCrypto/CommonHMAC.h> 实现常用加密功能，附腾讯云使用的 TC3-HMAC-SHA256 签名示例

最近在做腾讯云接口鉴权，但是Swift内没有现成的加密库，又不想导入第三方库，所以就自己写了一个简单了

主要功能有,都是对`String`的扩展，方便使用

#### HMAC
```swift
let tData = "test string".hmac(by: .SHA256, key: "key string".bytes)
let oDada = "other test string".hamc(by: .SHA256, key: tData)
let signature = oData.hexSting.lowercased()
```
#### HASH

```swift
let sha256Hash = "test string".hash(by: .SHA256)
```
