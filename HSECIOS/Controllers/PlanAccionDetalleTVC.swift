import UIKit

class PlanAccionDetalleTVC: UITableViewController {
    
    var responsables: [Persona] = []
    var codPlanAccion = ""
    // var plan = PlanAccionDetalle()
    var mejoras: [AccionMejora] = []
    var section2ShouldShow = false
    var section3ShouldShow = false
    var codTipoObs = ""
    var section3Title = ""
    let leftLabels: [String] = ["Código de acción", "Nro. doc. de referencia", "Área", "Nivel de riesgo", "Descripción", "Fecha de solicitud", "Estado", "Solicitado por", "Actividad relacionada", "Referencia", "Tipo de acción", "Fecha inicial", "Fecha final"]
    var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("Plan de acción", UIImage.init(named: "editar"))
    }
    
    func cleanData() {
        self.rightLabels = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
        self.responsables = []
        self.mejoras = []
        self.section2ShouldShow = false
        self.section3ShouldShow = false
        self.tableView.reloadData()
    }
    
    func loadData(_ nuevo: PlanAccionGeneral) {
        self.section2ShouldShow = nuevo.Editable == 2 || nuevo.Editable == 3
        self.codPlanAccion = nuevo.CodAccion ?? ""
        Rest.getDataGeneral(Routes.forPlanAccionDetalle(nuevo.CodAccion ?? ""), true, success: {(resultValue:Any?,data:Data?) in
            let plan: PlanAccionDetalle = Dict.dataToUnit(data!) ?? PlanAccionDetalle()
            self.codTipoObs = plan.CodTipoObs ?? ""
            self.rightLabels = [plan.CodAccion ?? "", plan.NroDocReferencia ?? "", Utils.searchMaestroDescripcion("AREA", plan.CodAreaHSEC ?? ""), Utils.searchMaestroStatic("NIVELRIESGO", plan.CodNivelRiesgo ?? ""), plan.DesPlanAccion ?? "", Utils.str2date2str(plan.FechaSolicitud ?? ""), Utils.searchMaestroStatic("ESTADOPLAN", plan.CodEstadoAccion ?? ""), plan.SolicitadoPor ?? "", Utils.searchMaestroDescripcion("ACTR", plan.CodActiRelacionada ?? ""), Utils.searchMaestroStatic("REFERENCIAPLAN", plan.CodReferencia ?? ""), Utils.searchMaestroDescripcion("TPAC", plan.CodTipoAccion ?? ""), Utils.str2date2str(plan.FecComprometidaInicial ?? ""), Utils.str2date2str(plan.FecComprometidaFinal ?? "")]
            var splitsNombres = (plan.Responsables ?? "").components(separatedBy: ";")
            var splitsCodigos = (plan.CodResponsables ?? "").components(separatedBy: ";")
            var nuevosResponsables: [Persona] = []
            for i in 0..<splitsNombres.count {
                var data = splitsNombres[i].components(separatedBy: ":")
                if data.count == 2 {
                    let nuevaPersona = Persona()
                    nuevaPersona.Nombres = data[0]
                    nuevaPersona.Cargo = data[1]
                    nuevaPersona.CodPersona = splitsCodigos[i]
                    nuevosResponsables.append(nuevaPersona)
                }
            }
            self.responsables = nuevosResponsables
            self.section3ShouldShow = (plan.NroDocReferencia ?? "").starts(with: "INS") || (plan.NroDocReferencia ?? "").starts(with: "OBS")
            self.section3Title = (plan.NroDocReferencia ?? "").starts(with: "INS") ? "VER INSPECCIÓN" : "VER OBSERVACIÓN"
            self.tableView.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forPlanAccionDetalle(nuevo.CodAccion), true, vcontroller: self, success: {(dict:NSDictionary) in
            let plan = Dict.toPlanAccionDetalle(dict)
            self.rightLabels = [plan.CodAccion, plan.NroDocReferencia, Utils.searchMaestroDescripcion("AREA", plan.CodAreaHSEC), Utils.searchMaestroStatic("NIVELRIESGO", plan.CodNivelRiesgo), plan.DesPlanAccion, Utils.str2date2str(plan.FechaSolicitud), Utils.searchMaestroStatic("ESTADOPLAN", plan.CodEstadoAccion), plan.SolicitadoPor, Utils.searchMaestroDescripcion("ACTR", plan.CodActiRelacionada), Utils.searchMaestroStatic("REFERENCIAPLAN", plan.CodReferencia), Utils.searchMaestroDescripcion("TPAC", plan.CodTipoAccion), Utils.str2date2str(plan.FecComprometidaInicial), Utils.str2date2str(plan.FecComprometidaFinal)]
            var splitsNombres = plan.Responsables.components(separatedBy: ";")
            var splitsCodigos = plan.CodResponsables.components(separatedBy: ";")
            var nuevosResponsables: [Persona] = []
            for i in 0..<splitsNombres.count {
                var data = splitsNombres[i].components(separatedBy: ":")
                if data.count == 2 {
                    let nuevaPersona = Persona()
                    nuevaPersona.Nombres = data[0]
                    nuevaPersona.Cargo = data[1]
                    nuevaPersona.CodPersona = splitsCodigos[i]
                    nuevosResponsables.append(nuevaPersona)
                }
            }
            self.responsables = nuevosResponsables
            self.section3ShouldShow = plan.NroDocReferencia.starts(with: "INS") || plan.NroDocReferencia.starts(with: "OBS")
            self.section3Title = plan.NroDocReferencia.starts(with: "INS") ? "VER INSPECCIÓN" : "VER OBSERVACIÓN"
            self.tableView.reloadData()
        })*/
        
        Rest.getDataGeneral(Routes.forAccionMejora(nuevo.CodAccion ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            self.mejoras = Dict.dataToArray(data!).Data
            // self.mejoras = Dict.toArrayAccionMejora(dict).Data
            // self.tableView.reloadSections([2], with: .none)
            self.tableView.reloadData()
        }, error: nil)
    }
    
    func loadData(_ nuevo: PlanAccionDetalle) {
        self.setTitleAndImage("Obs/Plan de acción", Images.observacion)
        self.codPlanAccion = nuevo.CodAccion ?? ""
        self.section2ShouldShow = false
        self.section3ShouldShow = false
        self.rightLabels[0] = nuevo.CodAccion ?? ""
        self.rightLabels[1] = nuevo.NroDocReferencia ?? ""
        self.rightLabels[2] = Utils.searchMaestroDescripcion("AREA", nuevo.CodAreaHSEC ?? "")
        self.rightLabels[3] = Utils.searchMaestroStatic("NIVELRIESGO", nuevo.CodNivelRiesgo ?? "")
        self.rightLabels[4] = nuevo.DesPlanAccion ?? ""
        self.rightLabels[5] = Utils.str2date2str(nuevo.FechaSolicitud ?? "")
        self.rightLabels[6] = Utils.searchMaestroStatic("ESTADOPLAN", nuevo.CodEstadoAccion ?? "")
        self.rightLabels[7] = nuevo.SolicitadoPor ?? ""
        self.rightLabels[8] = Utils.searchMaestroDescripcion("ACTR", nuevo.CodActiRelacionada ?? "")
        self.rightLabels[9] = Utils.searchMaestroStatic("REFERENCIAPLAN", nuevo.CodReferencia ?? "")
        self.rightLabels[10] = Utils.searchMaestroDescripcion("TPAC", nuevo.CodTipoAccion ?? "")
        self.rightLabels[11] = Utils.str2date2str(nuevo.FecComprometidaInicial ?? "")
        self.rightLabels[12] = Utils.str2date2str(nuevo.FecComprometidaFinal ?? "")
        
        var splits = (nuevo.Responsables ?? "").components(separatedBy: ";")
        var nuevosResponsables: [Persona] = []
        for i in 0..<splits.count {
            var data = splits[i].components(separatedBy: ":")
            if data.count == 2 {
                let nuevaPersona = Persona()
                nuevaPersona.Nombres = data[0]
                nuevaPersona.Cargo = data[1]
                nuevosResponsables.append(nuevaPersona)
            }
        }
        self.responsables = nuevosResponsables
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        case 1:
            return 30
        case 2:
            if self.section2ShouldShow {
                return 60
            }
            return CGFloat.leastNonzeroMagnitude
        case 3:
            if self.section3ShouldShow {
                return 40
            }
            return CGFloat.leastNonzeroMagnitude
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            /*let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.attributedText = Utils.generateAttributedString(["Plan de acción"], ["HelveticaNeue-Bold"], [16], [UIColor.white])
            return header.contentView*/
            return nil
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
            header.texto.attributedText = Utils.generateAttributedString(["Responsables"], ["HelveticaNeue"], [14], [UIColor.white])
            return header.contentView
        case 2:
            if self.section2ShouldShow {
                return tableView.dequeueReusableCell(withIdentifier: "celda2")!.contentView
            }
            return nil
        case 3:
            // var titulo = ""
            /*if self.plan.NroDocReferencia.starts(with: "INS") {
                titulo = "VER INSPECCIÓN"
            } else if self.plan.NroDocReferencia.starts(with: "OBS") {
                titulo = "VER OBSERVACIÓN"
            }*/
            if section3ShouldShow {
                let header = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Boton
                header.boton.setTitle(self.section3Title, for: .normal)
                return header.contentView
            }
            return nil
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.leftLabels.count
        case 1:
            return self.responsables.count
        case 2:
            return self.mejoras.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda2Texto
            celda.texto1.text = self.leftLabels[indexPath.row]
            celda.texto2.text = self.rightLabels[indexPath.row]
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda2Texto
            let unit = self.responsables[indexPath.row]
            celda.texto1.text = unit.Nombres
            celda.texto2.text = unit.Cargo
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! PlanAccionDetalleTVCell
            let unit = self.mejoras[indexPath.row]
            celda.autor.text = unit.Persona
            celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
            celda.contenido.text = unit.Descripcion
            let porcent: CGFloat = CGFloat(Int(unit.PorcentajeAvance ?? "") ?? 0) / CGFloat(100)
            
            
            celda.porcentaje.text = "\(unit.PorcentajeAvance ?? "-")%"
            celda.progreso.progress = Float(porcent)
            celda.progreso.progressTintColor = porcent < 0.5 ? UIColor.red : UIColor.green
            celda.editableView.isHidden = unit.Editable != "1" && unit.Editable != "3"
            celda.editableBoton.tag = indexPath.row
            celda.limiteView.isHidden = indexPath.row == self.mejoras.count - 1
            if (unit.UrlObs ?? "") != "" {
                celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
            }
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            let unit = self.mejoras[indexPath.row]
            
            VCHelper.openUpsertPlanAccionMejora(self, "GET", unit.Correlativo, self.codPlanAccion, self.responsables, nil)
            // VCHelper.openGetPlanAccionMejora(self, unit, self.codPlanAccion, self.responsables[0])
        }
    }
    
    @IBAction func clickAddAccionMejora(_ sender: Any) {
        VCHelper.openUpsertPlanAccionMejora(self, "ADD", nil, self.codPlanAccion, self.responsables, {(atencion) in
            Rest.getDataGeneral(Routes.forAccionMejora(self.codPlanAccion), false, success: {(resultValue:Any?,data:Data?) in
                self.mejoras = Dict.dataToArray(data!).Data
                self.tableView.reloadData()
            }, error: nil)
        })
    }
    
    @IBAction func clickEditAccionMejora(_ sender: Any) {
        let indice = (sender as! UIButton).tag
        let unit = self.mejoras[indice]
        
        self.presentAlert("Opciones", nil, .actionSheet, nil, nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(actionEditar) in
            VCHelper.openUpsertPlanAccionMejora(self, "PUT", unit.Correlativo, self.codPlanAccion, self.responsables, {(accion) in
                Rest.getDataGeneral(Routes.forAccionMejora(self.codPlanAccion), false, success: {(resultValue:Any?,data:Data?) in
                    self.mejoras = Dict.dataToArray(data!).Data
                    self.tableView.reloadData()
                }, error: nil)
            })
            }, {(actionEliminar) in
                self.presentAlert("¿Desea eliminar item?", "Accion Mejora \(unit.Correlativo!)", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(alert) in
                    Rest.getDataGeneral(Routes.forAccionMejoraDelete("\(unit.Correlativo!)"), true, success: {(resultValue:Any?,data:Data?) in
                        let respuesta = resultValue as! String
                        if respuesta == "1" {
                            self.presentAlert("Item eliminado", nil, .alert, 1, nil, [], [], actionHandlers: [])
                            Rest.getDataGeneral(Routes.forAccionMejora(self.codPlanAccion), false, success: {(resultValue:Any?,data:Data?) in
                                self.mejoras = Dict.dataToArray(data!).Data
                                self.tableView.reloadData()
                            }, error: nil)
                        } else {
                            self.presentAlert("Error", "Ocurrió un error al intentar eliminar el item", .alert, 2, nil, [], [], actionHandlers: [])
                        }
                    }, error: nil)
                    }, nil])
                print("click eliminar")
            }, nil])
    }
    
    
    @IBAction func clickBotonInf(_ sender: Any) {
        var unit = MuroElement()
        unit.Codigo = self.rightLabels[1]
        // unit.Tipo = self.rightLabels[0]
        if self.rightLabels[1].starts(with: "INS") {
            VCHelper.openInsDetalle(self, unit, false)
        } else {
            VCHelper.openObsDetalle(self, unit.Codigo!, self.codTipoObs, false)
        }
    }
    
    
}
class PlanAccionDetalleTVCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var progreso: UIProgressView!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var porcentaje: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var editableBoton: UIButton!
    @IBOutlet weak var limiteView: UIView!
}
