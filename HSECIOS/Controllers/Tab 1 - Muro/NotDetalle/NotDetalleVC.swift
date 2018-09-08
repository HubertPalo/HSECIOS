import UIKit

class NotDetalleVC: UIViewController {
    
    var noticia = MuroElement()
    var shouldLoadNoticia = false
    var hijo = NotDetalleTVC()
    
    @IBOutlet weak var nuevoComentario: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.hijo.comentarios = []
        self.hijo.tableView.reloadSections([1], with: .none)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nuevoComentario.text = ""
        
        if shouldLoadNoticia {
            Rest.getDataGeneral(Routes.forNoticia(noticia.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                self.hijo.data = Dict.dataToUnit(data!)!
                self.hijo.tableView.reloadSections([0], with: .none)
            }, error: nil)
            
        }
        Rest.getDataGeneral(Routes.forComentarios(noticia.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
            let arrayComentarios: ArrayGeneral<Comentario> = Dict.dataToArray(data!)
            self.hijo.comentarios = arrayComentarios.Data
            for unit in arrayComentarios.Data {
                if (unit.Estado ?? "") != "" {
                    Images.downloadAvatar(unit.Estado ?? "", {() in
                        self.hijo.tableView.reloadSections([1], with: .none)
                    })
                }
            }
            self.hijo.tableView.reloadSections([1], with: .none)
        }, error: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "HSEC", Images.minero)
        self.hijo = self.childViewControllers[0] as! NotDetalleTVC
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    }
    
    func loadNoticia(_ noticia: MuroElement) {
        let distintos = noticia.Codigo != self.noticia.Codigo
        self.noticia = distintos ? noticia : self.noticia
        self.shouldLoadNoticia = distintos
    }
    
    @IBAction func clickEnviarComentario(_ sender: Any) {
        self.view.endEditing(true)
        if nuevoComentario.text?.count == 0 {
            return
        }
        
        let parametros = ["CodComentario":noticia.Codigo ?? "","Comentario": nuevoComentario.text!]
        
        Rest.postDataGeneral(Routes.forPostComentario(), parametros, true, success: {(resultValue:Any?,data:Data?) in
            self.presentAlert("Comentario enviado", nil, .alert, 1, nil, [], [], actionHandlers: [])
            self.nuevoComentario.text = ""
            Rest.getDataGeneral(Routes.forComentarios(self.noticia.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayComentarios: ArrayGeneral<Comentario> = Dict.dataToArray(data!)
                self.hijo.comentarios = arrayComentarios.Data
                for unit in arrayComentarios.Data {
                    if (unit.Estado ?? "") != "" {
                        Images.downloadAvatar(unit.Estado ?? "", {() in
                            self.hijo.tableView.reloadSections([1], with: .none)
                        })
                    }
                }
                self.hijo.tableView.reloadSections([1], with: .none)
            }, error: nil)
            // Alerts.presentAlert("Comentario Enviado", "Enviado", imagen: nil, viewController: self)
        }, error: {(error) in
            self.presentAlert("Error", error, .alert, 2, nil, [], [], actionHandlers: [])
            // Alerts.presentAlert("Error", error, duration: 2, imagen: nil, viewController: self)
        })
    }
    
}
