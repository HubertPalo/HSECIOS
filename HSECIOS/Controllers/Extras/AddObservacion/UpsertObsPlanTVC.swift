import UIKit

class UpsertObsPlanTVC: UITableViewController, UITextViewDelegate {
    
    var modo = "ADD"
    var codigo = ""
    
    var obsPlan = PlanAccionDetalle()
    
    var responsables: [Persona] = []
    var fechaInicial = Date()
    var fechaFinal = Date()
    var tarea = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadModo(_ modo: String, _ plan: PlanAccionDetalle, _ muroElement: MuroElement) {
        self.modo = modo
        self.obsPlan = plan
        self.codigo = muroElement.Codigo ?? ""
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.tarea = textView.text
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.modo == "ADD" ? 1 : 5
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
                celda.texto2.text = "Observaciones"
            case 2:
                celda.texto1.text = "Nro Documento:"
                celda.texto2.text = self.obsPlan.NroDocReferencia
            case 3:
                celda.texto1.text = "Código Acción:"
                celda.texto2.text = self.obsPlan.CodAccion
            case 4:
                celda.texto1.text = "Estado:"
                celda.texto2.text = self.obsPlan.CodEstadoAccion
            default:
                break
            }
            return celda
        case 1:
            switch indexPath.row {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda2Texto
                celda.texto1.attributedText = Utils.addInitialRedAsterisk("Solicitado Por:", "HelveticaNeue-Bold", 13)
                celda.texto2.text = Utils.str2date2str(self.obsPlan.CodSolicitadoPor ?? "")
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada:", "HelveticaNeue-Bold", 13)
                celda.boton.setTitle(self.obsPlan.CodActiRelacionada, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Nivel Riesgo:", "HelveticaNeue-Bold", 13)
                celda.boton.setTitle(self.obsPlan.CodNivelRiesgo, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Área HSEC:", "HelveticaNeue-Bold", 13)
                celda.boton.setTitle(self.obsPlan.CodAreaHSEC, for: .normal)
                celda.boton.tag = indexPath.row
                return celda
            case 4:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Tipo Acción:", "HelveticaNeue-Bold", 13)
                celda.boton.setTitle(self.obsPlan.CodTipoAccion, for: .normal)
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
            celda.textView.text = self.tarea
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
            self.obsPlan.CodSolicitadoPor = persona.Nombres
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
    
}
