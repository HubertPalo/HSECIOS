import UIKit

class MuroFiltroPopUp: UIViewController {
    
    var alClickOpcion: ((_ opcion: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickOpcion(_ sender: Any) {
        self.alClickOpcion?((sender as! UIButton).tag)
        self.dismiss(animated: true, completion: nil)
    }
    
}
