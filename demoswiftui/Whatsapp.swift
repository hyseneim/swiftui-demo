//
//  Whatsapp.swift
//  demoswiftui
//
//  Created by Gabriele Cipolloni on 12/04/23.
//

import SwiftUI

class ChatsViewModel: ObservableObject {
    @Published var chats = ChatModel.sampleChat
    
    func getSortedFilteredChats(query: String) -> [ChatModel] {
        let sortedChats = chats.sorted {
            guard let date1 = $0.messages.last?.date else {
                return false
            }
            guard let date2 = $1.messages.last?.date else {
                return false
            }
            return date1 > date2
        }
        
        if (query == "") {
            return sortedChats
        }
        
        return sortedChats.filter {
            $0.person.name.lowercased().contains(query.lowercased())
        }
    }
    
    func getSectionMessages(for chat: ChatModel) -> [[Message]] {
        var res = [[Message]]()
        var tmp = [Message]()
        for message in chat.messages {
            if let firstMessage = tmp.first {
                let daysBetween = firstMessage.date.daysBetween(date: message.date)
                if (daysBetween >= 1) {
                    res.append(tmp)
                    tmp.removeAll()
                    tmp.append(message)
                }
                else {
                    tmp.append(message)
                }
            }
            else {
                tmp.append(message)
            }
        }
        res.append(tmp)
        return res
    }
    
    func markAsUnread(_ newValue: Bool, chat: ChatModel) {
        if let index = chats.firstIndex(where: {
            $0.id == chat.id
        }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text: String, in chat: ChatModel) -> Message? {
        if let index = chats.firstIndex(where: {$0.id == chat.id}) {
            let message = Message(text, type: .Sent)
            chats[index].messages.append(message)
            return message
        }
        
        return nil
    }
}

struct Whatsapp: View {
    
    @StateObject var viewModel = ChatsViewModel()
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.getSortedFilteredChats(query: query)) { chat in
                    ZStack {
                        ChatRow(chat: chat)
                        NavigationLink(destination: {
                            ChatDetail(chat: chat).environmentObject(viewModel)
                        }, label: {
                            EmptyView()
                        }).buttonStyle(.plain)
                        .frame(width: 0)
                        .opacity(0)
                    }.swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button(action: {
                            viewModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                        }, label: {
                            if (chat.hasUnreadMessage) {
                                Label("Read", systemImage: "text.bubble")
                            }
                            else {
                                Label("Unread", systemImage: "circle.fill")
                            }
                        }).tint(.blue)
                    }
                }
            }.listStyle(.plain)
                .navigationTitle("Chats")
                .navigationBarItems(trailing: Button(action: {
                    
                }, label: {
                    Image(systemName: "square.and.pencil")
                }))
                .searchable(text: $query)
        }
    }
}

struct ChatRow: View {
    
    let chat: ChatModel
    
    var body: some View {
        HStack(spacing: 20) {
            Image(chat.person.imgString)
                .resizable()
                .frame(width: 70, height: 70, alignment: .top)
                .clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(chat.person.name).bold()
                        Spacer()
                        Text(chat.messages.last?.date.descriptiveString() ?? "")
                    }
                    HStack {
                        Text(chat.messages.last?.text ?? "").foregroundColor(.gray).lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                }
                
                Circle().foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
                    .frame(width: 18, height: 18)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }.frame(height: 80)
    }
}

struct ChatDetail: View {
    
    @EnvironmentObject var viewModel: ChatsViewModel
    
    let chat: ChatModel
    
