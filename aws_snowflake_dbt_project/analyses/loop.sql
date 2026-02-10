{%set cols = ['BOOKING_ID ', 'BOOKING_DATE', 'BOOKING_AMOUNT']%}
select 
{%for col in cols %}
{{col}}
{%if not loop.last %},{%endif%}
{%endfor%}
from {{ref('bronze_bookings')}}

