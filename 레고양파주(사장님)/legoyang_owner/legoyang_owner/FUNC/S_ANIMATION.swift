//
//  S_ANIMATION.swift
//  APT
//
//  Created by 장 제현 on 2021/09/25.
//

import UIKit

// MARK: 뷰 에니메이션 설정
class S_ANIMATION: NSObject, UIViewControllerAnimatedTransitioning {
    
    var X_LEFT: Bool = false
    var X_RIGHT: Bool = false
    var Y_TOP: Bool = false
    var Y_BOTTOM: Bool = false
    var ALPHA: Bool = false
    var PRESENTING: Bool = false
    let DIMMING_VIEW = UIButton()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let TO_VC = transitionContext.viewController(forKey: .to),
            let FROM_VC = transitionContext.viewController(forKey: .from) else { return }
        
        let CONTAINER_VIEW = transitionContext.containerView
        
        let FINAL_WIDTH = TO_VC.view.bounds.width
        let FINAL_HEIGHT = TO_VC.view.bounds.height
        
        if PRESENTING {
            
            DIMMING_VIEW.backgroundColor = .black; DIMMING_VIEW.alpha = 0.0; DIMMING_VIEW.frame = CONTAINER_VIEW.bounds; CONTAINER_VIEW.addSubview(DIMMING_VIEW)
            
            if X_LEFT { TO_VC.view.frame = CGRect(x: -FINAL_WIDTH, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if X_RIGHT { TO_VC.view.frame = CGRect(x: FINAL_WIDTH, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if Y_TOP { TO_VC.view.frame = CGRect(x: 0.0, y: -FINAL_HEIGHT, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if Y_BOTTOM { TO_VC.view.frame = CGRect(x: 0.0, y: FINAL_HEIGHT, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            if ALPHA { TO_VC.view.frame = CGRect(x: 0.0, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT) }
            CONTAINER_VIEW.addSubview(TO_VC.view)
        }
        
        let DURATION = transitionDuration(using: transitionContext)
        let IS_CANCELLED = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: DURATION, animations: {
            
            if !self.ALPHA {
                
                let TRANSFORM = {
                    self.DIMMING_VIEW.alpha = 0.3
                    if self.X_LEFT { TO_VC.view.transform = CGAffineTransform(translationX: FINAL_WIDTH, y: 0.0) }
                    if self.X_RIGHT { TO_VC.view.transform = CGAffineTransform(translationX: -FINAL_WIDTH, y: 0.0) }
                    if self.Y_TOP { TO_VC.view.transform = CGAffineTransform(translationX: 0.0, y: FINAL_HEIGHT) }
                    if self.Y_BOTTOM { TO_VC.view.transform = CGAffineTransform(translationX: 0.0, y: -FINAL_HEIGHT) }
                }
                let IDENTITY = { self.DIMMING_VIEW.alpha = 0.0; FROM_VC.view.transform = .identity }
                
                self.PRESENTING ? TRANSFORM() : IDENTITY()
            } else {
                
                let TRANSFORM = { self.DIMMING_VIEW.alpha = 0.3; TO_VC.view.alpha = 1.0 }
                let IDENTITY = { self.DIMMING_VIEW.alpha = 0.0; FROM_VC.view.alpha = 0.0 }
                
                self.PRESENTING ? TRANSFORM() : IDENTITY()
            }
        }) { (_) in
            
            transitionContext.completeTransition(!IS_CANCELLED)
        }
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    static let TRANSITION: S_ANIMATION = S_ANIMATION()
}

// 회원가입(아이디 중복검사, 휴대전화 본인인증)
extension VC_SIGNUP {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
}
//
//// 아이디 및 비밀번호 찾기
//extension VC_FIND {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
//    }
//}

// 레고팡팡(상세조회 필터)
extension VC1_MAIN {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
}

// 내 사업장 정보("따옴표" 색상 바꾸기)
extension VC3_STORE_EDIT {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
}

// 환경설정(비밀번호 및 담당자정보 변경)
extension VC_SETTING {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
}

// 레pay(상세조회 필터)
extension VC_LEPAY {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = true; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        UIViewController.TRANSITION.PRESENTING = false; UIViewController.TRANSITION.Y_BOTTOM = true; return UIViewController.TRANSITION
    }
}
