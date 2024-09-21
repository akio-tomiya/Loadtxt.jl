# Loadtxt.jl
This is a package for loading a file like


A file ``Plaquette.txt`` is like,
```
0  1.0 # plaq
1  0.6854375345806106 # plaq
2  0.6112020484663069 # plaq
3  0.5892058139713018 # plaq
4  0.5755750821561645 # plaq
5  0.5644999193762664 # plaq
```
and you can load this file *a la* numpy loadtxt.

```
fname = "Plaquette.txt"
loadtxt(fname)
```
then, you will get
```
julia> loadtxt(fname)
5×2 adjoint(::Matrix{Float64}) with eltype Float64:
   0.0  1.0
   1.0  0.685438
   2.0  0.611202
   3.0  0.589206
   4.0  0.575575
   5.0  0.5645
```

```
julia> data = loadtxt(fname)
julia> data[:,2]
502-element Vector{Float64}:
 1.0
 0.6854375345806106
 0.6112020484663069
 0.5892058139713018
 0.5755750821561645
 0.5644999193762664
```

If you want to make a plot of this file,
```
julia> using Plots
julia> plot(data[:,1],data[:,2])
```
