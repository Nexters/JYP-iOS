import ProjectDescription
import ProjectDescriptionHelpers

/*
                +-------------+
                |             |
                |     App     | Contains MyApp App target and MyApp unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project Factory

protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }

    func generate() -> [Target]
}

// MARK: - Base Project Factory



class BaseProjectFactory: ProjectFactory {
    let projectName: String = "JYP-iOS"
    
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen"
        ]

    let dependencies: [TargetDependency] = [
        .external(name: "Moya"),
        .external(name: "Alamofire"),
        .external(name: "RxMoya"),
        .external(name: "SnapKit"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "ReactorKit"),
        .external(name: "Then"),
    ]
    
    let packages: [Package] = [
        .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMinor(from: "15.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0")),
        .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMinor(from: "3.2.0")),
        .remote(url: "https://github.com/devxoul/Then.git", requirement: .upToNextMinor(from: "3.0.0")),
    ]
    
    func generate() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.jyp.\(projectName)",
                deploymentTarget: .iOS(targetVersion: "13.0", devices: [.iphone]),
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/\(projectName)/Sources/**"],
                resources: "\(projectName)/\(projectName)/Resources/**", scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
//                entitlements: "\(projectName)/\(projectName).entitlements",
                dependencies: dependencies
            ),

            Target(
                name: "\(projectName)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "com.jyp.\(projectName).Tests",
                infoPlist: .default,
                sources: ["\(projectName)/\(projectName)Tests/**"],
                dependencies: [.target(name: "JYP-iOS")]
            )
        ]
    }
}

// MARK: - Project

let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    packages: factory.packages,
    targets: factory.generate()
)
