**Disclaimer: This package is under heavy construction.**

# T8code.jl

**T8code.jl** is a Julia package that wraps
[t8code](https://github.com/holke/t8code), a C library to manage multiple
connected adaptive binary trees, quadtrees, and octrees in parallel.

## Installation
If you have not yet installed Julia, please [follow the instructions for your
operating system](https://julialang.org/downloads/platform/). T8code.jl works
with Julia v1.6 or newer.

T8code.jl depends on [t8code](https://github.com/holke/t8code) and a MPI
distribution provided by your system.

## Setup
For example, if your t8code library is installed to `/opt/t8code`,
use it from T8code.jl by executing
```bash
$ export JULIA_T8CODE_PATH="/opt/t8code"
$ julia --project
```
## Usage
Check out the `examples/tutorials` directory on how to use this package.

## Timings
Using T8code.jl for the first time will take several seconds to precompile.
For example, on my machine I get:
```
julia> @time using T8code
 [... some output ...]
 19.333991 seconds (551.69 k allocations: 39.069 MiB, 0.25% compilation time)
```
Using the module next time is much faster:
```
julia> @time using T8code
 0.330443 seconds (514.11 k allocations: 37.093 MiB, 8.33% compilation time)
```

## Authors
T8code.jl is maintained by
[Johannes Markert](https://www.jmark.de)
(German Aerospace Center (DLR), Germany),
The [t8code](https://github.com/holke/t8code) library itself is maintained by
Johannes Holke and many others.

## License
T8code.jl is licensed under the MIT license (see [LICENSE.md](LICENSE.md)).
[t8code](https://github.com/holke/t8code) itself is licensed under the GNU
General Public License, version 2.
