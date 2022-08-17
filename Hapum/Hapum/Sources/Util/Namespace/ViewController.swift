//
//  ViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/08/17.
//

import UIKit

struct ViewController {
    private init() { }
    static func main(storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: "MainViewController")
    }
    static func aboutApp(storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: "AboutAppViewController")
    }
    static func createPhotosWall(storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: "CreatePhotosWallViewController")
    }
    static func privacyPolicy(storyboard: UIStoryboard) -> UIViewController {
        return storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
    }
}
