import UIKit

class ObsDetallePVCTab1: UIViewController {
    
    var hijo = InfoDetalleTVC()
    
    override func viewWillAppear(_ animated: Bool) {
        self.hijo.dataLeft = Globals.GODataLeft
        self.hijo.dataRight = Globals.GODataRight
        self.hijo.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (VCHelper.obsDetalle as! ObsDetalleVC).selectTab(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hijo = self.childViewControllers[0] as! InfoDetalleTVC
        self.hijo.dataLeft = Globals.GODataLeft
        self.hijo.dataRight = Globals.GODataRight
        self.hijo.tableView.reloadData()
    }
    
    func reloadData() {
        self.hijo.dataLeft = Globals.GODataLeft
        self.hijo.dataRight = Globals.GODataRight
        self.hijo.tableView.reloadData()
    }
    
    func loadObservacion(_ observacion: MuroElement) {
        if self.childViewControllers.count > 0 {
            if let hijo = self.childViewControllers[0] as? InfoDetalleTVC {
                hijo.dataLeft = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia"]
                hijo.dataRight = ["-", "-", "-", "-", "-", "-", "-", "-"]
                hijo.tableView.reloadData()
            }
        }
        Rest.getDataGeneral(Routes.forObservaciones(observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            let data: ObservacionGD = Dict.dataToUnit(data!)!
            let splits = (data.CodUbicacion ?? "").split(separator: ".")
            var labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia"]
            var values = [
                data.CodObservacion ?? "",
                Utils.searchMaestroDescripcion("AREA", data.CodAreaHSEC ?? ""),
                Utils.searchMaestroStatic("NIVELRIESGO", data.CodNivelRiesgo ?? ""),
                data.ObservadoPor ?? "",
                Utils.str2date2str(data.Fecha ?? ""),
                Utils.str2hour2str(data.Fecha ?? ""),
                Utils.searchMaestroDescripcion("GERE", data.Gerencia ?? ""),
                Utils.searchMaestroDescripcion("SUPE.\(data.Gerencia ?? "")", data.Superint ?? "")
            ]
            if splits.count > 0 {
                labels.append("Ubicación")
                values.append(Utils.searchMaestroDescripcion("UBIC", String(splits[0])))
            }
            
            if splits.count > 1 {
                labels.append("Sub Ubicación")
                values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1])))
            }
            if splits.count > 2 {
                labels.append("Ubicación Específica")
                values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2])))
            }
            labels.append(contentsOf: ["Lugar", "Tipo"])
            values.append(contentsOf: [data.Lugar ?? "", Utils.searchMaestroDescripcion("TPOB", data.CodTipo ?? "")])
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = labels
            hijo.dataRight = values
            hijo.tableView.reloadData()
        }, error: nil)
    }
}
