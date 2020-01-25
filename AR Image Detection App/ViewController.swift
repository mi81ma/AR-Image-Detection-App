//
//  ViewController.swift
//  AR Image Detection App
//
//  Created by masato on 25/1/2020.
//  Copyright © 2020 gigmuster. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // @IBOutlet var sceneView: ARSCNView!

    // 1. add sceneView var
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // 2. set sceneView size
        sceneView = {
            let arscnView = ARSCNView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))

            return arscnView
        }()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene


        // 3. addSubview sceneView
        view.addSubview(sceneView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 4. Create a session configuration
        let configuration: ARImageTrackingConfiguration = {
            let configulation = ARImageTrackingConfiguration()

            guard let referenceImage = ARReferenceImage.referenceImages(inGroupNamed: "AR_Resources", bundle: Bundle.main) else {
                fatalError("Fail to load the reference images")
            }

            // 5. set referenceImage to trackingImage
            configulation.trackingImages = referenceImage

            return configulation
        }()

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    //Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        // -------- 球体のNodeを追加 ---------------

        let sphereMaterial = SCNMaterial()
        // sphereMaterial.diffuse.contents = UIColor.green
        sphereMaterial.diffuse.contents = UIImage(named: "earth3d")

        // Sphere Node
        let sphereNode = SCNNode()

        sphereNode.geometry = SCNSphere(radius: 3)

        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0, 0, 2)

        // 3D Sphereの傾き
        sphereNode.eulerAngles.x = -.pi / 2

        // add 3D-object node to SCNScene
        node.addChildNode(sphereNode)
        print("sphereNode: ", sphereNode)


        // moviing object3DTexture
        let rotateAction = SCNAction.rotate(by: 360.degreesToRadians(),
                                            around: SCNVector3(0, 0, 1),
                                            duration: 8)
        let rotateForeverAction = SCNAction.repeatForever(rotateAction)
        sphereNode.runAction(rotateForeverAction)

        // --------- 以上、球体のNode ---------------
     
        return node
    }

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


extension Int {
    func degreesToRadians() -> CGFloat {
        return CGFloat(self) * CGFloat.pi / 180.0
    }
}
