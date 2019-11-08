//
//  ViewController.swift
//  NavCog
//
//  Created by Harsh Agarwal on 11/7/19.
//  Copyright © 2019 Vivek Roy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = logo.image
        logo.image = nil
        logo.image = image
        
        
    }


}

