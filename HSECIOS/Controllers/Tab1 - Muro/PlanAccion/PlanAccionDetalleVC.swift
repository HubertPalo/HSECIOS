import UIKit

class PlanAccionDetalleVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var plan: ObsPlanAccion = ObsPlanAccion()
    var leftLabels: [String] = ["Código de acción", "Nro. doc. de referencia", "Área", "Nivel de riesgo", "Descripción", "Fecha de solicitud", "Estado", "Solicitado por", "Responsable", "Actividad relacionada", "Referencia", "Tipo de acción", "Fecha inicial", "Fecha final"]
    var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        rightLabels = [plan.CodAccion, plan.NroDocReferencia, plan.CodAreaHSEC, plan.CodNivelRiesgo, plan.DesPlanAccion, plan.FechaSolicitud, plan.CodEstadoAccion, plan.CodSolicitadoPor, plan.Responsables, plan.CodActiRelacionada, plan.CodReferencia, plan.CodTipoAccion, plan.FecComprometidaInicial, plan.FecComprometidaFinal]
    }
    
    func loadPlan(plan: ObsPlanAccion){
        
        self.tabla.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PlanAccionDetalleTVCell
        celda.dataLeft.text = leftLabels[indexPath.row]
        celda.dataRight.text = rightLabels[indexPath.row]
        return celda
    }
}

class PlanAccionDetalleTVCell: UITableViewCell {
    @IBOutlet weak var dataLeft: UILabel!
    @IBOutlet weak var dataRight: UILabel!
}
