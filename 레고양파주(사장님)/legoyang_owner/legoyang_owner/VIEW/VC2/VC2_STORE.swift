//
//  VC2_STORE.swift
//  legoyang_owner
//
//  Created by Busan Dynamic on 2023/03/09.
//

import UIKit
import ImageSlideshow
import MapKit

// 스토어
class VC2_STORE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var STORE_ID: String = ""
    
    var OBJ_STORE: [API_USER] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var HEADER_V: UIView!
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var SCROLLVIEW: UIScrollView!
    
    @IBOutlet weak var SLIDER_I: ImageSlideshow!
    @IBOutlet weak var SLIDER_H: NSLayoutConstraint!
    @IBOutlet weak var PAGE_L: UILabel!
    
    @IBOutlet weak var QUOTE_LEFT_I: UIImageView!
    @IBOutlet weak var STORE_L: UILabel!
    @IBOutlet weak var QUOTE_RIGHT_I: UIImageView!
    @IBOutlet weak var SHARE_B: UIButton!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
    @IBOutlet weak var ADDRESS_L: UILabel!
    @IBOutlet weak var OPENTIME_L: UILabel!
    
    @IBOutlet weak var MENUS_V: UIView!
    @IBOutlet weak var MENUS_L: UILabel!
    
    @IBOutlet weak var STORE_L1: UILabel!
    @IBOutlet weak var STORE_L2: UILabel!
    @IBOutlet weak var STORE_L3: UILabel!
    @IBOutlet weak var STORE_L4: UILabel!
    @IBOutlet weak var STORE_L5: UILabel!
    
    @IBOutlet weak var MKMAPVIEW: MKMapView!
    
    override func loadView() {
        super.loadView()
        
        HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0
        
        MKMAPVIEW.showsScale = true; MKMAPVIEW.isRotateEnabled = true
        if #available(iOS 13.0, *) { MKMAPVIEW.overrideUserInterfaceStyle = .light }
        
        loadView2()
    }
    
    func loadView2() {
        
        let DATA = UIViewController.appDelegate.StoreObject[OBJ_POSITION]
        
        STORE_ID = DATA.storeId
        
        IMAGESLIDER(IV: SLIDER_I, IU: DATA.imageArray, PH: UIImage(), RD: 0, CM: .scaleAspectFill)
        SLIDER_H.constant = UIApplication.shared.statusBarFrame.height
        if DATA.imageArray.count > 0 { PAGE_L.text = "1 / \(DATA.imageArray.count)" } else { PAGE_L.text = "-" }
        
        QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[DATA.storeColor] ?? "quote_left0")
        STORE_L.text = " \(DATA.storeName) "
        QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[DATA.storeColor] ?? "quote_right0")
        SUBJECT_L.text = DATA.storeSubTitle
        CONTENTS_L.text = DT_CHECK(DATA.storeEtc)
        ADDRESS_L.text = "주소: \(DT_CHECK(DATA.storeAddress))"
        OPENTIME_L.text = "영업시간: \(DT_CHECK(DATA.storeTime))"
        
        var menu: String = ""
        for data in DATA.storeMenu {
            if data.menuPrice.rangeOfCharacter(from: CharacterSet(charactersIn: "1234567890").inverted) != nil {
                menu.append("#\(data.menuName)(\(data.menuPrice)) ")
            } else {
                menu.append("#\(data.menuName)(\(NF.string(from: (Int(data.menuPrice) ?? 0) as NSNumber) ?? "0")원) ")
            }
        }; if DATA.storeMenu.count > 0 { MENUS_V.isHidden = false; MENUS_L.text = menu } else { MENUS_V.isHidden = true }
        
        STORE_L1.text = DT_CHECK(DATA.ownerName)
        STORE_L2.text = DT_CHECK(DATA.storeName)
        STORE_L3.text = DT_CHECK(DATA.storeAddress)
        STORE_L4.text = NUMBER("phone", DATA.storeTel)
        STORE_L5.text = NUMBER("company", DATA.storeRegnum)
        
        MKMAPVIEW.removeAnnotations(MKMAPVIEW.annotations)
        
        if (DATA.lat != "") && (DATA.lon != "") && (DATA.lat != "0.0") && (DATA.lon != "0.0") {
            
            let ANNOTATION = MKPointAnnotation()
            ANNOTATION.title = DATA.storeName
            ANNOTATION.subtitle = DATA.storeAddress
            ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(DATA.lat) ?? 0.0, longitude: Double(DATA.lon) ?? 0.0)
            MKMAPVIEW.addAnnotation(ANNOTATION)
            
            let COORDINATE = CLLocationCoordinate2D(latitude: Double(DATA.lat) ?? 0.0, longitude: Double(DATA.lon) ?? 0.0)
            let SPAN = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
            MKMAPVIEW.setRegion(REGION, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SCROLLVIEW.delegate = self
        
        SLIDER_I.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(true)
    }
}

extension VC2_STORE: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if UIViewController.appDelegate.StoreObject[OBJ_POSITION].imageArray.count > 0 { PAGE_L.text = "\(page+1) / \(UIViewController.appDelegate.StoreObject[OBJ_POSITION].imageArray.count)" } else { PAGE_L.text = "-" }
    }
}

extension VC2_STORE: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let OFFSET_Y = scrollView.contentOffset.y
        let SLIDER_H = SLIDER_I.frame.maxY-HEADER_V.frame.height
        if OFFSET_Y > SLIDER_H { HEADER_V.backgroundColor = .white.withAlphaComponent((OFFSET_Y-SLIDER_H)/50); LINE_V.alpha = 0.05 } else { HEADER_V.backgroundColor = .white.withAlphaComponent(0.0); LINE_V.alpha = 0.0 }
    }
}
