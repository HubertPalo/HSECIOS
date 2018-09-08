import UIKit

class ObsDetallePVCTab1: UIViewController {
    
    var hijo = InfoDetalleTVC()
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        (VCHelper.obsDetalle as! ObsDetalleVC).selectTab(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hijo = self.childViewControllers[0] as! InfoDetalleTVC
        self.hijo.tableView.reloadData()
    }
    
    func reloadData() {
        let splits = (Globals.UOTab1ObsGD.CodUbicacion ?? "").split(separator: ".")
        self.hijo.data = [["Codigo", Globals.UOTab1ObsGD.CodObservacion ?? ""], ["Area", Utils.searchMaestroDescripcion("AREA", Globals.UOTab1ObsGD.CodAreaHSEC ?? "")], ["Nivel de riesgo", Utils.searchMaestroStatic("NIVELRIESGO", Globals.UOTab1ObsGD.CodNivelRiesgo ?? "")], ["Observado Por", Globals.UOTab1ObsGD.ObservadoPor ?? ""], ["Fecha", Utils.str2date2str(Globals.UOTab1ObsGD.Fecha ?? "")], ["Hora", Utils.str2hour2str(Globals.UOTab1ObsGD.Fecha ?? "")], ["Gerencia", Utils.searchMaestroDescripcion("GERE", Globals.UOTab1ObsGD.Gerencia ?? "")], ["Superintendencia", Utils.searchMaestroDescripcion("SUPE.\(Globals.UOTab1ObsGD.Gerencia ?? "")", Globals.UOTab1ObsGD.Superint ?? "")]]
        
        if splits.count > 0 {
            self.hijo.data.append(["Ubicación", Utils.searchMaestroDescripcion("UBIC", String(splits[0]))])
        }
        
        if splits.count > 1 {
            self.hijo.data.append(["Sub Ubicación", Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1]))])
        }
        if splits.count > 2 {
            self.hijo.data.append(["Ubicación Específica", Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2]))])
        }
        self.hijo.data.append(["Lugar", Globals.UOTab1ObsGD.Lugar ?? ""])
        self.hijo.data.append(["Tipo", Utils.searchMaestroDescripcion("TPOB", Globals.UOTab1ObsGD.CodTipo ?? "")])
        self.hijo.tableView.reloadData()
    }
}
