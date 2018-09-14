import UIKit
import AVKit
import DKImagePickerController

extension UISegmentedControl {
    func customize(_ barraInf: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray
            ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "DINCondensed-Bold", size: 18),
            NSAttributedStringKey.foregroundColor: UIColor.black
            ], for: .selected)
        self.addSubview(barraInf)
    }
}

extension UIViewController {
    
    func presentarAlertaDeseaFinalizar(_ aceptarHandler: ((UIAlertAction) -> Void)?, _ cancelarHandler: ((UIAlertAction) -> Void)?) {
        self.presentAlert("¿Desea finalizar?", "Los datos fueron guardados correctamente", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [aceptarHandler, cancelarHandler])
    }
    
    func presentarAlertaDatosSinGuardar(_ aceptarHandler: (() -> Void)?) {
        self.presentAlert("Datos sin guardar", "¿Está seguro de salir sin guardar cambios?", .alert, nil, Images.alertaAmarilla, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(aceptarAction) in
            aceptarHandler?()
            }, nil])
    }
    
    func presentError(_ mensaje: String) {
        self.presentAlert("Error", mensaje, .alert, 2, nil, [], [], actionHandlers: [])
    }
    
    func presentAlert(_ title: String?, _ message: String?, _ style: UIAlertControllerStyle, _ time: Double?, _ image: UIImage?, _ actionTitles: [String], _ actionStyles: [UIAlertActionStyle], actionHandlers: [((UIAlertAction) -> Void)?] ) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: style)
        if let imagen = image {
            let labelView = alert.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0]
            let imageView = UIImageView.init(image: imagen)
            let tituloLabel = alert.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0].subviews[0] as! UILabel
            imageView.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            labelView.addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            imageView.centerYAnchor.anchorWithOffset(to: tituloLabel.centerYAnchor).constraint(equalToConstant: 0).isActive = true
            imageView.leadingAnchor.anchorWithOffset(to: labelView.leadingAnchor).constraint(equalToConstant: -15).isActive = true
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
    
    func showGaleria(_ fotos: [FotoVideo], _ indice: Int) {
        let vc = VCHelper.galeria as! ImageSliderVC
        Utils.galeriaIndice = indice
        Utils.galeriaVCs = [UIViewController].init(repeating: UIViewController(), count: fotos.count)
        for i in 0..<fotos.count {
            Utils.galeriaVCs[i] = Utils.utilsSB.instantiateViewController(withIdentifier: "imageSliderItem")
            let view = Utils.galeriaVCs[i] as! ImageSliderPVCItem
            Dict.unitToData(fotos[i])
            view.indice = i
            view.foto = fotos[i].copy()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func showVideo(_ multimedia: FotoVideo) {
        if let asset = multimedia.asset {
            asset.fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
        } else if multimedia.Url != nil {
            print("\(Config.urlBase)\(multimedia.Url!)")
            let playerAV = AVPlayer.init(url: URL.init(string: "\(Config.urlBase)\(multimedia.Url!)")!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = playerAV
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        } else {
            self.presentAlert("Error", "No se pudo cargar la información del video", .alert, 2, nil, [], [], actionHandlers: [])
        }
    }
    
    func setTitleAndImage(_ title: String, _ image: UIImage?) {
        let newTitleView = UIView()
        let newStack = UIStackView()
        newStack.spacing = 2
        newStack.axis = .horizontal
        let newTitleLabel = UILabel.init()
        newTitleLabel.attributedText = NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: title.count > 25 ? 13 : 15)!])
        newTitleLabel.textAlignment = .center
        newTitleView.addSubview(newStack)
        newStack.translatesAutoresizingMaskIntoConstraints = false
        newStack.centerXAnchor.constraint(equalTo: newTitleView.centerXAnchor).isActive = true
        newStack.centerYAnchor.constraint(equalTo: newTitleView.centerYAnchor).isActive = true
        newStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        newStack.distribution = .fill
        if let imagen = image {
            let newTitleImage = UIImageView.init(image: imagen)
            newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
            newTitleImage.heightAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
            newStack.addArrangedSubview(newTitleImage)
        }
        newStack.addArrangedSubview(newTitleLabel)
        self.navigationItem.titleView = newTitleView
    }
    
    func setTitleAndImage(_ title: String, _ image: UIImage?, _ color: UIColor) {
        let newTitleView = UIView()
        let newStack = UIStackView()
        newStack.spacing = 2
        newStack.axis = .horizontal
        let newTitleLabel = UILabel.init()
        newTitleLabel.attributedText = NSAttributedString.init(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.init(name: "HelveticaNeue", size: title.count > 25 ? 13 : 15)!])
        newTitleLabel.textAlignment = .center
        newTitleView.addSubview(newStack)
        
        newStack.translatesAutoresizingMaskIntoConstraints = false
        newStack.centerXAnchor.constraint(equalTo: newTitleView.centerXAnchor).isActive = true
        newStack.centerYAnchor.constraint(equalTo: newTitleView.centerYAnchor).isActive = true
        newStack.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        newStack.distribution = .fill
        if let imagen = image {
            let newImage = imagen.withRenderingMode(.alwaysTemplate)
            let newTitleImage = UIImageView.init(image: newImage)
            newTitleImage.tintColor = color
            newTitleImage.widthAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
            newTitleImage.heightAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
            
            newStack.addArrangedSubview(newTitleImage)
        }
        newStack.addArrangedSubview(newTitleLabel)
        self.navigationItem.titleView = newTitleView
    }
    
    func setSearchBarTitle() {
        let searchBar = UISearchBar()
        searchBar.delegate = self as! UISearchBarDelegate
        searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.navigationItem.titleView = searchBar
    }
}

extension String {
    
    func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regEx)
        return emailTest.evaluate(with: self)
    }
    
    func toDate() -> Date? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = "dd-MM-YYYY"
        if let temp = dateFormatterInput.date(from: self) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd"
        if let temp = dateFormatterInput.date(from: self) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let temp = dateFormatterInput.date(from: self) {
            return temp
        }
        dateFormatterInput.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let temp = dateFormatterInput.date(from: self) {
            return temp
        }
        return dateFormatterInput.date(from: self)
    }
    
    func toDate(_ inputFormat: String) -> Date? {
        let dateFormatterInput = DateFormatter()
        dateFormatterInput.dateFormat = inputFormat
        return dateFormatterInput.date(from: self)
    }
}

extension Date {
    
    func toString() -> String {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "es-ES")
        dateFormatterOutput.dateFormat = "EEEE dd 'de' MMMM 'de' yyyy"
        return dateFormatterOutput.string(from: self)
    }
    
    func toString(_ outputFormat: String) -> String {
        let dateFormatterOutput = DateFormatter()
        dateFormatterOutput.locale = Locale(identifier: "es-ES")
        dateFormatterOutput.dateFormat = outputFormat
        return dateFormatterOutput.string(from: self)
    }
    
}
