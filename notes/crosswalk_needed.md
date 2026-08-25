# Occupation Crosswalk Needed

The ACS/IPUMS file uses Census occupation codes in `occ`.

The Dingel-Neiman remote-workability file uses SOC occupation codes in `onetsoccode`.

These do not merge directly. Before running the full analysis, add a crosswalk file:

```text
data/raw/remote/occ_soc_crosswalk.csv
```

The crosswalk should have:

```text
occ
onetsoccode
```

Useful places to look:

- IPUMS OCC/OCCSOC crosswalk documentation
- Census occupation code lists and crosswalks
- BLS National Employment Matrix/SOC to ACS crosswalk
