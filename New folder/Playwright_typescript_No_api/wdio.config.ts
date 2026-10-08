import type { Options } from '@wdio/types';
import { ANDROID_CAPS } from './config/caps.config';

export const config: Options.Testrunner = {
  runner: 'local',

  autoCompileOpts: {
    autoCompile: true,
    tsNodeOpts: {
      transpileOnly: true,
      project: './tsconfig.json',
    },
  },

  specs: ['./tests/android/**/*.spec.ts'],
  exclude: [],

  capabilities: [ANDROID_CAPS],

  logLevel: 'info',
  bail: 0,
  waitforTimeout: 10_000,
  connectionRetryTimeout: 120_000,
  connectionRetryCount: 3,

  services: [
    [
      'appium',
      {
        command: 'appium',
        args: {
          address: process.env['APPIUM_HOST'] ?? 'localhost',
          port: Number(process.env['APPIUM_PORT'] ?? 4723),
          relaxedSecurity: true,
        },
      },
    ],
  ],

  framework: 'mocha',

  reporters: [
    'spec',
    [
      'junit',
      {
        outputDir: './test-results',
        outputFileFormat: () => 'android-results.xml',
      },
    ],
  ],

  mochaOpts: {
    ui: 'bdd',
    timeout: 60_000,
  },
};


// TypeScript has no official Appium client library
                    // ↓
// Uses WebdriverIO as the bridge
// WebdriverIO → talks to → Appium server → talks to → Android device