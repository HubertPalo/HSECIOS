import UIKit
import DropDown

class MuroSearchVC: UIViewController {
    
    @IBOutlet weak var dropQueBuscar: UIButton!
    
    let dropdown = DropDown()
    
    let listaQueBuscar = ["Observaciones", "Inspecciones", "Noticias"]
    let listaDestinos = ["toFiltroObservacion", "toFiltroInspeccion", "toFiltroNoticia"]
    
    var queBuscar = "Observaciones"
    var destino = "toFiltroObservacion"
    
    var observaciones: [MuroElement] = []
    var parametros: [String:String] = [:]
    var nroitems = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func saveData(_ data: [MuroElement]) {
        observaciones = data
        let hijo = self.childViewControllers[0] as! MuroTVC
        hijo.data = data
        hijo.tableView.reloadData()
    }
    
    @IBAction func clickEnDropQueBuscar(_ sender: Any) {
        Utils.setDropdown(dropdown, dropQueBuscar, listaQueBuscar, afterClickCampo(_:_:))
        dropdown.show()
    }
    
    func afterClickCampo(_ index: Int, _ item: String) {
        dropQueBuscar.setTitle(item, for: .normal)
        queBuscar = item
        destino = listaDestinos[index]
        print("\(index) - \(item)")
    }
    
    @IBAction func clickEnFiltro(_ sender: Any) {
        self.performSegue(withIdentifier: destino, sender: self)
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        nroitems = 10
        searchData()
    }
    
    func searchData() {
        parametros = [:]
        switch queBuscar {
        case "Observaciones":
            parametros["CodUbicacion"] = "\(nroitems)"
            parametros["Lugar"] = "1"
            Helper.postData(Routes.forMuroSearchO(), parametros, true, vcontroller: self, success: successGettingData(_:))
            break
        case "Inspecciones":
            parametros["Elemperpage"] = "\(nroitems)"
            parametros["Pagenumber"] = "1"
            Helper.postData(Routes.forMuroSearchI(), parametros, true, vcontroller: self, success: successGettingData(_:))
            break
        case "Noticias":
            parametros["Elemperpage"] = "\(nroitems)"
            parametros["Pagenumber"] = "1"
            Helper.postData(Routes.forMuroSearchN(), parametros, true, vcontroller: self, success: successGettingData(_:))
            break
        default:
            break
        }
    }
    
    func successGettingData(_ dict: NSDictionary){
        let data = Dict.toArrayMuroElement(dict)
        let hijo = self.childViewControllers[0] as! MuroTVC
        hijo.data = data
        hijo.tableView.reloadData()
    }
    
}
