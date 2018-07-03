import UIKit

class FiltroContrataVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var campoCodigo: UITextField!
    
    @IBOutlet weak var campoRazonSocial: UITextField!
    
    var data = ["", ""]
    
    var alSeleccionarCelda: ((_ nombre:String, _ codigo:String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.campoCodigo.delegate = self
        self.campoRazonSocial.delegate = self
        self.campoCodigo.tag = 0
        self.campoRazonSocial.tag = 1
    }
    
    func limpiarData() {
        self.data = ["", ""]
        self.campoCodigo?.text = ""
        self.campoRazonSocial?.text = ""
    }
    
    func seleccionarDataYSalir(_ nombre:String, _ codigo:String) {
        self.alSeleccionarCelda?(nombre, codigo)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        data[textField.tag] = textField.text ?? ""
        print(self.data)
    }
    
    @IBAction func clickBuscar(_ sender: Any) {
        self.view.endEditing(true)
        
        var dbDescripcion = Utils.maestroDescripcion["PROV"] ?? []
        var dbCodTipo = Utils.maestroCodTipo["PROV"] ?? []
        
        if !self.data[0].isEmpty {
            for i in (0..<dbCodTipo.count).reversed() {
                if !dbCodTipo[i].uppercased().contains(self.data[0].uppercased()) {
                    dbDescripcion.remove(at: i)
                    dbCodTipo.remove(at: i)
                }
            }
        }
        
        if !self.data[1].isEmpty {
            for i in (0..<dbDescripcion.count).reversed() {
                if !dbDescripcion[i].uppercased().contains(self.data[1].uppercased()) {
                    dbDescripcion.remove(at: i)
                    dbCodTipo.remove(at: i)
                }
            }
        }
        let hijo = self.childViewControllers[0] as! FiltroContrataTVC
        hijo.codigos = dbCodTipo
        hijo.nombres = dbDescripcion
        hijo.tableView.reloadData()
    }
    
}
