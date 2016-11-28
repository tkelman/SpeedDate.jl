# SpeedDate.jl

A simple tool for the estimation of coalescence times between sequences.
Created with julia and [Bio.jl](https://github.com/BioJulia/Bio.jl)

## Quick Start

### Installation

Enter in a Julia terminal:
```julia
Pkg.clone("https://github.com/Ward9250/SpeedDate.jl.git")
```
To download and install the master branch. Note the master branch is ahead
of any release and so may contain bugs of incomplete features.

### Useage

To use the SpeedDate program on the command line, invoke julia like so:

```sh
julia -e"using SpeedDate; SpeedDate.main()"
```

The `compute` command is invoked to compute genetic distances and coalescence times
for an input aligned FASTA file. Use the -h flag to display the possible options
for the `compute` command:

```sh
julia -e"using SpeedDate; SpeedDate.main()" compute -h

usage: <PROGRAM> compute [-f FILE] [-s [DNASEQS...]] [-m MODEL]
                        [-r MUTATION_RATE] [--method METHOD]
                        [-o OUTFILE] [--scan] [-w WIDTH] [-j STEP]
                        [--onlydist] [-h]

optional arguments:
  -f, --file FILE       An input file.
  -s, --dnaseqs [DNASEQS...]
                        The first of two DNA sequences to test (type:
                        Bio.Seq.BioSequence{Bio.Seq.DNAAlphabet{4}})
  -m, --model MODEL     The model used to compute genetic distances.
                        Currently jc69, and k80 are supported.
                        (default: "jc69")
  -r, --mutation_rate MUTATION_RATE
                        The mutation rate to be assumed. (type:
                        Float64, default: 1.0e-8)
  --method METHOD       The dating method to use. Currently 'default'
                        and 'simple' are supported.  (default:
                        "default")
  -o, --outfile OUTFILE
                        Base name for the output files(s). (default:
                        "SpeedDate")
  --scan                Whether or not to compute dates across
                        sequences with a sliding window.
  -w, --width WIDTH     Width of the sliding window across sequences.
                        (type: Int64, default: 100)
  -j, --step STEP       The number of base pairs the sliding window
                        moves by each iteration. (type: Int64,
                        default: -1)
  --onlydist
  -h, --help            show this help message and exit
```

_A note about unit tests, as SpeedDate essentially wraps Bio.jl functionality in a command line or GTK gui, no unit tests have been included yet, as the functions used have their own unit tests in the BioJulia project in which they are defined._ 
