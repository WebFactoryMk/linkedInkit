import Foundation
import Alamofire

class LinkedInHTTPClient: Alamofire.Manager {
    
    let linkedInConfiguration: LinkedInConfiguration
    var presentingViewController: UIViewController?
    
    var viewControllerDelegate: LinkedInAuthorizationViewControllerDelegate?
    
    init(linkedInConfiguration: LinkedInConfiguration, presentingViewController: UIViewController?) {
        self.linkedInConfiguration = linkedInConfiguration
        self.presentingViewController = presentingViewController
        
        super.init(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func getAuthorizationCode(withSuccessCalback successCallback: LinkedInAuthCodeSuccessCallback?,
                                                 cancelCallback: LinkedInAuthCodeCancelCallback?,
                                                 failureCallback: LinkedInAuthFailureCallback?) {
        let viewController = LinkedInAuthorizationViewController(configuration: linkedInConfiguration, successCalback: { [weak self] (code) in
            self?.hideAuthorizationViewController()
            successCallback?(code: code)
            }, cancelCalback: { [weak self] in
                self?.hideAuthorizationViewController()
                cancelCallback?()
            }) { [weak self] (error) in
                self?.hideAuthorizationViewController()
                failureCallback?(error: error)
        }
        viewController.delegate = viewControllerDelegate
        
        showAuthorizationViewController(viewController)
    }
    
    func getAccessToken(forAuthorizationCode code: String,
                                             success: LinkedInAuthSuccessCallback,
                                             failure: LinkedInAuthFailureCallback) {
        let redrectURL = linkedInConfiguration.redirectURL.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        let accessTokenURL = "http://www.linkedin.com/oauth/v2/accessToken?grant_type=authorization_code&code=\(code)&redirect_uri=\(redrectURL)&client_id=\(linkedInConfiguration.clientID)&client_secret=\(linkedInConfiguration.clientSecret)"
        
        self.request(.POST, accessTokenURL, parameters: nil, encoding: .URL, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .Success(let JSON):
                let accessToken = JSON["access_token"] as? String
                let expiresIn =  Int(JSON["expires_in"] as! String)
                let expiredDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Second,
                    value: expiresIn!,
                    toDate: NSDate(),
                    options: NSCalendarOptions.init(rawValue: 0))
                let token = LinkedInAccessToken(withAccessToken: accessToken,
                    expireDate: expiredDate,
                    isSDK: false)
                
                success(token: token)
            case .Failure(let error):
                failure(error: error)
            }
        }
    }

    //Helper methods
    func showAuthorizationViewController(viewController: LinkedInAuthorizationViewController) {
        if presentingViewController == nil {
            presentingViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        }
        
        presentingViewController?.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func hideAuthorizationViewController() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}