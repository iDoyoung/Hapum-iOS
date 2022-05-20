//
//  AboutAppRouter.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/17.
//

import UIKit

@objc
protocol AboutAppRoutingLogic {
    func routeToRecommendApp(segue: UIStoryboardSegue?)
    func routeToPrivacyPolicy(segue: UIStoryboardSegue?)
    func openAppStoreToWriteReview()
}

final class AboutAppRouter: NSObject, AboutAppRoutingLogic {
    
    weak var viewController: AboutAppViewController?
    
    func routeToRecommendApp(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        presentActivityVC(source: viewController)
    }
    
    func routeToPrivacyPolicy(segue: UIStoryboardSegue?) {
        guard let viewController = viewController else { return }
        
        if segue == nil {
            let storyboard = UIStoryboard(name: StoryboardName.about, bundle: Bundle.main)
            let destinationVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
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
    
    private func presentActivityVC(source: AboutAppViewController) {
        let message = ["https://apps.apple.com/app/id1625220721"]
        let activityVC = UIActivityViewController(activityItems: message, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popup = activityVC.popoverPresentationController {
                popup.sourceView = source.view
            }
        }
        source.present(activityVC, animated: true, completion: nil)
    }
    
    private func navigateToPrivacyPolicy(source: AboutAppViewController, destination: PrivacyPolicyViewController) {
        source.show(destination, sender: nil)
    }
    
}
