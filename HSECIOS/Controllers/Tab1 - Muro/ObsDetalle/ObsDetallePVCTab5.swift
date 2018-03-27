import UIKit

class ObsDetallePVCTab5: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(4)
        }
       /* HMuro.getObservacionesComentario(Utils.selectedObsCode, vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*tabla.delegate = self
        tabla.dataSource = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)*/
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
    /*
    func updateRowAt(_ indice: Int) {
        tabla.reloadRows(at: [IndexPath.init(row: indice, section: 0)], with: .automatic)
    }
    
    func successGettingData(_ comentario: [ObsComentario]) {
        Utils.comentario = comentario
        tabla.reloadData()
    }
    */
    func errorGettingData(_ error: String) {
        print(error)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Utils.comentario.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MuroDetallePVCTab4TVCell
        let comentario = Utils.comentario[indexPath.row]
        
        celda.autor.text = comentario.Nombres
        celda.fecha.text = Utils.str2date2str(comentario.Fecha)
        celda.comentario.text = comentario.Comentario
        let codigoImagen = "media/getAvatar/\(comentario.Estado)/Carnet.jpg"
        if let temp = Images.imagenes[codigoImagen] {
            celda.imagen.image = temp
        } else {
            Images.get(codigoImagen, tableView, indexPath.row)
        }
        return celda
    }
    /*
    @IBAction func enviarComentario(_ sender: Any) {
        HMuro.postObservacionesComentario("OBS00240761", inputComentario.text!, vcontroller: self, success: successPostingData(_:), error: errorPostingData(_:))
    }
    
    func successPostingData(_ result: String) {
        print("result: \(result)")
        switch result {
        case "1":
            HMuro.getObservacionesComentario("OBS00240761", vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))
        default:
            break
        }
    }
    */
    func errorPostingData(_ error: String) {
        print(error)
    }
    
}

class MuroDetallePVCTab4TVCell: UITableViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var autor: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var comentario: UILabel!
}
