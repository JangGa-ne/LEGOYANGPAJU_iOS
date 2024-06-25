//
//  S_IMAGE.swift
//  Horticulture
//
//  Created by 장 제현 on 2021/10/30.
//

import UIKit
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
        
        DispatchQueue.global().sync {
            if IU != "" {
                let REQUEST = ImageRequest(url: URL(string: IU)! , processors: [ImageProcessors.Resize(size: IV.frame.size)])
                let OPTIONS = ImageLoadingOptions(placeholder: PH, contentModes: .init(success: CM, failure: .scaleAspectFit, placeholder: .scaleAspectFit))
                Nuke.loadImage(with: REQUEST, options: OPTIONS, into: IV) { error in
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
    
    func setImageSlider(imageView: ImageSlideshow, imageUrls: [String], cornerRadius: CGFloat, contentMode: UIView.ContentMode) {
        
        imageView.layer.cornerRadius = cornerRadius; imageView.contentScaleMode = contentMode
        
        DispatchQueue.global().sync {
            
            var images: [SDWebImageSource] = []
            for imageUrl in imageUrls { images.append(SDWebImageSource(urlString: imageUrl)!) }
            
            DispatchQueue.main.async { imageView.setImageInputs(images) }
        }
    }
    
    func setImageNuke(imageView: UIImageView, placeholder: UIImage?, imageUrl: String, cornerRadius: CGFloat, contentMode: UIView.ContentMode) {

        imageView.layer.cornerRadius = cornerRadius; imageView.contentMode = contentMode

        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.frame = CGRect(x: imageView.bounds.midX-10, y: imageView.bounds.midY-10, width: 20, height: 20)
        imageView.addSubview(activityIndicatorView); activityIndicatorView.startAnimating()

        if let loadUrl = URL(string: imageUrl) {

            DispatchQueue.global(qos: .background).sync {

                let requset = ImageRequest(url: loadUrl, processors: [ImageProcessors.Resize(size: imageView.bounds.size)])
                let options = ImageLoadingOptions(placeholder: placeholder, transition: .fadeIn(duration: 0.2), contentModes: .init(success: contentMode, failure: .scaleAspectFit, placeholder: .scaleAspectFit))

                Nuke.loadImage(with: requset, options: options, into: imageView) { _ in
                    activityIndicatorView.stopAnimating(); activityIndicatorView.removeFromSuperview()
                }
            }
            
        } else {
            activityIndicatorView.stopAnimating(); activityIndicatorView.removeFromSuperview(); imageView.image = placeholder
        }
    }
}

class ImageDataSource {
    private let imageUrls: [URL]
    
    init(imageUrls: [URL]) {
        self.imageUrls = imageUrls
    }
    
    func imageUrl(at index: Int) -> URL {
        return imageUrls[index]
    }
    
    func numberOfImages() -> Int {
        return imageUrls.count
    }
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
