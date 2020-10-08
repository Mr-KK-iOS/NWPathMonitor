//
//  ViewController.swift
//  NWPathMonitor
//
//  Created by Admin on 10/8/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController  {
    
    var networkCheck = NetworkCheck.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Call this function in any ViewController to detect Netowrk Connection & show alert to user
        
        let _ = NetworkCheck.sharedInstance()
        
        ///Start Listening to network detection for a particular VC
        //networkCheck.start(observer: self)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //networkCheck.stop(observer: self)
    }
    
    func NetworkStatus(status: NWPath.Status) {
        /*
        switch status {
        case .satisfied:
            //Write your code
        case .unsatisfied:
            //Write your code
        case .requiresConnection:
            //Write your code
        default:
            break
        }
         */
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
