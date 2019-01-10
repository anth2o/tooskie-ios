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

    @IBAction func goFacebook(_ sender: Any) {
        openUrl(urlString: "https://risibank.fr/cache/stickers/d120/12055-full.png")
    }
    
    @IBAction func goInstagram(_ sender: Any) {
        openUrl(urlString: "https://static.boredpanda.com/blog/wp-content/uploads/2016/12/funny-donald-trump-queen-elizabeth-photohop-trumpqueen-32-584a764a887b7__700.jpg")
    }
    
    @IBAction func goLinkedin(_ sender: Any) {
        openUrl(urlString: "https://img-9gag-fun.9cache.com/photo/aA1Ovxg_460sv.mp4")
    }

    @IBAction func goYoutube(_ sender: Any) {
        openUrl(urlString: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    }
    
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
