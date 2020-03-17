//
//  ViewController.swift
//  SwiftSimpleCrypto
//
//  Created by ZhaoYong on 2020/3/17.
//  Copyright © 2020 ZhaoYong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView = UITextView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100))
        view.addSubview(textView)
        
        let secretId  = "AKIDz8krbsJ5yKBZQpn74WFkmLPx3EXAMPLE"
        let secretKey = "Gu5t9xGARNpq86cd98joQYCN3EXAMPLE"
        
        let action = "DescribeInstances"

        let service = "cvm"
        let host = "cvm.tencentcloudapi.com"
        let region = "ap-guangzhou"
        let version = "2017-03-12"
        let algorithm = "TC3-HMAC-SHA256"
        
        let timestampInterval: TimeInterval = 1551113065
        let timestamp = "\(Int(timestampInterval))"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //注意时区，否则容易出错
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.string(from: Date(timeIntervalSince1970: timestampInterval))
        
        // ************* 步骤 1：拼接规范请求串 *************
        let httpRequestMethod = "POST"
        let canonicalUri = "/"
        let canonicalQueryString = ""
        let canonicalHeaders = "content-type:application/json; charset=utf-8\n" + "host:" + host + "\n"
        let signedHeaders = "content-type;host"
        let payload = "{\"Limit\": 1, \"Filters\": [{\"Values\": [\"\\u672a\\u547d\\u540d\"], \"Name\": \"instance-name\"}]}"
        let hashedRequestPayload = payload.hashHex(by: .SHA256)
        let canonicalRequest = httpRequestMethod + "\n" + canonicalUri + "\n" + canonicalQueryString + "\n"
            + canonicalHeaders + "\n" + signedHeaders + "\n" + hashedRequestPayload;
        print("第一步结果：", canonicalRequest)
        textView.text = "第一步结果：" + canonicalRequest + "\n"
        
        // ************* 步骤 2：拼接待签名字符串 *************
        let credentialScope = date + "/" + service + "/" + "tc3_request"
        let hashedCanonicalRequest = canonicalRequest.hashHex(by: .SHA256)
        let stringToSign = algorithm + "\n" + timestamp + "\n" + credentialScope + "\n" + hashedCanonicalRequest
        
        print("第二步结果：", stringToSign)
        textView.text += "第二步结果：" + stringToSign + "\n"
        
        // ************* 步骤 3：计算签名 *************
        let secretDate = date.hmac(by: .SHA256, key: ("TC3" + secretKey).bytes)
        let secretService = service.hmac(by: .SHA256, key: secretDate)
        let secretSigning = "tc3_request".hmac(by: .SHA256, key: secretService)
        let signature = stringToSign.hmac(by: .SHA256, key: secretSigning).hexString.lowercased()
        
        print("第三步结果：", signature)
        textView.text += "第三步结果：" + signature + "\n"
        
        // ************* 步骤 4：拼接 Authorization *************
        let authorization = "TC3-HMAC-SHA256 " + "Credential=" + secretId + "/" + credentialScope + ", "
        + "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature
        
        print("第四步结果：", authorization)
        textView.text += "第四步结果：" + authorization + "\n"
        
        var headerParams = [String: Any]()
        headerParams["Host"]           = host
        headerParams["Authorization"]  = authorization
        headerParams["Content-Type"]   = "application/json; charset=utf-8"
        headerParams["X-TC-Action"]    = action
        headerParams["X-TC-Timestamp"] = timestamp
        headerParams["X-TC-Version"]   = version
        headerParams["X-TC-Region"]    = region
        
        //然后例如AFN,可以使用AFHTTPRequestSerializer 的 requestSerializer 写入到请求头
//        for headerParam in headerParams {
//            requestSerializer.setValue(headerParam.value, forHTTPHeaderField: headerParam.key)
//        }
    }
}

