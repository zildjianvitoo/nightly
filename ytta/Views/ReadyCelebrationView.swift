//
//  ReadyCelebrationView.swift
//  ytta
//
//  Created by Codex on 04/03/26.
//

import SwiftUI

struct ReadyCelebrationView: View {
    @State private var animateIcon = false

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.success.opacity(0.14))
                    .frame(width: 34, height: 34)

                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.success)
                    .symbolEffect(.bounce, value: animateIcon)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Ready for Tomorrow")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Everything important is already lined up.")
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppTheme.success.opacity(0.18))
        )
        .shadow(color: Color.black.opacity(0.08), radius: 18, y: 10)
        .onAppear {
            animateIcon.toggle()
        }
        .accessibilityElement(children: .combine)
    }
}

struct ReadyCelebrationView_Previews: PreviewProvider {
    static var previews: some View {
        ReadyCelebrationView()
            .padding()
            .background(AppTheme.background)
    }
}
