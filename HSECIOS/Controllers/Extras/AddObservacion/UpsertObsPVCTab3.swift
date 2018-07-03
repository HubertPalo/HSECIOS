import UIKit

class UpsertObsPVCTab3: UIViewController {
    
    var modo = "ADD"
    var codigo = ""
    
    var galeria = GaleriaFVDVC()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDVC
        // self.galeria.loadModoPOST()
    }
    
    func loadModo(_ modo: String, _ codigo: String) {
        self.modo = modo
        self.codigo = codigo
        
        switch modo {
        case "ADD":
            break
        case "PUT":
            Rest.getDataGeneral(Routes.forMultimedia(self.codigo), false, success: {(resultValue:Any?,data:Data?) in
                let multimedia: ArrayGeneral<Multimedia> = Dict.dataToUnit(data!)!
                print(String.init(data: Dict.unitToData(multimedia)!, encoding: .utf8))
            }, error: nil)
        default:
            break
        }
        
    }
}
