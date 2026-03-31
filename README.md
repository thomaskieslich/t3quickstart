<span style="color:red;">!!!</span> Original Repository on: https://codeberg.org/kiesi/t3quickstart <span style="color:red;">!!!</span>

Mirror only on Github: https://github.com/thomaskieslich/t3quickstart

# Quickstart a TYPO3 Project
Sometimes i need a fresh TYPO3 Project with or without content.
This is a script to create it from Environment.

## Setup
1. Copy `.env.local.dist` to `.env.local` and adjust values (especially admin credentials):
   ```bash
   cp .env.local.dist .env.local
   ```
2. Adjust version-specific settings in `.env.<version>` if needed

## Configuration
### Add-ons (in `.env.<version>` or `.env.local`)
| Variable | Default | Description |
|----------|---------|-------------|
| `INSTALL_PHPMYADMIN` | `0` | Install ddev-phpmyadmin add-on |
| `INSTALL_CAMINO_THEME` | `1` | Install Camino Theme (TYPO3 14+ only) |

## Usage
Supported versions: 10, 11, 12, 13, 14

| Version | Install Command | Delete Command |
|---------|-----------------|----------------|
| 10 | `./t3quickstart install 10` | `./t3quickstart delete 10` |
| 11 | `./t3quickstart install 11` | `./t3quickstart delete 11` |
| 12 | `./t3quickstart install 12` | `./t3quickstart delete 12` |
| 13 | `./t3quickstart install 13` | `./t3quickstart delete 13` |
| 14 | `./t3quickstart install 14` | `./t3quickstart delete 14` |

Der Projektordner wird automatisch als `typo3-v<version>` angelegt. Ein eigener Name kann als dritter Parameter übergeben werden:
```bash
./t3quickstart install 14 my-custom-project
./t3quickstart delete 14 my-custom-project
```

After installation, open `https://typo3-v<version>.ddev.site/typo3` and use the credentials from `.env.local`.
