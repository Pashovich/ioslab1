//
//  BaseShipObject.swift
//  SpaceInvaders
//
//  Created by administrator on 23.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import Foundation
import UIKit
class BaseShipObject {
    var bulletImageName = "bullet"
    var image : UIImage!
    var bulletImage : UIImageView!
    
    let bulletWidth = CGFloat(10)
    let bulletHeight = CGFloat(10)
    var collisionBoundBorder : CGFloat
    var moveDirection : CGFloat
    
    var speed = 3.0

    
    init(){
        self.image = UIImage(named: self.bulletImageName)
        self.collisionBoundBorder = 0
        self.moveDirection = 0
    }
    
    internal func makeBullet(object:UIImageView){
        self.bulletImage = UIImageView(image: self.image)
        
        self.bulletImage.frame.origin.x = object.center.x
        self.bulletImage.frame.origin.y = object.center.y
        self.bulletImage.frame.size.width = self.bulletWidth
        self.bulletImage.frame.size.height = self.bulletHeight
    }
    public func removeFromView(){
        
    }
    
}
