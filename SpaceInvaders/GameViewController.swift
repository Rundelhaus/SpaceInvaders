//
//  GameViewController.swift
//  SpaceInvaders
//
//  Created by Admin on 15.03.2021.
//

import Foundation
import SnapKit
import CoreMotion

final class GameViewController: UIViewController {
    
    var motion = CMMotionManager()
    
    var timer: Timer!
    var timer2Secs: Timer!
    
    let centerX = UIScreen.main.bounds.maxX / 2
    var coordinate: Double = Double(UIScreen.main.bounds.maxX / 2)
    let playerY = UIScreen.main.bounds.maxY - 100
    public var player = UIImageView(image: #imageLiteral(resourceName: "playerShip"))
    private let backgroundView = UIView()
    private var backgroundImageView = UIImageView()
    private let endGameButton = UIButton(type: .system)
    
    var aliensArmy = [UIImageView]()
    let oneAlienPrice = 10
    let alienNumber = 18
    
    let scoreText = UILabel()
    var score: Int = 0
    
    let maxLazers = 3
    var lazers = [UIImageView]()
    var currentLasers = 0
    
    var direction = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        self.setupLayout()
        startGame()
    }
    
    private func addSubviews() {
        self.view.addSubview(backgroundView)
        self.backgroundView.addSubview(backgroundImageView)
        self.backgroundView.addSubview(scoreText)
    }
    
