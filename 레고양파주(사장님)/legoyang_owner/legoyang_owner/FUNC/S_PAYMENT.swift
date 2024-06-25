//
//  S_PAYMENT.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/10/27.
//

import UIKit
import StoreKit
import FirebaseFirestore

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

struct InAppProducts {
    static let productIdentifiers: Set<String> = [
        "LEGOYANG_OWNER_TICKET_1",
        "LEGOYANG_OWNER_TICKET_2",
        "LEGOYANG_OWNER_TICKET_3",
        "LEGOYANG_OWNER_TICKET_4",
        "LEGOYANG_OWNER_TICKET_5",
        "LEGOYANG_OWNER_TICKET_6",
    ]
    static let store = IAPHelper(productIds: InAppProducts.productIdentifiers)
}

typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

class IAPHelper: NSObject  {
    
    static var VC: UIViewController?
    
    let productIdentifiers: Set<String>
    var purchasedProductIdentifiers: Set<String> = []
    var productsRequest: SKProductsRequest?
    var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    let payamounts: [String: Any] = [
        "LEGOYANG_OWNER_TICKET_1": "1000",
        "LEGOYANG_OWNER_TICKET_2": "4000",
        "LEGOYANG_OWNER_TICKET_3": "9000",
        "LEGOYANG_OWNER_TICKET_4": "20000",
        "LEGOYANG_OWNER_TICKET_5": "50000",
        "LEGOYANG_OWNER_TICKET_6": "70000",
    ]
    
    init(productIds: Set<String>) { productIdentifiers = productIds
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}

extension IAPHelper {
    
    func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self; productsRequest?.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        SKPaymentQueue.default().add(SKPayment(product: product))
    }
    
    func isProductPurchased(_ productIdentifier: String) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPHelper: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        productsRequestCompletionHandler?(true, response.products); clearRequestAndHandler()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler?(false, nil); clearRequestAndHandler()
    }
    
    func clearRequestAndHandler() {
        productsRequest = nil; productsRequestCompletionHandler = nil
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchased: success(transaction: transaction); break
                case .failed: failure(transaction: transaction); break
                case .restored: restore(transaction: transaction); break
                case .deferred, .purchasing: break
                default: fatalError()
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        S_INDICATOR(IAPHelper.VC?.view ?? UIView(), animated: false)
        if queue.transactions.count == 0 {
            print("복구안됨")
        } else {
            print("복구됨")
        }
    }
    
    func success(transaction: SKPaymentTransaction) {
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        
        let productIdentifier = transaction.payment.productIdentifier
        let STORE_ID = UserDefaults.standard.string(forKey: "store_id") ?? ""
        let STORE_CASH = (Int(UIViewController.appDelegate.StoreObject[UIViewController.appDelegate.row].storeCategory) ?? 0) + (Int(payamounts[productIdentifier] as? String ?? "0") ?? 0)
        let timestamp = IAPHelper.VC?.setKoreaTimestamp() ?? 0
        let PARAMETERS: [String: Any] = [
            "\(timestamp)": [
                "lepay_amount": payamounts[productIdentifier] as? String ?? "0",
                "lepay_detail": "레pay 충전",
                "lepay_time": "\(timestamp)",
                "lepay_type": "충전"
            ]
        ]
        
        Firestore.firestore().collection("store").document(STORE_ID).setData(["store_cash": "\(STORE_CASH)"], merge: true) { _ in
            if let BVC = UIViewController.VC_LEPAY_DEL { BVC.PAY_L.text = "\((NF.string(from: STORE_CASH as NSNumber) ?? ""))원" }
        }; Firestore.firestore().collection("lepay_history").document(STORE_ID).setData(PARAMETERS, merge: true)
        
        SKPaymentQueue.default().finishTransaction(transaction)
        S_INDICATOR(IAPHelper.VC?.view ?? UIView(), animated: false); IAPHelper.VC?.S_NOTICE("레pay 충전됨")
    }
    
    func restore(transaction: SKPaymentTransaction) {
        if let productIdentifier = transaction.original?.payment.productIdentifier {
            deliverPurchaseNotificationFor(identifier: productIdentifier)
        }; SKPaymentQueue.default().finishTransaction(transaction); S_INDICATOR(IAPHelper.VC?.view ?? UIView(), animated: false)
    }
    
    func failure(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?, let localizedDescription = transaction.error?.localizedDescription, transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }; SKPaymentQueue.default().finishTransaction(transaction); S_INDICATOR(IAPHelper.VC?.view ?? UIView(), animated: false); IAPHelper.VC?.S_NOTICE("레pay 충전 안됨")
    }
    
    func deliverPurchaseNotificationFor(identifier: String?) {
        if let identifier = identifier {
            purchasedProductIdentifiers.insert(identifier)
            UserDefaults.standard.setValue(true, forKey: identifier)
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
        }
    }
}
