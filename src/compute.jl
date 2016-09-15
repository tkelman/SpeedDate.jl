
function gather_sequences(args)
    names = Vector{ASCIIString}()
    seqs =  Vector{DNASequence}()
    if haskey(args, "dnaseqs")
        n = 0
        for i in args["dnaseqs"]
            n += 1
            push!(names, "cmdSeq_$n")
            push!(seqs, i)
        end
    end
    if haskey(args, "file") && typeof(args["file"]) != Void
        for i in open(FASTAReader, args["file"])
            push!(names, i.name)
            push!(seqs, i.seq)
        end
    end
    @assert length(seqs) >= 2 error("2 or more sequences must be provided.")
    return Indexer(names), seqs
end

function generate_names_lists(indexer::Indexer)
    l = length(names(indexer))
    list1 = Vector{Symbol}(binomial(l, 2))
    list2 = Vector{Symbol}(binomial(l, 2))
    k = 0
    for i in 1:l
        for j in i+1:l
            k += 1
            list1[k] = indexer.names[i]
            list2[k] = indexer.names[j]
        end
    end
    return list1, list2
end

function pairwise_dates{D<:EvolutionaryDistance,S<:Sequence}(::Type{D}, sequences::Vector{S},
    mu::Float64, method)

    slen = length(sequences[1])
    for seq in sequences
        @assert length(seq) == slen error("Sequences must be of the same length!")
    end

    dists, vars = distance(D, sequences)
    Ts = zeros(Float64, length(dists))

    @inbounds for i in 1:length(dist)
        nmut = convert(Int, ceil(dists[i] * slen))
        Ts[i] = Dating.middle(coaltime(slen, nmut, mu, method))
    end
    return Ts
end

#=
function pairwise_dates{D<:EvolutionaryDistance,S<:Sequence}(sequences::Vector{S},
    mu::Float64, model::Type{D}, method, width::Int64, length::Int64)



    slen = length(sequences)
    times = zeros(Float64, slen, slen)
    for i = 1:slen, j = i+1:slen
        Dist, Var = distance(model, sequences[i], sequences[j])
        nmut = convert(Int, ceil(Dist * slen))
        T = coaltime(length(sequences[i]), nmut, mu, method)
        mT = Dating.middle(T)
        times[i, j] = times[j, i] = mT
    end
    return times
end
=#

function compute(args)

    index, sequences = gather_sequences(args)
    names1, names2 = generate_names_lists(index)

    m = lowercase(args["model"])
    if m == "jc69"
        model = JukesCantor69
    elseif m == "k80"
        model = Kimura80
    else
        error("Invalid choice of distance model.")
    end
    distfile = open("$(args["outfile"])_distances.txt", "w")
    if args["scan"]
        if args["step"] <= 0
            args["step"] = args["width"]
        end
        dists = distance(model, sequences, args["width"], args["step"])
    else
        dists, vars = distance(model, sequences)
        for i in 1:length(names1)
            print(distfile, names1[i])
            print(distfile, ", ")
            print(distfile, names2[i])
            print(distfile, ", ")
            print(distfile, dists[i])
            print(distfile, "\n")
        end
    end
    close(distfile)
#=
    met = lowercase(args["method"])
    if met == "default"
        dmethod = SpeedDating
    elseif met == "simple"
        dmethod = SimpleEstimate
    else
        error("Invalid choice of coalescence time estimate method.")
    end





        times = pairwise_dates(sequences, args["mutation_rate"], model, dmethod, )

        times = pairwise_dates(sequences, args["mutation_rate"], model, dmethod)
        writedlm("$(args["outfile"]).txt", times)
=#


end
