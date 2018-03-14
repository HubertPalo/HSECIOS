import UIKit

class ObsDetallePVCTab4PopUp: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    let labels = ["Código de acción", "Nro doc. de referencia", "Área", "Nivel de riesgo", "Descripción", "Fecha de Solicitud", "Estado", "Solicitado por", "Responsable", "Acción relacionada", "Referencia", "Tipo de acción", "Fecha inicial", "Fecha final"]
    var values = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    var planAccion: ObsPlanAccion = ObsPlanAccion()
    
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
        //let planAccion = Utils.planAccion[Utils.selectedObsPlanAccion]
        values = [
            planAccion.CodAccion,
            planAccion.NroDocReferencia,
            Globals.obsArea[planAccion.CodAreaHSEC] ?? "",
            Globals.obsRiesgo[planAccion.CodNivelRiesgo] ?? "",
            planAccion.DesPlanAccion,
            Utils.str2date2str(planAccion.FechaSolicitud),
            Globals.obsEstado[planAccion.CodEstadoAccion] ?? "",
            planAccion.CodSolicitadoPor,
            planAccion.CodResponsable,
            planAccion.CodActiRelacionada,
            planAccion.CodReferencia,
            planAccion.CodTipoAccion,
            Utils.str2date2str(planAccion.FecComprometidaInicial),
            Utils.str2date2str(planAccion.FecComprometidaFinal)
        ]
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
