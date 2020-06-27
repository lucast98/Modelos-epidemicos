using PyCall

matplotlib = pyimport("matplotlib") 
plt = pyimport("matplotlib.pyplot")

k = 2 #numero de populações
delta_t = 0.25 #intervalo de tempo entre valores
N = ones(Int, 3*k) #tamanho da população i 
S = zeros(3*k) #matriz com qtd de pessoas suscetíveis em uma subpopulação
I = zeros(3*k) #matriz com qtd de pessoas infectadas em uma subpopulação
alfa = zeros(3*k) #matriz com taxa de contato de pessoas de grupo i com pessoas do grupo k

#Função que representa um somatório 
function sum(alfa, N, I, n)
    sum = 0
    for j = 1:k
        sum = sum + ((alfa[j]*delta_t)/N)*I[j][n]
    end
    return sum
end

#Função para somar a condição de não-negatividade a ser verificada
function sum2(alfa, N)
    sum = 0
    for j = 1:k
        sum = sum + ((alfa[j]*delta_t*N[k])/N[j])
    end
    return sum
end

#Função para o obter o valor maximo entre k-1 valores
function getMax(alfa)
    maxVar = 0
    for i = 1:k
        for n = 1:k-1
            maxVar = max(maxVar, sum2(alfa[i], N))
        end
    end
    return maxVar
end

#Função para concatenar o elemento 0 em uma lista
function catMatrix(qtd)
    m = Int[]
    for i = 1:qtd
        push!(m, 0)
    end
    return m
end

#Função para criar uma matriz bidimensional
function createMatrix(X, qtd)
    X = [X, catMatrix(qtd)] #junta os dois primeiros em uma lista
    i=2
    for i in 3:k
        push!(X, catMatrix(qtd)) #adiciona os demais na mesma lista
    end
    return X
end

#Função para definir as condições inicias de cada subpopulação
function initialConditions(S, I, alfa)
    for i = 1:3*k
        N[i] = 3*k #qtd de pessoas na população i
    end

    S = createMatrix(S, 3*k) #cria matriz de pessoas suscetíveis
    I = createMatrix(I, 3*k) #cria matriz de pessoas infectadas
    alfa = createMatrix(alfa, 3*k) #cria matriz do alfa
    
    for n = 1:k
        I[n][1] = 1 #condição inicial
        S[n][1] = N[n]-I[n][1] #condição inicial
    end

    for i = 1:k
        for j = 1:3*k
            alfa[i][j] = j #valores de alfa entre as populações
        end
    end

    #= println(S)
    println(I)
    println(alfa) =#
    return S,I,alfa
end

#Função para obter o resultado do modelo SI com k populações
function discreteSI_model(S, I, alfa)
    for i = 1:k
        for n = 1:3*k-1
            produto = sum(alfa[i], N[i], I, n)
            S[i][n+1] = floor(S[i][n]*(1 - produto)) #valor discretizado da qtd de pessoas suscetíveis em uma população no tempo n
            I[i][n+1] = ceil(I[i][n] + S[i][n]*produto) #valor discretizado da qtd de pessoas infectadas em uma população no tempo n
        end
    end
end

function main()
    S2,I2,alfa2 = initialConditions(S, I, alfa)

    for i = 1:k
        if S2[i][1] <= 0 || I2[i][1] < 0
            println("Condições iniciais da subpopulação ", i ," não-positivas.")
            return
        end
    end
    if getMax(alfa2) > 1
        println("Condição de não-negatividade não atendida")
    else
        discreteSI_model(S2, I2, alfa2)
        plt.figure()
        for j = 1:k
            c=[Float16(j)/Float16(k), 0.0, Float16(k-j)/Float16(k)] #valor RGB da cor
            c2=[Float16(j/2)/Float16(k), 0.5, Float16(k-j/2)/Float16(k)] #valor RGB da cor
            plt.plot(I2[j], linestyle=":", marker="x", color=c, label = "Infectados da subpopulação $j")
            plt.plot(S2[j], linestyle=":", marker="o", color=c2, label = "Suscetíveis da subpopulação $j")
        end
        plt.xlabel("n")
        plt.ylabel("I(n), S(n)")
        plt.legend(fancybox=true, framealpha=1, shadow=true, borderpad=1)
        plt.show()
    end
end    

main()