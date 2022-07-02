//
// Created by Dossymkhan Zhulamanov on 02.07.2022.
//

import Foundation
import CoreData

protocol CoreDataViewModel {

}

class DefaultCoreDataViewModel: CoreDataViewModel {
    var container = AppDelegate.sharedAppDelegate.coreDataStack

    init() {
        container.managedContext
    }
}