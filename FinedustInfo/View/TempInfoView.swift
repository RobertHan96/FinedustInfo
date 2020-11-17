import UIKit

class TempInfoView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var maxTempTitleLabel: UILabel!
    @IBOutlet weak var maxTempValueLabel: UILabel!
    @IBOutlet weak var minTempTitleLabel: UILabel!
    @IBOutlet weak var minTempValueLabel: UILabel!
    @IBOutlet weak var humidityTitlelabel: UILabel!
    @IBOutlet weak var humidityValueLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        commonInit()
    }

    required init?(coder aCoder: NSCoder) {
        super.init(coder : aCoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("TempInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
