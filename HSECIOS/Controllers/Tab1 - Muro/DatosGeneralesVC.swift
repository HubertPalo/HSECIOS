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
        Rest.getDataGeneral(Routes.forObservaciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let data: ObservacionGD = Dict.dataToUnit(data!)!
            // let data = Dict.toObsGeneralData(dict)
            let splits = (data.CodUbicacion ?? "").split(separator: ".")
            self.labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación"]
            self.values = [
                data.CodObservacion ?? "",
                Utils.searchMaestroDescripcion("AREA", data.CodAreaHSEC ?? ""),
                Utils.searchMaestroStatic("NIVELRIESGO", data.CodNivelRiesgo ?? ""),
                data.ObservadoPor ?? "",
                Utils.str2date2str(data.Fecha ?? ""),
                Utils.str2hour2str(data.Fecha ?? ""),
                Utils.searchMaestroDescripcion("GERE", data.Gerencia ?? ""),
                Utils.searchMaestroDescripcion("SUPE.\(data.Gerencia ?? "")", data.Superint ?? ""),
                Utils.searchMaestroDescripcion("UBIC", String(splits[0]))
            ]
            if splits.count > 1 {
                self.labels.append("Sub Ubicación")
                self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1])))
            }
            if splits.count > 2 {
                self.labels.append("Ubicación Específica")
                self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2])))
            }
            self.labels.append(contentsOf: ["Lugar", "Tipo"])
            self.values.append(contentsOf: [data.Lugar ?? "", Utils.searchMaestroDescripcion("TPOB", data.CodTipo ?? "")])
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.labels
            hijo.dataRight = self.values
            hijo.tableView.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forObservaciones(codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
            let data = Dict.toObsGeneralData(dict)
            let splits = (data.CodUbicacion ?? "").split(separator: ".")
            self.labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación"]
            self.values = [
                data.CodObservacion ?? "",
                Utils.searchMaestroDescripcion("AREA", data.CodAreaHSEC ?? ""),
                Utils.searchMaestroStatic("NIVELRIESGO", data.CodNivelRiesgo ?? ""),
                data.ObservadoPor ?? "",
                Utils.str2date2str(data.Fecha ?? ""),
                Utils.str2hour2str(data.Fecha ?? ""),
                Utils.searchMaestroDescripcion("GERE", data.Gerencia ?? ""),
                Utils.searchMaestroDescripcion("SUPE.\(data.Gerencia ?? "")", data.Superint ?? ""),
                Utils.searchMaestroDescripcion("UBIC", String(splits[0]))
            ]
            if splits.count > 1 {
                self.labels.append("Sub Ubicación")
                self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1])))
            }
            if splits.count > 2 {
                self.labels.append("Ubicación Específica")
                self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2])))
            }
            self.labels.append(contentsOf: ["Lugar", "Tipo"])
            self.values.append(contentsOf: [data.Lugar ?? "", Utils.searchMaestroDescripcion("TPOB", data.CodTipo ?? "")])
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.labels
            hijo.dataRight = self.values
            hijo.tableView.reloadData()
        })*/
    }
}
