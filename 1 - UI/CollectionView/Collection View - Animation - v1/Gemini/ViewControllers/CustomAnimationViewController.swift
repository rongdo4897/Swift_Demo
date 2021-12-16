import UIKit
import Gemini

enum CustomAnimationType {
    case custom1
    case custom2

    fileprivate func layout(withParentView parentView: UIView) -> UICollectionViewFlowLayout {
        switch self {
        case .custom1:
            let layout = UICollectionViewPagingFlowLayout()
            layout.itemSize = CGSize(width: parentView.bounds.width - 100, height: parentView.bounds.height - 200)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            layout.minimumLineSpacing = 10
            layout.scrollDirection = .horizontal
            return layout

        case .custom2:
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 150, height: 150)
            layout.sectionInset = UIEdgeInsets(top: 15,
                                               left: (parentView.bounds.width - 150) / 2,
                                               bottom: 15,
                                               right: (parentView.bounds.width - 150) / 2)
            layout.minimumLineSpacing = 15
            layout.scrollDirection = .vertical
            return layout
        }
    }
}

final class CustomAnimationViewController: UIViewController {
    @IBOutlet private weak var collectionView: GeminiCollectionView! {
        didSet {
            let nib = UINib(nibName: cellIdentifier, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
            collectionView.delegate   = self
            collectionView.dataSource = self

            if #available(iOS 11.0, *) {
                collectionView.contentInsetAdjustmentBehavior = .never
            }
        }
    }

    private let cellIdentifier = String(describing: ImageCollectionViewCell.self)
    private let images = Resource.image.images
    private var animationType = CustomAnimationType.custom2

    static func make(animationType: CustomAnimationType) -> CustomAnimationViewController {
        let storyboard = UIStoryboard(name: "CustomAnimationViewController", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CustomAnimationViewController") as! CustomAnimationViewController
        viewController.animationType = animationType
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(toggleNavigationBarHidden(_:)))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)

        switch animationType {
        case .custom1:
            collectionView.collectionViewLayout = animationType.layout(withParentView: view)
            collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
            collectionView.gemini
                .customAnimation()
                .translation(x: 0, y: 50, z: 0)
                .rotationAngle(x: 0, y: 13, z: 0)
                .ease(.easeOutExpo)
                .shadowEffect(.fadeIn)
                .maxShadowAlpha(0.3)

        case .custom2:
            collectionView.collectionViewLayout = animationType.layout(withParentView: view)
            collectionView.gemini
                .customAnimation()
                .backgroundColor(startColor: UIColor(red: 38 / 255, green: 194 / 255, blue: 129 / 255, alpha: 1),
                                 endColor: UIColor(red: 89 / 255, green: 171 / 255, blue: 227 / 255, alpha: 1))
                .ease(.easeOutSine)
                .cornerRadius(75)
        }
    }

    @objc private func toggleNavigationBarHidden(_ gestureRecognizer: UITapGestureRecognizer) {
        let isNavigationBarHidden = navigationController?.isNavigationBarHidden ?? true
        navigationController?.setNavigationBarHidden(!isNavigationBarHidden, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension CustomAnimationViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
}

// MARK: - UICollectionViewDelegate

extension CustomAnimationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            self.collectionView.animateCell(cell)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CustomAnimationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageCollectionViewCell

        if animationType == .custom1 {
            cell.configure(with: images[indexPath.row])
        }

        self.collectionView.animateCell(cell)
        return cell
    }
}
