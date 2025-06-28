//
//  LegalDirectoryView.swift
//  RefugeGuide
//
//  Created by Djibal Ramazani on 22/06/2025.
//

import SwiftUI
import SwiftUICore

struct LegalDirectoryView: View {
    @State private var searchText = ""
    @State private var selectedSpecialty: LegalSpecialty = .all
    @State private var selectedLanguage: String = "Any"
    @State private var showFilters = false
    
    let languages = ["Any", "English", "Arabic", "Farsi", "French", "Ukrainian", "Urdu"]
    let professionals = sampleLegalProfessionals
    
    var filteredProfessionals: [LegalProfessional] {
        var result = professionals
        
        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.organization.localizedCaseInsensitiveContains(searchText) ||
                $0.specialties.contains(where: { $0.rawValue.localizedCaseInsensitiveContains(searchText) })
            }
        }
        
        // Apply specialty filter
        if selectedSpecialty != .all {
            result = result.filter { $0.specialties.contains(selectedSpecialty) }
        }
        
        // Apply language filter
        if selectedLanguage != "Any" {
            result = result.filter { $0.languages.contains(selectedLanguage) }
        }
        
        return result
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText, placeholder: "Search legal professionals...")
                    .padding()
                
                FilterBar(
                    selectedSpecialty: $selectedSpecialty,
                    showFilters: $showFilters
                )
                
                if filteredProfessionals.isEmpty {
                    EmptyResultsView()
                } else {
                    List(filteredProfessionals) { professional in
                        NavigationLink(destination: ProfessionalDetailView(professional: professional)) {
                            ProfessionalRow(professional: professional)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Legal Directory")
            .sheet(isPresented: $showFilters) {
                LegalFiltersView(
                    selectedSpecialty: $selectedSpecialty,
                    selectedLanguage: $selectedLanguage,
                    languages: languages
                )
            }
        }
    }
}

struct FilterBar: View {
    @Binding var selectedSpecialty: LegalSpecialty
    @Binding var showFilters: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                Button(action: { selectedSpecialty = .all }) {
                    FilterPill(
                        title: "All",
                        isSelected: selectedSpecialty == .all
                    )
                }
                
                ForEach(LegalSpecialty.allCases.filter { $0 != .all }) { specialty in
                    Button(action: { selectedSpecialty = specialty }) {
                        FilterPill(
                            title: specialty.rawValue,
                            isSelected: selectedSpecialty == specialty
                        )
                    }
                }
                
                Button(action: { showFilters = true }) {
                    HStack {
                        Image(systemName: "line.3.horizontal.decrease")
                        Text("More Filters")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 5)
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.footnote)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
    }
}

struct ProfessionalRow: View {
    let professional: LegalProfessional
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: "person.crop.square")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
                .padding(5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(professional.name)
                    .font(.headline)
                
                Text(professional.organization)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                SpecialtyTags(specialties: professional.specialties)
                
                LanguageTags(languages: professional.languages)
            }
            
            Spacer()
            
            VStack {
                if professional.isAvailableToday {
                    AvailabilityBadge(isAvailable: true)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

struct SpecialtyTags: View {
    let specialties: [LegalSpecialty]
    
    var body: some View {
        FlowLayout(spacing: 5) {
            ForEach(specialties, id: \.self) { specialty in
                Text(specialty.rawValue)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(specialty.color.opacity(0.1))
                    .foregroundColor(specialty.color)
                    .cornerRadius(5)
            }
        }
    }
}

struct LanguageTags: View {
    let languages: [String]
    
    var body: some View {
        FlowLayout(spacing: 5) {
            ForEach(languages, id: \.self) { language in
                Text(language)
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(5)
            }
        }
    }
}

struct AvailabilityBadge: View {
    let isAvailable: Bool
    
    var body: some View {
        Text(isAvailable ? "Available Today" : "Booked")
            .font(.caption2)
            .padding(5)
            .background(isAvailable ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
            .foregroundColor(isAvailable ? .green : .gray)
            .cornerRadius(5)
    }
}

struct ProfessionalDetailView: View {
    let professional: LegalProfessional
    @State private var showScheduleSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HeaderView()
                
                SpecialtiesSection()
                
                LanguagesSection()
                
                AboutSection()
                
                AppointmentSection()
            }
            .padding()
        }
        .navigationTitle(professional.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showScheduleSheet) {
            ConsultationScheduleView()
        }
    }
    
    private func HeaderView() -> some View {
        HStack(alignment: .top) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(5)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(professional.name)
                    .font(.title2)
                    .bold()
                
                Text(professional.organization)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                if professional.isAvailableToday {
                    AvailabilityBadge(isAvailable: true)
                        .padding(.top, 5)
                }
                
                RatingView(rating: professional.rating, reviewCount: professional.reviewCount)
                    .padding(.top, 5)
            }
            
            Spacer()
        }
    }
    
    private func SpecialtiesSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Specialties")
                .font(.headline)
            
            FlowLayout(spacing: 10) {
                ForEach(professional.specialties, id: \.self) { specialty in
                    Text(specialty.rawValue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(specialty.color.opacity(0.1))
                        .foregroundColor(specialty.color)
                        .cornerRadius(20)
                }
            }
        }
    }
    
    private func LanguagesSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Languages")
                .font(.headline)
            
            FlowLayout(spacing: 10) {
                ForEach(professional.languages, id: \.self) { language in
                    Text(language)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                }
            }
        }
    }
    
    private func AboutSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("About")
                .font(.headline)
            
            Text(professional.bio)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private func AppointmentSection() -> some View {
        VStack(spacing: 15) {
            Button(action: { showScheduleSheet = true }) {
                Text("Schedule Consultation")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: { callNumber(phoneNumber: professional.phone) }) {
                Text("Call Office: \(professional.phone)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .foregroundColor(.green)
                    .cornerRadius(10)
            }
        }
        .padding(.top)
    }
    
    private func callNumber(phoneNumber: String) {
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(cleanNumber)") {
            UIApplication.shared.open(url)
        }
    }
}

