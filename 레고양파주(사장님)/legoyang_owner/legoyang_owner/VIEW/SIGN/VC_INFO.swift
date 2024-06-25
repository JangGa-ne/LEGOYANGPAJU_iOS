//
//  VC_INFO.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/04.
//

import UIKit

class VC_INFO: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var VC_AGREEMENT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VC_AGREEMENT_B.addTarget(self, action: #selector(VC_AGREEMENT_B(_:)), for: .touchUpInside)
    }
    
    @objc func VC_AGREEMENT_B(_ sender: UIButton) {
        segueViewController(identifier: "VC_AGREEMENT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
    }
}
