//
//  TextEditorWithPlaceholder.swift
//  TextEditorWithPlaceholder
//
//  Created by 平岡修 on 2022/06/01.
//

import SwiftUI

public struct TextEditorWithPlaceholder: View {
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case textEditor
        case placeholder
    }
    
    @Binding var text: String
    private let placeholderText: String
    private let shouldAutoFocus: Bool
    
    public init(_ placeholder: String, text: Binding<String>, shouldAutoFocus: Bool = false) {
        self._text = text
        self.placeholderText = placeholder
        self.shouldAutoFocus = shouldAutoFocus
    }
    
    public var body: some View {
        ZStack {
            
            // Show the placeholder if the text is empty
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .onTapGesture {
                        guard self.shouldAutoFocus else { return }
                        focusedField = .placeholder
                    }
                
                VStack {
                    HStack {
                        TextField(placeholderText, text: $text)
                            .focused($focusedField, equals: .placeholder)
                            .onAppear {
                                guard self.shouldAutoFocus else { return }
                                focusedField = .placeholder
                            }
                        
                        Spacer()
                    }
                    .padding(.leading, 6)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
            .opacity(text.isEmpty ? 1 : 0)
            
            // Show the text editor if the text is not empty
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused($focusedField, equals: .textEditor)
                .onAppear {
                    guard self.shouldAutoFocus else { return }
                    focusedField = .textEditor
                }
                .opacity(text.isEmpty ? 0 : 1)
        }
        .padding(.leading, -6)
    }
}

struct TextEditorWithPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorWithPlaceholder("Write down...", text: .constant(""))
    }
}
