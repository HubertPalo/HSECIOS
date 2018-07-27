import UIKit

class InsObservacionPVCTab1: UIViewController {
    
    var insObservacion = InsObservacion()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(0)
        }
        Rest.getDataGeneral(Routes.forInsObservacionGD("\(insObservacion.Correlativo ?? 0)"), false, success: {(resultValue:Any?,data:Data?) in
            let data: InsObservacionGD = Dict.dataToUnit(data!)!
            let hijo = self.childViewControllers[0] as! InfoDetalleTVC
            hijo.dataLeft = [
                "Codigo",
                "Nro. Inspección",
                "Lugar",
                "Ubicación",
                "Aspecto observado",
                "Actividad relacionada",
                "Nivel de riesgo",
                "Observación"
            ]
            hijo.dataRight = [String].init(repeating: "", count: 8)
            hijo.dataRight[0] = data.CodInspeccion ?? ""
            hijo.dataRight[1] = "\(data.NroDetInspeccion ?? 0)"
            hijo.dataRight[2] = data.Lugar ?? ""
            hijo.dataRight[3] = data.CodUbicacion ?? ""
            hijo.dataRight[4] = data.CodAspectoObs ?? ""
            hijo.dataRight[5] = data.CodActividadRel ?? ""
            hijo.dataRight[6] = data.CodNivelRiesgo ?? ""
            hijo.dataRight[7] = data.Observacion ?? ""
            hijo.tableView.reloadData()
        }, error: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
