import UIKit

class ObsDetallePVCTab5: UIViewController {
    
    var observacion = MuroElement()
    var comentarios = ComentariosVC()
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(4)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.comentarios = self.childViewControllers[0] as! ComentariosVC
        /*tabla.delegate = self
        tabla.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/
    }
    
    func loadObservacion(_ codigo: String) {
        self.comentarios.loadComentarios(codigo)
        self.comentarios.codigo = codigo
        self.comentarios.forzarActualizacionDeComentarios = {
            self.comentarios.loadComentarios(codigo)
        }
    }
    
    
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }*/
    
}

class MuroDetallePVCTab4TVCell: UITableViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var autor: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var comentario: UILabel!
}
