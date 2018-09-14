//
//  PopSelectorViewController.swift
//  PopSelector
//
//  Created by Winann on 2018/8/27.
//

import UIKit

class PopSelectorViewController: UIViewController {

    var borderWidth: CGFloat = 0
    let bottomBGView: UIView = UIView()
    let contentBGView: UIView = UIView()
    var countPerRow: Int = 2
    var imageInsetsValue: CGFloat = 0
    var callBack: ((ContentModel) -> Void)?
    var models: [ContentModel]?
    var contents: [ContentView] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layoutBGView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutContentView()
    }
    private func layoutContentView() {
        guard let datas = models else { return }
        for subview in contentBGView.subviews {
            subview.removeFromSuperview()
        }
        contents = datas.map { (model) -> ContentView in
            let view = ContentView(frame: CGRect.zero, image: model.image ?? UIImage(), title: model.title, tips: model.tips, disable: model.disable)
            return view
        }
        for (i, contentView) in contents.enumerated() {
            let width = self.view.bounds.width / 2 - borderWidth
            var tempFrame = CGRect.zero
            if 0 == i {
                tempFrame = CGRect(x: 0, y: contentBGView.bounds.maxY - width, width: width, height: width)
            } else {
                if i % countPerRow == 0 {
                    tempFrame = CGRect(x: 0, y: contents[i - 1].bounds.minY - width, width: width, height: width)
                } else {
                    tempFrame = CGRect(x: contents[i - 1].frame.maxX + 1, y: contents[i - 1].frame.minY, width: width, height: width)
                }
            }
            contentView.tag = 1000 + i
            contentView.frame = tempFrame
            contentView.click = { [weak self] index in
                guard let `self` = self else { return }
                guard let datas = self.models, datas.count > index else { return }
                self.hidden(for: index)
                self.dismiss(animated: true) { [weak self] in
                    self?.callBack?(datas[index])
                }
            }
            contentBGView.addSubview(contentView)
        }
        animation()
    }
    
    private func animation() {
        for i in 0..<contents.count {
            let content = contents[i]
            let showAnimation = CASpringAnimation(keyPath: "position.y")
            showAnimation.fromValue = content.layer.position.y + content.bounds.width / 3
            showAnimation.toValue = content.layer.position.y
            showAnimation.mass = 1
            showAnimation.initialVelocity = 20
            showAnimation.duration = 0.3
            showAnimation.stiffness = 500
            content.layer.add(showAnimation, forKey: "show")
        }
    }
    
    private func hidden(for i: Int) {
        guard i < contents.count else { return }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.5
//        opacityAnimation.fillMode = kCAFillModeForwards
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 10
        opacityAnimation.duration = 0.5
        contents[i].layer.add(opacityAnimation, forKey: "opacity")
        contents[i].layer.add(scaleAnimation, forKey: "scale")
    }
    
    private func layoutBGView() {
        view.addSubview(bottomBGView)
        view.addSubview(contentBGView)
        bottomBGView.translatesAutoresizingMaskIntoConstraints = false
        contentBGView.translatesAutoresizingMaskIntoConstraints = false
        /// bottom bg view
        let bottomLeading = bottomBGView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        let bottomTrailing = bottomBGView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        if #available(iOS 11.0, *) {
            let bottomBottom = bottomBGView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            view.addConstraint(bottomBottom)
        } else {
            let bottomBottom = bottomBGView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            view.addConstraint(bottomBottom)
        }
        let bottomHeight = bottomBGView.heightAnchor.constraint(equalToConstant: 75)
        view.addConstraints([bottomLeading, bottomTrailing, bottomHeight])

        /// content bg View
        let contentLeading = contentBGView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: borderWidth)
        let contentTrailing = contentBGView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: borderWidth)
        let contentBottom = contentBGView.bottomAnchor.constraint(equalTo: bottomBGView.topAnchor, constant: 0)
        if #available(iOS 11.0, *) {
            let contentTop = contentBGView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
            view.addConstraint(contentTop)
        } else {
            // Fallback on earlier versions
            let contentTop = contentBGView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
            view.addConstraint(contentTop)
        }
        view.addConstraints([contentLeading, contentTrailing, contentBottom])

        let cancelBtn = UIButton(type: .custom)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.setImage(BundleProvider.image("退出"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        bottomBGView.addSubview(cancelBtn)
        let btnLeading = cancelBtn.leadingAnchor.constraint(equalTo: bottomBGView.leadingAnchor)
        let btnTrailing = cancelBtn.trailingAnchor.constraint(equalTo: bottomBGView.trailingAnchor)
        let btnBottom = cancelBtn.bottomAnchor.constraint(equalTo: bottomBGView.bottomAnchor)
        let btnTop = cancelBtn.topAnchor.constraint(equalTo: bottomBGView.topAnchor)
        bottomBGView.addConstraints([btnLeading, btnTrailing, btnBottom, btnTop])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backAction))
        contentBGView.addGestureRecognizer(tap)
    }

    @objc private func backAction() {
        dismiss(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
