//
//  CustomSegmentedControl.swift
//  Movies_Database_App
//
//  Created by 1916782 on 15/07/24.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: CustomSegmentedControl, didSelectIndex index: Int)
}

@IBDesignable
class CustomSegmentedControl: UISegmentedControl {

    weak var delegate: CustomSegmentedControlDelegate?

    private var buttons = [UIButton]()
    private var selector: UIView!

    var selectedIndex: Int = 0 {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var buttonTexts: [String] = [] {
        didSet {
            setupButtons()
        }
    }

    @IBInspectable
    var selectorColor: UIColor = .blue {
        didSet {
            selector.backgroundColor = selectorColor
        }
    }

    @IBInspectable
    var textColor: UIColor = .black {
        didSet {
            updateView()
        }
    }

    @IBInspectable
    var selectorTextColor: UIColor = .white {
        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        createSelector()
        setupButtons()
    }

    private func createSelector() {
        selector = UIView(frame: CGRect(x: 0, y: 0, width: frame.width / CGFloat(buttonTexts.count), height: frame.height))
        selector.layer.cornerRadius = frame.height / 2
        selector.backgroundColor = selectorColor
        addSubview(selector)
    }

    private func setupButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for (index, title) in buttonTexts.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
            button.tag = index
            buttons.append(button)
            addSubview(button)
        }
        updateView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard !frame.width.isNaN, !frame.height.isNaN, !selector.frame.width.isNaN else {
            print("Invalid frame values detected.")
            return
        }

        let buttonWidth = frame.width / CGFloat(buttonTexts.count)

        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: buttonWidth * CGFloat(index), y: 0, width: buttonWidth, height: frame.height)
        }

        selector.frame.size.width = frame.width / CGFloat(buttonTexts.count)
    }




    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        delegate?.segmentedControl(self, didSelectIndex: selectedIndex)
    }

    private func updateView() {
        for (index, button) in buttons.enumerated() {
            button.setTitleColor(index == selectedIndex ? selectorTextColor : textColor, for: .normal)
        }

        let selectorStartPosition = frame.width / CGFloat(buttonTexts.count) * CGFloat(selectedIndex)
        UIView.animate(withDuration: 0.3) {
            self.selector.frame.origin.x = selectorStartPosition
        }
    }
}
