import UIKit

class ComentariosVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var comentarios : [ObsComentario] = []
    var codigo = ""
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var campoComentario: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.codigo = Utils.selectedObsCode
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Helper.getData(Routes.forComentarios(codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.comentarios = Dict.toArrayObsComentario(dict)
            self.tabla.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.allowsSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func updateDataForCode(code: String){
        codigo = code
        Helper.getData(Routes.forComentarios(codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.comentarios = Dict.toArrayObsComentario(dict)
            self.tabla.reloadData()
        })
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
                          
        Helper.postData(Routes.forPostComentario(), parametros, true, vcontroller: self, success: {(str:String) in
            
        })
    }
    
}

class ComentariosTVCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var comentario: UILabel!
}
