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

    func generateTarget() -> [Target]
    func generateConfigurations() -> Settings
}

// MARK: - Base Project Factory

class BaseProjectFactory: ProjectFactory {
    let projectName: String = "JYP-iOS"
    let bundleName: String = "journeypiki"

    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "KAKAO_REST_KEY": "$(KAKAO_REST_KEY)",
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "SERVER_HOST": "$(SERVER_HOST)",
        "SERVER_JWT_MASTER_KEY": "$(SERVER_JWT_MASTER_KEY)",
        "GOOGLE_API_KEY": "$(GOOGLE_API_KEY)",
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": ["kakao$(KAKAO_APP_KEY)"]
            ]
        ],
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "kakao$(KAKAO_APP_KEY)", "googlechromes", "comgooglemaps"],
        "App Transport Security Settings": ["Allow Arbitrary Loads": true],
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "UIAppFonts": [
            "Item 0": "Pretendard-Medium.otf",
            "Item 1": "Pretendard-Regular.otf",
            "Item 2": "Pretendard-SemiBold.otf",
            "Item 3": "Pretendard-Bold.otf"
        ]
    ]


    let dependencies: [TargetDependency] = [
        .external(name: "Moya"),
        .external(name: "Alamofire"),
        .external(name: "RxMoya"),
        .external(name: "SnapKit"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxGesture"),
        .external(name: "RxDataSources"),
        .external(name: "ReactorKit"),
        .external(name: "Then"),
        .external(name: "Lottie"),
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
        .external(name: "GoogleMaps"),
        .external(name: "Kingfisher"),
        .external(name: "KeychainAccess")
    ]

    func generateConfigurations() -> Settings {
        Settings.settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Release.xcconfig")),
        ])
    }

    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.jyp.\(bundleName)",
                deploymentTarget: .iOS(targetVersion: "14.0", devices: [.iphone]),
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/\(projectName)/Sources/**"],
                resources: "\(projectName)/\(projectName)/Resources/**",
                entitlements: "\(projectName)/\(projectName).entitlements",
                scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
                dependencies: dependencies
            ),

            Target(
                name: "\(projectName)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: "com.jyp.\(projectName).Tests",
                infoPlist: .default,
                sources: ["\(projectName)/\(projectName)Tests/**"],
                dependencies: [.target(name: "\(projectName)")]
            )
        ]
    }
}

// MARK: - Project

let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)
