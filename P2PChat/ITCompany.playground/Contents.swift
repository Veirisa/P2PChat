import UIKit


class Company {
    var ceo: CEO?
    var manager: Manager?
    var developers: Developers?
    
    deinit {
        print("Company deinit")
    }
}

class CEO {
    var manager: Manager?

    deinit {
        print("CEO deinit")
    }
    
    // MARK: CEO actions

    func printManager() {
        print("------ Manager from \(self) ------")
        print("Manager:")
        if let manager = manager {
            print(manager)
        } else {
            print("doesn't exist")
        }
    }

    func askManagerPrintDevelopers() {
        let printDevelopers = { (manager: Manager) -> Void in
            print("------ Developers from \(manager)  ------")
            print("Developers:")
            if let developers = manager.developers {
                for developer in developers.storage.values {
                    print("\(developer) [\(developer.id)]")
                }
            } else {
                print("dont't exist")
            }
        }
        manager?.doTaskFromCEO(task: printDevelopers)
    }

    func askManagerPrintCompany() {
        let printCompany = { (manager: Manager) -> Void in
            print("------ Company from \(manager) ------")
            print("CEO:")
            if let ceo = manager.ceo {
                print(ceo)
            } else {
                print("doesn't exist")
            }
            print("Manager:", "\(manager)", separator:"\n")
            print("Developers:")
            if let developers = manager.developers {
                for developer in developers.storage.values {
                    print("\(developer) [\(developer.id)]")
                }
            } else {
                print("dont't exist")
            }
        }
        manager?.doTaskFromCEO(task: printCompany)
    }
    
    // MARK: Developer speaking
    
    func listen(from developer: Developer, message: String) {
        print("CEO received message \"\(message)\" from Developer [\(developer.id)]")
    }
}

class Manager {
    weak var ceo: CEO?
    var developers: Developers?

    deinit {
        print("Manager deinit")
    }
    
    // MARK: CEO actions

    func doTaskFromCEO(task: (_ manager: Manager) -> Void) {
        task(self)
    }
    
    // MARK: Developer speaking
    
    func listen(from developer: Developer, message: String) {
        print("Manager received message \"\(message)\" from Developer [\(developer.id)]")
    }
    
    func askCEO() -> CEO? {
        return ceo
    }
    
    func askDeveloper(withId developerId: Int) -> Developer? {
        return developers?.storage[developerId]
    }
}

/*
 * Motivation: Company and Manager store references to the same object.
 */
class Developers {
    var storage: [Int: Developer] = [:]
    
    deinit {
        print("Developers deinit")
    }
}

class Developer {
    let id: Int
    weak var manager: Manager?

    init(id: Int) {
        self.id = id
    }

    deinit {
        print("Developer [\(id)] deinit")
    }
    
    // MARK: Developer speaking
    
    func listen(from developer: Developer, message: String) {
        print("Developer [\(id)] received message \"\(message)\" from Developer [\(developer.id)]")
    }
    
    func sayToCEO(message: String) {
        print("Developer [\(id)] sent message \"\(message)\" to CEO")
        let ceo = manager?.askCEO()
        ceo?.listen(from: self, message: message)
    }
    
    func sayToManager(message: String) {
        print("Developer [\(id)] sent message \"\(message)\" to Manager")
        manager?.listen(from: self, message: message)
    }
    
    func sayToDeveloper(withId developerId: Int, message: String) {
        print("Developer [\(id)] sent message \"\(message)\" to Developer [\(developerId)]")
        let developer = manager?.askDeveloper(withId: developerId)
        developer?.listen(from: self, message: message)
    }
}


func createCompany() -> Company {
    let ceo = CEO()
    let manager = Manager()
    ceo.manager = manager
    manager.ceo = ceo
    let developers = Developers()
    manager.developers = developers
    for id in 1...10 {
        let developer = Developer(id: id)
        developers.storage[id] = developer
        developer.manager = manager
    }
    let company = Company()
    company.ceo = ceo
    company.manager = manager
    company.developers = developers
    return company
}

func ceoActions(company: Company?) {
    let ceo = company?.ceo
    ceo?.printManager()
    print()
    ceo?.askManagerPrintDevelopers()
    print()
    ceo?.askManagerPrintCompany()
    print()
}

func developerSpeaking(company: Company?) {
    guard let developers = company?.developers else { return }
    guard let developerFrom = developers.storage.values.randomElement() else { return }
    developerFrom.sayToCEO(message: "Hello, CEO!")
    print()
    developerFrom.sayToManager(message: "Hello, Manager!")
    print()
    if let idDeveloperTo = developers.storage.keys.randomElement() {
        developerFrom.sayToDeveloper(withId: idDeveloperTo, message: "Hello, another Developer!")
    }
    print()
}

var company: Company? = createCompany()
ceoActions(company: company)
developerSpeaking(company: company)
company = nil
