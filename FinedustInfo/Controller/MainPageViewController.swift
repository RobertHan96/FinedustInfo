import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    lazy var viewContorllerList : [UIViewController] = {
        let finedustInfoVC = FinedustViewController()
        let weatherVC = WeatherViewController()
        return [weatherVC, finedustInfoVC]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = viewContorllerList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        MainPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
}

extension MainPageViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewContorllerList.firstIndex(of : viewController) else{
                return nil
            }
        let previousIndex = vcIndex-1
            guard previousIndex >= 0 else {
                return nil
            }
            return viewContorllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewContorllerList.firstIndex(of : viewController) else{
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed == true{
            let currentTag = pageViewController.viewControllers!.first!.view.tag
            print("현재 보고 있는 페이지는 \(currentTag+1) 번째 입니다.")            
        }
    }

}
