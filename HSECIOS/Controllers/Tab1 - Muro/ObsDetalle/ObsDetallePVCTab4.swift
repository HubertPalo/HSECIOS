import UIKit

class ObsDetallePVCTab4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var planes: [PlanAccionDetalle] = []
    
    var observacion = MuroElement()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(3)
        }
        Rest.getDataGeneral(Routes.forObsPlanAccion(self.observacion.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
            let arrayPlanes: ArrayGeneral<PlanAccionDetalle> = Dict.dataToArray(data!)
            // self.planes = Dict.toArrayObsPlanAccion(dict)
            self.planes = arrayPlanes.Data
            self.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forObsPlanAccion(self.observacion.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
            self.planes = Dict.toArrayObsPlanAccion(dict)
            self.tabla.reloadData()
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    //Tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MuroDetallePVCTab3TVCell
        
        let unit = planes[indexPath.row]
        celda.tarea.text = unit.DesPlanAccion
        celda.responsable.text = unit.CodResponsables
        celda.area.text = Utils.searchMaestroDescripcion("AREA", unit.CodAreaHSEC ?? "")//Globals.obsArea[unit.CodAreaHSEC]
        celda.estado.text = Utils.searchMaestroDescripcion("ESOB", unit.CodEstadoAccion ?? "")//Globals.obsEstado[unit.CodEstadoAccion]
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popup = Utils.obsDetalleSB.instantiateViewController(withIdentifier: "tabMuroDetalle4PopUp") as! ObsDetallePVCTab4PopUp
        popup.modalPresentationStyle = .overCurrentContext
        popup.planAccion = planes[indexPath.row]
        self.present(popup, animated: true, completion: nil)
    }
    //Tabla
}

class MuroDetallePVCTab3TVCell: UITableViewCell {
    
    @IBOutlet weak var tarea: UILabel!
    
    @IBOutlet weak var responsable: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
}
