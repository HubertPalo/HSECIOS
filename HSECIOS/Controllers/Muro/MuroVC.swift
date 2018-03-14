import UIKit

class MuroVC: UIViewController {
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    
    @IBOutlet weak var botonNewObs: UIButton!
    
    var observaciones: [MuroElement] = []
    
    var elementos = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabla.delegate = self
        //tabla.dataSource = self
        
        getDataForTable(10)
        //HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
        
        botonNewObs.layer.cornerRadius = 5
        botonNewObs.layer.borderWidth = 1
        
        botonNewObs.layer.borderColor = UIColor.gray.cgColor
        Utils.setImageCircle(imagenPerfil)
        //imagenPerfil.layer.cornerRadius = imagenPerfil.frame.height/2
        //imagenPerfil.layer.masksToBounds = true
        if Images.imagenes[UserInfo.Avatar] != nil {
            imagenPerfil.image = Images.imagenes[UserInfo.Avatar]
            imagenPerfil.layer.cornerRadius = imagenPerfil.frame.height/2
        } else {
            Images.get(UserInfo.Avatar, success: checkForAvatar)
        }
        
        
    }
    
    func getDataForTable(_ cant: Int) {
        Helper.getData(Routes.forMuro(cant), true, vcontroller: self, success: { (dict:NSDictionary) in
            let hijo = self.childViewControllers[0] as! MuroTVC
            hijo.data = Dict.toArrayMuroElement(dict)
            hijo.tableView.reloadData()
        })
        //HMuro.getObservaciones(1, cant, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
    }
    
    func success(_ dict: NSDictionary){
        let units = Dict.toArrayMuroElement(dict)
    }
    
    func successGettingData(_ data: [MuroElement]) {
        observaciones = data
        //tabla.reloadData()
        let hijo = self.childViewControllers[0] as! MuroTVC
        hijo.data = data
        hijo.tableView.reloadData()
    }
    
    func checkForAvatar() {
        if Images.imagenes[UserInfo.Avatar] != nil {
            imagenPerfil.image = Images.imagenes[UserInfo.Avatar]
            imagenPerfil.layer.cornerRadius = imagenPerfil.frame.height/2
        }
    }
    
    func updateRowAt(_ index: Int) {
        
    }
    
    func handleError(_ error: String){
        print(error)
    }
    /*
    // Actualizar o cargar mas al llegar a los extremos
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            // Actualizar, al llegar al extremo superior
            HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            print(maximumOffset - currentOffset)
            if maximumOffset - currentOffset <= -10 {
                // Actualizar con mas celdas, al llegar al extremo inferior
                elementos = elementos + 5
                HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
            }
        }
    }
    
    //Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observaciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "observaciones") as! ObservacionesTVCell
        let unit = observaciones[indexPath.row]
        celda.area.text = unit.Area
        celda.autor.text = unit.ObsPor
        celda.fecha.text = Utils.str2date2str(unit.Fecha)
        celda.descripcion.text = unit.Obs
        celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
        if let imagen = Images.imagenes[unit.UrlObs] {
            celda.rostro.image = imagen
        } else {
            celda.rostro.image = Images.blank
            Images.get(unit.UrlObs, tableView, indexPath.row)
        }
        
        if unit.UrlPrew == "" {
            celda.imagenView.isHidden = true
            //celda.imagenCtWidth.isActive = false
        } else {
            celda.imagenView.isHidden = false
            //celda.imagenCtWidth.isActive = true
            if Images.imagenes[unit.UrlPrew] != nil {
                celda.imagen.image = Images.imagenes[unit.UrlPrew]
            } else {
                celda.imagen.image = Images.blank
                Images.get(unit.UrlPrew, tableView, indexPath.row)
            }
        }
        switch unit.NivelR {
        case "AL":
            celda.circulo.image = Images.lightRed
            break
        case "ME":
            celda.circulo.image = Images.lightYellow
            break
        case "BA":
            celda.circulo.image = Images.lightGreen
            break
        default:
            break
        }
        
        celda.tipo.text = Globals.obsTipo[unit.Tipo]
        celda.area.text = Globals.obsArea[unit.Area]
        /*switch unit.Tipo {
        case "TO01":
            celda.tipo.text = "Comportamiento"
            break
        case "TO02":
            celda.tipo.text = "Condicion"
            break
        case "TO03":
            celda.tipo.text = "Tarea"
            break
        case "TO04":
            celda.tipo.text = "Interaccion Seguridad"
            break
        default:
            celda.tipo.text = Utils.observaciones[indice].Tipo
            break
        }
        switch Utils.observaciones[indice].Area {
        case "001":
            celda.area.text = "Seguridad"
            break
        case "002":
            celda.area.text = "Salud Ocupacional"
            break
        case "004":
            celda.area.text = "Comunidades"
            break
        default:
            celda.area.text = Utils.observaciones[indice].Area
            break
        }*/
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indice = indexPath.row
        Utils.selectedObsCode = observaciones[indexPath.row].Codigo
        //let padre = self.parent as! ObservacionesVC
        Tabs.indexMuro = 0
        self.performSegue(withIdentifier: "toDetalle", sender: self)
    }
 */
    
    @IBAction func clickEnCamara(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "murodet"))!, animated: true, completion: nil)
    }
    /*
    @IBAction func clickEnComentarios(_ sender: Any) {
        let celdaTabla = (sender as AnyObject).superview??.superview?.superview?.superview as! ObservacionesTVCell
        let indice = tabla.indexPath(for: celdaTabla)!.row
        Utils.selectedObsCode = Utils.observaciones[indice].Codigo
        Tabs.indexMuro = 3
        self.performSegue(withIdentifier: "toDetalle", sender: self)
    }*/
}

class ObservacionesTVCell: UITableViewCell {
    
    @IBOutlet weak var rostro: UIImageView!
    
    @IBOutlet weak var autor: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var tipo: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var circulo: UIImageView!
    
    @IBOutlet weak var imagen: UIImageView!
    
    @IBOutlet weak var imagenView: UIView!
    
    @IBOutlet weak var descripcion: UILabel!
    
    @IBOutlet weak var comentarios: UIButton!
    
    @IBOutlet weak var imagenCtWidth: NSLayoutConstraint!
}


