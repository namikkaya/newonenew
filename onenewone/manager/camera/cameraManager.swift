//
//  cameraManager.swift
//  onenewone
//
//  Created by namik kaya on 8.02.2020.
//  Copyright © 2020 namik kaya. All rights reserved.
//

import UIKit
import AVFoundation

class cameraManager: NSObject {
    private let TAG:String = "cameraManager"
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private var rootView:UIView?
    private var previewView:UIView?
    
    private var cameraPositionHolder:AVCaptureDevice.Position?
    
    init(root rootView:UIView,preview previewView:UIView) {
        self.rootView = rootView
        self.previewView = previewView
        super.init()
        
        cameraPositionHolder = .front
        cameraConfig()
        audioConfig()
        startRecording()
    }
    
    private func cameraConfig() {
        let captureDevice:AVCaptureDevice? = getDevice(position: cameraPositionHolder!)//AVCaptureDevice.default(for: AVMediaType.video)
        
        var input:AVCaptureInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            print(error)
        }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input!)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        layer_autoSize()
    }
    
    private func startRecording() {
        previewView!.layer.addSublayer(videoPreviewLayer!)
        previewView!.setNeedsDisplay()
        captureSession?.startRunning()
    }
    
    private func layer_autoSize() {
        guard let rootView = rootView else { return }
        videoPreviewLayer?.frame = rootView.frame
        videoPreviewLayer!.setNeedsDisplay()
    }
    
    func autoRefreshView() {
        layer_autoSize()
    }
    
    private func audioConfig() {
        
        let microphone = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInMicrophone, for: AVMediaType.audio, position: AVCaptureDevice.Position.unspecified)
        
        self.getAudioInputDevice(captureDevice: microphone) { (status:Bool?, input:AVCaptureDeviceInput?) in
            if let status = status {
                if status {
                    if let input = input {
                        if let session = captureSession {
                            if session.canAddInput(input) {
                                session.addInput(input)
                            }
                        }
                        captureSession?.automaticallyConfiguresApplicationAudioSession = false
                    }
                }
            }
        }
    }
    
    
    func getDevice(position: AVCaptureDevice.Position)->AVCaptureDevice? {
        var avCapture:AVCaptureDevice?
        if (position == .front) {
            if let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front){
                avCapture = device
                print("front::: ")
            }
        }else {
            if let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.back){
                avCapture = device
                print("back::: ")
            }
        }
        return avCapture
    }
    
    func getAudioInputDevice(captureDevice:AVCaptureDevice?, completion: (Bool?,AVCaptureDeviceInput?)->()) {
        if let captureDevice = captureDevice {
            var input:AVCaptureDeviceInput?
            do {
                input = try AVCaptureDeviceInput(device: captureDevice)
                completion(true, input)
            } catch let error {
                print("KAYA_HATA: \(error)")
                completion(false, input)
            }
        }
        
    }
    /// Kamera pozisyonu değiştirir
    public func changeCamera(){
        if (cameraPositionHolder == AVCaptureDevice.Position.front) {
            cameraPositionHolder = AVCaptureDevice.Position.back
        }else {
            cameraPositionHolder = AVCaptureDevice.Position.front
        }
        dischargeCamera()
        cameraConfig()
    }
    
    private func dischargeCamera(){
        captureSession = nil
        videoPreviewLayer?.removeFromSuperlayer()
        videoPreviewLayer = nil
    }
    
    deinit {
        dischargeCamera()
        rootView = nil
        previewView = nil
    }
    
    internal func orientationStatus(status:UIDeviceOrientation) {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            print("\(TAG) landscapeLeft")
            videoPreviewLayer?.frame = CGRect(x: 0, y: 0, width: (rootView?.frame.size.width)!, height: (rootView?.frame.size.height)!)
            previewView!.setNeedsDisplay()
            break
        case .landscapeRight:
             print("\(TAG) landscapeRight")
            break
        case .unknown:
             print("\(TAG) unknown")
            break
        case .portrait:
             print("\(TAG) portrait")
            break
        case .portraitUpsideDown:
             print("\(TAG) portraitUpsideDown")
            break
        case .faceUp:
             print("\(TAG) faceUp")
            break
        case .faceDown:
             print("\(TAG) faceDown")
            break
            
        @unknown default:
            fatalError()
        }
    }

}
