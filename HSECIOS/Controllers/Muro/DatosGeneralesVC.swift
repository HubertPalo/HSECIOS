import UIKit

class DatosGeneralesVC: UIViewController {
    
    var labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación", "Sub Ubicación", "Ubicación Específica", "Lugar", "Tipo"]
    var values = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    //var codigo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        hijo.dataLeft = labels
        hijo.dataRight = values
        hijo.tableView.reloadData()
    }
    
    func loadDataFor (_ codigo: String) {
        Helper.getData(Routes.forObservaciones(codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
            let data = Dict.toObsGeneralData(dict)
            let splits = data.CodUbicacion.split(separator: ".")
            self.labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación"]
            self.values = [
                data.CodObservacion,
                Globals.obsArea[data.CodAreaHSEC]!,
                Globals.obsRiesgo[data.CodNivelRiesgo]!,
                data.ObservadoPor,
                Utils.str2date2str(data.Fecha),
                Utils.str2hour2str(data.Fecha),
                Globals.gGerencia[data.Gerencia] ?? "-",
                Globals.gSuperintendencia[data.Gerencia]?[data.Superint] ?? "-",
                Globals.decode(data.CodUbicacion, "UB")
            ]
            if splits.count > 1 {
                self.labels.append("Sub Ubicación")
                self.values.append(Globals.decode(data.CodUbicacion, "SU"))
            }
            if splits.count > 2 {
                self.labels.append("Ubicación Específica")
                self.values.append(Globals.decode(data.CodUbicacion, "UE"))
            }
            self.labels.append(contentsOf: ["Lugar", "Tipo"])
            self.values.append(contentsOf: [data.Lugar, Globals.obsTipo[data.CodTipo]!])
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.labels
            hijo.dataRight = self.values
            hijo.tableView.reloadData()
        })
    }
}
