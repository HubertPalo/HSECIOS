import UIKit

class InsDetallePVCTab2: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(1)
        }
        Helper.getData(Routes.forInsEquipoInspeccion(Utils.selectedObsCode), false, vcontroller: self, success: {(dict:NSDictionary) in
            let data = Dict.toArrayPersona(dict)
            self.updateChild("Personas que realizan la inspección", data, true, 0)
        })
        Helper.getData(Routes.forInsPersonasAtendidas(Utils.selectedObsCode), false, vcontroller: self, success: {(dict:NSDictionary) in
            let data = Dict.toArrayPersona(dict)
            self.updateChild("Personas que atendieron", data, false, 1)
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChild("Personas que realizan la inspección", [], true, 0)
        updateChild("Personas que atendieron", [], false, 1)
    }
    
    func updateChild(_ title: String, _ data:[Persona], _ paintLeader: Bool, _ index: Int){
        let hijo = self.childViewControllers[index] as! PersonasVC
        hijo.titulo.text = title
        hijo.paintLeader = paintLeader
        hijo.data = data
        hijo.tabla.reloadData()
    }
}
