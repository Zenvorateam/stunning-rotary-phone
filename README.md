# Zenvora Mart — Native Flutter application

This project is written in Dart/Flutter. It contains **no HTML, CSS, JavaScript or WebView**.

## Included native app flows
- 1.6-second splash screen and Zenvora branding
- Strict black / white / grey visual theme throughout the app
- Home page with swipeable promotional slider
- Category icon navigation and brand selection (brand PNGs supported)
- Product listing with consistent cards, discount labels, wishlist and Details action
- Native product detail page
- Search and product sorting
- Persistent cart with quantity controls and delivery fee calculation
- Checkout form with Cash on Delivery flow
- Local order history and customer profile
- Saved products / wishlist
- Native bottom navigation

## Product and backend status
The included catalog is sample/demo data so the native UI can be built and tested immediately. Cart, profile, wishlist and placed COD orders are stored locally using SharedPreferences.

Supabase authentication, live catalogue sync, admin operations, order sync, Razorpay/online payments, shipping rules and production checkout are **not connected in this build**. The supplied HTML and the loose Dart files do not provide a complete, verified native screen implementation plus all required backend schema/configuration. I have not pretended those production integrations are complete. They should be connected against the actual Zenvora Supabase project and SQL schema in a separate integration step.

## Brand PNGs
Put your logos in `assets/brands/` using these names:
- `north.png`
- `forme.png`
- `casa.png`
- `pure.png`

Until a logo is added, its brand name is displayed as a fallback.

## Build APK with GitHub Actions
1. Create a GitHub repository and upload the contents of this folder.
2. Open the repository's **Actions** tab.
3. Run **Build Zenvora APK** or push to `main`.
4. Download `zenvora-release-apk` from the completed workflow run.

The workflow generates the Android platform folder with `flutter create`, then runs dependency install, analysis and release APK build.

## Local build
Install Flutter stable, then run:
```bash
flutter create . --platforms=android --project-name zenvora --org com.zenvora
flutter pub get
flutter analyze
flutter build apk --release
```
