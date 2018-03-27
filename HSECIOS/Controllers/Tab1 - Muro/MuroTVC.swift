import UIKit

class MuroTVC: UITableViewController {
    
    var data: [MuroElement] = []
    var numCeldas = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = data[indexPath.row]
        if unit.Codigo.starts(with: "OBS") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "observacion") as! MuroTVCell1
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.tipoarea.text = "\(Globals.obsTipo[unit.Tipo]!) - \(Globals.obsArea[unit.Area]!)"
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            celda.contenido.text = unit.Obs
            
            if let imagen = Images.imagenes[unit.UrlObs] {
                celda.avatar.image = imagen
            } else {
                celda.avatar.image = Images.blank
                //Images.get(unit.UrlObs, tableView, indexPath.row)
                Images.getFromCode(unit.UrlObs, "Avatar", tableView, indexPath.row)
            }
            //celda.comentarios.setTitle("\(unit.UrlPrew) - \(celda.imagenView.isHidden)", for: .normal)
            if unit.UrlPrew == "" {
                celda.imagenView.isHidden = true
                /*if !celda.imagenView.isHidden {
                 celda.imagenView.isHidden = true
                 }*/
            } else {
                celda.imagenView.isHidden = false
                /*if celda.imagenView.isHidden {
                 celda.imagenView.isHidden = false
                 }*/
                if Images.imagenes[unit.UrlPrew] != nil {
                    celda.imagen.image = Images.imagenes[unit.UrlPrew]
                } else {
                    celda.imagen.image = Images.blank
                    Images.getFromCode(unit.UrlPrew, "Image", tableView, indexPath.row)
                    //Images.get(unit.UrlPrew, tableView, indexPath.row)
                }
            }
            celda.luz.image = Images.getImageForRisk(unit.NivelR)
            /*switch unit.NivelR {
            case "AL":
                celda.luz.image = Images.lightRed
                break
            case "ME":
                celda.luz.image = Images.lightYellow
                break
            case "BA":
                celda.luz.image = Images.lightGreen
                break
            default:
                break
            }*/
            return celda
        } else if unit.Codigo.starts(with: "INS") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "inspeccion") as! MuroTVCell2
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            let tipo = Globals.insTipo[unit.Tipo] ?? "-"
            celda.tipoarea.text = tipo
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            
            let contenidoSplits = unit.Obs.split(separator: ";")
            let nivelRSplits = unit.NivelR.split(separator: ";")
            print("\(indexPath.row) - \(unit.NivelR) - \(nivelRSplits)")
            if nivelRSplits.count == 1 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                Utils.hideStackView(celda.stack2)
                Utils.hideStackView(celda.stack3)
                
            }
            if nivelRSplits.count == 2 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.contenido2.text = String(contenidoSplits[1])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.luz2.image = Images.getImageForRisk(String(nivelRSplits[1]))
                Utils.showStackView(celda.stack2)
                Utils.hideStackView(celda.stack3)
            }
            if nivelRSplits.count == 3 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.contenido2.text = String(contenidoSplits[1])
                celda.contenido3.text = String(contenidoSplits[2])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.luz2.image = Images.getImageForRisk(String(nivelRSplits[1]))
                celda.luz3.image = Images.getImageForRisk(String(nivelRSplits[2]))
                Utils.showStackView(celda.stack2)
                Utils.showStackView(celda.stack3)
            }
            
            if let imagen = Images.imagenes[unit.UrlObs] {
                celda.avatar.image = imagen
            } else {
                celda.avatar.image = Images.blank
                Images.getFromCode(unit.UrlObs, "Avatar", tableView, indexPath.row)
            }
            //celda.comentarios.setTitle("\(unit.UrlPrew) - \(celda.imagenView.isHidden)", for: .normal)
            if unit.UrlPrew == "" {
                celda.imagenView.isHidden = true
                /*if !celda.imagenView.isHidden {
                 celda.imagenView.isHidden = true
                 }*/
            } else {
                celda.imagenView.isHidden = false
                /*if celda.imagenView.isHidden {
                 celda.imagenView.isHidden = false
                 }*/
                if Images.imagenes[unit.UrlPrew] != nil {
                    celda.imagen.image = Images.imagenes[unit.UrlPrew]
                } else {
                    celda.imagen.image = Images.blank
                    Images.getFromCode(unit.UrlPrew, "Image", tableView, indexPath.row)
                }
            }
            return celda
        } else if unit.Codigo.starts(with: "NOT") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "noticia") as! MuroTVCell3
            celda.autor.text = unit.ObsPor
            if let imagen = Images.imagenes[unit.UrlObs] {
                print(unit.UrlObs)
                celda.avatar.image = imagen
            } else {
                Images.getFromCode(unit.UrlObs, "Avatar", tableView, indexPath.row)
            }
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            celda.contenido.text = unit.Obs
            celda.fecha.text = unit.Fecha
            if unit.UrlPrew != "" {
                celda.imagen.isHidden = false
                if let imagen = Images.imagenes[unit.UrlPrew] {
                    celda.imagen.image = imagen
                } else {
                    Images.getFromCode(unit.UrlPrew, "Image", tableView, indexPath.row)
                }
            } else {
                celda.imagen.isHidden = true
            }
            //celda.imagen.image
            celda.titulo.text = unit.Area
            
            return celda
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utils.selectedObsCode = data[indexPath.row].Codigo
        Tabs.indexObsDetalle = 0
        let celda = tableView.cellForRow(at: indexPath)
        if celda is MuroTVCell1 {
            self.parent?.performSegue(withIdentifier: "toDetalleObs", sender: self)
        }
        if celda is MuroTVCell2 {
            self.parent?.performSegue(withIdentifier: "toDetalleIns", sender: self)
        }
        if celda is MuroTVCell3 {
            self.parent?.performSegue(withIdentifier: "toDetalleNot", sender: self)
        }
        
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            // Actualizar, al llegar al extremo superior
            if self.parent is MuroVC {
                let padre = self.parent as! MuroVC
                padre.getDataForTable(numCeldas)
            }
            if self.parent is MuroSearchVC {
                let padre = self.parent as! MuroSearchVC
                padre.searchData()
            }
            //HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            print(maximumOffset - currentOffset)
            if maximumOffset - currentOffset <= -10 {
                // Actualizar con mas celdas, al llegar al extremo inferior
                numCeldas = numCeldas + 5
                if self.parent is MuroVC {
                    let padre = self.parent as! MuroVC
                    padre.getDataForTable(numCeldas)
                }
                if self.parent is MuroSearchVC {
                    let padre = self.parent as! MuroSearchVC
                    padre.nroitems = padre.nroitems + 10
                    padre.searchData()
                }
                
                
                //HMuro.getObservaciones(1, elementos, vcontroller: self, success: successGettingData(_:), error: handleError(_:))
            }
        }
    }
    @IBAction func clickEnComentarios(_ sender: Any) {
        let celda = (sender as AnyObject).superview??.superview?.superview?.superview
        if celda is MuroTVCell1 {
            let indice = tableView.indexPath(for: celda as! MuroTVCell1)!.row
            Utils.selectedObsCode = data[indice].Codigo
            Tabs.indexObsDetalle = 3
            self.parent?.performSegue(withIdentifier: "toDetalleObs", sender: self)
        }
        if celda is MuroTVCell2 {
            let indice = tableView.indexPath(for: celda as! MuroTVCell2)!.row
            Utils.selectedObsCode = data[indice].Codigo
            Tabs.indexObsDetalle = 3
            self.parent?.performSegue(withIdentifier: "toDetalleIns", sender: self)
        }
        if celda is MuroTVCell3 {
            let indice = tableView.indexPath(for: celda as! MuroTVCell3)!.row
            Utils.selectedObsCode = data[indice].Codigo
            Tabs.indexObsDetalle = 3
            self.parent?.performSegue(withIdentifier: "toDetalleNot", sender: self)
        }
    }
    
}

class MuroTVCell1: UITableViewCell {
    // Celda Observacion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipoarea: UILabel!
    @IBOutlet weak var luz: UIImageView!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenView: UIView!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var comentarios: UIButton!
}

class MuroTVCell2: UITableViewCell {
    // Celda Inspeccion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipoarea: UILabel!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var luz1: UIImageView!
    @IBOutlet weak var luz2: UIImageView!
    @IBOutlet weak var luz3: UIImageView!
    @IBOutlet weak var contenido1: UILabel!
    @IBOutlet weak var contenido2: UILabel!
    @IBOutlet weak var contenido3: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenView: UIView!
    
    @IBOutlet weak var comentarios: UIButton!
}

class MuroTVCell3: UITableViewCell {
    // Celda Noticia
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var comentarios: UIButton!
}
