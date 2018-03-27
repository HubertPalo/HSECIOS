import UIKit

class ObsDetallePVCTab1: UIViewController {
    
    var labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación", "Sub Ubicación", "Ubicación Específica", "Lugar", "Tipo"]
    var values = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(0)
        }
        let hijo = self.childViewControllers[0] as! DatosGeneralesVC
        hijo.loadDataFor(Utils.selectedObsCode)
        /*
        print(Utils.selectedObsCode)
        //HMuro.getObservacionesGeneralData(Utils.selectedObsCode, vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))
        Helper.getData(Routes.forObservaciones(Utils.selectedObsCode), true, vcontroller: self, success: {(dict: NSDictionary) in
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
                //Globals.decode(data.Gerencia, "G"),
                //Utils.cleanCode(Globals.gGerencia[data.Gerencia] ?? "-"),
                //Globals.decode("\(data.Gerencia).\(data.Superint)", "S")
                Globals.gSuperintendencia[data.Gerencia]?[data.Superint] ?? "-",
                //Utils.cleanCode(Globals.gUbicaciones[String(splits[0])] ?? "-")
                Globals.decode(data.CodUbicacion, "UB")
            ]
            if splits.count > 1 {
                self.labels.append("Sub Ubicación")
                //values.append(Utils.cleanCode(Globals.gSubUbicaciones[String(splits[0])]![String(splits[1])] ?? "-"))
                self.values.append(Globals.decode(data.CodUbicacion, "SU"))
            }
            if splits.count > 2 {
                self.labels.append("Ubicación Específica")
                self.values.append(Globals.decode(data.CodUbicacion, "UE"))
                //values.append(Utils.cleanCode(Globals.gUbicacionesEsp[String(splits[0])]![String(splits[1])]![String(splits[2])] ?? "-"))
            }
            self.labels.append(contentsOf: ["Lugar", "Tipo"])
            self.values.append(contentsOf: [data.Lugar, Globals.obsTipo[data.CodTipo]!])
            
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = self.labels
            hijo.dataRight = self.values
            hijo.tableView.reloadData()
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let hijo = self.childViewControllers[0] as! InfoDetalleTVC
        hijo.dataLeft = labels
        hijo.dataRight = values
        hijo.tableView.reloadData()
 */
    }
    /*
    func successGettingData(_ data: ObservacionGD) {
        let splits = data.CodUbicacion.split(separator: ".")
        labels = ["Codigo", "Area", "Nivel de riesgo", "Observado Por", "Fecha", "Hora", "Gerencia", "Superintendencia", "Ubicación"]
        values = [
            data.CodObservacion,
            Globals.obsArea[data.CodAreaHSEC]!,
            Globals.obsRiesgo[data.CodNivelRiesgo]!,
            data.ObservadoPor,
            Utils.str2date2str(data.Fecha),
            Utils.str2hour2str(data.Fecha),
            Globals.decode(data.Gerencia, "G"),
            //Utils.cleanCode(Globals.gGerencia[data.Gerencia] ?? "-"),
            Globals.decode("\(data.Gerencia).\(data.Superint)", "S"),
            //Utils.cleanCode(Globals.gUbicaciones[String(splits[0])] ?? "-")
            Globals.decode(data.CodUbicacion, "UB")
        ]
        if splits.count > 1 {
            labels.append("Sub Ubicación")
            //values.append(Utils.cleanCode(Globals.gSubUbicaciones[String(splits[0])]![String(splits[1])] ?? "-"))
            values.append(Globals.decode(data.CodUbicacion, "SU"))
        }
        if splits.count > 2 {
            labels.append("Ubicación Específica")
            values.append(Globals.decode(data.CodUbicacion, "UE"))
            //values.append(Utils.cleanCode(Globals.gUbicacionesEsp[String(splits[0])]![String(splits[1])]![String(splits[2])] ?? "-"))
        }
        labels.append(contentsOf: ["Lugar", "Tipo"])
        values.append(contentsOf: [data.Lugar, Globals.obsTipo[data.CodTipo]!])
        
    }
    
    func errorGettingData(_ error: String) {
        print(error)
    }
    */
}
