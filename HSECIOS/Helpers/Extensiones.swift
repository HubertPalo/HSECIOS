import UIKit

extension UIViewController{
    
    
    func presentAlert(_ title: String?,_ message: String?, _ style: UIAlertControllerStyle,_ time: Double?, _ image: UIImage?,_ actionTitles: [String], _ actionStyles: [UIAlertActionStyle], actionHandlers: [((UIAlertAction) -> Void)?] ) {
        
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
    
    
    
    func presentAlert2(_ title: String?,_ message: String?, _ style: UIAlertControllerStyle,_ time: Double?, _ image: UIImage?,_ actionTitles: [String], _ actionStyles: [UIAlertActionStyle], actionHandlers: [((UIAlertAction) -> Void)?] ) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        
        if let imagen = image {
            alert.title = "\n\(alert.title ?? "")"
            let imageView = UIImageView.init(image: imagen)
            imageView.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            alert.view.addSubview(imageView)
            imageView.center = CGPoint.init(x: 25, y: 100)
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
    
    
    
    
    
}
