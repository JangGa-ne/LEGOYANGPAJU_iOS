//
//  VC_MAP1.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/02/06.
//

import UIKit
import CoreLocation
import FirebaseFirestore

class TC_MAP1: UITableViewCell {
    
    var isChecked: Bool = false
    
    @IBOutlet weak var CHECK_I: UIImageView!
    
    @IBOutlet weak var BACKGROUND_V: UIView!
    @IBOutlet weak var CATEGORY_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
}

class VC_MAP1: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LEGOPANGPANG: Bool = false
    let CL_MANAGER = CLLocationManager()
    
    var OBJ_CATEGORY: [API_CATEGORY] = []
    var OBJ_POSITION: Int = 0
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    @IBOutlet weak var MAP_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_MAP1_DEL = self
        
        CL_MANAGER.requestWhenInUseAuthorization()
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        GET_CATEGORY(NAME: "카테고리", AC_TYPE: "store_category")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
        
        MAP_B.addTarget(self, action: #selector(MAP_B(_:)), for: .touchUpInside)
    }
    
    @objc func MAP_B(_ sender: UIButton) {
        
        let MEMBER_ID = UserDefaults.standard.string(forKey: "member_id") ?? ""
        if MEMBER_ID == "" {
            S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
        } else {
            
            switch CLLocationManager.authorizationStatus() {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                
                let LOCATION = CL_MANAGER.location?.coordinate
                Firestore.firestore().collection("member").document(MEMBER_ID).setData(["lat": "\(LOCATION?.latitude ?? 37.66)", "lon": "\(LOCATION?.longitude ?? 126.76)"], merge: true)
                let VC = storyboard?.instantiateViewController(withIdentifier: "VC_MAP2") as! VC_MAP2
                VC.LEGOPANGPANG = LEGOPANGPANG; VC.OBJ_CATEGORY = OBJ_CATEGORY; VC.OBJ_POSITION = OBJ_POSITION
                navigationController?.pushViewController(VC, animated: true)
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
        
        setBackSwipeGesture(false)
    }
}

extension VC_MAP1: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if OBJ_CATEGORY.count > 0 { return OBJ_CATEGORY.count } else { return 0 }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_MAP1_1", for: indexPath) as! TC_MAP1
            if LEGOPANGPANG { CELL.CHECK_I.image = UIImage(named: "check_on") } else { CELL.CHECK_I.image = UIImage(named: "check_off") }
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = OBJ_CATEGORY[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_MAP1_2", for: indexPath) as! TC_MAP1
            if OBJ_POSITION == indexPath.item { CELL.BACKGROUND_V.borderColor = .H_FF6F00; CELL.BACKGROUND_V.borderWidth = 2 } else { CELL.BACKGROUND_V.borderColor = .clear }
            
            CELL.CATEGORY_I.image = UIImage(named: CATEGORY_IMAGES[DATA.NAME] ?? "")
            CELL.CATEGORY_L.text = DATA.NAME
            if !LEGOPANGPANG { CELL.COUNT_L.text = "\(DATA.COUNT)" } else { CELL.COUNT_L.text = "\(DATA.PP_COUNT)" }
            
            return CELL
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 { UIImpactFeedbackGenerator().impactOccurred()
            if !LEGOPANGPANG { LEGOPANGPANG = true } else { LEGOPANGPANG = false }; TABLEVIEW.reloadData()
        } else if indexPath.section == 1 {
            OBJ_POSITION = indexPath.item; TABLEVIEW.reloadData()
        }
    }
}

//extension VC_MAP1: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if OBJ_CATEGORY.count > 0 { return OBJ_CATEGORY.count } else { return 0 }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let DATA = OBJ_CATEGORY[row]
//
//        let imageView = UIImageView()
//        imageView.frame.size.width = view?.frame.height ?? 0
//        imageView.image = UIImage(named: CATEGORY_IMAGES[DATA.NAME] ?? "")
//        imageView.contentMode = .scaleAspectFit
//
//        let label = UILabel()
//        label.text = DATA.NAME
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
//
//        let stackview = UIStackView()
//        stackview.distribution = .fillEqually
//        stackview.axis = .horizontal
//        stackview.spacing = 10
//        stackview.addArrangedSubview(imageView)
//        stackview.addArrangedSubview(label)
//
//        return stackview
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        OBJ_POSITION = row; CATEGORY_TF.text = "  \(OBJ_CATEGORY[row].NAME)"
//    }
//}
