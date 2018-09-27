//
//  ContentView.swift
//  PopSelector
//
//  Created by Winann on 2018/8/28.
//

import UIKit

class ContentView: UIView {
    let iconImageView: UIImageView
    let titleLable: UILabel
    var imageInsetsValue: CGFloat = 0
    var tips: String = ""
    var disable: Bool = false
    var click: ((Int)->Void)?
    override var frame: CGRect {
        didSet {
            configFrame()
        }
    }
    override init(frame: CGRect) {
        iconImageView = UIImageView()
        titleLable = UILabel()
        super.init(frame: frame)
    }
    convenience init(frame: CGRect, image: UIImage, title: String, tips: String = "", disable: Bool = false) {
        self.init(frame: frame)
        iconImageView.image = image
        titleLable.text = title + "\n" + tips
        titleLable.numberOfLines = 2
        self.tips = tips
        self.disable = disable
        layoutContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configFrame() {
        let iconFrame = CGRect(x: 0, y: imageInsetsValue, width: bounds.width, height: bounds.height / 3 * 2 - imageInsetsValue)
        iconImageView.frame = iconFrame
        
        let titleFrame = CGRect(x: 0, y: iconFrame.maxY, width: bounds.width, height: bounds.height / 3)
        titleLable.frame = titleFrame
    }
    private func layoutContent() {
        configFrame()
        iconImageView.contentMode = .scaleAspectFit
        titleLable.font = UIFont.systemFont(ofSize: 15)
        titleLable.textColor = UIColor(red: 63 / 255.0, green: 57 / 255.0, blue: 81 / 255.0, alpha: 1)
        titleLable.textAlignment = .center
        if disable {
            titleLable.textColor = UIColor(red: 166 / 255.0, green: 179 / 255.0, blue: 197 / 255.0, alpha: 1)
        }
        
        if !tips.isEmpty {
            let attrStr = NSMutableAttributedString(string: titleLable.text ?? "")
            attrStr.addAttributes([NSAttributedString.Key.foregroundColor: titleLable.textColor], range: NSRange(location: 0, length: titleLable.text?.count ?? 0))
            var location = 0
            if let text = titleLable.text, !text.isEmpty {
                location = text.count - tips.count
            }
            attrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange(location: location, length: tips.count))
            titleLable.attributedText = attrStr
        }
        addSubview(iconImageView)
        addSubview(titleLable)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapSelf))
        addGestureRecognizer(tap)
    }
    
    @objc private func tapSelf() {
        guard !disable else { return }
        click?(tag - 1000)
    }
}
