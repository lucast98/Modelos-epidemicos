using PyCall

matplotlib = pyimport("matplotlib") 
plt = pyimport("matplotlib.pyplot")

delta_t = 0.25 #intervalo de tempo entre valores
N = 100 #tamanho da população
S = [] #vetor com qtd de pessoas suscetíveis em função de n
I = [] #vetor com qtd de pessoas infectadas em função de n
alfa = 2 #taxa de contato

#Função para definir as condições inicias de cada subpopulação
function initialConditions(S, I)
    push!(I, 1)  #condição inicial
    push!(S, N-I[1])  #condição inicial 
end

#Função para obter o resultado do modelo SI com uma única população
function discreteSI_model(S, I)
    produto = (alfa*delta_t)/N
    for n = 1:N-1
        #println(S[n], " - ", I[n])
        push!(S, floor(S[n]*(1 - produto*I[n]))) #armazena o novo valor no vetor de suscetíveis, além de arredondar para menos
        push!(I, ceil(I[n]*(1 + produto*S[n]))) #armazena o novo valor no vetor de infectados, além de arredondar para mais
    end
end

function main()
    initialConditions(S, I)
    if S[1] <= 0 || I[1] <= 0
        println("Condições iniciais não-positivas.")
    elseif alfa <= 0
        println("Alfa deve ser maior que zero.")
    elseif delta_t > 1/alfa
        println("Delta t deve ser menor ou igual a 1/alfa.")
    else
        discreteSI_model(S, I)
        plt.figure()
        plt.plot(I, linestyle=":", marker="x", color="red", label = "Infectados")
        plt.plot(S, linestyle=":", marker="o", color="blue", label = "Suscetíveis")
        plt.xlabel("n")
        plt.ylabel("I(n), S(n)")
        plt.legend(fancybox=true, framealpha=1, shadow=true, borderpad=1)

        plt.show()
    end
end

main()