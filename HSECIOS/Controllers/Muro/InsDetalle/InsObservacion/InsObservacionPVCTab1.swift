import UIKit

class InsObservacionPVCTab1: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        Helper.getData(Routes.forInsObservacionGD(Utils.selectedInsObsCode), false, vcontroller: self, success: {(dict:NSDictionary) in
            let data = Dict.toInsObservacionGD(dict)
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
            hijo.dataRight = [
                data.CodInspeccion,
                data.NroDetInspeccion,
                data.Lugar,
                data.CodUbicacion,
                data.CodAspectoObs,
                data.CodActividadRel,
                data.CodNivelRiesgo,
                data.Observacion
            ]
            hijo.tableView.reloadData()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
