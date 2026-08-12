#!/usr/bin/env python3
"""
Scraper for Microsoft Business Central feature documentation.
Henter features fra Microsoft Learn på engelsk og dansk og gemmer som JSON.

Brug: python3 scrape_features.py [--lang en|da|both]
"""

import json
import re
import sys
import requests
from datetime import datetime
from pathlib import Path

# Microsoft Learn URLs - opdateres når Microsoft ændrer struktur
# Brug browser til at finde aktuelle URLs da Microsoft ofte ændrer dem
BC_VERSION_URLS = {
    # 2025 Wave 2 - Tjek aktuelle URLs
    '2025_2_en': 'https://learn.microsoft.com/en-us/dynamics365/release-plans/dynamics365-business-central?bc-version=2025-wave-2',
    '2025_2_da': 'https://learn.microsoft.com/da-dk/dynamics365/release-plans/dynamics365-business-central?bc-version=2025-wave-2',
    # 2024 Wave 1
    '2024_1_en': 'https://learn.microsoft.com/en-us/dynamics365/release-plans/dynamics365-business-central?bc-version=2024-wave-1',
    '2024_1_da': 'https://learn.microsoft.com/da-dk/dynamics365/release-plans/dynamics365-business-central?bc-version=2024-wave-1',
    # 2023 Wave 1  
    '2023_1_en': 'https://learn.microsoft.com/en-us/dynamics365/release-plans/dynamics365-business-central?bc-version=2023-wave-1',
    '2023_1_da': 'https://learn.microsoft.com/da-dk/dynamics365/release-plans/dynamics365-business-central?bc-version=2023-wave-1',
}

# Alternativ: Brug Microsofts API hvis tilgængeligt
# https://learn.microsoft.com/api/catalog/dynamics365/business-central

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9',
    'Accept-Language': 'en-US,en;q=0.9,da;q=0.8',
}

def fetch_url(url, max_retries=3):
    """Hent HTML indhold fra URL med retry logic."""
    for attempt in range(max_retries):
        try:
            response = requests.get(url, headers=HEADERS, timeout=30)
            response.raise_for_status()
            return response.text
        except requests.RequestException as e:
            if attempt == max_retries - 1:
                print(f"Error fetching {url}: {e}")
            else:
                print(f"Retry {attempt + 1}/{max_retries} for {url}")
    return None

def parse_feature_page(html, lang='en'):
    """
    Parse HTML og udtræk features fra Microsoft Learn.
    Leder efter feature-entries i HTML strukturen.
    """
    features = []
    
    # Microsoft Learn bruger ofte article tags eller div med data-attributes
    # Prøv at finde feature blocks
    
    # Pattern for feature titler og beskrivelser
    feature_pattern = r'<a[^>]*href="([^"]*release-plan[^"]*)"[^>]*>\s*<h[23][^>]*>([^<]+)</h[23]>'
    
    for match in re.finditer(feature_pattern, html, re.IGNORECASE | re.DOTALL):
        link = match.group(1)
        title = re.sub(r'\s+', ' ', match.group(2)).strip()
        
        if title and len(title) > 10:
            features.append({
                'Title': title,
                'Area': 'Applikationsfunktioner' if lang == 'da' else 'Application Features',
                'description': '',
                'link': link.rstrip('/').split('/')[-1] if link else '',
                'publicPreview': None,
                'generalAvailability': None
            })
    
    # Alternativ: Find tabel-rækker
    if not features:
        row_pattern = r'<tr[^>]*>.*?</tr>'
        for row_match in re.finditer(row_pattern, html, re.DOTALL):
            row = row_match.group(0)
            cell_pattern = r'<td[^>]*>(.*?)</td>'
            cells = re.findall(cell_pattern, row, re.DOTALL)
            
            if len(cells) >= 2:
                title = re.sub(r'<[^>]+>', '', cells[0]).strip()
                area = re.sub(r'<[^>]+>', '', cells[1]).strip() if len(cells) > 1 else ''
                
                if title and len(title) > 10:
                    features.append({
                        'Title': title,
                        'Area': area if area else ('Applikationsfunktioner' if lang == 'da' else 'Application Features'),
                        'description': '',
                        'link': '',
                        'publicPreview': None,
                        'generalAvailability': None
                    })
    
    return features

