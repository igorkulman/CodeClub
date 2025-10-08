import Foundation

let arguments = CommandLine.arguments

let filePath: String
switch arguments.count {
case 2:
    filePath = arguments[1]
default:
    print("Usage: swift patrik-insane-cryptographic-authentication.swift <file>")
    exit(0)
}

let url = URL(string: "https://code-club-website.patrik-dvoracek.workers.dev/rest/puzzle/2025/september/auth")!
let content = try String(contentsOfFile: filePath, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines)
let parts = content.split(separator: ":")
let username = parts[0]
let password = parts[1]

func createRequest<T: Encodable>(body: T) throws -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("igor", forHTTPHeaderField: "X-Cookie-User")
    request.httpMethod = "POST"
    request.httpBody = try JSONEncoder().encode(body)
    return request
}

struct AuthRequest: Encodable {
    let username: String
    let password: String
    let type = "credentials"
}

struct AuthResponse: Decodable {
    let token: String
}

let (authData, _) = try await URLSession.shared.data(for: createRequest(body: AuthRequest(username: String(username), password: String(password))))
let token = try JSONDecoder().decode(AuthResponse.self, from: authData).token

let alphabet = "abcdefghijklmnopqrstuvwxyz"
let greetingToken = token.reduce(100) { sum, char in
    let lowercased = Character(char.lowercased())
    guard let index = alphabet.firstIndex(of: lowercased) else {
        return sum
    }
    let indexValue = alphabet.distance(from: alphabet.startIndex, to: index)
    return ((sum + indexValue + 1) * Int(lowercased.asciiValue!)) % 4096
}

struct GreetingRequest: Encodable {
    let token: Int
    let type = "greeting"
}

struct GreetingResponse: Decodable {
    let result: String
}

let (greetingData, _) = try await URLSession.shared.data(for: createRequest(body: GreetingRequest(token: greetingToken)))
let result = try JSONDecoder().decode(GreetingResponse.self, from: greetingData).result
print(result)
