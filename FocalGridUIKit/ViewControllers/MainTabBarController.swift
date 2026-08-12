//
//  MainTabBarController.swift
//  FocalGridUIKit
//
//  Created by DIMAS DAFFA ERNANDA on 11/07/26.
//

import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = UINavigationController(rootViewController: DashboardViewController())
        home.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        let gallery = UINavigationController(rootViewController: GalleryViewController())
        gallery.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill")
        )

        viewControllers = [home, gallery]
//        tabBar.tintColor = .themeMaple
    }
}

private struct MainTabBarPreviewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainTabBarController {
        MainTabBarController()
    }
    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {}
}

#Preview("Main Tab Bar Controller") {
    MainTabBarPreviewWrapper()
}
