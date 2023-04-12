//
//  ContentView.swift
//  myaxa
//
//  Created by Gabriele Cipolloni on 11/04/23.
//

import SwiftUI
import UIKit

struct InstagramClone : View {
    
    init(feed: [Post], stories: [Story]) {
        self.feed = feed
        self.stories = stories
    }
    
    let feed: [Post]
    let stories: [Story]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(stories, id: \.author.nickname, content: { story in
                            VStack {
                                ZStack {
                                    Circle().fill(LinearGradient(
                                        gradient: Gradient(colors: [.red, .purple, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing
                                    )).frame(width: 65, height: 65)
                                    Image(uiImage: story.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60, alignment: .top)
                                        .clipped()
                                        .clipShape(Circle())
                                }
                                Text(story.author.nickname).font(.caption)
                            }
                        })
                    }.padding([.leading, .top, .bottom], 10)
                }
                Divider()
                List(feed, id: \.author.nickname, rowContent: { post in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(uiImage: post.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30, alignment: .top)
                                .clipped()
                                .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(post.author.nickname)
                                    .fontWeight(.bold)
                                Text("Italy")
                                    .font(.caption)
                            }
                        }
                                   
                       Image(uiImage: post.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220, alignment: .top)
                                .clipped()
                                .padding([.leading, .trailing], -20)
                        
                        HStack {
                            Group {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                                Image(systemName: "paperplane")
                            }.padding([.trailing], 5)
                            
                            Spacer()
                            Image(systemName: "bookmark")
                        }.font(.callout).padding([.top, .bottom], 6)
                        
                        Group {
                            Text(post.author.nickname).fontWeight(.bold)
                            +
                            Text(" ")
                            +
                            Text(post.description)
                        }.font(.caption).lineLimit(2)
                    }.padding([.bottom], 10)
                }).listStyle(PlainListStyle())
            }
            .navigationBarTitle("Instagram", displayMode: .inline)
            .navigationBarItems(leading: Image(systemName: "camera"), trailing:
                Image(systemName: "paperplane"))
        }
    }
    
}

struct Post {
    let description: String
    let image: UIImage
    let author: Author
}

struct Author {
    let nickname: String
    let image: UIImage
}

struct Story {
    let author: Author
    let image: UIImage
}

extension Post {
    static func mocks() -> [Post] {
        [
            Post(description: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                Author(nickname: "Gabriele", image: UIImage(named: "jon-snow")!)),
            Post(description: "Hello World 2!", image: UIImage(named: "jon-snow")!, author:
                Author(nickname: "Gabriele2", image: UIImage(named: "jon-snow")!)),
            Post(description: "Hello World 3!", image: UIImage(named: "jon-snow")!, author:
                Author(nickname: "Gabriele3", image: UIImage(named: "jon-snow")!))
        ]
    }
}

extension Story {
    static func mocks() -> [Story] {
        [
            Story(author:
                Author(nickname: "Gabriele", image: UIImage(named: "jon-snow")!),
                  image: UIImage(named: "jon-snow")!),
            Story(author:
                Author(nickname: "Gabriele2", image: UIImage(named: "jon-snow")!),
                  image: UIImage(named: "jon-snow")!),
            Story(author:
                Author(nickname: "Gabriele3", image: UIImage(named: "jon-snow")!),
                  image: UIImage(named: "jon-snow")!)
        ]
    }
}

#if DEBUG
struct InstagramClonePreview : PreviewProvider {
    static var previews: some View {
        InstagramClone(feed: Post.mocks(), stories: Story.mocks())
    }
}
#endif
