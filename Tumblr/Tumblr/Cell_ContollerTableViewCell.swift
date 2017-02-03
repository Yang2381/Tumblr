//
//  Cell_ContollerTableViewCell.swift
//  Tumblr
//
//  Created by Yawen & Szu Kai Yang on 2/2/2017.
//  Copyright © 2017 YangSzu Kai. All rights reserved.
//

import UIKit


class Cell_ContollerTableViewCell: UITableViewCell {
    @IBOutlet weak var PicTitle: UILabel!

    @IBOutlet weak var Avartar: UIImageView!
    
    @IBOutlet weak var Pictures_View: UIImageView!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
