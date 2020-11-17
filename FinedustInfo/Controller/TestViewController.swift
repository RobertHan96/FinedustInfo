import UIKit
import Then
import SnapKit
class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .purple
        view.addSubview(testTitle)
        testTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.greaterThanOrEqualTo(self.view.snp.right).offset(20)
        }
    }
    
    let testTitle = UILabel().then {
        $0.text = "Test Page"
        $0.adjustsFontSizeToFitWidth = true
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .black
    }
    
}
