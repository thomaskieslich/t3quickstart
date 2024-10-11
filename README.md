# Quickstart a TYPO3 Project
Sometimes i need a fresh TYPO3 Project with or without content. 
This is a script to create it from Environment.

## Usage
### TYPO3 12 with Introduction Package
- Check Environments in .env.12
- run `./t3quickstart install 12`
- open https://t3quick-12.ddev.site/typo3 and use Credentials from .env.12

- `cd t3quick-12 && ddev stop`
- delete Project by run `cd .. && ./t3quickstart delete 12`

