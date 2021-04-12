import SwiftUI

extension View {
    public func foreground<Overlay: View>(
        _ overlay: Overlay
    ) -> some View {
        self.overlay(overlay).mask(self)
    }
}
