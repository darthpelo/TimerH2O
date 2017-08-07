//
//  TH2OTimerViewController+Coach.swift
//  TimerH2O
//
//  Created by Alessio Roberto on 06/08/2017.
//  Copyright © 2017 Alessio Roberto. All rights reserved.
//

import Foundation
import Instructions

enum Mark: Int {
    case one
    case two
    case three
    case four
}

extension TH2OTimerViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return Mark.four.rawValue + 1
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkAt index: Int) -> CoachMark {
        switch index {
        case Mark.one.rawValue:
            return coachMarksController.helper.makeCoachMark(for: self.startNewSessionButton)
        case Mark.two.rawValue:
            return coachMarksController.helper.makeCoachMark(for: self.stopTimerButton)
        case Mark.three.rawValue:
            return coachMarksController.helper.makeCoachMark(for: self.endSessionButton)
        case Mark.four.rawValue:
            if let subviews = self.tabBarController?.tabBar.subviews {
                let coachMark = coachMarksController.helper.makeCoachMark(for: subviews[3]) {(frame: CGRect) -> UIBezierPath in
                    // This will create an oval cutout a bit larger than the view.
                    return UIBezierPath(ovalIn: frame.insetBy(dx: -4, dy: -4))
                }
                return coachMark
            }
            return coachMarksController.helper.makeCoachMark(for: nil)
        default:
            return coachMarksController.helper.makeCoachMark(for: nil)
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              coachMarkViewsAt index: Int,
                              madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        if index == Mark.one.rawValue {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkOne()
            coachViews.bodyView.nextLabel.text = "1️⃣"
            
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        } else if index == Mark.two.rawValue {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkTwo()
            coachViews.bodyView.nextLabel.text = "2️⃣"
            
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        } else if index == Mark.three.rawValue {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkThree()
            coachViews.bodyView.nextLabel.text = "3️⃣"
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        } else {
            coachViews.bodyView.hintLabel.text = R.string.localizable.coachMarkFour()
            coachViews.bodyView.nextLabel.text = "👌"
            UserDefaults().timerCoachShowed = true
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        }
    }
}
