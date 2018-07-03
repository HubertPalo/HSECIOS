import UIKit

class InsObservacionPVCTab1: UIViewController {
    
    var insObservacion = InsObservacion()
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let padre = self.parent?.parent as? InsObservacionVC {
            padre.selectTab(0)
        }
        Rest.getDataGeneral(Routes.forInsObservacionGD(insObservacion.Correlativo), false, success: {(resultValue:Any?,data:Data?) in
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
        }, error: nil)
        /*Rest.getData(Routes.forInsObservacionGD(insObservacion.Correlativo), false, vcontroller: self, success: {(dict:NSDictionary) in
            // let data: InsObservacionGD = Dict.translateTo(data!)!
            let data = Dict.toInsObservacionGD(dict)
            
            print(dict)
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
        })*/
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
