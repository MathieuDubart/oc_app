//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Mathieu Dubart on 15/07/2023.
//

import UIKit

class QuestionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    enum Style {
        case correct, incorrect, standard
    }
    
    var style:Style = .standard {
        didSet {
            setStyle(style)
        }
    }
    
    //lorsque title est modifié, le contenu de la méthode didSet est exécuté
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    
    private func setStyle(_ style:Style) {
        switch style {
        case .correct:
            backgroundColor = UIColor(red: 200/255.0, green: 236/255.0, blue: 160/255.0, alpha: 1.0)
            icon.image = #imageLiteral(resourceName: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            backgroundColor = #colorLiteral(red: 0.9545022845, green: 0.5277165174, blue: 0.5802887082, alpha: 1) //backgroundColor = #colorLiteral()
            icon.image = #imageLiteral(resourceName: "Icon Error") // icon.image = #imageLiteral()
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7510173917, green: 0.7683033943, blue: 0.786244452, alpha: 1)
            icon.isHidden = true
        }
    }
    
}
