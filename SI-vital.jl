using PyCall

matplotlib = pyimport("matplotlib") 
plt = pyimport("matplotlib.pyplot")

delta_t = 0.5 #intervalo de tempo entre valores
N = 100 #tamanho da população
S = [] #vetor com qtd de pessoas suscetíveis em função de n
I = [] #vetor com qtd de pessoas infectadas em função de n
alfa = 2 #taxa de contato
beta = 0.3 #taxa de nascimento, que é igual a de morte

#Função para definir as condições inicias de cada subpopulação
function initialConditions(S, I)
    push!(I, 1)  #condição inicial
    push!(S, N-I[1])  #condição inicial 
end

#Função para obter o resultado do modelo SI com uma única população
function discreteSI_model(S, I)
    produto = (alfa*delta_t)/N
    for n = 1:30
        push!(S, floor(S[n]*(1 - produto*I[n]) + beta*delta_t*(N-S[n]))) #armazena o novo valor no vetor de suscetíveis, além de arredondar para menos
        push!(I, ceil(I[n]*(1 - beta*delta_t + produto*S[n]))) #armazena o novo valor no vetor de infectados, além de arredondar para mais
    end
    #= println(S)
    println(I) =#
end

function main()
    R0 = alfa/beta
    println("R0: ", R0)
    initialConditions(S, I)
    if S[1] <= 0 || I[1] <= 0
        println("Condições iniciais não-positivas.")
    elseif beta*delta_t > 1
        println("Beta*Delta t deve ser menor ou igual a 1.")
    elseif alfa*delta_t >= (1 + sqrt(beta*delta_t))^2
        println("Alfa*Delta t deve menor que (1 + sqrt(Beta*Delta t))^2.")
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