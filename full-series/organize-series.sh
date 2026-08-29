#!/usr/bin/env bash
#
# organize-series.sh
#
# Reorganizes the "full-series" directory (60 essays: .tex/.pdf/.aux/.log/.out
# each) into thematic volume subfolders. Run this FROM INSIDE full-series/.
#
# Volume 1 is the original 14 (kept together since you already have an
# audio overview keyed to that set). Volumes 2-7 split the remaining 46
# by the kind of claim/mechanism involved, not by the order they were written.
#
# Safe to re-run: uses `mv -n` (no-clobber) and skips files already moved.

set -euo pipefail

if [ ! -f "biefeld-brown.tex" ]; then
  echo "Error: run this script from inside the full-series/ directory"
  echo "(expected to find biefeld-brown.tex here)."
  exit 1
fi

# ---- Volume definitions ----------------------------------------------

VOL1_NAME="volume-1-original-fourteen"
VOL1=(
  biefeld-brown podkletnov emdrive lifters alcubierre patent-antigravity
  torsion-fields zero-point-energy searl-effect dean-drive
  hutchison-effect grasp-program cold-fusion-antigravity depalma-spinning-ball
)

VOL2_NAME="volume-2-reactionless-thrust"
VOL2=(
  mach-effect-thruster nassikas-thruster heins-perepiteia
  depalma-n-machine tewari-generator
)

VOL3_NAME="volume-3-magnet-and-coil-over-unity"
VOL3=(
  yildiz-motor perendev-motor bedini-motor joe-newman-machine
  steorn-orbo kanarev-electrolysis rodin-coil marinov-motor
)

VOL4_NAME="volume-4-exotic-energy-and-vacuum-theory"
VOL4=(
  hydrino-blacklight papp-engine rossi-ecat stanley-meyer
  shipov-vacuum bearden-scalar kozyrev-mirrors chernetsky-generator
)

VOL5_NAME="volume-5-undemonstrated-personal-claims"
VOL5=(
  schauberger-vortex hamel-spinning-wheel grebennikov-cavity coral-castle
  otis-carr-otcx1 moray-radiant-energy reich-orgone reich-cloudbuster
  rife-machine mitogenetic-radiation callahan-paramagnetism
)

VOL6_NAME="volume-6-institutional-history-and-legend"
VOL6=(
  ufo-reverse-engineering tesla-suppression tesla-teleforce
  bob-lazar-element115 hendershot-generator wilbert-smith-project-magnet
  philadelphia-experiment adamski-contactee die-glocke kecksburg-incident
  pais-patents n-rays-blondlot
)

VOL7_NAME="volume-7-companion-pieces"
VOL7=(
  walking-through-walls lightweight-body-engineering-critique
)

# ---- Move logic ---------------------------------------------------------

EXTS=(tex pdf aux log out)

move_set() {
  local dirname="$1"
  shift
  local names=("$@")
  mkdir -p "$dirname"
  for base in "${names[@]}"; do
    local moved_any=0
    for ext in "${EXTS[@]}"; do
      if [ -f "${base}.${ext}" ]; then
        mv -n "${base}.${ext}" "${dirname}/"
        moved_any=1
      fi
    done
    if [ "$moved_any" -eq 0 ]; then
      echo "  warning: no files found for '${base}' (already moved, or name mismatch)"
    fi
  done
  echo "-> ${dirname}: $(ls "${dirname}"/*.tex 2>/dev/null | wc -l | tr -d ' ') essays"
}

echo "Organizing into volumes..."
move_set "$VOL1_NAME" "${VOL1[@]}"
move_set "$VOL2_NAME" "${VOL2[@]}"
move_set "$VOL3_NAME" "${VOL3[@]}"
move_set "$VOL4_NAME" "${VOL4[@]}"
move_set "$VOL5_NAME" "${VOL5[@]}"
move_set "$VOL6_NAME" "${VOL6[@]}"
move_set "$VOL7_NAME" "${VOL7[@]}"

# ---- Generate a top-level index ------------------------------------------

cat > INDEX.md << 'EOF'
# Antigravity / Fringe Physics Satire Series — Index

## Volume 1 — The Original Fourteen (has a separate audio overview)
- Biefeld-Brown effect
- Podkletnov's rotating superconductor
- The EmDrive
- Lifters
- The Alcubierre drive
- Patent-office antigravity claims
- Torsion fields (Akimov/Shipov)
- Zero-point energy extraction hybrids
- Searl Effect Generator
- Dean Drive
- Hutchison Effect
- Boeing's GRASP program
- Cold fusion + antigravity hybrids
- DePalma's spinning ball

## Volume 2 — Reactionless Thrust / Momentum-Conservation Violations
- Woodward-Mach effect thruster
- Nassikas thruster
- Heins's Perepiteia effect
- DePalma's N-machine
- Tewari's Space Power Generator

## Volume 3 — Permanent-Magnet & Pulsed-Coil "Over-Unity" Motors
- Yildiz Motor
- Perendev magnetic motor
- Bedini motor-generator
- Joe Newman's Energy Machine
- Steorn's Orbo
- Kanarev's rotating water electrolysis
- Rodin Coil
- Marinov's asymmetric homopolar claims

## Volume 4 — Exotic Energy Release & Vacuum/Field Theory
- Hydrino / BlackLight Power
- Papp noble gas engine
- Rossi's E-Cat
- Stanley Meyer's water fuel cell
- Shipov's physical vacuum theory
- Bearden's scalar electromagnetics
- Kozyrev mirrors
- Chernetsky plasma generator

## Volume 5 — Undemonstrated Personal Claims & Anomalous Phenomena
- Schauberger's vortex/implosion claims
- Hamel's spinning wheel
- Grebennikov's cavity structure effect
- Coral Castle (Leedskalnin)
- Otis Carr's OTC-X1
- Moray's Radiant Energy Device
- Reich's orgone accumulator
- Reich's cloudbuster
- Rife machine
- Mitogenetic radiation (Gurwitsch/Kaznacheyev)
- Callahan's soil paramagnetism

## Volume 6 — Institutional History, Legend, and Method
- Electrogravitic UFO reverse-engineering narratives
- Tesla suppression narrative (Wardenclyffe)
- Tesla's teleforce/death ray
- Bob Lazar / Element 115
- Hendershot Fuelless Generator
- Wilbert Smith / Project Magnet
- The Philadelphia Experiment
- George Adamski's contactee claims
- Die Glocke (Nazi Bell)
- Kecksburg incident
- The Pais patents
- N-rays (Blondlot) — the historical anchor case for the whole series' method

## Volume 7 — Companion Pieces
- Why We Can't Walk Through Walls (grounding piece — models good reasoning about scale, doesn't debunk a claim)
- Self-audit of the author's own four proposals (lightweight bone/gas-cell skeleton, mercury battery factory, solar Oberth slingshot, magnetic-floor propulsion)
EOF

echo ""
echo "Done. Wrote INDEX.md."
echo "Remaining loose files in this directory (if any):"
ls ./*.tex 2>/dev/null || echo "  (none — everything sorted)"
