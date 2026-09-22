with enriched_customers as (
    select * from {{ ref('int_customer_enriched') }}
),

customer_metrics as (
    select
        customer_id,
        name_prefix,
        first_name,
        last_name,
        full_name,
        email_address,
        birth_date,
        age,
        age_group,
        gender,
        gender_desc,
        marital_status,
        marital_status_desc,
        annual_income,
        income_bracket,
        total_children,
        education_level,
        occupation,
        is_home_owner,
        case
            when is_home_owner = true and total_children > 0 then 'Family Homeowner'
            when is_home_owner = true and total_children = 0 then 'Individual Homeowner'
            when is_home_owner = false and total_children > 0 then 'Family Renter'
            else 'Individual Renter'
        end as customer_segment,
        _loaded_at as dbt_loaded_at,
        current_timestamp() as dbt_updated_at
    from enriched_customers
)

select * from customer_metrics
