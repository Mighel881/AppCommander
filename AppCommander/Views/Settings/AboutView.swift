//
//  AboutView.swift
//  AppCommander
//
//  Created by Hariz Shirazi on 2023-06-03.
//

import SwiftUI

struct AboutView: View {
    
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    @Environment(\.colorScheme) var colorScheme
    struct Contribution: Identifiable, Equatable, Hashable {
        var id = UUID()
        let name: String
        let url: String
        let contribution: String
        let image: String
    }
    
    let contribs: [Contribution] = [Contribution(name: "BomberFish", url: "https://bomberfish.ca", contribution: "Main Developer", image: "bomberfish"), Contribution(name: "sourcelocation", url: "https://github.com/sourcelocation", contribution: "ApplicationManager, Various Code Snippets, Appabetical", image: "suslocation"), Contribution(name: "Avangelista", url: "https://github.com/Avangelista", contribution: "Appabetical", image: "floppa"), Contribution(name: "Nathan", url: "https://github.com/verygenericname", contribution: "JIT Implementation", image: "nathan"), Contribution(name: "haxi0", url: "https://haxi0.space", contribution: "DirtyJIT", image: "hax"), Contribution(name: "Mineek", url: "https://github.com/Mineek", contribution: "Filebrowser", image: "minek"), Contribution(name: "Serena", url: "https://github.com/SerenaKit", contribution: "Backup System", image: "serena"), Contribution(name: "LeminLimez", url: "https://github.com/leminlimez", contribution: "Tools Grid UI, MDC RAM safety, LSApplicationWorkspace header, Various Code snippets", image: "lemon"), Contribution(name: "sneakyf1shy", url: "https://github.com/f1shy-dev", contribution: "Analytics, Bugfixes", image: "other_fish"), Contribution(name: "zhuowei", url: "https://worthdoingbadly.com", contribution: "Unsandboxing, installd patch, WDBDISSH", image: "zhuowei")]
    var body: some View {
        VStack {
            VStack {
                Image("Default")
                    .resizable()
                    .scaledToFill() // add if you need
                    .frame(width: 84.0, height: 84.0) // as per your requirement
                    .clipped()
                    .cornerRadius(18)
                Text("AppCommander \(version)")
                    .font(.title)
                Text(build)
                    .font(.caption)
                    .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                Text("")
                HStack {
                    if colorScheme == .dark {
                        Image("AbsoluteSolver")
                            .resizable()
                            .antialiased(false)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, -4)
                        Text("Powered by AbsoluteSolver")
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .font(.system(.footnote, design: .monospaced))
                    } else {
                        Image("AbsoluteSolver")
                            .resizable()
                            .antialiased(false)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, -4)
                            .colorInvert()
                        Text("Powered by AbsoluteSolver")
                            .foregroundColor(.black)
                            .lineLimit(1)
                            .font(.system(.footnote, design: .monospaced))
                    }
                }
                .opacity(0.75)
            }
            List {
                Section {
                    ForEach(contribs) { contrib in
                        LinkCell(imageName: contrib.image, url: contrib.url, title: contrib.name, contribution: contrib.contribution)
                    }
                    NavigationLink {
                        TranslatorsView()
                    } label: {
                        Label("Translators", systemImage: "character.bubble")
                    }
                    NavigationLink {
                        PackageCreditsView()
                    } label: {
                        Label("Swift Packages", systemImage: "shippingbox")
                    }
                } header: {
                    Label("Credits", systemImage: "heart")
                }
            }
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}