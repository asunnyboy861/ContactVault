import Contacts
import Foundation

final class CSVGenerator {
    static func generate(contacts: [CNContact]) -> Data? {
        let header = "First Name,Last Name,Organization,Job Title,Phone,Email,Street,City,State,Zip,Country"
        var rows = [header]
        
        for contact in contacts {
            let phones = contact.phoneNumbers.map { $0.value.stringValue }.joined(separator: " | ")
            let emails = contact.emailAddresses.map { $0.value as String }.joined(separator: " | ")
            
            let row = [
                escapeCSV(contact.givenName),
                escapeCSV(contact.familyName),
                escapeCSV(contact.organizationName),
                escapeCSV(contact.jobTitle),
                escapeCSV(phones),
                escapeCSV(emails),
                escapeCSV(contact.postalAddresses.first?.value.street ?? ""),
                escapeCSV(contact.postalAddresses.first?.value.city ?? ""),
                escapeCSV(contact.postalAddresses.first?.value.state ?? ""),
                escapeCSV(contact.postalAddresses.first?.value.postalCode ?? ""),
                escapeCSV(contact.postalAddresses.first?.value.country ?? "")
            ].joined(separator: ",")
            
            rows.append(row)
        }
        
        let csvContent = rows.joined(separator: "\n")
        return csvContent.data(using: .utf8)
    }
    
    static func escapeCSV(_ string: String) -> String {
        if string.contains(",") || string.contains("\"") || string.contains("\n") {
            return "\"" + string.replacingOccurrences(of: "\"", with: "\"\"") + "\""
        }
        return string
    }
}
