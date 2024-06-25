//
//  AlertViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var type: String = ""
    
    @IBOutlet weak var AlertView: UIMainView!
    @IBOutlet weak var noticeImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var explainReviewView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.AlertViewControllerDelegate = self
        
        explainReviewView.isHidden = true
        explainReviewView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(explainReviewView(_:))))
        
        cancelButton.addTarget(self, action: #selector(cancelButton(_:)), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(actionButton(_:)), for: .touchUpInside)
        
        if type == "coupon_download" {
            noticeImageView.image = UIImage(named: "check_on")
            mainTitleLabel.text = "쿠폰이 발급 되었습니다."
            subTitleLabel.text = "고양 파주에서 팡팡하게 누리세요!"
            cancelButton.setTitle("확인", for: .normal)
            actionButton.setTitle("쿠폰함으로 이동", for: .normal)
        } else if type == "coupon_notUse" {
            noticeImageView.image = UIImage(named: "alert_notice")
            mainTitleLabel.text = "이미 받은 쿠폰이 있습니다."
            subTitleLabel.text = "쿠폰함에서 확인해 보세요!"
            cancelButton.setTitle("확인", for: .normal)
            actionButton.setTitle("쿠폰함으로 이동", for: .normal)
        } else if (type == "coupon_review") || (type == "coupon_review2") {
            noticeImageView.image = UIImage(named: "alert_notice")
            mainTitleLabel.text = "작성하지 않은 후기가 있습니다."
            subTitleLabel.text = "사용하신 레고팡팡 쿠폰 후기를 작성해 주세요!"
            explainReviewView.isHidden = false
            cancelButton.setTitle("확인", for: .normal)
            actionButton.setTitle("후기 작성하기", for: .normal)
        } else if type == "coupon_useCoupon" {
            noticeImageView.image = UIImage(named: "alert_notice")
            mainTitleLabel.text = "해당 쿠폰은 최근에 사용 했습니다."
            subTitleLabel.text = "재사용은 7일 이후 다운로드 가능해요!"
            cancelButton.setTitle("확인", for: .normal)
            actionButton.setTitle("", for: .normal)
            actionButton.isHidden = true
        } else if type == "tutorial_start" {
            noticeImageView.isHidden = true
            mainTitleLabel.text = "튜토리얼 모드"
            subTitleLabel.text = "튜토리얼 모드를 시작하시겠습니까?\n(레고팡팡 쿠폰 사용법)"
            cancelButton.setTitle("아니요", for: .normal)
            actionButton.setTitle("예", for: .normal)
        } else if type == "tutorial_stop" {
            noticeImageView.isHidden = true
            mainTitleLabel.text = "튜토리얼 모드"
            subTitleLabel.text = "튜토리얼 모드를 종료할 경우\n홈으로 돌아갑니다."
            cancelButton.setTitle("종료", for: .normal)
            actionButton.setTitle("계속하기", for: .normal)
        } else if type == "tutorial_end" {
            noticeImageView.isHidden = true
            mainTitleLabel.text = "튜토리얼 모드"
            subTitleLabel.text = "튜토리얼 모든 과정을 다하였습니다.\n 이제 팡팡하게 누려보세요!"
            cancelButton.setTitle("확인", for: .normal)
            actionButton.setTitle("", for: .normal)
            actionButton.isHidden = true
        }
        
        if type == "coupon_download", let delegate = UIViewController.TutorialViewControllerDelegate {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { delegate.loadingData(level: 5, image: self.AlertView.toImage(), y: self.AlertView.frame.minY, imageHeight: self.AlertView.frame.height) }
        }
    }
    
    @objc func explainReviewView(_ sender: UITapGestureRecognizer) {
        setPipMediaPlayer(linkUrl: "https://dl.dropboxusercontent.com/s/56dgqm8dr57ccso/review_guide.mp4", width: 40*5, height: 50*5)
    }
    
    @objc func cancelButton(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
        
        if (type == "tutorial_start") || (type == "tutorial_stop") || (type == "tutorial_end") {
            
            guard let delegate = UIViewController.TutorialViewControllerDelegate else { return }
            
            delegate.dismiss(animated: false) {
                
                if let delegate_1 = UIViewController.StoreDetailViewControllerDelegate {
                    delegate_1.navigationController?.popViewController(animated: false)
                }
                if let delegate_2 = UIViewController.StoreDetailViewControllerDelegate {
                    delegate_2.navigationController?.popViewController(animated: false)
                }
                if let delegate_3 = UIViewController.StoreViewControllerDelegate {
                    delegate_3.navigationController?.popViewController(animated: false)
                }
                if let delegate_4 = UIViewController.TabBarControllerDelegate {
                    delegate_4.selectedIndex = 2
                }
                
                UIViewController.TutorialViewControllerDelegate = nil
            }
        }
    }
    
    @objc func actionButton(_ sender: UIButton) {
        
        dismiss(animated: false, completion: nil)
        
        if (type == "coupon_download") || (type == "coupon_notUse"), let delegate = UIViewController.TabBarControllerDelegate {
            delegate.segueViewController(identifier: "CouponViewController")
        } else if type == "coupon_review", let delegate = UIViewController.TabBarControllerDelegate {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
            segue.position = 1
            delegate.navigationController?.pushViewController(segue, animated: true)
        } else if type == "coupon_review2", let delegate = UIViewController.CouponViewControllerDelegate {
            delegate.position = 1; delegate.loadingData()
        } else if type == "tutorial_start", let delegate = UIViewController.TabBarControllerDelegate {
            let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            segue.modalPresentationStyle = .overFullScreen
            delegate.present(segue, animated: false, completion: nil)
        }
    }
}