def scrape_bc_version(version_key, lang='en'):
    """Scrape features for en specifik BC version."""
    url_key = f"{version_key}_{lang}"
    url = BC_VERSION_URLS.get(url_key)
    
    if not url:
        print(f"Unknown version key: {url_key}")
        return []
    
    print(f"  Fetching: {url}")
    html = fetch_url(url)
    
    if not html:
        print(f"  ⚠ Could not fetch URL - Microsoft may have changed structure")
        print(f"     Manual URL update required in scrape_features.py")
        return []
    
    features = parse_feature_page(html, lang)
    print(f"  Found {len(features)} features")
    
    return features

def convert_txt_to_json(txt_path, lang='en'):
    """Konverter eksisterende .txt fil til JSON format."""
    try:
        with open(txt_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        data = json.loads(content)
        
        if 'BusinessCentralVersion' in data:
            version_info = data['BusinessCentralVersion']
            if 'Version' in version_info and lang not in version_info['Version']:
                version_info['Version'] = f"{version_info['Version']} ({lang.upper()})"
            if 'VersionII' in version_info and lang not in version_info['VersionII']:
                version_info['VersionII'] = f"{version_info['VersionII']} ({lang.upper()})"
        
        return data
    except Exception as e:
        print(f"Error converting {txt_path}: {e}")
        return None

def create_json_output(features, version_name, version_code, lang='en'):
    """Opret JSON struktur som BC extension forventer."""
    return {
        "BusinessCentralVersion": {
            "Version": version_code,
            "VersionII": version_name,
            "Feature": features
        }
    }

def save_json(data, filepath):
    """Gem JSON til fil."""
    filepath.parent.mkdir(parents=True, exist_ok=True)
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    print(f"  ✓ Saved: {filepath}")

def main():
    """Hovedfunktion."""
    lang_arg = 'both'
    if len(sys.argv) > 1:
        lang_arg = sys.argv[1].lower()
    
    languages = ['en', 'da'] if lang_arg == 'both' else [lang_arg]
    
    script_dir = Path(__file__).parent
    output_dir = script_dir.parent / 'features'
    output_dir.mkdir(exist_ok=True)
    
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M')
    print(f"\n{'='*60}")
    print(f"BC Feature Scraper - {timestamp}")
    print(f"Languages: {', '.join(languages)}")
    print('='*60)
    
    # Konverter eksisterende .txt filer til JSON
    print("\n📁 Converting existing .txt files to JSON...")
    for txt_file in sorted(output_dir.glob('BC_*.txt')):
        print(f"  Processing: {txt_file.name}")
        file_lang = 'da' if 'dk' in txt_file.name.lower() else 'en'
        
        data = convert_txt_to_json(txt_file, file_lang)
        if data:
            json_file = output_dir / txt_file.with_suffix('.json').name
            save_json(data, json_file)
    
    # Scrap nye data fra Microsoft Learn
    print("\n🌐 Scraping Microsoft Learn...")
    
    versions_to_scrape = [
        ('2025_2', 'Business Central 2025 Wave 2', 'BC 25.2'),
        ('2024_1', 'Business Central 2024 Wave 1', 'BC 24.1'),
        ('2023_1', 'Business Central 2023 Wave 1', 'BC 23.1'),
    ]
    
    for version_key, version_name, version_code in versions_to_scrape:
        for lang in languages:
            print(f"\n  Scraping {version_name} ({lang.upper()})...")
            
            features = scrape_bc_version(version_key, lang)
            
            if features:
                json_data = create_json_output(
                    features,
                    f"{version_name} ({lang.upper()})",
                    f"{version_code} ({lang.upper()})",
                    lang
                )
                
                filename = f"BC_{version_key.replace('_', '_')}_{lang}.json"
                filepath = output_dir / filename
                save_json(json_data, filepath)
            else:
                print(f"  ⚠ No features found")
    
    print(f"\n{'='*60}")
    print(f"✓ Completed at {datetime.now().strftime('%H:%M')}")
    print('='*60)
    print("\n📝 NOTE: If scraping found no features, Microsoft may have changed")
    print("their URL structure. Update BC_VERSION_URLS in scrape_features.py")
    print("or manually download JSON from Microsoft Learn.")
    print("\nExisting JSON files in features/ are still valid and will be used.")

if __name__ == '__main__':
    try:
        import requests
    except ImportError:
        print("Error: requests library not installed.")
        print("Run: pip3 install requests")
        sys.exit(1)
    
    main()
