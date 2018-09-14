import UIKit

class UpsertObsPVCTab4: UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(3)
        }
        self.tableView.reloadData()
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
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let unit = Globals.UOTab4Planes[indexPath.row]
        if let codAccion = Int(unit.CodAccion ?? "") {
            /*let muroUnit = MuroElement()
            muroUnit.Codigo = Globals.UOCodigo*/
            var copia = unit.copy()
            copia.NroDocReferencia = Globals.UOCodigo
            copia.FechaSolicitud = Utils.date2str(Date(), "YYYY-MM-dd")
            copia.SolicitadoPor = Utils.userData.Nombres
            copia.CodSolicitadoPor = Utils.userData.CodPersona
            VCHelper.openUpsertPlanAccion(self, "PUT", copia, nil, {(newplan) in
                Globals.UOTab4Planes[indexPath.row] = newplan
                self.tableView.reloadData()
            })
            /*VCHelper.openUpsertObsPlan(self, 2, unit, muroUnit, {(plan:PlanAccionDetalle) in
                let planToPost = plan.copy()
                planToPost.Responsables = nil
                planToPost.SolicitadoPor = nil
                planToPost.CodTipoObs = nil
                // planToPost
                let data = Dict.unitToData(planToPost)
                let params: [String:String] = Dict.dataToUnit(data!)!
                Rest.postDataGeneral("\(Config.urlBase)/PlanAccion/Post", params, true, success: {(resultValue:Any?,data:Data?) in
                    let respuesta = resultValue as! String
                    if respuesta == "-1" {
                        self.presentAlert("Error", "Ocurrió un error al intentar realizar la operación", .alert, 2, nil, [], [], actionHandlers: [])
                    } else {
                        Globals.UOTab4Planes[indexPath.row] = plan
                        self.tableView.reloadData()
                    }
                }, error: {(error) in
                    self.presentAlert("Error", "Ocurrió un error al intentar realizar la operación", .alert, 2, nil, [], [], actionHandlers: [])
                })
            })*/
        } else {
            VCHelper.openUpsertPlanAccion(self, "PUT", unit, {(newplan) in
                Globals.UOTab4Planes[indexPath.row] = newplan
            }, { (newplan) in
                self.tableView.reloadData()
            })
            /*VCHelper.openUpsertObsPlan(self, 1, unit, MuroElement(), {(plan:PlanAccionDetalle) in
                Globals.UOTab4Planes[indexPath.row] = plan
                self.tableView.reloadData()
            })*/
        }
        
    }
    
    @IBAction func clickAddPlan(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let plan = PlanAccionDetalle()
        plan.SolicitadoPor = Globals.UOTab1ObsGD.ObservadoPor
        plan.CodSolicitadoPor = Globals.UOTab1ObsGD.CodObservadoPor
        plan.CodNivelRiesgo = Globals.UOTab1ObsGD.CodNivelRiesgo
        plan.CodAreaHSEC = Globals.UOTab1ObsGD.CodAreaHSEC
        plan.CodEstadoAccion = "01"
        plan.CodTabla = "TOBS"
        plan.CodReferencia = "01"
        plan.NroDocReferencia = Globals.UOCodigo
        plan.FechaSolicitud = Utils.date2str(Date(), "YYYY-MM-dd")
        plan.CodAccion = "-1"
        if Globals.UOCodigo == "" {
            VCHelper.openUpsertPlanAccion(self, "ADD", plan, {(newplan) in
                Globals.UOTab4Planes.append(newplan)
            }, { (newplan) in
                self.tableView.reloadData()
            })
        } else {
            VCHelper.openUpsertPlanAccion(self, "ADD", plan, nil, { (newplan) in
                self.tableView.reloadData()
            })
        }
        
        //let element = MuroElement()
        //element.Codigo = Globals.UOCodigo
        
        /*VCHelper.openUpsertObsPlan(self, "ADD", {
            self.tableView.reloadData()
        })*/
        /*VCHelper.openUpsertObsPlan(self, 1, plan, element, {(planDetalle:PlanAccionDetalle) in
            if Globals.UOCodigo == "" {
                Globals.UOTab4Planes.append(planDetalle)
                self.tableView.reloadData()
            } else {
                planDetalle.NroDocReferencia = Globals.UOCodigo
                var showplan = planDetalle.copy()
                showplan.CodAccion = "-1"
                showplan.Responsables = nil
                
                showplan.CodTipoObs = showplan.CodTipoObs ?? ""
                showplan.SolicitadoPor = nil
                print(planDetalle.Responsables)
                print(planDetalle.SolicitadoPor)
                let params: [String:String] = Dict.dataToUnit(Dict.unitToData(showplan)!)!
                Rest.postDataGeneral(Routes.forPostPlanAccion(), params, true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    if (resultValue as! String) == "-1" {
                        self.presentAlert("Error", "Ocurrió un error al insertar el Plan de Acción", .alert, 2, nil, [], [], actionHandlers: [])
                    } else {
                        planDetalle.CodAccion = resultValue as! String
                        Globals.UOTab4Planes.append(planDetalle)
                        self.tableView.reloadData()
                    }
                }, error: nil)
            }
        })*/
    }
    
    @IBAction func clickBorrarPlan(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let boton = sender as! UIButton
        let unit = Globals.UOTab4Planes[boton.tag]
        print(unit.CodAccion)
        if unit.CodAccion != nil && unit.CodAccion != "" {
            Globals.UOTab4CodAccionABorrar.insert(unit.CodAccion!)
        }
        Globals.UOTab4Planes.remove(at: boton.tag)
        self.tableView.reloadData()
    }
    
}

class UpsertObsPVCTab4Cell: UITableViewCell {
    @IBOutlet weak var tarea: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var riesgo: UILabel!
}
