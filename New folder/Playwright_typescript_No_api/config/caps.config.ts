export const ANDROID_CAPS = {
    platformName: 'Android',
  'appium:automationName': 'UiAutomator2',
  'appium:deviceName': process.env['ANDROID_DEVICE'] ?? 'emulator-5554',
  'appium:platformVersion': process.env['ANDROID_VERSION'] ?? '13.0',
  'appium:appPackage': 'in.startv.hotstar',
  'appium:appActivity': 'com.hotstar.android.ui.splashscreen.SplashScreenActivity',
  'appium:app': process.env['ANDROID_APP_PATH'] ?? './apps/JioHotstar.apk',
  'appium:appWaitActivity': '*',
  'appium:newCommandTimeout': 300,
  'appium:noReset': false,
  'appium:fullReset': false,
};


// appium:autoWebview: false means Appium starts in NATIVE (default).
