//
//  CacheApp.swift
//  Caché
//
//  Created by Hariz Shirazi on 2023-03-02.
//

import LocalConsole
import SwiftUI

let appVersion = ((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown") + " (" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown") + ")")
let consoleManager = LCManager.shared
let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
// var escaped = false
// var has_cooked = false

@main
struct AppCommanderApp: App {
    init() {
//
    }

    @State var escaped = false
    @State var has_cooked = false
    var body: some Scene {
        WindowGroup {
            VStack {
                if escaped && has_cooked {
                    RootView()
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                print("AppCommander version \(appVersion)")

                DispatchQueue.global(qos: .background).sync {
                    MDC.top_secret_sauce { baked_goods in
                        has_cooked = true
                        if baked_goods == false {
                            DispatchQueue.main.async {
                                UIApplication.shared.alert(title: "Uh oh... 🏴‍☠️", body: "Looks like you're using a leaked build! Crashing in 5 seconds... Begone, pirate!", withButton: false)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000)) {
                                fatalError()
                            }
                        }
                    }
                }

                #if targetEnvironment(simulator)
                    escaped = true
                #else
                    if #available(iOS 16.2, *) {
                        // I'm sorry 16.2 dev beta 1 users, you are a vast minority.
                        print("Throwing not supported error (mdc patched)")
                        DispatchQueue.main.async {
                            UIApplication.shared.alert(title: "Not Supported", body: "This version of iOS is not supported.", withButton: false)
                        }
                        escaped = false
                    } else {
                        // grant r/w access
                        if #available(iOS 15, *) {
                            print("Escaping Sandbox...")
                            // asyncAfter(deadline: .now())
                            DispatchQueue.global(qos: .userInitiated).sync {
                                grant_full_disk_access { error in
                                    if error != nil {
                                        print("Unable to escape sandbox!! Error: ", String(describing: error?.localizedDescription ?? "unknown?!"))
                                        DispatchQueue.main.async {
                                            UIApplication.shared.alert(title: "Unsandboxing Error", body: "Error: \(String(describing: error?.localizedDescription))\nPlease close the app and retry.", withButton: false)
                                        }
                                        escaped = false
                                    } else {
                                        print("Successfully escaped sandbox!")
                                        escaped = true
                                    }
                                }
                            }
                        }
                    }
                #endif

                let userDefaults = UserDefaults.standard
                // check for updates. this would be replaced by kouyou but its JUST NOT FINISHED!!!!!!!!!!!!!!
                // F1shy I'm begging you PLEASE just FINISH the frontend PLEASE
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let url = URL(string: "https://api.github.com/repos/BomberFish/AppCommander/releases/latest") {
                    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                        guard let data = data else { return }

                        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            if (json["tag_name"] as? String)?.replacingOccurrences(of: "v", with: "").compare(version, options: .numeric) == .orderedDescending {
                                print("Update found: \(appVersion) -> \(json["tag_name"] ?? "null")")
                                UIApplication.shared.confirmAlert(title: "Update available!", body: "A new app update is available, do you want to visit the releases page?", onOK: {
                                    UIApplication.shared.open(URL(string: "https://github.com/BomberFish/AppCommander/releases/latest")!)
                                }, noCancel: false)
                            }
                        }
                    }
                    task.resume()
                }

                Haptic.shared.notify(.success)
                consoleManager.isVisible = userDefaults.bool(forKey: "LCEnabled")
                // i just copied the entire code block, prints and everything, from stackoverflow.
                // Will I change it at all? No!
                if launchedBefore {
                    print("Not first launch.")
                    UIApplication.shared.alert(title: "⚠️ IMPORTANT ⚠️", body: "This app is still very much in development. If anything happens to your device, I will point and laugh at you.")
                } else {
                    print("First launch, setting UserDefault.")
                    // FIXME: body really sucks
                    UIApplication.shared.choiceAlert(title: "Analytics", body: "Allow AppCommander to send anonymized data to improve your experience?", yesAction: {
                        userDefaults.set(1, forKey: "analyticsLevel")
                        userDefaults.set(true, forKey: "launchedBefore")
                    }, noAction: {
                        userDefaults.set(0, forKey: "analyticsLevel")
                        userDefaults.set(true, forKey: "launchedBefore")
                    })
                }
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        MDC.isMDCSafe = false
    }
}
