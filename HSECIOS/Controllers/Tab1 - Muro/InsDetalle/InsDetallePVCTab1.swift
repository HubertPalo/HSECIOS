import UIKit

class InsDetallePVCTab1: UIViewController {
    
    var inspeccion = MuroElement()
    
    var dataLeft = ["Codigo", "Gerencia", "Superintendencia", "Contrata", "Fecha programada", "Fecha de inspección", "Hora", "Ubicación", "Sub Ubicación", "Tipo de Inspección"]
    var dataRight = ["-","-","-","-","-","-","-","-","-","-"]
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(0)
        }
        Rest.getDataGeneral(Routes.forInspecciones(inspeccion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            let generalData: InspeccionGD = Dict.dataToUnit(data!)!
            var ubicacion = generalData.CodUbicacion
            var sububicacion = generalData.CodSubUbicacion
            ubicacion = Utils.searchMaestroDescripcion("UBIC",ubicacion)
            let splits = generalData.CodSubUbicacion.split(separator: ".")
            // if splits.count == 1 {
            //ubicacion = Utils.searchMaestroDescripcion("UBIC", String(splits[0]))/* Globals.gUbicaciones[generalData.CodUbicacion] ?? "-"*/
            //   sububicacion = "-"
            //} else
            if splits.count == 2 {
                // ubicacion = Utils.searchMaestroDescripcion("UBIC", String(splits[0])) //Globals.gUbicaciones[String(splits[0])] ?? "-"
                sububicacion = Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1]))
            }
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.dataLeft
            hijo.dataRight = [
                generalData.CodInspeccion,
                Utils.searchMaestroDescripcion("GERE", generalData.Gerencia),
                Utils.searchMaestroDescripcion("SUPE.\(generalData.Gerencia)", generalData.SuperInt),
                generalData.CodContrata,
                Utils.str2date2str(generalData.FechaP),
                Utils.str2date2str(generalData.Fecha),
                Utils.str2hour2str(generalData.Fecha),
                ubicacion,
                sububicacion,
                Utils.searchMaestroDescripcion("TPIN", generalData.CodTipo)
            ]
            hijo.tableView.reloadData()
        }, error: nil)
        
        /*Rest.getData(Routes.forInspecciones(inspeccion.Codigo), false, vcontroller: self, success: { (dict: NSDictionary) in
            let generalData = Dict.toInspeccionGD(dict)
            var ubicacion = generalData.CodUbicacion
            var sububicacion = generalData.CodSubUbicacion
            ubicacion = Utils.searchMaestroDescripcion("UBIC",ubicacion)
            let splits = generalData.CodSubUbicacion.split(separator: ".")
            // if splits.count == 1 {
            //ubicacion = Utils.searchMaestroDescripcion("UBIC", String(splits[0]))/* Globals.gUbicaciones[generalData.CodUbicacion] ?? "-"*/
            //   sububicacion = "-"
            //} else
            if splits.count == 2 {
                // ubicacion = Utils.searchMaestroDescripcion("UBIC", String(splits[0])) //Globals.gUbicaciones[String(splits[0])] ?? "-"
                sububicacion = Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1]))
            }
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.dataLeft
            hijo.dataRight = [
                generalData.CodInspeccion,
                Utils.searchMaestroDescripcion("GERE", generalData.Gerencia),
                Utils.searchMaestroDescripcion("SUPE.\(generalData.Gerencia)", generalData.SuperInt),
                generalData.CodContrata,
                Utils.str2date2str(generalData.FechaP),
                Utils.str2date2str(generalData.Fecha),
                Utils.str2hour2str(generalData.Fecha),
                ubicacion,
                sububicacion,
                Utils.searchMaestroDescripcion("TPIN", generalData.CodTipo)
            ]
            hijo.tableView.reloadData()
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        hijo.dataLeft = dataLeft
        hijo.dataRight = dataRight
        hijo.tableView.reloadData()
    }
    
}
