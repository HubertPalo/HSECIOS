import UIKit
import WebKit

class NotDetalleTVC: UITableViewController, UIWebViewDelegate {
    
    var heightWebValue = CGFloat(0)
    var shouldLoadData = true
    
    var data = Noticia()
    var comentarios: [Comentario] = []
    // var webView: WKWebView!
    let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("sadadasd")
        print(webView.scrollView.contentSize)
        if self.heightWebValue != webView.scrollView.contentSize.height {
            self.heightWebValue = webView.scrollView.contentSize.height
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .linkClicked {
            UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("asdadad - \(webView.scrollView.contentSize.height)")
        print(webView.frame)
        print(webView.scrollView.contentSize)
        // self.heightWebValue = webView.scrollView.contentSize.height
        // self.tableView.reloadSections([0], with: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return CGFloat(40)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        return tableView.dequeueReusableCell(withIdentifier: "celda1")!.contentView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comentarios.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*if indexPath.section == 0 && heightWebValue > 0{
            return heightWebValue
        }*/
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! NotDetalleTVCell
            celda.titulo.text = data.Titulo
            celda.fecha.text = Utils.str2date2str(data.Fecha)
            celda.webView.allowsInlineMediaPlayback = true
            celda.webView.mediaPlaybackRequiresUserAction = false
            celda.webView.delegate = self
            celda.webView.loadHTMLString(data.Descripcion, baseURL: nil)
            celda.webView.scrollView.isScrollEnabled = false
            // celda.webView.heightAnchor.constraint(equalTo: celda.webView.scrollView.heightAnchor, multiplier: 1.0).isActive = true
            celda.heightConstraint.constant = self.heightWebValue
            
            /*webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.init())
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.translatesAutoresizingMaskIntoConstraints = false
            // webView.scrollView.translatesAutoresizingMaskIntoConstraints = false
            
            celda.noticiaView.addSubview(webView)
            webView.topAnchor.constraint(equalTo: celda.noticiaView.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: celda.noticiaView.rightAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: celda.noticiaView.leftAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: celda.noticiaView.bottomAnchor).isActive = true
            webView.loadHTMLString("\(header)\((data.Descripcion))", baseURL: nil)*/
            // webView.scrollView.heightAnchor.constraint(equalTo: celda.noticiaView.heightAnchor, multiplier: 1.0).isActive = true
            /*print(webView.scrollView.contentSize)
            webView.heightAnchor.constraint(equalTo: webView.scrollView.heightAnchor, multiplier: 1.0).isActive = true
             celda.noticiaView.heightAnchor.constraint(equalTo: webView.heightAnchor, multiplier: 1).isActive = true*/
            
            
            // celda.noticiaView.sizeToFit()
            /*if self.heightWebValue != 0 {
                celda.heightConstraint.constant =  self.heightWebValue
            }*/
            return celda
        }
        let unit = self.comentarios[indexPath.row]
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! CeldaComentario
        celda.autor.text = unit.Nombres
        celda.comentario.text = unit.Comentario
        celda.fecha.text = Utils.str2date2str(unit.Fecha)
        if (unit.CodComentario ?? "") != "" {
            celda.avatar.image = Images.getImageFor("A-\(unit.CodComentario ?? "")")
        }
        // Images.loadAvatarFromDNI(unit.CodComentario, celda.avatar, true)
        // Images.loadImagePreviewFromCode(unit.CodComentario, celda.avatar, tableView, indexPath)
        return celda
        
    }
    
}

class NotDetalleTVCell: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var webView: UIWebView!
    
    // @IBOutlet weak var noticiaView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
}
