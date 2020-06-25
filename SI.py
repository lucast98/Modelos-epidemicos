from matplotlib import pyplot as plt
import numpy as np
import math

delta_t = 0.25
N = 100
I = np.zeros(N)
S = np.zeros(N)
I[0] = 1
S[0] = N-I[0]
alfa = 2

def discreteSI_model():
    #print("0", S[0], I[0])
    produto = (alfa*delta_t)/N
    for n in range(len(S)-1):
        S[n+1] = S[n]*(1 - produto*I[n])
        S[n+1] = math.floor(S[n+1])

        I[n+1] = I[n]*(1 + produto*S[n])
        I[n+1] = math.ceil(I[n+1])
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

            