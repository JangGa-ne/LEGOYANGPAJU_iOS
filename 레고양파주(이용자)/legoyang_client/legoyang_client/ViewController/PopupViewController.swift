//
//  PopupViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/06.
//

import UIKit
import ImageSlideshow

class PopupViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var adImageSliderView: ImageSlideshow!
    @IBOutlet weak var todayHiddenButton: UIButton!
    @IBOutlet weak var hiddenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.PopupViewControllerDelegate = self
        
        adImageSliderView.pageIndicator = nil
        adImageSliderView.slideshowInterval = 5
        adImageSliderView.delegate = self
        adImageSliderView.tag = 0; adImageSliderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(adImageSliderView(_:))))
        
        var images: [String] = []
        for data in UIViewController.appDelegate.AppLegoObject.mainContents {
            images.append(data.url)
        }; setImageSlider(imageView: adImageSliderView, imageUrls: images, cornerRadius: 0, contentMode: .scaleAspectFill)
        
        for (i, button) in [todayHiddenButton, hiddenButton].enumerated() {
            button!.tag = i; button!.addTarget(self, action: #selector(hiddenButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func hiddenButton(_ sender: UIButton) {
        
        if sender.tag == 0 {
            UserDefaults.standard.setValue(setKoreaTimestamp()+86400000, forKey: "today_hidden_time")
            UserDefaults.standard.synchronize()
        } else if sender.tag == 1 {
            
        }
        
        dismiss(animated: false, completion: nil)
    }
}

extension PopupViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        imageSlideshow.tag = page
    }
    
    @objc func adImageSliderView(_ sender: UITapGestureRecognizer) {
        
        guard let sender = sender.view else { return }
        
        let data = UIViewController.appDelegate.AppLegoObject.mainContents[sender.tag]
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "SafariViewController") as! SafariViewController
        segue.modalPresentationStyle = .pageSheet
        segue.titleName = "팝업 상세보기"; segue.linkUrl = data.linkUrl
        present(segue, animated: true, completion: nil)
    }
}