    private func setupBackgroundView() {
        backgroundView.snp.makeConstraints { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
    }
    
    public func setupBackgroundImageView() {
        backgroundImageView.image = #imageLiteral(resourceName: "Image")
        backgroundImageView.snp.makeConstraints() { (make) in
            make.bottom.top.left.right.equalToSuperview()
        }
    }
    
    private func setupScoreLabel() {
        scoreText.text = "YOUR SCORE: \(score)"
        scoreText.font = UIFont(name: "Montserrat-Regular", size: 12)
        scoreText.textColor = .white
        scoreText.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupAliensArmy() {
        let sX = Int(UIScreen.main.bounds.width/8)
        let sY = Int(UIScreen.main.bounds.height/10)
        let shipWidth = sX
        let shipHeight = shipWidth/2
        var count = 0
        for i in 1...3 {
            for j in 1...6{
                let enemy = UIImageView(image: #imageLiteral(resourceName: "enemyShip"))
                enemy.frame = CGRect(x: sX*j, y: sY*i, width: shipWidth, height: shipHeight)
                aliensArmy.append(enemy)
                aliensArmy[count].isHidden = false
                self.view.addSubview(aliensArmy[count])
                count = count+1

            }
            
        }
            
    }
    
    private func setupLazerView() {
        let lazer = UIImageView(image: #imageLiteral(resourceName: "bullet"))
            lazer.frame = CGRect(x: player.frame.midX, y: player.frame.minY-20, width: 10, height: 20)
            lazer.center = CGPoint(x: player.center.x, y: player.center.y-35)
            lazers.append(lazer)
            backgroundImageView.addSubview(lazer)
    }
    
    private func setupLayout() {
        setupBackgroundView()
        setupBackgroundImageView()
        setupAliensArmy()
        setupScoreLabel()
    }
    
    private func setupEndGameButton() {
        endGameButton.setTitle("Закончить игру", for: .normal)
        endGameButton.backgroundColor = .green
        endGameButton.setTitleColor(.white, for: .normal)
        endGameButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
        endGameButton.makeRoundedCorners(radius: 8)
        backgroundView.addSubview(endGameButton)
        endGameButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        endGameButton.addTarget(self, action: #selector(endGameButtonPressed), for: .touchUpInside)
    }
    
    private func startGame() {
        
        player.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
        player.center = CGPoint(x: centerX, y: playerY)
        self.view.addSubview(player)
        motion.startAccelerometerUpdates()
        setupLazerView()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer2Secs = Timer.scheduledTimer(timeInterval: 2.2, target: self, selector: #selector(update2Secs), userInfo: nil, repeats: true)
    }
    
    private func gameOver() {
        timer?.invalidate()
        timer2Secs?.invalidate()
        setupEndGameButton()
        
        var topScore = UserDefaults.standard.integer(forKey: "topScore")
        if topScore < self.score {
            topScore = self.score
            UserDefaults.standard.setValue(topScore, forKey: "topScore")
        }
    }
    
    
    @objc func update() {
        updatePlayerMovement()
        updateLazersMovement()
        updateAliensMovement()
    }
    
    @objc func update2Secs() {
        setupLazerView()
    }
    
    @objc func updateAliensMovement() {
        var step:CGFloat
        for alien in aliensArmy {
            if (direction) { step = -1 } else { step = 1 }
            alien.frame = CGRect(x: alien.frame.minX+step, y: alien.frame.minY+0.2, width: alien.frame.width, height: alien.frame.height)
            if (alien.frame.maxY >= player.frame.minY) {
                gameOver()
            }
            switch direction {
            case true:
                if (alien.frame.minX < CGFloat(UIScreen.main.bounds.minX)) {
                    direction = false
                }
            default:
                if (alien.frame.maxX > CGFloat(UIScreen.main.bounds.maxX)) {
                    direction = true
                }
            }
        }
    }
    
    @objc func endGameButtonPressed(sender: UIButton!) {
        endGameButton.backgroundColor = .green
        let startPageViewController = StartPageViewController()
        startPageViewController.modalPresentationStyle = .fullScreen
        self.show(startPageViewController, sender: self)
    }
    
    @objc func updateLazersMovement() {
        for lazer in lazers {
            lazer.frame = CGRect(x: lazer.frame.minX, y: lazer.frame.minY-3, width: 10, height: 20)
            checkCollitionAliens(lazer: lazer)
            checkLazerOut(lazer: lazer)
        }
    }
    
    @objc func updatePlayerMovement() {
        if let acceleroMeterData = motion.accelerometerData {
            if acceleroMeterData.acceleration.x > 0 {
                if coordinate > Double(UIScreen.main.bounds.maxX) - 30 {
                    coordinate -= 3
                }
                if acceleroMeterData.acceleration.x > 0.1 {
                    coordinate += 2
                    player.frame = CGRect(x: coordinate, y: Double(playerY), width: 30, height: 50)
                } else {
                    coordinate += 1
                    player.frame = CGRect(x: coordinate, y: Double(playerY), width: 30, height: 50)
                }
            } else {
                if coordinate < 0 {
                    coordinate += 3
                }
                if acceleroMeterData.acceleration.x < (-0.1) {
                    coordinate -= 2
                    player.frame = CGRect(x: coordinate, y: Double(playerY), width: 30, height: 50)
                }
                coordinate -= 1
                player.frame = CGRect(x: coordinate, y: Double(playerY), width: 30, height: 50)
            }
        }
    }
    
    @objc func checkCollitionAliens(lazer: UIImageView) {
        for alien in aliensArmy {
            if (alien.frame.intersects(lazer.frame) && alien.isHidden == false) {
                if let index = lazers.firstIndex(where: {$0 == lazer}) {
                    lazers.remove(at: index)
                }
                lazer.removeFromSuperview()
                alien.isHidden = true
                score += oneAlienPrice
                if(score >= oneAlienPrice * 18) {
                    gameOver()
                }
                scoreText.text = "YOUR SCORE: \(score)"
            }
        }
    }
    
    @objc func checkLazerOut(lazer: UIImageView) {
        if (lazer.frame.maxY < UIScreen.main.bounds.minY) {
            if let index = lazers.firstIndex(where: {$0 == lazer}) {
                lazers.remove(at: index)
            }
            lazer.removeFromSuperview()
        }
    }

    
}
