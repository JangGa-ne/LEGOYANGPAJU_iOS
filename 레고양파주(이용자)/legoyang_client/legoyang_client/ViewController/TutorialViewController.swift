//
//  TutorialViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/10.
//

import UIKit
import FirebaseFirestore

class TutorialViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var level: Int = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButton(_ sender: UIButton) {
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        segue.modalPresentationStyle = .overFullScreen
        segue.type = "tutorial_stop"
        present(segue, animated: false, completion: nil)
        
//        let alert = UIAlertController(title: "튜토리얼 모드", message: "튜토리얼 모드를 종료할 경우 홈으로 돌아갑니다.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "계속하기", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "종료", style: .cancel, handler: { _ in
//            
//            self.dismiss(animated: false) {
//                if let delegate_1 = UIViewController.StoreDetailViewControllerDelegate {
//                    delegate_1.navigationController?.popViewController(animated: false)
//                }
//                if let delegate_2 = UIViewController.StoreDetailViewControllerDelegate {
//                    delegate_2.navigationController?.popViewController(animated: false)
//                }
//                if let delegate_3 = UIViewController.StoreViewControllerDelegate {
//                    delegate_3.navigationController?.popViewController(animated: false)
//                }
//                if let delegate_4 = UIViewController.TabBarControllerDelegate {
//                    delegate_4.selectedIndex = 2
//                }
//            }
//        }))
//        present(alert, animated: true, completion: nil)
    }
    
    var tutorialView: UIMainView! = UIMainView()
    var tutorialImageView: UIImageView! = UIImageView()
    var tutorialTitleLabel: UILabel! = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.TutorialViewControllerDelegate = self
        
        loadingData(level: 0)
    }
    
    func loadingData(level: Int = 0, image: UIImage? = nil, y: CGFloat = 0, imageHeight: CGFloat = 0) {
        
        self.level = level
        
        tutorialImageView.cornerRadius = 10
        tutorialImageView.clipsToBounds = true
        
        tutorialView.backgroundColor = .white
        tutorialView.layer.cornerRadius = 10
        view.addSubview(tutorialView)
        
        tutorialTitleLabel.backgroundColor = .black.withAlphaComponent(0.7)
        tutorialTitleLabel.layer.cornerRadius = 5
        tutorialTitleLabel.clipsToBounds = true
        tutorialTitleLabel.textAlignment = .center
        tutorialTitleLabel.textColor = .white
        tutorialTitleLabel.font = .boldSystemFont(ofSize: 10)
        view.addSubview(tutorialTitleLabel)
        
        if level == 0 {
            
            guard let delegate = UIViewController.TabBarControllerDelegate else { return }
            
            tutorialView.frame = CGRect(x: delegate.tabBar.frame.width/5/2*3-25, y: delegate.tabBar.frame.minY, width: 50, height: 50)
            tutorialTitleLabel.text = "'매장찾기'를 눌려주세요!"
            tutorialTitleLabel.frame = CGRect(x: tutorialView.frame.midX-CGFloat(stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)/2+10), y: tutorialView.frame.minY-35, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 30)
            
            let tabbarImageView = UIImageView()
            tabbarImageView.frame = CGRect(x: 0, y: 8, width: 50, height: 21)
            tabbarImageView.contentMode = .scaleAspectFit
            tabbarImageView.image = UIImage(named: "tab6")?.withRenderingMode(.alwaysOriginal)
            tutorialView.addSubview(tabbarImageView)
            
            let tabbarTitleLabel = UILabel()
            tabbarTitleLabel.frame = CGRect(x: 0, y: 32, width: 50, height: 18)
            tabbarTitleLabel.textAlignment = .center
            tabbarTitleLabel.textColor = .black
            tabbarTitleLabel.font = .systemFont(ofSize: 10, weight: .medium)
            tabbarTitleLabel.text = "매장 찾기"
            tutorialView.addSubview(tabbarTitleLabel)
            
        } else if level == 1 {
            
            tutorialView.frame = CGRect(x: 20, y: UIApplication.shared.statusBarFrame.height+170, width: (UIScreen.main.bounds.width-50)/2, height: 60)
            tutorialImageView.frame = tutorialView.bounds
            tutorialTitleLabel.text = "'카테고리'를 눌려주세요!"
            tutorialTitleLabel.frame = CGRect(x: 20, y: tutorialView.frame.maxY+5, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 30)
            
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
            
        } else if level == 2 {
            
            tutorialView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height+180, width: UIApplication.shared.statusBarFrame.width, height: imageHeight)
            tutorialImageView.frame = tutorialView.bounds
            tutorialTitleLabel.text = "'레고팡팡 가맹점'을 선택하세요!"
            tutorialTitleLabel.frame = CGRect(x: 20, y: tutorialView.frame.minY-35, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 30)
            
            tutorialImageView.frame.origin.y = 20
            tutorialImageView.contentMode = .scaleAspectFill
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
            
        } else if level == 3 {
            
            tutorialView.frame = CGRect(x: UIScreen.main.bounds.width-110, y: y, width: 100, height: 45)
            tutorialImageView.frame.origin = CGPoint(x: tutorialView.bounds.midX-80.67/2, y: tutorialView.bounds.minY+10)
            tutorialImageView.frame.size = CGSize(width: 80.67, height: 25)
            tutorialTitleLabel.frame = .zero
            
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
            
        } else if level == 4 {
            
            tutorialView.frame = CGRect(x: UIScreen.main.bounds.width/2-150, y: y, width: 300, height: imageHeight)
            tutorialImageView.frame = tutorialView.bounds
            tutorialTitleLabel.text = "'쿠폰'을 받아보세요!"
            tutorialTitleLabel.frame = CGRect(x: tutorialView.frame.minX, y: tutorialView.frame.maxY+5, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 30)
            
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
            
            let couponDownloadButton = UIButton()
            couponDownloadButton.frame = CGRect(x: tutorialView.bounds.minX, y: tutorialView.bounds.maxY-44, width: tutorialView.frame.width, height: 44)
            couponDownloadButton.addTarget(self, action: #selector(couponDownloadButton(_:)), for: .touchUpInside)
            tutorialView.addSubview(couponDownloadButton)
        } else if level == 5 {
            
            tutorialView.frame = CGRect(x: UIScreen.main.bounds.midX-140, y: y, width: 280, height: imageHeight)
            tutorialView.layer.cornerRadius = 15
            tutorialImageView.frame = tutorialView.bounds
            tutorialTitleLabel.text = "'쿠폰함'으로 이동하세요!"
            tutorialTitleLabel.frame = CGRect(x: tutorialView.frame.midX, y: tutorialView.frame.maxY+5, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 30)
            
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
            
            let blurView_1 = UIView()
            blurView_1.backgroundColor = .black.withAlphaComponent(0.3)
            blurView_1.frame.origin = tutorialView.bounds.origin
            blurView_1.frame.size = CGSize(width: tutorialView.bounds.width, height: tutorialView.bounds.height-40)
            blurView_1.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
            tutorialView.addSubview(blurView_1)
            
            let blurView_2 = UIView()
            blurView_2.backgroundColor = .black.withAlphaComponent(0.3)
            blurView_2.frame.origin = CGPoint(x: tutorialView.bounds.origin.x, y: blurView_1.bounds.maxY)
            blurView_2.frame.size = CGSize(width: tutorialView.bounds.width/2, height: 40)
            blurView_2.roundCorners(corners: [.layerMinXMaxYCorner], radius: 15)
            tutorialView.addSubview(blurView_2)
        } else if level == 6 {
            
            tutorialView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height+130, width: UIApplication.shared.statusBarFrame.width, height: imageHeight)
            tutorialImageView.frame = tutorialView.bounds
            tutorialTitleLabel.text = "'쿠폰 사용하기'를 눌러 매장 직원을 통해\n쿠폰을 사용할 수 있어요!"
            tutorialTitleLabel.frame = CGRect(x: 20, y: tutorialView.frame.maxY+5, width: stringWidth(text: tutorialTitleLabel.text!, fontSize: 10)+20, height: 45)
            tutorialTitleLabel.numberOfLines = 2
            
            tutorialImageView.frame.origin.y = 10
            tutorialImageView.contentMode = .scaleAspectFill
            tutorialImageView.image = image
            tutorialView.addSubview(tutorialImageView)
        }
        
        tutorialView.tag = level
        tutorialView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tutorialView(_:))))
    }
    
    @objc func tutorialView(_ sender: UITabBarController) {
        
        guard let sender = sender.view else { return }
        guard let delegate = UIViewController.TabBarControllerDelegate else { return }
        
        if sender.tag == 4 { return }
        
        for view in view.subviews { if backButton != view { view.removeFromSuperview() } }
        for view in tutorialView.subviews { view.removeFromSuperview() }
        
        if sender.tag == 0 {
            
            delegate.selectedIndex = 1
            
            if let delegate_1 = UIViewController.CategoryViewControllerDelegate {
                delegate_1.gridView.reloadData()
            }
            
        } else if sender.tag == 1, let delegate_1 = UIViewController.CategoryViewControllerDelegate, UIViewController.appDelegate.CategoryObject.count > 0 {
            
            let segue = delegate_1.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
            segue.usePangpang = delegate_1.pangpangSwitch.isOn; segue.position = 0
            delegate_1.navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 2, let delegate_2 = UIViewController.StoreViewControllerDelegate, delegate_2.StoreObject.count > 0 {
            
            let segue = delegate_2.storyboard?.instantiateViewController(withIdentifier: "StoreDetailViewController") as! StoreDetailViewController
            segue.StoreObject = delegate_2.StoreObject; segue.row = 0
            delegate_2.navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 3, let delegate_3 = UIViewController.StoreDetailViewControllerDelegate {

            let segue = delegate_3.storyboard?.instantiateViewController(withIdentifier: "PangpangCouponViewController") as! PangpangCouponViewController
            segue.modalPresentationStyle = .overFullScreen
            segue.type = "download"; segue.StoreObject = delegate_3.StoreObject[delegate_3.row]
            delegate_3.present(segue, animated: false, completion: nil)
            
        } else if sender.tag == 5 {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
            segue.tutorial = true
            delegate.navigationController?.pushViewController(segue, animated: true)
            
        } else if sender.tag == 6 {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            segue.modalPresentationStyle = .overFullScreen
            segue.type = "tutorial_end"
            present(segue, animated: false, completion: nil)
            
//            let alert = UIAlertController(title: "튜토리얼 모드 종료", message: "튜토리얼 모든 과정을 다하였습니다.\n 이제 팡팡하게 누려보세요!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: { _ in
//
//                UIViewController.TutorialViewControllerDelegate = nil
//
//                self.dismiss(animated: false) {
//                    if let delegate_1 = UIViewController.StoreDetailViewControllerDelegate {
//                        delegate_1.navigationController?.popViewController(animated: false)
//                    }
//                    if let delegate_2 = UIViewController.StoreDetailViewControllerDelegate {
//                        delegate_2.navigationController?.popViewController(animated: false)
//                    }
//                    if let delegate_3 = UIViewController.StoreViewControllerDelegate {
//                        delegate_3.navigationController?.popViewController(animated: false)
//                    }
//                    if let delegate_4 = UIViewController.TabBarControllerDelegate {
//                        delegate_4.selectedIndex = 2
//                    }
//                }
//            }))
//            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func couponDownloadButton(_ sender: UIButton) {
        
        guard let delegate = UIViewController.PangpangCouponViewControllerDelegate else { return }
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.main.async {
            
            let timestamp: String = "\(delegate.setKoreaTimestamp())"
            
            let memberPangpangHistoryParams: [String: Any] = [
                timestamp: [
                    "receive_time": timestamp,
                    "review_idx": "",
                    "use_menu": delegate.StoreObject.pangpangMenu,
                    "use_store_id": delegate.StoreObject.storeId,
                    "use_store_name": delegate.StoreObject.storeName,
                    "use_time": "0",
                    "write_review": "false"
                ]
            ]
            Firestore.firestore().collection("member_pangpang_history").document(UIViewController.appDelegate.MemberId).setData(memberPangpangHistoryParams, merge: true) { _ in
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            segue.modalPresentationStyle = .overFullScreen
            segue.type = "coupon_download"
            delegate.present(segue, animated: false, completion: nil)
        }
    }
}
