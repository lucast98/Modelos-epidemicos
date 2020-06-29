using PyCall
matplotlib = pyimport("matplotlib") 
plt = pyimport("matplotlib.pyplot")

delta_t = 0.25 #intervalo de tempo entre valores
N = 100 #tamanho da população
S = [] #vetor com qtd de pessoas suscetíveis em função de n
I = [] #vetor com qtd de pessoas infectadas em função de n
R = []
alfa = 2 #taxa de contato
gamma = 0.5#chance de um individuo infectado ser removido do processo de infecção

c1 = (alfa*delta_t)/N
c2 = (gamma*delta_t)

function initialConditions(S,I,R)
    push!(I,1)
    push!(R,0)#aqui assumimos que inicialmente ninguem é imune a doença(se acharem necessario podemos atribuir um valor para os já imunes)
    push!(S,N-(I[1]+R[1]))
end

function discreteSIR_model(S, I, R)
    for n = 1:N-1
        println(S[n], " - ", I[n],"-",R[n])
        push!(S, floor(S[n]*(1 - c1*I[n]))) #armazena o novo valor no vetor de suscetíveis, além de arredondar para menos
        push!(I, ceil(I[n]*(1 - c2 + c1*S[n]))) #armazena o novo valor no vetor de infectados, além de arredondar para mais
        push!(R, floor(R[n]) + c1*I[n])#quando rodar verificar o arredondamento,se deve ser para baixo ou para cima, se for o caso nao arredondar ou revisar o arredondamento
    end
end

function main()
    initialConditions(S, I, R)
    if S[1] <= 0 || I[1] <= 0 || R[1] < 0
        println("Condições iniciais não-positivas.")
    elseif alfa <= 0
        println("Alfa deve ser maior que zero.")
    elseif gamma <= 0 || gamma > 1
        println("Gamma deve ser uma probabilidade.")
    elseif delta_t > 1/alfa || delta_t > 1/gamma
        println("Delta t deve ser menor ou igual ao menor valor entre 1/alfa e 1/gama.")
    else
        discreteSIR_model(S, I, R)
        plt.figure()
        plt.plot(I, linestyle=":", marker="x", color="red", label = "Infectados")
        plt.plot(S, linestyle=":", marker="o", color="blue", label = "Suscetíveis")
        plt.plot(R, linestyle=":", marker="v", color="green", label = "Recuperados")#talvez esse titulo recuperados nao seja o ideal
        plt.xlabel("n")
        plt.ylabel("I(n), S(n),R(n)")
        plt.legend(fancybox=true, framealpha=1, shadow=true, borderpad=1)

        plt.show()
    end
end

main()