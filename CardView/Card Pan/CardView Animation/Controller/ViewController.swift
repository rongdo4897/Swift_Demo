//
//  ViewController.swift
//  CardView Animation
//
//  Created by Hoang Tung Lam on 2/26/21.
//

import UIKit

enum CardState {
    case expanded // Mở rộng
    case collapsed // Thu gọn
}

class ViewController: UIViewController {
    @IBOutlet weak var lblLocation: UILabel!
        
    var cardBottomViewController: CardViewBottomController!
    var cardTopViewController: CardViewTopController!
    var cardLeftViewController: CardViewLeftController!
    var cardRightViewController: CardViewRightController!
    
    // Một đối tượng thực hiện một số hiệu ứng hình ảnh phức tạp.
    var visualEffectView: UIVisualEffectView!
    
    let cardBottomHeight: CGFloat = UIScreen.main.bounds.height - 65 // Chiều cao lớn nhất view
    let cardBottomHandleAreaHeight: CGFloat = 65 // Chiều cao nhỏ nhất của card
    let cardTopHeight: CGFloat = UIScreen.main.bounds.height - 65 // Chiều cao lớn nhất view
    let cardTopHandleAreaHeight: CGFloat = 65 // Chiều cao nhỏ nhất của card
    let cardLeftWidth: CGFloat = UIScreen.main.bounds.width - 65 // Chiều rộng lớn nhất view
    let cardLeftHandleAreaWidth: CGFloat = 65 // Chiều rộng nhỏ nhất của card
    let cardRightWidth: CGFloat = UIScreen.main.bounds.width - 65 // Chiều rộng lớn nhất view
    let cardRightHandleAreaWidth: CGFloat = 65 // Chiều rộng nhỏ nhất của card
    
    var cardBottomVisiable = false // Kiểm tra xem card có thể hiện hết không
    var cardTopVisiable = false // Kiểm tra xem card có thể hiện hết không
    var cardLeftVisiable = false // Kiểm tra xem card có thể hiện hết không
    var cardRightVisiable = false // Kiểm tra xem card có thể hiện hết không
    
    var nextStateBottom: CardState {
        return cardBottomVisiable ? .collapsed : .expanded
    }
    var nextStateTop: CardState {
        return cardTopVisiable ? .collapsed : .expanded
    }
    var nextStateLeft: CardState {
        return cardLeftVisiable ? .collapsed : .expanded
    }
    var nextStateRight: CardState {
        return cardRightVisiable ? .collapsed : .expanded
    }
    
    // tạo 1 mảng các lớp tạo hoạt ảnh cho các thay đổi đối với dạng xem và cho phép sửa đổi động của các hoạt ảnh đó.
    var bottomRunningAnimations = [UIViewPropertyAnimator]()
    var topRunningAnimations = [UIViewPropertyAnimator]()
    var leftRunningAnimations = [UIViewPropertyAnimator]()
    var rightRunningAnimations = [UIViewPropertyAnimator]()
    
