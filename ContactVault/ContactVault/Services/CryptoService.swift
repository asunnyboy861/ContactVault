import CryptoKit
import Foundation

final class CryptoService {
    static func encrypt(data: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined ?? Data()
    }
    
    static func decrypt(data: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    static func deriveKey(from password: String) -> SymmetricKey {
        let passwordData = password.data(using: .utf8)!
        let hashed = SHA256.hash(data: passwordData)
        return SymmetricKey(data: hashed)
    }
}
