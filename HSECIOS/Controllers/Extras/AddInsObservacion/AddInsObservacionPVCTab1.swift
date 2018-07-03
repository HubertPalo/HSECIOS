import UIKit

class AddInsObservacionPVCTab1: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nroInspeccion: UILabel!
    
    @IBOutlet weak var lugarTF: UITextField!
    
    @IBOutlet weak var observacionTF: UITextField!
    
    var data: [String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lugarTF.delegate = self
        self.observacionTF.delegate = self
        self.lugarTF.tag = 1
        self.observacionTF.tag = 2
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            data["Lugar"] = textField.text
        case 2:
            data["Observacion"] = textField.text
        default:
            break
        }
        print(self.data)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

