
import UIKit
import AVKit
import AudioToolbox

class CameraView: UIView {
    override class var layerClass: AnyClass {
        get {
            return AVCaptureVideoPreviewLayer.self
        }
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        get {
            return super.layer as! AVCaptureVideoPreviewLayer
        }
    }
}


class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var qrCodeFrameView:UIView?
    
    var cameraView: CameraView!
    let session = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: AVCaptureSession.self.description(), attributes: [], target: nil)
    var dniScan = ""
    override func loadView() {
        cameraView = CameraView()
        
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session.beginConfiguration()
        
        let videoDevice = AVCaptureDevice.default(for: .video)
        
        if (videoDevice != nil) {
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice!)
            
            if (videoDeviceInput != nil) {
                if (session.canAddInput(videoDeviceInput!)) {
                    session.addInput(videoDeviceInput!)
                }
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (session.canAddOutput(metadataOutput)) {
                session.addOutput(metadataOutput)
                
                metadataOutput.metadataObjectTypes = [
                    .ean13,
                    .qr,
                    .upce,
                    .code39,
                    .code39Mod43,
                    .ean8,
                    .code93,
                    .pdf417,
                    .aztec,
                    .interleaved2of5,
                    .itf14,
                    .dataMatrix
                    
                    
                ]
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
            }
        }
        
        session.commitConfiguration()
        
        cameraView.layer.session = session
        cameraView.layer.videoGravity = .resizeAspectFill
        
        let videoOrientation: AVCaptureVideoOrientation
        switch UIApplication.shared.statusBarOrientation {
        case .portrait:
            videoOrientation = .portrait
            
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            
        case .landscapeLeft:
            videoOrientation = .landscapeLeft
            
        case .landscapeRight:
            videoOrientation = .landscapeRight
            
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection?.videoOrientation = videoOrientation
        /*
         // Initialize QR Code Frame to highlight the QR code
         qrCodeFrameView = UIView()
         qrCodeFrameView?.layer.borderColor = UIColor.red.cgColor
         qrCodeFrameView?.layer.borderWidth = 2
         qrCodeFrameView?.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
         
         view.addSubview(qrCodeFrameView!)
         view.bringSubview(toFront:qrCodeFrameView!)
         ///////////////////////////
         */
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    /*
     override func viewDidLayoutSubviews() {
     sessionQueue.async {
     self.session.stopRunning()
     }
     }
     */
    
    func disCamera() {
        sessionQueue.async {
            self.session.stopRunning()
        }
    }
    
    func startCam(){
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update camera orientation
        let videoOrientation: AVCaptureVideoOrientation
        switch UIDevice.current.orientation {
        case .portrait:
            videoOrientation = .portrait
            
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
            
        case .landscapeLeft:
            videoOrientation = .landscapeRight
            
        case .landscapeRight:
            videoOrientation = .landscapeLeft
            
        default:
            videoOrientation = .portrait
        }
        
        cameraView.layer.connection?.videoOrientation = videoOrientation
    }
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //self.playSound();
        print("scannervc \(Globals.isScaning)")
        if (metadataObjects.count > 0 && metadataObjects.first is AVMetadataMachineReadableCodeObject && Globals.isScaning) {
            Globals.isScaning = false
            let scan = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            dniScan = scan.stringValue!
            (self.parent as! AsistenciaVC).DataToScan(dniScan)
            
            
            self.disCamera()
            /*
             sessionQueue.async {
             self.session.stopRunning()
             }
             sessionQueue.async {
             self.session.startRunning()
             }
             */
            
            /*let alertController = UIAlertController(title: "Barcode Scanned", message: scan.stringValue, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
             
             present(alertController, animated: true, completion: nil)*/
            
        }
    }
    
}

