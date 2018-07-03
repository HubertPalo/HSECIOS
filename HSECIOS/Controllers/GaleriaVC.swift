import UIKit

/*class GaleriaVC: UIViewController {
    
    var codigo = ""
    
    @IBOutlet weak var noFilesView: UIView!
    
    @IBOutlet weak var multimediaStack: UIStackView!
    
    @IBOutlet weak var documentosStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        multimediaStack.isHidden = true
        documentosStack.isHidden = true
        //getFilesFor(codigo)
    }
    
    func getFilesFor(_ code: String){
        Rest.getData(Routes.forMultimedia(code), false, vcontroller: self, success: {(dict: NSDictionary) in
            let files: [Multimedia] = Dict.toArrayMultimedia(dict)
            var multimedia: [Multimedia] = []
            var documentos: [Multimedia] = []
            
            for i in 0..<files.count {
                switch files[i].TipoArchivo {
                case "TP01":
                    multimedia.append(files[i])
                    break
                case "TP02":
                    multimedia.append(files[i])
                    break
                case "TP03":
                    documentos.append(files[i])
                    break
                default:
                    break
                }
            }
            
            self.multimediaStack.isHidden = !(multimedia.count > 0)
            self.documentosStack.isHidden = !(documentos.count > 0)
            self.noFilesView.isHidden = !(self.multimediaStack.isHidden && self.documentosStack.isHidden)
            let multimediaVC = self.childViewControllers[0] as! MultimediaTVC
            multimediaVC.multimedia = multimedia
            multimediaVC.tableView.reloadData()
            let documentosVC = self.childViewControllers[1] as! DocumentosTVC
            documentosVC.documentos = documentos
            documentosVC.tableView.reloadData()
            
        })
    }
    
}*/
