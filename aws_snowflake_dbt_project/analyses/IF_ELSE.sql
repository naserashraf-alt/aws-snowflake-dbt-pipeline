{% set name  = 'dev' %}



{% if name == 'dev' %}
    select * from {{ ref('bronze_listings') }}
{% else %}
    select * from {{ ref('bronze_bookings') }}
{% endif %}