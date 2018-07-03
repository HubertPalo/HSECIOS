import UIKit

class InsDetallePVCTab3: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    var observaciones: [InsObservacion] = []
    var inspeccion = MuroElement()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(2)
        }
        Rest.getDataGeneral(Routes.forInsObservaciones(inspeccion.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
            let arrayObservaciones: ArrayGeneral<InsObservacion> = Dict.dataToArray(data!)
            self.observaciones = arrayObservaciones.Data
            self.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forInsObservaciones(inspeccion.Codigo), true, vcontroller: self, success: {(dict:NSDictionary) in
            self.observaciones = Dict.toArrayInsObservacion(dict)
            self.tabla.reloadData()
        })*/
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    
    // tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observaciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! InsDetallePVCTab3TVCell
        let unit = observaciones[indexPath.row]
        celda.observacion.text = unit.Observacion
        celda.riesgo.image = Images.getImageForRisk(unit.CodNivelRiesgo)
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = observaciones[indexPath.row]
        VCHelper.openInsObsDetalle(self, unit)
        /*Utils.selectedInsObsCode = unit.Correlativo
        let padre = self.parent?.parent as! InsDetalleVC
        padre.codigoInsObservacion = unit.CodInspeccion
        padre.correlativoInsObservacion = unit.Correlativo
        padre.performSegue(withIdentifier: "toObs", sender: self)
        print("is InsDetalleVC : \(self.parent is InsDetalleVC)")
        print("is InsDetalleVC : \(self.parent?.parent is InsDetalleVC)")
        print("is InsDetalleVC : \(self.parent?.parent?.parent is InsDetalleVC)")*/
    }
    // tableview
    
}

class InsDetallePVCTab3TVCell: UITableViewCell {
    @IBOutlet weak var observacion: UILabel!
    @IBOutlet weak var riesgo: UIImageView!
}
