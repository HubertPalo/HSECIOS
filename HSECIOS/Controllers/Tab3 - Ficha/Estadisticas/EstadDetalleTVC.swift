import UIKit

class EstadDetalleTVC: UITableViewController {
    
    var categoria = ""
    var facilitos: [FacilitoElement] = []
    var planesAccion: [PlanAccionGeneral] = []
    var observaciones: [MuroElement] = []
    var inspecciones: [MuroElement] = []
    var incidentes: [EstadisticaDetalle] = []
    var iperc: [EstadisticaDetalle] = []
    var auditorias: [EstadisticaDetalle] = []
    var simulacros: [EstadisticaDetalle] = []
    var reuniones: [EstadisticaDetalle] = []
    var comites: [EstadisticaDetalle] = []
    
    override func viewDidAppear(_ animated: Bool) {
        print("categoria appear: \(self.categoria)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("categoria load: \(self.categoria)")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categoria {
        case "-1":
            return facilitos.count
        case "00":
            return planesAccion.count
        case "01":
            return observaciones.count
        case "02":
            return inspecciones.count
        case "03":
            return incidentes.count
        case "04":
            return iperc.count
        case "05":
            return auditorias.count
        case "06":
            return simulacros.count
        case "07":
            return reuniones.count
        case "08":
            return comites.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch categoria {
        case "-1":
            // let unit = facilitos[indexPath.row]
            // let celda = tableView.dequeueReusableCell(withIdentifier: "celdaFac") as! EstadDetalleTVCellFac
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaFac") as! FacilitosTVCell
            let unit = facilitos[indexPath.row]
            celda.autor.text = unit.Persona
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.tipo.text = Utils.searchMaestroStatic("TIPOFACILITO", unit.Tipo ?? "")
            celda.estado.text = Utils.searchMaestroStatic("ESTADOFACILITO", unit.Estado ?? "")// unit.Estado
            celda.contenido.text = unit.Observacion
            print("\(indexPath) - editable: \(unit.Editable)")
            celda.viewEditable.isHidden = unit.Editable == "0" || unit.Editable == "2"
            celda.tiempo.attributedText = Utils.handleSeconds("\(unit.TiempoDiffMin ?? 0)")
            celda.limiteView.isHidden = indexPath.row == self.facilitos.count - 1
            Images.loadAvatarFromDNI(unit.UrlObs ?? "", celda.avatar, true, tableView, indexPath)
            // Images.loadAvatarFromDNI(unit.UrlObs, celda.avatar, true)
            if unit.UrlPrew == "" {
                celda.imagen.isHidden = true
            } else {
                celda.imagen.isHidden = false
                Images.loadImagePreviewFromCode(unit.UrlPrew ?? "", celda.imagen, {
                    tableView.reloadRows(at: [indexPath], with: .none)
                    /*(if (tableview.indexPathsForVisibleRows?.contains(indexPath))! {
                     tableview.reloadRows(at: [indexPath], with: .none)
                     }*/
                })
            }
            Images.loadIcon("ESTADOFACILITO.\(unit.Estado)", celda.imagenEstado)
            
            return celda
        case "00":
            /*let unit = planesAccion[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlan") as! EstadDetalleTVCellPlan
            celda.nombreCompleto.text = unit.SolicitadoPor
            celda.fecha.text = unit.FechaSolicitud
            celda.contenido.text = unit.DesPlanAccion*/
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlan") as! PlanesAccionPendientesTVCell
            let unit = self.planesAccion[indexPath.row]
            Images.loadAvatarFromDNI(unit.CodSolicitadoPor ?? "", celda.avatar, true, tableView, indexPath)
            Images.loadIcon("NIVELRIESGO.\(unit.CodNivelRiesgo)", celda.icono)
            celda.editableView.isHidden = unit.Editable != nil && unit.Editable != 1 && unit.Editable != 3
            celda.autor.text = unit.SolicitadoPor
            celda.fecha.text = Utils.str2date2str(unit.FechaSolicitud ?? "")
            celda.tipo.text = Utils.searchMaestroStatic("TABLAS", unit.CodTabla ?? "")
            celda.estado.text = Utils.searchMaestroStatic("ESTADOPLAN", unit.CodEstadoAccion ?? "")
            celda.contenido.text = unit.DesPlanAccion
            celda.limiteView.isHidden = indexPath.row == self.planesAccion.count - 1
            return celda
            // return celda
        case "01":
            let unit = observaciones[indexPath.row]
            /*let celda = tableView.dequeueReusableCell(withIdentifier: "celdaObs") as! EstadDetalleTVCellObs
            celda.nombreCompleto.text = unit.ObsPor
            celda.fecha.text = unit.Fecha
            celda.contenido.text = unit.Obs*/
            // return celda
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaObs") as! MuroTVCell1
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.detalle.attributedText = Utils.generateAttributedString(["Observación", " / \(Utils.searchMaestroDescripcion("TPOB", unit.Tipo ?? "")) / \(Utils.searchMaestroDescripcion("AREA", unit.Area ?? ""))"], ["HelveticaNeue-Bold", "HelveticaNeue"], [13,13], [UIColor.black, UIColor.black])
            // celda.detalle.text =
            celda.contenido.text = unit.Obs
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            
            Images.loadAvatarFromDNI(unit.UrlObs ?? "", celda.avatar, true, tableView, indexPath)
            /*if let imagen = Images.imagenes[unit.UrlObs] {
             celda.avatar.image = imagen
             } else {
             celda.avatar.image = Images.blank
             Images.getFromCode(unit.UrlObs, "Avatar", tableView, indexPath.row)
             }*/
            if unit.UrlPrew == "" {
                celda.imagen.isHidden = true
            } else {
                celda.imagen.isHidden = false
                if Images.imagenes[unit.UrlPrew ?? ""] != nil {
                    celda.imagen.image = Images.imagenes[unit.UrlPrew ?? ""]
                } else {
                    celda.imagen.image = Images.blank
                    Images.getFromCode(unit.UrlPrew ?? "", "Image", tableView, indexPath.row)
                }
            }
            /*
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
             */
            celda.riesgoImagen.image = Images.getImageForRisk(unit.NivelR ?? "")
            return celda
        case "02":
            let unit = inspecciones[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaIns") as! MuroTVCell2
            /*celda.nombreCompleto.text = unit.ObsPor
            celda.fecha.text = unit.Fecha
            celda.contenido1.text = unit.Obs
            return celda*/
            // let celda = tableView.dequeueReusableCell(withIdentifier: "inspeccion") as! MuroTVCell2
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            
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
            Images.loadAvatarFromDNI(unit.UrlObs ?? "", celda.avatar, true, tableView, indexPath)
            /*if let imagen = Images.imagenes[unit.UrlObs] {
             celda.avatar.image = imagen
             } else {
             celda.avatar.image = Images.blank
             Images.getFromCode(unit.UrlObs, "Avatar", tableView, indexPath.row)
             }*/
            
            if unit.UrlPrew == "" {
                celda.imagen.isHidden = true
            } else {
                celda.imagen.isHidden = false
                if Images.imagenes[unit.UrlPrew ?? ""] != nil {
                    celda.imagen.image = Images.imagenes[unit.UrlPrew ?? ""]
                } else {
                    celda.imagen.image = Images.blank
                    Images.getFromCode(unit.UrlPrew ?? "", "Image", tableView, indexPath.row)
                }
            }
            return celda
        case "03":
            let unit = incidentes[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.incidentes.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        case "04":
            let unit = iperc[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.iperc.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        case "05":
            let unit = auditorias[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.auditorias.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        case "06":
            let unit = simulacros[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.simulacros.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        case "07":
            let unit = reuniones[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.reuniones.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        case "08":
            let unit = comites[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.limiteView.isHidden = indexPath.row == self.comites.count - 1
            Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch categoria {
        case "-1":
            VCHelper.openFacilitoDetalle(self, self.facilitos[indexPath.row])
        case "00":
            VCHelper.openPlanAccionDetalle(self, self.planesAccion[indexPath.row])
        case "01":
            VCHelper.openObsDetalle(self, self.observaciones[indexPath.row])
        case "03":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.incidentes[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        case "04":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.iperc[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        case "05":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.auditorias[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        case "06":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.simulacros[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        case "07":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.reuniones[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        case "08":
            let padre = self.parent as! EstadDetalleVC
            padre.detFullToSend = self.comites[indexPath.row]
            padre.performSegue(withIdentifier: "toDetFull", sender: self)
        default:
            break
        }
    }
    
    @IBAction func clickEditable(_ sender: Any) {
        var superV = (sender as! UIButton).superview
        while !(superV is UITableViewCell) {
            superV = superV?.superview
        }
        let index = self.tableView.indexPath(for: superV as! UITableViewCell)!
        
        let unit = self.observaciones[index.row]
        
        Utils.openSheetMenu(self, "OPCIONES", nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], [{(editarAlert) in
            if (unit.Codigo ?? "").starts(with: "OBS") {
                VCHelper.openUpsertObservacion(self, "PUT", unit.Codigo ?? "")
            }
            }, {(eliminarAlert) in
                Alerts.presentAlert("Oops", "Funcionalidad aun no implementada", duration: 1, imagen: nil, viewController: self)
            }, nil])
    }
    
}

class EstadDetalleTVCellPlan: UITableViewCell {
    
    @IBOutlet weak var nombreCompleto: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var contenido: UILabel!
    
    @IBOutlet weak var limiteView: UIView!
    
}

class EstadDetalleTVCellFac: UITableViewCell {
    
    @IBOutlet weak var nombreCompleto: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var contenido: UILabel!
    
    @IBOutlet weak var limiteView: UIView!
    
}

class EstadDetalleTVCellObs: UITableViewCell {
    
    @IBOutlet weak var nombreCompleto: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var contenido: UILabel!
    
}

class EstadDetalleTVCellIns: UITableViewCell {
    
    @IBOutlet weak var nombreCompleto: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var contenido1: UILabel!
    
    @IBOutlet weak var contenido2: UILabel!
    
    @IBOutlet weak var contenido3: UILabel!
    
    @IBOutlet weak var stackContenido2: UIStackView!
    
    @IBOutlet weak var stackContenido3: UIStackView!
    
}

class EstadDetalleTVCellComun: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var limiteView: UIView!
}
