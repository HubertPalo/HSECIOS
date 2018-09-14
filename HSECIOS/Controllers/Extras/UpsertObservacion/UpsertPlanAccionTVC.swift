import UIKit

class UpsertPlanAccionTVC: UITableViewController, UITextViewDelegate {
    
    // var modo = 1
    // var codigo = ""
    var modo = ""
    
    @IBOutlet weak var botonTopIzq: UIBarButtonItem!
    var obsPlan = PlanAccionDetalle()
    // var modoObs = false
    var responsables: [Persona] = []
    var fechaInicial = Date()
    var fechaFinal = Date()
    
    // var alClickTopDer : ((_ plan: PlanAccionDetalle) -> Void)?
    var actualizarTabla: ((_: PlanAccionDetalle) -> Void)?
    var editarPlan: ((_: PlanAccionDetalle) -> Void)?
    // var idReplaceObs = -1
    // var idReplaceInsObs = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadModo(_ modo: String, _ plan: PlanAccionDetalle, _ editarPlan: ((_: PlanAccionDetalle) -> Void)?, _ actualizarTablaExterna: ((_: PlanAccionDetalle) -> Void)?) {
        self.modo = modo
        
        self.setTitleAndImage((modo == "ADD" ? "Nuevo" : "Editar") + " plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
        self.obsPlan = plan
        self.editarPlan = editarPlan
        //self.idReplaceObs = idReplaceObs
        // se lf.idReplaceInsObs = idReplaceInsObs
        self.fechaInicial = Utils.str2date(plan.FecComprometidaInicial ?? "") ?? Date()
        self.fechaFinal = Utils.str2date(plan.FecComprometidaFinal ?? "") ?? Date()
        self.responsables = []
        let codSplits = (plan.CodResponsables ?? "").components(separatedBy: ";")
        if codSplits.count > 0 && codSplits[0] != "" {
            let nomSplits = (plan.Responsables ?? "").components(separatedBy: ";")
            for i in 0..<codSplits.count {
                let persona = Persona()
                persona.CodPersona = codSplits[i]
                let nombreCargo = nomSplits[i].components(separatedBy: ":")
                persona.Cargo = nombreCargo[1]
                persona.Nombres = nombreCargo[0]
                self.responsables.append(persona)
            }
        }
        self.actualizarTabla = actualizarTablaExterna
        self.tableView.reloadData()
    }
    
