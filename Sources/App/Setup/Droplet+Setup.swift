@_exported import Vapor
import Jobs

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        // Do any additional droplet setup
        
        // Workout Reader job
        let feeds = (config["sources", "feeds"]?.array ?? []).flatMap({ WorkoutReaderSource(config: $0) })
        Jobs.add(interval: .seconds(30)) {
            let readerService = WorkoutReaderService(for: feeds)
            readerService.updateAll()
        }
    }
}
