# ERAI 90 Group Guard V1

This is an offline, reversible AI Lua experiment candidate. It changes only the copied `script/700010_battle.luabnd.dcx`; the regulation copy is unchanged from the 81 baseline.

The candidate evaluates a geometric condition in the shared 700010 Goal: self-to-player <= 8 and self-to-current-enemy <= 12, excluding the existing 10312/10317/10318 forced branch. It assigns a temporary action that approaches `TARGET_HOSTPLAYER` for 3 seconds, then guards `TARGET_ENE_0` for 5 seconds. This is not threat-intent prediction and does not provide member separation.

Manual test is not authorized by this build step. If later approved, use the profile with the existing verified me3 0.13.0 offline launcher, one session only, and keep the 81 package for rollback.