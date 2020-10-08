//
//  ViewController.swift
//  NWPathMonitor
//
//  Created by Kaustabh on 10/8/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import Foundation
import UIKit

import Network

protocol NetworkObserver: class {
    func NetworkStatus(status: NWPath.Status)
}

class NetworkCheck {
    
   
    struct NetworkChangeObservation {
        weak var observer: NetworkObserver?
    }
    
    private var monitor = NWPathMonitor()
    private static let _sharedInstance = NetworkCheck()
    private var observations = [ObjectIdentifier: NetworkChangeObservation]()
    
    var currentStatus: NWPath.Status {
        get {
            return monitor.currentPath.status
        }
    }
    
    class func sharedInstance() -> NetworkCheck {
        return _sharedInstance
    }
    
    /// Description - //Path Handler for network monitor
    init() {
        monitor.pathUpdateHandler = { [unowned self] path in
            for (id, observations) in self.observations {
                
                //If any observer is nil, remove it from the list of observers
                guard let observer = observations.observer else {
                    self.observations.removeValue(forKey: id)
                    continue
                }
                
                DispatchQueue.main.async(execute: {
                    observer.NetworkStatus(status: path.status)
                })
            }
            switch path.status {
            case .satisfied:
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.presentAlert(withTitle: .Info, message: "Internet is back")
                }
                break
            case .unsatisfied:
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.presentAlert(withTitle: .Info, message: "Internet is unstable")
                }
                break
            case .requiresConnection:
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.presentAlert(withTitle: .Info, message: "Internet is gone")
                }
                break
            default:
                break
            }
            
            
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    /// Description
    /// - Parameter observer:- Start Listening observer
    func start(observer: NetworkObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = NetworkChangeObservation(observer: observer)
    }
    
    /// Description
    /// - Parameter observer: stop listening observer
    func stop(observer: NetworkObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
    
}

enum titleType : String {
    case Info = "Info"
    case Warning = "Warning"
    case Error = "Error"
    case Alert = "Alert"
}

extension UIViewController {

    func presentAlert(withTitle title: titleType = .Info, message : String = "") {
        let alertController = UIAlertController(title: title.rawValue , message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        print("Ok button completion handler")
    }
    let CANCELAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: { action in
        print("CANCEL button completion handler")
    })
    alertController.addAction(OKAction)
    alertController.addAction(CANCELAction)
    self.present(alertController, animated: true, completion: nil)
  }
}

