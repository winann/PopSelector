//
//  WillShowPopSelector.swift
//  PopSelector
//
//  Created by Winann on 2018/8/28.
//

import UIKit

public struct ContentModel {
    public init() { }
    public var image: UIImage?
    public var title: String = ""
    public var id: String = ""
    public var scheme: String = ""
    public var disable: Bool = false
    public var tips: String = ""
    public var data: Any?
}
public protocol WillShowPopSelector {
    func showSelector(from vc: UIViewController, models: [ContentModel], countPerRow: Int, borderWidth: CGFloat, imageInsetsValue: CGFloat, callBack: ((ContentModel) -> Void)?)
}
extension WillShowPopSelector {
    public func showSelector(from vc: UIViewController, models: [ContentModel], countPerRow: Int = 2, borderWidth: CGFloat = 20, imageInsetsValue: CGFloat = 10, callBack: ((ContentModel) -> Void)?) {
        let popVC = PopSelectorViewController()
        popVC.countPerRow = countPerRow
        popVC.models = models
        popVC.borderWidth = borderWidth
        popVC.callBack = callBack
        popVC.modalTransitionStyle = .crossDissolve
        popVC.modalPresentationStyle = .overCurrentContext
        vc.present(popVC, animated: true)
    }
}