    @State private var text = ""
    @FocusState private var isFocused
    @State private var messageIDToScroll: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { reader in
                ScrollView {
                    ScrollViewReader { scrollReader in
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of: messageIDToScroll) { _ in
                                if let messageID = messageIDToScroll {
                                    DispatchQueue.main.async {
                                        withAnimation(Animation.easeIn) {
                                            scrollReader.scrollTo(messageID, anchor: nil)
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                if let messageID = chat.messages.last?.id {
                                    DispatchQueue.main.async {
                                        withAnimation(Animation.easeIn) {
                                            scrollReader.scrollTo(messageID, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                    }
                }.padding(.horizontal)
            }.padding(.bottom, 5).background(.white)
            
            toolbarView()
        }.padding(.top, 1)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {}, label: {
                HStack {
                    Image(chat.person.imgString)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    Text(chat.person.name).bold()
                }.foregroundColor(.black)
            }), trailing: Button(action: {}, label: {
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "video")
                    })
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "phone")
                    })
                }
            }))
            .onAppear {
                viewModel.markAsUnread(false, chat: chat)
            }
    }
    
    func toolbarView() -> some View {
        VStack {
            let height: CGFloat = 37
            HStack {
                TextField("Message...", text: $text).padding(.horizontal, 10)
                    .frame(height: height)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .focused($isFocused)
                
                Button(action: {
                    if let message = viewModel.sendMessage(text, in: chat) {
                        text = ""
                        messageIDToScroll = message.id
                    }
                }, label: {
                    Image(systemName: "paperplane.fill").foregroundColor(.white)
                        .frame(width: height, height: height)
                        .background(Circle().foregroundColor(text.isEmpty ? .gray : .blue))
                }).disabled(text.isEmpty)
            }.frame(height: height)
        }.padding(.vertical).padding(.horizontal).background(.thickMaterial)
    }
    
    let columns = [GridItem(.flexible(minimum: 10))]
    
    func getMessagesView(viewWidth: CGFloat) -> some View {
        LazyVGrid(columns: columns, spacing: 0, pinnedViews: [.sectionHeaders]) {
            let sectionMessages = viewModel.getSectionMessages(for: chat)
            ForEach(sectionMessages.indices, id: \.self) { sectionIndex in
                let messages = sectionMessages[sectionIndex]
                Section(header: sectionHeader(firstMessage: messages.first!)) {
                    ForEach(messages) { message in
                        let isReceived = message.type == .Received
                        HStack {
                            ZStack {
                                Text(message.text)
                                    .padding(.horizontal)
                                    .padding(.vertical, 12)
                                    .background(isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
                                    .cornerRadius(13)
                            }.frame(width: viewWidth * 0.7, alignment: isReceived ? .leading : .trailing).padding(.vertical)
                        }.frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing).id(message.id)
                    }
                }
            }
        }
    }
    
    func sectionHeader(firstMessage message: Message) -> some View {
        ZStack {
            Text(message.date.descriptiveString(dateStyle: .medium).capitalized)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .regular))
                .frame(width: 120)
                .padding(.vertical, 5)
                .background(Capsule().foregroundColor(.blue))
        }.padding(.vertical, 5)
        .frame(maxWidth: .infinity)
    }
}

struct ChatModel: Identifiable {
    var id = UUID()
    let person: Person
    var messages: [Message]
    var hasUnreadMessage = false
}

struct Person: Identifiable {
    var id = UUID()
    let name: String
    let imgString: String
}

struct Message: Identifiable {
    
    enum MessageType {
        case Sent, Received
    }
    
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    init(_ text: String, type: MessageType, date: Date) {
        self.text = text
        self.type = type
        self.date = date
    }
    
    init(_ text: String, type: MessageType) {
        self.init(text, type: type, date: Date())
    }
}

extension ChatModel {
    static let sampleChat = [
        ChatModel(person: Person(name: "Gabriele", imgString: "jon-snow"), messages: [
            Message("Hey", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Hey", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Hey", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 3)),
            Message("Hey", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 3))
        ], hasUnreadMessage: true),
        ChatModel(person: Person(name: "Mario", imgString: "jon-snow"), messages: [
            Message("Hey2", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 4))
        ], hasUnreadMessage: false),
        ChatModel(person: Person(name: "Enrico", imgString: "jon-snow"), messages: [
            Message("Hey3", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 5))
        ], hasUnreadMessage: true),
        ChatModel(person: Person(name: "Andrea", imgString: "jon-snow"), messages: [
            Message("Hey4", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 6))
        ], hasUnreadMessage: false),
        ChatModel(person: Person(name: "Lorenzo", imgString: "jon-snow"), messages: [
            Message("Hey5", type: .Sent, date: Date(timeIntervalSinceNow: -86400 * 7))
        ], hasUnreadMessage: true)
    ]
}

extension Date {
    func descriptiveString(dateStyle: DateFormatter.Style = .short) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale.init(identifier: "it-IT")
        let daysBetween = self.daysBetween(date: Date())
        if (daysBetween == 0) {
            return "Oggi"
        }
        else if (daysBetween == 1) {
            return "Ieri"
        }
        else if (daysBetween < 5) {
            let weekdayIndex = Calendar.current.component(.weekday, from: self) - 1
            return formatter.weekdaySymbols[weekdayIndex]
        }
        return formatter.string(from: self)
    }
    
    func daysBetween(date: Date) -> Int {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: date)
        if let daysBetween = calendar.dateComponents([.day], from: date1, to: date2).day {
            return daysBetween
        }
        return 0
    }
}

#if DEBUG
struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        Whatsapp()
    }
}

struct ChatDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatDetail(chat: ChatModel.sampleChat[0])
                .environmentObject(ChatsViewModel())
        }
    }
}
#endif
