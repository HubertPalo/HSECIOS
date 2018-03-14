import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func clickEnLogin(_ sender: Any) {
        Utils.bloquearPantalla(self)
    }
    
}

