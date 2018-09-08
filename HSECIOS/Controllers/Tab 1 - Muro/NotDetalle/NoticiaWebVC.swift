import UIKit
import WebKit

class NoticiaWebVC: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webViewContainer: UIView!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    var webView: WKWebView!
    var noticia = Noticia()
    let header = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration.init())
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        //let myURL = URL(string: "https://www.apple.com")
        //let myRequest = URLRequest(url: myURL!)
        
        webViewContainer.addSubview(webView)
        webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        //webView.load(myRequest)
    }
    
    func loadNoticia(noticia: Noticia) {
        titulo.text = noticia.Titulo
        fecha.text = noticia.Fecha
        
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.loadHTMLString("\(header)\((noticia.Descripcion))", baseURL: nil)
        //webViewContainer.addSubview(webView)
        //webView.topAnchor.constraint(equalTo: webViewContainer.topAnchor).isActive = true
        //webView.rightAnchor.constraint(equalTo: webViewContainer.rightAnchor).isActive = true
        //webView.leftAnchor.constraint(equalTo: webViewContainer.leftAnchor).isActive = true
        //webView.bottomAnchor.constraint(equalTo: webViewContainer.bottomAnchor).isActive = true
        //webView.load(myRequest)
    }
}
