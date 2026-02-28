# xTom - Homebrew
This is the repository used for [xTom](https://github.com/xtomcom) Homebrew installations.

## Preparation
1. You should make sure that `Homebrew` is already installed on your Mac. if not, you can install it using the following command.
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
2. You should use the `tap` command to add our repository.
```shell
brew tap xtomcom/brew
```

## Install
- [xtomcom/rdap](https://github.com/xtomcom/rdap) - A command-line RDAP client for querying domain, IP, and ASN information
```shell
brew install xtomcom/brew/rdap
```

## Uninstall
```shell
brew uninstall rdap
```

## Untap
```shell
brew untap xtomcom/brew
```