struct RatingView: View {
    let rating: Double
    let reviewCount: Int
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(1..<6) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(index <= Int(rating) ? .yellow : .gray)
            }
            
            Text(String(format: "%.1f", rating))
                .bold()
            
            Text("(\(reviewCount) reviews)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct LegalFiltersView: View {
    @Binding var selectedSpecialty: LegalSpecialty
    @Binding var selectedLanguage: String
    let languages: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Specialty")) {
                    Picker("Legal Specialty", selection: $selectedSpecialty) {
                        ForEach(LegalSpecialty.allCases, id: \.self) { specialty in
                            Text(specialty.rawValue).tag(specialty)
                        }
                    }
                }
                
                Section(header: Text("Language")) {
                    Picker("Spoken Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                }
                
                Section {
                    Button("Apply Filters") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct EmptyResultsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue.opacity(0.5))
                .padding(.top, 50)
            
            Text("No Professionals Found")
                .font(.title2)
                .bold()
            
            Text("Try adjusting your search criteria or filters")
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

// MARK: - Models
struct LegalProfessional: Identifiable {
    let id = UUID()
    let name: String
    let organization: String
    let specialties: [LegalSpecialty]
    let languages: [String]
    let rating: Double
    let reviewCount: Int
    let phone: String
    let bio: String
    let isAvailableToday: Bool
}

enum LegalSpecialty: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }

    case all = "All"
    case asylum = "Asylum Law"
    case immigration = "Immigration"
    case humanRights = "Human Rights"
    case family = "Family Law"
    case housing = "Housing"
    case employment = "Employment"
    case benefits = "Benefits"

    var color: Color {
        switch self {
        case .all: return .blue
        case .asylum: return .green
        case .immigration: return .purple
        case .humanRights: return .orange
        case .family: return .pink
        case .housing: return .teal
        case .employment: return .indigo
        case .benefits: return .mint
        }
    }
}


let sampleLegalProfessionals = [
    LegalProfessional(
        name: "Sarah Johnson",
        organization: "Refugee Legal Aid UK",
        specialties: [.asylum, .immigration],
        languages: ["English", "Arabic", "French"],
        rating: 4.8,
        reviewCount: 42,
        phone: "+44 20 7123 4567",
        bio: "Specialized in asylum cases with over 10 years of experience. Committed to helping refugees navigate the UK legal system.",
        isAvailableToday: true
    ),
    LegalProfessional(
        name: "David Chen",
        organization: "Human Rights Legal Practice",
        specialties: [.humanRights, .asylum],
        languages: ["English", "Mandarin", "Cantonese"],
        rating: 4.9,
        reviewCount: 38,
        phone: "+44 20 7654 3210",
        bio: "Human rights lawyer focusing on asylum seekers' rights. Formerly worked with UNHCR in refugee camps.",
        isAvailableToday: false
    )
]

// Flow layout for tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight + spacing
                totalWidth = max(totalWidth, lineWidth)
                lineWidth = 0
                lineHeight = 0
            }
            
            lineWidth += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        
        totalHeight += lineHeight
        totalWidth = max(totalWidth, lineWidth - spacing)
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var lineHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += lineHeight + spacing
                lineHeight = 0
            }
            
            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )
            
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
    }
}
