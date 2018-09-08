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
        /*case "-1":
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaFac") as! FacilitosTVCell
            let unit = facilitos[indexPath.row]
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if (unit.UrlPrew ?? "") != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            Images.loadIcon("ESTADOFACILITO.\(unit.Estado)", celda.imagenEstado)
            celda.autor.text = unit.Persona
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.tipo.text = Utils.searchMaestroStatic("TIPOFACILITO", unit.Tipo ?? "")
            celda.estado.text = Utils.searchMaestroStatic("ESTADOFACILITO", unit.Estado ?? "")// unit.Estado
            celda.contenido.text = unit.Observacion
            print("\(indexPath) - editable: \(unit.Editable)")
            celda.viewEditable.isHidden = unit.Editable == "0" || unit.Editable == "2"
            celda.tiempo.attributedText = Utils.handleSeconds("\(unit.TiempoDiffMin ?? 0)")
            celda.limiteView.isHidden = indexPath.row == self.facilitos.count - 1
            return celda*/
        case "00":
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaPlan") as! PlanesAccionPendientesTVCell
            let unit = self.planesAccion[indexPath.row]
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.CodSolicitadoPor ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.CodSolicitadoPor ?? "")")
            }
            Images.loadIcon("NIVELRIESGO.\(unit.CodNivelRiesgo ?? "")", celda.icono)
            celda.empresa.text = unit.Empresa
            celda.editableView.isHidden = unit.Editable != nil && unit.Editable != 1 && unit.Editable != 3
            celda.autor.text = unit.SolicitadoPor
            celda.fecha.text = Utils.str2date2str(unit.FechaSolicitud ?? "")
            celda.tipo.text = Utils.searchMaestroStatic("TABLAS", unit.CodTabla ?? "")
            celda.estado.text = Utils.searchMaestroStatic("ESTADOPLAN", unit.CodEstadoAccion ?? "")
            celda.contenido.text = unit.DesPlanAccion
            celda.limiteView.isHidden = indexPath.row == self.planesAccion.count - 1
            return celda
        /*case "01":
            let unit = observaciones[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaObs") as! MuroTVCell1
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.detalle.attributedText = Utils.generateAttributedString(["Observación", " / \(Utils.searchMaestroDescripcion("TPOB", unit.Tipo ?? "")) / \(Utils.searchMaestroDescripcion("AREA", unit.Area ?? ""))"], ["HelveticaNeue-Bold", "HelveticaNeue"], [13,13], [UIColor.black, UIColor.black])
            // celda.detalle.text =
            celda.contenido.text = unit.Obs
            celda.comentarios.setTitle("\(unit.Comentarios ?? 0) comentarios", for: .normal)
            
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if (unit.UrlPrew ?? "") != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            
            /*if unit.UrlPrew == "" {
                celda.imagen.isHidden = true
            } else {
                celda.imagen.isHidden = false
                if Images.imagenes[unit.UrlPrew ?? ""] != nil {
                    celda.imagen.image = Images.imagenes[unit.UrlPrew ?? ""]
                } else {
                    celda.imagen.image = Images.blank
                    Images.getFromCode(unit.UrlPrew ?? "", "Image", tableView, indexPath.row)
                }
            }*/
            celda.riesgoImagen.image = Images.getImageForRisk(unit.NivelR ?? "")
            return celda
        case "02":
            let unit = inspecciones[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaIns") as! MuroTVCell2
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
            if (unit.UrlPrew ?? "") != "" {
                celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
            }
            celda.autor.text = unit.ObsPor
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.comentarios.setTitle("\(unit.Comentarios) comentarios", for: .normal)
            
            let contenidoSplits = (unit.Obs ?? "").split(separator: ";")
            let nivelRSplits = (unit.NivelR ?? "").split(separator: ";")
            
            if nivelRSplits.count == 1 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.stack2.isHidden = true
                celda.stack3.isHidden = true
                /*Utils.hideStackView(celda.stack2)
                Utils.hideStackView(celda.stack3)*/
                
            }
            if nivelRSplits.count == 2 {
                celda.contenido1.text = String(contenidoSplits[0])
                celda.contenido2.text = String(contenidoSplits[1])
                celda.luz1.image = Images.getImageForRisk(String(nivelRSplits[0]))
                celda.luz2.image = Images.getImageForRisk(String(nivelRSplits[1]))
                celda.stack2.isHidden = false
                celda.stack3.isHidden = true
                /*Utils.showStackView(celda.stack2)
                Utils.hideStackView(celda.stack3)*/
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
                /*Utils.showStackView(celda.stack2)
                Utils.showStackView(celda.stack3)*/
            }
            
            return celda*/
        case "03":
            let unit = incidentes[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.incidentes.count - 1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            // Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            
            return celda
        case "04":
            let unit = iperc[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.iperc.count - 1
            // Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            return celda
        case "05":
            let unit = auditorias[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.auditorias.count - 1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            return celda
        case "06":
            let unit = simulacros[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.simulacros.count - 1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            return celda
        case "07":
            let unit = reuniones[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.reuniones.count - 1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            return celda
        case "08":
            let unit = comites[indexPath.row]
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetalleTVCellComun
            celda.nombreCompleto.text = unit.Responsable
            celda.contenido.text = unit.Descripcion
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.limiteView.isHidden = indexPath.row == self.comites.count - 1
            celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
            celda.avatar.layer.masksToBounds = true
            // Images.loadAvatarFromDNI(unit.ResponsableDNI, celda.avatar, true, tableView, indexPath)
            if (unit.ResponsableDNI ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.ResponsableDNI ?? "")")
            }
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch categoria {
        case "-1":
            VCHelper.openFacilitoDetalle(self, self.facilitos[indexPath.row].CodObsFacilito ?? "")
        case "00":
            VCHelper.openPlanAccionDetalle(self, self.planesAccion[indexPath.row])
        case "01":
            VCHelper.openObsDetalle(self, self.observaciones[indexPath.row].Codigo!, self.observaciones[indexPath.row].Tipo!, false)
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
        let indice = (sender as! UIButton).tag
        let unit = self.planesAccion[indice]
        self.presentAlert("OPCIONES", nil, .actionSheet, nil, nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(editarAlert) in
            VCHelper.openUpsertPlanAccion(self.parent!, "PUT", unit.CodAccion!, {(planAccion) in
                var copia = planAccion.copy()
                copia.Responsables = nil
                copia.SolicitadoPor = nil
                Rest.postDataGeneral(Routes.forPostPlanAccion(), Dict.unitToParams(copia), true, success: {(resultValue:Any?,data:Data?) in
                    var strResult = resultValue as! String
                    if strResult == "-1" {
                        self.presentAlert("Error", "Ocurrió un error al ingresar el plan de acción", .alert, 2, nil, [], [], actionHandlers: [])
                    } else {
                        self.presentAlert("Operación exitosa", "Se editó el Plan de Acción correctamente", .alert, 2, nil, [], [], actionHandlers: [])
                    }
                }, error: {(error) in
                    print(error)
                })
            })
            }, {(eliminarAlert) in
                self.presentAlert("¿Desea eliminar item?", "Plan Acción \(unit.CodAccion!)", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(actionAceptar) in
                    Rest.getDataGeneral(Routes.forPlanAccionDelete(unit.CodAccion!), true, success: {(resultValue:Any?,data:Data?) in
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

/*class EstadDetalleTVCellPlan: UITableViewCell {
    
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
    
}*/

class EstadDetalleTVCellComun: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nombreCompleto: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var limiteView: UIView!
}
