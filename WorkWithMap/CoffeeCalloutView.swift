//
//  CoffeeCalloutView.swift
//  WorkWithMap
//
//  Created by Сергей Голенко on 01.02.2021.
//

import UIKit

class CoffeeCalloutView: UIView {
    
    private var annotation : CoffeeAnnotation!
    
    
    init(annotation:CoffeeAnnotation,frame: CGRect = CGRect.zero){
        super.init(frame: frame)
        self.annotation = annotation
        self.frame = frame
        configure()
    }
    
    func add(to view:UIView){
        view.addSubview(self)
        self.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -5).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
     private func configure(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.backgroundColor = .green
        // text label
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = .white
        titleLabel.text = annotation.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
