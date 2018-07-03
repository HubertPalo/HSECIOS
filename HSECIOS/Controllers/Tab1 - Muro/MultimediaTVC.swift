import UIKit

/*class MultimediaTVC: UITableViewController {
    
    var multimedia: [Multimedia] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multimedia.count/2 + multimedia.count%2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! MultimediaTVCell

        let unit1 = multimedia[indexPath.row*2]
        Images.loadImagePreviewFromCode(unit1.Correlativo , celda.imagen1)
        /*if let imagen = Images.imagenes[unit1.Descripcion] {
            celda.imagen1.image = imagen
        } else {
            Images.get(unit1.Descripcion, tableView, indexPath.row)
        }*/
        
        if indexPath.row*2 + 1 != multimedia.count {
            let unit2 = multimedia[indexPath.row*2 + 1]
            Images.loadImagePreviewFromCode(unit2.Correlativo, celda.imagen2)
            /*if let imagen = Images.imagenes[unit2.Descripcion] {
                celda.imagen2.image = imagen
            } else {
                Images.get(unit2.Descripcion, tableView, indexPath.row)
            }*/
        } else {
            celda.extraview.isHidden = true
        }
        return celda
    }
    
    @IBAction func clickEnImagen1(_ sender: Any) {
        let celda = (sender as AnyObject).superview??.superview?.superview?.superview as! MultimediaTVCell
        let indice = tableView.indexPath(for: celda)!.row * 2
        // Images.showGallery(codigo: multimedia[indice].Descripcion, list: multimedia, index: indice, viewController: self)
    }
    
    @IBAction func clickEnImagen2(_ sender: Any) {
        let celda = (sender as AnyObject).superview??.superview?.superview?.superview as! MultimediaTVCell
        let indice = tableView.indexPath(for: celda)!.row * 2 + 1
        // Images.showGallery(codigo: multimedia[indice].Descripcion, list: multimedia, index: indice, viewController: self)
    }
    
}

class MultimediaTVCell: UITableViewCell {
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var extraview: UIView!
}*/
