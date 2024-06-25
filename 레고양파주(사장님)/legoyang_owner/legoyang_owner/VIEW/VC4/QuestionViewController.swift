//
//  QuestionViewController.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/28.
//

import UIKit

class QuestionListCell: UITableViewCell {
    
    @IBOutlet weak var HEADER_I: UIImageView!
    @IBOutlet weak var HEADER_L: UILabel!
    
    @IBOutlet weak var COLOR_V: UILabel!
    @IBOutlet weak var TITLE_L: UILabel!
    @IBOutlet weak var BODY_L: UILabel!
}

class QuestionViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var OBJ_QNA: [API_QNA] = []
    
    @IBOutlet weak var NAVI_V: UIView!
    @IBOutlet weak var NAVI_L: UILabel!
    @IBAction func VC_SETTING_B(_ sender: UIButton) { segueViewController(identifier: "VC_SETTING") }
    @IBOutlet weak var LINE_V: UIView!
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.QuestionViewControllerDelegate = self
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        GET_QNA(NAME: "Q&A", AC_TYPE: "app")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}

extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if OBJ_QNA.count > 0 { return 4 } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let CELL = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell_T") as! QuestionListCell
        if section == 1 {
            CELL.HEADER_I.image = UIImage(named: "pangpang"); CELL.HEADER_L.textColor = .H_FF6F00; CELL.HEADER_L.text = " 레고팡팡"
        } else if section == 2 {
            CELL.HEADER_I.image = UIImage(named: "legoup"); CELL.HEADER_L.textColor = .H_FFEF68; CELL.HEADER_L.text = " 레고업"
        } else if section == 3 {
            CELL.HEADER_I.image = UIImage(named: "logo4"); CELL.HEADER_L.textColor = .H_00529C; CELL.HEADER_L.text = " 기타 서비스"
        }
        return CELL
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 0 } else { return 60 }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if (section == 1) && (OBJ_QNA[0].PANGPANG.count > 0) {
            return OBJ_QNA[0].PANGPANG.count
        } else if (section == 2) && (OBJ_QNA[0].LEGOUP.count > 0) {
            return OBJ_QNA[0].LEGOUP.count
        } else if (section == 3) && (OBJ_QNA[0].ETC.count > 0) {
            return OBJ_QNA[0].ETC.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "QuestionListCell_1", for: indexPath) as! QuestionListCell
        } else {
            
            let DATA = OBJ_QNA[0]
            let CELL = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell_2", for: indexPath) as! QuestionListCell
            
            if indexPath.section == 1 {
                CELL.COLOR_V.backgroundColor = .H_FF6F00
                CELL.TITLE_L.text = DATA.PANGPANG[indexPath.item].QUESTION
                CELL.BODY_L.text = DATA.PANGPANG[indexPath.item].ANSWER
            } else if indexPath.section == 2 {
                CELL.COLOR_V.backgroundColor = .H_FFEF68
                CELL.TITLE_L.text = DATA.LEGOUP[0].QUESTION
                CELL.BODY_L.text = DATA.LEGOUP[indexPath.item].ANSWER
            } else if indexPath.section == 3 {
                CELL.COLOR_V.backgroundColor = .H_00529C
                CELL.TITLE_L.text = DATA.ETC[indexPath.item].QUESTION
                CELL.BODY_L.text = DATA.ETC[indexPath.item].ANSWER
            }
            
            return CELL
        }
    }
}
