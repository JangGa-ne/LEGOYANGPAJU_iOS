//
//  LocationAuthorityViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/04/15.
//

import UIKit
import CoreLocation
import FirebaseFirestore

class LocationAuthorityViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var detail: Bool = false
    var position: Int = 0
    
    @IBOutlet weak var backView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var pangpangSwitch: UISwitch!
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var segueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        UIViewController.LocationAuthorityViewControllerDelegate = self
        
        CLLocationManager().requestWhenInUseAuthorization()
        
        backView.isHidden = !detail
        pangpangSwitch.isOn = detail
        pangpangSwitch.addTarget(self, action: #selector(pangpangSwitch(_:)), for: .valueChanged)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 10; layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        gridView.setCollectionViewLayout(layout, animated: true, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        segueButton.addTarget(self, action: #selector(segueButton(_:)), for: .touchUpInside)
    }
    
    @objc func pangpangSwitch(_ sender: UISwitch) {
        gridView.reloadData()
    }
    
    @objc func segueButton(_ sender: UIButton) {
        
        if UIViewController.appDelegate.MemberId == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            
            switch CLLocationManager.authorizationStatus() {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                
                let coordinate = CLLocationManager().location?.coordinate
                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(["lat": "\(coordinate?.latitude ?? 37.66)", "lon": "\(coordinate?.longitude ?? 126.76)"], merge: true)
                
                let segue = storyboard?.instantiateViewController(withIdentifier: "GeoMapViewController") as! GeoMapViewController
                segue.usePangpang = pangpangSwitch.isOn; segue.position = position
                navigationController?.pushViewController(segue, animated: true)
                
            case .denied, .notDetermined, .restricted:
                
                S_NOTICE("위치 권한 비활성화 (!)")
                
                let ALERT = UIAlertController(title: "\'레고양파주\'에서\n\'설정\'을(를) 열려고 합니다", message: "레고양파주 가맹점을 찾기위해 위치 사용권한을 활성화 해주시기 바랍니다.", preferredStyle: .alert)
                ALERT.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                ALERT.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                present(ALERT, animated: true, completion: nil)
                
            default :
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(detail)
    }
}

extension LocationAuthorityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if UIViewController.appDelegate.CategoryObject.count > 0 { return UIViewController.appDelegate.CategoryObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = UIViewController.appDelegate.CategoryObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryGridCell_1", for: indexPath) as! CategoryGridCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        if indexPath.row == position {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.H_FF6F00.cgColor
        } else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
        
        setImageNuke(imageView: cell.iconImageView, placeholder: UIImage(), imageUrl: data.imageUrl, cornerRadius: 0, contentMode: .scaleAspectFit)
        cell.mainTitleLabel.text = data.cateName
        if pangpangSwitch.isOn { cell.subTitleLabel.text = "\(data.pangpangCount)" } else { cell.subTitleLabel.text = "\(data.count)" }
        cell.subTitleLabelWidth.constant = stringWidth(text: cell.subTitleLabel.text!, fontSize: 10)+20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        position = indexPath.row; gridView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-40, height: 60)
    }
}
