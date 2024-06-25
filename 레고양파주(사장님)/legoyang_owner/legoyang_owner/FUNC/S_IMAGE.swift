//
//  S_IMAGE.swift
//  Horticulture
//
//  Created by 장 제현 on 2021/10/30.
//

import UIKit
import AVKit
import SDWebImage
import Nuke
import FirebaseStorage
import ImageSlideshow

extension UIViewController {
    
    // 이미지 비동기화
    func SDWEBIMAGE(IV: UIImageView, IU: String, PH: UIImage?, RD: CGFloat, CM: UIView.ContentMode) {
        // 기본값
        IV.layer.cornerRadius = RD; IV.clipsToBounds = true; IV.contentMode = CM

//        var SCALEMODE: SDImageScaleMode = .aspectFit
//        if CM == .scaleAspectFit { SCALEMODE = .aspectFit } else if CM == .scaleAspectFill { SCALEMODE = .aspectFill }
//        let RESIZE = SDImageResizingTransformer(size: IV.bounds.size, scaleMode: SCALEMODE)

        DispatchQueue.global(qos: .userInitiated).sync {
            if IU != "" {
                if IU.contains("firebase") && PH != nil {
                    IV.sd_setImage(with: URL(string: IU)!, placeholderImage: PH)
                } else if PH != nil {
                    IV.sd_setImage(with: URL(string: IU.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")!, placeholderImage: PH)
                } else {
                    IV.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    IV.sd_setImage(with: URL(string: IU.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")!)
                }
            } else {
                IV.image = UIImage(named: "logo2")
            }
        }
    }
    
    func NUKE(IV: UIImageView, IU: String, PH: UIImage = UIImage(), RD: CGFloat, CM: UIView.ContentMode) {
        // 기본값
        IV.layer.cornerRadius = RD; IV.clipsToBounds = true; IV.contentMode = CM
        // 로딩 인디케이터
        let INDICATOR = UIActivityIndicatorView(style: .gray)
        INDICATOR.frame = CGRect(x: IV.bounds.midX-10, y: IV.bounds.midY-10, width: 20, height: 20)
        IV.addSubview(INDICATOR); INDICATOR.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).sync {
            if IU != "" {
                let REQUEST = ImageRequest(url: URL(string: IU)! , processors: [ImageProcessors.Resize(size: IV.frame.size)])
                let OPTIONS = ImageLoadingOptions(placeholder: PH, contentModes: .init(success: CM, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
                Nuke.loadImage(with: REQUEST, options: OPTIONS, into: IV) { _ in
                    INDICATOR.stopAnimating(); INDICATOR.removeFromSuperview()
                }
            } else {
                INDICATOR.stopAnimating(); INDICATOR.removeFromSuperview(); IV.image = UIImage(named: "logo2")
            }
        }
    }
    
    func IMAGESLIDER(IV: ImageSlideshow, IU: [String], PH: UIImage?, RD: CGFloat, CM: UIView.ContentMode) {
        
        IV.layer.cornerRadius = RD; IV.clipsToBounds = true
        IV.pageIndicator = .none; IV.contentScaleMode = CM
        
        DispatchQueue.global(qos: .userInitiated).sync {

            var IMAGES: [SDWebImageSource] = []
            for i in 0 ..< IU.count { IMAGES.append(SDWebImageSource(urlString: IU[i], placeholder: PH)!) }

            DispatchQueue.main.async { IV.setImageInputs(IMAGES) }
        }
    }
    
    // 비디오 썸네일
    func SDWEBVIDEO(IV: UIImageView, IU: String, PH: UIImage?, RD: CGFloat, CM: UIView.ContentMode) {
        
        IV.layer.cornerRadius = RD; IV.clipsToBounds = true; IV.contentMode = CM
        
        if IU != "" {
            DispatchQueue.global().async {
                do {
                    let ASSET = AVAsset(url: URL(string: IU)!)
                    let IMAGE_GENERATOR = AVAssetImageGenerator(asset: ASSET); IMAGE_GENERATOR.appliesPreferredTrackTransform = true
                    let CG_IMAGE = try IMAGE_GENERATOR.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                    DispatchQueue.main.async { IV.image = UIImage(cgImage: CG_IMAGE) }
                } catch {
                    IV.image = PH ?? UIImage(named: "logo.png")
                }
            }
        } else {
            IV.image = PH ?? UIImage(named: "logo.png")
        }
    }
    
//    // 비디오 플레이어
//    func VIDIO_PLAYER(OBJ_MEDIA: [SOSIK_D], TAG: Int, PROTOCOL: UIViewController?) {
//
//        let DATA = OBJ_MEDIA[TAG]
//        if DATA.MEDIA_TYPE == "M" && DATA.MEDIA_URL != "" {
//
//            let PLAYER = AVPlayer(url: URL(string: DATA.MEDIA_URL)!)
//            let PLAYER_VC = AVPlayerViewController()
//
//            PLAYER_VC.player = PLAYER
//            PLAYER.play()
//            PROTOCOL.present(PLAYER_VC, animated: true, completion: nil)
//        }
//    }
}

extension UIImage {
    
    func resize(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in self.draw(in: CGRect(origin: .zero, size: size)) }
        
        return renderImage
    }
}
