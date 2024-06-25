//
//  GeoMapViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/15.
//

import UIKit
import MapKit
import PanModal

class GeoMapViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var usePangpang: Bool = false
    var position: Int = 0
    
    var StoreObject: [StoreData] = []
    
    var locationManager = CLLocationManager()
    var annotations = [MKPointAnnotation]()
    var annotation = MKPointAnnotation()
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pangpangView: UIVisualEffectView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.GeoMapViewControllerDelegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        mapView.showsScale = true; mapView.isRotateEnabled = false
        if #available(iOS 13.0, *) { mapView.overrideUserInterfaceStyle = .light }
        mapView.delegate = self
        
        if usePangpang {
            pangpangView.layer.borderColor = UIColor.H_FF6F00.cgColor
        } else {
            pangpangView.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        pangpangView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pangpangTap(_:))))
        refreshButton.addTarget(self, action: #selector(refreshButton(_:)), for: .touchUpInside)
        
        loadingData(); enlargement()
    }
    
    func loadingData() {
        
        StoreObject.removeAll(); annotations.removeAll(); mapView.removeAnnotations(mapView.annotations)
        
        annotation.title = "내위치"
        annotation.coordinate = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        mapView.addAnnotation(annotation)
        
        for data in UIViewController.appDelegate.StoreObject {
            
            if (data.storeCategory == UIViewController.appDelegate.CategoryObject[position].cateName) && (data.lat != "") && (data.lat != "0.0") && (data.lon != "") && (data.lon != "0.0") && (data.storeId != "01099999999") {
                
                if usePangpang && (data.usePangpang == "true") {
                    
                    StoreObject.append(data)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = data.storeName
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0.0, longitude: Double(data.lon) ?? 0.0)
                    annotations.append(annotation); mapView.addAnnotation(annotation)
                    
                } else if !usePangpang {
                    
                    StoreObject.append(data)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = data.storeName
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(data.lat) ?? 0.0, longitude: Double(data.lon) ?? 0.0)
                    annotations.append(annotation); mapView.addAnnotation(annotation)
                }
            }
        }
        
        gridView.reloadData()
    }
    
    func enlargement() {
        
        let coordicate = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordicate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func pangpangTap(_ sender: UITapGestureRecognizer) {
        
        usePangpang = !usePangpang
        
        if usePangpang {
            sender.view?.layer.borderColor = UIColor.H_FF6F00.cgColor
        } else {
            sender.view?.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        loadingData()
        
        if let refresh_1 = UIViewController.LocationAuthorityViewControllerDelegate {
            refresh_1.pangpangSwitch.isOn = usePangpang; refresh_1.gridView.reloadData()
        }
    }
    
    @objc func refreshButton(_ sender: UIButton) {
        loadingData(); enlargement()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension GeoMapViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.CategoryObject.count > 0 { return UIViewController.appDelegate.CategoryObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.CategoryObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NaviBarGridCell_1", for: indexPath) as! NaviBarGridCell
        
        if indexPath.row == position {
            cell.mainTitleLabel.layer.borderColor = UIColor.H_FF6F00.cgColor
            cell.mainTitleLabel.textColor = .H_FF6F00
            cell.mainTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        } else {
            cell.mainTitleLabel.layer.borderColor = UIColor.darkGray.cgColor
            cell.mainTitleLabel.textColor = .black
            cell.mainTitleLabel.font = UIFont.systemFont(ofSize: 14)
        }
        cell.mainTitleLabel.layer.borderWidth = 0.5
        cell.mainTitleLabel.text = data.cateName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        position = indexPath.row; loadingData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: stringWidth(text: UIViewController.appDelegate.CategoryObject[indexPath.row].cateName, fontSize: 14)+40, height: 40)
    }
}

extension GeoMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        
        let cluster = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        cluster.subtitle = nil
        return cluster
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        markerView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        markerView.clusteringIdentifier = "cluster"
        markerView.glyphTintColor = .clear
        
        if annotation.title != "내위치" {
            markerView.removeFromSuperview()
            markerView.markerTintColor = .clear
            markerView.glyphImage = UIImage()
        }
        
        let markerImageView = UIImageView(frame: CGRect(x: -10, y: -25, width: 50, height: 50))
        markerImageView.backgroundColor = .white
        markerImageView.layer.borderWidth = 3
        markerImageView.layer.borderColor = UIColor.white.cgColor
        markerImageView.layer.cornerRadius = 5
        markerImageView.clipsToBounds = true
        
        for data in StoreObject {
            
            if data.storeName == annotation.title {
                
                if data.storeImage != "" {
                    setImageNuke(imageView: markerImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.storeImage, cornerRadius: 5, contentMode: .scaleAspectFill)
                } else if data.imageArray.count > 0 {
                    setImageNuke(imageView: markerImageView, placeholder: UIImage(named: "logo2"), imageUrl: data.imageArray[0], cornerRadius: 5, contentMode: .scaleAspectFill)
                } else {
                    markerImageView.image = UIImage(named: "logo2")
                }
                
                markerView.addSubview(markerImageView)
                
                if let cluster = annotation as? MKClusterAnnotation, annotation.title != "내위치" {
                    
                    let clusterCount = cluster.memberAnnotations.count
                    let clusterWidth = CGFloat(stringWidth(text: "\(clusterCount)", fontSize: 12)+15)
                    let clusterCountLabel = UILabel()
                    clusterCountLabel.frame = CGRect(x: markerImageView.frame.maxX-clusterWidth+10, y: markerImageView.frame.minY-5, width: clusterWidth, height: 20)
                    clusterCountLabel.backgroundColor = .systemBlue
                    clusterCountLabel.layer.cornerRadius = 10
                    clusterCountLabel.clipsToBounds = true
                    clusterCountLabel.textAlignment = .center
                    clusterCountLabel.textColor = .white
                    clusterCountLabel.font = .boldSystemFont(ofSize: 12)
                    clusterCountLabel.text = "\(clusterCount)"
                    
                    markerView.addSubview(clusterCountLabel)
                }
                
                return markerView
            }
        }
        
        markerView.canShowCallout = true; return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) { UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if view.annotation?.title == "내위치" { return }
        
        let segue = storyboard?.instantiateViewController(withIdentifier: "StoreTableViewController") as! StoreTableViewController
        segue.modalPresentationStyle = .overFullScreen
        
        if let cluster = view.annotation as? MKClusterAnnotation {
            let annotationIndex = cluster.memberAnnotations.compactMap { annotations.firstIndex(of: $0 as! MKPointAnnotation) }
            segue.StoreObject = StoreObject; segue.row = annotationIndex
        } else {
            let annotationIndex = annotations.firstIndex(of: view.annotation as! MKPointAnnotation)
            segue.StoreObject = StoreObject; segue.row = [annotationIndex ?? 0]
        }
        
        presentPanModal(segue)
        
        DispatchQueue.main.async { mapView.deselectAnnotation(view.annotation, animated: false) }
    }
}
