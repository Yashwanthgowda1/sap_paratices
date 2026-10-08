/***
 * in encapsulation we use private or public or readonly 
 * access we have perviate methods call this within in calss using the get method also fine or set method no need to call uing () 
 * it automaticaly add parmeter
 * 
 * note in polymorpishm:
 * =========================
 * 
 * Constructor overloading

      TypeScript doesn't allow multiple constructor implementations like Java:
      instde Instead, use overload signatures + one implementation:
 */




import readline from "readline";

// ===============================
// PARENT CLASS
// ===============================

class BankAccount {
    username: string;
    private password: string;
    branch_name: string;
    balance: number;
    isSignedIn: boolean;

    constructor(
        username: string,
        password: string,
        balance: number,
        branch_name: string
    ) {
        this.username = username;
        this.password = password;
        this.balance = balance;
        this.branch_name = branch_name;
        this.isSignedIn = false;
    }

    // Parent method
    signIn(): boolean {
        if (this.username !== "" && this.password !== "") {
            this.isSignedIn = true;

            console.log(`\nWelcome ${this.username}`);
            return true;
        }

        console.log("Invalid username or password");
        return false;
    }

    // Parent method
    checkLogin(): boolean {
        if (!this.isSignedIn) {
            console.log("Please login first");
            return false;
        }

        return true;
    }

    // Parent method
    balance_value(): number {
        if (this.checkLogin()) {
            return this.balance;
        }

        return 0;
    }

    // Parent method
    withdraw(amount: number): number {
        if (!this.checkLogin()) {
            return this.balance;
        }

        if (amount <= 0) {
            console.log("Invalid amount");
            return this.balance;
        }

        if (amount > this.balance) {
            console.log("Insufficient balance");
            return this.balance;
        }

        this.balance -= amount;

        console.log(`₹${amount} withdrawn successfully`);

        return this.balance;
    }

    // Parent method
    deposit(amount: number): number {
        if (!this.checkLogin()) {
            return this.balance;
        }

        if (amount <= 0) {
            console.log("Invalid amount");
            return this.balance;
        }

        this.balance += amount;

        console.log(`₹${amount} deposited successfully`);

        return this.balance;
    }
}


// ===============================
// CHILD CLASS
// ===============================

class PremiumBankAccount extends BankAccount {

    accountType: string;
    transferLimit: number;

    constructor(
        username: string,
        password: string,
        balance: number,
        branch_name: string,
        accountType: string,
        transferLimit: number
    ) {

        // Call parent constructor
        super(
            username,
            password,
            balance,
            branch_name
        );

        // Child properties
        this.accountType = accountType;
        this.transferLimit = transferLimit;
    }

    // Child method
    resetPassword(newPassword: string): void {

        if (!this.checkLogin()) {
            return;
        }

        if (newPassword === "") {
            console.log("Password cannot be empty");
            return;
        }

        this.password = newPassword;

        console.log("Password reset successfully");
    }

    // Child method
    transfer(amount: number): void {

        if (!this.checkLogin()) {
            return;
        }

        if (amount <= 0) {
            console.log("Invalid transfer amount");
            return;
        }

        if (amount > this.transferLimit) {
            console.log(
                `Transfer limit is ₹${this.transferLimit}`
            );
            return;
        }

        if (amount > this.balance) {
            console.log("Insufficient balance");
            return;
        }

        this.balance -= amount;

        console.log(`₹${amount} transferred successfully`);
    }

    // Child method
    showAccountDetails(): void {

        if (!this.checkLogin()) {
            return;
        }

        console.log("\n===== ACCOUNT DETAILS =====");

        console.log("Username:", this.username);
        console.log("Branch:", this.branch_name);
        console.log("Account Type:", this.accountType);
        console.log("Transfer Limit:", this.transferLimit);
        console.log("Balance:", this.balance);
    }
}


// ===============================
// CREATE CHILD OBJECT
// ===============================

const user1 = new PremiumBankAccount(
    "Yash",
    "password123",
    10000,
    "Bangalore",
    "Premium",
    5000
);


// ===============================
// READLINE
// ===============================

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});


// ===============================
// ATM MENU
// ===============================

function showMenu(): void {

    console.log("\n==========================");
    console.log("       ATM MENU");
    console.log("==========================");

    console.log("1. Check Balance");
    console.log("2. Withdraw");
    console.log("3. Deposit");
    console.log("4. Transfer");
    console.log("5. Reset Password");
    console.log("6. Account Details");
    console.log("7. Exit");

    rl.question("\nEnter your choice: ", (choice) => {

        switch (choice) {

            // -------------------
            // CHECK BALANCE
            // -------------------

            case "1":

                console.log(
                    "Current Balance: ₹",
                    user1.balance_value()
                );

                showMenu();

                break;


            // -------------------
            // WITHDRAW
            // -------------------

            case "2":

                rl.question(
                    "Enter withdrawal amount: ",
                    (amount) => {

                        user1.withdraw(Number(amount));

                        showMenu();
                    }
                );

                break;


            // -------------------
            // DEPOSIT
            // -------------------

            case "3":

                rl.question(
                    "Enter deposit amount: ",
                    (amount) => {

                        user1.deposit(Number(amount));

                        showMenu();
                    }
                );

                break;


            // -------------------
            // TRANSFER
            // -------------------

            case "4":

                rl.question(
                    "Enter transfer amount: ",
                    (amount) => {

                        user1.transfer(Number(amount));

                        showMenu();
                    }
                );

                break;


            // -------------------
            // RESET PASSWORD
            // -------------------

            case "5":

                rl.question(
                    "Enter new password: ",
                    (newPassword) => {

                        user1.resetPassword(newPassword);

                        showMenu();
                    }
                );

                break;


            // -------------------
            // ACCOUNT DETAILS
            // -------------------

            case "6":

                user1.showAccountDetails();

                showMenu();

                break;


            // -------------------
            // EXIT
            // -------------------

            case "7":

                console.log(
                    "\nThank you for using our ATM."
                );

                rl.close();

                break;


            // -------------------
            // INVALID
            // -------------------

            default:

                console.log(
                    "Invalid choice. Please try again."
                );

                showMenu();
        }
    });
}


// ===============================
// LOGIN
// ===============================

console.log("===== BANK LOGIN =====");

if (user1.signIn()) {
    showMenu();
}


// -==========================================lose couplig donr by intrefce
interface NotificationService {

    send(message: string): void;
}


class EmailService implements NotificationService {

    send(message: string): void {
        console.log("Email:", message);
    }
}


class Notification {

    constructor(
        private service: NotificationService
    ) {}

    send(message: string): void {
        this.service.send(message);
    }
}


// 1. Create implementation object
const emailService = new EmailService();


// 2. Pass object reference to Notification
const notification = new Notification(emailService);


// 3. Call Notification method
notification.send("Hello");