//
//  InfoView.swift
//  TestClientServerApp
//
//  Created by Андрей Понамарчук on 15.12.2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

class InfoView: UIView {
    @IBOutlet var infoContentView: UIView!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var infoName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InfoView", owner: self, options: nil)
        addSubview(infoContentView)
        infoContentView.frame = self.bounds
        infoContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
