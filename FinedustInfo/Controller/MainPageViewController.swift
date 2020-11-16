import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    lazy var viewContorllerList : [UIViewController] = {
        let finedustInfoVC = MainViewController()
        let weatherVC = WeatherViewController()
        return [weatherVC, finedustInfoVC]
    }()
    let pageControll = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = viewContorllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension MainPageViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let vcIndex = viewContorllerList.index(of : viewController) else{
                return nil
            }
        let previousIndex = vcIndex-1
            guard previousIndex >= 0 else {
                return nil
            }
            return viewContorllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewContorllerList.index(of : viewController) else{
            return nil
        }
        let afterIndex = vcIndex+1
        guard viewContorllerList.count != afterIndex else {
            return nil
        }
        guard viewContorllerList.count >= afterIndex else {
            return nil
        }
        return viewContorllerList[afterIndex]
    }
}
