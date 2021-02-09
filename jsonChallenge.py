import json


def read_file(s):
    while True:
        try:
            file1 = input("Digite o nome do " + s + " arquivo a ser comparado:\n")
            with open(file1) as json_file:
                data = json.load(json_file)
                ve = []  # Vetor de estrutura
                vd = []  # Vetor de dados
                cont = 0

                ve.append([])
                vd.append([])
                if type(data) == dict:  # Se a estrutura for dicionário
                    ve[cont].append(str(type(data)))
                    read(data, cont, ve, vd)
                else:
                    ve[cont].append(data + str(type(data)))
                    vd[cont].append(data)
                    if type(data) == list:  # Se a estrutura for lista
                        read(data, cont, ve, vd)
                return [ve, vd]
        except FileNotFoundError:
            print("Arquivo não encontrado.")


def read(struct, cont, ve, vd):
    cont = cont + 1
    if len(ve) < cont + 1:
        ve.append([])
        vd.append([])
    for s in struct:
        if type(s) == dict:  # Se a estrutura for dicionário
            ve[cont].append(str(type(s)))
            read(s, cont, ve, vd)
        else:
            ve[cont].append(s + str(type(struct[s])))
            if type(struct[s]) == dict:  # Se a estrutura for dicionário
                read(struct[s], cont, ve, vd)
            else:
                if type(struct[s]) == list:  # Se a estrutura for lista
                    read(struct[s], cont, ve, vd)
                else:
                    vd[cont].append(struct[s])


def size_cont(v):
    t = 0
    for vv in v:
        for vvv in vv:
            t = t + 1
    return t


def verify(vv1, vv2):
    t = 0  # Total de folhas na árvore
    s = 0  # Total de semelhanças
    cont = 0  # Contador de profundidade na árvore
    t1 = size_cont(vv1)
    t2 = size_cont(vv2)
    if t1 > t2:
        v1 = vv1
        v2 = vv2
    else:
        v1 = vv2
        v2 = vv1

    for v in v1:
        for vv in v:
            t = t + 1
            for vvv in v2[cont]:
                if vv == vvv:
                    s = s + 1
                    break
        cont = cont + 1

    return [t, s]


res = read_file("primeiro")
v1e = res[0]  # Vetor de estrutura do primeiro arquivo
v1d = res[1]  # Vetor de dados do primeiro arquivo

res = read_file("segundo")
v2e = res[0]  # Vetor de estrutura do segundo arquivo
v2d = res[1]  # Vetor de dados do segundo arquivo

res = verify(v1e, v2e)
te = res[0]  # Total de estruturas
se = res[1]  # Total de semelhanças

res = verify(v1d, v2d)
td = res[0]  # Total de dados
sd = res[1]  # Total de semelhanças

pe = se / te  # Porcentagem de semelhanças na estrutura
pd = sd / td  # Porcentagem de semelhanças nos dados
pp = pd * pe  # Porcentagem de semelhanças total
print("A semelhança entre os arquivos é de: " + str(pp) + "\n")
