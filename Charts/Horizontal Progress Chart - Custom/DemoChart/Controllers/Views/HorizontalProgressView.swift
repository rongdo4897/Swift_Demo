//
//  HorizontalProgressBar.swift
//  DemoChart
//
//  Created by Hoang Lam on 27/05/2022.
//

import Foundation
import UIKit

enum HorizontalProgressViewSize: Int {
    case normal = 0
}

@objc
protocol HorizontalProgressViewDataSource: AnyObject {
    func numberOfSections(in progressView: HorizontalProgressView) -> Int
    func progressView(_ progressView: HorizontalProgressView,
                      viewForSection section: Int) -> HorizontalProgressViewSectionItem
}

@objc
protocol HorizontalProgressViewDelegate: AnyObject {
    @objc optional func progressView(_ progressView: HorizontalProgressView, didTapSectionAt index: Int)
}

@IBDesignable
class HorizontalProgressView: UIView {
    var progressView: UIView!
    private var heightConstraint: NSLayoutConstraint?
    private var centerXBottomLabelConstraint: NSLayoutConstraint!
    private var trailingBottomLabelConstraint: NSLayoutConstraint!
    private var leadingBottomLabelConstraint: NSLayoutConstraint!
    
    lazy var trackView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var dotView: UIView!
    private var imageView: UIImageView!
    
    private var topLabel = UILabel()
    private var bottomLabel = UILabel()
    
    var dashedLineColor: UIColor = .white
    
    @IBInspectable var size: Int = HorizontalProgressViewSize.normal.rawValue {
        didSet {
            self.updateSize()
        }
    }
    
    @IBInspectable public var trackInset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var trackBackgroundColor: UIColor? = .clear {
        didSet {
            trackView.backgroundColor = trackBackgroundColor
        }
    }
    
    weak var dataSource: HorizontalProgressViewDataSource? {
        didSet {
            self.reloadData()
        }
    }
    
    weak var delegate: HorizontalProgressViewDelegate?
    
    var progressViewSections: [HorizontalProgressViewSectionItem: Int] = [:]
    
    public var totalProgress: Float {
        return currentProgress.reduce(0) { $0 + $1 }
    }
    
    private var numberOfSections: Int = 0
    private var currentProgress: [Float] = []
    
    private var layoutProvider: HorizontalProgressViewLayoutProvidable = HorizontalProgressViewLayoutProvider.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.updateSize()
        self.setupProgressView()
    }
    
    private func updateSize() {
        if let heightConstraint = self.heightConstraint {
            self.removeConstraint(heightConstraint)
        }
        switch self.size {
        case HorizontalProgressViewSize.normal.rawValue:
            self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 76)
            self.addConstraint(self.heightConstraint!)
        default:
            self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 76)
            self.addConstraint(self.heightConstraint!)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        trackView.frame = layoutProvider.trackFrame(self)
        layoutSections()
        updateCornerRadius()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.dotView.makeDashedBorderLine(color: self.dashedLineColor, strokeLength: 2, gapLength: 2, width: 1, orientation: .vertical)
        
        reLayoutBottomlabel()
    }
}

// MARK: - Progress View
extension HorizontalProgressView {
    private func setupProgressView() {
        progressView = UIView()
        self.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        self.updateBackgroundProgressColor(color: .white)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            progressView.topAnchor.constraint(equalTo: self.topAnchor, constant: 19),
            progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -27)
        ])
        
        progressView.addSubview(trackView)
    }
    
    private func updateBackgroundProgressColor(color: UIColor) {
        self.progressView.backgroundColor = color
    }
}

