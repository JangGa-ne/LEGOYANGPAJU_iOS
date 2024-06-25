//
//  P4_MAIN.swift
//  legoyang_owner
//
//  Created by Busan Dynamic on 2023/03/29.
//

import UIKit
import FirebaseFirestore

extension QuestionViewController {
    
    func GET_QNA(NAME: String, AC_TYPE: String) {
        // 데이터 삭제
        self.OBJ_QNA.removeAll(); self.TABLEVIEW.reloadData()
        
        Firestore.firestore().collection(AC_TYPE).document("qna").getDocument { response, error in
            
            if let response = response {
                
                let DICT = response.data()
                let AP_VALUE = API_QNA()
                
                AP_VALUE.SET_TYPE(TYPE: [self.SET_QNATYPE(ARRAY: DICT?["pangpang"] as? [Any] ?? []), self.SET_QNATYPE(ARRAY: DICT?["legoup"] as? [Any] ?? []), self.SET_QNATYPE(ARRAY: DICT?["etc"] as? [Any] ?? [])])
                
                AP_VALUE.SET_PANGPANG(PANGPANG: self.SET_QNATYPE(ARRAY: DICT?["pangpang"] as? [Any] ?? []))
                AP_VALUE.SET_LEGOUP(LEGOUP: self.SET_QNATYPE(ARRAY: DICT?["legoup"] as? [Any] ?? []))
                AP_VALUE.SET_ETC(ETC: self.SET_QNATYPE(ARRAY: DICT?["etc"] as? [Any] ?? []))
                // 데이터 추가
                self.OBJ_QNA.append(AP_VALUE)
            }; self.TABLEVIEW.reloadData()
        }
    }
    
    func SET_QNATYPE(ARRAY: [Any]) -> [API_QNATYPE] {
        
        var OBJ_QNATYPE: [API_QNATYPE] = []
        
        for (_, DATA) in ARRAY.enumerated() {
            
            let DICT = DATA as? [String: Any]
            let AP_VALUE = API_QNATYPE()
            
            AP_VALUE.SET_ANSWER(ANSWER: DICT?["answer"] as Any)
            AP_VALUE.SET_QUESTION(QUESTION: DICT?["question"] as Any)
            // 데이터 추가
            OBJ_QNATYPE.append(AP_VALUE)
        }
        
        return OBJ_QNATYPE
    }
}

class API_QNA {
    
    var TYPE: [[API_QNATYPE]] = []
    var PANGPANG: [API_QNATYPE] = []
    var LEGOUP: [API_QNATYPE] = []
    var ETC: [API_QNATYPE] = []
    
    func SET_TYPE(TYPE: [Any]) { self.TYPE = TYPE as? [[API_QNATYPE]] ?? [] }
    func SET_PANGPANG(PANGPANG: [Any]) { self.PANGPANG = PANGPANG as? [API_QNATYPE] ?? [] }
    func SET_LEGOUP(LEGOUP: [Any]) { self.LEGOUP = LEGOUP as? [API_QNATYPE] ?? [] }
    func SET_ETC(ETC: [Any]) { self.ETC = ETC as? [API_QNATYPE] ?? [] }
}

class API_QNATYPE {
    
    var ANSWER: String = ""
    var QUESTION: String = ""
    
    func SET_ANSWER(ANSWER: Any) { self.ANSWER = ANSWER as? String ?? "" }
    func SET_QUESTION(QUESTION: Any) { self.QUESTION = QUESTION as? String ?? "" }
}
