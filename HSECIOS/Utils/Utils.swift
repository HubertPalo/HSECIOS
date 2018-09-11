import UIKit
import MBProgressHUD
import DropDown
import DatePickerDialog
import DKImagePickerController
import Photos

class Utils {
    // Variables Globales
    static var orientation = UIInterfaceOrientationMask.portrait
    static let mainSB = UIStoryboard.init(name: "Main", bundle: nil)
    static let utilsSB = UIStoryboard.init(name: "Utils", bundle: nil)
    static let addObservacionSB = UIStoryboard.init(name: "AddObservacion", bundle: nil)
    static let addInspeccionSB = UIStoryboard.init(name: "AddInspeccion", bundle: nil)
    static let addInsObsSB = UIStoryboard.init(name: "AddInsObservacion", bundle: nil)
    static let notDetalleSB = UIStoryboard.init(name: "NotDetalle", bundle: nil)
    static let obsDetalleSB = UIStoryboard.init(name: "ObsDetalle", bundle: nil)
    static let insDetalleSB = UIStoryboard.init(name: "InsDetalle", bundle: nil)
    static let insObsDetalleSB = UIStoryboard.init(name: "InsObsDetalle", bundle: nil)
    static let facDetalleSB = UIStoryboard.init(name: "FacDetalle", bundle: nil)
    static let planAccionSB = UIStoryboard.init(name: "PlanAccion", bundle: nil)
    static let capacitacionSB = UIStoryboard.init(name: "Capacitacion", bundle: nil)
    
    static var capCursoDetalle = CapCursoDetalle()
    static var notasVC = NotasVC()
    static var asistenciaVC = AsistenciaVC()
    static var menuVC = MenuVC()
    static var menuPlanesPendientes = PlanesAccionVC()
    static var menuCapRecibidas = CapacitacionVC()
    
    static var userData = UserData()
    
    static var maestro: [String:[Maestro]] = [:]
    static var maestroCodTipo: [String:[String]] = [:]
    static var maestroDescripcion: [String:[String]] = [:]
    
    static var maestroStatic1: [String:[String]] = [:]
    static var maestroStatic2: [String:[String]] = [:]
    
    static let widthDevice = UIScreen.main.bounds.width
    static let heightDevice = UIScreen.main.bounds.height
    
    static var InteraccionHabilitada = true
    
    static var galeriaVCs = [UIViewController]()
    static var galeriaIndice = 0
    
    static var currentYear = 0
    static var currentMonth = ""
    
    static var token = ""
    static var FCMToken = ""
    static var loginUsr = ""
    static var loginPwd = ""
    static var actualView = UIViewController()
    
    static var progressHUD : MBProgressHUD?
    
    static var openComentarios = false
    static let dropdown = DropDown()
    
    static var progressIndicator: UIActivityIndicatorView!
    static var progressFlag = 0
    
    static var shouldStopAlamofireRequests = [Int]()
    
