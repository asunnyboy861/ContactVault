import Contacts
import Foundation

final class ContactService {
    static let shared = ContactService()
    private let store = CNContactStore()
    
    private init() {}
    
    func requestAccess() async -> Bool {
        do {
            return try await store.requestAccess(for: .contacts)
        } catch {
            return false
        }
    }
    
    private let safeKeys: [CNKeyDescriptor] = [
        CNContactIdentifierKey as CNKeyDescriptor,
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactMiddleNameKey as CNKeyDescriptor,
        CNContactNamePrefixKey as CNKeyDescriptor,
        CNContactNameSuffixKey as CNKeyDescriptor,
        CNContactNicknameKey as CNKeyDescriptor,
        CNContactOrganizationNameKey as CNKeyDescriptor,
        CNContactJobTitleKey as CNKeyDescriptor,
        CNContactDepartmentNameKey as CNKeyDescriptor,
        CNContactPhoneNumbersKey as CNKeyDescriptor,
        CNContactEmailAddressesKey as CNKeyDescriptor,
        CNContactPostalAddressesKey as CNKeyDescriptor,
        CNContactUrlAddressesKey as CNKeyDescriptor,
        CNContactTypeKey as CNKeyDescriptor
    ]
    
    func fetchAllContacts() async throws -> [CNContact] {
        try await Task.detached { [store, safeKeys] in
            let request = CNContactFetchRequest(keysToFetch: safeKeys)
            var contacts: [CNContact] = []
            
            try store.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
            
            return contacts.sorted {
                ($0.familyName + $0.givenName) < ($1.familyName + $1.givenName)
            }
        }.value
    }
    
    func getContactCount() async throws -> Int {
        try await Task.detached { [store] in
            let keys: [CNKeyDescriptor] = [CNContactIdentifierKey as CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            var count = 0
            try store.enumerateContacts(with: request) { _, _ in
                count += 1
            }
            return count
        }.value
    }
}
