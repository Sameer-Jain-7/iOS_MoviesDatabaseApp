import UIKit

@IBDesignable
class CustomRatingView: UIView {
    private var ratingLabel: UILabel!
    private var ratingValue: UILabel!

    @IBInspectable
    var source: String = "Rating" {
        didSet {
            ratingLabel.text = source
        }
    }

    @IBInspectable
    var value: String = "0.0" {
        didSet {
            ratingValue.text = value
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        ratingLabel = UILabel()
        ratingLabel.text = source
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 16)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false

        ratingValue = UILabel()
        ratingValue.text = value
        ratingValue.font = UIFont.systemFont(ofSize: 16)
        ratingValue.translatesAutoresizingMaskIntoConstraints = false

        addSubview(ratingLabel)
        addSubview(ratingValue)

        NSLayoutConstraint.activate([
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            ratingValue.leadingAnchor.constraint(equalTo: ratingLabel.trailingAnchor, constant: 8),
            ratingValue.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingValue.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
}
