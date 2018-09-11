import UIKit

class ComentariosVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var comentarios : [Comentario] = []
    var codigo = ""
    // var shouldReloadTabla = false
    
    var forzarActualizacionDeComentarios: (() -> Void)?
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var campoComentario: UITextField!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        tabla.allowsSelection = false
        self.campoComentario.delegate = self
        /*if shouldReloadTabla {
            tabla.reloadData()
        }*/
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
    }
    
    func loadComentarios(_ codigo: String) {
        self.codigo = codigo
        self.comentarios = []
        //self.shouldReloadTabla = true
        self.tabla?.reloadData()
        Rest.getDataGeneral(Routes.forComentarios(codigo), false, success: {(resultValue:Any?,data:Data?) in
            let arrayComentarios: ArrayGeneral<Comentario> = Dict.dataToArray(data!)
            self.comentarios = arrayComentarios.Data//Dict.toArrayObsComentario(dict)
            // self.shouldReloadTabla = true
            self.tabla?.reloadData()
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
        var info = notification.userInfo
        // NSDictionary* info = [aNotification userInfo];
        var kbSize = (info![UIKeyboardFrameEndUserInfoKey] as! CGRect).size
        // CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        var contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        // UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scroll.contentInset = contentInsets;
        scroll.scrollIndicatorInsets = contentInsets;
        
        var aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!aRect.contains(campoComentario.frame.origin) ) {
            scroll.scrollRectToVisible(campoComentario.frame, animated: true)
            // [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
        }
        // scroll.scrollRectToVisible(campoComentario.frame, animated: true)
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }*/
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInsets = UIEdgeInsets.zero;
        scroll.contentInset = contentInsets;
        scroll.scrollIndicatorInsets = contentInsets;
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }*/
    }
    
    // tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comentarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! CeldaComentario
        let unit = comentarios[indexPath.row]
        celda.autor.text = unit.Nombres
        celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
        celda.comentario.text = unit.Comentario
        celda.limiteView.isHidden = indexPath.row == self.comentarios.count - 1
        celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
        celda.avatar.layer.masksToBounds = true
        if (unit.Estado ?? "") != "" {
            celda.avatar.image = Images.getImageFor("A-\(unit.Estado ?? "")")
        }
        return celda
    }
    // tabla
    
    @IBAction func clickEnEnviar(_ sender: Any) {
        self.view.endEditing(true)
        let parametros = ["CodComentario":codigo,"Comentario": campoComentario.text!]
                          
        Rest.postDataGeneral(Routes.forPostComentario(), parametros, true, success: {(resultValue:Any?,data:Data?) in
            self.presentAlert("Comentario enviado", nil, .alert, 2, nil, [], [], actionHandlers: [])
            self.forzarActualizacionDeComentarios?()
            self.campoComentario.text = nil
            // Alerts.presentAlert("Comentario Enviado", "Enviado", imagen: nil, viewController: self)
        }, error: {(error) in
            self.presentAlert("Error", error, .alert, 2, nil, [], [], actionHandlers: [])
            // Alerts.presentAlert("Error", error, duration: 2, imagen: nil, viewController: self)
        })
        /*Rest.postData(Routes.forPostComentario(), parametros, true, vcontroller: self, success: {(str:String) in
            
        })*/
    }
    
}

/*class ComentariosTVCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var comentario: UILabel!
}*/
