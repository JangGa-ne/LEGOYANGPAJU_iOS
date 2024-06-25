//
//  VC_QRSCAN.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/29.
//

import AVFoundation
import UIKit

class VC_QRSCAN: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var buttonPressed: Bool = false
    
    var OBJ_PANGPANG: [API_PANGPANG_HISTORY] = []
    var OBJ_POSITION: Int = 0
    
    var AV_SESSION = AVCaptureSession()
    var AV_PREVIEW = AVCaptureVideoPreviewLayer()
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var OR_V: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.VC_QRSCAN_DEL = self
        
        let INPUT: AVCaptureDeviceInput
        let OUTPUT = AVCaptureMetadataOutput()
        
        guard let DEVICE = AVCaptureDevice.default(for: .video) else { return }
        do { INPUT = try AVCaptureDeviceInput(device: DEVICE) } catch { return }
        
        if AV_SESSION.canAddInput(INPUT) { AV_SESSION.addInput(INPUT) } else { return }
        if AV_SESSION.canAddOutput(OUTPUT) { AV_SESSION.addOutput(OUTPUT); OUTPUT.setMetadataObjectsDelegate(self, queue: DispatchQueue.main); OUTPUT.metadataObjectTypes = [.qr] } else { return }
        
        AV_PREVIEW.session = AV_SESSION
        AV_PREVIEW.frame = view.layer.bounds
        AV_PREVIEW.videoGravity = .resizeAspectFill
        OR_V.layer.addSublayer(AV_PREVIEW)
        
        AV_SESSION.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BACK_GESTURE(false)
        
        if !AV_SESSION.isRunning { AV_SESSION.startRunning() }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if AV_SESSION.isRunning { AV_SESSION.stopRunning() }
    }
}

extension VC_QRSCAN: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if !buttonPressed, let METADATA = metadataObjects.first {
            
            buttonPressed = true
            
            guard let READABLE = METADATA as? AVMetadataMachineReadableCodeObject else { return }
            guard let CODE = READABLE.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            print(CODE)
            
//            PUT_COUPON(NAME: "QR쿠폰", AC_TYPE: "", CODE: CODE.replacingOccurrences(of: " ", with: ""))
            putCoupon(code: CODE.replacingOccurrences(of: " ", with: ""))
        }
    }
}
