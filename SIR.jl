using PyCall

matplotlib = pyimport("matplotlib") 
plt = pyimport("matplotlib.pyplot")

delta_t = 0.25 #intervalo de tempo entre valores
N = 100 #tamanho da população
S = [] #vetor com qtd de pessoas suscetíveis em função de n
I = [] #vetor com qtd de pessoas infectadas em função de n
R = [] #vetor com qtd de pessoas rejeitadas em função de n
alfa = 2 #taxa de contato
gamma = 1 #chance de um individuo infectado ser removido do processo de infecção

#Função para definir as condições inicias de cada subpopulação
function initialConditions(S, I, R)
    push!(I, 1)  #condição inicial
    push!(R, 0) #condição inicial (aqui assumimos que inicialmente ninguem é imune a doença)
    push!(S, N-I[1]-R[1])  #condição inicial 
end

#Função para obter o resultado do modelo SI com uma única população
function discreteSI_model(S, I, R)
    produto = (alfa*delta_t)/N
    for n = 1:30
        push!(S, floor(S[n]*(1 - produto*I[n]))) #armazena o novo valor no vetor de suscetíveis, além de arredondar para menos
        push!(I, ceil(I[n]*(1 - gamma*delta_t + produto*S[n]))) #armazena o novo valor no vetor de infectados, além de arredondar para mais
        #push!(R, floor(R[n] + gamma*delta_t*I[n])) #armazena o novo valor no vetor de removido (talvez o erro esteja no arredondamento)
        push!(R, N-S[n+1]-I[n+1]) 
    end
    println(S)
    println(I)
    println(R)
end

function main()
    initialConditions(S, I, R)
    if S[1] <= 0 || I[1] <= 0 || R[1] < 0
        println("Condições iniciais não-positivas.")
    elseif alfa <= 0
        println("Alfa deve ser maior que zero.")
    elseif gamma <= 0
        println("Gamma deve ser maior que zero")
    elseif delta_t > min(1/alfa, 1/gamma)
        println("Delta t deve ser menor ou igual a ", min(1/alfa, 1/gamma), ".")
    else
        R0 = (S[1]*alfa)/(N*gamma)
        println("R0 = ", R0)
        discreteSI_model(S, I, R)
        plt.figure()
        plt.plot(I, linestyle=":", marker="x", color="red", label = "Infectados")
        plt.plot(S, linestyle=":", marker="o", color="blue", label = "Suscetíveis")
        plt.plot(R, linestyle=":", marker="v", color="green", label = "Removidos")
        plt.xlabel("n")
        plt.ylabel("I(n), S(n), R(n)")
        plt.legend(fancybox=true, framealpha=1, shadow=true, borderpad=1)

        plt.show()
    end
end

main()