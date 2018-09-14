import UIKit

class NotaEditPopupVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txNombre: UILabel!
    @IBOutlet weak var ETNota: UITextField!
    
    @IBOutlet weak var txCargo: UILabel!
    
    @IBOutlet weak var SlidNota: UISlider!
    
    @IBOutlet weak var avatar: UIImageView!
    
    //var dataPersona = Persona()
    
    var cursoNotas: [Persona] = []
    var codCurso = ""
    var position = 0
    
    var nota = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ETNota.delegate = self
        print(cursoNotas[position].CodPersona)
        updateValues(cursoNotas[position])
        
    }
    
    func updateValues(_ dataPersona: Persona){
        self.txNombre.text = dataPersona.Nombres
        self.txCargo.text = dataPersona.Cargo
        if dataPersona.Email != nil{
            self.ETNota.text = dataPersona.Email
        } else {
            self.ETNota.text = "0"
        }
        
        Images.loadAvatarFromDNI(dataPersona.NroDocumento ?? "", avatar, false)
        self.SlidNota.setValue(Float(dataPersona.Email ?? "") ?? 0, animated: true)
        print(ETNota.text!)
        self.nota = Int(ETNota.text ?? "0")!
        
        //if unit.Cargo == ""{celdaT.Cargo.text = " "} else { celdaT.Cargo.text = unit.Cargo}
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*let data = textField.text
         let allowedCharacter = CharacterSet.decimalDigits
         let characterSet = CharacterSet(charactersIn: string)
         return allowedCharacter.isSuperset(of: characterSet)
         */
        if textField.tag == 0 {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let nsString = textField.text as NSString?
                let num = nsString?.replacingCharacters(in: range, with: string)
                let numero = Int(num!) ?? 0
                if numero <= 20 && numero >= 0 {
                    self.nota = numero
                    return true
                }
            }
            return false
        }
        return true
    }
    
    @IBAction func slidMod(_ sender: UISlider) {
        //self.ETNota = //String(Int((sender as AnyObject).value))
        let currentValue = Int(sender.value)
        ETNota.text = "\(currentValue)"
        self.nota = currentValue
    }
    @IBAction func ClosePopup(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editCambio(_ sender: Any) {
        self.SlidNota.setValue(Float(nota), animated: true)
        
        
    }
    
    @IBAction func btnAumentar(_ sender: Any) {
        self.nota = self.nota < 20 ? self.nota + 1 : 20
        self.ETNota.text = String(nota)
        self.SlidNota.setValue(Float(nota), animated: true)
    }
    
    @IBAction func btnDisminuir(_ sender: Any) {
        self.nota = self.nota > 0 ? self.nota - 1 : 0
        self.ETNota.text = String(nota)
        self.SlidNota.setValue(Float(nota), animated: true)
        
    }
    
    //        self.porcentaje = self.porcentaje > 0 ? self.porcentaje - 1 : 0
    @IBAction func SaveData(_ sender: Any) {
        Rest.postDataGeneral(Routes.forNotasUpdate(), ["CodPersona": cursoNotas[position].CodPersona!, "NroDocumento": codCurso, "Estado": ETNota.text!], true, success: {(resultValue:Any?,data:Data?) in
            let str = resultValue as! String
            print(str)
            if str == "-1" {
                self.presentAlert(nil, "Ocurrio un error, no se pudo guardar la nota", .actionSheet, 2, nil, [], [], actionHandlers: [])
            }else {
                self.presentAlert(nil, "Operación exitosa", .actionSheet, 2, nil, [], [], actionHandlers: [])
                Utils.notasVC.loadDatanoticia(self.codCurso,"")
                
            }
            
        }, error: {(error) in
            //self.inputsStack.isHidden = false
            print(error)
            
        })
        
        
        
        
        
        
        
    }
    // _ codeP: String, _ codCurso: String
    @IBAction func DeleteUser(_ sender: Any) {
        self.presentAlert("Eliminar participante", "Estas seguro de eliminar al participante \(cursoNotas[position].Nombres)?", .alert, nil, Images.alertaAmarilla, ["Cancelar", "Aceptar"], [.cancel, .default], actionHandlers: [ {(alertaCancelar) in
            print("Esto ocurre al presionar cancelar")
            
            }, {(alertAceptar) in
                print("Esto ocurre al presionar aceptar")
                Rest.getDataGeneral(Routes.forUserDelete(self.cursoNotas[self.position].CodPersona!, self.codCurso), true, success: {(resultValue:Any?,data:Data?) in let str = resultValue as! String
                    print(str)
                    /*if str == "-1" {
                     self.presentAlert(_title: nil, "Ocurrio un error", .actionSheet, 2, nil, [], [], actionHandlers: [])
                     }else {
                     self.presentAlert(_title: nil, "Operación exitosa", .actionSheet, 2, nil, [], [], actionHandlers: [])
                     */
                    Utils.notasVC.loadDatanoticia(self.codCurso,str)
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                    //}
                    
                }, error: nil)
                
            }, {(alertaEliminar) in
                print("Esto ocurre al presionar eliminar")
            }])
        
    }
    
    @IBAction func NextUser(_ sender: Any) {
        
        
        if cursoNotas.count - 1 > position{
            if cursoNotas[position+1].Estado == "A" {
                
                position = position + 1
                updateValues(cursoNotas[position])
                
            }
        }
    }
    
    @IBAction func BackUser(_ sender: Any) {
        if position > 0 {
            if cursoNotas[position+1].Estado == "A" {
                position = position - 1
                updateValues(cursoNotas[position])
            }
        }
    }
    
    
    
    
}
