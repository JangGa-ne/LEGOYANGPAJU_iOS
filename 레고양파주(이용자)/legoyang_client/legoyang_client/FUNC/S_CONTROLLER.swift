//
//  S_CONTROLLER.swift
//  Horticulture
//
//  Created by 장 제현 on 2021/10/07.
//

import UIKit

extension UIViewController {
    
    static var CategoryGridCellDelegate: CategoryGridCell? = nil
    
    static var TabBarControllerDelegate: TabBarController? = nil
    static var LoadingViewControllerDelegate: LoadingViewController? = nil
    static var LoginAAViewControllerDelegate: LoginAAViewController? = nil
    static var PhoneCheckViewControllerDelegate: PhoneCheckViewController? = nil
    static var MainViewControllerDelegate: MainViewController? = nil
    static var PopupViewControllerDelegate: PopupViewController? = nil
    static var SearchViewControllerDelegate: SearchViewController? = nil
    static var CategoryViewControllerDelegate: CategoryViewController? = nil
    static var StoreViewControllerDelegate: StoreViewController? = nil
    static var StoreDetailViewControllerDelegate: StoreDetailViewController? = nil
    static var PangpangCouponViewControllerDelegate: PangpangCouponViewController? = nil
    static var LegongguViewControllerDelegate: LegongguViewController? = nil
    static var LegongguDetailViewControllerDelegate: LegongguDetailViewController? = nil
    static var LegongguOptionViewControllerDelegate: LegongguOptionViewController? = nil
    static var MyPageViewControllerDelegate: MyPageViewController? = nil
    static var MyPageViewController2Delegate: MyPageViewController2? = nil
    static var CouponViewControllerDelegate: CouponViewController? = nil
    static var CouponPasswordViewControllerDelegate: CouponPasswordViewController? = nil
    static var WantViewControllerDelegate: WantViewController? = nil
    static var BasketViewControllerDelegate: BasketViewController? = nil
    static var OrderViewControllerDelegate: OrderViewController? = nil
    static var SafariViewControllerDelegate: SafariViewController? = nil
    static var LocationAuthorityViewControllerDelegate: LocationAuthorityViewController? = nil
    static var GeoMapViewControllerDelegate: GeoMapViewController? = nil
    static var StoreTableViewControllerDelegate: StoreTableViewController? = nil
    static var AroundListViewControllerDelegate: AroundListViewController? = nil
    static var AlertViewControllerDelegate: AlertViewController? = nil
    static var NoticeViewControllerDelegate: NoticeViewController? = nil
    static var SettingViewControllerDelegate: SettingViewController? = nil
    static var TutorialViewControllerDelegate: TutorialViewController? = nil
    static var EventViewControllerDelegate: EventViewController? = nil
    static var EventDetailViewControllerDelegate: EventDetailViewController? = nil
    static var MyEventViewControllerDelegate: MyEventViewContoller? = nil
    
    static var LoginViewController_DEL: LoginViewController?
    static var VC_SIGNUP_DEL: VC_SIGNUP?
    static var VC_FIND_DEL: VC_FIND?
    
    static var TBC_DEL: TBC?
    static var VC_MAP1_DEL: VC_MAP1?
    static var VC_MAP2_DEL: VC_MAP2?
    static var VC_MAIN_DEL: VC_MAIN?
    static var VC_MORE_DEL: VC_MORE?
    static var VC_COUPON_DEL: VC_COUPON?
    
    static var VC_NOTICE_DEL: VC_NOTICE?
    static var VC_AROUND_DEL: VC_AROUND?
    
    static var VC_DETAIL1_DEL: VC_DETAIL1?
    static var VC_LEGONGGU1_DEL: VC_LEGONGGU1?
    static var VC_LEGONGGU2_DEL: VC_LEGONGGU2?
    static var VC_BASKET_DEL: VC_BASKET?
    static var VC_DETAIL4_DEL: VC_DETAIL4?
    static var VC_LEGOPANGPANG_DEL: VC_LEGOPANGPANG?
    
    static var VC_ORDER1_DEL: VC_ORDER1?
    static var VC_ORDER2_DEL: VC_ORDER2?
    
    func segueTabBarController(identifier: String, idx: Int, animated: Bool = true) {
        
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: identifier) as! UITabBarController
        tabBarController.selectedIndex = idx
        navigationController?.pushViewController(tabBarController, animated: animated)
    }
    
    func segueViewController(identifier: String, animated: Bool = true) {
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(viewController!, animated: animated)
    }
}

/// 내비게이션 설정
extension UIViewController: UIGestureRecognizerDelegate {
    
    func setBackSwipeGesture(_ bool: Bool) {
        UIViewController.appDelegate.backSwipeGesture = bool
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        return UIViewController.appDelegate.backSwipeGesture
    }
}

extension UINavigationController {

    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin(); CATransaction.setCompletionBlock(completion); pushViewController(viewController, animated: animated); CATransaction.commit()
    }
    
    public func popViewController(animated: Bool, completion: (() -> Void)?) {
        CATransaction.begin(); CATransaction.setCompletionBlock(completion); popViewController(animated: animated); CATransaction.commit()
    }
}
