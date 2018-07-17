import UIKit

class Celda1Texto: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
}

class Celda2Texto: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
}

class Celda3Texto: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var texto3: UILabel!
}

class Celda3Texto1Boton: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var texto3: UILabel!
    @IBOutlet weak var boton: UIButton!
}

class Celda2Texto1View: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var view: UIView!
}

class Celda2Texto1Boton: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    @IBOutlet weak var boton: UIButton!
}

class Celda1Texto1Boton: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var boton: UIButton!
}

class Celda1Boton: UITableViewCell {
    @IBOutlet weak var boton: UIButton!
}

class Celda1Texto2Boton: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var boton1: UIButton!
    @IBOutlet weak var boton2: UIButton!
}

class Celda1Texto1InputText: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var inputTexto: UITextField!
}

class Celda1Texto1TextView: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var textView: UITextView!
}

class Celda1Texto1View: UITableViewCell {
    @IBOutlet weak var texto: UILabel!
    @IBOutlet weak var view: UIView!
}

class Celda1View: UITableViewCell {
    @IBOutlet weak var view: UIView!
}

class CeldaGaleria: UITableViewCell  {
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var play1: UIImageView!
    @IBOutlet weak var play2: UIImageView!
    @IBOutlet weak var boton1: UIButton!
    @IBOutlet weak var boton2: UIButton!
    @IBOutlet weak var botonX1: UIButton!
    @IBOutlet weak var botonX2: UIButton!
    @IBOutlet weak var viewX1: UIView!
    @IBOutlet weak var viewX2: UIView!
    
    override func prepareForReuse() {
        self.imagen1.image = Images.blank
        self.imagen2.image = Images.blank
    }
}

class CeldaDocumento: UITableViewCell {
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var tamanho: UILabel!
    @IBOutlet weak var viewX: UIView!
    @IBOutlet weak var botonDescargar: UIButton!
}

class CeldaComentario: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var comentario: UILabel!
}
