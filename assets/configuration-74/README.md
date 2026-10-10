# ERAI 74 — Unified spirit count configuration

Run `Configure-Unified-74.cmd` and enter Greatshield `1..5` and Lone Wolf `1..3`. It creates one isolated package/profile under `generated\greatshield-N-lone-wolf-M`, always starting from the accepted `AI_SUMMON_BASELINE`.

The native spirit item still selects the type in game. This is not a mixed party: the two groups coexist in one package, but the user summons one type at a time with the corresponding native item. `Validate-Unified-74.ps1` is offline preflight only and never starts me3 or the game.
