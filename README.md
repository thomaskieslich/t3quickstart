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
| `CREATE_PACKAGES_DIR` | `0` | Create `packages/` directory and register as Composer path repository for local extensions |

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

## Local Extensions (packages directory)

To use local extensions across multiple TYPO3 instances, create a shared `packages/` directory at the project root:

```bash
mkdir -p packages
# Place or clone extensions here, e.g.:
git clone https://github.com/example/my_extension.git packages/my_extension
```

### Option 1: Docker Mount (recommended)

For each TYPO3 instance that should access the packages directory, create `.ddev/docker-compose.mount.yaml`:

```yaml
services:
  web:
    volumes:
      - "../packages:/var/www/html/packages"
```

Then add to `composer.json`:

```json
{
    "repositories": [{
        "name": "local",
        "type": "path",
        "url": "packages/*"
    }]
}
```

Install the extension:
```bash
ddev composer require vendor/my_extension:@dev
```

### Option 2: Symlink

Create a symlink inside the TYPO3 instance directory:

```bash
ln -s ../packages typo3-v13/packages
```

Then use the same `composer.json` configuration as above. The symlink is automatically mounted into the container.
