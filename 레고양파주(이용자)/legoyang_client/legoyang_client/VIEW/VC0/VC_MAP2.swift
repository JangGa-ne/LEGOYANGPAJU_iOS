//
//  VC_MAP2.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/25.
//

import UIKit
import MapKit
import CoreLocation

class VC_MAP2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LEGOPANGPANG: Bool = false
    
    var OBJ_CATEGORY: [API_CATEGORY] = []
    var OBJ_POSITION: Int = 0
    
    var OBJ_MAP: [API_STORE] = []
    
    var StoreObject: [StoreData] = []
    
    var ANNOTATIONS = [MKPointAnnotation]()
    var ANNOTATION = MKPointAnnotation()
    
    var CL_MANAGER = CLLocationManager()
    var LAT: Double = 0.0
    var LON: Double = 0.0
    var NAME: String = ""
    var ADDRESS: String = ""
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    @IBOutlet weak var LEGOPANGPANG_EV: UIVisualEffectView!
    @IBOutlet weak var MKMAPVIEW: MKMapView!
    @IBOutlet weak var REFRESH_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_MAP2_DEL = self
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 0; LAYOUT.minimumInteritemSpacing = 10
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: false, completion: nil)
        
        MKMAPVIEW.showsScale = true; MKMAPVIEW.isRotateEnabled = false
        if #available(iOS 13.0, *) { MKMAPVIEW.overrideUserInterfaceStyle = .light }
        
        if LEGOPANGPANG {
            LEGOPANGPANG_EV.layer.borderColor = UIColor.H_FF6F00.cgColor
        } else {
            LEGOPANGPANG_EV.layer.borderColor = UIColor.lightGray.cgColor
        }
        
//        GET_MAP(NAME: "레고탐색", AC_TYPE: "store")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self
        
        MKMAPVIEW.delegate = self
        
        LEGOPANGPANG_EV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LEGOPANGPANG_EV(_:))))
        REFRESH_B.addTarget(self, action: #selector(REFRESH_B(_: )), for: .touchUpInside)
        
        loadingData()
    }
    
    func loadingData() {
        
        StoreObject.removeAll(); MKMAPVIEW.removeAnnotations(MKMAPVIEW.annotations); ANNOTATIONS.removeAll()
        
        ANNOTATION.title = "내위치"
        ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: CL_MANAGER.location?.coordinate.latitude ?? 0.0, longitude: CL_MANAGER.location?.coordinate.longitude ?? 0.0)
        MKMAPVIEW.addAnnotation(ANNOTATION)
        
        for data in UIViewController.appDelegate.StoreObject {
            
            if (data.storeCategory == OBJ_CATEGORY[OBJ_POSITION].NAME) && (data.lat != "") && (data.lon != "") && (data.lat != "0.0") && (data.lon != "0.0") && (data.usePangpang == "\(LEGOPANGPANG)") {
                
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = data.storeName
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0.0, longitude: Double(data.lon) ?? 0.0)
                MKMAPVIEW.addAnnotation(ANNOTATION); ANNOTATIONS.append(ANNOTATION)
                
                StoreObject.append(data)
            }
        }
        
        let COORDINATE = CLLocationCoordinate2D(latitude: CL_MANAGER.location?.coordinate.latitude ?? 0.0, longitude: CL_MANAGER.location?.coordinate.longitude ?? 0.0)
        let SPAN = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
        MKMAPVIEW.setRegion(REGION, animated: true)
        
        COLLECTIONVIEW.reloadData()
    }
    
    @objc func LEGOPANGPANG_EV(_ sender: UITapGestureRecognizer) { UIImpactFeedbackGenerator().impactOccurred()
        
        if !LEGOPANGPANG {
            LEGOPANGPANG = true; sender.view?.layer.borderColor = UIColor.H_FF6F00.cgColor
        } else {
            LEGOPANGPANG = false; sender.view?.layer.borderColor = UIColor.lightGray.cgColor
        }; //GET_MAP(NAME: "레고탐색", AC_TYPE: "store")
        loadingData()
        
        if let BVC = UIViewController.VC_MAP1_DEL { BVC.LEGOPANGPANG = LEGOPANGPANG; BVC.TABLEVIEW.reloadData() }
    }
    
    func viewDidLoad2() {
        
        MKMAPVIEW.removeAnnotations(MKMAPVIEW.annotations); ANNOTATIONS.removeAll()
        
        ANNOTATION.title = "내위치"
        ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: CL_MANAGER.location?.coordinate.latitude ?? 0.0, longitude: CL_MANAGER.location?.coordinate.longitude ?? 0.0)
        MKMAPVIEW.addAnnotation(ANNOTATION)
        
        for (_, DATA) in OBJ_MAP.enumerated() {
            
            if (DATA.LAT != "") && (DATA.LON != "") && (DATA.LAT != "0.0") && (DATA.LON != "0.0") {
                
                let ANNOTATION = MKPointAnnotation()
                ANNOTATION.title = DATA.ST_NAME
                ANNOTATION.coordinate = CLLocationCoordinate2D(latitude: Double(DATA.LAT) ?? 0.0, longitude: Double(DATA.LON) ?? 0.0)
                MKMAPVIEW.addAnnotation(ANNOTATION); ANNOTATIONS.append(ANNOTATION)
            }
        }
        
        let COORDINATE = CLLocationCoordinate2D(latitude: CL_MANAGER.location?.coordinate.latitude ?? 0.0, longitude: CL_MANAGER.location?.coordinate.longitude ?? 0.0)
        let SPAN = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
        MKMAPVIEW.setRegion(REGION, animated: true)
    }
    
    @objc func REFRESH_B(_ sender: UIButton) {
////        viewDidLoad2()
//        GET_MAP(NAME: "레고탐색", AC_TYPE: "store")
        loadingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_MAP2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if OBJ_CATEGORY.count > 0 { return OBJ_CATEGORY.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let DATA = OBJ_CATEGORY[indexPath.item]
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_STORE_1", for: indexPath) as! CC_STORE
        
        if indexPath.item == OBJ_POSITION {
            CELL.backgroundColor = .H_00529C; CELL.TITLE_L.textColor = .white
        } else {
            CELL.backgroundColor = .H_F4F4F4; CELL.TITLE_L.textColor = .black.withAlphaComponent(0.5)
        }
        
        CELL.TITLE_L.text = DATA.NAME
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { UIImpactFeedbackGenerator().impactOccurred()
//        OBJ_POSITION = indexPath.item; GET_MAP(NAME: "레고탐색", AC_TYPE: "store"); COLLECTIONVIEW.reloadData()
        OBJ_POSITION = indexPath.item; loadingData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (OBJ_CATEGORY[indexPath.item].NAME.count * 12) + 40, height: 40)
    }
}

