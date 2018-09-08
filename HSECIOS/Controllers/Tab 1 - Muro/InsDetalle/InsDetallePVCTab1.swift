import UIKit

class InsDetallePVCTab1: UIViewController {
    
    var inspeccion = MuroElement()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(0)
        }
        Rest.getDataGeneral(Routes.forInspecciones(inspeccion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            let generalData: InspeccionGD = Dict.dataToUnit(data!)!
            var ubicacion = generalData.CodUbicacion ?? ""
            var sububicacion = generalData.CodSubUbicacion ?? ""
            ubicacion = Utils.searchMaestroDescripcion("UBIC",ubicacion)
            let splits = (generalData.CodSubUbicacion ?? "").split(separator: ".")
            
            if splits.count == 2 {
                sububicacion = Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1]))
            }
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.data[0][1] = generalData.CodInspeccion ?? ""
            hijo.data[1][1] = Utils.searchMaestroDescripcion("GERE", generalData.Gerencia ?? "")
            hijo.data[2][1] = Utils.searchMaestroDescripcion("SUPE.\(generalData.Gerencia ?? "")", generalData.SuperInt ?? "")
            hijo.data[3][1] = Utils.searchMaestroDescripcion("PROV", generalData.CodContrata ?? "")
            hijo.data[4][1] = Utils.str2date2str(generalData.FechaP ?? "")
            hijo.data[5][1] = Utils.str2date2str(generalData.Fecha ?? "")
            hijo.data[6][1] = Utils.str2hour2str(generalData.Fecha ?? "")
            hijo.data[7][1] = ubicacion
            hijo.data[8][1] = sububicacion
            hijo.data[9][1] = Utils.searchMaestroDescripcion("TPIN", generalData.CodTipo ?? "")
            hijo.tableView.reloadData()
        }, error: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        hijo.data = [["Codigo", "-"], ["Gerencia", "-"], ["Superintendencia", "-"], ["Contrata", "-"], ["Fecha programada", "-"], ["Fecha de inspección", "-"], ["Hora", "-"], ["Ubicación", "-"], ["Sub Ubicación", "-"], ["Tipo de Inspección", "-"]]
        hijo.tableView.reloadData()
    }
    
}
