{%macro multiply(first, second , precision)%}
round({{first }}*{{ second}},{{precision}})
{%endmacro%}