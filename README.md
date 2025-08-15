EasyGuard for tvOS 🛡️
EasyGuard is a secure VPN app for Apple TV, built with UIKit, using the IKEv2 protocol, and structured with MVC architecture.

✨ Features
IKEv2 Protocol: Secure and stable VPN tunneling.

tvOS Native (UIKit): Optimized for Apple TV's interface.

MVC Architecture: Clean code for better organization.

VPN Control: Connect, disconnect, and view real-time status.

Network Extension: Manages VPN tunnel in the background.

🚀 Setup & Installation
Clone:

git clone https://github.com/TeccClubb/EasyGuard-TVos.git
cd EasyGuard-TVos

Open in Xcode:

open EasyGuard.xcodeproj

Configure Xcode: For both main app and Network Extension targets, set Signing & Capabilities (Team, Network Extensions with Packet Tunnel, App Groups).

Build & Run: Select your EasyGuard target and a tvOS device/simulator in Xcode, then run.

📐 Architecture Details
EasyGuard uses MVC (Model-View-Controller) for clear separation:

Model: Handles all data and business logic (e.g., VPN configs, status).

View: UI elements for display and user interaction.

Controller: Manages communication between Model and View, handling user input and updating the UI.

Made with ❤️ for TecClub SMC PVT