    /*func loadModo2(_ modo: String, _ plan: PlanAccionDetalle, _ modoObservacion: Bool, _ actualizarTablaExterna: (() -> Void)?) {
        self.modoObs = modoObservacion
        switch modo {
        case "ADD":
            self.setTitleAndImage("Nuevo plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
            // self.modo = 1
        case "PUT":
            self.setTitleAndImage("Editar plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
            // self.modo = 2
        default:
            break
        }
        // self.modo = modo
        self.obsPlan = plan
        // self.codigo = plan ?? ""
        let codSplits = (plan.CodResponsables ?? "").components(separatedBy: ";")
        self.responsables = []
        if codSplits.count > 0 && codSplits[0] != "" {
            let nomSplits = (plan.Responsables ?? "").components(separatedBy: ";")
            for i in 0..<codSplits.count {
                let persona = Persona()
                persona.CodPersona = codSplits[i]
                let nombreCargo = nomSplits[i].components(separatedBy: ":")
                persona.Cargo = nombreCargo[1]
                persona.Nombres = nombreCargo[0]
                self.responsables.append(persona)
            }
        }
        // self.alClickTopDer = alClickTopDer
        self.actualizarTabla = actualizarTablaExterna
        self.tableView.reloadData()
    }
    
    func loadModo(_ modo: Int, _ plan: PlanAccionDetalle, _ muroElement: MuroElement, _ alClickTopDer: ((_ plan: PlanAccionDetalle) -> Void)?) {
        if modo == 1 {
            self.setTitleAndImage("Nuevo plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
        }
        if modo == 2 {
            self.setTitleAndImage("Editar plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
        }
        // self.modo = modo
        self.obsPlan = plan
        // self.codigo = muroElement.Codigo ?? ""
        let codSplits = (plan.CodResponsables ?? "").components(separatedBy: ";")
        self.responsables = []
        if codSplits.count > 0 && codSplits[0] != "" {
            let nomSplits = (plan.Responsables ?? "").components(separatedBy: ";")
            for i in 0..<codSplits.count {
                let persona = Persona()
                persona.CodPersona = codSplits[i]
                let nombreCargo = nomSplits[i].components(separatedBy: ":")
                persona.Cargo = nombreCargo[1]
                persona.Nombres = nombreCargo[0]
                self.responsables.append(persona)
            }
        }
        self.alClickTopDer = alClickTopDer
        self.tableView.reloadData()
    }
    
    func loadModo(_ modo: String, _ codigo: String, _ alClickTopDer: ((_ plan: PlanAccionDetalle) -> Void)?) {
        // self.modo = modo == "GET" ? 1: 2
        if modo == "PUT" {
            self.setTitleAndImage("Editar plan de acción", UIImage.init(named: "planesPendientes"), UIColor.white)
        }
        // self.codigo = codigo
        Rest.getDataGeneral(Routes.forPlanAccionDetalle(codigo), true, success: {(resultValue:Any?,data:Data?) in
            self.obsPlan = Dict.dataToUnit(data!)!
            self.fechaInicial = self.obsPlan.FecComprometidaInicial?.toDate() ?? Date()
            self.fechaFinal = self.obsPlan.FecComprometidaFinal?.toDate() ?? Date()
            let codSplits = (self.obsPlan.CodResponsables ?? "").components(separatedBy: ";")
            self.responsables = []
            if codSplits.count > 0 && codSplits[0] != "" {
                let nomSplits = (self.obsPlan.Responsables ?? "").components(separatedBy: ";")
                for i in 0..<codSplits.count {
                    let persona = Persona()
                    persona.CodPersona = codSplits[i]
                    let nombreCargo = nomSplits[i].components(separatedBy: ":")
                    persona.Cargo = nombreCargo[1]
                    persona.Nombres = nombreCargo[0]
                    self.responsables.append(persona)
                }
            }
            self.alClickTopDer = alClickTopDer
            self.tableView.reloadData()
            print(resultValue)
        }, error: nil)
    }*/
    
