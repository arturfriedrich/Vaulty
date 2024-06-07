# Vaulty - A Secure Storage for Your Passwords

Vaulty is a terminal-based, open-source password manager that offers an efficient and lightweight solution for storing, editing, and browsing your saved passwords. It stores your passwords locally and employs strong encryption techniques to ensure maximum security.

## Table of Contents

1. [Disclaimer](#disclaimer)
2. [Features](#features)
3. [Technologies Used](#technologies-used)
4. [Installation](#installation)
5. [Getting Started](#getting-started)
6. [Usage](#usage)
    - [Add Profile](#add-profile)
    - [Find Profile Data](#find-profile-data)
    - [Retrieve All Profile Data](#retrieve-all-profile-data)
    - [Update Profile Data](#update-profile-data)
    - [Delete Profile Data](#delete-profile-data)
7. [Security](#security)
8. [Contribution](#contribution)
9. [License](#license)

## Disclaimer

Vaulty is designed to store passwords securely on your local machine. While it employs strong encryption, the security of your data depends on the security of your device. Ensure your device is protected against malware and unauthorized access. The developers are not responsible for any loss or breach of data.

## Features

- Local storage of passwords with encryption.
- Secure master password for accessing stored data.
- Add, retrieve, update, and delete password profiles.
- Automatic password generation.
- Clipboard integration for easy copying of usernames and passwords.
- Session timeout for enhanced security.

## Technologies Used

- **Bash**: The scripting language used for developing Vaulty.
- **OpenSSL**: For encrypting and decrypting passwords.
- **pbcopy**: For clipboard integration on macOS.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/vaulty.git
    cd vaulty
    ```

2. Add Vaulty to your PATH by adding the following line to your `~/.zshrc` or `~/.bashrc`:
    ```bash
    export PATH=$PATH:/path/to/vaulty
    ```

3. Source the updated profile to make the changes effective:
    ```bash
    source ~/.zshrc  # For zsh users
    source ~/.bashrc  # For bash users
    ```

## Getting Started

Run Vaulty from anywhere in your terminal:
```bash
vaulty
```

## Usage

### Add Profile

To add a new profile:
1. Select the `(a)dd profile` option.
2. Enter the website name.
3. Enter the username.
4. Choose to either create a password or generate one.

### Find Profile Data

To find a specific profile:
1. Select the `(f)ind profile data` option.
2. Enter the website name.
3. Choose to copy the username or password to the clipboard.

### Retrieve All Profile Data

To retrieve all profiles:
1. Select the `(r)etrieve all profile data` option.
2. All profiles will be displayed, excluding the master password.

### Update Profile Data

To update an existing profile:
1. Select the `(u)pdate profile data` option.
2. Enter the website name.
3. Enter a new username or leave blank to keep the existing one.
4. Choose to create or generate a new password, or leave blank to keep the existing one.

### Delete Profile Data

To delete a profile:
1. Select the `(d)elete profile data` option.
2. Enter the website name.
3. Confirm the deletion.

## Security

- **Encryption**: Passwords are encrypted using AES-256-CBC, a strong encryption standard.
- **Master Password**: Protects access to the stored data.
- **Session Timeout**: Automatically exits the application after 2 minutes of inactivity.

## Contribution

Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure your code follows the project's style and passes all tests.

## License

Vaulty is open-source software licensed under the MIT License. See the LICENSE file for more information.