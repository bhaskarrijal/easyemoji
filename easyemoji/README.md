# Easy Emoji

**A native macOS utility to fix the Globe (fn) key.**

I built this because macOS forces you to choose between *Switching Input Sources* **or** *Showing Emojis* with the Globe key. After adding a Nepali keyboard, I needed both.

- **Short Tap** - Switch Input Source (e.g., English <-> Nepali).
- **Long Press** - Open the Emoji Picker.

---

### Installation

Since I haven't paid Apple for a Developer ID yet, this app is unsigned. You will see a security warning on the first launch.

1.  **Download** the latest `.dmg` or `.app` release.
2.  **Drag and Drop** `GlobeKey.app` into your **Applications** folder.
3.  **Right-Click (Control-Click)** the app and select **Open**.
    - *Do not double-click the first time.*
    - Click **Open** in the dialog box to whitelist the app.

> **"App is Damaged" Error?**
> If macOS says the file is damaged (common with AirDrop transfers), run this in your terminal to clear the quarantine flag:
> ```bash
> xattr -cr /Applications/GlobeKey.app
> ```

---

### Mandatory Permissions

This app uses low-level event monitoring (`CGEvent`) to detect key presses and simulate shortcuts. It **will not work** without Accessibility permissions.

1.  Go to **System Settings** > **Privacy & Security** > **Accessibility**.
2.  Click the **+** button (or drag the app file into the list).
3.  Select **GlobeKey.app** and ensure the toggle is **ON**.

**Note:** If the app stops working after an update, **remove it** from this list (`-` button) and re-add it. macOS often creates "stale" permission references for re-compiled binaries.

---

### Development and Testing

To build from source or debug via Xcode:

1.  **Clone the repo** and open `GlobeEmojiTool.xcodeproj`.
2.  **Disable Sandboxing**:
    - Go to project settings > **Signing & Capabilities**.
    - Delete the **App Sandbox** capability (click the `x`).
    - *Global key listening is blocked in the sandbox.*
3.  **Build & Run** (`Cmd + R`).

**MANDATORY: Granting Accessibility to Debug Build**
To test the app while running from Xcode, you must manually whitelist the debug binary.

1.  In Xcode, go to **Product** > **Show Build Folder in Finder**.
2.  Navigate to `Products/Debug/`.
3.  **Drag and Drop** the `GlobeKey.app` file directly into **System Settings > Accessibility**.
4.  Toggle the permission **ON**.

---

### Config

You can adjust the "Hold Duration" (sensitivity) from the menu bar.

1.  Click the **Globe Icon** in the menu bar.
2.  Use the slider to adjust how long you must hold `fn` to trigger the emoji picker.
    - **Default:** 0.4s
    - **Recommended:** 0.35s for fast typists.
