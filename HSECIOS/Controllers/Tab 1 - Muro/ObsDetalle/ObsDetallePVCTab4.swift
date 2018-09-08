import UIKit

class ObsDetallePVCTab4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(3)
        }
        self.tabla.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.UOTab4Planes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! Celda4Texto1View
        let unit = Globals.UOTab4Planes[indexPath.row]
        celda.texto1.text = unit.DesPlanAccion
        celda.texto2.text = (unit.Responsables ?? "").components(separatedBy: ";").joined(separator: "\n")
        celda.texto3.text = Utils.searchMaestroDescripcion("AREA", unit.CodAreaHSEC ?? "")
        celda.texto4.text = Utils.searchMaestroDescripcion("ESOB", unit.CodEstadoAccion ?? "")
        celda.view.isHidden = indexPath.row == Globals.UOTab4Planes.count - 1
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        VCHelper.openPlanAccionDetalle(self, Globals.UOTab4Planes[indexPath.row])
    }
}
