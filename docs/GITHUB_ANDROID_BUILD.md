# GitHub Actions — Android APK & AAB (ProVixo Provider)

## Repository secrets

Same four secrets as the customer app (same `prt.jks`):

| Secret | Description |
|--------|-------------|
| `KEYSTORE_BASE64` | Base64 of `prt.jks` |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_PASSWORD` | Key password |
| `KEY_ALIAS` | Key alias |

## Encode keystore

```bash
base64 -i "/Users/amityadav/Projects/prt.jks" | pbcopy
```

## SHA-1 / SHA-256

```bash
"/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -list -v \
  -keystore "/Users/amityadav/Projects/prt.jks" \
  -alias YOUR_ALIAS
```

Register fingerprints on Firebase Android app **com.pt.provixoprovider**.

## Run build

**Actions → Android Release (APK + AAB) → Run workflow**  
Artifacts: `provixo-provider-apk`, `provixo-provider-aab`.
