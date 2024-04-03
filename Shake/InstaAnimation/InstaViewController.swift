import UIKit
import Combine

class InstaViewController: UIViewController, UIScrollViewDelegate {

    enum Constants {
        static let piByTwoo = (CGFloat.pi / 2)
        static let facesCount = 4
    }
    var cubeView = [StoryView]()
    var viewModel: InstaViewModel!
    lazy var closeButton: UIButton = createCloseButton()

    let transformLayer = CATransformLayer()
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    var index = 0
    lazy var size = {
        return view.frame
    }()
    private var cancelBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        for i in 0...3 {
            var url: String?
            if i < viewModel.users.count {
                url = viewModel.users[i].stories.first?.imageURL
            }

            let view = createView(url)
            self.view.addSubview(view)
            cubeView.append(view)
        }
        turnCarousel()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(turn))
        view.addGestureRecognizer(panGesture)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)

        setupCloseButton()

        setupBindings()
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            closeButton.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    func setupBindings() {
        viewModel.$currentStory
            .dropFirst()
            .sink { [weak self] in
                guard let self else { return }
                let imageView = self.cubeView[self.index]
                imageView.updateImage(url: $0)

                // update image with url
            }
            .store(in: &cancelBag)
    }

    func createView(_ url: String?) -> StoryView {
        let imageView = StoryView(url: url)
        imageView.frame = CGRect(x: 0,
                                 y: 20,
                                 width: size.width,
                                 height: size.height - 20)

        imageView.backgroundColor = .black
        return imageView
    }

    func turnCarousel() {
        //try view
        let segmentForView = 2*CGFloat.pi / CGFloat(Constants.facesCount)
        var angleOffset = currentAngle

        let storyViews = view.subviews.filter { view in
            let isUiButton = (view as? UIButton) != nil
            return !isUiButton
        }
        for view in storyViews {
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, angleOffset, 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, size.width / 2)
            view.layer.transform = transform

            angleOffset += segmentForView
        }
    }

    @objc func turn(recognizer: UIPanGestureRecognizer) {
        let xOffset = recognizer.translation(in: view).x
        if recognizer.state == .began {
            currentOffset = 0
        }
        let xDiff = xOffset * 0.005 - currentOffset
        currentOffset += xDiff
        currentAngle += xDiff
print(currentAngle)
        if (index == 0 && currentAngle > 0)
            || (index == Constants.facesCount - 1 && currentAngle < 0) {
            return
        }
        turnCarousel()

        if recognizer.state == .ended {
            let currentItemAngle = currentAngle - (-CGFloat(index) * Constants.piByTwoo)
            if currentItemAngle < -CGFloat.pi / 4 {
                nextIndex()
            } else if currentItemAngle > CGFloat.pi / 4 {
                previousIndex()
            } else {
                currentAngle = -CGFloat(index) * (CGFloat.pi * 2 / 4)
            }
            startAnimation()
        }
    }

    @objc func tap(recognizer: UIPanGestureRecognizer) {
        var shouldAnimate = false
        if recognizer.location(in: view).x < view.frame.width / 2
            && viewModel.userIndex > 0 {
            previousStoryIndex()
            shouldAnimate = true
        } else if recognizer.location(in: view).x >= view.frame.width / 2
                    && viewModel.userIndex < viewModel.users.count - 1 {
            nextStoryIndex()
            shouldAnimate = true
        }
        if shouldAnimate {
            startAnimation()
        }
    }
    
    func createCloseButton() -> UIButton {
        let button = UIButton(type: .system)
        let closeImage = UIImage(systemName: "multiply.circle.fill")
        button.setImage(closeImage, for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 10000
        return button
    }

}

private extension InstaViewController {

    func nextStoryIndex() {
        viewModel.nextStory()
    }

    func previousStoryIndex() {
        viewModel.previousStory()
    }


    func nextIndex() {
        index = (index + 1) % 4
        viewModel.nextIndex()
    }

    func previousIndex() {
        index = (index - 1) % 4
        viewModel.previousIndex()
    }

    func startAnimation() {
        let storyViews = view.subviews.filter { view in
            let isUiButton = (view as? UIButton) != nil
            return !isUiButton
        }

        currentAngle = -CGFloat(index) * (CGFloat.pi * 2 / 4)
        for (index, view) in storyViews.enumerated() {
            view.layer.zPosition = 0
            if index == self.index {
                view.layer.zPosition = 1500
            }
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.turnCarousel()
        }
    }
}
