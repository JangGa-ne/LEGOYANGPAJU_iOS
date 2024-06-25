//
//  S_CONTROLLER.swift
//  Horticulture
//
//  Created by 장 제현 on 2021/10/07.
//

import UIKit

extension UIViewController {
    
    static var LoadingViewControllerDelegate: VC_LOADING? = nil
    static var TabBarControllerDelegate: TBC? = nil
    static var MarketViewControllerDelegate: VC0_MAIN? = nil
    static var PangpangViewControllerDelegate: VC1_MAIN? = nil
    static var StoreViewControllerDelegate: VC2_MAIN? = nil
    static var StoreEditViewControllerDelegate: VC3_MAIN? = nil
    static var QuestionViewControllerDelegate: QuestionViewController? = nil
    
    static var VC_SIGNUP_DEL: VC_SIGNUP?
    static var VC0_MAIN_DEL: VC0_MAIN?
    static var VC1_MAIN_DEL: VC1_MAIN?
    static var VC_QRSCAN_DEL: VC_QRSCAN?
    static var VC2_MAIN_DEL: VC2_MAIN?
    static var VC3_MAIN_DEL: VC3_MAIN?
    static var VC3_STORE_EDIT_DEL: VC3_STORE_EDIT?
    static var VC_SETTING_DEL: VC_SETTING?
    static var VC_LEPAY_DEL: VC_LEPAY?
    
    func PRESENT_TBC(IDENTIFIER: String, INDEX: Int) {
        
        let TBC = storyboard?.instantiateViewController(withIdentifier: IDENTIFIER) as! UITabBarController
        TBC.selectedIndex = INDEX
        navigationController?.pushViewController(TBC, animated: true)
    }
    
    func segueViewController(identifier: String) {
        
        let VC = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(VC!, animated: true)
    }
}

/// 내비게이션 설정
extension UIViewController: UIGestureRecognizerDelegate {
    
    func BACK_GESTURE(_ BOOL: Bool) {
        UIViewController.AD.SWIPE_GESTURE = BOOL
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return UIViewController.AD.SWIPE_GESTURE
    }
}

extension UINavigationController {

    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin(); CATransaction.setCompletionBlock(completion); pushViewController(viewController, animated: animated); CATransaction.commit()
    }
}
