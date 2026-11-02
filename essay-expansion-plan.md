# Essay Expansion Plan

This is the working roadmap for expanding the essays in `full-series` into the same developed form used in `developed/volume-1-original-fourteen`.

## 1. Scope and workflow

- Keep all originals in `full-series` untouched.
- Create matching folders in `developed/volume-2-reactionless-thrust`, `developed/volume-3-magnet-and-coil-over-unity`, `developed/volume-4-exotic-energy-and-vacuum-theory`, `developed/volume-5-undemonstrated-personal-claims`, `developed/volume-6-institutional-history-and-legend`, and `developed/volume-7-companion-pieces`.
- Work one volume at a time.
- Stop after each volume for review before moving to the next one.
- Use the model essays in `developed/volume-1-original-fourteen` as the reference for tone and structure.
- If any model is missing, use `developed/volume-1-original-fourteen/podkletnov.tex` as the fallback reference.
- Volume 2 remains awaiting its required build check because no LaTeX compiler was available. At the user's request, limited Volume 3 drafting has begun before that gate is cleared; this does not mark Volume 2 complete.

## 1.1 Current Volume 2 status

| Essay | Status |
|---|---|
| `depalma-n-machine` | Revised; shaft torque and angular speed remain central; historical details without verified sources are removed or qualified. Build not verified. |
| `heins-perepiteia` | Revised; unsupported history and test claims are removed or qualified; test requirements are distinguished from tests actually performed. Build not verified. |
| `tewari-generator` | Revised; unsupported design, performance, and test-history claims are removed or qualified. Build not verified. |
| `mach-effect-thruster` | Drafted around the full Dresden torsion-balance analysis and Woodward's separately reported pendulum response. Citation review recorded. Build not verified. |
| `nassikas-thruster` | Drafted with claims limited to the source record located; unsupported force values and replication claims removed. Build not verified. |

All five Volume 2 source reviews and draft revisions are complete, but the volume has not passed its required build gate. No LaTeX compiler (`pdflatex`, `latexmk`, or `tectonic`) was available during the prior check. Volume 3 drafting is now proceeding on the user's explicit request; do not mark Volume 2 complete.

## 1.2 Limited Volume 3 drafting

| Essay | Status |
|---|---|
| `bedini-motor` | Expanded with verified Bedini patent records; the original draft's categorical claims about independent tests and a demonstrated measurement error were softened because no supporting test report was verified. |
| `kanarev-electrolysis` | Expanded with an evidence-limited account and a verified NIST water thermochemistry source; Kanarev-specific performance, measurement-error, and publication-history claims remain unverified and are not stated as established findings. |
| Remaining six essays | Not started. |

This is a limited continuation, not a declaration that Volume 3 is complete. Pause for review after these two essays unless the user asks to continue.

## 2. Target structure for each essay

Each essay should be rewritten to match this general pattern:

- Title stays faithful to the original topic but avoids question titles and avoids the word “critique” in the title.
- Abstract framing the claim, evidence, and limits of the claim.
- Introduction establishing the claim and why it became important.
- History of the claim: who advanced it, when, and in what context.
- Explanation of the underlying theory in clear but rigorous prose.
- Section on the test or replication record, stating only what the actual literature supports.
- Section on the strongest objection stated fairly and without caricature.
- Response or qualification of the claim.
- Closing paragraph stating plainly what the paper does not prove.
- Bibliography included inside the same `.tex` file under `\begin{thebibliography}{99}`.
- Every `\cite` must match a `\bibitem`, and there must be no unused entries.

## 3. Writing rules

- Write in long academic paragraphs, not bullet points or clipped fragments.
- Do not use em dashes.
- Do not use emojis.
- Do not write in the first person.
- Do not foreground the author as a narrated figure.
- Keep the original author's thesis and entropic-gravity framing wherever it is present.
- Expand each essay to roughly 1,500 to 2,500 words.
- Use byline: `Flyxion` and affiliation `Independent Researcher`.
- Keep the tone skeptical, measured, and evidence-based rather than polemical.

## 4. Sourcing and verification rules

- Only cite works that can be verified.
- Verify each citation through an arXiv listing, journal page, or a reference list in another verified paper.
- If a claim cannot be verified, rewrite it to say only what the record genuinely supports.
- Do not fabricate reports, patent numbers, discontinued program details, or replication methods.
- If the original essay makes a claim without solid support, make it explicit that the evidence is absent.
- When serious counterarguments exist, present them fairly before answering them.
- If a citation cannot be verified, note it in the final review report rather than guessing.

## 5. LaTeX and build checklist

For each essay:

- Create the new `.tex` file in the matching `developed/volume-N` folder.
- Keep the file self-contained with its own bibliography.
- Ensure all titles in the bibliography are in headline case.
- Ensure every citation key is used and every entry is used.
- Compile with `pdflatex` twice where the toolchain is available. If unavailable, record the blocker and do not describe the essay as built.
- Confirm there are no errors and no undefined citations.
- Delete `.aux`, `.log`, and `.out` files after successful compilation.
- Leave the original files in `full-series` unchanged.
- Do not commit or push.

