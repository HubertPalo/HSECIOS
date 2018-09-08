import UIKit

class ObsPlanAccionDetalleTVC: UITableViewController {
    
    var responsables: [Persona] = []
    var plan = PlanAccionDetalle()
    
    var leftLabels: [String] = ["Código de acción", "Nro. doc. de referencia", "Área", "Nivel de riesgo", "Descripción", "Fecha de solicitud", "Estado", "Solicitado por", "Responsable", "Actividad relacionada", "Referencia", "Tipo de acción", "Fecha inicial", "Fecha final"]
    var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.bounces = false
        rightLabels[0] = plan.CodAccion ?? ""
        rightLabels[1] = plan.NroDocReferencia ?? ""
        rightLabels[2] = plan.CodAreaHSEC ?? ""
        rightLabels[3] = plan.CodNivelRiesgo ?? ""
        rightLabels[4] = plan.DesPlanAccion ?? ""
        rightLabels[5] = plan.FechaSolicitud ?? ""
        rightLabels[6] = plan.CodEstadoAccion ?? ""
        rightLabels[7] = plan.CodSolicitadoPor ?? ""
        rightLabels[8] = plan.Responsables ?? ""
        rightLabels[9] = plan.CodActiRelacionada ?? ""
        rightLabels[10] = plan.CodReferencia ?? ""
        rightLabels[11] = plan.CodTipoAccion ?? ""
        rightLabels[12] = plan.CodReferencia ?? ""
        rightLabels[13] = plan.CodReferencia ?? ""
        rightLabels[14] = plan.FecComprometidaInicial ?? ""
        rightLabels[15] = plan.FecComprometidaFinal ?? ""
            
        // rightLabels = [, , , , , , , , , , , , , ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto
        switch section {
        case 0:
            return nil //header.texto.attributedText = Utils.generateAttributedString(["Plan de acción"], ["HelveticaNeue-Bold"], [16], [UIColor.white])
        case 1:
            header.texto.attributedText = Utils.generateAttributedString(["Responsables"], ["HelveticaNeue-Bold"], [14], [UIColor.white])
        default:
            break
        }
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? leftLabels.count : self.responsables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "celda\(indexPath.section + 2)"
        let celda = tableView.dequeueReusableCell(withIdentifier: id) as! Celda2Texto
        celda.texto1.text = indexPath.section == 0 ? leftLabels[indexPath.row] : responsables[indexPath.row].Nombres
        celda.texto2.text = indexPath.section == 1 ? rightLabels[indexPath.row] : responsables[indexPath.row].Cargo
        return celda
    }
}
