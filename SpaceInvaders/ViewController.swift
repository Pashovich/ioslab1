//
//  ViewController.swift
//  SpaceInvaders
//
//  Created by administrator on 20.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var data: JsonData!
    let buttonWidth = CGFloat(100)
    let buttonHeight = CGFloat(40)
    let buttonsColor = UIColor(named: "Buttons")
    let textColor = UIColor(named: "Text")
    @IBOutlet weak var Results: UIButton!
    
    @objc func startGame(sender: UIButton!) {
        self.performSegue(withIdentifier: "startGameScene", sender: self)
    }
    @objc func showResults(sender: UIButton!) {
        self.performSegue(withIdentifier: "showResults", sender: self)
    }
    
    private func makeStartButton(){
        let startGameButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - self.buttonWidth/2, y: UIScreen.main.bounds.height/2 - self.buttonHeight/2 - 200, width: self.buttonWidth, height: self.buttonHeight))
        startGameButton.backgroundColor = self.buttonsColor
        startGameButton.setTitleColor(self.textColor, for: .normal)
        startGameButton.setTitle(data.startButtonLable, for: .normal)
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        self.view.addSubview(startGameButton)
    }
    private func makeResultsButton(){
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/2 - self.buttonWidth/2, y: UIScreen.main.bounds.height/2 - self.buttonHeight/2 - 100, width: self.buttonWidth, height: self.buttonHeight))
        button.backgroundColor = self.buttonsColor
        button.setTitleColor(self.textColor, for: .normal)
        button.setTitle(self.data.resultsButton, for: .normal)
        button.addTarget(self, action: #selector(showResults), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileReader = FileReader()
        data = fileReader.read(path: "data")

        self.makeStartButton()
        self.makeResultsButton()
    }

}

class GameSceneViewController : UIViewController{
    var totalPointsLabel : UILabel!
    @IBOutlet var shootGesture: UITapGestureRecognizer!
    var totalPoints : Int!
    var gameIsOn :Bool!
    var playerShipObject : PlayerShip!
    var enemyShipObjects : [EnemyShip]!
    let sideOffsetsArray = [-10,10]
    let buttonWidth = CGFloat(50)
    let buttonHeight = CGFloat(50)
    let rowsOfEnemies = 3
    let columnsOfEnemies = 4
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context:NSManagedObjectContext!
    var data : JsonData!
    let textColor = UIColor(named: "Text")
    var endGameLable : UILabel!
    
    
        
    
    weak var shipObject: UIImageView!
    
