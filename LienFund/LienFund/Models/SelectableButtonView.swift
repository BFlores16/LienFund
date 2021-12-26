//
//  SelectableButtonView.swift
//  LienFund
//
//  Created by Brando Flores on 12/25/21.
//

import UIKit

class SelectableButtonView: UIView {
    
    @IBOutlet weak var frameOutline: UIView!
    let nibName = "SelectableButtonView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        
        frameOutline.layer.cornerRadius = 10
        frameOutline.layer.shadowColor = UIColor.black.cgColor
        frameOutline.layer.shadowOpacity = 0.4
        frameOutline.layer.shadowRadius = 4.0
        frameOutline.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
