import UIKit

class UpsertObsPVCTab4: UITableViewController {
    
    var planes: [String] = []
    var codigo = ""
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(3)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1")
        return celda
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda\(indexPath.row)") as! Celda1Texto
        celda.texto.text = "Titulo \(indexPath)"
        return celda
    }
    
    @IBAction func clickAddPlan(_ sender: Any) {
        let plan = PlanAccionDetalle()
        plan.SolicitadoPor = (Tabs.forAddObs[0] as! UpsertObsPVCTab1).obsGD.CodObservadoPor
        plan.CodSolicitadoPor = (Tabs.forAddObs[0] as! UpsertObsPVCTab1).obsGD.ObservadoPor
        let element = MuroElement()
        element.Codigo = self.codigo
        VCHelper.openUpsertObsPlan(self, "ADD", plan, element)
    }
    
}

