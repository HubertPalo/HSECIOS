import UIKit

extension UIViewController {
    
    func presentAlert(_ title: String?, _ message: String?, _ style: UIAlertControllerStyle, _ time: Double?, _ image: UIImage?, _ actionTitles: [String], _ actionStyles: [UIAlertActionStyle], actionHandlers: [((UIAlertAction) -> Void)?] ) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        
        if let imagen = image {
            alert.title = "\n\(alert.title ?? "")"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 25, y: 25)
        }
        
        for i in 0..<actionTitles.count {
            alert.addAction(UIAlertAction(title: actionTitles[i], style: actionStyles[i], handler: actionHandlers[i]))
        }
        
        self.present(alert, animated: true, completion: nil)
        
        if let duration = time {
            let when = DispatchTime.now() + duration
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func presentSheetMenu(_ titulo: String?, _ mensaje: String?, _ titulos: [String], _ estilos: [UIAlertActionStyle], _ handlers: [((_ alertAction:UIAlertAction) -> Void)?]) {
        let alertaVC = UIAlertController.init(title: titulo, message: nil, preferredStyle: .actionSheet)
        for i in 0..<titulos.count {
            alertaVC.addAction(UIAlertAction.init(title: titulos[i], style: estilos[i], handler: handlers[i]))
        }
        self.present(alertaVC, animated: true, completion: nil)
    }
}

class Alerts {
    
    static func presentAlert(_ title: String, _ message: String, duration: Int, imagen: UIImage?, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if imagen != nil {
            alert.title = "\n\(alert.title!)"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 20, y: 20)
        }
        
        viewController.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + Double(duration)
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    static func presentAlert(_ title: String, _ message: String, imagen: UIImage?, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
        if imagen != nil {
            alert.title = "\n\(alert.title!)"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 20, y: 20)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentAlertWithAccept(_ title: String, _ message: String, imagen: UIImage?, viewController: UIViewController, acccept: @escaping ()-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            acccept()
        }))
        //alert.addAction(UIAlertAction.init(title: <#T##String?#>, style: <#T##UIAlertActionStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>))
        
        if imagen != nil {
            alert.title = "\n\(alert.title!)"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 20, y: 20)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentAlertWithAcceptAndCancel(_ title: String, _ message: String, imagen: UIImage?, viewController: UIViewController, acccept: @escaping ()-> Void, cancel: @escaping ()-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            acccept()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {(alert: UIAlertAction!) in
            cancel()
        }))
        
        if imagen != nil {
            alert.title = "\n\(alert.title!)"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 20, y: 20)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentAlertWithAcceptAndCancel(_ title: String, _ message: String, imagen: UIImage?, viewController: UIViewController, acccept: @escaping ()-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in
            acccept()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
        
        if imagen != nil {
            alert.title = "\n\(alert.title!)"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 20, y: 20)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func presentError(type: String, viewController: UIViewController){
        var title = ""
        var message = ""
        let duration = 1
        switch type {
        case "401":
            title = "Sin autorizacion"
            message = "Por favor, revise su configuracion"
        case "404":
            title = "Url incorrecta"
            message = "Por favor, revise su configuracion"
        case "500":
            title = "Error interno"
            message = "Por favor, revise su configuracion"
        default:
            title = "Error"
            message = "Ha ocurrido un imprevisto. Por favor, comuníquese con el administrador"
        }
        Alerts.presentAlert(title, message, duration: duration, imagen: UIImage(named: "error"), viewController: viewController)
    }
}

