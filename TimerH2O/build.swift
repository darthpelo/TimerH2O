import ShellOut
import Foundation

let arguments = CommandLine.arguments

guard arguments.count > 1 else {
    print("👮  No Fastlane number given")
    exit(1)
}

let lane = arguments[1]

if lane == "1" {
  do {
    try shellOut(to: "bundle exec fastlane release")
  } catch {
      let error = error as! ShellOutError
      print(error.message) // Prints STDERR
      print(error.output) // Prints STDOUT
  }
} else {
  exit(1)
}
