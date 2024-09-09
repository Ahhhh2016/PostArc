//
//  PostcardList.swift
//  PostArc
//
//  Created by Yixuan Liu on 9/5/24.
//

import SwiftUI


struct PostcardList: View {
    @StateObject private var postcardData = PostcardData()


    var body: some View {
        NavigationSplitView {
            if postcardData.postcards.isEmpty {
                Text("No postcards yet")
                    .font(.headline)
                    .padding()
            } else {
                List(postcardData.postcards) { postcard in
                    NavigationLink {
                        PostcardDetail()
                    } label: {
                        HStack {
                            postcard.image1
                                .resizable()
                                .frame(width: 50, height: 50)
                            postcard.image2
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            Text(postcard.fromWhere)
                            
                            
                            Spacer()
                        }
                    }
                }
                .navigationTitle("Postcards")
            }
        
        } detail: {
            Text("Select a postcard")
        }
    }
}


#Preview {
    PostcardList()
}
