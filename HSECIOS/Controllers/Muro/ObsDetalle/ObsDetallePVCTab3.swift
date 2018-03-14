import UIKit

class ObsDetallePVCTab3: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var containerSuperior: UIView!
    
    @IBOutlet weak var tabla1: UITableView!
    
    @IBOutlet weak var tabla2: UITableView!
    
    @IBOutlet weak var tabla1CtHeight: NSLayoutConstraint!
    
    var documentos: [Multimedia] = []
    var multimedia: [Multimedia] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(2)
        }
        Helper.getData(Routes.forMultimedia(Utils.selectedObsCode), true, vcontroller: self, success: {(dict: NSDictionary) in
            let adjuntos = Dict.toArrayMultimedia(dict)
            self.documentos = []
            self.multimedia = []
            if adjuntos.count == 0 {
                let popup = UIViewController()
                popup.modalPresentationStyle = .overCurrentContext
                popup.view.backgroundColor = UIColor.black
                
                self.present(popup, animated: true, completion: nil)
            } else {
                for i in 0..<adjuntos.count {
                    switch adjuntos[i].TipoArchivo {
                    case "TP01":
                        self.multimedia.append(adjuntos[i])
                        break
                    case "TP02":
                        self.multimedia.append(adjuntos[i])
                        break
                    case "TP03":
                        self.documentos.append(adjuntos[i])
                        break
                    default:
                        break
                    }
                }
                self.tabla1.reloadData()
                self.tabla2.reloadData()
            }
        })
        //HMuro.getObservacionesMultimedia(codeObs, vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla1.delegate = self
        tabla1.dataSource = self
        tabla2.delegate = self
        tabla2.dataSource = self
    }
    
    //Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabla1 {
            return multimedia.count/2 + multimedia.count%2
        } else if tableView == tabla2 {
            return documentos.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabla1 {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! ObsDetallePVCTab3TVCell1
            
            celda.imagen1.image = Images.checked
            celda.imagen2.image = Images.unchecked
            
            let unit1 = multimedia[indexPath.row*2]
            if let imagen = Images.imagenes[unit1.Url] {
                celda.imagen1.image = imagen
            } else {
                Images.get(unit1.Url, tableView, indexPath.row)
            }
            
            if indexPath.row*2 + 1 != multimedia.count {
                let unit2 = multimedia[indexPath.row*2 + 1]
                if let imagen = Images.imagenes[unit2.Url] {
                    celda.imagen2.image = imagen
                } else {
                    Images.get(unit2.Url, tableView, indexPath.row)
                }
            } else {
                celda.imagen2.isHidden = true
            }
            return celda
        } else if tableView == tabla2 {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! ObsDetallePVCTab3TVCell2
            let unit = documentos[indexPath.row]
            celda.titulo.text = unit.Descripcion
            return celda
        }
        return UITableViewCell()
    }
    func errorGettingData(_ error: String) {
        print(error)
    }
    
    @IBAction func clickEnBotonSuperior(_ sender: Any) {
        tabla1.isHidden = !tabla1.isHidden
        if tabla1CtHeight != nil {
            tabla1CtHeight.isActive = !tabla1CtHeight.isActive
        }
    }
    
    @IBAction func clickEnBotonInferior(_ sender: Any) {
        //containerSuperior.isHidden = true
    }
    
    @IBAction func clickEnBoton1(_ sender: Any) {
        let celdaTabla = (sender as AnyObject).superview??.superview?.superview?.superview as! ObsDetallePVCTab3TVCell1
        let indexPathTabla = self.tabla1.indexPath(for: celdaTabla)
        let indice = indexPathTabla!.row * 2
        Images.showGallery(codigo: multimedia[indice].Url, list: multimedia, index: indice, viewController: self)
    }
    
    @IBAction func clickEnBoton2(_ sender: Any) {
        let celdaTabla = (sender as AnyObject).superview??.superview?.superview?.superview as! ObsDetallePVCTab3TVCell1
        let indexPathTabla = self.tabla1.indexPath(for: celdaTabla)
        let indice = indexPathTabla!.row * 2 + 1
        Images.showGallery(codigo: multimedia[indice].Url, list: multimedia, index: indice, viewController: self)
        
    }
}

class ObsDetallePVCTab3TVCell1: UITableViewCell {
    
    @IBOutlet weak var imagen1: UIImageView!
    
    @IBOutlet weak var imagen2: UIImageView!
    
    @IBOutlet weak var viewImagen1: UIView!
    
    @IBOutlet weak var viewImagen2: UIView!
    
}

class ObsDetallePVCTab3TVCell2: UITableViewCell {
    
    @IBOutlet weak var titulo: UILabel!
}