    func textViewDidChange(_ textView: UITextView) {
        self.obsPlan.DesPlanAccion = textView.text
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.obsPlan.CodAccion == "-1" ? 1 : 5
        case 1:
            return 5
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return self.responsables.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
            celda.texto.isHidden = true
            celda.view.isHidden = true
            celda.contentView.backgroundColor = UIColor.groupTableViewBackground
            return celda.contentView
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
            celda.texto.isHidden = false
            celda.view.isHidden = true
            celda.contentView.backgroundColor = UIColor.groupTableViewBackground
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Fecha Comprometida", "HelveticaNeue-Bold", 14)
            return celda.contentView
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
            celda.texto.isHidden = false
            celda.view.isHidden = true
            celda.contentView.backgroundColor = UIColor.groupTableViewBackground
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Tarea:", "HelveticaNeue-Bold", 14)
            return celda.contentView
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
            celda.texto.isHidden = false
            celda.view.isHidden = false
            celda.contentView.backgroundColor = UIColor.groupTableViewBackground
            celda.texto.attributedText = Utils.addInitialRedAsterisk("Responsables", "HelveticaNeue-Bold", 14)
            return celda.contentView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 5
        case 2:
            return 30
        case 3:
            return 30
        case 4:
            return 30
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
            switch indexPath.row {
            case 0:
                celda.texto1.text = "Fecha de Solicitud:"
                celda.texto2.text = Utils.str2date2str(self.obsPlan.FechaSolicitud ?? "")
            case 1:
                celda.texto1.text = "Referencia:"
                var tipoReferencia = "-"
                if (self.obsPlan.NroDocReferencia ?? "").starts(with: "OBS") {
                    tipoReferencia = "Observaciones"
                }
                if (self.obsPlan.NroDocReferencia ?? "").starts(with: "INS") {
                    tipoReferencia = "Inspecciones"
                }
                celda.texto2.text = tipoReferencia
            case 2:
                celda.texto1.text = "Nro Documento:"
                celda.texto2.text = self.obsPlan.NroDocReferencia
            case 3:
                celda.texto1.text = "Código Acción:"
                celda.texto2.text = self.obsPlan.CodAccion
            case 4:
                celda.texto1.text = "Estado:"
                celda.texto2.text = Utils.searchMaestroStatic("ESTADOPLAN", self.obsPlan.CodEstadoAccion ?? "")
            default:
                break
            }
            return celda
        case 1:
            switch indexPath.row {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto
                celda.texto1.attributedText = Utils.addInitialRedAsterisk("Solicitado Por:", "HelveticaNeue-Bold", 13)
                celda.texto2.text = self.obsPlan.SolicitadoPor ?? ""
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada:", "HelveticaNeue-Bold", 13)
                var dato = Utils.searchMaestroDescripcion("ACTR", self.obsPlan.CodActiRelacionada ?? "")
                dato = dato == "" ? "- SELECCIONE -" : dato
                celda.boton.setTitle(dato, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Nivel Riesgo:", "HelveticaNeue-Bold", 13)
                var dato = Utils.searchMaestroStatic("NIVELRIESGO", self.obsPlan.CodNivelRiesgo ?? "")
                dato = dato == "" ? "- SELECCIONE -" : dato
                celda.boton.setTitle(dato, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Área HSEC:", "HelveticaNeue-Bold", 13)
                var dato = Utils.searchMaestroDescripcion("AREA", self.obsPlan.CodAreaHSEC ?? "")
                dato = dato == "" ? "- SELECCIONE -" : dato
                celda.boton.setTitle(dato, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 4:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Tipo Acción:", "HelveticaNeue-Bold", 13)
                var dato = Utils.searchMaestroDescripcion("TPAC", self.obsPlan.CodTipoAccion ?? "")
                dato = dato == "" ? "- SELECCIONE -" : dato
                celda.boton.setTitle(dato, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            default:
                return UITableViewCell()
            }
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto1Boton
            celda.texto.text = indexPath.row == 0 ? "Inicial:" : "Final:"
            celda.boton.setTitle(Utils.date2str(indexPath.row == 0 ? self.fechaInicial : self.fechaFinal, "dd 'de' MMMM").uppercased(), for: .normal)
            return celda
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! Celda1Texto1TextView
            celda.textView.text = self.obsPlan.DesPlanAccion
            celda.textView.delegate = self
            return celda
        case 4:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda7") as! Celda2Texto1Boton
            let unit = self.responsables[indexPath.row]
            celda.texto1.text = unit.Nombres
            celda.texto2.text = unit.Cargo
            celda.boton.tag = indexPath.row
            return celda
        default:
            return UITableViewCell()
        }
        /*let celda = tableView.dequeueReusableCell(withIdentifier: "celda\(indexPath.row)") as! AddObsPlanAccionTVCell1
        celda.titulo.text = "Titulo \(indexPath)"
        return celda*/
    }
    
    @IBAction func clickSolicitadoPor(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona:Persona) in
            self.obsPlan.SolicitadoPor = persona.Nombres
            self.obsPlan.CodSolicitadoPor = persona.CodPersona
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        })
    }
    
