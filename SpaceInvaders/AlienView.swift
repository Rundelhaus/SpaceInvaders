//
//  AlienView.swift
//  SpaceInvaders
//
//  Created by Admin on 01.04.2021.
//

import UIKit

class AlienView: UIView {
    let alienImageView = UIImageView()
    init(){
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupAlienImageView()
    }
    
    private func setupView() {
        snp.makeConstraints { (make) in
            make.size.equalTo(40)
        }
    }
    
    private func setupAlienImageView() {
        addSubview(alienImageView)
        alienImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        alienImageView.image = UIImage(named: "enemyShip")
        alienImageView.contentMode = .scaleAspectFit
    }
}
