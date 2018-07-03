import UIKit

class ObsDetallePVCTab4PopUp: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    let labels = ["Código de acción", "Nro doc. de referencia", "Área", "Nivel de riesgo", "Descripción", "Fecha de Solicitud", "Estado", "Solicitado por", "Responsable", "Acción relacionada", "Referencia", "Tipo de acción", "Fecha inicial", "Fecha final"]
    var values = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    var planAccion = PlanAccionDetalle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        updateValues()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MuroDetallePVCTab3PopUpCell
        let indice = indexPath.row
        celda.label.text = labels[indice]
        celda.value.text = values[indice]
        return celda
    }
    
    func updateValues() {
        values[0] = planAccion.CodAccion ?? ""
        values[1] = planAccion.NroDocReferencia ?? ""
        values[2] = Utils.searchMaestroDescripcion("AREA", planAccion.CodAreaHSEC ?? "")
        values[3] = Utils.searchMaestroStatic("NIVELRIESGO", planAccion.CodNivelRiesgo ?? "")
        values[4] = planAccion.DesPlanAccion ?? ""
        values[5] = Utils.str2date2str(planAccion.FechaSolicitud ?? "")
        values[6] = planAccion.CodEstadoAccion ?? ""
        values[7] = planAccion.CodSolicitadoPor ?? ""
        values[8] = planAccion.CodResponsables ?? ""
        values[9] = planAccion.CodActiRelacionada ?? ""
        values[10] = planAccion.CodReferencia ?? ""
        values[11] = planAccion.CodTipoAccion ?? ""
        values[12] = Utils.str2date2str(planAccion.FecComprometidaInicial ?? "")
        values[13] = Utils.str2date2str(planAccion.FecComprometidaFinal ?? "")
        
    }
    
    @IBAction func cerrarPopUp(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

class MuroDetallePVCTab3PopUpCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var value: UILabel!
    
}
