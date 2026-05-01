import Foundation

enum ExportFormat: String, CaseIterable, Identifiable {
    case vcf = "VCF"
    case csv = "CSV"
    
    var id: String { rawValue }
    
    var fileExtension: String {
        switch self {
        case .vcf: return "vcf"
        case .csv: return "csv"
        }
    }
    
    var mimeType: String {
        switch self {
        case .vcf: return "text/vcard"
        case .csv: return "text/csv"
        }
    }
    
    var description: String {
        switch self {
        case .vcf: return "vCard format, compatible with all contact apps"
        case .csv: return "Comma-separated values, for spreadsheets"
        }
    }
}
