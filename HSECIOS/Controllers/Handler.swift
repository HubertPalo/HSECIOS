import UIKit

class Handler: UIViewController {
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segments.addTarget(self, action: #selector(segmentClicked(segment:)), for: .valueChanged)
        segments.addTarget(self, action: #selector(segmentClicked(segment:)), for: .touchUpInside)
    }
    
    @objc func segmentClicked(segment: UISegmentedControl) {
        let slider = self.childViewControllers[0] as! SliderMenu1
        slider.presentViewAt(segment.selectedSegmentIndex)
    }
    
    
}