// MARK: - Label
extension HorizontalProgressView {
    private func setupTopLabel() {
        self.addSubview(topLabel)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -4)
        ])
    }
    
    private func setupBottomLabel(pointView: UIImageView) {
        self.addSubview(bottomLabel)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        centerXBottomLabelConstraint = bottomLabel.centerXAnchor.constraint(equalTo: pointView.centerXAnchor)
        trailingBottomLabelConstraint = bottomLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        leadingBottomLabelConstraint = bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor)
                
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: pointView.bottomAnchor, constant: 5),
            centerXBottomLabelConstraint,
            trailingBottomLabelConstraint,
            leadingBottomLabelConstraint
        ])
        
        centerXBottomLabelConstraint.isActive = true
        trailingBottomLabelConstraint.isActive = false
        leadingBottomLabelConstraint.isActive = false
    }
    
    private func reLayoutBottomlabel() {
        let totalWidthBottomLabel = bottomLabel.frame.origin.x + bottomLabel.frame.size.width
        let widthSuperView = self.frame.size.width
        
        if totalWidthBottomLabel >= widthSuperView {
            centerXBottomLabelConstraint.isActive = false
            trailingBottomLabelConstraint.isActive = true
            leadingBottomLabelConstraint.isActive = false
        } else if bottomLabel.frame.origin.x <= 0 {
            centerXBottomLabelConstraint.isActive = false
            trailingBottomLabelConstraint.isActive = false
            leadingBottomLabelConstraint.isActive = true
        }
    }
    
    func setTextTopLabel(text: String) {
        guard text.range(of: "万円") != nil else {
            topLabel.text = text
            topLabel.textColor = .black
            topLabel.font = UIFont(name: "HiraginoSans-W3", size: 10) ?? UIFont.systemFont(ofSize: 10)
            return
        }
        
        // Cắt chuỗi dựa theo giới hạn trên và dưới của 1 contain
        let u = text.startIndex
        let h = text.range(of: "万円")!.lowerBound // Giới hạn trên của phạm vi cần lấy
                
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.colorFromHexString(hex: "888888"), subString: "万円")
        attributedText.apply(font: UIFont(name: "HiraginoSans-W3", size: 9) ?? .systemFont(ofSize: 9), subString: "万円")
        attributedText.apply(color: .black, subString: String(text[u ..< h]))
        attributedText.apply(font: UIFont(name: "HiraginoSans-W3", size: 10) ?? .systemFont(ofSize: 10), subString: String(text[u ..< h]))
        
        topLabel.attributedText = attributedText
    }
    
    func setTextBottomLabel(text: String) {
        guard text.range(of: "万円") != nil , text.range(of: "現在の残高") != nil else {
            bottomLabel.text = text
            bottomLabel.textColor = .black
            bottomLabel.font = UIFont(name: "HiraginoSans-W3", size: 11) ?? UIFont.systemFont(ofSize: 11)
            return
        }
        
        // Cắt chuỗi dựa theo giới hạn trên và dưới của 1 contain
        let u = text.startIndex
        let r = text.range(of: "現在の残高")!.upperBound
        let h = text.range(of: "万円")!.lowerBound
                
        let attributedText = NSMutableAttributedString.getAttributedString(fromString: text)
        attributedText.apply(color: UIColor.colorFromHexString(hex: "727272"), subString: "万円")
        attributedText.apply(font: UIFont(name: "HiraginoSans-W3", size: 10) ?? .systemFont(ofSize: 10), subString: "万円")
        attributedText.apply(color: .black, subString: String(text[u ..< r]))
        attributedText.apply(font: UIFont(name: "HiraginoSans-W3", size: 11) ?? .systemFont(ofSize: 11), subString: String(text[u ..< r]))
        attributedText.apply(color: .black, subString: String(text[r ..< h]))
        attributedText.apply(font: UIFont(name: "KulimPark-Regular", size: 16) ?? .systemFont(ofSize: 16), subString: String(text[r ..< h]))
        
        bottomLabel.attributedText = attributedText
    }
}

// MARK: - Image
extension HorizontalProgressView {
    private func setupImage(view: HorizontalProgressViewSectionItem) {
        imageView = UIImageView()
        imageView.image = UIImage(named: "point")
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 6),
            imageView.heightAnchor.constraint(equalToConstant: 8),
            imageView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -3),
            imageView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
    }
}

// MARK: - Dot View
extension HorizontalProgressView {
    private func setupDotView() {
        dotView = UIView()
        progressView.addSubview(dotView)
        dotView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dotView.centerXAnchor.constraint(equalTo: trackView.centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            dotView.heightAnchor.constraint(equalTo: trackView.heightAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - Action
extension HorizontalProgressView {
    public func reloadData() {
        guard let dataSource = dataSource else { return }
        numberOfSections = dataSource.numberOfSections(in: self)
        
        progressViewSections.keys.forEach { $0.removeFromSuperview() }
        progressViewSections.removeAll()
        currentProgress.removeAll()
        
        for index in 0..<numberOfSections {
            configureSection(withDataSource: dataSource, index, numberOfSections)
        }
        
        self.setupDotView()
    }
    
    private func configureSection(withDataSource dataSource: HorizontalProgressViewDataSource,
                                  _ section: Int, _ numberOfSections: Int) {
        let bar = dataSource.progressView(self, viewForSection: section)
        bar.delegate = self
        progressViewSections[bar] = section
        trackView.addSubview(bar)
        currentProgress.insert(0, at: section)
        
        if section == (numberOfSections - 1) {
            self.setupImage(view: bar)
            self.setupTopLabel()
            self.setupBottomLabel(pointView: imageView)
        }
    }
    
    public func progress(forSection section: Int) -> Float {
        return currentProgress[section]
    }
    
    public func setProgress(section: Int, to progress: Float) {
        currentProgress[section] = max(0, min(progress, 1 - totalProgress + currentProgress[section]))
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    public func resetProgress() {
        for section in 0..<progressViewSections.count {
            setProgress(section: section, to: 0)
        }
    }
    
    private func layoutSections() {
        for (section, index) in progressViewSections {
            section.frame = layoutProvider.sectionFrame(self, section: index)
            trackView.bringSubviewToFront(section)
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = layoutProvider.cornerRadius(self)
        trackView.layer.cornerRadius = layoutProvider.trackCornerRadius(self)
    }
}

//MARK: - HorizontalProgressViewSectionItemDelegate
extension HorizontalProgressView: HorizontalProgressViewSectionItemDelegate {
    func didTapSection(_ section: HorizontalProgressViewSectionItem) {
        if let index = progressViewSections[section] {
            delegate?.progressView?(self, didTapSectionAt: index)
        }
    }
}
