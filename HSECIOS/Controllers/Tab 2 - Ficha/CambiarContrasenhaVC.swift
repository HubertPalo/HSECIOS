import UIKit

class CambiarContrasenhaVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var contrasenhaActual: UITextField!
    @IBOutlet weak var nuevaContrasenha: UITextField!
    @IBOutlet weak var confirmacionContrasenha: UITextField!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contrasenhaActual.delegate = self
        contrasenhaActual.tag = 0
        nuevaContrasenha.delegate = self
        nuevaContrasenha.tag = 1
        confirmacionContrasenha.delegate = self
        confirmacionContrasenha.tag = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 1 {
            return false
        }
        return true
    }
    
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        self.botonTopDer.isEnabled = false
        Rest.postDataGeneral(Routes.forChangePass(), ["username":Utils.userData.CodPersona ?? "", "password":contrasenhaActual.text ?? "", "domain":nuevaContrasenha.text ?? ""], true, success: {(resultValue:Any?,data:Data?) in
            self.botonTopDer.isEnabled = true
            if let respuesta = resultValue as? String {
                self.presentAlert("Respuesta", respuesta, .alert, 2, nil, [], [], actionHandlers: [])
            } else {
                self.presentAlert("Error", "La app no puede traducir el mensaje recibido desde el servidor", .alert, 2, nil, [], [], actionHandlers: [])
            }
            
        }, error: {(error) in
            self.botonTopDer.isEnabled = true
            self.presentAlert("Error", "Ocurrió un error durante el proceso", .alert, 2, nil, [], [], actionHandlers: [])
        })
    }
    
}
