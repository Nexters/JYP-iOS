import ProjectDescription

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMinor(from: "15.0.0")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxGesture.git", requirement: .upToNextMinor(from: "4.0.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMinor(from: "3.2.0")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .upToNextMinor(from: "3.0.0")),
    .remote(url: "https://github.com/kakao/kakao-ios-sdk", requirement: .upToNextMinor(from: "2.11.0")),
    .remote(url: "https://github.com/YAtechnologies/GoogleMaps-SP.git", requirement: .upToNextMinor(from: "6.0.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .upToNextMinor(from: "5.0.0")),
    .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.0.0")),
    .remote(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", requirement: .upToNextMajor(from: "4.2.2")),
    .remote(url: "https://github.com/airbnb/lottie-spm.git", requirement: .upToNextMajor(from: "4.1.2"))
])

let dependencies = Dependencies(
    swiftPackageManager: spm,
    platforms: [.iOS]
)
