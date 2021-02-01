//
//  CoffeeCalloutView.swift
//  WorkWithMap
//
//  Created by Сергей Голенко on 01.02.2021.
//

import UIKit

class CoffeeCalloutView: UIView {
    
    // устанавливать annotation буду через init (например в методе didSelect annotation)
    private var annotation : CoffeeAnnotation!
    

    func add(to view:UIView){
        // очень важно сначала добавить view, а потом уже установить констрейты
        view.addSubview(self)
        self.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -5).isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Эти 4 строчки кода можно также переместить в метод configure(),так будет даже правильнее
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 40.0
        self.layer.masksToBounds = true
        self.backgroundColor = .purple
        
    }
    
     private func configure(){
        // text label
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textColor = .white
        titleLabel.text = annotation.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        // очень важно сначала добавить titleLabel, а потом уже установить констрейты
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    init(annotation:CoffeeAnnotation,frame: CGRect = CGRect.zero){
        super.init(frame: frame)
        self.annotation = annotation
        self.frame = frame
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
   
    
}
