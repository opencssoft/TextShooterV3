//
//  EnemyNode.swift
//  TextShooter
//
//  Created by FangChen on 2017/11/22.
//  Copyright © 2017年 FangChen. All rights reserved.
//

import SpriteKit

class EnemyNode: SKNode {
    override init(){
        super.init()
        name = "Enemy \(self)"
        initNodeGraph()
        initPhysicsBody()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initNodeGraph(){
        let topRow = SKLabelNode(fontNamed:"Courier-Bold")
        topRow.fontColor = SKColor.brown
        topRow.fontSize = 20
        topRow.text = "x x"
        topRow.position = CGPoint(x:0,y:15)
        addChild(topRow)
        
        let middleRow = SKLabelNode(fontNamed:"Courier-Bold")
        middleRow.fontColor = SKColor.brown
        middleRow.fontSize = 20
        middleRow.text = "x"
        addChild(middleRow)
        
        let bottomRow = SKLabelNode(fontNamed:"Courier-Bold")
        bottomRow.fontColor = SKColor.brown
        bottomRow.fontSize = 20
        bottomRow.text = "x x"
        bottomRow.position = CGPoint(x:0,y:-15)
        addChild(bottomRow)
    }
    
    private func initPhysicsBody(){
        let body = SKPhysicsBody(rectangleOf:CGSize(width:40,height:40))
        body.affectedByGravity = false
        body.categoryBitMask = EnmeyCategory
        body.contactTestBitMask = PlayerCategory|EnmeyCategory
        body.mass = 0.2
        body.angularDamping = 0
        body.linearDamping = 0
        body.fieldBitMask = 0
        physicsBody = body
    }
    
    override func receiveAttacker(_ attacker:SKNode,contact:SKPhysicsContact){
        physicsBody!.affectedByGravity = true
        let force = vectorMultiply(attacker.physicsBody!.velocity,contact.collisionImpulse)
        let myContact = scene!.convert(contact.contactPoint,to:self)
        physicsBody!.applyForce(force,at:myContact)
        
        let path = Bundle.main.path(forResource:"MissleExplosion",ofType:"sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 20
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        run(SKAction.playSoundFileNamed("enemyHit.wav", waitForCompletion: false))
    }
    
    override func friendlyBumpFrom(_ node:SKNode){
        physicsBody!.affectedByGravity = true
    }
}
