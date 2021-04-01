//
//  RoundAwardView.swift
//  RoundAwardView
//
//  Created by Suren Gevorkyan on 4/1/21.
//

import UIKit

@IBDesignable
class RoundAwardView: UIView {
    @IBInspectable var disabledLightColor: UIColor = .lightGray
    @IBInspectable var disabledDarkColor: UIColor = .darkGray
    @IBInspectable var lightColor: UIColor = .systemBlue
    @IBInspectable var darkColor: UIColor = .blue
    
    @IBInspectable var topText: String = ""
    @IBInspectable var bottomText: String = ""
    
    @IBInspectable var textColor: UIColor = .white
    @IBInspectable var disabledTextColor: UIColor = .white
    
    @IBInspectable var icon: UIImage?
    @IBInspectable var isEnabled: Bool = true
    @IBInspectable var lockIcon: UIImage? = UIImage(systemName: "lock.fill")
    
    private var areIconViewsSetup = false
    private lazy var iconImageView = UIImageView()
    private lazy var lockIconImageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupIconImageView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupIconImageView()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = self.bounds.size
        let darkColor = isEnabled ? self.darkColor : disabledDarkColor
        let lightColor = isEnabled ? self.lightColor : disabledLightColor
        let textColor = isEnabled ? self.textColor : disabledTextColor
        
        context.translateBy(x: size.width / 2, y: size.height / 2)
        context.scaleBy(x: 1, y: -1)
        
        let arcWidth: CGFloat = size.width * 0.05
        let radius = (size.width / 2) * 0.8
        
        let backgroundPath = UIBezierPath(arcCenter: .zero,
                                 radius: 0,
                                 startAngle: 0,
                                 endAngle: 2 * .pi,
                                 clockwise: false)
        backgroundPath.lineCapStyle = .round
        backgroundPath.lineWidth = size.width
        lightColor.setStroke()
        backgroundPath.stroke()
        
        let font = UIFont.systemFont(ofSize: size.width * 0.15, weight: .heavy)
        
        let topTextAngles = centerArcPerpendicular(text: topText, context: context, radius: radius, angle: .pi / 2, color: textColor, font: font, clockwise: true)
        let bottomTextAngles = centerArcPerpendicular(text: bottomText, context: context, radius: radius, angle: CGFloat(-Double.pi / 2), color: textColor, font: font, clockwise: false)
        
        let path = UIBezierPath(arcCenter: .zero,
                                 radius: radius,
                                 startAngle: bottomTextAngles.startPosition - 0.1,
                                 endAngle: topTextAngles.startPosition + 0.1,
                                 clockwise: false)
        path.lineCapStyle = .round
        path.lineWidth = arcWidth
        darkColor.setStroke()
        path.stroke()
        
        let rightPath = UIBezierPath(arcCenter: .zero,
                                 radius: radius,
                                 startAngle: topTextAngles.endPosition - 0.1,
                                 endAngle: bottomTextAngles.endPosition + 0.1,
                                 clockwise: false)
        rightPath.lineCapStyle = .round
        rightPath.lineWidth = arcWidth
        darkColor.setStroke()
        rightPath.stroke()
        
        let centerPath = UIBezierPath(arcCenter: .zero,
                                 radius: 0,
                                 startAngle: 0,
                                 endAngle: 2 * .pi,
                                 clockwise: false)
        centerPath.lineCapStyle = .round
        centerPath.lineWidth = size.width * 0.6
        darkColor.setStroke()
        centerPath.stroke()
        
        
        if let icon = icon {
            let centerCircleWidth = size.width * 0.6
            let iconWidth = min(centerCircleWidth * 0.6, icon.size.width)
            let iconHeight = min(centerCircleWidth * 0.6, icon.size.height)
            
            iconImageView.image = icon
            iconImageView.frame.size = CGSize(width: iconWidth, height: iconHeight)
            iconImageView.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        } else {
            iconImageView.image = nil
        }
        
        if let lockIcon = lockIcon, !isEnabled {
            let centerCircleWidth = size.width * 0.6
            let iconWidth = min(centerCircleWidth * 0.6, lockIcon.size.width)
            let iconHeight = min(centerCircleWidth * 0.6, lockIcon.size.height)
            
            lockIconImageView.image = lockIcon
            lockIconImageView.frame.size = CGSize(width: iconWidth, height: iconHeight)
            lockIconImageView.center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        } else {
            lockIconImageView.image = nil
        }
    }
    
    private func setupIconImageView() {
        if !areIconViewsSetup {
            iconImageView.frame = .zero
            iconImageView.center = center
            lockIconImageView.frame = .zero
            lockIconImageView.center = center
            lockIconImageView.tintColor = .white
            
            addSubview(iconImageView)
            addSubview(lockIconImageView)
            
            areIconViewsSetup = true
        }
    }
}

