import UIKit

class NotDetallePVCTab1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? NotDetalleVC {
            padre.selectTab(0)
        }
        Helper.getData(Routes.forNoticia(Utils.selectedObsCode), false, vcontroller: self, success: {(dict: NSDictionary) in
            let noticia = Dict.toNoticia(dict)
            let hijo = self.childViewControllers[0] as! NoticiaWebVC
            hijo.noticia = noticia
            hijo.loadNoticia(noticia: noticia)
        })
    }
    
}
