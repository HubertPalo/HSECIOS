import UIKit

class RecuperarContrasenhaVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.botonTopDer.isEnabled = false
        self.email.delegate = self
        self.setTitleAndImage("Recuperar Contraseña", nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        let direccion = self.email.text ?? ""
        if !direccion.isValidEmail() {
            self.presentAlert("Error", "No se ha detectado un email válido", .alert, 2, nil, [], [], actionHandlers: [])
            return
        }
        Rest.postDataGeneral(Routes.forRecoveryPass(), ["Url": direccion], true, success: {(resultValue:Any?,data:Data?) in
            let respuesta = resultValue as! String
            print(resultValue)
            if respuesta == "-1" {
                self.presentError("Ocurrió un error al procesar su solicitud")
                return
            }
            self.presentAlert(respuesta, nil, .alert, 2, nil, [], [], actionHandlers: [])
        }, error: {(error) in
            
        })
    }
}
