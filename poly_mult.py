import numpy as np

def poly_mult(P,D):

    N = len(P)
    M = len(D)
    NM = (N-1)+(M-1)+1
    Q = np.zeros(NM)

    print N, M, NM
    for i in range(N):
        for j in range(i+1):
            Q[i] += P[j]*D[i-j]

    for i in range(M-N):
        for j in range(N):
            Q[N+i] += P[j]*D[i+N-j]

    for i in range(1,N):
        for j in range(N-i):
            Q[NM-N+i] += P[i+j]*D[M-j-1]

    return Q

def poly_mult1(P,D):

    D = D[::-1]
    N = len(P)
    M = len(D)
    NM = (N-1)+(M-1)+1
    P = np.hstack((np.zeros(M-1),P,np.zeros(M-1)))
    D = np.hstack(D)
    Q = np.zeros(NM)

    print P
    print D

    print N,M,NM

    for i in range(NM):
        for j in range(M):
            print i,j+i,j
            Q[i] += P[j+i]*D[j]

    return Q
