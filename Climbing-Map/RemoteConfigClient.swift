//
//  RemoteConfigClient.swift
//  Climbing-Map
//
//  Created by riku on 2021/05/02.
//

import Foundation
import Firebase

enum RemoteConfigParameterKey: String, CaseIterable {
    case meintenance = "meintenance"
}

//struct ServerMaintenanceConfig: Codable {
//    let isMaintenance: Bool
//    let title: String
//    let message: String
//}
//
//protocol RemoteConfigClientProtocol {
//    func fetchServerMaintenanceConfig(succeeded: @escaping (ServerMaintenanceConfig) -> Void, failed: @escaping (String) -> Void)
//}

class RemoteConfigClient {

//    func fetchMaintenance() -> ServerMaintenanceConfig {
//        let remoteConfig = RemoteConfig.remoteConfig()
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0; // for test
//        remoteConfig.configSettings = settings
//        remoteConfig.fetch() { (status, error) -> Void in
//            guard status == .success else {
//                return
//            }
//            remoteConfig.activate() { (changed, error) in
//                guard let fetchedString = remoteConfig.configValue(forKey: "maintenance").stringValue else {
//                    return
//                }
//                let data = fetchedString.data(using: .utf8)!
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                do {
//                    return try decoder.decode(ServerMaintenanceConfig.self, from: data)
//                } catch {
//                    return ServerMaintenanceConfig()
//                }
//
//            }
//        }
//    }
}
