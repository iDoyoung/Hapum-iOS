//
//  AboutAppViewController.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/15.
//

import UIKit

final class AboutAppViewController: UITableViewController {

    var router: (NSObjectProtocol&AboutAppRoutingLogic)?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUpViewController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViewController()
    }
    
    private func setUpViewController() {
        let router = AboutAppRouter()
        self.router = router
        router.viewController = self
    }
    
    enum TableViewSection: Int, CaseIterable {
        case info = 0, detail
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButtonItem()
        configureTableViewCell()
    }
    
    private func setRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(backToMainScene))
    }
    
    private func configureTableViewCell() {
        tableView.register(AppInfoTableViewCell.self, forCellReuseIdentifier: AppInfoTableViewCell.reuseID)
        tableView.register(AboutAppTableViewCell.self, forCellReuseIdentifier: AboutAppTableViewCell.reuseID)
    }
    
    private func getAppVersion() -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let version = infoDictionary["CFBundleShortVersionString"] as? String else {
            return "???"
        }
        return "Version \(version)"
    }
    
    //MARK: - Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let scene = segue.identifier else { return }
        routeScene(scene, segue: segue)
        
    }
    
    private func routeScene(_ scene: String, segue: UIStoryboardSegue?) {
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router,
           router.responds(to: selector){
            router.perform(selector, with: segue)
        }
    }
    
    //MARK: - Table view datasource & delegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableViewSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableViewSection = TableViewSection(rawValue: section) else { return 0 }
        switch tableViewSection {
        case .info:
            return 1
        case .detail:
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableViewSection = TableViewSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch tableViewSection {
        case .info:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppInfoTableViewCell.reuseID, for: indexPath) as? AppInfoTableViewCell else { return UITableViewCell() }
            cell.versionLabel.text = getAppVersion()
            return cell
        case .detail:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutAppTableViewCell.reuseID, for: indexPath) as? AboutAppTableViewCell else { return UITableViewCell() }
            var content = cell.defaultContentConfiguration()
            switch indexPath.row {
            case 0:
                content.text = LabelText.recommending
            case 1:
                content.text = LabelText.reviewing
            case 2:
                content.text = LabelText.privacyPolicy
            default:
                break
            }
            cell.contentConfiguration = content
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == TableViewSection.detail.rawValue {
            switch indexPath.row {
            case 0:
                router?.presentActivityVC(source: self, sender: tableView.cellForRow(at: indexPath))
            case 1:
                router?.openAppStoreToWriteReview()
            case 2:
                performSegue(withIdentifier: SegueID.privacyPolicy, sender: self)
            default:
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AboutAppViewController {
    
    @objc
    func backToMainScene() {
        dismiss(animated: true)
    }
    
}
