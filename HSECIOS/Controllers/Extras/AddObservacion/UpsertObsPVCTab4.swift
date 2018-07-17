import UIKit

class UpsertObsPVCTab4: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.UOTab4Planes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1")
        return celda
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda3Texto1Boton
        let unit = Globals.UOTab4Planes[indexPath.row]
        celda.texto1.text = unit.DesPlanAccion ?? ""
        celda.texto2.text = Utils.searchMaestroStatic("ESTADOPLAN", unit.CodEstadoAccion ?? "")
        celda.texto3.text = Utils.searchMaestroStatic("NIVELRIESGO", unit.CodNivelRiesgo ?? "")
        celda.boton.tag = indexPath.row
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = Globals.UOTab4Planes[indexPath.row]
        VCHelper.openUpsertObsPlan(self, 1, unit, MuroElement(), {(plan:PlanAccionDetalle) in
            Globals.UOTab4Planes[indexPath.row] = plan
            self.tableView.reloadData()
        })
    }
    
    @IBAction func clickAddPlan(_ sender: Any) {
        let plan = PlanAccionDetalle()
        plan.SolicitadoPor = Globals.UOTab1ObsGD.CodObservadoPor
        plan.CodSolicitadoPor = Globals.UOTab1ObsGD.ObservadoPor
        plan.CodNivelRiesgo = Globals.UOTab1ObsGD.CodNivelRiesgo
        plan.CodAreaHSEC = Globals.UOTab1ObsGD.CodAreaHSEC
        plan.CodEstadoAccion = "01"
        let element = MuroElement()
        element.Codigo = Globals.UOCodigo
        VCHelper.openUpsertObsPlan(self, 1, plan, element, {(planDetalle:PlanAccionDetalle) in
            Globals.UOTab4Planes.append(planDetalle)
            self.tableView.reloadData()
        })
    }
    
    @IBAction func clickBorrarPlan(_ sender: Any) {
        Globals.UOTab4Planes.remove(at: (sender as! UIButton).tag)
        self.tableView.reloadData()
    }
    
}

class UpsertObsPVCTab4Cell: UITableViewCell {
    @IBOutlet weak var tarea: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var riesgo: UILabel!
}
