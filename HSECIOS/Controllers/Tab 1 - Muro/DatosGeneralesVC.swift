import UIKit

class DatosGeneralesVC: UIViewController {
    
    // var labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación", "Sub Ubicación", "Ubicación Específica", "Lugar", "Tipo"]
    // var values = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    //var codigo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        var data = [[String]]()
        data.append(["Codigo", "-"])
        data.append(["Area", "-"])
        data.append(["Nivel de riesgo", "-"])
        data.append(["Observado Por", "-"])
        data.append(["Fecha", "-"])
        data.append(["Hora", "-"])
        data.append(["Gerencia", "-"])
        data.append(["Superintendencia", "-"])
        data.append(["Ubicación", "-"])
        data.append(["Sub Ubicación", "-"])
        data.append(["Ubicación Específica", "-"])
        data.append(["Lugar", "-"])
        data.append(["Tipo", "-"])
        hijo.data = data
        hijo.separatorHidden = true
        hijo.tableView.reloadData()
    }
    
    func loadDataFor (_ codigo: String) {
        Rest.getDataGeneral(Routes.forObservaciones(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let data: ObservacionGD = Dict.dataToUnit(data!)!
            
            var hijoData = [[String]]()
            hijoData.append(["Codigo", data.CodObservacion ?? ""])
            hijoData.append(["Area", Utils.searchMaestroDescripcion("AREA", data.CodAreaHSEC ?? "")])
            hijoData.append(["Nivel de riesgo", Utils.searchMaestroStatic("NIVELRIESGO", data.CodNivelRiesgo ?? "")])
            hijoData.append(["Observado Por", data.ObservadoPor ?? ""])
            hijoData.append(["Fecha", Utils.str2date2str(data.Fecha ?? "")])
            hijoData.append(["Hora", Utils.str2hour2str(data.Fecha ?? "")])
            hijoData.append(["Gerencia", Utils.searchMaestroDescripcion("GERE", data.Gerencia ?? "")])
            hijoData.append(["Superintendencia", Utils.searchMaestroDescripcion("SUPE.\(data.Gerencia ?? "")", data.Superint ?? "")])
            
            let splits = (data.CodUbicacion ?? "").split(separator: ".")
            hijoData.append(["Ubicación", Utils.searchMaestroDescripcion("UBIC", String(splits[0]))])
            
            
            /*self.labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación"]
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
            ]*/
            if splits.count > 1 {
                hijoData.append(["Sub Ubicación", Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1]))])
                // self.labels.append("Sub Ubicación")
                // self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0]))", String(splits[1])))
            }
            if splits.count > 2 {
                hijoData.append(["Ubicación Específica", Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2]))])
                // self.labels.append("Ubicación Específica")
                // self.values.append(Utils.searchMaestroDescripcion("UBIC.\(String(splits[0])).\(String(splits[1]))", String(splits[2])))
            }
            hijoData.append(["Lugar", data.Lugar ?? ""])
            hijoData.append(["Tipo", Utils.searchMaestroDescripcion("TPOB", data.CodTipo ?? "")])
            // self.labels.append(contentsOf: ["Lugar", "Tipo"])
            // self.values.append(contentsOf: [data.Lugar ?? "", Utils.searchMaestroDescripcion("TPOB", data.CodTipo ?? "")])
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.data = hijoData
            // hijo.dataLeft = self.labels
            // hijo.dataRight = self.values
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
