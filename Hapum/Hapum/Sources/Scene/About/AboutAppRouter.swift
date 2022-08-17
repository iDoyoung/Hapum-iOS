//
//  AboutAppRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/17.
//

import UIKit

@objc
protocol AboutAppRoutingLogic {
    func presentActivityVC(source: AboutAppViewController, sender: UITableViewCell?)
    func routeToPrivacyPolicy(segue: UIStoryboardSegue?)
    func openAppStoreToWriteReview()
}

final class AboutAppRouter: NSObject, AboutAppRoutingLogic {
    
    weak var viewController: AboutAppViewController?

    func routeToPrivacyPolicy(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        
        if segue == nil {
            let storyboard = Storyboard.about
            let destinationVC = ViewController.privacyPolicy(storyboard: storyboard) as! PrivacyPolicyViewController
            navigateToPrivacyPolicy(source: viewController, destination: destinationVC)
        }
    }
    
    func openAppStoreToWriteReview() {
        guard let url = URL(string: "https://apps.apple.com/app/id1625220721?action=write-review") else {
           return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func presentActivityVC(source: AboutAppViewController, sender: UITableViewCell?) {
        let message = ["https://apps.apple.com/app/id1625220721"]
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = source.view
                popover.sourceRect = sender?.frame ?? CGRect()
            }
        }
        source.present(activityVC, animated: true, completion: nil)
    }
    
    private func navigateToPrivacyPolicy(source: AboutAppViewController, destination: PrivacyPolicyViewController) {
        source.show(destination, sender: nil)
    }
    
}
