# Mod source

This directory contains the source used to build the corresponding OpenDereth mod packages.

The projects target OpenDereth's pinned ACE.Server 1.1 / .NET 10 runtime and reference `ACE.Server.csproj`. To rebuild one, place or sync its project directory under an OpenDereth checkout's `Source` directory, build it against that exact ACE version, run the relevant tests, and package it with OpenDereth's `scripts/package-mod.ps1` helper.

| Directory | Package ID | Origin |
|---|---|---|
| `AquafirCreatureVariants` | `opendereth.aquafir-creature-variants` | Aquafir creature concepts, reviewed, completed, and made stackable for OpenDereth |
| `CriticalOverride` | `aquafir.critical-override` | Aquafir sample, ported and tested for OpenDereth |
| `ExpandedCastOnStrike` | `titaniumweiner.ace-unique-weenies-proc` | ACEUniqueWeenies behavior, packaged for OpenDereth |
| `HelloCommand` | `aquafir.hello-command` | Aquafir developer sample, ported for OpenDereth |
| `MultiImbue` | `opendereth.three-imbues` | OpenDereth |
| `SocietyTailoring` | `aquafir.society-tailoring` | Aquafir sample, ported and tested for OpenDereth |
| `UnlimitedStatAugmentation` | `opendereth.unlimited-stat-augmentation-gems` | OpenDereth |
| `UnlimitedSkillSpecializations` | `opendereth.unlimited-skill-specializations` | OpenDereth |
| `UniversalLootLuck` | `opendereth.universal-loot-luck` | OpenDereth |

Original-author links and attribution are preserved in each project README and in the main catalog. CustomClothingBase source remains in [OptimShi's authoritative repository](https://github.com/OptimShi/CustomClothingBase); its binaries are not represented here as OpenDereth-authored source.
