type LogLevel = 'INFO' | 'WARN' | 'ERROR' | 'DEBUG';

export class Logger {
  private readonly context: string;

  constructor(context: string) {
    this.context = context;
  }

  private log(level: LogLevel, message: string): void {
    const timestamp = new Date().toISOString();
    const prefix = `[${timestamp}] [${level.padEnd(5)}] [${this.context}]`;
    if (level === 'ERROR') {
      console.error(`${prefix} ${message}`);
    } else if (level === 'WARN') {
      console.warn(`${prefix} ${message}`);
    } else {
      console.log(`${prefix} ${message}`);
    }
  }

  info(message: string):  void { this.log('INFO',  message); }
  warn(message: string):  void { this.log('WARN',  message); }
  error(message: string): void { this.log('ERROR', message); }
  debug(message: string): void { this.log('DEBUG', message); }
}
