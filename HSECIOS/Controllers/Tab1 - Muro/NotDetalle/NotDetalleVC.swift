import UIKit

class NotDetalleVC: UIViewController {
    
    var noticia = MuroElement()
    var shouldLoad = false
    var hijo = NotDetalleTVC()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "HSEC", Images.minero)
        self.hijo = self.childViewControllers[0] as! NotDetalleTVC
        
        
    }
    
    func loadNoticia(_ noticia: MuroElement) {
        let distintos = noticia.Codigo != self.noticia.Codigo
        self.noticia = distintos ? noticia : self.noticia
        self.shouldLoad = distintos
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(shouldLoad)
        if shouldLoad {
            Rest.getDataGeneral(Routes.forNoticia(noticia.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                self.hijo.data = Dict.dataToUnit(data!)!//Dict.toNoticia(dict)
                self.hijo.tableView.reloadSections([0], with: .none)
            }, error: nil)
            Rest.getDataGeneral(Routes.forComentarios(noticia.Codigo ?? ""), false, success: {(resultValue:Any?,data:Data?) in
                let arrayComentarios: ArrayGeneral<Comentario> = Dict.dataToArray(data!)
                self.hijo.comentarios = arrayComentarios.Data//Dict.toArrayObsComentario(dict)
                self.hijo.tableView.reloadSections([1], with: .none)
            }, error: nil)
            /*Rest.getData(Routes.forNoticia(noticia.Codigo), true, vcontroller: self, success: {(dict:NSDictionary) in
                self.hijo.data = Dict.toNoticia(dict)
                self.hijo.tableView.reloadSections([0], with: .none)
            })
            Rest.getData(Routes.forComentarios(noticia.Codigo), false, vcontroller: self, success: {(dict:NSDictionary) in
                self.hijo.comentarios = Dict.toArrayObsComentario(dict)
                self.hijo.tableView.reloadSections([1], with: .none)
            })*/
        }
    }
    
}
