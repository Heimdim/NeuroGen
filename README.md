# NeuroGen

NeuroGen is a Flutter client for **Kling AI image generation**. You describe what you want (and optionally attach a reference image), jobs are queued and polled until results arrive, and you can browse past generations in history.

## Features

- Submit generations with a text prompt and optional local image input (`image_picker`).
- Background job handling with status updates (`flutter_bloc` + `JobsCubit`).
- Persistent job history via **Hive**.
- **English and Russian** UI (`flutter_localizations` + ARB-generated `AppLocalizations`).
- Optional **save to gallery** for finished images (`gal`).
- Network images cached with **cached_network_image**.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) with Dart **3.11** or newer (see `pubspec.yaml` `environment.sdk`).
- A Kling developer account with API access credentials used by this app (access key + secret key).

## Configuration

The app loads environment values from **`assets/.env`** at startup (`flutter_dotenv`). Create that file next to your other assets (it is listed in `pubspec.yaml` and should stay out of version control if you use real secrets).

**Required**

- `KLING_ACCESS_KEY` — Kling access key.
- `KLING_SECRET_KEY` — Kling secret key; the app builds a short-lived **JWT** (`HS256`) for the `Authorization` header.

**Optional**

- `KLING_API_BASE_URL` — API host; defaults to `https://api.kling.ai` if unset or empty.
- `KLING_MODEL_NAME` — Image model name sent as `model_name`; defaults to `kling-v2-1` if unset or empty.

If the required keys are missing, startup fails with a configuration error that tells you to set them in `assets/.env`.

## Run the app

```bash
flutter pub get
flutter run
```

Pick your device or emulator as usual. On first launch, ensure `assets/.env` exists and contains valid Kling credentials.

## Project layout (high level)

- `lib/main.dart` — Initializes dotenv, Hive, `GetIt` service locator, and provides `JobsCubit` at the root.
- `lib/core/` — API config, Dio client, Kling auth interceptor, locale controller.
- `lib/data/` — Remote data source, providers, repository, local image storage.
- `lib/domain/` — Entities and provider abstractions.
- `lib/presentation/` — Screens (`AppShell`, generation, history) and cubits.

## Tests and analysis

```bash
flutter analyze
flutter test
```

## Legal and safety

API keys and secrets belong only in local `assets/.env` (or your CI secrets store), never in screenshots, issues, or commits. Refer to Kling’s terms and acceptable use for generated content.
