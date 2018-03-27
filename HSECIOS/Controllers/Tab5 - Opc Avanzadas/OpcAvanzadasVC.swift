import UIKit

class OpcAvanzadasVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var asunto: UITextField!
    
    @IBOutlet weak var asuntoLength: UILabel!
    
    @IBOutlet weak var mensaje: UITextView!
    
    @IBOutlet weak var botonEnviar: UIButton!
    
    let asuntoMaxLength = 50
    let mensajeMaxLength = 800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        asunto.delegate = self
        mensaje.delegate = self
        mensaje.layer.borderColor = UIColor.gray.cgColor
        mensaje.layer.borderWidth = 0.25
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = asunto.text!.count + string.count - range.length
        let shouldChange = newLength <= asuntoMaxLength
        if shouldChange {
            botonEnviar.isEnabled = newLength > 0 && mensaje.text.count > 0
        }
        return shouldChange
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = mensaje.text.count + text.count - range.length
        let shouldChange = newLength <= mensajeMaxLength
        if shouldChange {
            botonEnviar.isEnabled = newLength > 0 && asunto.text!.count > 0
        }
        return newLength <= mensajeMaxLength;
    }
    
    @IBAction func clickEnEnviar(_ sender: Any) {
        let params: [String:String] = [
            "Url" : asunto.text ?? "",
            "Descripcion" : mensaje.text
        ]
        Helper.postData(Routes.forSendFeeback(), params, true, vcontroller: self, success: {(str: String) in
            let num = Int(str) ?? 0
            if num <= 0 {
                Alerts.presentAlert("", "Ocurrió un problema durante el envío, inténtelo de nuevo.", imagen: nil, viewController: self)
                //Alerts.presentAlertWithAccept("", "Ocurrió un problema durante el envío, inténtelo de nuevo.", imagen: nil, viewController: self, acccept: { ()                })
                print("Ocurrió un problema durante el envío, inténtelo de nuevo.")
            } else {
                Alerts.presentAlert("", "Su mensaje ha sido enviado. Cod \(str)", imagen: nil, viewController: self)
                /*Alerts.presentAlertWithAccept("", "Su mensaje ha sido enviado. Cod \(str)", imagen: nil, viewController: self, acccept: { ()
                })*/
                print("Su mensaje ha sido enviado. Cod \(str)")
            }
        })
    }
    
}