## 6. Volume-by-volume rollout

### Volume 2: Reactionless Thrust

- [x] depalma-n-machine draft and source review
- [x] heins-perepiteia draft and source review
- [x] mach-effect-thruster draft and source review
- [x] nassikas-thruster draft and source review
- [x] tewari-generator draft and source review
- [ ] Build all five files twice, check for errors and undefined citations, and remove generated auxiliary files

### Volume 3: Magnet and Coil Over Unity

- [x] bedini-motor draft and citation review
- joe-newman-machine
- [x] kanarev-electrolysis draft and citation review
- marinvov-motor
- perendev-motor
- rodin-coil
- steorn-orbo
- yildiz-motor

### Volume 4: Exotic Energy and Vacuum Theory

- bearden-scalar
- chernetsky-generator
- hydrino-blacklight
- kozyrev-mirrors
- papp-engine
- rossi-ecat
- shipov-vacuum
- stanley-meyer

### Volume 5: Undemonstrated Personal Claims

- callahan-paramagnetism
- coral-castle
- grebennikov-cavity
- hamel-spinning-wheel
- mitogenetic-radiation
- moray-radiant-energy
- otis-carr-otcx1
- reich-cloudbuster
- reich-orgone
- rife-machine
- schauberger-vortex

### Volume 6: Institutional History and Legend

- adamski-contactee
- bob-lazar-element115
- die-glocke
- hendershot-generator
- kecksburg-incident
- n-rays-blondlot
- pais-patents
- philadelphia-experiment
- tesla-suppression
- tesla-teleforce
- ufo-reverse-engineering
- wilbert-smith-project-magnet

### Volume 7: Companion Pieces

- lightweight-body-engineering-critique
- walking-through-walls

## 7. Review gates

After each volume:

- Read the generated files for consistency.
- Check that the thesis remains intact.
- Check that the entropic-gravity framing was preserved where it existed.
- Check the bibliography for unused or broken citations.
- Check the writing style for repetition, invented details, or unsupported claims.
- Check all compile steps and cleanup requirements.
- Report any unverifiable citations.
- Await approval before starting the next volume.

## 8. Final success criteria

The work is complete only when:

- Every essay in volumes 2 through 7 has a matching developed file.
- Each file is fully compiled and clean.
- The writing matches the model form and tone.
- No unsupported claims were inserted.
- The bibliography is internally consistent.
- The originals remain untouched.
- The user can review and commit the files themselves.

## 9. Copilot-ready prompt

Use this as the direct prompt for Copilot if needed:

The folder developed/volume-1-original-fourteen contains fourteen expanded LaTeX essays, each with a built PDF. Treat them as the model for every other essay in full-series. Expand the essays in volumes 2 through 7 of full-series into the same form, writing the new files into a matching developed/volume-N folder and leaving the originals untouched. Work one volume at a time and stop after each volume for review before starting the next one. Each essay should grow to roughly 1,500 to 2,500 words, keep the author's original thesis and its entropic-gravity framing section, and gain a history of the claim, a section on the replication or test record, a section on the strongest objection stated fairly, and a closing paragraph that says plainly what the paper does not prove.

Write in long academic paragraphs, never bullets or clipped sentences. Do not use em dashes, emojis, or the word critique in a title, and avoid titles phrased as questions. Do not write in the first person or foreground the author as a narrated figure. Do not invent probabilities, scores, or statistics; if a number appears, derive it in the text from a stated formula. Titles in the bibliography must be in headline case, and the bibliography belongs inside the same .tex file as a thebibliography section, with every \cite key matching a \bibitem and no unused entries. Use the byline Flyxion with the affiliation Independent Researcher and no other name.

Sourcing is the main risk. Only cite a work you can confirm exists, by checking its arXiv listing, journal page, or a reference list in another paper. If you cannot verify an author list, title, volume, or page range, give less detail rather than guessing, and never fabricate a report, patent number, or case. Where the original essay asserts something you cannot find support for, such as a replication that used a particular method or a program that was discontinued, rewrite it to say only what the record shows and say that the evidence is absent. Where the literature contains a serious counterargument, present it honestly before answering it, as was done for the Army Research Laboratory report in the Biefeld-Brown essay and the positive-energy warp drive papers in the Alcubierre essay.

Build each file with pdflatex run twice, confirm there are no errors or undefined citations, delete the .aux, .log, and .out files, and report a list of any citation you could not verify. If the model essay in developed/volume-1-original-fourteen is unavailable, use developed/volume-1-original-fourteen/podkletnov.tex as the default reference. Do not commit or push; leave the changes for me to review and commit myself.
