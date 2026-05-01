import Contacts
import Foundation

final class VCFGenerator {
    static func generate(contacts: [CNContact]) -> Data? {
        var vcardString = ""
        for contact in contacts {
            vcardString += vCardString(for: contact)
        }
        return vcardString.data(using: .utf8)
    }
    
    static func vCardString(for contact: CNContact) -> String {
        var lines: [String] = []
        lines.append("BEGIN:VCARD")
        lines.append("VERSION:3.0")
        lines.append("PRODID:-//ContactVault//EN")
        lines.append("UID:\(escapeVCF(contact.identifier))")
        
        if !contact.givenName.isEmpty || !contact.familyName.isEmpty {
            let nameComponents = [
                escapeVCF(contact.familyName),
                escapeVCF(contact.givenName),
                escapeVCF(contact.middleName),
                escapeVCF(contact.namePrefix),
                escapeVCF(contact.nameSuffix)
            ]
            lines.append("N:\(nameComponents.joined(separator: ";"))")
            
            var fullName = contact.namePrefix
            if !fullName.isEmpty { fullName += " " }
            fullName += contact.givenName
            if !contact.middleName.isEmpty { fullName += " " + contact.middleName }
            if !contact.familyName.isEmpty { fullName += " " + contact.familyName }
            if !contact.nameSuffix.isEmpty { fullName += " " + contact.nameSuffix }
            lines.append("FN:\(escapeVCF(fullName))")
        }
        
        if !contact.organizationName.isEmpty {
            lines.append("ORG:\(escapeVCF(contact.organizationName))")
        }
        if !contact.jobTitle.isEmpty {
            lines.append("TITLE:\(escapeVCF(contact.jobTitle))")
        }
        if !contact.departmentName.isEmpty {
            lines.append("ROLE:\(escapeVCF(contact.departmentName))")
        }
        
        for phone in contact.phoneNumbers {
            let label = mapPhoneLabel(phone.label)
            let number = escapeVCF(phone.value.stringValue)
            lines.append("TEL;TYPE=\(label):\(number)")
        }
        
        for email in contact.emailAddresses {
            let label = mapEmailLabel(email.label)
            let address = escapeVCF(email.value as String)
            lines.append("EMAIL;TYPE=\(label):\(address)")
        }
        
        for address in contact.postalAddresses {
            let label = mapAddressLabel(address.label)
            let value = address.value
            let street = escapeVCF(value.street)
            let city = escapeVCF(value.city)
            let state = escapeVCF(value.state)
            let postalCode = escapeVCF(value.postalCode)
            let country = escapeVCF(value.country)
            lines.append("ADR;TYPE=\(label):;;\(street);\(city);\(state);\(postalCode);\(country)")
        }
        
        for url in contact.urlAddresses {
            let urlString = escapeVCF(url.value as String)
            lines.append("URL:\(urlString)")
        }
        
        lines.append("END:VCARD")
        return lines.joined(separator: "\r\n") + "\r\n"
    }
    
    static func escapeVCF(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: ",", with: "\\,")
            .replacingOccurrences(of: ";", with: "\\;")
            .replacingOccurrences(of: "\n", with: "\\n")
    }
    
    static func mapPhoneLabel(_ label: String?) -> String {
        guard let label = label else { return "CELL" }
        if label == CNLabelPhoneNumberMain { return "MAIN" }
        if label == CNLabelPhoneNumberMobile { return "CELL" }
        if label == CNLabelPhoneNumberHomeFax { return "HOME,FAX" }
        if label == CNLabelPhoneNumberWorkFax { return "WORK,FAX" }
        if label == CNLabelHome { return "HOME" }
        if label == CNLabelWork { return "WORK" }
        if label == CNLabelOther { return "OTHER" }
        return "CELL"
    }
    
    static func mapEmailLabel(_ label: String?) -> String {
        guard let label = label else { return "INTERNET" }
        if label == CNLabelHome { return "HOME,INTERNET" }
        if label == CNLabelWork { return "WORK,INTERNET" }
        return "INTERNET"
    }
    
    static func mapAddressLabel(_ label: String?) -> String {
        guard let label = label else { return "HOME" }
        if label == CNLabelHome { return "HOME" }
        if label == CNLabelWork { return "WORK" }
        return "OTHER"
    }
}
