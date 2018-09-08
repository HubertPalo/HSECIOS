import UIKit

class MuroTVC: UITableViewController {
    
    var data: [MuroElement] = []
    var numCeldas = 10
    
    var dataDisqueCopartida = 100
    
    // var alClickCelda: ((_ elemento: MuroElement) -> Void)?
    // var alClickEditar: ((_ elemento: MuroElement) -> Void)?
    // var alClickComentarios: ((_ elemento: MuroElement) -> Void)?
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        // self.presentAlert("Token", Utils.FCMToken, .alert, 1, nil, [], [], actionHandlers: [])
    }
    
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
        switch (unit.Codigo ?? "").prefix(3) {
        case "OBS":
            let celda = tableView.dequeueReusableCell(withIdentifier: "observacion") as! MuroTVCell1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.avatarBoton.tag = indexPath.row
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.detalle.attributedText = Utils.generateAttributedString(["Observación", " / \(Utils.searchMaestroDescripcion("TPOB", unit.Tipo ?? "")) / \(Utils.searchMaestroDescripcion("AREA", unit.Area ?? ""))"], ["HelveticaNeue-Bold", "HelveticaNeue"], [12,12], [UIColor.darkGray, UIColor.darkGray])
            celda.empresa.text = unit.Empresa
            celda.contenido.text = unit.Obs
            
            
            celda.imagenView.isHidden = (unit.UrlPrew ?? "").isEmpty
            celda.imagenBoton.tag = indexPath.row
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.riesgoImagen.image = Images.getImageForRisk(unit.NivelR ?? "")
            celda.comentarios.isHidden = (unit.Comentarios ?? 0) == -10
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.comentarios.tag = indexPath.row
            celda.limiteView.isHidden = indexPath.row == self.data.count - 1
            return celda
        case "INS":
            let celda = tableView.dequeueReusableCell(withIdentifier: "inspeccion") as! MuroTVCell2
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.avatarBoton.tag = indexPath.row
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.empresa.text = unit.Empresa
            
            let contenidoSplits = (unit.Obs ?? "").split(separator: ";")
            let nivelRSplits = (unit.NivelR ?? "").split(separator: ";")
            
            if nivelRSplits.count == 0 {
                celda.contenido1.text = nil
                celda.luz1.image = nil
                celda.stack2.isHidden = true
                celda.stack3.isHidden = true
            }
            if nivelRSplits.count == 1 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.stack2.isHidden = true
                celda.stack3.isHidden = true
            }
            if nivelRSplits.count == 2 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.contenido2.text = String(contenidoSplits[1])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.luz2.image = Images.getImageForRisk(String(nivelRSplits[1]))
                celda.stack2.isHidden = false
                celda.stack3.isHidden = true
            }
            if nivelRSplits.count == 3 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.contenido2.text = String(contenidoSplits[1])
                celda.contenido3.text = String(contenidoSplits[2])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.luz2.image = Images.getImageForRisk(String(nivelRSplits[1]))
                celda.luz3.image = Images.getImageForRisk(String(nivelRSplits[2]))
                celda.stack2.isHidden = false
                celda.stack3.isHidden = false
            }
            
            
            celda.imagenView.isHidden = (unit.UrlPrew ?? "").isEmpty
            celda.imagenBoton.tag = indexPath.row
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.comentarios.isHidden = (unit.Comentarios ?? 0) == -10
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.comentarios.tag = indexPath.row
            celda.limiteView.isHidden = indexPath.row == self.data.count - 1
            return celda
        case "NOT":
            let celda = tableView.dequeueReusableCell(withIdentifier: "noticia") as! MuroTVCell3
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.avatarBoton.tag = indexPath.row
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            
            celda.contenido.text = unit.Obs
            
            celda.titulo.text = unit.Area
            
            
            celda.imagenView.isHidden = (unit.UrlPrew ?? "").isEmpty
            celda.imagenBoton.tag = indexPath.row
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.comentarios.isHidden = (unit.Comentarios ?? 0) == -10
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.comentarios.tag = indexPath.row
            celda.limiteView.isHidden = indexPath.row == self.data.count - 1
            return celda
        case "OBF":
            let celda = tableView.dequeueReusableCell(withIdentifier: "facilito") as! MuroTVCell4
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if unit.UrlObs != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.avatarBoton.tag = indexPath.row
            celda.autor.text = unit.ObsPor
            
            celda.contenido.text = unit.Obs
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.detalle.text = Utils.searchMaestroStatic("TIPOFACILITO", unit.Tipo ?? "")
            
            celda.imagenView.isHidden = (unit.UrlPrew ?? "").isEmpty
            celda.imagenBoton.tag = indexPath.row
            if unit.UrlPrew != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.comentarios.isHidden = (unit.Comentarios ?? 0) == -10
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            celda.comentarios.tag = indexPath.row
            celda.limiteView.isHidden = indexPath.row == self.data.count - 1
            return celda
        default:
            return UITableViewCell()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = self.data[indexPath.row]
        switch (unit.Codigo ?? "").prefix(3) {
        case "OBS":
            VCHelper.openObsDetalle(self.parent!, unit.Codigo ?? "", unit.Tipo ?? "", false)
        case "INS":
            VCHelper.openInsDetalle(self.parent!, unit, false)
        case "NOT":
            VCHelper.openNotDetalle(self.parent!, unit)
        case "OBF":
            VCHelper.openFacilitoDetalle(self.parent!, unit.Codigo ?? "")
        default:
            break
        }
        // self.alClickCelda?(unit)
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
        let indice = (sender as! UIButton).tag
        let unit = self.data[indice]
        switch (unit.Codigo ?? "").prefix(3) {
        case "OBS":
            VCHelper.openObsDetalle(self.parent!, unit.Codigo ?? "", unit.Tipo ?? "", true)
        case "INS":
            VCHelper.openInsDetalle(self.parent!, unit, true)
        case "NOT":
            VCHelper.openNotDetalle(self.parent!, unit)
        case "OBF":
            VCHelper.openFacilitoDetalle(self.parent!, unit.Codigo ?? "")
        default:
            break
        }
    }
    
    @IBAction func clickAvatar(_ sender: Any) {
        let boton = sender as! UIButton
        Utils.showFichaFor(self.data[boton.tag].UrlObs ?? "")
        /*var superviwe = (sender as! UIButton).superview
        while !(superviwe is UITableViewCell) {
            superviwe = superviwe?.superview
        }
        var codigo = self.tableView.indexPath(for: superviwe as! UITableViewCell)
        print("este es el codigo : \(codigo)")
        Utils.showFichaFor(self.data[codigo!.row].UrlObs ?? "")*/
    }
    
    @IBAction func clickImagen(_ sender: Any) {
        let unit = self.data[(sender as! UIButton).tag]
        let multimedia = FotoVideo()
        multimedia.Correlativo = Int(unit.UrlPrew!)
        self.showGaleria([multimedia], 0)
    }
    
    @IBAction func clickEditable(_ sender: Any) {
        var superV = (sender as! UIButton).superview
        while !(superV is UITableViewCell) {
            superV = superV?.superview
        }
        let index = self.tableView.indexPath(for: superV as! UITableViewCell)!
        let unit = self.data[index.row]
        self.presentAlert("OPCIONES", nil, .actionSheet, nil, nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(editarAlert) in
            switch (unit.Codigo ?? "").prefix(3) {
            case "OBS":
                VCHelper.upsertObservacion(self, "PUT", unit.Codigo!)
            case "INS":
                VCHelper.upsertInspeccion(self, "PUT", unit.Codigo!)
            case "OBF":
                VCHelper.openUpsertFacilito(self, "PUT", unit.Codigo!)
            default:
                break
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
                    }, error: nil)
                    }, nil])
            }, nil])
    }
}

