import UIKit

class ObsDetallePVCTab4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var planes: [ObsPlanAccion] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(3)
        }
        Helper.getData(Routes.forObsPlanAccion(Utils.selectedObsCode), true, vcontroller: self, success: {(dict: NSDictionary) in
            self.planes = Dict.toArrayObsPlanAccion(dict)
            // Utils.planAccion = self.planes
            //self.planes = planes
            self.tabla.reloadData()
        })
        //HMuro.getObservacionesPlanAccion(Utils.selectedObsCode, vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))
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
        celda.responsable.text = unit.CodResponsable
        celda.area.text = Globals.obsArea[unit.CodAreaHSEC]
        celda.estado.text = Globals.obsEstado[unit.CodEstadoAccion]
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popup = Tabs.sb.instantiateViewController(withIdentifier: "tabMuroDetalle4PopUp") as! ObsDetallePVCTab4PopUp
        popup.modalPresentationStyle = .overCurrentContext
        popup.planAccion = planes[indexPath.row]
        self.present(popup, animated: true, completion: nil)
    }
    //Tabla
    
    func successGettingData(_ planAccion: [ObsPlanAccion]) {
        Utils.planAccion = planAccion
        planes = planAccion
        tabla.reloadData()
    }
    
    func errorGettingData(_ error: String) {
        print(error)
    }
}

class MuroDetallePVCTab3TVCell: UITableViewCell {
    
    @IBOutlet weak var tarea: UILabel!
    
    @IBOutlet weak var responsable: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
}
