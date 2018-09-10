import UIKit

class InsDetallePVCTab4: UIViewController {
    
    var inspeccion = MuroElement()
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? InsDetalleVC {
            padre.selectTab(3)
        }
        let hijo = self.childViewControllers[0] as! ComentariosVC
        hijo.codigo = inspeccion.Codigo ?? ""
        hijo.loadComentarios(inspeccion.Codigo ?? "")
        hijo.forzarActualizacionDeComentarios = {
            hijo.loadComentarios(self.inspeccion.Codigo ?? "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

