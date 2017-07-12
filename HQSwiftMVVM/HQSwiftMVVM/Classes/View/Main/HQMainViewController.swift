//
//  HQMainViewController.swift
//  HQSwiftMVVM
//
//  Created by 王红庆 on 2017/7/5.
//  Copyright © 2017年 王红庆. All rights reserved.
//

import UIKit

class HQMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        setupComposeButton()
    }
    
    // 设置支持的方向之后,当前的控制器及子控制器都会遵守这个方向,因此写在`HQMainViewController`里面
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: - 监听方法
    // FIXME: 没有实现
    // @objc 允许这个函数在运行时通过`OC`消息的消息机制被调用
    @objc fileprivate func composeStatus() {
        print("点击加号按钮")
        
        let vc = UIViewController()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.view.backgroundColor = UIColor.hq_randomColor()
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - 撰写按钮
    fileprivate lazy var composeButton = UIButton(hq_imageName: "tabbar_compose_icon_add",
                                              backImageName: "tabbar_compose_button")
}

/*
 extension 类似于 OC 中的分类,在 Swift 中还可以用来切分代码块
 可以把功能相近的函数,放在一个extension中
 */
extension HQMainViewController {
    
    /// 设置撰写按钮
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        // 设置按钮的位置
        let count = CGFloat(childViewControllers.count)
        // 减`1`是为了是按钮变宽,覆盖住系统的容错点
        let w = tabBar.bounds.size.width / count - 1
        composeButton.frame = tabBar.bounds.insetBy(dx: w * 2, dy: 0)
        
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    /// 设置所有子控制器
    fileprivate func setupChildControllers() {
        
        let array: [[String: Any]] = [
            [
                "className": "HQAViewController",
                "title": "首页",
                "imageName": "a",
                "visitorInfo": [
                    "imageName": "",
                    "message": "关注一些人，回这里看看有什么惊喜"
                ]
            ],
            [
                "className": "HQBViewController",
                "title": "消息",
                "imageName": "b",
                "visitorInfo": [
                    "imageName": "visitordiscover_image_message",
                    "message": "登录后，别人评论你的微博，发给你的信息，都会在这里收到通知"
                ]
            ],
            [
                "className": "UIViewController"
            ],
            [
                "className": "HQCViewController",
                "title": "发现",
                "imageName": "c",
                "visitorInfo": [
                    "imageName": "visitordiscover_image_message",
                    "message": "登录后，最新、最热微博尽在掌握，不再会与时事潮流擦肩而过"
                ]
            ],
            [
                "className": "HQDViewController",
                "title": "我",
                "imageName": "d",
                "visitorInfo": [
                    "imageName": "visitordiscover_image_profile",
                    "message": "登录后，你的微博、相册，个人资料会显示在这里，显示给别人"
                ]
            ]
        ]
        
        (array as NSArray).write(toFile: "/Users/wanghongqing/Desktop/demo.plist", atomically: true)
        
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
    }
    /*
     ## 关于 fileprvita 和 private
     
     - 在`swift 3.0`，新增加了一个`fileprivate`，这个元素的访问权限为文件内私有
     - 过去的`private`相当于现在的`fileprivate`
     - 现在的`private`是真正的私有，离开了这个类或者结构体的作用域外面就无法访问了
     */
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典[className, title, imageName, "vistorInfo"]
    /// - Returns: 子控制器
    fileprivate func controller(dict: [String: Any]) -> UIViewController {
        
        // 1. 获取字典内容
        guard let className = dict["className"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + className) as? UIViewController.Type else {
                
                return UIViewController()
        }
        
        // 2. 创建视图控制器
        let vc = cls.init()
        vc.title = title
        
        // 3. 设置图像
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        // 设置`tabBar`标题颜色
        vc.tabBarItem.setTitleTextAttributes(
            [NSForegroundColorAttributeName: UIColor.orange],
            for: .selected)
        // 设置`tabBar`标题字体大小,系统默认是`12`号字
        vc.tabBarItem.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.systemFont(ofSize: 12)],
            for: .normal)
        
        let nav = HQNavigationController(rootViewController: vc)
        return nav
    }
}
