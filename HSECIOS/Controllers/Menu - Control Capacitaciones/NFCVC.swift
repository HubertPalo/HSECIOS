import UIKit
import AVFoundation
import CoreNFC

@available(iOS 11.0, *)
class NFCVC: UIViewController, NFCNDEFReaderSessionDelegate {
    var nfcSession: NFCNDEFReaderSession?
    @IBOutlet weak var mensaje: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ScanNFC(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error.localizedDescription)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Parse the card's information
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)! // 1
        }
        
        DispatchQueue.main.async {
            self.mensaje.text = result
        }
        
    }
    
}
