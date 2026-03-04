//
//  PlanSectionView.swift
//  ytta
//
//  Created by Codex on 03/03/26.
//

import SwiftUI

struct PlanSectionView: View {
    let title: String
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding? = nil
    var axis: Axis = .horizontal
    var minHeight: CGFloat = 54

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            inputContainer
        }
        .padding(AppTheme.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .fill(AppTheme.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .stroke(AppTheme.border)
        )
    }

    @ViewBuilder
    private var inputContainer: some View {
        if axis == .vertical {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(AppTheme.textSecondary.opacity(0.5))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                        .allowsHitTesting(false)
                }

                verticalEditor
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(inputBackground)
        } else {
            horizontalField
        }
    }

    private var inputBackground: some ShapeStyle {
        AppTheme.background
    }

    @ViewBuilder
    private var verticalEditor: some View {
        if let isFocused {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight)
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)
                .focused(isFocused)
        } else {
            TextEditor(text: $text)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight)
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)
        }
    }

    @ViewBuilder
    private var horizontalField: some View {
        if let isFocused {
            TextField(placeholder, text: $text, axis: axis)
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(inputBackground)
                .focused(isFocused)
        } else {
            TextField(placeholder, text: $text, axis: axis)
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .background(inputBackground)
        }
    }
}

struct PlanSectionView_Previews: PreviewProvider {
    static var previews: some View {
        StatefulPreviewWrapper("") { value in
            PlanSectionView(
                title: "What to Wear",
                icon: "tshirt",
                placeholder: "School uniform, black hoodie, sneakers...",
                text: value
            )
            .padding()
            .background(AppTheme.background)
        }
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
