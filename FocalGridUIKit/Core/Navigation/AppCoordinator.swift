//
//  AppCoordinator.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 17/08/26.
//

import Foundation

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let repository: CompositionRepositoryProtocol

    init(navigationController: UINavigationController, repository: CompositionRepositoryProtocol = LocalCompositionRepository()) {
        self.navigationController = navigationController
        self.repository = repository
    }

    func start() {
        let mainTabBar = MainTabBarController()
        
        // Setup Tab Bar View Controllers
        let dashboardVM = DashboardViewModel(repository: repository)
        let dashboardVC = DashboardViewController(viewModel: dashboardVM)
        dashboardVC.coordinator = self
        
        let homeNav = UINavigationController(rootViewController: dashboardVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let galleryVC = GalleryViewController()
        let galleryNav = UINavigationController(rootViewController: galleryVC)
        galleryNav.tabBarItem = UITabBarItem(title: "Gallery", image: UIImage(systemName: "photo.on.rectangle"), selectedImage: UIImage(systemName: "photo.on.rectangle.fill"))
        
        mainTabBar.viewControllers = [homeNav, galleryNav]
        navigationController.setViewControllers([mainTabBar], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    func showDetailCard(for type: CompositionType, from nav: UINavigationController?) {
        let viewModel = DetailCardViewModel(type: type, repository: repository)
        let detailVC = DetailCardViewController(viewModel: viewModel)
        detailVC.coordinator = self
        (nav ?? navigationController).pushViewController(detailVC, animated: true)
    }

    func showMechanicDetail(mechanics: [GridMechanic], startIndex: Int, themeColor: UIColor, title: String, from nav: UINavigationController?) {
        let reader = MechanicDetailViewController(
            mechanics: mechanics,
            startIndex: startIndex,
            themeColor: themeColor,
            compositionTitle: title
        )
        (nav ?? navigationController).pushViewController(reader, animated: true)
    }
}
