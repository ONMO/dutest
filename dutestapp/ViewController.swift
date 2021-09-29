//
//  ViewController.swift
//  dutestapp
//
//  Created by rama chinthu on 8/10/21.
//

import UIKit
import OnMobileRBTSDK

enum AuthenticationKey: String {
    case prod = ""
    case staging = "0nM0b!1eStaging"
    case preProduction = "0nM0b!1ePreProduction"
    case preStaging = "0nM0b!1ePreStaging"
    case dev = "0nM0b!1eDevelopment"
}

class ViewController: UIViewController {

    @IBOutlet weak var initializeAndLaunchButton: UIButton!
    @IBOutlet weak var initializeButton: UIButton!
    @IBOutlet weak var launchButton: UIButton!
    var activityView: UIActivityIndicatorView?
    
    var authenticationKey : String = AuthenticationKey.dev.rawValue
    var clientKey : String = ""
    
    var phoneNumber: String = ""
    var phoneNumbers: [String] = []
    
    var onMobileRBTConnectorResponse: OnMobileRBTConnectorResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    func initialSetup() {
        initializeAndLaunchButton?.isHidden = false
        initializeButton?.isHidden = false
        launchButton?.isHidden = true
    }

    @IBAction func initialiseAndLaunchSDK(_ sender: Any) {
        _initialiseAndLaunchSDK()
    }

    @IBAction func initialiseSDK(_ sender: Any) {
        _initialiseSDK()
    }

    @IBAction func launchSDKUI(_ sender: Any) {
        _launchSDK()
    }
    
    @IBAction func showAlertView(_ sender: Any) {
        showLaunchOnAlertController(style: .alert)
    }
    
    @IBAction func showAlertSheet(_ sender: Any) {
        showLaunchOnAlertController(style: .actionSheet)
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    private func showLaunchOnAlertController(style: UIAlertController.Style) {
        let alertController = UIAlertController(title:"OnMobileDUSDK", message: "", preferredStyle:style)

        let launchAction = UIAlertAction.init(title: "Initialize and launch", style: .default) { (UIAlertAction) in
            self._initialiseAndLaunchSDK()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (UIAlertAction) in
        }

        alertController.addAction(launchAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func _initialiseAndLaunchSDK() {
        showActivityIndicator()
        
        OnMobileRBTConnector.initialize(
            withAuthenticationKey: authenticationKey,
            andClientKey: clientKey,
            forPhoneNumber: phoneNumber,
            andPhoneNumbers: phoneNumbers,
            controller: self,
            listener: #selector(onMobileRBTConnectorResponseCallbackListenerMethod),
            eventListener: #selector(onMobileRBTConnectorResponseEventListenerMethod),
            succedded: { (response) in
                self.hideActivityIndicator()
                self.onMobileRBTConnectorResponse = response
                self.onMobileRBTConnectorResponse?.launch(
                    on: self,
                    animated: true,
                    failed: { (error) in
                        print(error.message)
                    })
                
            },
            failed: { (error) in
                self.hideActivityIndicator()
                print(error.message)
            })
    }
    
    private func _initialiseSDK() {
        showActivityIndicator()
        OnMobileRBTConnector.initialize(
            withAuthenticationKey: authenticationKey,
            andClientKey: clientKey,
            forPhoneNumber: phoneNumber,
            andPhoneNumbers: phoneNumbers,
            controller: self,
            listener: #selector(onMobileRBTConnectorResponseCallbackListenerMethod),
            eventListener: #selector(onMobileRBTConnectorResponseEventListenerMethod),
            succedded: { (response) in
                self.hideActivityIndicator()
                self.onMobileRBTConnectorResponse = response
                self.initializeButton?.isHidden = true
                self.launchButton?.isHidden = false
            },
            failed: { (error) in
                self.hideActivityIndicator()
                print(error.message)
            })
    }
    
    private func _launchSDK() {
        self.onMobileRBTConnectorResponse?.launch(on: self, animated: true, failed: { (error) in
            print(error.message)
        })
    }
    
    @objc func onMobileRBTConnectorResponseCallbackListenerMethod() {
        guard let listenerType = self.onMobileRBTConnectorResponse?.callbackListener.type else {
            return
        }
        
        switch listenerType {
        case .activation,
             .deActivation:
            
            //Your activationOrDeactivationController
            let activationOrDeactivationController: UIViewController = UIViewController()
            
            let onMobileRBTConnectorCallback = self.onMobileRBTConnectorResponse?.callbackListener.onMobileRBTConnectorCallback
            onMobileRBTConnectorCallback?.controller?.present(activationOrDeactivationController, animated: true, completion: nil)
        }
    }
    
    @objc func onMobileRBTConnectorResponseEventListenerMethod() {
        guard let listenerType = self.onMobileRBTConnectorResponse?.eventListener.type else {
            return
        }
        
        switch listenerType {
        case .sdkOpen:
            print("Handle sdk open")
            
        case .sdkClose:
            print("Handle sdk close")
            self.initializeButton?.isHidden = false
            self.launchButton?.isHidden = true
        
        case .event:
            print("Handle Event")
            print(self.onMobileRBTConnectorResponse?.eventListener.event ?? "No value")
        }
    }
}


