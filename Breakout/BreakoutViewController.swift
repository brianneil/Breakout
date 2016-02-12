//
//  BreakoutViewController.swift
//  Breakout
//
//  Created by Brian Neil on 2/11/16.
//  Copyright © 2016 Apollo Hearing. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {

    
    @IBOutlet weak var gameView: UIView!
    
    lazy var animator: UIDynamicAnimator = {
        let lazilyCreatedAnimator = UIDynamicAnimator(referenceView: self.gameView)
        lazilyCreatedAnimator.delegate = self
        return lazilyCreatedAnimator
    }()
    
    let brickOutBehavior = BrickOutBehavior()
    
    var bricksPerRow = 10
    
    var rows = 5    //Number of rows of bricks
    
    var aspectRatio = 5  //The ratio of the width to the height of the brick
    
    var brickPercentage = 0.80   //The percent of the width of the screen that the bricks take up
    
    var paddleWidthDivider = 7
    
    let paddleOffset = 20
    let ballOffset = 10
    
    var paddleSize: CGSize{
        let width = gameView.bounds.width/CGFloat(paddleWidthDivider)
        let height = CGFloat(10)
        return CGSize(width: width, height: height)
    }
    
    var ballSize: CGSize {
        let size = gameView.bounds.width/30
        return CGSize(width: size, height: size)
    }
    
    
    var brickGap: CGFloat {
        let gap = gameView.bounds.width / CGFloat(bricksPerRow) - brickSize.width
        return gap
    }
    
    var brickSize: CGSize {     //Calculated property brick size
        let width = gameView.bounds.width / CGFloat(bricksPerRow) * CGFloat(brickPercentage)
        let height = width/CGFloat(aspectRatio)
        return CGSize(width: width, height: height)
    }
    
    struct Names {
        static let EdgePathName = "EdgePath"
        static let BrickName = "Brick"
        static let PaddleTag = 100
    }
    
    
    @IBAction func slidePaddle(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(gameView).x
            if translation != 0 {
                //move the paddle
                if let taggedPaddle = gameView.viewWithTag(Names.PaddleTag) {
                    taggedPaddle.center.x += translation
                    if taggedPaddle.center.x <= paddleSize.width/2 {taggedPaddle.center.x = paddleSize.width/2}
                    if taggedPaddle.center.x >= gameView.bounds.width - (paddleSize.width / 2) { taggedPaddle.center.x = gameView.bounds.width - (paddleSize.width / 2) }
                    //TODO need to set the boundary!
                }
                sender.setTranslation(CGPointZero, inView: gameView)
            }
        default: break
        }
    }
    
    func brick(x x: CGFloat, y: CGFloat, brickCount: Int) {       //Takes the position of the brick and then creates a brick at that spot
        let brickOrigin = CGPoint(x: x, y: y)
        let frame = CGRect(origin: brickOrigin, size: brickSize)
        
        let brickView = UIView(frame: frame)
        brickView.backgroundColor = UIColor.blackColor()
        
        let bezRect = frame
        let path = UIBezierPath(rect: bezRect)
        brickOutBehavior.addBoundary(path, name: Names.BrickName + "\(brickCount)")
        
        brickOutBehavior.addBrick(brickView)
    }
    
    func drawBricks() {             //Nested for loops to generate brick positions
        for yIndex in 0..<rows {
            for xIndex in 0..<bricksPerRow {
                let xPos = brickGap/2 + ((brickGap + brickSize.width) * CGFloat(xIndex)) //brickgap/2 spacing at each end.
                let yPos = brickGap + brickGap * CGFloat(yIndex)
                brick(x: xPos, y: yPos, brickCount: xIndex + yIndex)
            }
        }
    }
    
    func drawPaddle() {
        let x = gameView.bounds.width/2 - paddleSize.width/2
        let y = gameView.bounds.height - paddleSize.height - CGFloat(paddleOffset)
        let paddleOrigin = CGPoint(x: x, y: y)
        
        let frame = CGRect(origin: paddleOrigin, size: paddleSize)
        let paddleView = UIView(frame: frame)
        paddleView.backgroundColor = UIColor.redColor()
        paddleView.tag = Names.PaddleTag
        
        gameView.addSubview(paddleView)
        //TODO this needs a boundary!
    }
    
    func drawBall() {
        let xOrigin = gameView.bounds.width/2 - ballSize.width/2
        let yOrigin = gameView.bounds.height - ballSize.height - paddleSize.height - CGFloat(paddleOffset) - CGFloat(ballOffset)
        let ballOrigin = CGPoint(x: xOrigin, y: yOrigin)
        
        let frame = CGRect(origin: ballOrigin, size: ballSize)
        let ballView = UIView(frame: frame)
        ballView.backgroundColor = UIColor.orangeColor()
        
        brickOutBehavior.addBall(ballView)
    }
    
    func setEdgeBoundaries() {      //Starts in the bottom left corner, works it's way around to bottom right.
        let edgePath = UIBezierPath()
        let startPoint = CGPoint(x: 0, y: 0 + gameView.bounds.height)
        edgePath.moveToPoint(startPoint)
        edgePath.addLineToPoint(CGPointZero)
        edgePath.addLineToPoint(CGPoint(x: 0 + gameView.bounds.width, y: 0))
        edgePath.addLineToPoint(CGPoint(x: 0 + gameView.bounds.width, y: 0 + gameView.bounds.height))
        brickOutBehavior.addBoundary(edgePath, name: Names.EdgePathName)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(brickOutBehavior)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawBricks()
        drawPaddle()
        drawBall()
        setEdgeBoundaries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
