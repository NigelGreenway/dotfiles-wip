# Symfony2 shortcuts

sf() { ./app/console "$@"; }

## entities
sfentities() { sf doctrine:generate:entities "$@" --no-backup; }

## Migrations
sfmigration() { $EDITOR `sf doctrine:migrations:generate | awk -F"\"" '{ print $2 }'`; } # Opens migration file in your chosen editor
sfmigrate() { sf doctrine:migrations:migrate; } # Migrates the database to the latest version

# integrated web server functionality
sfserve() { sf server:run 0.0.0.0:$1; }
