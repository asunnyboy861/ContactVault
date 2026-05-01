import SwiftUI

struct ContactSupportView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var topic = "General"
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var showError = false
    
    private let topics = ["General", "Bug Report", "Feature Request", "Backup Issue", "Restore Issue", "Other"]
    
    var body: some View {
        Form {
            topicSection
            nameSection
            emailSection
            messageSection
            submitSection
        }
        .navigationTitle("Contact Support")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Sent!", isPresented: $showSuccess) {
            Button("OK") {
                name = ""
                email = ""
                message = ""
                topic = "General"
            }
        } message: {
            Text("Your message has been sent successfully.")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Failed to send message. Please try again.")
        }
    }
    
    private var topicSection: some View {
        Section("Topic") {
            Picker("Topic", selection: $topic) {
                ForEach(topics, id: \.self) { t in
                    Text(t).tag(t)
                }
            }
        }
    }
    
    private var nameSection: some View {
        Section("Name (Optional)") {
            TextField("Your name", text: $name)
        }
    }
    
    private var emailSection: some View {
        Section("Email") {
            TextField("your@email.com", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .autocapitalization(.none)
        }
    }
    
    private var messageSection: some View {
        Section("Message") {
            TextEditor(text: $message)
                .frame(minHeight: 100)
        }
    }
    
    private var submitSection: some View {
        Section {
            Button {
                submitFeedback()
            } label: {
                HStack {
                    if isSubmitting {
                        ProgressView()
                            .tint(.white)
                    }
                    Text("Submit")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isSubmitting || email.isEmpty || message.isEmpty)
        }
    }
    
    private func submitFeedback() {
        isSubmitting = true
        
        let feedbackURL = "https://formspree.io/f/xwpkkqjp"
        
        guard let url = URL(string: feedbackURL) else {
            isSubmitting = false
            showError = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "ContactVault"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil {
                    showSuccess = true
                } else {
                    showError = true
                }
            }
        }.resume()
    }
}