    static func setButtonImage(_ boton: UIButton, _ imagen: UIImage) {
        var subview = UIImageView.init(image: imagen)
        subview.widthAnchor.constraint(equalToConstant: 25).isActive = true
        subview.heightAnchor.constraint(equalToConstant: 25).isActive = true
        boton.addSubview(subview)
        subview.centerXAnchor.anchorWithOffset(to: boton.centerXAnchor).constraint(equalToConstant: 0).isActive = true
        subview.centerYAnchor.anchorWithOffset(to: boton.centerYAnchor).constraint(equalToConstant: 0).isActive = true
        boton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        boton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    static func separateMultimedia(_ data: [Multimedia]) -> (fotovideos: [FotoVideo], documentos: [DocumentoGeneral]) {
        var fotovideos: [FotoVideo] = []
        var documentos: [DocumentoGeneral] = []
        for i in 0..<data.count {
            let tipo = data[i].TipoArchivo ?? ""
            switch tipo {
            case "TP01": // imagen
                fotovideos.append(data[i].toFotoVideo())
                /*let unit = FotoVideo()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = tipo
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                unit.esVideo = false
                multimedia.append(unit)*/
            case "TP02": // video
                fotovideos.append(data[i].toFotoVideo())
                /*let unit = FotoVideo()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = tipo
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                unit.esVideo = true
                multimedia.append(unit)*/
            case "TP03": // documento
                documentos.append(data[i].toDocumentoGeneral())
                /*let unit = DocumentoGeneral()
                unit.Correlativo = "\(data[i]["Correlativo"] as? Int ?? -1)"
                unit.Url = data[i]["Url"] as? String ?? ""
                unit.Tamanio = data[i]["Tamanio"] as? String ?? ""
                unit.TipoArchivo = tipo
                unit.Descripcion = data[i]["Descripcion"] as? String ?? ""
                documentos.append(unit)*/
            default:
                break
            }
        }
        return (fotovideos,documentos)
    }
    
    static func test2(_ cadena1: inout String, _ cadena2: inout String) {
        cadena1 = "funciono"
        cadena2 = "la funcion"
    }
    
    static func getAllYearsRange() -> (initialDate: String, endDate: String) {
        let actualYear: Int = Int(Utils.date2str(Date(), "YYYY"))!
        if actualYear < 2018 {
            return ("2014-01-01", "2018-01-01")
        }
        return ("2014-01-01", Utils.date2str(Date(), "YYYY-MM-dd"))
    }
    
    static func getYearArray(_ withAsterisk: Bool) -> [String] {
        let anhoActual: Int = Int(Utils.date2str(Date(), "YYYY")) ?? 2018
        var array: [String] = withAsterisk ? ["*"] : []
        for i in (2014..<anhoActual + 1).reversed() {
            array.append("\(i)")
        }
        return array
    }
    
    static func bloquearPantalla() {
        print("ProgressFlag : \(self.progressFlag)+")
        if progressFlag == 0 {
            progressIndicator.isHidden = false
            progressIndicator.startAnimating()
            progressIndicator.superview?.bringSubview(toFront: progressIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        progressFlag = progressFlag + 1
    }
    
    static func showFichaFor(_ dni: String){
        // ((self.menuVC.childViewControllers[0] as! UITabBarController).childViewControllers[0] as! UINavigationController).popToRootViewController(animated: true)
        self.menuVC.showFichaFor(dni)
    }
    
    /*static func initCeldaGaleria(_ celda: inout CeldaGaleria, _ dataIzq: FotoVideo, _ dataDer: FotoVideo?, _ editable: Bool, _ tableview: UITableView, _ indexPath: IndexPath) {
        celda.viewX1.isHidden = !editable
        celda.viewX2.isHidden = !editable
        celda.play1.isHidden = dataIzq.TipoArchivo != "TP02"
        celda.play2.isHidden = dataDer != nil && dataDer!.TipoArchivo != "TP02"//  !(dataDer?.esVideo ?? false)
        celda.imagen2.isHidden = dataDer == nil
        Dict.unitToData(dataIzq)
        if dataIzq.asset == nil {
            /*Images.loadImagePreviewFromCode("\(dataIzq.Correlativo ?? 0)", celda.imagen1, {
                tableview.reloadRows(at: [indexPath], with: .none)
            })*/
        } else {
            celda.imagen1.image = dataIzq.imagen
        }
        if let newdataDer = dataDer {
            if newdataDer.asset == nil {
                /*Images.loadImagePreviewFromCode("\(newdataDer.Correlativo ?? 0)", celda.imagen2, {
                    tableview.reloadRows(at: [indexPath], with: .none)
                })*/
            } else {
                celda.imagen2.image = newdataDer.imagen
            }
        }
    }
    
    static func initCeldaDocumento(_ celda: CeldaDocumento, _ data: DocumentoGeneral, _ editable: Bool, _ downloadable: Bool) -> CeldaDocumento{
        celda.botonEliminar.isEnabled = downloadable
        if let url = data.url {
            
        } else {
            celda.nombre.text = data.Descripcion
            celda.tamanho.text = self.getSizeFromFile(size: Int(data.Tamanio ?? "") ?? 0)
            celda.viewX.isHidden = !editable
            let fileNameSplits = (data.Descripcion ?? "").components(separatedBy: ".")
            let fileExtension = fileNameSplits[fileNameSplits.count - 1]
            Images.loadIcon("FILES.\(fileExtension)", celda.icono)
        }
        return celda
    }*/
    
    static func loadAssets(assets: [DKAsset], originales: [FotoVideo], chandler: ((_:[FotoVideo]) -> Void)?) {
        var nombres: [String] = []
        var nuevos = originales// [FotoVideo].init(originales)
        var finishedImage = [Bool].init(repeating: false, count: assets.count)
        //var finishedData = [Bool].init(repeating: false, count: assets.count)
        for i in 0..<originales.count {
            nombres.append(originales[i].Descripcion ?? "")
        }
        for i in 0..<assets.count {
            let unit = FotoVideo()
            assets[i].fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image, info) in
                unit.asset = assets[i]
                unit.TipoArchivo = assets[i].isVideo ? "TP02" : "TP01"
                unit.imagen = image ?? Images.blank
                unit.Descripcion = PHAssetResource.assetResources(for: assets[i].originalAsset!).first?.originalFilename ?? ""
                if !nombres.contains(unit.Descripcion ?? "") {
                    nuevos.append(unit)
                    nombres.append(unit.Descripcion ?? "")
                }
                finishedImage[i] = true
                var finishedFlagImage = true
                for i in 0..<finishedImage.count {
                    finishedFlagImage = finishedFlagImage && finishedImage[i]
                }
                /*var finishedFlagData = true
                for i in 0..<finishedData.count {
                    finishedFlagData = finishedFlagData && finishedImage[i]
                }*/
                if finishedFlagImage/* && finishedFlagData*/ {
                    chandler?(nuevos)
                }
            })
            
        }
    }
    
    static func handleSeconds(_ input: String) -> NSMutableAttributedString? {
        print("\(input)")
        let fuente = "HelveticaNeue-Bold"
        let tamanho: CGFloat = 13
        var color = UIColor.black
        
        if let numero: Int = Int(input) {
            if numero == 0 {
                return nil
            }
            if numero < 0 {
                color = UIColor.red
            }
            
            let minutos = numero.magnitude
            if minutos == 1 {
                return Utils.generateAttributedString(["1 minuto"], [fuente], [tamanho], [color])
            }
            if minutos < 60 {
                return Utils.generateAttributedString(["\(minutos) minutos"], [fuente], [tamanho], [color])
            }
            
            let horas = minutos / (60)
            if horas == 1 {
                return Utils.generateAttributedString(["1 hora"], [fuente], [tamanho], [color])
            }
            if horas < 24 {
                return Utils.generateAttributedString(["\(horas) horas"], [fuente], [tamanho], [color])
            }
            
            let dias = minutos / (60*24)
            if dias == 1 {
                return Utils.generateAttributedString(["1 día"], [fuente], [tamanho], [color])
            }
            if dias < 7 {
                return Utils.generateAttributedString(["\(dias) días"], [fuente], [tamanho], [color])
            }
            
            let semanas = minutos / (60*24*7)
            if semanas == 1 {
                return Utils.generateAttributedString(["1 semana"], [fuente], [tamanho], [color])
            }
            return Utils.generateAttributedString(["\(semanas) semanas"], [fuente], [tamanho], [color])
        }
        return nil
    }
    
    static func setTitleAndImage(_ viewcontroller: UIViewController,_ title: String, _ imagen: UIImage?) {
        
        let newStack = UIStackView()
        newStack.spacing = 2
        
        let newTitleView = UIView()
        let newTitleImage = UIImageView.init(image: imagen)
        newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
        newTitleImage.heightAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
        let newTitleLabel = UILabel.init()
        newTitleLabel.attributedText = NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: title.count > 25 ? 13 : 15)!])
        newTitleLabel.textAlignment = .center
        
        
        newTitleView.addSubview(newStack)
        newStack.translatesAutoresizingMaskIntoConstraints = false
        
        // newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        newStack.centerXAnchor.constraint(equalTo: newTitleView.centerXAnchor).isActive = true
        newStack.centerYAnchor.constraint(equalTo: newTitleView.centerYAnchor).isActive = true
        //newStack.bottomAnchor.anchorWithOffset(to: newTitleView.bottomAnchor).constraint(equalToConstant: 15).isActive = true
        //newStack.topAnchor.anchorWithOffset(to: newTitleView.topAnchor).constraint(equalToConstant: 15).isActive = true
        //newStack.heightAnchor.constraint(equalToConstant: 40)
        newStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        newStack.distribution = .fill
        newStack.addArrangedSubview(newTitleImage)
        newStack.addArrangedSubview(newTitleLabel)
        // print(viewcontroller.navigationItem.titleView?.frame)
        viewcontroller.navigationItem.titleView = newTitleView
    }
    
    /*static func openSheetMenu(_ viewcontroller: UIViewController, _ titulo: String?, _ mensaje: String?, _ titulos: [String], _ estilos: [UIAlertActionStyle], _ handlers: [((_ alertAction:UIAlertAction) -> Void)?]) {
        let alertaVC = UIAlertController.init(title: titulo, message: nil, preferredStyle: .actionSheet)
        for i in 0..<titulos.count {
            alertaVC.addAction(UIAlertAction.init(title: titulos[i], style: estilos[i], handler: handlers[i]))
        }
        viewcontroller.present(alertaVC, animated: true, completion: nil)
    }*/
    
    static func setTitleAndImage2(_ viewcontroller: UIViewController,_ title: String, _ imagen: UIImage?) {
        // print(viewcontroller.navigationItem.titleView?.frame)
        let newStack = UIStackView()
        newStack.spacing = 5
        let width = 100
        let height = 25
        // var imagennueva = imagen?.withRenderingMode(.alwaysTemplate)
        // let newTitleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        // let newTitleImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: height, height: height))
        let newTitleView = UIView()
        let newTitleImage = UIImageView.init(image: imagen)
        newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(22)).isActive = true
        newTitleImage.heightAnchor.constraint(equalToConstant: CGFloat(22)).isActive = true
        let newTitleLabel = UILabel.init()
        newTitleLabel.attributedText = NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: title.count > 25 ? 11 : 15)])
        newTitleLabel.textAlignment = .natural
        
        
        newTitleView.addSubview(newStack)
        newStack.translatesAutoresizingMaskIntoConstraints = false
        
        // newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        newStack.centerXAnchor.constraint(equalTo: newTitleView.centerXAnchor).isActive = true
        newStack.centerYAnchor.constraint(equalTo: newTitleView.centerYAnchor).isActive = true
        //newStack.bottomAnchor.anchorWithOffset(to: newTitleView.bottomAnchor).constraint(equalToConstant: 15).isActive = true
        //newStack.topAnchor.anchorWithOffset(to: newTitleView.topAnchor).constraint(equalToConstant: 15).isActive = true
        //newStack.heightAnchor.constraint(equalToConstant: 40)
        newStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        newStack.distribution = .fill
        newStack.addArrangedSubview(newTitleImage)
        newStack.addArrangedSubview(newTitleLabel)
        // print(viewcontroller.navigationItem.titleView?.frame)
        viewcontroller.navigationItem.titleView = newTitleView
    }
    
    static func createBarButtonItem(_ imagen: UIImage, _ width: Int, _ height: Int) -> UIBarButtonItem {
        let boton: UIButton = UIButton(type: .custom)
        boton.setImage(imagen, for: .normal)
        boton.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        return UIBarButtonItem.init(customView: boton)
    }
    
    static func getDateMonthInterval(_ date:Date) -> (initialDate: Date, endDate: Date) {
        let currentCalendar = Calendar.current
        let interval = currentCalendar.dateInterval(of: .month, for: date)
        let endDate = currentCalendar.date(byAdding: .day, value: -1, to: interval!.end)
        return (interval?.start ?? date, endDate ?? date)
    }
    
    static func generateAttributedString(_ strings:[String], _ fonts: [String], _ sizes: [CGFloat]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString.init()
        for i in 0..<strings.count {
            result.append(NSAttributedString.init(string: strings[i], attributes: [NSAttributedStringKey.font: UIFont.init(name: fonts[i], size: sizes[i]) ?? UIFont.init(name: "HelveticaNeue-Bold", size: 13)!]))
        }
        return result
    }
    
    static func generateAttributedString(_ strings:[String], _ fonts: [String], _ sizes: [CGFloat], _ colors:[UIColor]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString.init()
        for i in 0..<strings.count {
            result.append(NSAttributedString.init(string: strings[i], attributes: [NSAttributedStringKey.font: UIFont.init(name: fonts[i], size: sizes[i]) ?? UIFont.init(name: "HelveticaNeue-Bold", size: 13)!, NSAttributedStringKey.foregroundColor: colors[i]]))
        }
        return result
    }
    
    static func addInitialRedAsterisk(_ initialString: String) -> NSMutableAttributedString {
        return Utils.addInitialRedAsterisk(initialString, "HelveticaNeue-Bold", 13)
    }
    
    static func addInitialRedAsterisk(_ initialString: String, _ fontName: String, _ size: CGFloat) -> NSMutableAttributedString {
        let result = NSMutableAttributedString.init(string: "* \(initialString)", attributes: [NSAttributedStringKey.font: UIFont.init(name: fontName, size: size) ?? UIFont.init(name: "HelveticaNeue-Bold", size: 13)!])
        result.setAttributes([NSAttributedStringKey.font: UIFont.init(name: fontName, size: size) ?? UIFont.init(name: "HelveticaNeue-Bold", size: 13)!, NSAttributedStringKey.foregroundColor: UIColor.red], range: NSMakeRange(0, 1))
        return result
    }
    
    static func searchMaestroDescripcion(_ category: String,_ codTipo: String) -> String {
        let arrayAbuscar = Utils.maestroCodTipo[category] ?? []
        for i in 0..<arrayAbuscar.count {
            if arrayAbuscar[i] == codTipo {
                return Utils.maestroDescripcion[category]?[i] ?? ""
            }
        }
        return ""
    }
    
    static func searchMaestroDescripcion(_ codigo: String) -> String {
        var codigoSplits = codigo.components(separatedBy: ".")
        if codigoSplits.count > 1 {
            var codTipo = codigoSplits[codigoSplits.count - 1]
            var category = ""
            for i in 0..<(codigoSplits.count-1) {
                category += codigoSplits[i]
            }
            let arrayAbuscar = Utils.maestroCodTipo[category] ?? []
            for i in 0..<arrayAbuscar.count {
                if arrayAbuscar[i] == codTipo {
                    return Utils.maestroDescripcion[category]?[i] ?? ""
                }
            }
        }
        return ""
    }
    
    static func searchMaestroStatic(_ category: String,_ codTipo: String) -> String {
        let arrayAbuscar = Utils.maestroStatic1[category] ?? []
        for i in 0..<arrayAbuscar.count {
            if arrayAbuscar[i] == codTipo {
                return Utils.maestroStatic2[category]?[i] ?? ""
            }
        }
        return ""
    }
    
    static func navigateMenu(_ to: Int) {
        self.menuVC.navigateTo(to)
    }
    
    static func openMenu(){
        self.menuVC.showMenu()
    }
    
    
    static func openMenuTab(){
        self.menuVC.showMenuTab()
    }
    
    static func getSizeFromFile(file: NSData) -> String {
        let bytes = file.length
        if bytes < 1024 {
            return "\(bytes) B"
        }
        let kilobytes: Float = Float(bytes/1024)
        if kilobytes < 1024 {
            return "\(String(format: "%.2f", kilobytes)) KB"
        }
        let megabytes: Float = Float(kilobytes/1024)
        return "\(String(format: "%.2f", megabytes)) MB"
    }
    
    
    
    static func getSizeFromFile(size: Int?) -> String {
        if let noNil = size {
            let bytes = noNil
            if bytes < 1024 {
                return "\(bytes) B"
            }
            let kilobytes: Float = Float(bytes/1024)
            if kilobytes < 1024 {
                return "\(String(format: "%.2f", kilobytes)) KB"
            }
            let megabytes: Float = Float(kilobytes/1024)
            return "\(String(format: "%.2f", megabytes)) MB"
        }
        return "-"
    }
    
    static func setImageCircle(_ imageview: UIImageView) {
        imageview.layer.cornerRadius = imageview.frame.height/2
        imageview.layer.masksToBounds = true
    }
    
    static func getHeader() -> Dictionary<String, String> {
        return ["Authorization": "Bearer \(Utils.token)"]
    }
    
    /*static func separate(_ str: String, _ char: Character) -> [String]{
        let splits = str.split(separator: char)
        var array: [String] = []
        for i in 0..<splits.count {
            array.append(String(splits[i]))
        }
        return array
    }*/
    
    /*static func cleanCode(_ str: String) -> String {
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
    }*/
    
    static func setButtonStyle(to: UIButton) {
        to.titleLabel?.lineBreakMode = .byWordWrapping
        to.titleLabel?.numberOfLines = 0
    }
    
    /*static func hideStackView(_ stack: UIStackView) {
        if !stack.isHidden {
            stack.isHidden = true
        }
    }
    
    static func showStackView(_ stack: UIStackView) {
        if stack.isHidden {
            stack.isHidden = false
        }
    }*/
    
    static func showDropdown(_ boton: UIButton, _ data: [String], _ onClick: @escaping (_ index: Int, _ item: String)-> Void ) {
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = data
        dropdown.selectionAction = {(index, item) in
            boton.titleLabel!.numberOfLines = 2
            boton.titleLabel!.lineBreakMode = .byWordWrapping
            boton.setTitle(item, for: .normal)
            onClick(index, item)
        }
        dropdown.show()
    }
    
    static func openDatePicker(_ title: String, _ defaultDate:Date?, _ minDate: Date?, _ maxDate: Date?, chandler: @escaping (_ date: Date) -> Void) {
        DatePickerDialog().show(title, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", defaultDate: defaultDate ?? Date(), minimumDate: minDate, maximumDate: maxDate, datePickerMode: UIDatePickerMode.date, callback: {(date:Date?) in
            if let newdate = date {
                chandler(newdate)
            }
        })
    }
    
    static func openHourPicker(_ title: String, chandler: @escaping (_ date: Date) -> Void) {
        DatePickerDialog().show(title, doneButtonTitle: "Aceptar", cancelButtonTitle: "Cancelar", defaultDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: UIDatePickerMode.time, callback: {(date:Date?) in
            if let newdate = date {
                chandler(newdate)
            }
        })
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
    
    static func desbloquearPantalla() {
        print("ProgressFlag : \(self.progressFlag)-")
        progressFlag = progressFlag - 1
        if progressFlag == 0 {
            progressIndicator.stopAnimating()
            progressIndicator.isHidden = true
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    static func str2date(_ date:String, _ inputFormat:String) -> Date? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        return dateFormatterInput.date(from: date)
    }
    
    static func str2date(_ date:String) -> Date? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let temp = dateFormatterInput.date(from: date) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let temp = dateFormatterInput.date(from: date) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        if let temp = dateFormatterInput.date(from: date) {
            return temp
        }
        return dateFormatterInput.date(from: date)
    }
    
    static func date2str(_ date: Date?, _ outputFormat:String) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = outputFormat
            return dateFormatterOutput.string(from: newdate)
        }
        return ""
    }
    
    static func date2str(_ date: Date?) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = "EEEE dd 'de' MMMM 'de' yyyy"
            return dateFormatterOutput.string(from: newdate)
        }
        return ""
    }
    
    static func hour2str(_ date: Date?) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = "HH:mm 'h'"
            return dateFormatterOutput.string(from: newdate)
        }
        return ""
    }
    
    static func str2date2str(_ date: String, _ inputFormat: String, _ outputFormat: String) -> String {
        let temp = str2date(date, inputFormat)
        return date2str(temp, outputFormat)
    }
    
    static func str2date2str(_ date: String) -> String {
        if date == "" {
            return ""
        }
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
    
    static func randomInt(_ limite: Int) -> Int {
        return Int(arc4random_uniform(UInt32(limite)))
    }
    
    static func randomInt() -> Int {
        return Int(arc4random_uniform(UInt32(100000000)))
    }
    
    static func adaptSegmentedControl(_ segmentedControl: UISegmentedControl) -> UISegmentedControl {
        segmentedControl.backgroundColor = UIColor.white
        //segmentedControl.tintColor = UIColor.blue
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: 14)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: 14)], for: .selected)
        let underView = UIView()
        segmentedControl.addSubview(underView)
        underView.bottomAnchor.anchorWithOffset(to: segmentedControl.bottomAnchor).constraint(equalToConstant: 0).isActive = true
        underView.leftAnchor.anchorWithOffset(to: segmentedControl.leftAnchor).constraint(equalToConstant: 0).isActive = true
        underView.rightAnchor.anchorWithOffset(to: segmentedControl.rightAnchor).constraint(equalToConstant: 0).isActive = true
        underView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return segmentedControl
    }
    
    static func procesarMensajeError(_ error: String) -> (titulo: String, mensaje: String) {
        switch error {
        case "400":
            return ("Error de sintaxis", "Se envió un mensaje erróneo al servidor")
        case "401":
            return ("Error de autorización", "Revise que su sesión aún se encuentre activa")
        case "403":
            return ("Error de acceso", "Se prohibió el acceso al recurso solicitado")
        case "404":
            return ("Error de acceso", "No se encontró el recurso solicitado")
        case "405":
            return ("Error de acceso", "Se debe solicitar el recurso de otra forma")
        case "500":
            return ("Error interno", "El servidor falló al procesar su solicitud")
        case "Error":
            return ("Error desconocido", "Algo interfirió con su solicitud")
        default:
            return ("Error", error)
        }
    }
    
    static func fechaconHora(_ date: String) -> String {
        if date == "" {
            return ""
        }
        let temp = str2date(date)
        return date2hora(temp)
    }
    
    static func date2hora(_ date: Date?) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = "EEEE, d MMM yyyy, h:mm a"
            return dateFormatterOutput.string(from: newdate)
            
        }
        return ""
    }
    
    
    static func dataCombox(_ date: Date?) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = "EEE d MMM"
            return dateFormatterOutput.string(from: newdate)
            
        }
        return ""
    }
    
    static func Duracion_curso(_ input: String) -> String {
        print("\(input)")
        if let numero: Int = Int(input) {
            let minutos = numero.magnitude
            if minutos == 1 {
                return "1 minuto"
            }
            if minutos < 60 {
                return "\(minutos) minutos"
            }
            
            let horas = minutos / (60)
            if horas == 1 {
                return "1 hora"
            }
            if horas < 24 {
                return "\(horas) horas"
            }
            
            let dias = minutos / (60*24)
            if dias == 1 {
                return "1 día"
            }
            if dias < 7 {
                return "\(dias) días"
            }
            
            let semanas = minutos / (60*24*7)
            if semanas == 1 {
                return "1 semana"
            }
            return "\(semanas) semanas"
        }
        return ""
    }
    
    static func dateShort(_ date: Date?) -> String {
        if let newdate = date {
            let dateFormatterOutput = DateFormatter()
            dateFormatterOutput.locale = Locale(identifier: "es-ES")
            dateFormatterOutput.dateFormat = "EEE d MMM"
            return dateFormatterOutput.string(from: newdate)
        }
        return ""
    }
    
    static func getYearArray() -> [String] {
        var anhoActual: Int = Int(Utils.date2str(Date(), "YYYY")) ?? 2018
        var array: [String] = []
        for i in (2014..<anhoActual + 1).reversed() {
            array.append("\(i)")
        }
        return array
    }
}
