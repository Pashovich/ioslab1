//
//  EnemyShip.swift
//  SpaceInvaders
//
//  Created by administrator on 23.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import Foundation
import UIKit

class EnemyShip : BaseShipObject {
    var shipWidth = CGFloat(75)
    var shipHeight = CGFloat(75)
    var shipObject :UIImageView!
    var view : UIView!
    static var shipIndexes : [Int]!=[]
    static var enenyShipBullet : UIImageView!
    static var collisionBorder_ = CGFloat(0)
    static var moveDirection_ = CGFloat(0)
    static var hitPlayerShip = false
    static var isWin = false
    static var canShoot = true
        
    init (imageName: String, viewScene: UIView,x: CGFloat, y:CGFloat){
        let image = UIImage(named: imageName)
        super.init()
        self.shipObject = UIImageView(image: image!)
        let offsetFromTop = UIScreen.main.bounds.maxY * 0.01
        
        self.shipObject.frame = CGRect(x: x - self.shipWidth/2, y: y - offsetFromTop, width: self.shipWidth, height: self.shipHeight)
        
        viewScene.addSubview(self.shipObject)
        self.view = viewScene
        EnemyShip.moveDirection_ = UIScreen.main.bounds.maxY + self.bulletHeight
        EnemyShip.collisionBorder_ = EnemyShip.moveDirection_ - self.bulletHeight/2
        self.speed = 3
    }
    public func remove(){
        self.shipObject.removeFromSuperview()
    }
    public func makeBullet(){
        self.makeBullet(object: self.shipObject)
        EnemyShip.enenyShipBullet = self.bulletImage
        self.view.addSubview(EnemyShip.enenyShipBullet)
    }
    
    public func moveShipLeft(){
        UIView.animate(withDuration: 0.5, animations: {self.shipObject.frame.origin.x-=10})
    }
    
    public func moveShipRight(){
         UIView.animate(withDuration: 1, animations: {self.shipObject.frame.origin.x+=10})
    }
    private func checkIfIntersected(target :
        PlayerShip)->Bool{
        if (EnemyShip.enenyShipBullet.frame.intersects(target.shipObject.frame) && !target.shipObject.isHidden){
            return true
        }
            
        
        return false
    }
    
    public func moveShip(sideOffset : Int? = nil){
        let offset = sideOffset ?? Int(0)
        self.shipObject.frame = CGRect(x: self.shipObject.frame.origin.x + CGFloat(offset), y : self.shipObject.frame.origin.y + 10, width: self.shipObject.frame.width, height: self.shipObject.frame.height)
    }
    public func shoot(target : PlayerShip){
        if !EnemyShip.canShoot{
            return
        }
        self.makeBullet()
        DispatchQueue.global(qos: .userInteractive).async {
            var untilBorder = true
            while(untilBorder){
                usleep(50000)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.bulletImage.frame = CGRect(x: EnemyShip.enenyShipBullet.frame.origin.x, y: EnemyShip.enenyShipBullet.frame.origin.y + 20, width: EnemyShip.enenyShipBullet.frame.width, height: EnemyShip.enenyShipBullet.frame.height)
                    let colided = self.checkIfIntersected(target: target)
                    if (EnemyShip.enenyShipBullet.frame.origin.y > EnemyShip.collisionBorder_){
                        EnemyShip.enenyShipBullet.isHidden = true
                        untilBorder = false
                    }
                    if (colided){
                        target.removeFromView()
                        EnemyShip.isWin = true
                        EnemyShip.enenyShipBullet.isHidden = true
                        untilBorder = false
                        EnemyShip.hitPlayerShip = true
                    }
                }
            }
        }
    }
    override public func removeFromView(){
        self.shipObject.isHidden = true
    }
}
