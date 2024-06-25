//
//  VC_CATEGORY.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/16.
//

import UIKit

class TC_CATEGORY: UITableViewCell {
    
    var isChecked: Bool = false
    
    @IBOutlet weak var CHECK_I: UIImageView!
    
    @IBOutlet weak var CATEGORY_I: UIImageView!
    @IBOutlet weak var CATEGORY_L: UILabel!
    @IBOutlet weak var COUNT_L: UILabel!
}

class VC_CATEGORY: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var LEGOPANGPANG: Bool = false
    
    var OBJ_CATEGORY: [API_CATEGORY] = []
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
        
        GET_CATEGORY(NAME: "카테고리", AC_TYPE: "store_category")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(false)
    }
}

extension VC_CATEGORY: UITableViewDelegate, UITableViewDataSource {
    
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
            
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_CATEGORY_1", for: indexPath) as! TC_CATEGORY
            if LEGOPANGPANG { CELL.CHECK_I.image = UIImage(named: "check_on") } else { CELL.CHECK_I.image = UIImage(named: "check_off") }
            return CELL
        } else if indexPath.section == 1 {
            
            let DATA = OBJ_CATEGORY[indexPath.item]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_CATEGORY_2", for: indexPath) as! TC_CATEGORY
            
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
            
            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_STORE") as! VC_STORE
            VC.LEGOPANGPANG = LEGOPANGPANG; VC.OBJ_CATEGORY = OBJ_CATEGORY; VC.OBJ_POSITION = indexPath.item
            navigationController?.pushViewController(VC, animated: true)
        }
    }
}
