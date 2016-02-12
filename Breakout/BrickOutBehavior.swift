//
//  BrickOutBehavior.swift
//  Breakout
//
//  Created by Brian Neil on 2/11/16.
//  Copyright © 2016 Apollo Hearing. All rights reserved.
//

import UIKit

class BrickOutBehavior: UIDynamicBehavior {
    
//    lazy var gravity: UIGravityBehavior = {
//        let lazilyCreatedGravityBehavior = UIGravityBehavior()
//        lazilyCreatedGravityBehavior.gravityDirection = (CGVector(dx: 0.0, dy: -1.0))
//        return lazilyCreatedGravityBehavior
//    }()
    
    lazy var collider = UICollisionBehavior()
    
    lazy var ballBehavior: UIDynamicItemBehavior = {
        let lazilyCreatedBallBehavior = UIDynamicItemBehavior()
        lazilyCreatedBallBehavior.allowsRotation = false
        lazilyCreatedBallBehavior.elasticity = 1.0
        return lazilyCreatedBallBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
//        addChildBehavior(gravity)
    }
    
    func addBrick(brick: UIView){
        dynamicAnimator?.referenceView?.addSubview(brick)
    }
    
    func removeBrick(brick: UIView) {
        brick.removeFromSuperview()
    }
    
    func addBall(ball: UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
//        gravity.addItem(ball)
    }
    
    func removeBall(ball: UIView) {
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
//        gravity.removeItem(ball)
        ball.removeFromSuperview()
    }
    
    func addBoundary(path: UIBezierPath, name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }

}
