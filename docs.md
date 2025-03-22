# Implemented Crashlytics

1. to see all types of crashes and also wrote crash logs In HomeViewModel.dart and GameViewModel.dart.

// 1️⃣ Catches all synchronous Flutter framework errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // 2️⃣ Catches all uncaught asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // 3️⃣ Catches Dart's Isolate thread errors
  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort,
  );

## Post Hog (Flutter)

✅ Feature Flags: Ideal for controlling new features, A/B testing, or rolling out updates to specific user groups without pushing new builds.
✅ Session Replay: Helps you understand user behavior by replaying real user sessions — perfect for UI/UX improvements.
✅ Event Capture & User Identification: Useful for tracking user actions, app flows, and building personalized experiences.
✅ Group Analytics: Great for understanding user patterns across segments (e.g., tracking user behavior by demographics, location, etc.)

## ENV CONFIG (DotEnv)

Android: Fetching  PostHog Api key and Post Hog host diecrtly from .env file using dotenv packge,
Web: to use posthog on web we have to follow these steps:

1. There is a script tag available in posthog project copy that script tag.
2. Paste that script tag  web/index.html within head tag. But there is a problem that script tag will contain apikey and host so you have to replace actual apikey and host, otherwise it will compromised.
3. So the third step is secure POSTHOG_API_KEY and POSTHOG_HOST
   i)  create a file in: web/config.template.js
    paste this inside the file:  

      ```  window.posthogConfig = {
    apiKey: '__POSTHOG_API_KEY__',
    host:'__POSTHOG_HOST__',

} ```

   ii) Then connect web/config.template.js in web/index.html within head tag. like this:

        ``` <script src="config.template.js">
        </script> 

```
        
iii) After connecting, third step is to replace original host address and apikey with window.posthogConfig.host and window.posthogConfig.apiKey
   posthog.init(window.posthogConfig.apiKey, {
        api_host: window.posthogConfig.host,
        person_profiles: 'identified_only',
        session_recording: {
          maskAllInputs: true,
        }
    })
    
iv) Now add a build script in root directory. wordly/scripts/build_web.ps1 what this file is doing it is reading the apikey and host fromm.env and create a config.json file 

      i) paste below code in the wordly/scripts/build_web.ps1 file when you run this script it will generate web/config.js file

     code:    # Read .env file
$envConfig = Get-Content .env -Raw | ConvertFrom-StringData

# Replace placeholders in template
(Get-Content "web/config.template.js") `
    -replace '__POSTHOG_API_KEY__', $envConfig.POSTHOG_API_KEY `
    -replace '__POSTHOG_HOST__', $envConfig.POSTHOG_HOST `
| Set-Content "web/config.js"

<!-- # Build Flutter web -->
flutter build web --release

    ii) run in powershell (this will generate web/config.js based on the template web/config.template.js) --> .\scripts\build_web.ps1 

    iii) After that you will get your web/config.js file with actual api key and host. Make sure to add this file in .gigignore. Dont add web/config.template.js this in .gitignore
