CREATE OR REPLACE FUNCTION number_to_word(number integer)
RETURNS text AS $$
DECLARE
    ONES text[] := ARRAY['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
    TENS text[] := ARRAY['ten', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];
    TEENS text[] := ARRAY['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
    HUNDS text[] := ARRAY['trillion', 'billion', 'million', 'thousand'];
  
    hund integer := number%1000;
    thous integer := div(number,1000)%1000;
    mln integer := div(number,1000000)%1000;
    bln integer := div(number,1000000000)%1000;
    trl integer := div(number,1000000000000)%1000;
    tr integer [] := ARRAY[trl, bln, mln, thous, hund];
    words text [];
    one integer;
    ten integer;
    hun integer;

BEGIN
    FOR i IN 1..(array_length(tr, 1))

    LOOP
        one := tr[i]%10;
        ten := (div(tr[i], 10))%10;
        hun := (div(tr[i], 100));

        
        IF hun > 0 THEN 
            words := array_append(words, (ONES[hun] || ' hundred'));
        END IF;
        IF ten = 1 THEN
            words := array_append(words, (TEENS[one]));
        END IF;        
        IF ten <> 1 THEN
            words := array_append(words, (TENS[ten]));
            words := array_append(words, (ONES[one]));
        END IF;
        IF one > 0 THEN
            words := array_append(words, (HUNDS[i]));
        END IF;

    END LOOP;
    RETURN array_to_string(words, ' ');
END;
$$ LANGUAGE plpgsql IMMUTABLE;

