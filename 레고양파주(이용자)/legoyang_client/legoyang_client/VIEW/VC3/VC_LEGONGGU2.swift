//
//  VC_LEGONGGU2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/13.
//

import UIKit
import ImageSlideshow

class VC_LEGONGGU2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_LEGONGGU: [API_LEGONGGU] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_OPTION: [API_OPTION] = []
    
    @IBOutlet weak var HEADER_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var SLIDER_H: NSLayoutConstraint!
    @IBOutlet weak var PAGE_L: UILabel!
    
    @IBOutlet weak var TIMER_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
    
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var ITEM_PRICE_L: UILabel!
    @IBOutlet weak var PRICE_L: UILabel!
    @IBOutlet weak var POINT_I: UIImageView!
    @IBOutlet weak var DELIVERY_L: UILabel!
    @IBOutlet weak var SHARE_B: UIButton!
    
    @IBOutlet weak var EDIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_LEGONGGU2_DEL = self
        
        HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0
        
        let DATA = OBJ_LEGONGGU[OBJ_POSITION]
        
        IMAGESLIDER(IV: SLIDER_I, IU: DATA.ITEM_IMG, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
        SLIDER_H.constant = UIApplication.shared.statusBarFrame.height
        if DATA.ITEM_IMG.count > 0 { PAGE_L.text = "1 / \(DATA.ITEM_IMG.count)" } else { PAGE_L.text = "-" }
        
        var TIMESTAMP = (Int(DATA.END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970)); TIMER_L.text = FM_TIMER(TIMESTAMP: TIMESTAMP)
        let TIMER = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            TIMESTAMP = TIMESTAMP - 1; self.TIMER_L.text = self.FM_TIMER(TIMESTAMP: TIMESTAMP)
        }
        if FM_TIMER(TIMESTAMP: TIMESTAMP) == "마감" { TIMER.invalidate(); COUNT_L.text = "-" } else { COUNT_L.text = "\(DATA.REMAIN_COUNT)" }
        
        SUBJECT_L.text = DATA.ITEM_NAME
        CONTENTS_L.text = DATA.ITEM_CONTENT
        ITEM_PRICE_L.text = DATA.ITEM_PRICE
        PRICE_L.text = "\(NF.string(from: (Int(DATA.ITEM_BASEPRICE) ?? 0) as NSNumber) ?? "0")원"
        if DATA.ITEM_SALEINFO.contains("적립") { POINT_I.isHidden = false } else { POINT_I.isHidden = true }
        DELIVERY_L.text = DATA.ITEM_SALEINFO
        
        GET_OPTION(NAME: "옵션선택", AC_TYPE: "legonggu_options")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        SLIDER_I.delegate = self
        
        SHARE_B.addTarget(self, action: #selector(SHARE_B(_:)), for: .touchUpInside)
        
        EDIT_B.addTarget(self, action: #selector(EDIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func SHARE_B(_ sender: UIButton) { UIImpactFeedbackGenerator().impactOccurred()
        
        if OBJ_LEGONGGU.count > 0 {
            
            let DATA = OBJ_LEGONGGU[OBJ_POSITION]
            
            var IMAGE: String = ""
            if DATA.ITEM_MAINIMG != "" { IMAGE = DATA.ITEM_MAINIMG } else if DATA.ITEM_IMG.count > 0 { IMAGE = DATA.ITEM_IMG[0] }
            
            setShare(title: DATA.ITEM_NAME, description: DATA.ITEM_PRICE, imageUrl: IMAGE, params: "item_name=\(DATA.ITEM_NAME)&type=legonggu")
        } else {
            S_NOTICE("오류 (!)")
        }
    }
    
    @objc func EDIT_B(_ sender: UIButton) {
        
        if UserDefaults.standard.string(forKey: "member_id") ?? "" == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            
            let DATA = OBJ_LEGONGGU[OBJ_POSITION]
            let TIMESTAMP = (Int(DATA.END_TIME) ?? 0) - Int(floor(Date().timeIntervalSince1970))
            
            let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
            if (TIMESTAMP <= 0) && (MEMBER_ID != "01031870005") && (MEMBER_ID != "01031853309") {
                S_NOTICE("마감된 공구")
            } else {
                let VC = storyboard?.instantiateViewController(withIdentifier: "VC_OPTION3") as! VC_OPTION3
                VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
                VC.OBJ_LEGONGGU = OBJ_LEGONGGU; VC.OBJ_POSITION = OBJ_POSITION; VC.OBJ_OPTION = OBJ_OPTION
                present(VC, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_LEGONGGU2: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        PAGE_L.text = "\(page+1) / \(OBJ_LEGONGGU[OBJ_POSITION].ITEM_IMG.count)"
    }
}

extension VC_LEGONGGU2: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let SLIDER_H = SLIDER_I.frame.maxY-HEADER_V.frame.height
        if OFFSET_Y > SLIDER_H { HEADER_V.backgroundColor = .white.withAlphaComponent((OFFSET_Y-SLIDER_H)/50); LINE_V.alpha = 0.05 } else { HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0 }
    }
}
