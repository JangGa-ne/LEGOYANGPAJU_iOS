//
//  S_SHARE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/19.
//

import UIKit
import KakaoSDKShare
import KakaoSDKTemplate
import KakaoSDKCommon
import SafariServices

extension UIViewController {
    
    func setShare(title: String, description: String, imageUrl: String, params: String = "") {
        
        let json =
        """
            {
                "object_type": "feed",
                "content": {
                    "title": "\(title)",
                    "description": "\(description)",
                    "image_url": "\(imageUrl)",
                    "link": {
                        "android_execution_params": "\(params)",
                        "ios_execution_params": "\(params)",
                    }
                },
                "buttons": [
                    {
                        "title": "앱으로 보기",
                        "link": {
                            "android_execution_params": "\(params)",
                            "ios_execution_params": "\(params)",
                        }
                    }
                ]
            }
        """.data(using: .utf8)!
        
        guard let templatable = try? SdkJSONDecoder.custom.decode(FeedTemplate.self, from: json) else { return }
        // 카카오톡 설치여부 확인
        if ShareApi.isKakaoTalkSharingAvailable() {
            
            ShareApi.shared.shareDefault(templatable: templatable) { sharingResult, error in
                if let sharingResult = sharingResult {
                    print(sharingResult)
                    UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                }
            }
            
        } else if let url = ShareApi.shared.makeDefaultUrl(templatable: templatable) {
                
            var VC_SAFARI: SFSafariViewController?
            
            VC_SAFARI = SFSafariViewController(url: url)
            VC_SAFARI?.modalTransitionStyle = .crossDissolve
            VC_SAFARI?.modalPresentationStyle = .overCurrentContext
            
            present(VC_SAFARI!, animated: true, completion: nil)
        }
        
//        let link = Link(
//            webUrl: URL(string: "https://apps.apple.com/us/app/id1670109393"),
//            mobileWebUrl: URL(string: "https://apps.apple.com/us/app/id1670109393"),
//            androidExecutionParams: params,
//            iosExecutionParams: params
//        )
//
//        let content = Content(
//            title: title,
//            imageUrl: URL(string: imageUrl)!,
//            description: description,
//            link: link
//        )
//
//        let button = Button(
//            title: "앱으로 보기",
//            link: link
//        )
//
//        let feedTemplate = FeedTemplate(content: content, buttons: [button])
//
//        guard let feedTemplateJsonData = try? SdkJSONEncoder.custom.encode(feedTemplate) else { return }
//        guard let templateJsonObject = SdkUtils.toJsonObject(feedTemplateJsonData) else { return }
//        // 카카오톡 설치여부 확인
//        if ShareApi.isKakaoTalkSharingAvailable() {
//
//            ShareApi.shared.shareDefault(templateObject: templateJsonObject) { sharingResult, error in
//                if let sharingResult = sharingResult {
//                    UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
//                }
//            }
//
//        } else if let url = ShareApi.shared.makeDefaultUrl(templateObject: templateJsonObject) {
//
//            var VC_SAFARI: SFSafariViewController?
//
//            VC_SAFARI = SFSafariViewController(url: url)
//            VC_SAFARI?.modalTransitionStyle = .crossDissolve
//            VC_SAFARI?.modalPresentationStyle = .overCurrentContext
//
//            present(VC_SAFARI!, animated: true, completion: nil)
//        }
    }
}
