//
//  Environment.swift
//  CardX-iOS
//
//  Created by Huong Nguyen on 06/12/2021.
//

import Foundation

class Environment {
    private static let infoDictionary: [String: Any] = {
      guard let dict = Bundle.main.infoDictionary else {
        fatalError("Plist file not found")
      }
      return dict
    }()

    static let rootURL: String = {
      guard let rootURLstring = Environment.infoDictionary["ROOT_URL"] as? String else {
        fatalError("Root URL not set in plist for this environment")
      }
      guard let url = URL(string: rootURLstring) else {
        fatalError("Root URL is invalid")
      }
        return url.description
    }()

    static let googleConfig : String = {
        guard let name = Environment.infoDictionary["GOOGLE_PLIST_FILE_NAME"] as? String else {
          fatalError("Root URL not set in plist for this environment")
        }
        return name
    }()

}
