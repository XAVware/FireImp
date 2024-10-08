//
//  MenuView.swift
//  FireImp
//
//  Created by Ryan Smetana on 11/10/23.
//

import SwiftUI
import FirebaseAuth

@MainActor final class MenuViewModel: ObservableObject {
    @Published var remindersOn: Bool = true
    @Published var soundOn: Bool = true
    @Published var hapticsOn: Bool = true
    @Published var accLabelsOn: Bool = true
    
    @Binding var navPath: [ViewPath]
    
    init(navPath: Binding<[ViewPath]>) {
        self._navPath = navPath
    }
    
    func pushView(_ viewPath: ViewPath) {
        navPath.append(viewPath)
    }
    
    func logOut() {
        AuthService.shared.signout()
        navPath.removeAll()
        
        // TODO: Toggle Onboarding?
    }
}

struct MenuView: View {
    /// Menu components are equally spaced, `COMONENT_SPACING` ('x' from now on) away from eachother. The stack has 2x spacing. Stacked components (i.e. the Toggle label) have vertical padding of x.  The label in each component has x vertical padding.
    let COMPONENT_SPACING: CGFloat = 6
    @StateObject private var vm: MenuViewModel
    @StateObject var ENV: EnvironmentManager = EnvironmentManager.shared
    
    init(navPath: Binding<[ViewPath]>) {
        self._vm = StateObject(wrappedValue: MenuViewModel(navPath: navPath))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // 1. Account -- Only included if logged in, otherwise login/sign up button.
            VStack(spacing: COMPONENT_SPACING) {
                Button {
                    vm.pushView(.profileView)
                } label: {
                    Image(systemName: "person.fill")
                    Text("Profile")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, COMPONENT_SPACING)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.plain)
                .padding(.vertical, COMPONENT_SPACING)
                
                
            } //: VStack - Account Section
            .padding(.horizontal)
            .padding(.vertical, 12)
            .modifier(SubViewStyleMod())
            
            Spacer()
    
            
            // 4. Sign Out
            Button {
                vm.logOut()
            } label: {
                Image(systemName: "arrow.left.to.line.compact")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18)
                
                Text("Sign Out")
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } //: Sign Out Button
            .foregroundStyle(.black)
            .padding()
        } //: VStack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.primary)
        .modifier(NavToolbarMod("Menu", navPath: $vm.navPath))
        .background(.bg)
    } //: Body
    
}


struct MenuView_Previews: PreviewProvider {
    @State static var p: [ViewPath] =  []
    static var previews: some View {
        NavigationStack {
            MenuView(navPath: $p)
        }
    }
}
