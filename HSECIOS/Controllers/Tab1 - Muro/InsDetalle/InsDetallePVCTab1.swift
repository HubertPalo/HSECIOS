import UIKit

class InsDetallePVCTab1: UIViewController {
    
    var dataLeft = ["Codigo", "Gerencia", "Superintendencia", "Contrata", "Fecha programada", "Fecha de inspección", "Hora", "Ubicación", "Sub Ubicación", "Tipo de Inspección"]
    var dataRight = ["-","-","-","-","-","-","-","-","-","-"]
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(0)
        }
        
        Helper.getData(Routes.forInspecciones(Utils.selectedObsCode), true, vcontroller: self, success: { (dict: NSDictionary) in
            let generalData = Dict.toInspeccionGD(dict)
            var ubicacion = generalData.CodUbicacion
            var sububicacion = generalData.CodSubUbicacion
            
            let splits = generalData.CodUbicacion.split(separator: ".")
            if splits.count == 1 {
                ubicacion = Globals.gUbicaciones[generalData.CodUbicacion] ?? "-"
                sububicacion = "-"
            } else if splits.count == 2 {
                
                ubicacion = Globals.gUbicaciones[String(splits[0])] ?? "-"
                sububicacion = Globals.gSubUbicaciones[String(splits[0])]?[String(splits[1])] ?? "-"
            }
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.dataLeft
            hijo.dataRight = [
            generalData.CodInspeccion,
            Globals.gGerencia[generalData.Gerencia] ?? "-",
            Globals.gSuperintendencia[generalData.Gerencia]?[generalData.SuperInt] ?? "-",
            generalData.CodContrata,
            Utils.str2date2str(generalData.FechaP),
            Utils.str2date2str(generalData.Fecha),
            Utils.str2hour2str(generalData.Fecha),
            ubicacion,
            sububicacion,
            Globals.insTipo[generalData.CodTipo] ?? "-"
            ]
            hijo.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        hijo.dataLeft = dataLeft
        hijo.dataRight = dataRight
        hijo.tableView.reloadData()
    }
    
}
