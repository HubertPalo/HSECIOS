import UIKit
import Alamofire

class DocumentosTVC: UITableViewController, UIDocumentInteractionControllerDelegate {
    
    var documentos: [Multimedia] = []
    var docController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docController.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! DocumentosTVCell
        let unit = documentos[indexPath.row]
        celda.titulo.text = unit.Descripcion
        celda.tamanio.text = "\(unit.Tamanio) MBs"
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlfile: URL? = nil
        let unit = documentos[indexPath.row]
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(unit.Descripcion ?? "")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let newbutton = UIBarButtonItem()
        Alamofire.download("", to: destination)
            .downloadProgress { progress in
                //print("Download Progress: \(progress.fractionCompleted)")
                Utils.setDownloadFraction(Float(progress.fractionCompleted))
                //cargaProgreso.progress = Float(progress.fractionCompleted)
            }.validate().responseData { ( response ) in
                //print(response)
                self.docController = UIDocumentInteractionController(url: NSURL.fileURL(withPath: response.destinationURL!.path))
                self.docController.delegate = self
                self.docController.presentOptionsMenu(from: newbutton, animated: true)
                //cargaProgreso.hide(animated: true)
                Utils.desbloquearPantalla()
        }
    }
}

class DocumentosTVCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var tamanio: UILabel!
}
