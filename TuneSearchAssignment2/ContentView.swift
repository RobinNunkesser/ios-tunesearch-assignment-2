//
//  ContentView.swift
//  TuneSearchAssignment2
//
//  Created by Prof. Dr. Nunkesser, Robin on 16.12.20.
//

import SwiftUI
import TunesearchMockCore
import TunesearchCorePorts

struct ContentView: View {
    @State var searchText = "Jack Johnson"
    @State var navigate : Bool?
    @State private var showError = false
    @State private var errorText = ""

    var collectionsViewModel = CollectionsViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                TextField("Searchterm", text: $searchText)
                NavigationLink(destination: TracksListView().environmentObject(collectionsViewModel), tag: true, selection: $navigate) {
                    Button(action: startSearch) {
                        Text("Search")
                    }
                }
            }
            .padding(.horizontal)
            .alert(isPresented: $showError) { () -> Alert in
                Alert(title: Text("Error"), message: Text(errorText),
                      dismissButton: .cancel(Text("OK")))
            }
            .navigationBarTitle("Search")
        }
    }
    
    func startSearch() {
        let service = MockSearchTracksCommand()
        service.execute(inDTO: SearchTermDTO(term: searchText)) {
            result in
            switch result {
            case let .success(collections):
                display(success: collections.map({collection in CollectionViewModel(name: collection.name, tracks: collection.tracks.map({track in TrackPresenter().present(model: track)}))}))
            case let .failure(error):
                display(failure: error)
            }
        }
    }
    
    func display(failure: Error) {
        errorText = failure.localizedDescription
        showError.toggle()
    }
    
    func display(success: [CollectionViewModel]) {
        collectionsViewModel.collections = success
        self.navigate = true
    }}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
