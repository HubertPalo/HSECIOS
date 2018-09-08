import UIKit

class InsDetallePVCTab2: UIViewController {
    
    var inspeccion = MuroElement()
    var personasQueAtendieron = PersonasVC()
    var personasQueRealizaronLaInspeccion = PersonasVC()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(1)
        }
        Rest.getDataGeneral(Routes.forInsEquipoInspeccion(inspeccion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            self.personasQueRealizaronLaInspeccion.data = arrayPersonas.Data
            self.personasQueRealizaronLaInspeccion.tabla.reloadData()
        }, error: nil)
        Rest.getDataGeneral(Routes.forInsPersonasAtendidas(inspeccion.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            let arrayPersonas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            self.personasQueAtendieron.data = arrayPersonas.Data
            self.personasQueAtendieron.tabla.reloadData()
        }, error: nil)
        /*Rest.getData(Routes.forInsEquipoInspeccion(inspeccion.Codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            let data = Dict.toArrayPersona(dict)
            self.personasQueRealizaronLaInspeccion.data = data
            self.personasQueRealizaronLaInspeccion.tabla.reloadData()
        })
        Rest.getData(Routes.forInsPersonasAtendidas(inspeccion.Codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
            let data = Dict.toArrayPersona(dict)
            self.personasQueAtendieron.data = data
            self.personasQueAtendieron.tabla.reloadData()
        })*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // updateChild("Personas que realizan la inspección", [], true, 0)
        // updateChild("Personas que atendieron", [], false, 1)
        self.personasQueRealizaronLaInspeccion = self.childViewControllers[0] as! PersonasVC
        self.personasQueRealizaronLaInspeccion.titulo.text = "Personas que realizan la inspección"
        self.personasQueRealizaronLaInspeccion.paintLeader = true
        self.personasQueRealizaronLaInspeccion.data = []
        self.personasQueRealizaronLaInspeccion.tabla.reloadData()
        self.personasQueAtendieron = self.childViewControllers[1] as! PersonasVC
        self.personasQueAtendieron.titulo.text = "Personas que atendieron"
        self.personasQueAtendieron.paintLeader = false
        self.personasQueAtendieron.data = []
        self.personasQueAtendieron.tabla.reloadData()
    }
    
    func updateChild(_ title: String, _ data:[Persona], _ paintLeader: Bool, _ index: Int){
        if self.childViewControllers.count > index {
            let hijo = self.childViewControllers[index] as! PersonasVC
            hijo.titulo.text = title
            hijo.paintLeader = paintLeader
            hijo.data = data
            hijo.tabla.reloadData()
        }
        
    }
}
