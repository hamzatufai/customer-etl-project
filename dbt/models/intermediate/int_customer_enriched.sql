with customer_base as (
    select * from {{ ref('stg_customers') }}
),

customer_enriched as (
    select
        customer_id,
        name_prefix,
        first_name,
        last_name,
        full_name,
        birth_date,
        datediff(year, birth_date, current_date()) as age,
        case
            when datediff(year, birth_date, current_date()) < 18 then 'Under 18'
            when datediff(year, birth_date, current_date()) between 18 and 25 then '18-25'
            when datediff(year, birth_date, current_date()) between 26 and 35 then '26-35'
            when datediff(year, birth_date, current_date()) between 36 and 50 then '36-50'
            when datediff(year, birth_date, current_date()) between 51 and 65 then '51-65'
            else '65+'
        end as age_group,
        marital_status,
        marital_status_desc,
        gender,
        gender_desc,
        email_address,
        annual_income,
        case
            when annual_income < 30000 then 'Low Income'
            when annual_income between 30000 and 60000 then 'Middle Income'
            when annual_income between 60001 and 100000 then 'Upper Middle Income'
            else 'High Income'
        end as income_bracket,
        total_children,
        education_level,
        occupation,
        home_owner_flag,
        is_home_owner,
        _loaded_at
    from customer_base
)

select * from customer_enriched
