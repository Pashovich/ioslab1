//
//  PlayerShip.swift
//  SpaceInvaders
//
//  Created by administrator on 23.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import Foundation
import UIKit

class PlayerShip :BaseShipObject{
    
    var shipWidth = CGFloat(50)
    var shipHeight = CGFloat(50)
    var shipObject :UIImageView!
    var view : UIView!
    let moveDistance = CGFloat(20)
    let moveDuration = 0.3
    var label : UILabel!
    var data : JsonData!
    private var totalPoints = 0
    var isWin = false
    
    init (imageName: String, viewScene: UIView, x : CGFloat, y : CGFloat){
        let image = UIImage(named: imageName)
        super.init()
        self.shipObject = UIImageView(image: image!)
        let offsetFromBottom = UIScreen.main.bounds.maxY * 0.3
        
        self.shipObject.frame = CGRect(x: x - self.shipWidth/2, y: y - offsetFromBottom, width: self.shipWidth, height: self.shipHeight)
        
        viewScene.addSubview(self.shipObject)
        self.view = viewScene
        print(UIScreen.main.bounds.minY,self.bulletHeight)
        self.moveDirection = UIScreen.main.bounds.minY - self.bulletHeight
        self.collisionBoundBorder = self.moveDirection - self.bulletHeight/2
        self.isWin = false
        self.speed = 2.0
        
    }

    public func remove(){
        self.shipObject.removeFromSuperview()
    }
    public func makeBullet(){
        self.makeBullet(object: self.shipObject)
        self.view.addSubview(self.bulletImage)
    }
    
    public func moveShipLeft(){
        self.shipObject.frame = CGRect(x: self.shipObject.frame.origin.x - 20, y: self.shipObject.frame.origin.y, width: self.shipObject.frame.width, height: self.shipObject.frame.height)
    }
    
    public func moveShipRight(){
        self.shipObject.frame = CGRect(x: self.shipObject.frame.origin.x + 20, y: self.shipObject.frame.origin.y, width: self.shipObject.frame.width, height: self.shipObject.frame.height)
    }
    private func checkIfIntersected(target :
        [EnemyShip])->Int{
        enemyLoop: for i in 0..<target.count{
            if (self.bulletImage.frame.intersects(target[i].shipObject.frame) && !target[i].shipObject.isHidden){
                return i
            }
            
        }
        return -1
    }
    public func setTotalPointsLabel(label: UILabel, data : JsonData){
        self.label = label
        self.data = data
    }
    private func updateLable(){
        self.label.text = self.data.totalPointLable + String(self.totalPoints)
    }
    public func getTotalPoints()->Int{
        return self.totalPoints
    }
    internal func shoot(target : [EnemyShip]){
        self.makeBullet()
        DispatchQueue.global(qos: .userInteractive).async {
            var untilBorder = true
            print(EnemyShip.shipIndexes.count)
            if (EnemyShip.shipIndexes.count == 1) {
                self.isWin = true
            }
            while(untilBorder){
                usleep(10000)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    
                    self.bulletImage.frame = CGRect(x: self.bulletImage.frame.origin.x, y: self.bulletImage.frame.origin.y - 20, width: self.bulletImage.frame.width, height: self.bulletImage.frame.height)
                    let index = self.checkIfIntersected(target: target)
                    if ( self.bulletImage.layer.presentation()?.frame.origin.y ?? self.bulletImage.frame.origin.y < self.collisionBoundBorder){
                        self.bulletImage.isHidden = true
                        untilBorder = false
                    }
                    if (index != -1){
                        target[index].removeFromView()
                        if let idx = EnemyShip.shipIndexes.firstIndex(of:index) {
                            EnemyShip.shipIndexes.remove(at: idx)
                            self.totalPoints += 100
                            self.updateLable()
                        }
                        self.bulletImage.isHidden = true
                        untilBorder = false
                    }
                }
            }
        }
        
    }
    override public func removeFromView(){
        self.shipObject.isHidden = true
        
    }

    
}
