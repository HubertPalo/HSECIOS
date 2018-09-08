import UIKit

class FichaFiltroVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func loadPersona(persona: Persona){
        let navVCs = self.navigationController!.viewControllers
        let fichaVC = navVCs[navVCs.count - 2] as! FichaPersonalVC
        fichaVC.printData("asdsadadasdasdsa")
    }
}
