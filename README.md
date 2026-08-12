# Central Feature

Business Central extension der samler Microsofts feature-oplysninger fra Microsoft Learn på både engelsk og dansk.

## Formål

Denne extension gør det nemt at holde sig opdateret med nye features i Business Central ved automatisk at hente information fra Microsofts officielle dokumentation.

## Installation

1. Clone repoet:
   ```bash
   git clone https://github.com/jenshinnerup-lab/central-feature.git
   cd central-feature
   ```

2. Byg appen:
   ```bash
   al-go /build
   ```

3. Installer i dit Business Central miljø

## Automatisk Opdatering

### Manuel opdatering

Kør scraperen manuelt for at hente nyeste features:

```bash
cd /home/jens/openclaw-projects/central-feature
./scripts/update_features.sh
```

Eller kør Python scriptet direkte:

```bash
python3 scripts/scrape_features.py both
```

### Ugentlig automatisk opdatering (Cron)

Der er opsat et cron job der kører hver **mandag kl. 9:00**:

```cron
0 9 * * 1 /home/jens/openclaw-projects/central-feature/scripts/update_features.sh >> /home/jens/openclaw-projects/central-feature/logs/cron.log 2>&1
```

## Struktur

```
central-feature/
├── app.json                 # App konfiguration
├── features/                # Feature data (JSON filer)
│   ├── BC_2025_Wave_2_en.json
│   ├── BC_2025_Wave_2_da.json
│   └── ...
├── scripts/                 # Opdateringsscripts
│   ├── scrape_features.py   # Python scraper
│   └── update_features.sh   # Bash wrapper
├── src/                     # AL kildekode
└── logs/                    # Logfiler (oprettes automatisk)
```

## Scripts

### scrape_features.py

Python script der henter features fra Microsoft Learn.

**Brug:**
```bash
# Hent på både engelsk og dansk
python3 scripts/scrape_features.py both

# Kun engelsk
python3 scripts/scrape_features.py en

# Kun dansk
python3 scripts/scrape_features.py da
```

Scriptet vil:
1. Konvertere eksisterende `.txt` filer til `.json`
2. Scrape Microsoft Learn for nye features
3. Gemme resultaterne i `features/` mappen

### update_features.sh

Bash script der kører scraperen og committer ændringer til git.

Dette script:
- Puller seneste changes fra remote
- Kører Python scraperen
- Committer nye/ændrede JSON filer
- Pusher til remote repository

## Data Format

Features gemmes som JSON i følgende format:

```json
{
  "BusinessCentralVersion": {
    "Version": "BC 25.2 (EN)",
    "VersionII": "Business Central 2025 Wave 2 (EN)",
    "Feature": [
      {
        "Title": "Feature title",
        "Area": "Application Features",
        "description": "Feature description",
        "link": "feature-slug",
        "publicPreview": "2024-09-02",
        "generalAvailability": "2024-10-04"
      }
    ]
  }
}
```

## Business Central Integration

Extensionen læser JSON filerne fra `features/` mappen ved installation og opretter poster i følgende tabeller:

- `Business Central Version` (Tabel 91100)
- `Business Area` (Tabel 91101)
- `Feature Entry` (Tabel 91102)

Data vises på siderne:
- Business Central Version (Side 91100)
- Business Area (Side 91101)  
- Business Feature (Side 91102)

## Krav

- Python 3.6+
- `requests` library (`pip3 install requests`)
- Git
- Business Central 25.0+

## Logs

Logs gemmes i `logs/` mappen:
- `update_YYYY-MM-DD.log` - Daglige opdateringslogs
- `cron.log` - Cron job output

## Fejlfinding

### Scraper finder ingen features

Microsoft kan have ændret deres HTML struktur. Tjek:
1. At URLs i scriptet er korrekte
2. HTML parsing logic i `parse_feature_page()`

### Git push fejler

Tjek authentication:
```bash
git remote -v
git config --global credential.helper store
```

## License

MIT License

## Forfatter

Jens Hinnerup / vibrantcolor.dev
