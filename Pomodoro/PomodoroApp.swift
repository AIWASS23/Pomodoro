//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Marcelo de Araújo on 06/03/24.
//

import SwiftUI
import SwiftData
import TipKit



@main
class AppDelegate: NSObject, UIApplicationDelegate {
    
    @State var pomodoroModel : PomodoroModel = .init()
    
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Note.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        window.rootViewController = UIHostingController(rootView:
            ContentView()
            .task {
                do {
                    try Tips.configure([
                        Tips.ConfigurationOption
                            .datastoreLocation(.applicationDefault)])
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            .environment(pomodoroModel)
            .modelContainer(sharedModelContainer)
            .preferredColorScheme(.light)
            
        )
        window.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        do {
            print("I'm in \n")
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let importedNote = try decoder.decode(Note.self, from: data)
            print(importedNote.title ??  "test")
            
            
            let newItem = Note(timestamp: importedNote.timestamp!, image: importedNote.image!, tag: importedNote.tag ?? "Missing tag", title: importedNote.title ?? "Untitled")
            sharedModelContainer.mainContext.insert(newItem)
            
            
        } catch {
            print("Unable to load data: \(error)")
        }
        
        return true
    }
    
    
    
}
