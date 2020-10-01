//
//  UIView+fromNib().swift
//  MovieBrowser
//
//  Created by Anton Skrypnik on 01.10.2020.
//

import UIKit

extension UIView {
    
    class func fromNib() -> Self {
        let nib = UINib(nibName: String(describing: self), bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        return views.first as! Self
    }
    
}
