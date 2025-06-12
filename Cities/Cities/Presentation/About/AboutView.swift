//
//  AboutView.swift
//  Cities
//
//  Created by Gonza Giampietri on 12/06/2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(Strings.About.aboutThisApp)
                        .font(.title2.bold())
                    
                    Text(Strings.About.description)
                    
                    Divider()

                    Text("📞 Contact")
                        .font(.title2.bold())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label(Strings.About.phone, systemImage: "phone")
                        Label(Strings.About.email, systemImage: "envelope")
                        if let githubUrl = URL(string: Strings.About.Links.github) {
                            Link(destination: githubUrl) {
                                Label(title: { Text(Strings.About.github) }, icon: {
                                    Image(.github)
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                })
                            }
                        }
                        
                        if let githubUrl = URL(string: Strings.About.Links.linkedin) {
                            Link(destination: githubUrl) {
                                Label(title: { Text(Strings.About.linkedin) }, icon: {
                                    Image(.linkedin)
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                })
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(Strings.About.title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.About.closeButoonText) {
                        dismiss()
                    }
                    
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
