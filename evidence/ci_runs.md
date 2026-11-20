# GitHub Actions runs

| Phase | Commit SHA | Run URL | Result | Slither evidence |
|---|---|---|---|---|
| Vulnerable baseline | `c3988b21e8c9e1cacc04cdd539b8fa265c38b935` | https://github.com/chituong1506/CI-CD/actions/runs/44664472613 | RED (run 44664472613; `audit` failed at the Slither step) | `weak-prng` High, `reentrancy-eth` High, `uninitialized-state` High, `incorrect-equality` Medium, `tx-origin` Medium |
| Patched | `23ba6efce9a2920dad69f3f80abdcdf201cf8d12` | https://github.com/chituong1506/CI-CD/actions/runs/44665721295 | GREEN (run 44665721295; Slither step succeeded) | No configured High/Medium findings |