    // Chiều cao của hoạt ảnh khi gián đoạn (kéo lên xuống)
    var bottomAnimationProgressWhenInterrupted: CGFloat = 0
    var topAnimationProgressWhenInterrupted: CGFloat = 0
    var leftAnimationProgressWhenInterrupted: CGFloat = 0
    var rightAnimationProgressWhenInterrupted: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponents()
    }
    
    func initComponents() {
        lblLocation.startShimmeringAnimation(animationSpeed: 1.4, direction: .topLeftToBottomRight, repeatCount: 100000000)
        
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = view.frame // Khung hình của view hiệu ứng
        view.addSubview(visualEffectView)
        
        setUpCardBottom()
        setUpCardTop()
        setUpCardLeft()
        setUpCardRight()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Card Bottom
extension ViewController {
    func setUpCardBottom() {
        cardBottomViewController = CardViewBottomController(nibName: "CardViewBottomController", bundle: nil)
        self.addChild(cardBottomViewController) // add controller con vào cha
        self.view.addSubview(cardBottomViewController.view) // add view của con vào view cha
        // Khung hình của cardView
        cardBottomViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardBottomHandleAreaHeight, width: self.view.bounds.width, height: cardBottomHeight)
        cardBottomViewController.view.clipsToBounds = true
        
        // Bắt sự kiện chạm và kéo card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardBottomTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardBottomPan(recognizer:)))
        cardBottomViewController.viewHandleArea.addGestureRecognizer(tapGesture)
        cardBottomViewController.viewHandleArea.addGestureRecognizer(panGesture)
        
        // delegate
        cardBottomViewController.delegate = self
        
        visualEffectView.isHidden = true
    }
    
    // Chạm card
    @objc func handleCardBottomTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededBottom(state: nextStateBottom, duration: 0.9)
        default:
            break
        }
    }
    
    // Kéo card
    @objc func handleCardBottomPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // bắt đầu chuyển tiếp
            startInteractiveTransitionBottom(state: nextStateBottom, duration: 0.9)
        case .changed:
            // Cập nhật chuyển tiếp
            let translation = recognizer.translation(in: self.cardBottomViewController.viewHandleArea)
            var fractionCompleted = translation.y / cardBottomHeight
            // nếu cardVisiable = true (Kéo lên) -> Chỉ số dương , còn lại là âm
            fractionCompleted = cardBottomVisiable ? fractionCompleted : -fractionCompleted
            updateInteractiveTransitionBottom(fractionCompleted: fractionCompleted)
        case .ended:
            // Kết thúc chuyển tiếp
            continueInteractiveTransitionBottom()
        default:
            break
        }
    }
    
    // tạo hiệu ứng Chuyển đổi nếu cần
    func animateTransitionIfNeededBottom(state: CardState, duration: TimeInterval) {
        if bottomRunningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardBottomViewController.view.frame.origin.y = self.view.frame.height - self.cardBottomHeight
                    self.cardTopViewController.view.alpha = 0
                    self.cardLeftViewController.view.alpha = 0
                    self.cardRightViewController.view.alpha = 0
                case .collapsed:
                    self.cardBottomViewController.view.frame.origin.y = self.view.frame.height - self.cardBottomHandleAreaHeight
                    self.cardTopViewController.view.alpha = 1
                    self.cardLeftViewController.view.alpha = 1
                    self.cardRightViewController.view.alpha = 1
                }
            }
            
            frameAnimation.addCompletion { (_) in
                self.cardBottomVisiable = !self.cardBottomVisiable
                self.bottomRunningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            bottomRunningAnimations.append(frameAnimation)
            
            // Bo góc view
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardBottomViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardBottomViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            bottomRunningAnimations.append(cornerRadiusAnimator)
            
            //
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    self.visualEffectView.isHidden = false
                case .collapsed:
                    self.visualEffectView.effect = nil
                    self.visualEffectView.isHidden = true
                }
            }
            
            blurAnimator.startAnimation()
            bottomRunningAnimations.append(blurAnimator)
        }
    }
    
    // Hàm bắt đầu khi tương tác
    func startInteractiveTransitionBottom(state: CardState, duration: TimeInterval) {
        if bottomRunningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeededBottom(state: state, duration: duration)
        }
        
        for animator in bottomRunningAnimations {
            animator.pauseAnimation()
            bottomAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Hàm cập nhật khi tương tác
    func updateInteractiveTransitionBottom(fractionCompleted: CGFloat) {
        for animator in bottomRunningAnimations {
            animator.fractionComplete = fractionCompleted + bottomAnimationProgressWhenInterrupted
        }
    }
    
    // Hàm kết thúc khi tương tác
    func continueInteractiveTransitionBottom() {
        for animator in bottomRunningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

//MARK: - Card Top
extension ViewController {
    func setUpCardTop() {
        cardTopViewController = CardViewTopController(nibName: "CardViewTopController", bundle: nil)
        self.addChild(cardTopViewController) // add controller con vào cha
        self.view.addSubview(cardTopViewController.view) // add view của con vào view cha
        // Khung hình của cardView
        cardTopViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: cardTopHandleAreaHeight)
        cardTopViewController.view.clipsToBounds = true
        
        // Bắt sự kiện chạm và kéo card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardTopTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardTopPan(recognizer:)))
        cardTopViewController.viewHandleArea.addGestureRecognizer(tapGesture)
        cardTopViewController.viewHandleArea.addGestureRecognizer(panGesture)
        
        // delegate
        cardTopViewController.delegate = self
        
        visualEffectView.isHidden = true
    }
    
    // Chạm card
    @objc func handleCardTopTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededTop(state: nextStateTop, duration: 0.9)
        default:
            break
        }
    }
    
    // Kéo card
    @objc func handleCardTopPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // bắt đầu chuyển tiếp
            startInteractiveTransitionTop(state: nextStateTop, duration: 0.9)
        case .changed:
            // Cập nhật chuyển tiếp
            let translation = recognizer.translation(in: self.cardTopViewController.viewHandleArea)
            var fractionCompleted = translation.y / cardTopHeight
            // nếu cardVisiable = true (Kéo lên) -> Chỉ số dương , còn lại là âm
            fractionCompleted = cardTopVisiable ? -fractionCompleted : fractionCompleted
            updateInteractiveTransitionTop(fractionCompleted: fractionCompleted)
        case .ended:
            // Kết thúc chuyển tiếp
            continueInteractiveTransitionTop()
        default:
            break
        }
    }
    
    // tạo hiệu ứng Chuyển đổi nếu cần
    func animateTransitionIfNeededTop(state: CardState, duration: TimeInterval) {
        if topRunningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
//                    self.cardTopViewController.view.frame.origin.y = self.view.frame.height - self.cardTopHandleAreaHeight
                    self.cardTopViewController.view.frame.size.height = self.cardTopHeight
                    self.cardBottomViewController.view.alpha = 0
                    self.cardLeftViewController.view.alpha = 0
                    self.cardRightViewController.view.alpha = 0
                case .collapsed:
//                    self.cardTopViewController.view.frame.origin.y = 0
                    self.cardTopViewController.view.frame.size.height = self.cardTopHandleAreaHeight
                    self.cardBottomViewController.view.alpha = 1
                    self.cardLeftViewController.view.alpha = 1
                    self.cardRightViewController.view.alpha = 1
                }
            }
            
            frameAnimation.addCompletion { (_) in
                self.cardTopVisiable = !self.cardTopVisiable
                self.topRunningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            topRunningAnimations.append(frameAnimation)
            
            // Bo góc view
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardTopViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardTopViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            topRunningAnimations.append(cornerRadiusAnimator)
            
            //
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    self.visualEffectView.isHidden = false
                case .collapsed:
                    self.visualEffectView.effect = nil
                    self.visualEffectView.isHidden = true
                }
            }
            
            blurAnimator.startAnimation()
            topRunningAnimations.append(blurAnimator)
        }
    }
    
    // Hàm bắt đầu khi tương tác
    func startInteractiveTransitionTop(state: CardState, duration: TimeInterval) {
        if topRunningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeededTop(state: state, duration: duration)
        }
        
        for animator in topRunningAnimations {
            animator.pauseAnimation()
            topAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Hàm cập nhật khi tương tác
    func updateInteractiveTransitionTop(fractionCompleted: CGFloat) {
        for animator in topRunningAnimations {
            animator.fractionComplete = fractionCompleted + topAnimationProgressWhenInterrupted
        }
    }
    
    // Hàm cập nhật khi tương tác
    func continueInteractiveTransitionTop() {
        for animator in topRunningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

//MARK: - Card Left
extension ViewController {
    func setUpCardLeft() {
        cardLeftViewController = CardViewLeftController(nibName: "CardViewLeftController", bundle: nil)
        self.addChild(cardLeftViewController) // add controller con vào cha
        self.view.addSubview(cardLeftViewController.view) // add view của con vào view cha
        // Khung hình của cardView
        cardLeftViewController.view.frame = CGRect(x: 0, y: cardTopHandleAreaHeight, width: cardLeftHandleAreaWidth, height: view.bounds.height - cardTopHandleAreaHeight - cardBottomHandleAreaHeight)
        cardLeftViewController.view.clipsToBounds = true
        
        // Bắt sự kiện chạm và kéo card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardLeftTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardLeftPan(recognizer:)))
        cardLeftViewController.viewHandleArea.addGestureRecognizer(tapGesture)
        cardLeftViewController.viewHandleArea.addGestureRecognizer(panGesture)
        
        // delegate
        cardLeftViewController.delegate = self
        
        visualEffectView.isHidden = true
    }
    
    // Chạm card
    @objc func handleCardLeftTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededLeft(state: nextStateLeft, duration: 0.9)
        default:
            break
        }
    }
    
    // Kéo card
    @objc func handleCardLeftPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // bắt đầu chuyển tiếp
            startInteractiveTransitionLeft(state: nextStateLeft, duration: 0.9)
        case .changed:
            // Cập nhật chuyển tiếp
            let translation = recognizer.translation(in: self.cardLeftViewController.viewHandleArea)
            var fractionCompleted = translation.x / cardLeftWidth
            // nếu cardVisiable = true (Kéo lên) -> Chỉ số dương , còn lại là âm
            fractionCompleted = cardLeftVisiable ? -fractionCompleted : fractionCompleted
            updateInteractiveTransitionLeft(fractionCompleted: fractionCompleted)
        case .ended:
            // Kết thúc chuyển tiếp
            continueInteractiveTransitionLeft()
        default:
            break
        }
    }
    
    // tạo hiệu ứng Chuyển đổi nếu cần
    func animateTransitionIfNeededLeft(state: CardState, duration: TimeInterval) {
        if leftRunningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardLeftViewController.view.frame.size.width = self.cardLeftWidth
                    self.cardTopViewController.view.alpha = 0
                    self.cardBottomViewController.view.alpha = 0
                    self.cardRightViewController.view.alpha = 0
                case .collapsed:
                    self.cardLeftViewController.view.frame.size.width = self.cardLeftHandleAreaWidth
                    self.cardTopViewController.view.alpha = 1
                    self.cardBottomViewController.view.alpha = 1
                    self.cardRightViewController.view.alpha = 1
                }
            }
            
            frameAnimation.addCompletion { (_) in
                self.cardLeftVisiable = !self.cardLeftVisiable
                self.leftRunningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            leftRunningAnimations.append(frameAnimation)
            
            // Bo góc view
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardLeftViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardLeftViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            leftRunningAnimations.append(cornerRadiusAnimator)
            
            //
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    self.visualEffectView.isHidden = false
                case .collapsed:
                    self.visualEffectView.effect = nil
                    self.visualEffectView.isHidden = true
                }
            }
            
            blurAnimator.startAnimation()
            leftRunningAnimations.append(blurAnimator)
        }
    }
    
    // Hàm bắt đầu khi tương tác
    func startInteractiveTransitionLeft(state: CardState, duration: TimeInterval) {
        if leftRunningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeededLeft(state: state, duration: duration)
        }
        
        for animator in leftRunningAnimations {
            animator.pauseAnimation()
            leftAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Hàm cập nhật khi tương tác
    func updateInteractiveTransitionLeft(fractionCompleted: CGFloat) {
        for animator in leftRunningAnimations {
            animator.fractionComplete = fractionCompleted + leftAnimationProgressWhenInterrupted
        }
    }
    
    // Hàm cập nhật khi tương tác
    func continueInteractiveTransitionLeft() {
        for animator in leftRunningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

//MARK: - Card Rights
extension ViewController {
    func setUpCardRight() {
        cardRightViewController = CardViewRightController(nibName: "CardViewRightController", bundle: nil)
        self.addChild(cardRightViewController) // add controller con vào cha
        self.view.addSubview(cardRightViewController.view) // add view của con vào view cha
        // Khung hình của cardView
        cardRightViewController.view.frame = CGRect(x: view.bounds.width - cardRightHandleAreaWidth, y: cardTopHandleAreaHeight, width: cardRightWidth, height: view.bounds.height - cardTopHandleAreaHeight - cardBottomHandleAreaHeight)
        cardRightViewController.view.clipsToBounds = true
        
        // Bắt sự kiện chạm và kéo card
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardRightTap(recognizer:)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardRightPan(recognizer:)))
        cardRightViewController.viewHandleArea.addGestureRecognizer(tapGesture)
        cardRightViewController.viewHandleArea.addGestureRecognizer(panGesture)
        
        // delegate
        cardRightViewController.delegate = self
        
        visualEffectView.isHidden = true
    }
    
    // Chạm card
    @objc func handleCardRightTap(recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            animateTransitionIfNeededRight(state: nextStateRight, duration: 0.9)
        default:
            break
        }
    }
    
    // Kéo card
    @objc func handleCardRightPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // bắt đầu chuyển tiếp
            startInteractiveTransitionRight(state: nextStateRight, duration: 0.9)
        case .changed:
            // Cập nhật chuyển tiếp
            let translation = recognizer.translation(in: self.cardRightViewController.viewHandleArea)
            var fractionCompleted = translation.x / cardRightWidth
            // nếu cardVisiable = true (Kéo lên) -> Chỉ số dương , còn lại là âm
            fractionCompleted = cardRightVisiable ? fractionCompleted : -fractionCompleted
            updateInteractiveTransitionRight(fractionCompleted: fractionCompleted)
        case .ended:
            // Kết thúc chuyển tiếp
            continueInteractiveTransitionRight()
        default:
            break
        }
    }
    
    // tạo hiệu ứng Chuyển đổi nếu cần
    func animateTransitionIfNeededRight(state: CardState, duration: TimeInterval) {
        if rightRunningAnimations.isEmpty {
            let frameAnimation = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardRightViewController.view.frame.origin.x = self.view.frame.width - self.cardRightWidth
                    self.cardTopViewController.view.alpha = 0
                    self.cardLeftViewController.view.alpha = 0
                    self.cardBottomViewController.view.alpha = 0
                case .collapsed:
                    self.cardRightViewController.view.frame.origin.x = self.view.frame.width - self.cardRightHandleAreaWidth
                    self.cardTopViewController.view.alpha = 1
                    self.cardLeftViewController.view.alpha = 1
                    self.cardBottomViewController.view.alpha = 1
                }
            }
            
            frameAnimation.addCompletion { (_) in
                self.cardRightVisiable = !self.cardRightVisiable
                self.rightRunningAnimations.removeAll()
            }
            
            frameAnimation.startAnimation()
            rightRunningAnimations.append(frameAnimation)
            
            // Bo góc view
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardRightViewController.view.layer.cornerRadius = 12
                case .collapsed:
                    self.cardRightViewController.view.layer.cornerRadius = 0
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            rightRunningAnimations.append(cornerRadiusAnimator)
            
            //
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    self.visualEffectView.isHidden = false
                case .collapsed:
                    self.visualEffectView.effect = nil
                    self.visualEffectView.isHidden = true
                }
            }
            
            blurAnimator.startAnimation()
            rightRunningAnimations.append(blurAnimator)
        }
    }
    
    // Hàm bắt đầu khi tương tác
    func startInteractiveTransitionRight(state: CardState, duration: TimeInterval) {
        if rightRunningAnimations.isEmpty {
            // run animations
            animateTransitionIfNeededRight(state: state, duration: duration)
        }
        
        for animator in rightRunningAnimations {
            animator.pauseAnimation()
            rightAnimationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Hàm cập nhật khi tương tác
    func updateInteractiveTransitionRight(fractionCompleted: CGFloat) {
        for animator in rightRunningAnimations {
            animator.fractionComplete = fractionCompleted + rightAnimationProgressWhenInterrupted
        }
    }
    
    // Hàm cập nhật khi tương tác
    func continueInteractiveTransitionRight() {
        for animator in rightRunningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

extension ViewController: CardViewControllerDelegate {
    func didSelectCell(location: String) {
        lblLocation.text = location
    }
}
