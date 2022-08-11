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

    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "googlechromes", "comgooglemaps"],
        "CFBundleURLTypes": ["CFBundleURLSchemes": ["kakao$(KAKAO_APP_KEY)"]],
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
        "App Transport Security Settings": ["Allow Arbitrary Loads": true],
        "NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true],
        "KAKAO_REST_KEY": "$(KAKAO_REST_KEY)",
        "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)",
        "SERVER_HOST": "$(SERVER_HOST)",
        "GOOGLE_API_KEY": "$(GOOGLE_API_KEY)",
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
        .external(name: "KakaoSDKCommon"),
        .external(name: "KakaoSDKAuth"),
        .external(name: "KakaoSDKUser"),
        .external(name: "GoogleMaps")
    ]
    
    func generateConfigurations() -> Settings {
        Settings.settings(configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Release.xcconfig")),
        ])
    }

//    func generateProjectSettings() -> Settings {
//        #if arch(x86_64)
//        return Settings.settings(base: [
//            "ONLY_ACTIVE_ARCH": "NO",
//            "EXCLUDED_ARCHS": "arm64",
//        ], configurations: [
//            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Debug.xcconfig")),
//            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Release.xcconfig")),
//        ], defaultSettings: .recommended)
//        #else
//        return Settings.settings(base: [
//            "ONLY_ACTIVE_ARCH": "NO",
//            "EXCLUDED_ARCHS": "arm64",
//        ], configurations: [
//            .debug(name: "Debug", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Debug.xcconfig")),
//            .release(name: "Release", xcconfig: .relativeToRoot("\(projectName)/\(projectName)/Sources/Config/Release.xcconfig")),
//        ], defaultSettings: .recommended)
//        #endif
//    }

    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.jyp.\(projectName)",
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
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)
