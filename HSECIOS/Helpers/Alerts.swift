import UIKit

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
            /*if title == "Error 401" {
             while viewController?.navigationController?.viewControllers[viewController!.navigationController!.viewControllers.count - 1] as? ReservaLoginVC == nil{
             viewController?.navigationController?.popViewController(animated: true)
             }
             viewController?.dismiss(animated: true, completion: nil)
             }*/
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