extension VC_MAP2: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let CLUSTER = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        CLUSTER.subtitle = nil
        return CLUSTER
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let MARKER = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        MARKER.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        MARKER.clusteringIdentifier = "cluster"
        MARKER.glyphTintColor = .clear
        MARKER.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MARKER(_:))))
        
        if annotation.title != "내위치" { MARKER.removeFromSuperview(); MARKER.markerTintColor = .clear; MARKER.glyphImage = UIImage() }
        
        let IMAGE = UIImageView(frame: CGRect(x: -10, y: -25, width: 50, height: 50))
        IMAGE.backgroundColor = .white
        IMAGE.layer.borderWidth = 3; IMAGE.layer.borderColor = UIColor.white.cgColor
        IMAGE.clipsToBounds = true
        
        for (i, data) in StoreObject.enumerated() {
            
            if data.storeName == annotation.title { MARKER.tag = i
                
                if data.storeName != "" {
                    setImageNuke(imageView: IMAGE, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 7.5, contentMode: .scaleAspectFill)
                } else if data.imageArray.count > 0 {
                    setImageNuke(imageView: IMAGE, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 7.5, contentMode: .scaleAspectFill)
                } else {
                    IMAGE.layer.cornerRadius = 7.5; IMAGE.clipsToBounds = true
                    IMAGE.image = UIImage(named: "logo2")
                }; MARKER.addSubview(IMAGE)
                
                if let CLUSTER = annotation as? MKClusterAnnotation, (annotation.title != "내위치") {
                    
                    let COUNT = CLUSTER.memberAnnotations.count
                    let LABEL = UILabel(frame: CGRect(x: IMAGE.frame.maxX-CGFloat((STRING_WIDTH(TEXT: "\(COUNT)", FONT_SIZE: 12))+15)+10, y: IMAGE.frame.minY-5, width: CGFloat((STRING_WIDTH(TEXT: "\(COUNT)", FONT_SIZE: 12))+15), height: 20))
                    LABEL.backgroundColor = .systemBlue
                    LABEL.layer.cornerRadius = 10; LABEL.clipsToBounds = true
                    LABEL.textAlignment = .center
                    LABEL.textColor = .white
                    LABEL.font = .boldSystemFont(ofSize: 12)
                    LABEL.text = "\(COUNT)"
                    MARKER.addSubview(LABEL)
                }
                
                return MARKER
            }
        }; MARKER.canShowCallout = true; return nil
    }
    
    @objc func MARKER(_ sender: UITapGestureRecognizer) {
        ALERT2(BG: view, TIME: 0.5)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
            
            let memberAnnotations = clusterAnnotation.memberAnnotations
            let memberAnnotationsIndexes = memberAnnotations.compactMap { ANNOTATIONS.firstIndex(of: $0 as! MKPointAnnotation) }

            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_OPTION1") as! VC_OPTION1
            VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
            VC.OBJ_STORE = StoreObject; VC.OBJ_POSTION = memberAnnotationsIndexes
            present(VC, animated: true, completion: nil)
        } else {

            guard let annotationIndex = ANNOTATIONS.firstIndex(of: view.annotation as! MKPointAnnotation) else { return }

            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_OPTION2") as! VC_OPTION2
            VC.modalPresentationStyle = .overCurrentContext; VC.transitioningDelegate = self
            VC.OBJ_STORE = StoreObject; VC.OBJ_POSITION = annotationIndex
            present(VC, animated: true, completion: nil)

//            let COORDINATE = CLLocationCoordinate2D(latitude: view.annotation?.coordinate.latitude ?? 0.0, longitude: view.annotation?.coordinate.longitude ?? 0.0)
//            let SPAN = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//            let REGION = MKCoordinateRegion(center: COORDINATE, span: SPAN)
//            MKMAPVIEW.setRegion(REGION, animated: true)
        }
        
        DispatchQueue.main.async { self.MKMAPVIEW.deselectAnnotation(view.annotation, animated: false) }
    }
}
