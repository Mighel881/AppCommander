//
//  AbsoluteSolver.swift
//  AppCommander
//
//  Created by Hariz Shirazi on 2023-03-30.
//

import Foundation
import SwiftUI


// Absolute Solver: A file manager that will modify/delete files By Any Means Necessary™
public struct AbsoluteSolver {
    // replace files
    public static func replace(at: URL, with: NSData) -> Bool {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                if MDC.isMDCSafe {
                    print("[AbsoluteSolver] Using MDC method")
                    return MDCModify.replace(at: at, with: with)
                } else {
                    print("[AbsoluteSolver] PANIC!!! OUT OF RAM!!! THIS IS REALLY REALLY REALLY BAD!!!!!")
                    Haptic.shared.notify(.error)
                    UIApplication.shared.alert(body: "AbsoluteSolver: Overwrite failed!\nInsufficient RAM! Please reopen the app.", withButton: false)
                }
            } else if owner == "mobile" {
                print("[AbsoluteSolver] Using FM method")
                return FMModify.replace(at: at, with: with)
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner?!")
                Haptic.shared.notify(.error)
                UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nCould not find owner?!")
            } else {
                print("[AbsoluteSolver] Error: Unexpected owner!")
                Haptic.shared.notify(.error)
                UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nUnexpected file owner!")
            }
        } catch {
            print("[AbsoluteSolver] Error: \(error.localizedDescription)")
            Haptic.shared.notify(.error)
            UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)")
        }
        return false
    }
    
    // chainsaw hand time
    public static func delete(at: URL) -> Bool {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: at.path)
            let owner = fileAttributes[.ownerAccountName] as? String ?? "unknown"
            if owner == "root" {
                print("[AbsoluteSolver] Using MDC method")
                return MDCModify.delete(at: at)
            } else if owner == "mobile" {
                print("[AbsoluteSolver] Using FM method")
                return FMModify.delete(at: at)
            } else if owner == "unknown" {
                print("[AbsoluteSolver] Error: Could not find owner?!")
                Haptic.shared.notify(.error)
                UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nCould not find owner?!")
            } else {
                print("[AbsoluteSolver] Error: Unexpected owner!")
                Haptic.shared.notify(.error)
                UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\nUnexpected file owner!")
            }
        } catch {
            print("[AbsoluteSolver] Error: \(error.localizedDescription)")
            Haptic.shared.notify(.error)
            UIApplication.shared.alert(body: "Error replacing file at \(at.path) (Edit Style: AbsoluteSolver)\n\(error.localizedDescription)")
        }
        return false
    }
}
