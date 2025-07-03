import UIKit

class ToggleButton: UIButton {

    var isOn: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    private let thumbView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.backgroundColor = .lightGray
        self.addTarget(self, action: #selector(toggleState), for: .primaryActionTriggered)

        // Thumb view setup
        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = 12
        thumbView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(thumbView)

        // Add shadow for thumb (optional for better appearance)
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOpacity = 0.2
        thumbView.layer.shadowOffset = CGSize(width: 0, height: 1)
        thumbView.layer.shadowRadius = 1

        // Initial frame
        updateAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let thumbSize = CGSize(width: 24, height: 24)
        let y = (self.bounds.height - thumbSize.height) / 2
        let x = isOn ? (self.bounds.width - thumbSize.width - 4) : 4
        thumbView.frame = CGRect(origin: CGPoint(x: x, y: y), size: thumbSize)
    }

    @objc func toggleState() {
        isOn.toggle()
        sendActions(for: .valueChanged)
        updateAppearance(animated: true)
    }

    func setToggleState(to state: Bool) {
        self.isOn = state
        updateAppearance(animated: true)
    }

    private func updateAppearance(animated: Bool = false) {
        let background = isOn ? UIColor.red : UIColor.lightGray
        let thumbX = isOn ? (self.bounds.width - thumbView.bounds.width - 4) : 4

        let updates = {
            self.backgroundColor = background
            self.thumbView.frame.origin.x = thumbX
        }

        if animated {
            UIView.animate(withDuration: 0.25, animations: updates)
        } else {
            updates()
        }
    }

    // tvOS Focus Handling
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        coordinator.addCoordinatedAnimations {
            self.layer.borderWidth = self.isFocused ? 4 : 0
            self.layer.borderColor = self.isFocused ? UIColor.red.cgColor : nil
        }
    }
}
