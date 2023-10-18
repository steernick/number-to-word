CREATE OR REPLACE FUNCTION number_to_word(number numeric(16, 3))
RETURNS text AS $$
DECLARE
    ONES text[] := ARRAY['один', 'два', 'три', 'четыре', 
                'пять', 'шесть', 'семь', 'восемь', 'девять'];
    TENS text[] := ARRAY['десять', 'двадцать', 'тридцать',
            'сорок', 'пятьдесят', 'шестьдесят',
            'семьдесят', 'восемьдесят', 'девяноста'];
    TEENS text[] := ARRAY['десять', 'одиннадцать', 'двенадцать', 'тринадцать',
            'четырнадцать', 'пятнадцать', 'шестнадцать', 'семнадцать',
            'восемнадцать', 'девятнадцать'];
    HUNDS text[] := ARRAY['сто', 'двести', 'триста', 'четыреста',
            'пятьсот', 'шестьсот', 'семьсот', 'восемьсот',
            'девятьсот'];
    END1 text[] := ARRAY['биллион', 'миллиард', 'миллион', 'тысяча'];
    END2 text[] := ARRAY['биллиона', 'миллиарда', 'миллиона', 'тысячи'];
    END3 text[] := ARRAY['биллионов', 'миллиардов', 'миллионов', 'тысячи'];

    hund integer := div(number, 1)%1000;
    thous integer := div(number,1000)%1000;
    mln integer := div(number,1000000)%1000;
    bln integer := div(number,1000000000)%1000;
    trl integer := div(number,1000000000000)%1000;
    flt integer := div(number,0.001)%1000;
    fltstr text := rtrim(split_part(to_char((number%1), '0.000'), '.', 2), '0');
    tr integer [] := ARRAY[trl, bln, mln, thous, hund];
    words text [];
    word text;
    one integer;
    ten integer;

BEGIN
    IF number >= 1 THEN

        FOR i IN 1..(array_length(tr, 1))

        LOOP
            IF tr[i] <> 0 THEN
                one := tr[i]%10;
                ten := (div(tr[i], 10))%10;
                words := array_append(words, (HUNDS[(div(tr[i], 100))]));
                IF ten = 1 THEN
                    words := array_append(words, (TEENS[one+1]));
                END IF;        
                IF ten <> 1 THEN
                    words := array_append(words, (TENS[ten]));
                    words := array_append(words, (ONES[one]));
                END IF;
                IF tr[i] = 1 THEN
                    words := array_append(words, (END1[i]));
                ELSIF tr[i] > 1 AND one > 1 AND one < 5 AND ten > 1 THEN
                    words := array_append(words, (END2[i]));
                ELSE
                    words := array_append(words, (END3[i]));
                END IF;
            END IF;

        END LOOP;

    ELSE
        words := array_append(words, 'нуль');
    END IF;

    IF flt > 0 THEN
        IF flt%100 = 0 AND flt%10 = 0 THEN
        flt := flt/100;
        END IF;    
        IF flt%10 = 0 THEN
        flt := flt/10;
        END IF;  
        one := flt%10;
        ten := (div(flt, 10))%10;
        hund := (div(flt, 100));
        words := array_append(words, 'и');
        words := array_append(words, (HUNDS[hund]));
        IF ten = 1 THEN
            words := array_append(words, (TEENS[one+1]));
        END IF;        
        IF ten <> 1 THEN
            words := array_append(words, (TENS[ten]));
            words := array_append(words, (ONES[one]));
        END IF;
        IF length(fltstr) = 1 THEN
            words := array_append(words, 'десятых');
        ELSIF length(fltstr) = 2  THEN
            words := array_append(words, 'сотых');
        ELSE
            words := array_append(words, 'тысячных');
        END IF;
    END IF;

    word := array_to_string(words, ' ');

    IF word ~ 'один тысячи' THEN
    word := REGEXP_REPLACE(word, 'один тысячи', 'одна тысяча');
    END IF;
    IF word ~ 'один тысяча' THEN
    word := REGEXP_REPLACE(word, 'один тысяча', 'одна тысяча');
    END IF;
    IF word ~ 'два тысячи' THEN
    word := REGEXP_REPLACE(word, 'два тысячи', 'две тысячи');
    END IF;
    
    IF flt = 1 OR flt = 01 OR flt = 001 THEN
        word := REGEXP_REPLACE(word, 'один десятых', 'одна десятая');
        word := REGEXP_REPLACE(word, 'один сотых', 'одна сотая');
        word := REGEXP_REPLACE(word, 'один тысячных', 'одна тысячная');
    END IF;
    RETURN word;

END;
$$ LANGUAGE plpgsql IMMUTABLE;