class MuroTVCell1: UITableViewCell {
    // Celda Observacion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarBoton: UIButton!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var empresa: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var editableBoton: UIButton!
    @IBOutlet weak var riesgoImagen: UIImageView!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenBoton: UIButton!
    @IBOutlet weak var imagenView: UIView!
    @IBOutlet weak var comentarios: UIButton!
    @IBOutlet weak var limiteView: UIView!
}

class MuroTVCell2: UITableViewCell {
    // Celda Inspeccion
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarBoton: UIButton!
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
    @IBOutlet weak var empresa: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var editableBoton: UIButton!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenBoton: UIButton!
    @IBOutlet weak var imagenView: UIView!
    @IBOutlet weak var comentarios: UIButton!
    @IBOutlet weak var limiteView: UIView!
}

class MuroTVCell3: UITableViewCell {
    // Celda Noticia
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarBoton: UIButton!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenBoton: UIButton!
    @IBOutlet weak var imagenView: UIView!
    @IBOutlet weak var comentarios: UIButton!
    @IBOutlet weak var limiteView: UIView!
}

class MuroTVCell4: UITableViewCell {
    // Celda Facilito
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarBoton: UIButton!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var editableBoton: UIButton!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenBoton: UIButton!
    @IBOutlet weak var imagenView: UIView!
    @IBOutlet weak var comentarios: UIButton!
    @IBOutlet weak var limiteView: UIView!
}
