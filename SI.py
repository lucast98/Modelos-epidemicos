from matplotlib import pyplot as plt
import numpy as np
import math

delta_t = 0.25 #intervalo de tempo entre valores
N = 100 #tamanho da população
I = np.zeros(N) #vetor com qtd de pessoas infectadas em função de n
S = np.zeros(N) #vetor com qtd de pessoas suscetíveis em função de n
I[0] = 1 #condição inicial
S[0] = N-I[0] #condição inicial
alfa = 2 #taxa de contato

#Função para obter o resultado do modelo SI com uma única população
def discreteSI_model():
    #print("0", S[0], I[0])
    produto = (alfa*delta_t)/N
    for n in range(len(S)-1):
        S[n+1] = S[n]*(1 - produto*I[n])
        S[n+1] = math.floor(S[n+1]) #arredonda para menos

        I[n+1] = I[n]*(1 + produto*S[n])
        I[n+1] = math.ceil(I[n+1]) #arredonda par mais
        #print(n+1, S[n+1], I[n+1])

if __name__ == '__main__':
    #print(I[0])
    if S[0] <= 0 or I[0] <= 0:
        print("Condições iniciais não-positivas.")
    elif alfa <= 0:
        print("Alfa deve ser maior que zero.")
    elif (delta_t > 1/alfa):
        print("Delta t deve ser menor ou igual a 1/alfa.")
    else:
        discreteSI_model()
        plt.plot(I, linestyle=':', marker='x', color='red', label = 'Infectados')
        plt.plot(S, linestyle=':', marker='o', color='blue', label = 'Suscetíveis')
        plt.xlabel('n')
        plt.ylabel('I(n), S(n)')
        plt.legend(fancybox=True, framealpha=1, shadow=True, borderpad=1)
        plt.show()

            
