def number_to_word(number):

    ONE = ("", "one", "two", "three", "four", "five",
            "six", "seven", "eight", "nine")
    TEN = ("", "ten", "twenty", "thirty",
            "forty", "fifty", "sixty",
            "seventy", "eighty", "ninety")
    TEEN = ("ten", "eleven", "twelve", "thirteen",
            "fourteen", "fifteen", "sixteen", "seventeen",
            "eighteen", "nineteen")
    REST = ("trillion", "billion", "million", "thousand", "")
  
    no = int(number)
    
    if no > 999999999999999:
        raise ValueError("Your number is too big. Try again.")


    hund = no%1000
    thous = (no//1000)%1000
    mln = (no//1000000)%1000
    bln = (no//1000000000)%1000
    trl = (no//1000000000000)%1000
    l = [trl,bln,mln,thous,hund]
    words = []
    for i in range(len(l)):
        one = l[i]%10
        ten = (l[i]//10)%10
        hun = l[i]//100

        if hun > 0:
            words.append(ONE[hun] + " hundred")
        if ten == 1:
            words.append(TEEN[one])
        if ten != 1:
            words.append(TEN[ten])
            words.append(ONE[one])
        if one > 0:
            words.append(REST[i])

    return ' '.join(' '.join(words).split())

amount = float(input('Please, enter your amount: '))
print(number_to_word(int(amount)))