    private func initGame(){
        totalPoints = 0
        self.gameIsOn = true
        var products : [Result] = [Result]()
        let pX = UIScreen.main.bounds.width/2
        let pY = UIScreen.main.bounds.maxY
        self.enemyShipObjects = []
        self.playerShipObject = PlayerShip(imageName: "ship", viewScene : view, x:pX,y:pY)

        let n = Int(UIScreen.main.bounds.width/5)
        let m = Int(UIScreen.main.bounds.height/(2 * 5))
        let k = Int(UIScreen.main.bounds.height * 0.1)
        rowLoop:for i in 0...self.rowsOfEnemies - 1{
            columnLoop:for j in 0..<self.columnsOfEnemies{
                self.enemyShipObjects.append(EnemyShip(imageName: "enemy", viewScene: view, x: CGFloat(n * (j+1)), y: CGFloat(i*m+k)))
            }
        }
        EnemyShip.shipIndexes = Array(0...(self.rowsOfEnemies)*self.columnsOfEnemies-1)

        self.makePointsLabel()
        self.playerShipObject.setTotalPointsLabel(label: self.totalPointsLabel, data: self.data)
    
        self.makeRandomShotFromEnemy()
        self.makeEnemyShipsMove()
        self.checkState()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileReader = FileReader()
        data = fileReader.read(path: "data")
        self.makeButtons()

        self.initGame()

    }
    private func makePointsLabel(){
        let topOffset = UIScreen.main.bounds.maxY * 0.1
        self.totalPointsLabel = UILabel(frame: CGRect(x:0, y: 0, width: 300, height: 21))
        self.totalPointsLabel.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.minY + topOffset)
        self.totalPointsLabel.textAlignment = .center
        self.totalPointsLabel.textColor = UIColor(named: "Text")
        self.totalPointsLabel.text = self.data.totalPointLable + "0"
        self.view.addSubview(self.totalPointsLabel)
    }
    private func makeEndGameLable(labelText : String){
        self.endGameLable = UILabel(frame: CGRect(x:0, y: 0, width: 200, height: 21))
        self.endGameLable.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        self.endGameLable.textAlignment = .center
        self.endGameLable.text = labelText
        self.view.addSubview(self.endGameLable)
    }
    
    private func saveData(resultString: String, totalPoints: Int){
        
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Result", in: context)
        let newResult = NSManagedObject(entity: entity!, insertInto: context)
        newResult.setValue(resultString, forKey: "result")
        newResult.setValue(totalPoints, forKey: "points")
        print("Storing Data..")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
        
    }
    public func checkState(){
        DispatchQueue.global(qos: .userInteractive).async {
            while(self.gameIsOn){
                usleep(10000)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if (self.playerShipObject.isWin){
                        self.gameIsOn = false
                        self.makeEndGameLable(labelText: "WIN")
                        self.saveData(resultString: "WIN",  totalPoints: self.playerShipObject.getTotalPoints())
                        return
                    }
                    if (EnemyShip.isWin){
                        self.gameIsOn = false
                        self.makeEndGameLable(labelText: "LOST")
                        self.saveData(resultString: "LOST",  totalPoints: self.playerShipObject.getTotalPoints())
                        return
                    }
                }
            }
        }
    }
    
    private func makeButtons(){
        let xCoord = UIScreen.main.bounds.midX
        
        let yCoordMid = UIScreen.main.bounds.maxY * 0.8
        
        let xOffset = UIScreen.main.bounds.maxX * 0.3
        let buttonLeft = UIButton(frame: CGRect(x: xCoord - xOffset - self.buttonWidth/2, y: yCoordMid , width: self.buttonWidth, height: self.buttonHeight))
        buttonLeft.setTitle("Left", for: .normal)
        buttonLeft.setTitleColor(self.textColor, for: .normal)
        buttonLeft.addTarget(self, action: #selector(self.movePlayerShipLeft(sender:)), for: .touchUpInside)

        self.view.addSubview(buttonLeft)
        
        let buttonRight = UIButton(frame: CGRect(x: xCoord + xOffset - self.buttonWidth/2, y: yCoordMid, width: self.buttonWidth, height: self.buttonHeight))
        buttonRight.setTitle("Right", for: .normal)
        buttonRight.setTitleColor(self.textColor, for: .normal)
        buttonRight.addTarget(self, action: #selector(self.movePlayerShipRight(sender:)), for: .touchUpInside)

        self.view.addSubview(buttonRight)
        

        
        
    }
    @objc func movePlayerShipLeft(sender: UIButton!) {
      self.playerShipObject.moveShipLeft()
    }
    @objc func movePlayerShipRight(sender: UIButton!) {
      self.playerShipObject.moveShipRight()
    }
    @IBAction func shootAction(_ sender: Any) {
        self.shootGesture.isEnabled = false
        self.shoot()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.enablefunc), userInfo: nil, repeats: false)
    }
    @objc func enablefunc()
    {
        self.shootGesture.isEnabled = true
    }

    private func makeEnemyShipsMove(){
        let sideOffset = self.sideOffsetsArray.randomElement()
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if !self.gameIsOn{
                    return
                }
                shipsLoop: for i in 0..<self.enemyShipObjects.count{
                    self.enemyShipObjects[i].moveShip(sideOffset: sideOffset )
                }
            }
            sleep(3)
            if (self.gameIsOn){
                self.makeEnemyShipsMove()
            }
            return
        }
    }
    private func makeRandomShotFromEnemy(){
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                
                let shipIndex = EnemyShip.shipIndexes.randomElement() ?? -1
                if (shipIndex == -1){
                    return
                }
                if (self.gameIsOn){
                    self.enemyShipObjects[shipIndex].shoot(target: self.playerShipObject)
                }
                if (EnemyShip.hitPlayerShip){
                    self.gameIsOn = false
                    return
                }
            }
            sleep(4)
            if self.gameIsOn{
                self.makeRandomShotFromEnemy()
            }
            
        }
    }
    private func shoot() {
        if (self.gameIsOn){
            self.playerShipObject.shoot(target: self.enemyShipObjects)
        }
    }
}

