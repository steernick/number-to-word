def kwota_slownie(kwota):

    JEDN = ("", "jeden", "dwa", "trzy", "cztery", "pięć",
            "sześć", "siedem", "osiem", "dziewięć")
    DZIES = ("", "dziesięć", "dwadzieścia", "trzydzieści",
            "czterdzieści", "pięćdziesiąt", "sześćdziesiąt",
            "siedemdziesiąt", "osiemdziesiąt", "dziewięćdziesiąt")
    NAST = ("dziesięć", "jedenaście", "dwanaście", "trzynaście",
            "czternaście", "piętnaście", "szesnaście", "siedemnaście",
            "osiemnaście", "dziewiętnaście")
    SETY = ("", "sto", "dwieście", "trzysta", "czterysta",
            "pięćset", "sześćset", "siedemset", "osiemset",
            "dziewięćset")
    I = ("bilion", "miliard", "milion", "tysiąc", "złoty", "grosz")
    II = ("biliony", "miliardy", "miliony", "tysiące", "złote", "grosze")
    III = ("bilionów", "miliardów", "milionów", "tysięcy", "złotych", "groszy")
    zl = int(kwota)
    gr = round((kwota - zl)*100)
    
    if zl > 999999999999999:
        raise ValueError("Kwota jest zbyt duża. Podaj mniejszą.")


    sety = zl%1000
    tys = (zl//1000)%1000
    mln = (zl//1000000)%1000
    mld = (zl//1000000000)%1000
    bln = (zl//1000000000000)%1000
    tr = [(bln),(mld),(mln),(tys),(sety),(gr)]
    slowa = []
    for i in range(len(tr)):
        jedn = tr[i]%10
        dzies = (tr[i]//10)%10

        slowa.append(SETY[tr[i]//100])
        if dzies == 1:
            slowa.append(NAST[jedn])
        if dzies != 1:
            slowa.append(DZIES[dzies])
            slowa.append(JEDN[jedn])

        if tr[i] == 0:
            continue
        elif tr[i] == 1:
            slowa.append(I[i])
        elif dzies != 1 and 2 <= jedn < 5:
            slowa.append(II[i])
        else:
            slowa.append(III[i])

    return ' '.join(' '.join(slowa).split())


kwota = float(input('Wprowadź kwotę: '))
print(kwota_slownie(kwota))


