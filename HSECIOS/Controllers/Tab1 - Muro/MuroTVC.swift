import UIKit

class MuroTVC: UITableViewController {
    
    var data: [MuroElement] = []
    var numCeldas = 10
    
    var dataDisqueCopartida = 100
    
    var alClickCelda: ((_ elemento: MuroElement) -> Void)?
    var alClickEditar: ((_ elemento: MuroElement) -> Void)?
    var alClickComentarios: ((_ elemento: MuroElement) -> Void)?
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addMoreData(_ data: [MuroElement]) {
        var codigos: [String] = []
        var elementosPorAgregar: [MuroElement] = []
        for i in 0..<self.data.count {
            codigos.append(self.data[i].Codigo ?? "")
        }
        for i in 0..<data.count {
            if !codigos.contains(data[i].Codigo ?? "") {
                elementosPorAgregar.append(data[i])
            }
        }
        self.data.append(contentsOf: elementosPorAgregar)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let unit = data[indexPath.row]
        if (unit.Codigo ?? "").starts(with: "OBS") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "observacion") as! MuroTVCell1
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.detalle.attributedText = Utils.generateAttributedString(["Observación", " / \(Utils.searchMaestroDescripcion("TPOB", unit.Tipo ?? "")) / \(Utils.searchMaestroDescripcion("AREA", unit.Area ?? ""))"], ["HelveticaNeue-Bold", "HelveticaNeue"], [13,13], [UIColor.black, UIColor.black])
            celda.contenido.text = unit.Obs
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.riesgoImagen.image = Images.getImageForRisk(unit.NivelR ?? "")
            return celda
        } else if (unit.Codigo ?? "").starts(with: "INS") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "inspeccion") as! MuroTVCell2
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            
            let contenidoSplits = (unit.Obs ?? "").split(separator: ";")
            let nivelRSplits = (unit.NivelR ?? "").split(separator: ";")
            
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
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            return celda
        } else if (unit.Codigo ?? "").starts(with: "NOT") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "noticia") as! MuroTVCell3
            celda.autor.text = unit.ObsPor
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.contenido.text = unit.Obs
            celda.fecha.text = unit.Fecha
            celda.titulo.text = unit.Area
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            return celda
        } else if (unit.Codigo ?? "").starts(with: "OBF") {
            let celda = tableView.dequeueReusableCell(withIdentifier: "facilito") as! MuroTVCell4
            celda.autor.text = unit.ObsPor
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.contenido.text = unit.Obs
            celda.fecha.text = unit.Fecha
            celda.detalle.text = Utils.searchMaestroStatic("TIPOFACILITO", unit.Tipo ?? "")
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            return celda
        }
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = self.data[indexPath.row]
        self.alClickCelda?(unit)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            self.alScrollLimiteTop?()
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -10 {
                self.alScrollLimiteBot?()
            }
        }
    }
    
    @IBAction func clickEnComentarios(_ sender: Any) {
        var superview = (sender as AnyObject).superview??.superview
        while !(superview is UITableViewCell) {
            superview = superview?.superview
        }
        let unitRow = self.tableView.indexPath(for: superview as! UITableViewCell)!.row
        self.alClickComentarios?(self.data[unitRow])
        /*if celda is MuroTVCell1 {
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
        }*/
    }
    
    @IBAction func clickAvatar(_ sender: Any) {
        var superviwe = (sender as! UIButton).superview
        while !(superviwe is UITableViewCell) {
            superviwe = superviwe?.superview
        }
        var codigo = self.tableView.indexPath(for: superviwe as! UITableViewCell)
        print("este es el codigo : \(codigo)")
        Utils.showFichaFor(self.data[codigo!.row].UrlObs ?? "")
    }
    
    @IBAction func clickEditable(_ sender: Any) {
        var superV = (sender as! UIButton).superview
        while !(superV is UITableViewCell) {
            superV = superV?.superview
        }
        let index = self.tableView.indexPath(for: superV as! UITableViewCell)!
        let unit = self.data[index.row]
        
        Utils.openSheetMenu(self, "OPCIONES", nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], [{(editarAlert) in
            if (unit.Codigo ?? "").starts(with: "OBS") {
                VCHelper.upsertObservacion(self, "PUT", unit.Codigo!)
            } else if (unit.Codigo ?? "").starts(with: "INS") {
                VCHelper.upsertInspeccion(self, "PUT", unit.Codigo!)
                // VCHelper.openUpsertObservacion(self, "PUT", unit.Codigo ?? "")
            }
            }, {(eliminarAlert) in
                var tipo = ""
                var ruta = ""
                if (unit.Codigo ?? "").starts(with: "OBS") {
                    tipo = "Observación"
                    ruta = "/Observaciones/Delete/\(unit.Codigo!)"
                }
                if (unit.Codigo ?? "").starts(with: "INS") {
                    tipo = "Inspección"
                    ruta = "/Inspecciones/Delete/\(unit.Codigo!)"
                }
                if (unit.Codigo ?? "").starts(with: "OBF") {
                    tipo = "Facilito"
                    ruta = "/ObsFacilito/Delete/\(unit.Codigo!)"
                }
                if (unit.Codigo ?? "").starts(with: "NOT") {
                    tipo = "Noticia"
                    ruta = "/Noticias/Delete/\(unit.Codigo!)"
                }
                self.presentAlert("¿Desea eliminar item?", "\(tipo) \(unit.Codigo ?? "")", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(alert) in
                    Rest.getDataGeneral("\(Config.urlBase)\(ruta)", true, success: {(resultValue:Any?,data:Data?) in
                        let respuesta = resultValue as! String
                        if respuesta == "1" {
                            self.presentAlert("Item eliminado", nil, .alert, 1, nil, [], [], actionHandlers: [])
                        } else {
                            self.presentAlert("Error", "Ocurrió un error al intentar eliminar el item", .alert, 2, nil, [], [], actionHandlers: [])
                        }
                        
                        // hacer mas cosas al borrar, como actualizar la lista
                    }, error: nil)
                    }, nil])
            }, nil])
        
        
        
    }
}

class MuroTVCell1: UITableViewCell {
    // Celda Observacion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var riesgoImagen: UIImageView!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var comentarios: UIButton!
}

class MuroTVCell2: UITableViewCell {
    // Celda Inspeccion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    @IBOutlet weak var luz1: UIImageView!
    @IBOutlet weak var luz2: UIImageView!
    @IBOutlet weak var luz3: UIImageView!
    @IBOutlet weak var contenido1: UILabel!
    @IBOutlet weak var contenido2: UILabel!
    @IBOutlet weak var contenido3: UILabel!
    @IBOutlet weak var imagen: UIImageView!
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

class MuroTVCell4: UITableViewCell {
    // Celda Facilito
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var comentarios: UIButton!
}
