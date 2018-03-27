import UIKit

class MuroNewObsPVCTab1: UIViewController {
    
    @IBOutlet weak var campoArea: UIButton!
    
    @IBOutlet weak var campoRiesgo: UIButton!
    
    @IBOutlet weak var campoFecha: UIButton!
    
    @IBOutlet weak var campoUbicacion: UIButton!
    
    @IBOutlet weak var campoSubUbicacion: UIButton!
    
    @IBOutlet weak var campoUbicacionEsp: UIButton!
    
    @IBOutlet weak var campoLugar: UITextField!
    
    @IBOutlet weak var campoTipo: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? MuroNewObsVC {
            padre.selectTab(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        campoArea.titleLabel!.numberOfLines = 0
        campoArea.titleLabel!.lineBreakMode = .byWordWrapping
        campoRiesgo.titleLabel!.numberOfLines = 0
        campoRiesgo.titleLabel!.lineBreakMode = .byWordWrapping
        campoFecha.titleLabel!.numberOfLines = 0
        campoFecha.titleLabel!.lineBreakMode = .byWordWrapping
        campoUbicacion.titleLabel!.numberOfLines = 0
        campoUbicacion.titleLabel!.lineBreakMode = .byWordWrapping
        campoSubUbicacion.titleLabel!.numberOfLines = 0
        campoSubUbicacion.titleLabel!.lineBreakMode = .byWordWrapping
        campoUbicacionEsp.titleLabel!.numberOfLines = 0
        campoUbicacionEsp.titleLabel!.lineBreakMode = .byWordWrapping
        campoTipo.titleLabel!.numberOfLines = 0
        campoTipo.titleLabel!.lineBreakMode = .byWordWrapping
    }
    
    @IBAction func clickEnCampoArea(_ sender: Any) {
        Utils.showDropdown(campoArea, [String].init(Globals.obsArea.values), afterClickCampoArea(_:_:))
    }
    
    @IBAction func clickEnCampoRiesgo(_ sender: Any) {
        Utils.showDropdown(campoRiesgo, [String].init(Globals.obsRiesgo.values), afterClickCampoRiesgo(_:_:))
    }
    
    @IBAction func clickEnCampoFecha(_ sender: Any) {
    }
    
    @IBAction func clickEnCampoUbicacion(_ sender: Any) {
        Utils.showDropdown(campoUbicacion, [String].init(Globals.gUbicaciones.values), afterClickCampoUbicacion(_:_:))
    }
    
    @IBAction func clickEnCampoSubUbicacion(_ sender: Any) {
        let keys = (Globals.gUbicaciones as NSDictionary).allKeys(for: campoUbicacion.titleLabel!.text as Any)
        var values = ["-"]
        if keys.count > 0 {
            values = [String].init(Globals.gSubUbicaciones[keys[0] as! String]!.values)
        }
        
        Utils.showDropdown(campoSubUbicacion, values, afterClickCampoSubUbicacion(_:_:))
    }
    
    @IBAction func clickEnCampoUbicEspecifica(_ sender: Any) {
    }
    
    @IBAction func clickEnCampoTipo(_ sender: Any) {
    }
    
    func afterClickCampoArea(_ index: Int, _ item: String) {
        campoArea.setTitle(item, for: .normal)
    }
    func afterClickCampoRiesgo(_ index: Int, _ item: String) {
        campoRiesgo.setTitle(item, for: .normal)
    }
    func afterClickCampoUbicacion(_ index: Int, _ item: String) {
        //let keys = Globals.obsUbic
        //Utils.MNOUbicacion =
        campoUbicacion.setTitle(item, for: .normal)
    }
    func afterClickCampoSubUbicacion(_ index: Int, _ item: String) {
        campoSubUbicacion.setTitle(item, for: .normal)
    }
    func afterClickCampoUbicEspecifica(_ index: Int, _ item: String) {
        campoUbicacionEsp.setTitle(item, for: .normal)
    }
    func afterClickCampoTipo(_ index: Int, _ item: String) {
        campoTipo.setTitle(item, for: .normal)
    }
    
    
    
    
}
