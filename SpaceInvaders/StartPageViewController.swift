//
//  ViewController.swift
//  SpaceInvaders
//
//  Created by Admin on 04.03.2021.
//

import UIKit
import SnapKit

class StartPageViewController: UIViewController {

    public let backgroundView = UIView()
    public let backgroundImageView = UIImageView()
    private let nameOfTheGameLabel = UILabel()
    private let topScoreLabel = UILabel()
    private let startGameButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        self.setupLayout()
    }
    
    func addSubviews() {
        self.view.addSubview(backgroundView)
        backgroundView.addSubview(backgroundImageView)
        backgroundView.addSubview(nameOfTheGameLabel)
        backgroundView.addSubview(startGameButton)
        backgroundView.addSubview(topScoreLabel)
    }
    
    func setupLayout() {
        setupBackgroundView()
        setupBackgroundImageView()
      
        setupStartGameButton()
        setupNameOfTheGameLabel()
        setupTopScoreLabel()
    }
    
    private func setupTopScoreLabel() {
        topScoreLabel.text = "Top score: \(UserDefaults.standard.integer(forKey: "topScore"))"
        topScoreLabel.font = UIFont(name: "Montserrat-Regular", size: 20)
        topScoreLabel.textColor = .white
        topScoreLabel.textAlignment = .center
        topScoreLabel.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    public func setupBackgroundView() {
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
    

    
    private func setupStartGameButton() {
        startGameButton.setTitle("Начать игру", for: .normal)
        startGameButton.backgroundColor = .red
        startGameButton.setTitleColor(.white, for: .normal)
        startGameButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 20)
        startGameButton.makeRoundedCorners(radius: 8)
        startGameButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.width.equalTo(200)
            make.center.equalToSuperview()
        }
        startGameButton.addTarget(self, action: #selector(startGameButtonPressed), for: .touchUpInside)
    }
    
    private func setupNameOfTheGameLabel() {
        nameOfTheGameLabel.text = "Space Invaders"
        nameOfTheGameLabel.font = UIFont(name: "Montserrat-Regular", size: 54)
        nameOfTheGameLabel.textColor = .white
        nameOfTheGameLabel.textAlignment = .center
        nameOfTheGameLabel.numberOfLines = 2
        nameOfTheGameLabel.snp.makeConstraints{ (make) in
            make.width.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startGameButton.snp.top).inset(-50)
        }
    }
    
    @objc func startGameButtonPressed(sender: UIButton!) {
        startGameButton.backgroundColor = .green
        let gameViewController = GameViewController()
        gameViewController.modalPresentationStyle = .fullScreen
        self.show(gameViewController, sender: self)
    }
}
 
