//
//  BuildingPanel.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 09/01/2019.
//  Copyright © 2019 Antoine Hoorelbeke. All rights reserved.
//

import UIKit
class BuildingPanel: UIView {
    
    let nibName = "BuildingPanel"
    var contentView: UIView?
//    @IBAction func goFacebook(_ sender: Any) {
//        openUrl(urlString: "http://img.over-blog-kiwi.com/0/87/19/67/20161023/ob_587fbc_7776583435-comment-cuisiner-un-poulet.jpg")
//    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
