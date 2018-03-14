import UIKit
import MBProgressHUD
import DropDown
import DatePickerDialog

class Utils {
    // Variables Globales
    static var token = ""
    static var observaciones: [MuroElement] = []
    static var multimedia: [ObsMultimedia] = []
    static var planAccion: [ObsPlanAccion] = []
    static var comentario: [ObsComentario] = []
    static var progressHUD : MBProgressHUD?
    
    static var selectedObsCode : String = ""
    static var selectedInsObsCode : String = ""
    static var selectedObsPlanAccion : Int = -1
    
    static var openComentarios = false
    static let dropdown = DropDown()
    
    //MuroSearchFilterVC
    static var MSFFechaInicio = Date()
    static var MSFFechaFin = Date()
    //MuroSearchFilterVC
    
    //MuroSearchFilterPersonaVC
    static var MSFParray: [Persona] = []
    static var MSFselected: Persona = Persona()
    //MuroSearchFilterPersonaVC
    
    //MuroNewObs
    static var MNOArea = ""
    static var MNORiesgo = ""
    static var MNOFecha = ""
    static var MNOUbicacion = ""
    static var MNOSubUbicacion = ""
    static var MNOUbicacionEsp = ""
    static var MNOLugar = ""
    static var MNOTipo = ""
    //MuroNewObs
    
    
    static func setImageCircle(_ imageview: UIImageView) {
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.layer.masksToBounds = true
    }
    
    static func getHeader() -> Dictionary<String, String> {
        return ["Authorization": "Bearer \(Utils.token)"]
    }
    
    static func separate(_ str: String, _ char: Character) -> [String]{
        let splits = str.split(separator: char)
        var array: [String] = []
        for i in 0..<splits.count {
            array.append(String(splits[i]))
        }
        return array
    }
    
    static func cleanCode(_ str: String) -> String {
        if str == "-" {
            return str
        }
        let splits = str.split(separator: ";")
        return String(splits[1])
    }
    
    static func setDropdown(_ dropdown: DropDown, _ boton: UIButton, _ data: [String], _ onClick: @escaping (_ index: Int, _ item: String)-> Void ) {
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = data
        dropdown.selectionAction = onClick
    }
    
    static func setButtonStyle(to: UIButton) {
        to.titleLabel?.lineBreakMode = .byWordWrapping
        to.titleLabel?.numberOfLines = 0
    }
    
    static func hideStackView(_ stack: UIStackView) {
        if !stack.isHidden {
            stack.isHidden = true
        }
    }
    
    static func showStackView(_ stack: UIStackView) {
        if stack.isHidden {
            stack.isHidden = false
        }
    }
    
    static func showDropdown(_ boton: UIButton, _ data: [String], _ onClick: @escaping (_ index: Int, _ item: String)-> Void ) {
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = data
        dropdown.selectionAction = onClick
        dropdown.show()
    }
    
    static func openDatePicker(_ title: String, _ defaultDate:Date?, _ minDate: Date?, _ maxDate: Date?, chandler: @escaping (_ date: Date?) -> Void) {
        DatePickerDialog().show(title, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", defaultDate: defaultDate ?? Date(), minimumDate: minDate, maximumDate: maxDate, datePickerMode: UIDatePickerMode.date, callback: chandler)
    }
    
    static func bloquearPantalla(_ viewController: UIViewController) {
        var view = viewController.view
        if let viewN = viewController.navigationController {
            view = viewN.view
        }
        progressHUD = MBProgressHUD.showAdded(to: view!, animated: true)
        progressHUD?.bezelView.backgroundColor = UIColor.clear
        progressHUD?.mode = .indeterminate
        progressHUD?.label.text = nil
    }
    
    static func bloquearPantallaDescarga(_ viewController: UIViewController) {
        var view = viewController.view
        if let viewN = viewController.navigationController {
            view = viewN.view
        }
        progressHUD = MBProgressHUD.showAdded(to: view!, animated: true)
        progressHUD?.bezelView.backgroundColor = UIColor.clear
        progressHUD?.mode = .determinate
        progressHUD?.label.text = nil
    }
    
    static func setDownloadFraction(_ fraction: Float){
        progressHUD?.progress = fraction
    }
    
    static func bloquearPantalla(_ viewController: UIViewController, _ shouldBlock: Bool) {
        if shouldBlock {
            bloquearPantalla(viewController)
        }
    }
    
    static func desbloquearPantalla() {
        progressHUD?.hide(animated: true)
    }
    
    static func desbloquearPantalla(_ shouldBlock: Bool) {
        if shouldBlock {
            progressHUD?.hide(animated: true)
        }
    }
    static func str2date(_ date:String, _ inputFormat:String) -> Date {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        return dateFormatterInput.date(from: date)!
    }
    
    static func str2date(_ date:String) -> Date {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let temp = dateFormatterInput.date(from: date) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let temp = dateFormatterInput.date(from: date) {
            return temp
        }
        return dateFormatterInput.date(from: date)!
    }
    
    static func date2str(_ date: Date, _ outputFormat:String) -> String {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "es-ES")
        dateFormatterOutput.dateFormat = outputFormat
        return dateFormatterOutput.string(from: date)
    }
    
    static func date2str(_ date: Date) -> String {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "es-ES")
        dateFormatterOutput.dateFormat = "EEEE dd 'de' MMMM 'de' yyyy"
        return dateFormatterOutput.string(from: date)
    }
    
    static func hour2str(_ date: Date) -> String {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "es-ES")
        dateFormatterOutput.dateFormat = "HH:mm 'h'"
        return dateFormatterOutput.string(from: date)
    }
    
    static func str2date2str(_ date: String, _ inputFormat: String, _ outputFormat: String) -> String {
        let temp = str2date(date, inputFormat)
        return date2str(temp, outputFormat)
    }
    
    static func str2date2str(_ date: String) -> String {
        let temp = str2date(date)
        return date2str(temp)
    }
    
    static func str2hour2str(_ date: String) -> String {
        let temp = str2date(date)
        return hour2str(temp)
    }
    
    static func error(_ message: String,_ vc: UIViewController) {
        
    }
    
    static func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    
}
