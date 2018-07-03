import UIKit

class ComentariosVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var comentarios : [Comentario] = []
    var codigo = ""
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var campoComentario: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func loadComentarios(_ codigo: String) {
        self.codigo = codigo
        self.comentarios = []
        self.tabla.reloadData()
        Rest.getDataGeneral(Routes.forComentarios(codigo), false, success: {(resultValue:Any?,data:Data?) in
            let arrayComentarios: ArrayGeneral<Comentario> = Dict.dataToArray(data!)
            self.comentarios = arrayComentarios.Data//Dict.toArrayObsComentario(dict)
            self.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forComentarios(codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.comentarios = Dict.toArrayObsComentario(dict)
            self.tabla.reloadData()
        })*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    }
    
    // tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comentarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! ComentariosTVCell
        let unit = comentarios[indexPath.row]
        celda.autor.text = unit.Nombres
        celda.fecha.text = Utils.str2date2str(unit.Fecha)
        celda.comentario.text = unit.Comentario
        let codigoImagen = "media/getAvatar/\(unit.Estado)/Carnet.jpg"
        if let temp = Images.imagenes[codigoImagen] {
            celda.avatar.image = temp
        } else {
            Images.get(codigoImagen, tableView, indexPath.row)
        }
        return celda
    }
    // tabla
    
    @IBAction func clickEnEnviar(_ sender: Any) {
        let parametros = ["CodComentario":codigo,"Comentario": campoComentario.text!]
                          
        Rest.postDataGeneral(Routes.forPostComentario(), parametros, true, success: {(resultValue:Any?,data:Data?) in
            Alerts.presentAlert("Comentario Enviado", "Enviado", imagen: nil, viewController: self)
        }, error: {(error) in
            Alerts.presentAlert("Error", error, duration: 2, imagen: nil, viewController: self)
        })
        /*Rest.postData(Routes.forPostComentario(), parametros, true, vcontroller: self, success: {(str:String) in
            
        })*/
    }
    
}

class ComentariosTVCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var comentario: UILabel!
}