    @IBAction func clickBotonGeneral(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 1:
            Utils.showDropdown(boton, Utils.maestroDescripcion["ACTR"] ?? [], {(index,item) in
                self.obsPlan.CodActiRelacionada = Utils.maestroCodTipo["ACTR"]?[index] ?? ""
            })
        case 2:
            Utils.showDropdown(boton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index,item) in
                self.obsPlan.CodNivelRiesgo = Utils.maestroStatic1["NIVELRIESGO"]?[index] ?? ""
            })
        case 3:
            Utils.showDropdown(boton, Utils.maestroDescripcion["AREA"] ?? [], {(index,item) in
                self.obsPlan.CodAreaHSEC = Utils.maestroCodTipo["AREA"]?[index] ?? ""
            })
        case 4:
            Utils.showDropdown(boton, Utils.maestroDescripcion["TPAC"] ?? [], {(index,item) in
                self.obsPlan.CodTipoAccion = Utils.maestroCodTipo["TPAC"]?[index] ?? ""
            })
        default:
            break
        }
    }
    
    @IBAction func clickFecha(_ sender: Any) {
        switch (sender as! UIButton).tag {
        case 0:
            Utils.openDatePicker("Seleccione Fecha Inicial", Date(), nil, fechaFinal, chandler: {(date:Date) in
                self.fechaInicial = date
                self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 2)], with: .none)
            })
        case 1:
            Utils.openDatePicker("Seleccione Fecha Final", Date(), fechaInicial, nil, chandler: {(date:Date) in
                self.fechaFinal = date
                self.tableView.reloadRows(at: [IndexPath.init(row: 1, section: 2)], with: .none)
            })
        default:
            break
        }
    }
    
    @IBAction func clickResponsable(_ sender: Any) {
        VCHelper.openFiltroPersonas(self, {(personas) in
            for persona in personas {
                var addPersonaFlag = true
                for i in 0..<self.responsables.count {
                    addPersonaFlag = addPersonaFlag && self.responsables[i].NroDocumento != persona.NroDocumento
                }
                if addPersonaFlag {
                    self.responsables.append(persona)
                    self.tableView.reloadSections([4], with: .none)
                }
            }
        })
    }
    
    @IBAction func clickBorrarResponsable(_ sender: Any) {
        self.responsables.remove(at: (sender as! UIButton).tag)
        self.tableView.reloadSections([4], with: .none)
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        self.presentarAlertaDatosSinGuardar {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        self.obsPlan.FecComprometidaInicial = Utils.date2str(self.fechaInicial, "YYYY-MM-dd")
        self.obsPlan.FecComprometidaFinal = Utils.date2str(self.fechaFinal, "YYYY-MM-dd")
        self.obsPlan.CodResponsables = ""
        self.obsPlan.Responsables = ""
        var codResponsables = [String]()
        var responsables = [String]()
        for i in 0..<self.responsables.count {
            let persona = self.responsables[i]
            codResponsables.append(persona.CodPersona ?? "")
            responsables.append("\(persona.Nombres ?? ""):\(persona.Cargo ?? "")")
        }
        self.obsPlan.CodResponsables = codResponsables.joined(separator: ";")
        self.obsPlan.Responsables = responsables.joined(separator: ";")
        
        var nombreVariable = ""
        if self.obsPlan.CodActiRelacionada == nil || self.obsPlan.CodActiRelacionada == "" {
            nombreVariable = "Actividad Relacionada"
        }
        if self.obsPlan.CodNivelRiesgo == nil || self.obsPlan.CodNivelRiesgo == "" {
            nombreVariable = "Nivel Riesgo"
        }
        if self.obsPlan.CodAreaHSEC == nil || self.obsPlan.CodAreaHSEC == "" {
            nombreVariable = "Area HSEC"
        }
        if self.obsPlan.CodTipoAccion == nil || self.obsPlan.CodTipoAccion == "" {
            nombreVariable = "Tipo de acción"
        }
        if self.obsPlan.FecComprometidaInicial == nil || self.obsPlan.FecComprometidaInicial == "" {
            nombreVariable = "Fecha Inicial"
        }
        if self.obsPlan.FecComprometidaFinal == nil || self.obsPlan.FecComprometidaFinal == "" {
            nombreVariable = "Fecha Final"
        }
        if self.obsPlan.DesPlanAccion == nil || self.obsPlan.DesPlanAccion == "" {
            nombreVariable = "Tarea"
        }
        if self.responsables.count == 0 {
            nombreVariable = "Responsables"
        }
        
        if nombreVariable != "" {
            self.presentAlert("El siguiente campo no puede estar vacío", nombreVariable, .alert, 2, nil, [], [], actionHandlers: [])
            return
        }
        
        if let funcion = self.editarPlan {
            self.editarPlan?(self.obsPlan)
            self.actualizarTabla?(self.obsPlan)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            return
        }
        /*if self.modo == "ADD" && self.idReplaceObs == -1 {
            
        }
        
        if self.idReplaceObs != -1 {
            if self.idReplaceObs == -10 && self.idReplaceInsObs > 0 {
                
            }
            if self.idReplaceInsObs != -1 {
                Globals.UOTab4Planes[idReplaceObs] = self.obsPlan
            } else {
                Globals.UITab3LocalPlanes[idReplaceInsObs][idReplaceObs] = self.obsPlan
            }
            
            return
        }
        
        if self.idReplaceObs >= 0 {
            if self.idReplaceInsObs >= 0 {
                Globals.UOTab4Planes[idReplaceObs] = self.obsPlan
            } else {
                Globals.UITab3LocalPlanes[idReplaceInsObs][idReplaceObs] = self.obsPlan
            }
            self.actualizarTabla?()
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            return
        }*/
        
        var showplan = self.obsPlan.copy()
        // showplan.CodAccion = "-1"
        showplan.Responsables = nil
        //showplan.NroDocReferencia = Globals.UOCodigo
        showplan.CodTipoObs = showplan.CodTipoObs ?? ""
        showplan.SolicitadoPor = nil
        let params: [String:String] = Dict.dataToUnit(Dict.unitToData(showplan)!)!
        Rest.postDataGeneral(Routes.forPostPlanAccion(), params, true, success: {(resultValue:Any?,data:Data?) in
            print(resultValue)
            if (resultValue as! String) == "-1" {
                self.presentAlert("Error", "Ocurrió un error", .alert, 2, nil, [], [], actionHandlers: [])
            } else {
                self.presentarAlertaDeseaFinalizar({(actionAceptar) in
                    self.actualizarTabla?(self.obsPlan)
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }, {(cancelarAction) in
                    self.obsPlan.CodAccion = resultValue as! String
                })
                
            }
        }, error: nil)
        
        /*if self.modoObs {
            if Globals.UOCodigo == "" {
                if let click = self.alClickTopDer {
                    click(self.obsPlan)
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Globals.UOTab4Planes.append(self.obsPlan)
                    actualizarTabla?()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                //planDetalle.NroDocReferencia = Globals.UOCodigo
                
                var showplan = self.obsPlan.copy()
                showplan.CodAccion = "-1"
                showplan.Responsables = nil
                showplan.NroDocReferencia = Globals.UOCodigo
                showplan.CodTipoObs = showplan.CodTipoObs ?? ""
                showplan.SolicitadoPor = nil
                print(self.obsPlan.Responsables)
                print(self.obsPlan.SolicitadoPor)
                let params: [String:String] = Dict.dataToUnit(Dict.unitToData(showplan)!)!
                Rest.postDataGeneral(Routes.forPostPlanAccion(), params, true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    if (resultValue as! String) == "-1" {
                        self.presentAlert("Error", "Ocurrió un error", .alert, 2, nil, [], [], actionHandlers: [])
                    } else {
                        self.presentarAlertaDeseaFinalizar({(actionAceptar) in
                            Globals.UOTab4Planes.append(self.obsPlan)
                            self.actualizarTabla?()
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                        }, {(cancelarAction) in
                            self.obsPlan.CodAccion = resultValue as! String
                        })
                        
                    }
                }, error: nil)
            }
        } else {
            self.alClickTopDer?(self.obsPlan)
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }*/
    }
}
