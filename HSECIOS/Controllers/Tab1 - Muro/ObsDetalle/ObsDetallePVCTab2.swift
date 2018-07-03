import UIKit

class ObsDetallePVCTab2: UIViewController {
    
    var observacion = MuroElement()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(1)
        }
        let hijo = self.childViewControllers[0] as! ObsDetalleTVC
        Rest.getDataGeneral(Routes.forObsDetalle(observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            // let obsdetalle = Dict.toObsDetalle(dict)
            // hijo.obsDetalle = obsdetalle
            hijo.obsDetalle = Dict.dataToUnit(data!)!
            hijo.observacion = self.observacion
            hijo.reloadValues()
            if self.observacion.Tipo == "TO03" || self.observacion.Tipo == "TO04" {
                Rest.getDataGeneral(Routes.forObsSubDetalle(self.observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
                    let arrayObsSubDetalle: ArrayGeneral<ObsSubDetalle> = Dict.dataToArray(data!)
                    hijo.obsSubDetalle = arrayObsSubDetalle.Data
                    hijo.reloadValues()
                }, error: nil)
                Rest.getDataGeneral(Routes.forObsInvolucrados(self.observacion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
                    let arrayInvolucrados: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                    hijo.obsInvolucrados = arrayInvolucrados.Data
                    hijo.reloadValues()
                }, error: nil)
                /*Rest.getData(Routes.forObsSubDetalle(self.observacion.Codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
                    hijo.obsSubDetalle = Dict.toArrayObsSubDetalle(dict)
                    hijo.reloadValues()
                })
                Rest.getData(Routes.forObsInvolucrados(self.observacion.Codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
                    hijo.obsInvolucrados = Dict.toArrayPersona(dict)
                    hijo.reloadValues()
                })*/
            }
        }, error: nil)
        /*Rest.getData(Routes.forObsDetalle(observacion.Codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            let obsdetalle = Dict.toObsDetalle(dict)
            hijo.obsDetalle = obsdetalle
            hijo.observacion = self.observacion
            hijo.reloadValues()
            if self.observacion.Tipo == "TO03" || self.observacion.Tipo == "TO04" {
                Rest.getData(Routes.forObsSubDetalle(self.observacion.Codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
                    hijo.obsSubDetalle = Dict.toArrayObsSubDetalle(dict)
                    hijo.reloadValues()
                })
                Rest.getData(Routes.forObsInvolucrados(self.observacion.Codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
                    hijo.obsInvolucrados = Dict.toArrayPersona(dict)
                    hijo.reloadValues()
                })
            }
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
